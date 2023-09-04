using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.Android;

namespace alttrashcat_tests_csharp.tests
{
    public class BaseTest
    {
        public AndroidDriver<AndroidElement> appiumDriver;
        public AltDriver altDriver;
        public String HOST_ALT_SERVER = Environment.GetEnvironmentVariable("HOST_ALT_SERVER");
        public String BITBAR_APIKEY = Environment.GetEnvironmentVariable("BITBAR_APIKEY");
        public String BITBAR_APP_ID_SDK_201 = Environment.GetEnvironmentVariable("BITBAR_APP_ID_SDK_201");
        [OneTimeSetUp]
        public void SetupAppium()
        {

            AppiumOptions capabilities = new AppiumOptions();

            capabilities.AddAdditionalCapability("platformName", "Android");
            capabilities.AddAdditionalCapability("appium:deviceName", "Android");
            capabilities.AddAdditionalCapability("appium:automationName", "UiAutomator2");
            capabilities.AddAdditionalCapability("appium:deviceName", "Google Pixel 3a Android 12");
            capabilities.AddAdditionalCapability("appium:newCommandTimeout", 2000);
            
            capabilities.AddAdditionalCapability("bitbar_apiKey", BITBAR_APIKEY);
            capabilities.AddAdditionalCapability("bitbar_project", "Client Side SDK 2.0.1 on custom host");
            capabilities.AddAdditionalCapability("bitbar_testrun", "Start Page Tests on Samsung");

            // See available devices at: https://cloud.bitbar.com/#public/devices
            capabilities.AddAdditionalCapability("bitbar_device", "Samsung Galaxy A52 -US");
            capabilities.AddAdditionalCapability("bitbar_app", BITBAR_APP_ID_SDK_201);

            Console.WriteLine("WebDriver request initiated. Waiting for response, this typically takes 2-3 mins");

            appiumDriver = new AndroidDriver<AndroidElement>(new Uri("https://eu-mobile-hub.bitbar.com/wd/hub"), capabilities, TimeSpan.FromSeconds(3000));
            appiumDriver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);
            Thread.Sleep(15);
            Console.WriteLine("Appium driver started");
            SetupPortForwarding();
            altDriver = new AltDriver(host: HOST_ALT_SERVER);
            Console.WriteLine("AltDriver started");
        }

        [OneTimeTearDown]
        public void DisposeAppium()
        {
            Console.WriteLine("Ending");
            altDriver.Stop();
            appiumDriver.Quit();
        }

        public void SetupPortForwarding()
        {
            AltReversePortForwarding.RemoveReversePortForwardingAndroid();
            AltReversePortForwarding.ReversePortForwardingAndroid();
            Console.WriteLine("Port forwarded (Android).");
        }
    }
}