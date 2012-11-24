_subr() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  words=("${COMP_WORDS[@]:1:COMP_CWORD-1}")

  local completions="$(subr completions "${words[@]}")"
  COMPREPLY=( $(compgen -W "$completions" -- "$word") )

}

complete -F _subr subr
