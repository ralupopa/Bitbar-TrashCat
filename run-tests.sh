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
export PLATFORM_NAME="Android"
export UDID=${ANDROID_SERIAL}
export APPIUM_PORT="4723"

APILEVEL=$(adb shell getprop ro.build.version.sdk)
APILEVEL="${APILEVEL//[$'\t\r\n']}"
export PLATFORM_VERSION=${APILEVEL}
echo "API level is: ${APILEVEL}"

if [ "$APILEVEL" -gt "19" ]; then
	export AUTOMATION_NAME="UiAutomator2"
	echo "UiAutomator2"
else
	export AUTOMATION_NAME="UiAutomator1"
	echo "UiAutomator1"
fi

TEST=${TEST:="SampleAppTest"}

# Start AltTester Desktop from batchmode
echo "Starting AltTester Desktop ..."
export LICENSE_KEY=$(cat license.txt)

cd AltTesterDesktopLinuxBatchmode
chmod +x ./AltTesterDesktop.x86_64
./AltTesterDesktop.x86_64 -batchmode -port 13000 -license $LICENSE_KEY -nographics -termsAndConditionsAccepted &
cd ..

## Appium server launch
echo "Starting Appium ..."
appium --log-no-colors --log-timestamp

export APPIUM_APPFILE=$PWD/application.apk # App file is at current working folder

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