xrdb ~/.Xresources &
xset r rate 200 50 &
xrandr --output DP-4 --mode 2560x1600 --rate 165 &
clipmenud &
picom --config ~/.config/picom/picom.conf &
slstatus &
firefox &
kitty &
exec dwm
