Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/7] Sync README with fio usage output
Date: Tue,  3 Jan 2017 23:40:07 +0900
Message-Id: <1483454411-14535-3-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
References: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Some of the commits only update one of these.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 README | 20 +++++++++++---------
 init.c | 14 ++++++++------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/README b/README
index a35842e..2fa8e1b 100644
--- a/README
+++ b/README
@@ -152,32 +152,32 @@ $ fio
 	--bandwidth-log		Generate aggregate bandwidth logs
 	--minimal		Minimal (terse) output
 	--output-format=type	Output format (terse,json,json+,normal)
-	--terse-version=type	Terse version output format (default 3, or 2 or 4).
+	--terse-version=type	Set terse version output format (default 3, or 2 or 4)
 	--version		Print version info and exit
 	--help			Print this page
 	--cpuclock-test		Perform test/validation of CPU clock
-	--crctest[=test]	Test speed of checksum functions
+	--crctest=type		Test speed of checksum functions
 	--cmdhelp=cmd		Print command help, "all" for all of them
 	--enghelp=engine	Print ioengine help, or list available ioengines
 	--enghelp=engine,cmd	Print help for an ioengine cmd
 	--showcmd		Turn a job file into command line options
-	--readonly		Turn on safety read-only checks, preventing
-				writes
 	--eta=when		When ETA estimate should be printed
 				May be "always", "never" or "auto"
 	--eta-newline=time	Force a new line for every 'time' period passed
 	--status-interval=t	Force full status dump every 't' period passed
+	--readonly		Turn on safety read-only checks, preventing writes
 	--section=name		Only run specified section in job file.
 				Multiple sections can be specified.
 	--alloc-size=kb		Set smalloc pool to this size in kb (def 16384)
 	--warnings-fatal	Fio parser warnings are fatal
-	--max-jobs		Maximum number of threads/processes to support
-	--server=args		Start backend server. See Client/Server section.
-	--client=host		Connect to specified backend(s).
-	--remote-config=file	Tell fio server to load this local file
+	--max-jobs=nr		Maximum number of threads/processes to support
+	--server=args		Start a backend fio server. See Client/Server section.
+	--client=hostname	Talk to remote backend(s) fio server at hostname
+	--daemonize=pidfile	Background fio server, write pid to file
+	--remote-config=file	Tell fio server to load this local job file
 	--idle-prof=option	Report cpu idleness on a system or percpu basis
 				(option=system,percpu) or run unit work
-				calibration only (option=calibrate).
+				calibration only (option=calibrate)
 	--inflate-log=log	Inflate and output compressed log
 	--trigger-file=file	Execute trigger cmd when file exists
 	--trigger-timeout=t	Execute trigger af this time
@@ -218,6 +218,8 @@ Currently, additional logging is available for:
 	net		Dump info related to networking connections
 	rate		Dump info related to IO rate switching
 	compress	Dump info related to log compress/decompress
+	steadystate	Dump info related to steady state detection
+	helperthread	Dump info related to helper thread
 	? or help	Show available debug options.
 
 One can specify multiple debug options: e.g. --debug=file,mem will enable
diff --git a/init.c b/init.c
index 3c925a3..d12b75d 100644
--- a/init.c
+++ b/init.c
@@ -1995,12 +1995,13 @@ static void usage(const char *name)
 	printf("  --runtime\t\tRuntime in seconds\n");
 	printf("  --bandwidth-log\tGenerate aggregate bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
-	printf("  --output-format=x\tOutput format (terse,json,json+,normal)\n");
-	printf("  --terse-version=x\tSet terse version output format to 'x'\n");
+	printf("  --output-format=type\tOutput format (terse,json,json+,normal)\n");
+	printf("  --terse-version=type\tSet terse version output format"
+		" (default 3, or 2 or 4)\n");
 	printf("  --version\t\tPrint version info and exit\n");
 	printf("  --help\t\tPrint this page\n");
 	printf("  --cpuclock-test\tPerform test/validation of CPU clock\n");
-	printf("  --crctest\t\tTest speed of checksum functions\n");
+	printf("  --crctest=type\tTest speed of checksum functions\n");
 	printf("  --cmdhelp=cmd\t\tPrint command help, \"all\" for all of"
 		" them\n");
 	printf("  --enghelp=engine\tPrint ioengine help, or list"
@@ -2016,14 +2017,15 @@ static void usage(const char *name)
 	printf(" 't' period passed\n");
 	printf("  --readonly\t\tTurn on safety read-only checks, preventing"
 		" writes\n");
-	printf("  --section=name\tOnly run specified section in job file\n");
+	printf("  --section=name\tOnly run specified section in job file,"
+		" multiple sections can be specified\n");
 	printf("  --alloc-size=kb\tSet smalloc pool to this size in kb"
-		" (def 1024)\n");
+		" (def 16384)\n");
 	printf("  --warnings-fatal\tFio parser warnings are fatal\n");
 	printf("  --max-jobs=nr\t\tMaximum number of threads/processes to support\n");
 	printf("  --server=args\t\tStart a backend fio server\n");
 	printf("  --daemonize=pidfile\tBackground fio server, write pid to file\n");
-	printf("  --client=hostname\tTalk to remote backend fio server at hostname\n");
+	printf("  --client=hostname\tTalk to remote backend(s) fio server at hostname\n");
 	printf("  --remote-config=file\tTell fio server to load this local job file\n");
 	printf("  --idle-prof=option\tReport cpu idleness on a system or percpu basis\n"
 		"\t\t\t(option=system,percpu) or run unit work\n"
-- 
2.5.5


