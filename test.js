importPackage(org.openqa.selenium);
importPackage(org.openqa.selenium.firefox);
importPackage(org.openqa.selenium.support.ui);
//importPackage(org.openqa.selenium.support.ui.ExpectedConditions);

driver = new FirefoxDriver();
driver.get('http://test-cross3.nikkei-r.local/develop/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
driver.get('http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906');
wait = new WebDriverWait(driver, 30);
wait.until(
    ExpectedConditions.presenceOfElementLocated(By.ByXPath("//div[@id='customize_cntnr_my']//tr/td[@title='テスト01']"))
).click();
driver.findElementByXPath("//input[@value=' O K ']").click();
driver.findElementByLinkText("合成変数").click();
// 初期画面

driver.findElementByXPath("//tr[5]/td[1]").click();
del = driver.findElementById("del_gousei_valiable");
wait.until(
    new com.google.common.base.Function(
        {apply : function () {return del.isEnabled() || null;}
        }));
del.click();
// 一度キャンセル
wait.until(ExpectedConditions.alertIsPresent()).dismiss();

del.click();
wait.until(ExpectedConditions.alertIsPresent()).accept();
driver.getScreenshotAs(OutputType.FILE);
//driver.quit();

function $fn(target) {
    var fn = [];
    for (var key in target) {
        if (typeof (target[key]) == "function") {
            fn.push(key);
        }
    }
    return fn.sort();
}
