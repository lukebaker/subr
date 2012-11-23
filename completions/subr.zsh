if [[ ! -o interactive ]]; then
    return
fi

compctl -K _subr subr

_subr() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(subr commands)"
  else
    completions="$(subr completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
