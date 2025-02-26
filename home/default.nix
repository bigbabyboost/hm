{ lib, ... }:
let
  folder = builtins.path { path = ./.; };

  # Recursive function to collect all .nix files (excluding default.nix)
  collectNixFiles = dir:
    let
      dirStr = toString dir;  # Convert path to string for manipulation
      contents = builtins.readDir dir;  # Read current directory
      processEntry = name: type:
        let
          fullPath = dirStr + "/" + name;  # Full path as string
        in
          if type == "directory" then
            # Recurse into subdirectories
            collectNixFiles (builtins.path { path = fullPath; })
          else if type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" then
            # Add valid .nix files to the list
            [ (builtins.path { path = fullPath; }) ]
          else
            [];  # Ignore non-.nix files
      # Process all entries and flatten the results
      processed = lib.mapAttrsToList processEntry contents;
    in
      lib.concatLists processed;

  # Collect all .nix files recursively
  imports = collectNixFiles folder;
in {
  inherit imports;
}
