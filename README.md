# dotbash

dotbash とは以下を実行するプロジェクトである。

- ~/.bashrc への設定追加


# セットアップ手順

セットアップ手順は以下の通り。

```
$ cd ~/
$ git clone https://github.com/tomoyamkung/dotbash.git
$ cd dotbash
$ export DOTBASH=~/dotbash
$ ./etc/deploy.sh  # 本プロジェクトが提供する機能を設定にする
$ . ~/.bashrc  # ~/.bashrc の設定を有効にする
```


# 提供機能

本プロジェクトが提供する機能は非常にシンプルであり、以下だけである。

- ~/.bashrc への設定追加


## ~/.bashrc への設定追加について

~/.bashrc には以下の内容が追記される（この内容は etc/deploy/000_config/bashrc に書かれている）。

```
# dotbash settings
## alias
alias less="less -XF"
alias ll='ls -al --time-style=long-iso --color=auto'

## history
# 保存する履歴の数を設定する
export HISTSIZE=10000
# 保存する履歴に時刻を残す
HISTTIMEFORMAT='%Y%m%d %T';
export HISTTIMEFORMAT
# 重複する履歴は保存しない
export HISTCONTROL=ignoreboth:erasedups
# 空白から始まるコマンドは保存しない
export HISTCONTROL=ignorespace
# 履歴に保存しないコマンドを設定する → fg, bg, date, jobs を対象外とする
export HISTIGNORE="fg*:bg*:date*:jobs*"
# コマンド履歴を共有する
function share_history {
  history -a
  tac ~/.bash_history | awk '!a[$0]++' | tac > ~/.bash_history.tmp
  mv ~/.bash_history{.tmp,}
  history -c
  history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend

```

~/.bashrc が環境に存在する場合は、先頭から "# dotbash settings" とある行までを残すようになっており、それ以下の行は上記の内容で上書きする。なので、残しておきたい設定は "# dotbash settings" よりも上に書いておくこと。


# 仕様・制限事項

本プロジェクトの全体的な仕様、および、制限事項は以下の通り。

- 本プロジェクトは CentOS で開発され CentOS 上での使用を想定しているため、基本的に CentOS 以外での使用は考慮していない
- Git は既に環境にインストールされている状態とする
- シェルは bash を対象とする

