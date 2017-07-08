# startx at login
#### [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
#
#pulseaudio daemon
# pulseaudio --start &
# 

if [[ $XDG_VTNR -eq 1 ]] ; then
   	exec startx
fi

