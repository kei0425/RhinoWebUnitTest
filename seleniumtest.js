var SeleniumTest = function (param) {
    this.timeout = params.timeout || 30;
    this.driver = params.driver || new FirefoxDriver();
    this.wait = new WebDriverWait(this.driver, this.timeout);
    this.baseUrl = params.baseUrl || 'http://test-cross3.nikkei-r.local/develop';

    

    
    
    
};