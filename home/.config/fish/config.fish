source /usr/share/cachyos-fish-config/cachyos-config.fish

if status is-interactive
    ~/.local/bin/mise activate fish | source
else
    ~/.local/bin/mise activate fish --shims | source
    fish_add_path --global --move --path ~/.local/share/vite-plus/bin
end
