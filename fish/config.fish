# Commands to run in interactive sessions can go here
if status is-interactive
    # No greeting
    set fish_greeting
    # Aliases
    # kitty doesn't clear properly so we need to do this weird printing
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    alias pamcan pacman
    alias q 'qs -c ii'
    if test "$TERM" = "xterm-kitty"
        alias ssh 'kitten ssh'
    end
end

if status is-interactive
# Commands to run in interactive sessions can go here
end
