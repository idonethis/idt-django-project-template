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

source /etc/bash_completion.d/virtualenvwrapper

alias ll='ls -lh'
alias rmpyc='find . -name "*.pyc" -delete'
alias pygrep='grep -Rn --include="*.py" --exclude="*.pyc"'
alias resetdb="dropdb {{ project_name }}-dev && createdb {{ project_name }}-dev && ./manage.py migrate"
alias devserver="foreman start -f Procfile.dev"
alias devshell="foreman run python {{ project_name }}/manage.py shell -f Procfile.dev"
alias test="./manage.py test"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

workon {{ project_name }}
cd {{ project_name }}
