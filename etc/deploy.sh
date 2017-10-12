#!/bin/bash
set -eu

# ライブラリスクリプトを読み込む
. ${DOTBASH?"export DOTBASH=~/dotbash"}/bin/lib/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は etc/deploy/**/deploy.sh を一括して実行するスクリプトである。

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

find ${DOTBASH}/etc/deploy -name "deploy.sh" | sort | xargs -i ${dryrun} sh {}

exit 0
