load("UnitTest.js");
importPackage(org.openqa.selenium);
importPackage(org.openqa.selenium.firefox);
importPackage(org.openqa.selenium.support.ui);

var CrossTest = function (params) {
    params |= {};
    /**
     * �^�C���A�E�g
     */
    this.timeout = params.timeout || 30;
    /**
     * �h���C�o�[
     */
    this.driver = params.driver || new FirefoxDriver();
    /**
     * �x�[�XURL
     */
    this.baseUrl = params.baseUrl || 'http://test-cross3.nikkei-r.local/develop';

    this.wait = new WebDriverWait(this.driver, this.timeout);

    this.elements = {
        "�W�v�ݒ�Z�b�g�I��" : {
            by : By.ByXPath("//div[@id='MB_frame']"),
            "�e�X�g01" : {
                by : By.ByXPath("//tr[@title='�e�X�g01']")
            },
            "OK" : {
                by : By.ByXPath("//input[@value=' O K ']")
            }
        }
    };

    // �G�������g�擾
    this.getElement = function (path) {
        var
        pathList = path.split('/')
        ,domElement = this.driver
        ,element = this.elements
        ,i
        ;

        for (i = 0; i < pathList.length(); i++) {
            element = element[pathList[i]];
            if (!element.element) {
                // ����`�̏ꍇ�͂��ǂ�
                element.element = new WebDriverWait(
                    domElement, this.timeout).until(
                        ExpectedConditions.presenceOfElementLocated(element.by)
                    );
            }
            domElement = element.element;
        }

        return domElement;
    };

    this.setUp = function () {
        // DB������
        driver.get('http://test-cross3.nikkei-r.local/develop/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
        // �g�b�v�y�[�W
        driver.get('http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906');
        // �W�v�Z�b�g�I��
        this.getElement("�W�v�ݒ�Z�b�g�I��/�e�X�g01").click();
        this.getElement("�W�v�ݒ�Z�b�g�I��/OK").click();
    };
};
CrossTest.prototype = new UnitTest();
