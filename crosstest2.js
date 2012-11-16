load("UnitTest.js");
importPackage(org.openqa.selenium);
importPackage(org.openqa.selenium.firefox);
importPackage(org.openqa.selenium.support.ui);



var test = new SeleniumTest(
    {
        "driver"  : new FirefoxDriver(),
        "baseUrl" : 'http://test-cross3.nikkei-r.local/develop',
        "timeout" : 30
    });

var driver = new FirefoxDriver();
var wait = new WebDriverWait(driver, 30);

var Test1 = function () {
    this.driver = new FirefoxDriver();
    this.wait = new WebDriverWait(driver, 30);

    this.setUp = function () {
        // DB初期化
        driver.get('http://test-cross3.nikkei-r.local/develop/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
        // トップページ
        driver.get('http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906');
        // 集計セット選択
        wait.until(
            ExpectedConditions.presenceOfElementLocated(By.ByXPath('//tr[4]/td[2]'))
        ).click();
        driver.findElementByXPath("//input[@value=' O K ']").click();
    };
};

testCase("大項目", {
             setUp: function () {
                 // DB初期化
                 driver.get('http://test-cross3.nikkei-r.local/develop/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
                 // トップページ
                 driver.get('http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906');
                 // 集計セット選択
                 wait.until(
                     ExpectedConditions.presenceOfElementLocated(By.ByXPath('//tr[4]/td[2]'))
                 ).click();
                 driver.findElementByXPath("//input[@value=' O K ']").click();
             },
             "合成変数": function () {
                 // 合成変数遷移
                 driver.findElementByLinkText("合成変数").click();
                 // 要素設定
                 var
                 delButton = driver.findElementById("del_gousei_valiable")
                 ,editButton = driver.findElementById("edit_gousei_valiable")
                 ;

                 assertEquals("合成変数遷移直後の削除ボタン", false, delButton.isEnabled());
                 assertEquals("合成変数遷移直後の編集ボタン", false, editButton.isEnabled());

                 // 合成変数選択
                 driver.findElementByXPath("//tr[5]/td[1]").click();
             },
             tearDown: function () {
                 driver.quit();
             }
         });

