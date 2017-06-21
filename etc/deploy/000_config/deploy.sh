#!/bin/bash
set -eu

# ライブラリスクリプトを読み込む
. ${DOTBASH?"export DOTBASH=~/dotbash"}/bin/lib/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は ~/.bashrc の設定を行うスクリプトである。
  - ~/.bashrc に以下のファイルの内容を追記する
    - ${DOTBASH}/etc/deploy/000_config/bashrc
  - ~/.bashrc にある "# dotbash settings" と記述された行以降を上記ファイルで置き換えるようになっている
  - "# dotbash settings" よりも上の行は置き換わらないため、必要な設定はそこに記述しておくこと

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

temp_file=~/.$(basename ${0}).temp
bashrc=~/.bashrc
# ~/.bashrc から sed を使って必要な設定を切り出す開始行
from_row=1
# ~/.bashrc から sed を使って必要な設定を切り出す終了行
# デフォルトは ~/.bashrc の最終行
to_row=$(awk 'END{print NR}' ${bashrc})

# ~/.bashrc から設定を切り出すための範囲を決める
# ~/.bashrc に "# dotbash settings" と記述された行が存在する場合は、その上の行までが範囲
# 記述された行が存在しない場合はファイル全体
$(grep -q 'dotbash settings' ${bashrc}) && {
  to_row=$(grep -n 'dotbash settings' ${bashrc} | awk -F: '{print $1}')
  to_row=$(expr $to_row - 1)
}

# テンポラリファイルに設定を切り出して、そこに設定を追記する
{
  sed -n ${from_row},${to_row}p ${bashrc}
  cat ${DOTBASH}/etc/deploy/000_config/bashrc
} > $temp_file

# dry-run の場合はテンポラリファイルを cat で出力した後に削除する
if [ ! -z ${dryrun} ]; then
  cat $temp_file
  rm $temp_file
# dry-run ではない場合はテンポラリファイルを ~/.bashrc にリネームする
else
  mv $temp_file ${bashrc}
fi

exit 0
