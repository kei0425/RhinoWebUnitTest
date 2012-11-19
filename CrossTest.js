load("UnitTest.js");
importPackage(org.openqa.selenium);
importPackage(org.openqa.selenium.firefox);
importPackage(org.openqa.selenium.support.ui);

var CrossTest = function (params) {
    params = params || {};
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
            by : {ByXPath : "//div[@id='MB_frame']"},
            "�e�X�g01" : {
//                by : {ByXPath : "//tr[4]/td[2]"}
                by : {ByXPath : "//td[text()='�e�X�g01']"}
            },
            "OK" : {
                by : {ByXPath : "//input[@value=' O K ']"}
            }
        },
        "�����ϐ��^�u" : {
            by : {ByLinkText : "�����ϐ�" }
        },
        "�����ϐ��ꗗ" : {
            by : {ByXPath : "//div[@id='gousei_content']"},
            "qv_xq10_1" : {
                by : {ByXPath : "//td[text()='gv_xq10_1']"}
            },
            "�폜" : {
                by : {ByXPath : "//input[@id='del_gousei_valiable]"}
            },
            "�ҏW" : {
                by : {ByXPath : "//input[@id='edit_gousei_valiable]"}
            }
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
            element.element = new WebDriverWait(
                this.driver, this.timeout).until(
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

    this.setUp = function () {
        // DB������
        this.driver.get(this.baseUrl + '/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
        // �g�b�v�y�[�W
        this.driver.get(this.baseUrl + '/cross-lab/top?enq_id=906');
        // �W�v�Z�b�g�I��
        this.getElement("�W�v�ݒ�Z�b�g�I��/�e�X�g01").click();
        this.getElement("�W�v�ݒ�Z�b�g�I��/OK").click();
    };
};
CrossTest.prototype = new UnitTest();
