using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.iOS;
using OpenQA.Selenium;

namespace alttrashcat_tests_csharp.tests
{
    public class BaseTest
    {
        public IOSDriver<IOSElement> appiumDriver;
        public AltDriver altDriver;
        [OneTimeSetUp]
        public void SetupAppiumAndAltDriver()
        {

            AppiumOptions capabilities = new AppiumOptions();

            capabilities.AddAdditionalCapability("appium:deviceName", "iPhone 14");
            capabilities.AddAdditionalCapability("platformName", "IOS");
            capabilities.AddAdditionalCapability("automationName", "XCUITest");
            capabilities.AddAdditionalCapability("platformVersion", "16");
            capabilities.AddAdditionalCapability("newCommandTimeout", 2000);

            // See available devices at: https://cloud.bitbar.com/#public/devices
            capabilities.AddAdditionalCapability("app", "application.apk");

            Console.WriteLine("WebDriver request initiated. Waiting for response, this typically takes 2-3 mins");

            appiumDriver = new IOSDriver<IOSElement>(new Uri("http://localhost:4723/wd/hub"), capabilities, TimeSpan.FromSeconds(36000));
            appiumDriver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);
            Console.WriteLine("Appium driver started");
            altDriver = new AltDriver();
            Console.WriteLine("AltDriver started");

            IWebElement ll = appiumDriver.FindElement(OpenQA.Selenium.By.Id("Allow"));
            ll.Click();
        }

        [OneTimeTearDown]
        public void DisposeAppiumAndAltDriver()
        {
            Console.WriteLine("Ending");
            altDriver.Stop();
            appiumDriver.Quit();
        }
    }
}