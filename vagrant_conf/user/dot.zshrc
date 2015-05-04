# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ysrz"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

## command aliases
alias ll='ls -lh'
alias rmpyc='find . -name "*.pyc" -delete'
alias pygrep='grep -Rn --include="*.py" --exclude="*.pyc"'

alias devcelery='foreman start worker --procfile=Procfile.dev'
alias devserver='foreman start web --procfile=Procfile.dev'

alias manage.py='foreman run python manage.py'

alias devshell='foreman run python {{ project_name }}/manage.py shell_plus'
alias devdb='foreman run python {{ project_name }}/manage.py dbshell'
alias migrate='manage.py migrate'
alias resetdb="dropdb {{ project_name }}-dev && createdb {{ project_name }}-dev && manage.py syncdb && manage.py migrate"
alias runtest='foreman run --env env.test python manage.py test'
alias runtests='foreman run --env env.test python manage.py runtests'

alias prodshell='heroku run python manage.py shell_plus'
alias proddb='heroku pg:psql'


## command specific history search
### emacs bindings
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
### vim bindings
bindkey -a k history-beginning-search-backward
bindkey -a j history-beginning-search-forward

## activate vi-mode with annoying emacs brethren
alias vimode='source $ZSH/plugins/vi-mode/vi-mode.plugin.zsh'

## man page color and search hilighting
export PAGER="less"
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
export PYTHONPATH='/home/vagrant/{{ project_name }}/{{ project_name }}/'

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

workon {{ project_name }}
cd {{ project_name }}
