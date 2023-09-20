using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.Android;

namespace alttrashcat_tests_csharp.tests
{
    public class BaseTest
    {
        public AndroidDriver<AndroidElement> appiumDriver;
        public AltDriver altDriver;
        [OneTimeSetUp]
        public void SetupAppium()
        {

            AppiumOptions capabilities = new AppiumOptions();

            capabilities.AddAdditionalCapability("appium:deviceName", "Android");
            capabilities.AddAdditionalCapability("platformName", "Android");
            capabilities.AddAdditionalCapability("appium:automationName", "UIAutomator2");
            capabilities.AddAdditionalCapability("appium:app", "TrashCat201.apk");
            capabilities.AddAdditionalCapability("newCommandTimeout", 2000);

            Console.WriteLine("WebDriver request initiated. Waiting for response, this typically takes 2-3 mins");

            appiumDriver = new AndroidDriver<AndroidElement>(new Uri("http://localhost:4723/wd/hub"), capabilities, TimeSpan.FromSeconds(36000));
            appiumDriver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);
            Console.WriteLine("Appium driver started");
            altDriver = new AltDriver();
            Console.WriteLine("AltDriver started");
        }

        [OneTimeTearDown]
        public void DisposeAppium()
        {
            Console.WriteLine("Ending");
            altDriver.Stop();
            appiumDriver.Quit();
        }
    }
}