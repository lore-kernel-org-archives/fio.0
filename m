Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39234 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757765AbdADNAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Jan 2017 08:00:11 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cOlAo-0005oC-4c
        for fio@vger.kernel.org; Wed, 04 Jan 2017 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170104130001.C9F542C1D7E@kernel.dk>
Date: Wed,  4 Jan 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 747311bd9cb82c02bfa4622054b5142a71a6c8ec:

  t/stest: remove old test (2017-01-02 18:21:14 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1684f7fd9047c7405264f462f76e1135c563ec33:

  Add missing .help string for io_size option (2017-01-03 10:10:58 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (7):
      Fix trivial calloc argument order
      Add missing trailing \n in log_err/info()
      Sync README with fio usage output
      Fix canonical name for runtime/timeout option
      Add BSD package/building info to README
      Fix README - change just type "configure" to "./configure"
      Add missing .help string for io_size option

 README             | 32 +++++++++++++++++++-------------
 backend.c          |  2 +-
 client.c           |  2 +-
 engines/e4defrag.c |  2 +-
 engines/net.c      |  2 +-
 engines/rdma.c     |  6 +++---
 engines/sg.c       |  2 +-
 init.c             | 21 ++++++++++++++-------
 iolog.c            |  2 +-
 options.c          |  1 +
 server.c           |  2 +-
 11 files changed, 44 insertions(+), 30 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index a35842e..fdd5bec 100644
--- a/README
+++ b/README
@@ -68,6 +68,10 @@ Windows:
 Rebecca Cran <rebecca+fio@bluestop.org> has fio packages for Windows at
 http://www.bluestop.org/fio/ .
 
+BSDs:
+Packages for BSDs may be available from their binary package repositories.
+Look for a package "fio" using their binary package managers.
+
 
 Mailing list
 ------------
@@ -93,11 +97,11 @@ and archives for the old list can be found here:
 Building
 --------
 
-Just type 'configure', 'make' and 'make install'.
+Just type './configure', 'make' and 'make install'.
 
-Note that GNU make is required. On BSD it's available from devel/gmake;
-on Solaris it's in the SUNWgmake package. On platforms where GNU make
-isn't the default, type 'gmake' instead of 'make'.
+Note that GNU make is required. On BSDs it's available from devel/gmake
+within ports directory; on Solaris it's in the SUNWgmake package.
+On platforms where GNU make isn't the default, type 'gmake' instead of 'make'.
 
 Configure will print the enabled options. Note that on Linux based
 platforms, the libaio development packages must be installed to use
@@ -152,32 +156,32 @@ $ fio
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
@@ -218,6 +222,8 @@ Currently, additional logging is available for:
 	net		Dump info related to networking connections
 	rate		Dump info related to IO rate switching
 	compress	Dump info related to log compress/decompress
+	steadystate	Dump info related to steady state detection
+	helperthread	Dump info related to helper thread
 	? or help	Show available debug options.
 
 One can specify multiple debug options: e.g. --debug=file,mem will enable
diff --git a/backend.c b/backend.c
index c8c6de6..a46101c 100644
--- a/backend.c
+++ b/backend.c
@@ -2063,7 +2063,7 @@ static bool check_mount_writes(struct thread_data *td)
 
 	return false;
 mounted:
-	log_err("fio: %s appears mounted, and 'allow_mounted_write' isn't set. Aborting.", f->file_name);
+	log_err("fio: %s appears mounted, and 'allow_mounted_write' isn't set. Aborting.\n", f->file_name);
 	return true;
 }
 
diff --git a/client.c b/client.c
index 1b4d3d7..7934661 100644
--- a/client.c
+++ b/client.c
@@ -1322,7 +1322,7 @@ static int fio_client_handle_iolog(struct fio_client *client,
 	log_pathname = malloc(10 + strlen((char *)pdu->name) +
 			strlen(client->hostname));
 	if (!log_pathname) {
-		log_err("fio: memory allocation of unique pathname failed");
+		log_err("fio: memory allocation of unique pathname failed\n");
 		return -1;
 	}
 	/* generate a unique pathname for the log file using hostname */
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index e53636e..1e4996f 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -95,7 +95,7 @@ static int fio_e4defrag_init(struct thread_data *td)
 	ed->donor_fd = open(donor_name, O_CREAT|O_WRONLY, 0644);
 	if (ed->donor_fd < 0) {
 		td_verror(td, errno, "io_queue_init");
-		log_err("Can't open donor file %s err:%d", donor_name, ed->donor_fd);
+		log_err("Can't open donor file %s err:%d\n", donor_name, ed->donor_fd);
 		free(ed);
 		return 1;
 	}
diff --git a/engines/net.c b/engines/net.c
index 5f1401c..3bdd5cd 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1218,7 +1218,7 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 			return 1;
 		}
 		if (is_ipv6(o)) {
-			log_err("fio: IPv6 not supported for multicast network IO");
+			log_err("fio: IPv6 not supported for multicast network IO\n");
 			close(fd);
 			return 1;
 		}
diff --git a/engines/rdma.c b/engines/rdma.c
index fbe8434..10e60dc 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -881,7 +881,7 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 	rd->send_buf.nr = htonl(td->o.iodepth);
 
 	if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-		log_err("fio: ibv_post_send fail: %m");
+		log_err("fio: ibv_post_send fail: %m\n");
 		return 1;
 	}
 
@@ -932,7 +932,7 @@ static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 	ret = rdma_poll_wait(td, IBV_WC_RECV) < 0;
 
 	if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-		log_err("fio: ibv_post_send fail: %m");
+		log_err("fio: ibv_post_send fail: %m\n");
 		return 1;
 	}
 
@@ -965,7 +965,7 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 				     || (rd->rdma_protocol ==
 					 FIO_RDMA_MEM_READ))) {
 		if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-			log_err("fio: ibv_post_send fail: %m");
+			log_err("fio: ibv_post_send fail: %m\n");
 			return 1;
 		}
 
diff --git a/engines/sg.c b/engines/sg.c
index c1fe602..001193d 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -579,7 +579,7 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 	char *msg, msgchunk[MAXMSGCHUNK], *ret = NULL;
 	int i;
 
-	msg = calloc(MAXERRDETAIL, 1);
+	msg = calloc(1, MAXERRDETAIL);
 
 	/*
 	 * can't seem to find sg_err.h, so I'll just echo the define values
diff --git a/init.c b/init.c
index 3c925a3..9889949 100644
--- a/init.c
+++ b/init.c
@@ -94,7 +94,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'o' | FIO_CLIENT_FLAG,
 	},
 	{
-		.name		= (char *) "timeout",
+		.name		= (char *) "runtime",
 		.has_arg	= required_argument,
 		.val		= 't' | FIO_CLIENT_FLAG,
 	},
@@ -1984,6 +1984,11 @@ static void show_debug_categories(void)
 #endif
 }
 
+/*
+ * Following options aren't printed by usage().
+ * --append-terse - Equivalent to --output-format=terse, see f6a7df53.
+ * --latency-log - Deprecated option.
+ */
 static void usage(const char *name)
 {
 	printf("%s\n", fio_version_string);
@@ -1995,12 +2000,13 @@ static void usage(const char *name)
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
@@ -2016,14 +2022,15 @@ static void usage(const char *name)
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
diff --git a/iolog.c b/iolog.c
index 9393890..25d8dd0 100644
--- a/iolog.c
+++ b/iolog.c
@@ -422,7 +422,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 				continue;
 			}
 		} else {
-			log_err("bad iolog2: %s", p);
+			log_err("bad iolog2: %s\n", p);
 			continue;
 		}
 
diff --git a/options.c b/options.c
index 0f2adcd..1ca16e8 100644
--- a/options.c
+++ b/options.c
@@ -1883,6 +1883,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
 		.off1	= offsetof(struct thread_options, io_limit),
+		.help	= "Total size of I/O to be performed",
 		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
diff --git a/server.c b/server.c
index b7ebd63..6d5d4ea 100644
--- a/server.c
+++ b/server.c
@@ -2538,7 +2538,7 @@ int fio_start_server(char *pidfile)
 
 	pid = fork();
 	if (pid < 0) {
-		log_err("fio: failed server fork: %s", strerror(errno));
+		log_err("fio: failed server fork: %s\n", strerror(errno));
 		free(pidfile);
 		return -1;
 	} else if (pid) {
