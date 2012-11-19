load("UnitTest.js");
importPackage(org.openqa.selenium);
importPackage(org.openqa.selenium.firefox);
importPackage(org.openqa.selenium.support.ui);

var CrossTest = function (params) {
    params = params || {};
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
            by : {ByXPath : "//div[@id='MB_frame']"},
            "テスト01" : {
//                by : {ByXPath : "//tr[4]/td[2]"}
                by : {ByXPath : "//td[text()='テスト01']"}
            },
            "OK" : {
                by : {ByXPath : "//input[@value=' O K ']"}
            }
        },
        "合成変数タブ" : {
            by : {ByLinkText : "合成変数" }
        },
        "合成変数一覧" : {
            by : {ByXPath : "//div[@id='gousei_content']"},
            "qv_xq10_1" : {
                by : {ByXPath : "//td[text()='gv_xq10_1']"}
            },
            "削除" : {
                by : {ByXPath : "//input[@id='del_gousei_valiable]"}
            },
            "編集" : {
                by : {ByXPath : "//input[@id='edit_gousei_valiable]"}
            }
        }
    };

    // エレメント取得
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
                // XPath指定
                by = By.ByXPath(xpath + element.by.ByXPath);
            }
            else if (element.by.ById) {
                // ID指定
                by = By.ById(element.by.ById);
            }
            else if (element.by.ByLinkText) {
                // その他
                by = By.ByLinkText(element.by.ByLinkText);
            }
            // 見つかるまで待つ
            element.element = new WebDriverWait(
                this.driver, this.timeout).until(
                    ExpectedConditions.presenceOfElementLocated(by));

            if (!element.by.ByXPath) {
                // XPath指定作成
                if (element.by.ById) {
                    element.by.ByXPath = '//' + element.element.getTagName 
                        + "[@id='" + element.by.ById + "']";
                }
            }

            xpath = xpath + element.by.ByXPath;
        }

        // エレメントを返す
        return element.element;
    };

    this.setUp = function () {
        // DB初期化
        this.driver.get(this.baseUrl + '/api/cross-lab/cross/tool?dbname=crosstesttemplatedb');
        // トップページ
        this.driver.get(this.baseUrl + '/cross-lab/top?enq_id=906');
        // 集計セット選択
        this.getElement("集計設定セット選択/テスト01").click();
        this.getElement("集計設定セット選択/OK").click();
    };
};
CrossTest.prototype = new UnitTest();
