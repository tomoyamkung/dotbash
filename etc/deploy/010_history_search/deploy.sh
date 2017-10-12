#!/bin/bash
set -eu

# ライブラリスクリプトを読み込む
. ${DOTBASH?"export DOTBASH=~/dotbash"}/bin/lib/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は Ctrl+s に割り当たっているキーバインドを解除するスクリプトである。
  Crtl+s は通常「ターミナルのロック」に割り当たっているが、この割り当てを解除して、コマンド履歴を「過去から最新の方向に」検索するために割り当てることを目的とする。

Usage:
  $(basename ${0}) [-h] [-x]

Options:
  -h print this
  -x dry-run モードで実行する
EOF
  exit 0
}

while getopts hx OPT
do
  case "$OPT" in
    h) usage ;;
    x) enable_dryrun ;;
    \?) usage ;;
  esac
done

# Ctrl+s の割り当てが「ターミナルのロック」になっていれば、それを解除する
$(stty -a | grep -q "stop = ^S") && {
  ${dryrun} stty stop undef
}

exit 0
