# Remove all colors and escape characters of the given string and return a pure text
_lq_as_text()
{
    # Remove non-printing escape sequences from the prompt
    # embedded %'s will break this, however I am unaware of any ANSI escape
    # codes that have a % in them

    echo -n "$( echo -n "$1" | sed 's/%{[^%]*%}//g' )"
}

