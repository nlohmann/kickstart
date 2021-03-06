all:
	@echo "install"
	@echo "check"
	@echo "packages"
	@echo "update"
	@echo "uninstall"

install: homebrew_install haskell_install python_install cask_install tex_install quartz_install ruby_install
check: homebrew_check haskell_check cask_check
update: osx_update homebrew_update haskell_update python_update tex_update ruby_update
packages: install homebrew_packages haskell_packages python_packages cask_packages ruby_packages
uninstall: haskell_uninstall python_uninstall cask_uninstall homebrew_uninstall tex_uninstall quartz_uninstall ruby_uninstall


##########################################################################
# OSX
##########################################################################

osx_update:
	sudo softwareupdate --verbose --install --all


##########################################################################
# HOMEBREW
##########################################################################

homebrew_install:
	ruby -e "$$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
	touch homebrew_install

homebrew_packages: homebrew_install
	# bash
	brew install bash
	brew install bash-completion
	brew install fortune
	# developing
	brew install ant
	brew install apple-gcc42
	brew install astyle
	brew install autoconf
	brew install automake
	brew install bison
	brew install cppcheck
	brew install doxygen
	brew install ffmpeg
	brew install figlet
	brew install flex
	brew install gengetopt
	brew install git
	brew install gnu-sed
	brew install gource
	brew install graphviz
	brew install help2man
	brew install kimwitu++
	brew install lcov
	brew install lua
	brew install mercurial
	brew install mtr
	brew install node
	brew install pkg-config
	brew install ruby
	brew install subversion
	brew install texi2html
	brew install texinfo
	brew install vim
	brew install wget
	brew install xz
	## shell colors
	brew install colorsvn
	brew install grc
	# network
	brew install nmap
	## htop
	brew install htop
	sudo chown root:wheel /usr/local/Cellar/htop-osx/*/bin/htop
	sudo chmod u+s /usr/local/Cellar/htop-osx/*/bin/htop
	# graphics
	brew install svg2pdf
	brew install webkit2png
	brew install imagemagick
	# misc
	brew install sl
	brew install tree
	# backup
	brew install duplicity

homebrew_check: homebrew_install
	-brew doctor

homebrew_update: homebrew_install
	brew update
	brew upgrade
	-brew cleanup

homebrew_uninstall:
	cd `brew --prefix` ; rm -rf Cellar Library/Homebrew Library/Aliases Library/Formula Library/Contributions .git
	-brew prune
	rm -rf ~/Library/Caches/Homebrew
	rm -f homebrew_install


##########################################################################
# HOMEBREW CASK
##########################################################################

cask_install: homebrew_install
	brew tap phinze/homebrew-cask
	brew install brew-cask
	touch cask_install

cask_packages: cask_install
	-brew cask install adium
	-brew cask install base
	-brew cask install bettertouchtool
	-brew cask install chromium
	-brew cask install cyberduck
	-brew cask install cleanmymac
	-brew cask install controlplane
	-brew cask install dash
	-brew cask install delicious-library
	-brew cask install dropbox
	-brew cask install evernote
	-brew cask install f-lux
	-brew cask install fake
	-brew cask install firefox
	-brew cask install github
	-brew cask install instacast
	-brew cask install istumbler
	-brew cask install little-snitch
	-brew cask install mplayer-osx-extended
	-brew cask install skype
	-brew cask install superduper
	-brew cask install tapaal
	-brew cask install textmate
	-brew cask install tor-browser
	-brew cask install the-unarchiver
	-brew cask install things
	-brew cask install transmission
	-brew cask install virtualbox
	-brew cask install vlc

cask_check: cask_install
	brew cask checklinks `brew cask list`

cask_uninstall:
	-brew cask uninstall `brew cask list`
	brew untap phinze/homebrew-cask
	brew uninstall brew-cask
	sudo rm -fr /opt/homebrew-cask
	rm -f cask_install


##########################################################################
# HASKELL / CABAL
##########################################################################

haskell_install: homebrew_install
	brew install haskell-platform
	touch haskell_install

haskell_packages: haskell_install
	cabal install pandoc

haskell_check: haskell_install
	ghc-pkg check

haskell_update: haskell_install
	cabal update

haskell_uninstall:
	-brew uninstall haskell-platform
	rm -f haskell_install


##########################################################################
# PYTHON / PIP
##########################################################################

python_install: homebrew_install
	brew install python
	brew install python3
	touch python_install

python_packages: python_install
	sudo pip install httpie
	sudo pip install virtualenv
	# CouchDB
	sudo pip install couchdb
	sudo pip install iso8601
	# -> ~/Library/Application Support/CouchDB/etc/couchdb/local.ini
	# -> section "[query_servers]"
	# python = /usr/local/bin/couchpy

python_update: python_install
	sudo pip install --upgrade setuptools
	sudo pip install --upgrade pip
	-sudo pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs sudo pip install -U

python_uninstall:
	sudo pip freeze | xargs sudo pip uninstall -y
	brew uninstall python
	brew uninstall python3
	rm -f python_install


##########################################################################
# MACTEX
##########################################################################

tex_install:
	wget http://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg
	sudo installer -verbose -pkg MacTeX.pkg -target /
	rm MacTeX.pkg
	touch tex_install

tex_update: tex_install
	sudo tlmgr update --self
	sudo tlmgr update --all

tex_uninstall:
	sudo mv /usr/local/texlive ~/.Trash
	sudo mv /Applications/TeX ~/.Trash
	rm -f tex_install


##########################################################################
# QUARTZ
##########################################################################

quartz_install:
	wget http://xquartz.macosforge.org/downloads/SL/XQuartz-2.7.5.dmg
	hdiutil mount XQuartz-2.7.5.dmg
	sudo installer -verbose -pkg /Volumes/XQuartz-2.7.5/XQuartz.pkg -target /
	hdiutil unmount /Volumes/XQuartz-2.7.5
	rm XQuartz-2.7.5.dmg
	touch quartz_install

quartz_uninstall:
	launchctl unload /Library/LaunchAgents/org.macosforge.xquartz.startx.plist
	sudo launchctl unload /Library/LaunchDaemons/org.macosforge.xquartz.privileged_startx.plist
	sudo rm -rf /opt/X11* /Library/Launch*/org.macosforge.xquartz.* /Applications/Utilities/XQuartz.app /etc/*paths.d/*XQuartz
	sudo pkgutil --forget org.macosforge.xquartz.pkg
	rm -f quartz_install


##########################################################################
# RUBY
##########################################################################

ruby_install:
	touch ruby_install

ruby_packages: ruby_install
	# blog
	sudo gem install jekyll
	sudo gem install kramdown

ruby_update: ruby_install
	sudo gem update --system
	sudo gem update `gem list | cut -d ' ' -f 1`
	sudo gem cleanup

ruby_uninstall:
	for i in `gem list --no-versions`; do sudo gem uninstall -aIx $$i; done
	rm -f ruby_install
