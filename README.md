# Bitbar-TrashCat

## Server-Side

Follow [Running Cloud-Side Appium tests](https://support.smartbear.com/bitbar/docs/en/mobile-app-tests/automated-testing/appium-support/running-cloud-side-appium-tests.html) to prepare zip archive.

1. Upload zip with all tests and with `run-test.sh` script to launch test execution at the root level of the package.
2. Upload .apk / .ipa
3. Create new test run with previously uploaded files
4. If you use trial devices provided as group, please leave just one running and stop all the others. At the moment AltServer does not allow running same tests on same app simultaneously.

### Server-side with AltServer running in a separate Windows VM, accessible by both tests and game build through IP.

Tested setup using AltServer running in a Windows Azure VM. The conditions for the connection to work:
- the IP of the VM needs to be specified in `BaseTest.cs` when altDriver is instantiated.
- the game build needs to be instrumented with the same host IP.

### Server-side with AltServer running in Bitbar Ubuntu VM (localhost)

The script which is executed on Bitbar VM needs to contain the installation and launching of AltTester Desktop build.


## Client-Side


