#!/bin/sh

# Fix cursor
xsetroot -cursor_name left_ptr

# Polkit agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Enable power management
xfce4-power-manager &

# Restore wallpaper
# hsetroot -cover /usr/share/archcraft/dwm/wallpapers/default.png

# Enable super key for menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Set keyboard layout and toggle key
setxkbmap -model pc104 -layout us,us -variant alt-intl, -option grp:win_space_toggle &

# Keyboard repeat rate and delay
xset r rate 250 32 &

xrdb merge ~/.Xresources

# Keybind daemon
sxhkd &

# Lauch notification daemon
dunst -config $HOME/.config/dunst/dunstrc &

# Wallpaper
feh --bg-fill $HOME/Pictures/Wallpapers/646.jpg &

# Picom
picom --config $HOME/.config/picom/picom.conf --experimental-backends &

# Dwm bar
$HOME/dwm/scripts/bar.sh &

# Launch programs
easyeffects &
copyq &
thunar --daemon &

xbanish &

while type dwm >/dev/null; do dwm && continue || break; done
