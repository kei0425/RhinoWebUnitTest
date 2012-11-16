load("UnitTest.js");
importPackage(org.openqa.selenium);
importPackage(org.openqa.selenium.firefox);
importPackage(org.openqa.selenium.support.ui);

var CrossTest = function (params) {
    params |= {};
    /**
     * タイムアウト
     */
    this.timeout = params.timeout || 30;
    /**
     * ドライバー
     */
    this.driver = params.driver || new FirefoxDriver();
    /**
     * ベースURL
     */
    this.baseUrl = params.baseUrl || 'http://test-cross3.nikkei-r.local/develop';

    this.wait = new WebDriverWait(this.driver, this.timeout);

    this.elements = {
        "集計設定セット選択" : {
            by : By.ByXPath("//div[@id='MB_frame']"),
            "テスト01" : {
                by : By.ByXPath("//tr[@title='テスト01']")
            },
            "OK" : {
                by : By.ByXPath("//input[@value=' O K ']")
            }
        }
    };

    // エレメント取得
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
                // 未定義の場合はたどる
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
        // DB初期化
        driver.get('http://test-cross3.nikkei-r.local/develop/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
        // トップページ
        driver.get('http://test-cross3.nikkei-r.local/develop/cross-lab/top?enq_id=906');
        // 集計セット選択
        this.getElement("集計設定セット選択/テスト01").click();
        this.getElement("集計設定セット選択/OK").click();
    };
};
CrossTest.prototype = new UnitTest();
