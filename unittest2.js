/**
 * �e�X�g�N���X
 */
var testCase = function () {
    /**
     * �o��
     */
    this.output = function (message, color) {
        print(message);
    };
    /**
     * �A�T�[�g
     */
    this.assert = function () {
        if (!expr) {
            throw new Error(message);
        }
        this.assertCount++;
    
        return true;
    };
    /**
     * �A�T�[�g�C�R�[��
     */
    this.assertEquals = function () {
        return assert(message + "\nexpect : " + expect + "\nresult : " + result,
                      expect === result);
    };
    /**
     * �e�X�g���s
     */
    this.runner = function () {
        this.assertCount = 0;
        var
        successful = 0
        ,testCount = 0
        ,hasSetup = typeof tests.setUp == "function"
        ,hasTeardown = typeof tests.tearDown == "function"
        ,testList = []
        ,testName
        ,i
        ,color
        ;

        // �e�X�g���X�g�̍쐬
        for (testName in this) {
            if (/^\d/.test(test)) {
                testList.push(test);
            }
        }
        testList.sort(function (a,b) {
                          var
                          num_a = a.match(/^\d+/),
                          num_b = b.match(/^\d+/)
                          ;

                          return num_b - num_a;
                      });

        // ���s
        for (i = 0; i < testList.length(); i++) {
            testName = testList[i];
            testCount++;

            try {
                if (hasSetup) {
                    tests.setUp();
                }
                tests[testName]();
                output(testName, "#0c0");

                if (hasTeardown) {
                    tests.tearDown();
                }

                successful++;
            } catch (e) {
                output(testName + " failed: " + e.message, "#c00");
            }
        }
        color = successful == testCount ? "#0c0" : "#c00";

        output(testCount + " tests, " +
               (testCount - successful) + " failures", color);
        
    };
};

// ���܂�
function $fn(target) {
    var fn = [];
    for (var key in target) {
        if (typeof (target[key]) == "function") {
            fn.push(key);
        }
    }
    return fn.sort();
}
