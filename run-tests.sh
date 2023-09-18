#!/bin/bash

# Install dotnet
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 7.0

echo "Set dotnet in PATH so it can be used to execute tests"
export PATH="$PATH:$HOME/.dotnet"

echo "==> Setup ADB port reverse..."
adb reverse --remove-all
adb reverse tcp:13000 tcp:13000

##### Cloud testrun dependencies start
echo "Extracting tests.zip..."
unzip tests.zip

## Environment variables setup
echo "UDID set to ${IOS_UDID}"
export APPIUM_PORT="4723"

TEST=${TEST:="SampleAppTest"}

## Appium server launch
echo "Starting Appium ..."
appium -U ${IOS_UDID} --log-no-colors --log-timestamp --command-timeout 120

export APPIUM_APPFILE=$PWD/application.ipa # App file is at current working folder

# Prepare license
export LICENSE_KEY=$(cat license.txt)

# Install and launch AltTester Desktop
wget https://alttester.com/app/uploads/AltTester/desktop/AltTesterDesktopLinuxBatchmode.zip
unzip AltTesterDesktopLinuxBatchmode.zip
cd AltTesterDesktopLinuxBatchmode
chmod +x ./AltTesterDesktop.x86_64

# Start AltTester Desktop from batchmode
echo "Starting AltTester Desktop ..."
./AltTesterDesktop.x86_64 -batchmode -port 13000 -nographics -logfile /AltTesterLogs/AltTester.log -license $LICENSE_KEY -termsAndConditionsAccepted
cd ..

## Run the test:
echo "Running tests"
mkdir TestResults
dotnet test TestAlttrashCSharp.csproj --logger:junit --filter=MainMenuTests

echo "==> Collect reports"
mv TestResults/TestResults.xml TEST-all.xml

# De-activate license
echo "De-activating AltTester Desktop license"
cd AltTesterDesktopLinuxBatchmode
./AltTesterDesktop.x86_64 -batchmode -removeActivation