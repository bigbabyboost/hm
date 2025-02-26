# fish configurations
{ pkgs, ... }: {

  programs.fish = {
    enable = true;
    package = pkgs.fish;
    interactiveShellInit = ''
      # === Environment Variables ===

      # Ensure $HOME/.local/bin is in PATH
      if not contains -- $HOME/.local/bin $PATH
          set -gx PATH $HOME/.local/bin $HOME/bin $PATH
      end

      # === Custom Fish Greeting ===
      function fish_greeting
          # Get current hour and date in one call
          set -l datetime (date "+%H %A, %B %d %H:%M")
          set -l hour (string split ' ' $datetime)[1]
          set -l current_datetime (string join ' ' (string split ' ' $datetime)[2..])

          # Determine greeting based on time
          set -l greeting
          if test $hour -ge 5 -a $hour -lt 12
              set greeting "Good morning"
          else if test $hour -ge 12 -a $hour -lt 18
              set greeting "Good afternoon"
          else
              set greeting "Good evening"
          end

          # Colors
          set -l c_greeting (set_color --bold yellow)
          set -l c_user (set_color cyan)
          set -l c_date (set_color green)
          set -l c_reset (set_color normal)
          set -l fish_symbol (set_color brblue)"<><"$c_reset

          # Output greeting
          echo "$c_greeting$greeting,$c_reset $c_user$USER$c_reset! Today is $c_date$current_datetime$c_reset $fish_symbol"
      end

      # Set fish_greeting as the default greeting function
      set -g fish_greeting fish_greeting
      
      # Override fish keybindings
      function fish_user_key_bindings
        bind --erase --preset \es
        bind \e\e 'for cmd in sudo doas please; if command -q $cmd; fish_commandline_prepend $cmd; break; end; end'
      end

      function fish_prompt --description 'Write out the prompt'
      set -l last_pipestatus $pipestatus
      set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
      set -l normal (set_color normal)
      set -q fish_color_status
      or set -g fish_color_status red

      # Color the prompt differently when we're root
      set -l color_cwd $fish_color_cwd
      set -l suffix '>'
      if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
      end

      # Write pipestatus
      # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
      set -l bold_flag --bold
      set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
      if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
      end
      set __fish_prompt_status_generation $status_generation
      set -l status_color (set_color $fish_color_status)
      set -l statusb_color (set_color $bold_flag $fish_color_status)
      set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

      echo -n -s (prompt_login)' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
      end

    '';
    shellAliases = {
      warpstat = "curl https://www.cloudflare.com/cdn-cgi/trace/";
    };
  };
}
