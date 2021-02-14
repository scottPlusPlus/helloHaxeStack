package;

import zenlog.Log;
import utest.Assert;

using hawk.util.PromiseX;
using hawk.testutils.PromiseTestUtils;

class ServicesTest  extends utest.Test {

    @:timeout(1000)
	function testCreation(async:utest.Async) {

        var p = Services.create();

        Services.handlePromise(p, function(s){
            Assert.pass();
            async.done();
        }, function(e){
            Log.error("Services creation failed: " + Std.string(e));
            Assert.fail("creation should succeed");
        });
    }
}