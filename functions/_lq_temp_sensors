_lq_temp_sensors() {
    # Return the average system temperature we get through the sensors command
    local count=0
    local temperature=0
    for i in $(sensors | grep -E "^(Core|temp)" |
            sed $LQ_EXTENDED_RE "s/.*: *\+([0-9]*)\..°.*/\1/g"); do
        temperature=$(($temperature+$i))
        count=$(($count+1))
    done
    echo -ne "$(($temperature/$count))"
}

