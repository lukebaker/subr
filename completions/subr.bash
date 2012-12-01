_subr() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  execbasename=`basename ${COMP_WORDS[0]}`
  words=("${COMP_WORDS[@]:1:COMP_CWORD-1}")

  local completions="$($execbasename completions "${words[@]}")"
  COMPREPLY=( $(compgen -W "$completions" -- "$word") )

}

_subr_find_shortcuts() {
  # find any executable files in the same directory as the subr binary
  # that export _SUBR_SUB_COMMAND and add tab completion for them
  local subr_path=$(command -v "subr" || true)
  if [ -e "$subr_path" ]; then
    local subr_dir=$(dirname $subr_path)
    for file in $subr_dir/*; do
      if [ -x $file ]; then
        local is_sub=$(grep "export _SUBR_SUB_COMMAND" $file)
        if [ -n "$is_sub" ]; then
          local basenamef=`basename $file`
          complete -F _subr $basenamef
        fi
      fi
    done
  fi
}

complete -F _subr subr
_subr_find_shortcuts
