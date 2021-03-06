package;

import zenlog.Log;
import utest.ui.Report;
import utest.Runner;
import hawk.testutils.TestLogger;

class TestRunner {
	public static function main() {
		TestLogger.init();
		TestLogger.filter.indentStackStart = 18;

		var runner = new Runner();
		runner.addCases(test.test_chirp);
		runner.addCase(new ServicesTest());

		Report.create(runner);

		ageWarning();

		runner.run();
	}

	static function ageWarning():Void {
		var buildTime = CompileTime.buildDate();
		var now = Date.now();
		var dur = now.getTime() - buildTime.getTime();
		var seconds = Math.floor(dur / 1000);

		var minutes = seconds / 60;
		if (minutes > 1) {
			Log.warn('WARN! \n\nBuild is  ${minutes} minutes old\n\n WARN');
		}
	}
}
