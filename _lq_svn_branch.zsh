# Get the branch name of the current directory
# For the first level of the repository, gives the repository name
_lq_svn_branch()
{
    [[ "$LP_ENABLE_SVN" != 1 ]] && return
    local root
    local url
    local result
    eval $(LANG=C LC_ALL=C svn info 2>/dev/null | sed -n 's/^URL: \(.*\)/url="\1"/p;s/^Repository Root: \(.*\)/root="\1"/p' )
    if [[ "$root" == "" ]]; then
        return
    fi
    # Make url relative to root
    url="${url:${#root}}"
    if [[ "$url" == */trunk* ]] ; then
        echo -n trunk
    else
        result=$(expr "$url" : '.*/branches/\([^/]*\)' || expr "$url" : '/\([^/]*\)' || basename "$root")
        echo -n $result # FIXME should be: echo -n $(_lq_escape "${result}")
    fi
}

