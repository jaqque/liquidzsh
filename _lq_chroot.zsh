# Put the hostname if not locally connected
# color it in cyan within SSH, and a warning red if within telnet
# else diplay the host without color
# The connection is not expected to change from inside the shell, so we
# build this just once
LQ_HOST=""
_lq_chroot()
{
    if [[ -r /etc/debian_chroot ]] ; then
        local debchroot
        debchroot=$(cat /etc/debian_chroot)
        echo "(${debchroot})"
    fi
}
LQ_HOST="$(_lq_chroot)"
unset _lq_chroot

