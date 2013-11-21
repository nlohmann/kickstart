# use bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# link casks to /Applications rather than ~/Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# use Textmate as SVN editor
export SVN_EDITOR="/usr/local/bin/mate -w"

# Tell ls to be colourful
export CLICOLOR=1

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# generic colorizer (see http://noiseandheat.com/blog/2011/12/os-x-lion-terminal-colours/)
source "`brew --prefix grc`/etc/grc.bashrc"

# set the homebrew folder as path
export PATH=/usr/local/bin:/usr/local/sbin:/opt/local/bin:$PATH

# use colorsvn
alias svn=colorsvn

# set prompt
export PS1="[\[\033[0;37m\]\w\[\033[0m\]] "

# set dir depth (don't forget to use a recent bash - http://stackoverflow.com/questions/16416195/how-do-i-upgrade-bash-in-mac-osx-mountain-lion-and-set-it-the-correct-path)
export PROMPT_DIRTRIM=2

# color ant output
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'

alias venv='source venv/bin/activate'
