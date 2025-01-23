#!/bin/sh
conf_dir="$HOME/.config/hypr"
random_pick=$(find "$HOME/Pictures/wallpapers/" "$HOME/.config/.wallpapers/" -type f -name "*.png" -o -name "*.jpg" -o -name "*.JPEG" | shuf -n1)
sed -e "s~<wp>~${random_pick}~g" $conf_dir/hyprpaper.template > $conf_dir/hyprpaper.conf
