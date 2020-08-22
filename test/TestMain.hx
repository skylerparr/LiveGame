import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.client.SummaryReportClient;
import massive.munit.TestRunner;

#if js
import js.Lib;
#end

/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestMain
{
	static function main(){	new TestMain(); }

	public function new()
	{
		#if (debug && cpp)
		var startDebugger:Bool = false;
		var debuggerHost:String = "";
		var argStartDebugger:String = "-start_debugger";
		var pDebuggerHost:EReg = ~/-debugger_host=(.+)/;

		for (arg in Sys.args()) {
			if(arg == argStartDebugger){
				startDebugger = true;
			}
			else if(pDebuggerHost.match(arg)){
				debuggerHost = pDebuggerHost.matched(1);
			}
		}

		if(startDebugger){
			if(debuggerHost != "") {
				var args:Array<String> = debuggerHost.split(":");
				new debugger.HaxeRemote(true, args[0], Std.parseInt(args[1]));
			}
			else {
				new debugger.Local(true);
			}
		}
		#end

		var suites = new Array<Class<massive.munit.TestSuite>>();
		suites.push(TestSuite);

		#if MCOVER
			var client = new mcover.coverage.munit.client.MCoverPrintClient();
			var httpClient = new HTTPClient(new mcover.coverage.munit.client.MCoverSummaryReportClient());
			#if sys
				mcover.coverage.MCoverage.getLogger().addClient(new mcover.coverage.client.LcovPrintClient("mcover unittests", "coverage/lcov.info"));
				mcover.coverage.MCoverage.getLogger().addClient(new CoverageFileOutputClient("coverage/coverage.txt"));
			#end
		#else
		var client = new RichPrintClient();
		var httpClient = new HTTPClient(new SummaryReportClient());
		#end

		var runner:TestRunner = new TestRunner(client);
		runner.addResultClient(httpClient);
		runner.addResultClient(new HTTPClient(new JUnitReportClient()));
		runner.completionHandler = completionHandler;
		
		#if js
		var seconds = 0; // edit here to add some startup delay
		function delayStartup() 
		{
			if (seconds > 0) {
				seconds--;
				js.Browser.document.getElementById("munit").innerHTML =
					"Tests will start in " + seconds + "s...";
				haxe.Timer.delay(delayStartup, 1000);
			}
			else {
				js.Browser.document.getElementById("munit").innerHTML = "";
				runner.run(suites);
			}
		}
		delayStartup();
		#else
		runner.run(suites);
		#end
	}

	/*
		updates the background color and closes the current browser
		for flash and html targets (useful for continous integration servers)
	*/
	function completionHandler(successful:Bool):Void
	{
		var logger = mcover.coverage.MCoverage.getLogger();
		logger.report();

		try
		{
			#if flash
				flash.external.ExternalInterface.call("testResult", successful);
			#elseif js
				js.Lib.eval("testResult(" + successful + ");");
			#elseif sys
				Sys.exit(0);
			#end
		}
		// if run from outside browser can get error which we can ignore
		catch (e:Dynamic)
		{
		}
	}
}
