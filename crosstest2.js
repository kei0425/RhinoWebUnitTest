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
        // DB������
        driver.get('http://test-cross3.nikkei-r.local/develop/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
        // �g�b�v�y�[�W
        driver.get('http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906');
        // �W�v�Z�b�g�I��
        wait.until(
            ExpectedConditions.presenceOfElementLocated(By.ByXPath('//tr[4]/td[2]'))
        ).click();
        driver.findElementByXPath("//input[@value=' O K ']").click();
    };
};

testCase("�區��", {
             setUp: function () {
                 // DB������
                 driver.get('http://test-cross3.nikkei-r.local/develop/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
                 // �g�b�v�y�[�W
                 driver.get('http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906');
                 // �W�v�Z�b�g�I��
                 wait.until(
                     ExpectedConditions.presenceOfElementLocated(By.ByXPath('//tr[4]/td[2]'))
                 ).click();
                 driver.findElementByXPath("//input[@value=' O K ']").click();
             },
             "�����ϐ�": function () {
                 // �����ϐ��J��
                 driver.findElementByLinkText("�����ϐ�").click();
                 // �v�f�ݒ�
                 var
                 delButton = driver.findElementById("del_gousei_valiable")
                 ,editButton = driver.findElementById("edit_gousei_valiable")
                 ;

                 assertEquals("�����ϐ��J�ڒ���̍폜�{�^��", false, delButton.isEnabled());
                 assertEquals("�����ϐ��J�ڒ���̕ҏW�{�^��", false, editButton.isEnabled());

                 // �����ϐ��I��
                 driver.findElementByXPath("//tr[5]/td[1]").click();
             },
             tearDown: function () {
                 driver.quit();
             }
         });

