#!/usr/bin/env fish

if status is-interactive
    printf %b "=> Running commands for Linux...\n"
    printf %b "=> Running fish_ssh_agent...\n"
    fish_ssh_agent # TODO: need this?
    printf %b "=> Done: fish_ssh_agent\n"
else
    fish_ssh_agent # TODO: need this?
end
