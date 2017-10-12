
function usage() {
  cat <<EOF 1>&2
Description:
  シェルスクリプトを dry-run で実行する際に使用する変数と関数を定義したライブラリ。

Usage:
  dry-run を実行するための手順は以下の通り。

  1. 本ライブラリを読み込む
    - . /path/to/dry_run.sh
  2. enable_dryrun() 関数を実行する
  3. dry-run を実行したい場所で if を実行する

  if の例は以下の通り。

  ----
  if [ ! -z ${dryrun} ]; then
    echo "dry-run"
  else
    echo "execute"
  fi
  ----

  変数 ${dryrun} には "echo" が格納される。
  以下のようにコーディングすることで dry-run が有効になった際には ls は実行されず echo が実行されるようになる。
  よって if で切り分けるのではなく下記のような書き方で dry-run することも可能。

  ----
  ${dryrun} ls
  ----
EOF
  exit 1
}

# dry-run をするかの判定に使用するフラグ
# この変数に何か値が設定されている場合は dry-run とする
# デフォルトはブランク、つまり、dry-run しない
dryrun=

# dry-run を有効にする関数
function enable_dryrun() {
  dryrun=echo
}
