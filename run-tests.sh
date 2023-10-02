#!/bin/bash

# Install dotnet
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 7.0

echo "Set dotnet in PATH so it can be used to execute tests"
export PATH="$PATH:$HOME/.dotnet"

##### Cloud testrun dependencies start
echo "Extracting tests.zip..."
unzip tests.zip
ls

## Environment variables setup
echo "UDID set to ${IOS_UDID}"
export APPIUM_PORT="4723"
export APPIUM_AUTOMATION="XCUITest"
export APPIUM_APPFILE="$PWD/TrashCat.ipa"

export LICENSE_KEY=$(cat license.txt)

## Appium server launch
echo "Starting Appium ..."
appium -U ${IOS_UDID} --log-no-colors --log-timestamp --command-timeout 120

# Install and launch AltTester Desktop
#brew install wget
pwd
wget https://alttester.com/app/uploads/AltTester/desktop/AltTesterDesktopPackageMac__v2.0.2.zip
unzip AltTesterDesktopPackageMac__v2.0.2.zip
cd AltTesterDesktopPackageMac__v2.0.2
hdiutil attach AltTesterDesktop__v2.0.2.dmg
cp -R /Volumes/AltTesterDesktop/AltTesterDesktop.app /Applications
cd /Applications

# Start AltTester Desktop from batchmode
echo "Starting AltTester Desktop ..."
AltTesterDesktop.app/Contents/MacOS/AltTester\ Desktop -batchmode -port 13000 -license $LICENSE_KEY -nographics -logfile LOGFILE.txt
sleep 5

## Run the test:
echo "Running tests"
cd /Users/testdroid/test

mkdir TestResults
dotnet test TestAlttrashCSharp.csproj --logger:junit --filter=MainMenuTests

echo "==> Collect reports"
mv TestResults/TestResults.xml TEST-all.xml

# De-activating AltTester license
cd /Applications
AltTesterDesktop.app/Contents/MacOS/AltTester\ Desktop -batchmode -removeActivation

# Remove AltTester Desktop from Applications and Unmount dmg
echo "Remove AltTesterDesktop from Applications"
rm -r /Applications/AltTesterDesktop.app

echo "Unmounting AltTester Desktop license"
hdiutil detach /Volumes/AltTesterDesktop