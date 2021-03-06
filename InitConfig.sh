#!/bin/bash
## Florent DUFOUR
### My automated software installation after a clean install (for macOS Sierra)

#----------------------------------------------------------------
## Software to install:

declare -a brew=(
'cairo'
'ccat'
'duti'
'exiftool'
'ffmpeg'
'fish'
'groovysdk'
'hugin'
'hunspell'
'gcc'
'git'
'mas'
'maven'
'node'
'pandoc'
'pandoc-citeproc' # Because life is too short
'python3'
'trash'
'tree'
'youtube-dl')

declare -a cask=( # Some casks need it to be installed beforehand
'xquartz'         # Some casks rely on xquartz as a dependency: has to be first
'appcleaner'
'atom'
'boostnote'
'chromium'
'clipy'
'coconutbattery'
'cryptomator'
'dropbox'
'eclipse-ide'
'evernote'
'flux'
'font-latin-modern'
'font-open-sans'
'github'          # Formerly 'github-desktop'
#'goofy'
'gpg-suite'
'grammarly'
'iina'
'imagej'
'inkscape'
'intellij-idea-ce'
'iterm2'
'java8'
'mactex-no-gui'   # That's heavy!
'macvim'
'marp'
'meld'
'onyx'
'processing'      # Uh!
'rocket'
'scenebuilder'
'skype'
'spectacle'
'texstudio'
'touchbarserver'
'transmission'
'typora'
'wwdc'
'zotero'
'1password')

declare -a npm=(
'p5-manager')

declare -a apm=(
'atom-beautify'
'atom-live-server'
'autocomplete-java'
'close-on-left'   # Kind of a necessity...
'dark-flat-ui'
'emmet'
'highlight-column'# Change style for line: automatic color is 284b6f
'highlight-line'  # Change color to #284b6f
'highlight-selected'
'language-applescript'
'linter'
'linter-htmlhint'
'linter-javac'
'linter-jscs'
'linter-jshint'
'linter-jsonlint'
'linter-markdown'
'linter-shellcheck'
'linter-stylelint'
'linter-ui-default'
'minimap'
'outlander-syntax'
'p5xjs-autocomplete'
'todo-show'        #Yes!
'wordcount'
'zen')

declare -a mas=( # We prefer not to use `mas lucky`. The app id is more reliable.
'937984704'  # Amphetamine
'1229643033' # Am I online
'641027709'  # Color Picker
'1033480833' # Decompressor (Because someone will someday send you a .rar ...)
'409183694'  # Keynote
'576338668'  # Leaf
'715768417'  # Microsoft remote desktop
'409203825'  # Numbers
'409201541'  # Pages
'439654198') # Simple mind

declare -a pip=(
'cairosvg'
'jupyter'
'livereload'
'matplotlib'
'pandas')    # Comes along other useful libraries such as numpy

#----------------------------------------------------------------
## Install homebrew:

echo -e '\n\tINSTALLING HOMEBREW\n'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#----------------------------------------------------------------
## Setup:

echo -e '\n\tTAPPING\n'
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

#----------------------------------------------------------------
## Loop through the installs:

echo -e '\n\tMESSING WITH INSTALLS\n'

# Install casks first (some brews may rely on casks. ex: maven needs java7+ to be installed beforehand)

for c in "${cask[@]}"
do
    echo -e "> Installing cask $c \n"
    brew cask install "$c";
done

# Install brews

for b in "${brew[@]}"
do
    echo -e "> Installing brew: $b \n"
    brew install "$b";
done

# Install node packages

for n in "${npm[@]}"
do
    echo -e "> Installing node $n "
    sudo npm install -g "$n"
done

# Install atom packages

atom     # Open atom for the first time so the apm command is made available
sleep 30 # Wait for atom to be launched

for a in "${apm[@]}"
do
    echo -e "> Installing atom libraries $a"
    apm install "$a"
done

# Install app from mac app store

mas signin --dialog dufour.florent@icloud.com  # Displays a dialog box to login

for m in "${mas[@]}"
do
  echo -e "> Installing Mac app store Apps $m"
  mas install "$m"
done

# Install python packages

for p in "${pip[@]}"
do
  echo -e "> Intalling python libraries"
  pip3 install "$p"
done

#----------------------------------------------------------------
## GUI:

echo -e '\n\tMESSING WITH OTHER CONFIGS\n'

### Wallpapers

destination='/Library/Desktop\ Pictures' #(For macOS Sierra)

curl http://512pixels.net/downloads/macos-wallpapers/10-5.png -o 'Leopard.png'
curl http://512pixels.net/downloads/macos-wallpapers/10-6.png -o 'Snow-Leopard.png'

sudo mv Leopard.png "$destination/Leopard.png"
sudo mv Snow-Leopard.png "$destination/Snow-Leopard.png"

osascript -e 'tell application "System Events" to set picture of every desktop to ("/Library/Desktop Pictures/Leopard.png" as POSIX file as alias)'

### Hot corners

sudo osascript SetHotCorners.scpt # The AppleScript has to be in the same directory

### Finder prefs

defaults write com.apple.finder AppleShowAllFiles TRUE # Show hidden files

#----------------------------------------------------------------
## Shell:

### Spelling with hunspell

sudo mkdir /Library/Spelling
  # English dictionary
sudo curl -o /Library/Spelling/en_US.aff https://raw.githubusercontent.com/wooorm/dictionaries/master/dictionaries/en-US/index.aff
sudo curl -o /Library/Spelling/en_US.dic https://raw.githubusercontent.com/wooorm/dictionaries/master/dictionaries/en-US/index.dic
  # French dictionary
sudo curl -o /Library/Spelling/fr_FR.aff https://raw.githubusercontent.com/wooorm/dictionaries/master/dictionaries/fr/index.aff
sudo curl -o /Library/Spelling/fr_FR.dic https://raw.githubusercontent.com/wooorm/dictionaries/master/dictionaries/fr/index.dic

### Fish shell

fishPath=`which fish`
echo $fishPath | sudo tee -a /etc/shells  # Add Fish to the list of supported shells
chsh -s $fishPath                         # Make fish the default shell

#----------------------------------------------------------------
## vim:

### ultimate vim rc

# git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
#sh ~/.vim_runtime/install_awesome_vimrc.sh

#----------------------------------------------------------------
## Configuration:

#TODO: Activate & configure fire wall

### Atom configuration

apm disable welcome
#TODO: activate scroll past end

### Copy and source configuration resources

cp ./Resources/bashrc ~/.bash_profile            # For bash shell
cp ./Resources/bashrc ~/.config/fish/config.fish # For fish shell #TODO: create an alias to stay up to date
cp ./Resources/latexmkrc ~/.latexmkrc
cp ./Resources/groovy_profile ~/.groovy/groovy_profile
cp ./Resources/IINAConfig.conf /Library/Application Support/com.colliderli.iina/input_conf/MyConfig.conf
cp ./Resources/itermProfile.json ~/Library/Application Support/iTerm2/DynamicProfiles/MyConfig.json
chmod +x ./Resources/compressPDF
cp ./Resources/compressPDF /usr/local/bin/compressPDF

### Lightroom presets

sudo cp -r ./Resources/Lightroom-presets /Users/florent/Library/Application Support/Adobe/Lightroom/Develop Presets/User Presets

#----------------------------------------------------------------
## Default settings:

### Set default applications (using duti and inline applescripting)

duti -s "$(osascript -e 'id of app "Typora"')" md all
duti -s "$(osascript -e 'id of app "Chromium"')" html all

declare -a iinaFormats=(mp3 mp4 m4a mkv avi webm mov) #Add other formats here

for format in "${iinaFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "IINA"')" $format all
done

declare -a macvimFormats=(txt log dat sh fasta mgf f90 f95 srt csl bib bbl aux sty scala cson) #Add other formats here

for format in "${macvimFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "macvim"')" $format all
done

declare -a decompressorFormats=(rar) #Add other formats here

for format in "${decompressorFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "Decompressor"')" $format all
done

declare -a imagejFormats=(tif tiff) #Add other formats here

for format in "${imagejFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "imagej"')" $format all
done

#----------------------------------------------------------------
## Clean and reboot:

read -p "Remove cached packages/images now ? (Y/N): " remove

if [  $remove = 'Y'  ] || [  $remove = 'y'  ]
then
  rm -rf "$(brew --cache)"
  brew cleanup
fi

echo -e '\n\tREBOOTING\n'
read -p "Reboot now ? (Y/N): " reboot

if [  $reboot = 'Y'  ] || [  $reboot = 'y'  ]
then
  sudo shutdown -r now "Rebooting. Installation completed!";
fi
