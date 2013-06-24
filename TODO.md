TODO
====

Items
-----

* Move liquid.zsh to functuions/lq\_init
* Rename functions/ to Liquid/
* zcompile Liquid/
* Installer copy Liquid (and newly compliled Liquid.zwc) to somewhere in $fpath
* Instructions to add autoload -U lq\_init; lq\_init
* User to update PS1? Let user pick and choose?
* Should define only those functions available
* lq\_init should be able to pick up changes
    * eg: svn just installed, lq\_svn\_* enabled upon lq\_init
* lq\_reload to enhance the above?
* all functions should be canonicalised
    * loaded,
    * functions func > func
    * comments readded
    * might break some spacing
* indentions will be 8 instead of 4, but that will be okay
* Verify lowest version of zsh usable



Thoughts and Ideas
------------------

* Use precmd hooks?
* Take over PS1 entirely> eg: `PS1="$(lq_prompt)"` (or simimar)

