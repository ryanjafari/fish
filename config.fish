#!/usr/bin/env fish

# TODO: make ~/.config/fish a workspace?
# TODO: check permissions on and under ~/.config/fish
# TODO: version ~/.config/fish with GitHub

# Get the current OS:
set -g os (get_os)

if status is-interactive
    printf %b "=> Setting up 🐟 for: $os\n"

    source ~/.config/fish/environment/environment.fish
    source ~/.config/fish/environment/environment_$os.fish
    source ~/.config/fish/ffunctions/ffunctions.fish
    source ~/.config/fish/ffunctions/ffunctions_$os.fish
    source ~/.config/fish/commands/commands.fish
    source ~/.config/fish/commands/commands_$os.fish
    source ~/.config/fish/prompt.fish
    source ~/.config/fish/aliases.fish
    # TODO: source ~/.config/fish/abbreviations.fish
    # SEE: https://bit.ly/3qIzMUE

    printf %b "=> Done: setting up for $os\n"
else
    source ~/.config/fish/environment/environment.fish
    source ~/.config/fish/environment/environment_$os.fish
    source ~/.config/fish/ffunctions/ffunctions.fish
    source ~/.config/fish/ffunctions/ffunctions_$os.fish
    source ~/.config/fish/commands/commands.fish
    source ~/.config/fish/commands/commands_$os.fish
    source ~/.config/fish/prompt.fish
    source ~/.config/fish/aliases.fish
    # TODO: source ~/.config/fish/abbreviations.fish
    # SEE: https://bit.ly/3qIzMUE
end
