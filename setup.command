#!/bin/bash
#Download and install nodejs - requires password
#curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"

#Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#Use Homebrew to get latest node
brew update
export PATH="/usr/local/bin:$PATH"
brew install node

#Fixing npm permission
if ["$(npm config get prefix)" -ne "/usr"]; then
	sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}
else
	echo "Setting up local account."	
	mkdir ~/.npm-global
	npm config set prefix '~/.npm-global'
	NPM=~/.npm-global/bin
fi
#Sublime installation - version 2.0.2
mkdir /Volumes/mnt
curl -O  http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.dmg

if hdiutil  attach -mountpoint /Volumes/mnt Sublime%20Text%202.0.2.dmg; then
	cp -r /Volumes/mnt/Sublime\ Text\ 2.app /Applications/

	hdiutil detach /Volumes/mnt
	rm Sublime%20Text%202.0.2.dmg

	mkdir ~/bin
	BIN=~/bin

	ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/bin/subl
else
	echo "Sublime mount failed"
fi

#SET PATH
if [ -z $NPM ]; then 
	echo "npm path is not set"
else
	echo "npm path set succesfully"
fi
if [ -z $BIN ]; then
	echo "subl not set"
else
	echo "subl command set"
fi

# '>>' output just in case there is something in the profile
printf "export PATH=%s:%s:$PATH" $NPM $BIN >> ~/.bash_profile
source ~/.bash_profile

#Github Desktop install
#curl -O https://mac-installer.github.com/mac/GitHub%20Desktop%20216.zip
#unzip GitHub%20Desktop%20216.eip
brew install wget
wget --content-disposition -E -c https://central.github.com/mac/latest -O githubInstaller.zip
unzip githubInstaller.zip

echo "Launching Github Installer"
open "GitHub Desktop.app"
