load("UnitTest.js");
importPackage(org.openqa.selenium);
importPackage(org.openqa.selenium.firefox);
importPackage(org.openqa.selenium.support.ui);

var CrossTest = function (params) {
    var self = this;
    params = params || {};
    /**
     * �^�C���A�E�g
     */
    this.timeout = params.timeout || 5;
    /**
     * �h���C�o�[
     */
    this.driver = params.driver || new FirefoxDriver();
    /**
     * �x�[�XURL
     */
    this.baseUrl = params.baseUrl || 'http://test-cross3.nikkei-r.local/develop';
    /**
     * wait
     */
    this.wait = new WebDriverWait(this.driver, this.timeout);

    // �e�X�g�ǂݍ���
    this.loadTest = function (path) {
        var
        testJson
        ,testName
        ;

        eval('testJson = ' + readFile(path));

        this.elements = testJson.initialize.elements;
        this.baseUrl = testJson.initialize.baseUrl;
        this.testPattern = testJson.test;
        for (testName in testJson.test) {
            this[testName] = function(name) {
                return function () {
                    print('���s:' + name);
                    self.executeTest(name);
                };
            }(testName);
        }
    };

    // �G�������g�擾
    this.getElement = function (path) {
        var
        pathList = path.split('/')
        ,element = this.elements
        ,xpath = ''
        ,by
        ,i
        ;

        for (i = 0; i < pathList.length; i++) {
            element = element[pathList[i]];
            if (element.by.ByXPath) {
                // XPath�w��
                by = By.ByXPath(xpath + element.by.ByXPath);
            }
            else if (element.by.ById) {
                // ID�w��
                by = By.ById(element.by.ById);
            }
            else if (element.by.ByLinkText) {
                // ���̑�
                by = By.ByLinkText(element.by.ByLinkText);
            }
            // ������܂ő҂�
            element.element = this.wait.until(
                ExpectedConditions.presenceOfElementLocated(by));

            if (!element.by.ByXPath) {
                // XPath�w��쐬
                if (element.by.ById) {
                    element.by.ByXPath = '//' + element.element.getTagName 
                        + "[@id='" + element.by.ById + "']";
                }
            }

            xpath = xpath + element.by.ByXPath;
        }

        // �G�������g��Ԃ�
        return element.element;
    };
    // �e�X�g���s
    this.executeTest = function (testName) {
        var
        testList = self.testPattern[testName]
        ,testData
        ,i
        ,status
        ,message
        ;

        for (i = 0; i < testList.length; i++) {
            testData = testList[i];
            try {
                if (this[testData.command[0]]) {
                    // �R�}���h���s
                    this[testData.command[0]](testData);
                }
                else {
                    throw new Error('unknown command ' + testData.command[0]);
                }
                status = 'ok';
                message = '';
            } catch (x) {
                status = 'not ok';
                message = ' ' + x.message;
            }

            print (status + ' - ' + testData.comment + message);
        }
    };

    // �R�}���h�ꗗ
    this.open = function (testData) {
        this.driver.get(this.baseUrl + testData.command[1]);
    };
    this.click = function (testData) {
        this.getElement(testData.command[1]).click();
    };
    this.quit = function (testData) {
        this.driver.quit();
    };
    this.isEnabled = function (testData) {
        var element = this.getElement(testData.command[1]);
        try {
            this.wait.until(
                new com.google.common.base.Function(
                    {apply : function () {
                         if (element.isEnabled() == testData.command[2]) {
                             return true;
                         }
                         return null;
                     }
                    }));
        } catch (x) {

        }
        this.assertEquals(element.isEnabled(),
                          testData.command[2]);
    };
    this.alert = function (testData) {
        // �A���[�g���ł�܂ő҂�
        var alert = this.wait.until(ExpectedConditions.alertIsPresent());
        if (testData.command[2]) {
            this.assertEquals(alert.getText(),
                              testData.command[2]);
        }
        if (testData.command[1]) {
            alert.accept();
        }
        else {
            alert.dismiss();
        }
    };
    this.getText = function (testData) {
        var element = this.getElement(testData.command[1]);
        try {
            this.wait.until(
                new com.google.common.base.Function(
                    {apply : function () {
                         if (element.getText() == testData.command[2]) {
                             return true;
                         }
                         return null;
                     }
                    }));
        } catch (x) {

        }
        this.assertEquals(element.getText(),
                          testData.command[2]);
    };
};
CrossTest.prototype = new UnitTest();
