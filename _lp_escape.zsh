# Escape the given strings
# Must be used for all strings that may comes from remote sources,
# like VCS branch names
_lp_escape()
{
    printf "%q" "$*"
}

