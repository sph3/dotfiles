#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/dwm/scripts/bar_themes/catppuccin

DATA="$HOME/.local/share/dunspotify/currentSong"

spotify() {
  is_running=$(pgrep -x spotify >/dev/null && echo "Process found" || echo "Process not found")
  if [ "$is_running" = "Process found" ]; then
    artist="$(cat $DATA | grep "artist" | cut -d'|' -f2)"
    title="$(cat $DATA | grep "songTitle" | cut -d'|' -f2)"
    printf "^c$black^ ^b$green^ "
    printf "^c$white^ ^b$grey^ $title - $artist ^b$black^"
  else
    echo ""
  fi
}

get_volume(){
  curStatus=$(pactl get-sink-mute @DEFAULT_SINK@)
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | tail -n 2 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' | head -n 1)

  if [ "${curStatus}" = 'Mute: yes' ]
  then
      printf "^c$black^ ^b$mauve^ 婢"
      printf "^c$white^ ^b$grey^ $volume%% (Muted)"
  else
      printf "^c$black^ ^b$mauve^ 墳"
      printf "^c$white^ ^b$grey^ $volume%%"
  fi
}

pkg_updates() {
  # updates=$(doas xbps-install -un | wc -l) # void
  updates=$(pacman -Qu | wc -l) # arch, needs pacman contrib
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [[ "$updates" == 0 ]]; then
    printf "^b$black^ ^c$green^  Updated"
  else
    if [[ "$updates" == 1 ]]; then
      printf "^b$black^ ^c$green^  $updates"" update"
    else
      printf "^b$black^ ^c$green^  $updates"" updates"
    fi
  fi
}

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

mem() {
  printf "^c$mauve^^b$black^  "
  printf "^c$mauve^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%a %d %b %H:%M') "
  printf "^b$black^"
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(spotify) $(get_volume) $updates $(cpu) $(mem) $(clock)"
done
