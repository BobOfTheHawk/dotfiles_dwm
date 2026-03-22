/usr/lib/xdg-desktop-portal-gtk &
xrdb ~/.Xresources

# key repeat delay and rate
xset r rate 300 30

# monitor setup
xrandr --output DP-4 --mode 2560x1600 --rate 165

export CLIPMENU_DMENU_OPTS="-l 10 -fn monospace:size=14"
clipmenud &
picom --config ~/.config/picom/picom.conf &
slstatus &
lxpolkit &
qutebrowser &
exec dwm
