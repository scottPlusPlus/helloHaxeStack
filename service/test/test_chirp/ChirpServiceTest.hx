package test.test_chirp;

import polygonal.ds.ArrayedQueue;
import hawk.core.UUID;
import zenlog.Log;
import hawk.store.InMemoryStringStore;
import chirp.ChirpService.ChirpServiceDeps;
import chirp.*;
import hawk.messaging.LocalChannel;
import tink.CoreApi;
import utest.Assert;

using hawk.util.PromiseX;
using hawk.testutils.PromiseTestUtils;

class ChirpServiceTest  extends utest.Test {

    @:timeout(1000)
	function testHappy(async:utest.Async) {
        Log.debug("start testHappy");
        
        var service:ChirpService;
        var actor = UUID.gen();
        var msg = "my test chirp";

        var p = newService().next(function(s){
            service = s;
            return Noise;
        }).next(function(_){
            return service.postChirp(actor, msg);
        }).assertNoErr().thenWait(900).next(function(_){
            //Log.debug('post and wait complete, prepare to get');
            return service.getChirps();
        }).assertNoErr()
        .next(function(chirps){
            //Log.debug('got chirps');
            Assert.equals(1, chirps.length);
            Assert.equals(msg, chirps[0].message);
            return Noise;
        }).endTestChain(async);
    }

    @:timeout(1000)
    function testMostRecentFirst(async:utest.Async) {
        Log.debug("start testHappy");
        
        var service:ChirpService;
        var actor = UUID.gen();
        var msg1 = "first message";
        var msg2 = "second message";
        var msg3 = "third message";

        var p = newService().next(function(s){
            service = s;
            return Noise;
        }).next(function(_){
            return service.postChirp(actor, msg1);
        }).next(function(_){
            return service.postChirp(actor, msg2);
        }).next(function(_){
            return service.postChirp(actor, msg3);            
        }).assertNoErr().thenWait(900).next(function(_){
            return service.getChirps();
        }).assertNoErr()
        .next(function(chirps){
            Assert.equals(3, chirps.length);
            Assert.equals(msg3, chirps[0].message);
            Assert.equals(msg2, chirps[1].message);
            Assert.equals(msg1, chirps[2].message);
            return Noise;
        }).endTestChain(async);
    }

    function newService():Promise<ChirpService> {
        var channel = new LocalChannel<EvNewChirp>("chirp", EvNewChirp.toMessage, EvNewChirp.fromMessage);
		var deps:ChirpServiceDeps = {
			newChirpPub: channel,
			newChirpSub: channel,
			recentChirpStore: new InMemoryStringStore()
		}
		return new ChirpService().init(deps);
    }

}