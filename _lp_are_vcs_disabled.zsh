_lp_are_vcs_disabled()
{
    [[ -z "$LP_DISABLED_VCS_PATH" ]] && echo 0 && return
    local path
    local IFS=:
    for path in $LP_DISABLED_VCS_PATH; do
        if [[ "$PWD" == *"$path"* ]]; then
            echo 1
            return
        fi
    done
    echo 0
}

