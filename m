Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:50407
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1JNEAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 14 Oct 2011 00:00:05 -0400
Subject: Recent changes
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20111014040002.95902484001@kernel.dk>
Date: Fri, 14 Oct 2011 06:00:02 +0200 (CEST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 15b87723551b424d0db4c53577b567e670c7d4d8:

  Fix bad random offset generation for file map (2011-10-12 09:46:01 +0200)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Bruce Cran (2):
      Fix compile on FreeBSD
      Fix Windows issue with socklen_t

Jens Axboe (183):
      Start of client/server
      Hide things not appropriate behind is_backend
      Use poll() for connect loop
      Close listen socket when done
      Properly log errors in server
      Add start of client, start of real protocol
      Start of functional client
      Server logging cleanup/functionality
      Use length guarded sprintf functions
      Pass more arguments to fio_init_net_cmd()
      server: debug fixes
      crc16: use void * as the argument
      Reinstate double logging if f_err != stderr
      server: switch to 16-bit crc
      server: serial is a 64-bit field
      client: fix error in logging output
      server: quit client when job run is complete
      server: ensure payload larger than max is broken into pieces
      client: initial support for multiple connections
      client: continue support for multiple connections
      server: exit gracefully on ctrl-c
      client: re-setup poll fd array in case a client disappears
      Add FD_NET debugging value
      server/client: add FD_NET debug clues
      Fixup some bad file naming
      server: malloc/free fix
      Style fixup
      server: make struct group_run_stats network transfer friendly
      server: initial support for daemonizing
      server: start conversion of data structures to network friendly types
      client: don't setup shared mem area for just the frontend
      server: endianness bug and exit command
      server: unify shm setup
      Move stat_io_bytes/time to thread_data
      Move getrusage() out of thread_stat
      Allocate thread_stat name arrays statically
      server: transmit status as structures, not text
      client: fixup quit
      Add type checking to 16/32/64 endianness converters
      server: package defrag fix
      Add TODO list
      Abstract out calculation of ETA from display of ETA
      server: add ETA as a specific command
      server: send network copy of run_str[]
      server: attempt to handle client ctrl-c
      server: fix typos in conversion
      poll: break on EINTR without complaining
      server: remove some debug statements
      server: silence mem debug warning
      client: handle connection failure
      server: error handling and probe command
      client: probe command support
      server: idle loop support
      parser: use logging infrastructure
      server: fix for non zero appended strings
      Style fixup
      server: initial support for command line passing
      server: send return quit when asked to leave
      client: improve poll() loop
      server: improve exit handling
      client: improve handling of non-newline text strings
      server: add a few more debug logging statements
      Fix bad indexing of options
      server: more debug dumping
      Move endianness check to OS parts
      log: needs stdarg include for va_list
      HPUX endianness
      Wider endianness support
      More endianness for platforms
      Need signal.h for sigaction()
      server: fix sk typo and add endian type to probe
      server: log where connection is coming from
      server: cast sockaddr_in for accept()
      Update TODO
      Generic endianness typo
      server: log locally if connection isn't up yet
      Finalize (?) byte swap/endian stuff
      server: portability fixups
      log: don't use vsyslog
      Add fio_socklen_t
      Assume AIX is big endian
      AIX fixes
      Remove endianness TODO, should be done now
      Add IEEE 754 pack and unpack helpers
      Change network transmitted doubles to fio_fp64_t IEEE 754 type
      Merge branch 'master' into client-server
      Print usage if no arguments are given
      t/stest: add log.o smaller helper
      Re-enable -O2 optimization
      Add IEEE 754 test case
      Remove float conversion from TODO
      Fio 1.99
      Fix warnings about unused fwrite() return value
      client: prefix server text messages with <hostname>
      Endian sanity check
      Move endian support out of server.h
      Add support for write_iops_log
      client: check and error out on exceeding number of command line args to pass
      parser: always use the fio logging instead of stderr/stdout
      client: ensure that cmd line arguments are always run
      server: send quit if we don't add a job
      client: disconnect on read failure
      client: improve handling of multiple clients
      server: require poll before fio_net_recv_cmd()
      server: quit on !block and backend exit
      Fio 1.99.1
      Only print usage() on error
      Correctly handle multiple clients for various command line arguments
      Add jhash (Jenkins hash) and use that for file names
      client: add hashes for fd/name lookups
      net: support for unix domain sockets
      Add support for client/server connection over unix domain sockets
      Remember to close sockets on error
      Update TODO
      server: fix += -> + typo
      Unify client/server argument
      server: fix bad interpretation of local socket binding
      Remember to clear client cookie
      Split version into separate include fio
      client: remove leftover debug printf()
      server: increase default max pdu length to 1024
      Fio 1.99.2
      Poll server idle loop any time the main status thread sleeps
      client: fix mem leak
      Pass arch/os in probe
      server: ensure to set proper port
      client: don't clear client->addr after it's been set
      server: properly configure port without argument
      client: pretty up probe output
      Makefile: move -rdynamic to linking flag
      Fix warning when clang is used as the compiler
      Makefile: use -O3 by default
      Fio 1.99.3
      client: used hostname passed back in probe as log prefix
      Add protocol support for an arbitrary number of command line arguments
      Update TODO
      client: fix jobs_eta conversion typo
      client: sum running ETA of jobs
      client/server: request ETA instead of having the server send it automatically
      init: typo, remove -> remote.
      client: track pending ETA requests
      client/server: few select speedups
      Abstract out and export summation of thread_stats
      client: properly assign client eta in flight
      server: write pid file for backgrounded server to specified file
      server: improve pidfile and log handling
      client: duplicate arguments to "empty" clients
      server: fread() - check <= 0 return value
      Fio 1.99.4
      client/server: track and handle command timeouts
      server: assume PID is dead on ESRCH
      server: error handling fixes
      client: display summed total of all clients when all stats have been received
      client: dec sum_stat_clients if one a client is disconnected
      client/server: fix ptr <-> uint64_t casting warnings on 32-bit builds
      server: include 32/64-bit in probe
      client: cleanup bit printing
      Fix off-by-one in jobs_eta allocation
      Merge branch 'master' into client-server
      Correct Windows fio version
      Fix clat percentile display
      Pretty up clat percentile display so it's actually readable
      Be a bit more defensive in clat percentile calc and display
      server: fix bug in converting/storing clat percentiles
      Fio 1.99.5
      Remove extra \n before printing run status
      Enable completion latency percentiles by default
      Disable clat percentiles if gtod_reduce=1 is set
      Adapt clat percentiles for min/max values
      client/server: add support for passing disk_util structures
      Break double loop on end-of-clat percentiles
      Silence uninitialized mem warning on disk_util send
      Update TODO
      Add IOPS to terse output
      Don't output version for terse output
      Add completion latency percentiles to terse output format
      Add disk utilization to terse format output
      Move IEEE754 support code to lib/
      Check string length of ts->description, not value
      Fio 1.99.6
      Update man page
      Man page typo
      Only print ts->description if set for non-terse output

Martin Steigerwald (1):
      Escape minus signs in manpage to fix lintian warning:

 HOWTO                  |   29 ++-
 Makefile               |   32 +-
 README                 |   69 +++-
 SERVER-TODO            |    2 +
 arch/arch-alpha.h      |    2 +-
 arch/arch-arm.h        |    2 +-
 arch/arch-generic.h    |    2 +-
 arch/arch-hppa.h       |    2 +-
 arch/arch-ia64.h       |    2 +-
 arch/arch-mips.h       |    2 +-
 arch/arch-ppc.h        |    2 +-
 arch/arch-s390.h       |    2 +-
 arch/arch-sh.h         |    2 +-
 arch/arch-sparc.h      |    2 +-
 arch/arch-sparc64.h    |    2 +-
 arch/arch-x86.h        |    2 +-
 arch/arch-x86_64.h     |    2 +-
 arch/arch.h            |    4 +-
 client.c               |  995 ++++++++++++++++++++++++++++++++++++++++++
 crc/crc16.c            |    5 +-
 crc/crc16.h            |    2 +-
 debug.c                |    4 +-
 debug.h                |    1 +
 diskutil.c             |  194 +++++----
 diskutil.h             |   40 ++-
 engines/net.c          |  209 +++++++--
 eta.c                  |  163 ++++---
 examples/netio         |    9 +-
 filehash.c             |    4 +-
 fio.1                  |  128 +++++-
 fio.c                  |  261 +++++++++---
 fio.h                  |  216 ++--------
 fio_generate_plots     |   18 +
 fio_version.h          |    8 +
 hash.h                 |   77 ++++
 init.c                 |  429 +++++++++++++------
 io_u.c                 |    5 +-
 iolog.c                |  541 +++++++++++++++++++++++
 iolog.h                |   14 +-
 lib/ieee754.c          |   84 ++++
 lib/ieee754.h          |   20 +
 log.c                  |  574 +++----------------------
 log.h                  |   20 +-
 options.c              |   49 ++-
 os/os-aix.h            |   13 +
 os/os-freebsd.h        |   14 +
 os/os-hpux.h           |   14 +
 os/os-linux.h          |   19 +-
 os/os-mac.h            |   16 +
 os/os-netbsd.h         |   13 +
 os/os-solaris.h        |   13 +
 os/os-windows.h        |   11 +
 os/os.h                |   82 ++++
 os/windows/install.wxs |    4 +-
 os/windows/version.h   |   10 +-
 parse.c                |  107 +++---
 server.c               | 1134 ++++++++++++++++++++++++++++++++++++++++++++++++
 server.h               |  144 ++++++
 stat.c                 |  494 ++++++++++++++-------
 stat.h                 |  201 +++++++++
 t/ieee754.c            |   21 +
 t/log.c                |   15 +
 62 files changed, 5162 insertions(+), 1395 deletions(-)
 create mode 100644 SERVER-TODO
 create mode 100644 client.c
 create mode 100644 fio_version.h
 create mode 100644 iolog.c
 create mode 100644 lib/ieee754.c
 create mode 100644 lib/ieee754.h
 create mode 100644 server.c
 create mode 100644 server.h
 create mode 100644 stat.h
 create mode 100644 t/ieee754.c
 create mode 100644 t/log.c

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cc2df9b..a8d5197 100644
--- a/HOWTO
+++ b/HOWTO
@@ -267,7 +267,7 @@ filename=str	Fio normally makes up a filename based on the job name,
 		files between threads in a job or several jobs, specify
 		a filename for each of them to override the default. If
 		the ioengine used is 'net', the filename is the host, port,
-		and protocol to use in the format of =host/port/protocol.
+		and protocol to use in the format of =host,port,protocol.
 		See ioengine=net for more. If the ioengine is file based, you
 		can specify a number of files by separating the names with a
 		':' colon. So if you wanted a job to open /dev/sda and /dev/sdb
@@ -864,6 +864,9 @@ exitall		When one job finishes, terminate the rest. The default is
 bwavgtime=int	Average the calculated bandwidth over the given time. Value
 		is specified in milliseconds.
 
+iopsavgtime=int	Average the calculated IOPS over the given time. Value
+		is specified in milliseconds.
+
 create_serialize=bool	If true, serialize the file creating for the jobs.
 			This may be handy to avoid interleaving of data
 			files, which may greatly depend on the filesystem
@@ -1104,6 +1107,9 @@ write_lat_log=str Same as write_bw_log, except that this option stores io
 		and foo_lat.log. This helps fio_generate_plot fine the logs
 		automatically.
 
+write_bw_log=str If given, write an IOPS log of the jobs in this job
+		file. See write_bw_log.
+
 lockmem=int	Pin down the specified amount of memory with mlock(2). Can
 		potentially be used instead of removing memory or booting
 		with less memory to simulate a smaller amount of memory.
@@ -1356,25 +1362,42 @@ Split up, the format is as follows:
 
 	version, jobname, groupid, error
 	READ status:
-		Total IO (KB), bandwidth (KB/sec), runtime (msec)
+		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
 		Submission latency: min, max, mean, deviation
 		Completion latency: min, max, mean, deviation
+		Completion latency percentiles: 20 fields (see below)
 		Total latency: min, max, mean, deviation
 		Bw: min, max, aggregate percentage of total, mean, deviation
 	WRITE status:
-		Total IO (KB), bandwidth (KB/sec), runtime (msec)
+		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
 		Submission latency: min, max, mean, deviation
 		Completion latency: min, max, mean, deviation
+		Completion latency percentiles: 20 fields (see below)
 		Total latency: min, max, mean, deviation
 		Bw: min, max, aggregate percentage of total, mean, deviation
 	CPU usage: user, system, context switches, major faults, minor faults
 	IO depths: <=1, 2, 4, 8, 16, 32, >=64
 	IO latencies microseconds: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000
 	IO latencies milliseconds: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, 2000, >=2000
+	Disk utilization: Disk name, Read ios, write ios,
+			  Read merges, write merges,
+			  Read ticks, write ticks,
+			  Read in-queue time, write in-queue time,
+			  Disk utilization percentage
 	Additional Info (dependant on continue_on_error, default off): total # errors, first error code 
 	
 	Additional Info (dependant on description being set): Text description
 
+Completion latency percentiles can be a grouping of up to 20 sets, so
+for the terse output fio writes all of them. Each field will look like this:
+
+	1.00%=6112
+
+which is the Xth percentile, and the usec latency associated with it.
+
+For disk utilization, all disks used by fio are shown. So for each disk
+there will be a disk utilization section.
+
 
 8.0 Trace file format
 ---------------------
diff --git a/Makefile b/Makefile
index 85942a0..6a3f85b 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@ CC	= gcc
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 \
 	$(DEBUGFLAGS)
-OPTFLAGS= -O2 -fno-omit-frame-pointer -g $(EXTFLAGS)
+OPTFLAGS= -O3 -fno-omit-frame-pointer -g $(EXTFLAGS)
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS)
 LIBS	= -lm $(EXTLIBS)
 PROGS	= fio
@@ -12,9 +12,9 @@ UNAME  := $(shell uname)
 SOURCE = gettime.c fio.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
-		lib/num2str.c $(wildcard crc/*.c) engines/cpu.c \
+		lib/num2str.c lib/ieee754.c $(wildcard crc/*.c) engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		memalign.c
+		memalign.c server.c client.c iolog.c
 
 ifeq ($(UNAME), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c helpers.c cgroup.c trim.c \
@@ -22,7 +22,7 @@ ifeq ($(UNAME), Linux)
 		engines/splice.c engines/syslet-rw.c engines/guasi.c \
 		engines/binject.c engines/rdma.c profiles/tiobench.c
   LIBS += -lpthread -ldl -lrt -laio
-  CFLAGS += -rdynamic
+  LDFLAGS += -rdynamic
 endif
 ifeq ($(UNAME), SunOS)
   SOURCE += fifo.c lib/strsep.c helpers.c engines/posixaio.c \
@@ -33,12 +33,12 @@ endif
 ifeq ($(UNAME), FreeBSD)
   SOURCE += helpers.c engines/posixaio.c
   LIBS	 += -lpthread -lrt
-  CFLAGS += -rdynamic
+  LDFLAGS += -rdynamic
 endif
 ifeq ($(UNAME), NetBSD)
   SOURCE += helpers.c engines/posixaio.c
   LIBS	 += -lpthread -lrt
-  CFLAGS += -rdynamic
+  LDFLAGS += -rdynamic
 endif
 ifeq ($(UNAME), AIX)
   SOURCE += fifo.c helpers.c lib/getopt_long.c engines/posixaio.c
@@ -63,9 +63,16 @@ endif
 
 OBJS = $(SOURCE:.c=.o)
 
-T_OBJS = t/stest.o
-T_OBJS += mutex.o smalloc.o
-T_PROGS = t/stest
+T_SMALLOC_OBJS = t/stest.o
+T_SMALLOC_OBJS += mutex.o smalloc.o t/log.o
+T_SMALLOC_PROGS = t/stest
+
+T_IEEE_OBJS = t/ieee754.o
+T_IEEE_OBJS += ieee754.o
+T_IEEE_PROGS = t/ieee754
+
+T_OBJS = $(T_SMALLOC_OBJS)
+T_OBJS += $(T_IEEE_OBJS)
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
@@ -84,8 +91,11 @@ all: .depend $(PROGS) $(SCRIPTS)
 .c.o: .depend
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
 
-t/stest: $(T_OBJS)
-	$(QUIET_CC)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_OBJS) $(LIBS) $(LDFLAGS)
+t/stest: $(T_SMALLOC_OBJS)
+	$(QUIET_CC)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_SMALLOC_OBJS) $(LIBS) $(LDFLAGS)
+
+t/ieee754: $(T_IEEE_OBJS)
+	$(QUIET_CC)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IEEE_OBJS) $(LIBS) $(LDFLAGS)
 
 fio: $(OBJS)
 	$(QUIET_CC)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(OBJS) $(LIBS) $(LDFLAGS)
diff --git a/README b/README
index 0eac41f..26b5909 100644
--- a/README
+++ b/README
@@ -133,23 +133,25 @@ $ fio
 	--debug			Enable some debugging options (see below)
 	--output		Write output to file
 	--timeout		Runtime in seconds
-	--latency-log	Generate per-job latency logs
-	--bandwidth-log	Generate per-job bandwidth logs
+	--latency-log		Generate per-job latency logs
+	--bandwidth-log		Generate per-job bandwidth logs
 	--minimal		Minimal (terse) output
 	--version		Print version info and exit
 	--terse-version=type	Terse version output format
 	--help			Print this page
-	--cmdhelp=cmd	Print command help, "all" for all of them
+	--cmdhelp=cmd		Print command help, "all" for all of them
 	--showcmd		Turn a job file into command line options
 	--readonly		Turn on safety read-only checks, preventing
-					writes
+				writes
 	--eta=when		When ETA estimate should be printed
-					May be "always", "never" or "auto"
-	--section=name	Only run specified section in job file. Multiple
-				sections can be specified.
+				May be "always", "never" or "auto"
+	--section=name		Only run specified section in job file.
+				Multiple sections can be specified.
 	--alloc-size=kb	Set smalloc pool to this size in kb (def 1024)
 	--warnings-fatal Fio parser warnings are fatal
 	--max-jobs		Maximum number of threads/processes to support
+	--server=args		Start backend server. See Client/Server section.
+	--client=host		Connect to specified backend.
 
 
 Any parameters following the options will be assumed to be job files,
@@ -315,6 +317,59 @@ The job file parameters are:
 
 
 
+Client/server
+------------
+
+Normally you would run fio as a stand-alone application on the machine
+where the IO workload should be generated. However, it is also possible to
+run the frontend and backend of fio separately. This makes it possible to
+have a fio server running on the machine(s) where the IO workload should
+be running, while controlling it from another machine.
+
+To start the server, you would do:
+
+fio --server=args
+
+on that machine, where args defines what fio listens to. The arguments
+are of the form 'type:hostname or IP:port'. 'type' is either 'ip' for
+TCP/IP, or 'sock' for a local unix domain socket. 'hostname' is either
+a hostname or IP address, and 'port' is the port to listen to (only valid
+for TCP/IP, not a local socket). Some examples:
+
+1) fio --server
+
+   Start a fio server, listening on all interfaces on the default port (8765).
+
+2) fio --server=ip:hostname:4444
+
+   Start a fio server, listening on IP belonging to hostname and on port 4444.
+
+3) fio --server=:4444
+
+   Start a fio server, listening on all interfaces on port 4444.
+
+4) fio --server=1.2.3.4
+
+   Start a fio server, listening on IP 1.2.3.4 on the default port.
+
+5) fio --server=sock:/tmp/fio.sock
+
+   Start a fio server, listening on the local socket /tmp/fio.sock.
+
+When a server is running, you can connect to it from a client. The client
+is run with:
+
+fio --local-args --client=server --remote-args <job file(s)>
+
+where --local-args are arguments that are local to the client where it is
+running, 'server' is the connect string, and --remote-args and <job file(s)>
+are sent to the server. The 'server' string follows the same format as it
+does on the server side, to allow IP/hostname/socket and port strings.
+You can connect to multiple clients as well, to do that you could run:
+
+fio --client=server2 --client=server2 <job file(s)>
+
+
 Platforms
 ---------
 
diff --git a/SERVER-TODO b/SERVER-TODO
new file mode 100644
index 0000000..b988405
--- /dev/null
+++ b/SERVER-TODO
@@ -0,0 +1,2 @@
+- Collate ETA output from multiple connections into 1
+- If group_reporting is set, collate final output from multiple connections
diff --git a/arch/arch-alpha.h b/arch/arch-alpha.h
index e8132a0..c0f784f 100644
--- a/arch/arch-alpha.h
+++ b/arch/arch-alpha.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_ALPHA_H
 #define ARCH_ALPHA_H
 
-#define ARCH	(arch_alpha)
+#define FIO_ARCH	(arch_alpha)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		442
diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index b0cfd80..658b688 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_ARM_H
 #define ARCH_ARM_H
 
-#define ARCH	(arch_arm)
+#define FIO_ARCH	(arch_arm)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		314
diff --git a/arch/arch-generic.h b/arch/arch-generic.h
index c7b0ca0..a0b71f8 100644
--- a/arch/arch-generic.h
+++ b/arch/arch-generic.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_GENERIC_H
 #define ARCH_GENERIC_H
 
-#define ARCH	(arch_generic)
+#define FIO_ARCH	(arch_generic)
 
 #define nop			do { } while (0)
 #define read_barrier()		__asm__ __volatile__("": : :"memory")
diff --git a/arch/arch-hppa.h b/arch/arch-hppa.h
index c865a89..c1c079e 100644
--- a/arch/arch-hppa.h
+++ b/arch/arch-hppa.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_HPPA_H
 #define ARCH_HPPA_H
 
-#define ARCH	(arch_hppa)
+#define FIO_ARCH	(arch_hppa)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		267
diff --git a/arch/arch-ia64.h b/arch/arch-ia64.h
index 056f636..f4464c4 100644
--- a/arch/arch-ia64.h
+++ b/arch/arch-ia64.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_IA64_H
 #define ARCH_IA64_H
 
-#define ARCH	(arch_ia64)
+#define FIO_ARCH	(arch_ia64)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		1274
diff --git a/arch/arch-mips.h b/arch/arch-mips.h
index 759d3a9..0b781d1 100644
--- a/arch/arch-mips.h
+++ b/arch/arch-mips.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_MIPS64_H
 #define ARCH_MIPS64_H
 
-#define ARCH	(arch_mips)
+#define FIO_ARCH	(arch_mips)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		314
diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index d495a1b..b790a55 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_PPC_H
 #define ARCH_PPH_H
 
-#define ARCH	(arch_ppc)
+#define FIO_ARCH	(arch_ppc)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		273
diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index 0647750..fe51791 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_S390_H
 #define ARCH_S390_H
 
-#define ARCH	(arch_s390)
+#define FIO_ARCH	(arch_s390)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		282
diff --git a/arch/arch-sh.h b/arch/arch-sh.h
index f5f313d..9acbbbe 100644
--- a/arch/arch-sh.h
+++ b/arch/arch-sh.h
@@ -3,7 +3,7 @@
 #ifndef ARCH_SH_H
 #define ARCH_SH_H
 
-#define ARCH	(arch_sh)
+#define FIO_ARCH	(arch_sh)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set	288
diff --git a/arch/arch-sparc.h b/arch/arch-sparc.h
index cd552ab..fe47b80 100644
--- a/arch/arch-sparc.h
+++ b/arch/arch-sparc.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_SPARC_H
 #define ARCH_SPARC_H
 
-#define ARCH	(arch_sparc)
+#define FIO_ARCH	(arch_sparc)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		196
diff --git a/arch/arch-sparc64.h b/arch/arch-sparc64.h
index 332cf91..e793ae5 100644
--- a/arch/arch-sparc64.h
+++ b/arch/arch-sparc64.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_SPARC64_H
 #define ARCH_SPARC64_H
 
-#define ARCH	(arch_sparc64)
+#define FIO_ARCH	(arch_sparc64)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		196
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index 2e803cb..1ededd8 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_X86_H
 #define ARCH_X86_H
 
-#define ARCH	(arch_i386)
+#define FIO_ARCH	(arch_i386)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		289
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index f2dcf49..29e681f 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -1,7 +1,7 @@
 #ifndef ARCH_X86_64_h
 #define ARCH_X86_64_h
 
-#define ARCH	(arch_x86_64)
+#define FIO_ARCH	(arch_x86_64)
 
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		251
diff --git a/arch/arch.h b/arch/arch.h
index d598652..4ad49a4 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -8,7 +8,7 @@
 #endif
 
 enum {
-	arch_x86_64,
+	arch_x86_64 = 1,
 	arch_i386,
 	arch_ppc,
 	arch_ia64,
@@ -21,6 +21,8 @@ enum {
 	arch_hppa,
 
 	arch_generic,
+
+	arch_nr,
 };
 
 enum {
diff --git a/client.c b/client.c
new file mode 100644
index 0000000..c72f034
--- /dev/null
+++ b/client.c
@@ -0,0 +1,995 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/poll.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <signal.h>
+
+#include "fio.h"
+#include "server.h"
+#include "flist.h"
+#include "hash.h"
+
+struct client_eta {
+	struct jobs_eta eta;
+	unsigned int pending;
+};
+
+struct fio_client {
+	struct flist_head list;
+	struct flist_head hash_list;
+	struct flist_head arg_list;
+	struct sockaddr_in addr;
+	struct sockaddr_un addr_un;
+	char *hostname;
+	int port;
+	int fd;
+
+	char *name;
+
+	int state;
+
+	int skip_newline;
+	int is_sock;
+	int disk_stats_shown;
+
+	struct flist_head eta_list;
+	struct client_eta *eta_in_flight;
+
+	struct flist_head cmd_list;
+
+	uint16_t argc;
+	char **argv;
+};
+
+static struct timeval eta_tv;
+
+enum {
+	Client_created		= 0,
+	Client_connected	= 1,
+	Client_started		= 2,
+	Client_stopped		= 3,
+	Client_exited		= 4,
+};
+
+static FLIST_HEAD(client_list);
+static FLIST_HEAD(eta_list);
+
+static FLIST_HEAD(arg_list);
+
+static struct thread_stat client_ts;
+static struct group_run_stats client_gs;
+static int sum_stat_clients;
+static int sum_stat_nr;
+
+#define FIO_CLIENT_HASH_BITS	7
+#define FIO_CLIENT_HASH_SZ	(1 << FIO_CLIENT_HASH_BITS)
+#define FIO_CLIENT_HASH_MASK	(FIO_CLIENT_HASH_SZ - 1)
+static struct flist_head client_hash[FIO_CLIENT_HASH_SZ];
+
+static int handle_client(struct fio_client *client);
+static void dec_jobs_eta(struct client_eta *eta);
+
+static void fio_client_add_hash(struct fio_client *client)
+{
+	int bucket = hash_long(client->fd, FIO_CLIENT_HASH_BITS);
+
+	bucket &= FIO_CLIENT_HASH_MASK;
+	flist_add(&client->hash_list, &client_hash[bucket]);
+}
+
+static void fio_client_remove_hash(struct fio_client *client)
+{
+	if (!flist_empty(&client->hash_list))
+		flist_del_init(&client->hash_list);
+}
+
+static void fio_init fio_client_hash_init(void)
+{
+	int i;
+
+	for (i = 0; i < FIO_CLIENT_HASH_SZ; i++)
+		INIT_FLIST_HEAD(&client_hash[i]);
+}
+
+static struct fio_client *find_client_by_fd(int fd)
+{
+	int bucket = hash_long(fd, FIO_CLIENT_HASH_BITS) & FIO_CLIENT_HASH_MASK;
+	struct fio_client *client;
+	struct flist_head *entry;
+
+	flist_for_each(entry, &client_hash[bucket]) {
+		client = flist_entry(entry, struct fio_client, hash_list);
+
+		if (client->fd == fd)
+			return client;
+	}
+
+	return NULL;
+}
+
+static void remove_client(struct fio_client *client)
+{
+	dprint(FD_NET, "client: removed <%s>\n", client->hostname);
+	flist_del(&client->list);
+
+	fio_client_remove_hash(client);
+
+	if (!flist_empty(&client->eta_list)) {
+		flist_del_init(&client->eta_list);
+		dec_jobs_eta(client->eta_in_flight);
+	}
+
+	free(client->hostname);
+	if (client->argv)
+		free(client->argv);
+	if (client->name)
+		free(client->name);
+
+	free(client);
+	nr_clients--;
+	sum_stat_clients--;
+}
+
+static void __fio_client_add_cmd_option(struct fio_client *client,
+					const char *opt)
+{
+	int index;
+
+	index = client->argc++;
+	client->argv = realloc(client->argv, sizeof(char *) * client->argc);
+	client->argv[index] = strdup(opt);
+	dprint(FD_NET, "client: add cmd %d: %s\n", index, opt);
+}
+
+void fio_client_add_cmd_option(void *cookie, const char *opt)
+{
+	struct fio_client *client = cookie;
+	struct flist_head *entry;
+
+	if (!client || !opt)
+		return;
+
+	__fio_client_add_cmd_option(client, opt);
+
+	/*
+	 * Duplicate arguments to shared client group
+	 */
+	flist_for_each(entry, &arg_list) {
+		client = flist_entry(entry, struct fio_client, arg_list);
+
+		__fio_client_add_cmd_option(client, opt);
+	}
+}
+
+int fio_client_add(const char *hostname, void **cookie)
+{
+	struct fio_client *existing = *cookie;
+	struct fio_client *client;
+
+	if (existing) {
+		/*
+		 * We always add our "exec" name as the option, hence 1
+		 * means empty.
+		 */
+		if (existing->argc == 1)
+			flist_add_tail(&existing->arg_list, &arg_list);
+		else {
+			while (!flist_empty(&arg_list))
+				flist_del_init(arg_list.next);
+		}
+	}
+
+	client = malloc(sizeof(*client));
+	memset(client, 0, sizeof(*client));
+
+	INIT_FLIST_HEAD(&client->list);
+	INIT_FLIST_HEAD(&client->hash_list);
+	INIT_FLIST_HEAD(&client->arg_list);
+	INIT_FLIST_HEAD(&client->eta_list);
+	INIT_FLIST_HEAD(&client->cmd_list);
+
+	if (fio_server_parse_string(hostname, &client->hostname,
+					&client->is_sock, &client->port,
+					&client->addr.sin_addr))
+		return -1;
+
+	client->fd = -1;
+
+	__fio_client_add_cmd_option(client, "fio");
+
+	flist_add(&client->list, &client_list);
+	nr_clients++;
+	dprint(FD_NET, "client: added <%s>\n", client->hostname);
+	*cookie = client;
+	return 0;
+}
+
+static int fio_client_connect_ip(struct fio_client *client)
+{
+	int fd;
+
+	client->addr.sin_family = AF_INET;
+	client->addr.sin_port = htons(client->port);
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("fio: socket: %s\n", strerror(errno));
+		return -1;
+	}
+
+	if (connect(fd, (struct sockaddr *) &client->addr, sizeof(client->addr)) < 0) {
+		log_err("fio: connect: %s\n", strerror(errno));
+		log_err("fio: failed to connect to %s:%u\n", client->hostname,
+								client->port);
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static int fio_client_connect_sock(struct fio_client *client)
+{
+	struct sockaddr_un *addr = &client->addr_un;
+	fio_socklen_t len;
+	int fd;
+
+	memset(addr, 0, sizeof(*addr));
+	addr->sun_family = AF_UNIX;
+	strcpy(addr->sun_path, client->hostname);
+
+	fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("fio: socket: %s\n", strerror(errno));
+		return -1;
+	}
+
+	len = sizeof(addr->sun_family) + strlen(addr->sun_path) + 1;
+	if (connect(fd, (struct sockaddr *) addr, len) < 0) {
+		log_err("fio: connect; %s\n", strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static int fio_client_connect(struct fio_client *client)
+{
+	int fd;
+
+	dprint(FD_NET, "client: connect to host %s\n", client->hostname);
+
+	if (client->is_sock)
+		fd = fio_client_connect_sock(client);
+	else
+		fd = fio_client_connect_ip(client);
+
+	dprint(FD_NET, "client: %s connected %d\n", client->hostname, fd);
+
+	if (fd < 0)
+		return 1;
+
+	client->fd = fd;
+	fio_client_add_hash(client);
+	client->state = Client_connected;
+	return 0;
+}
+
+void fio_clients_terminate(void)
+{
+	struct flist_head *entry;
+	struct fio_client *client;
+
+	dprint(FD_NET, "client: terminate clients\n");
+
+	flist_for_each(entry, &client_list) {
+		client = flist_entry(entry, struct fio_client, list);
+
+		fio_net_send_simple_cmd(client->fd, FIO_NET_CMD_QUIT, 0, NULL);
+	}
+}
+
+static void sig_int(int sig)
+{
+	dprint(FD_NET, "client: got signal %d\n", sig);
+	fio_clients_terminate();
+}
+
+static void client_signal_handler(void)
+{
+	struct sigaction act;
+
+	memset(&act, 0, sizeof(act));
+	act.sa_handler = sig_int;
+	act.sa_flags = SA_RESTART;
+	sigaction(SIGINT, &act, NULL);
+
+	memset(&act, 0, sizeof(act));
+	act.sa_handler = sig_int;
+	act.sa_flags = SA_RESTART;
+	sigaction(SIGTERM, &act, NULL);
+}
+
+static void probe_client(struct fio_client *client)
+{
+	dprint(FD_NET, "client: send probe\n");
+
+	fio_net_send_simple_cmd(client->fd, FIO_NET_CMD_PROBE, 0, &client->cmd_list);
+}
+
+static int send_client_cmd_line(struct fio_client *client)
+{
+	struct cmd_single_line_pdu *cslp;
+	struct cmd_line_pdu *clp;
+	unsigned long offset;
+	unsigned int *lens;
+	void *pdu;
+	size_t mem;
+	int i, ret;
+
+	dprint(FD_NET, "client: send cmdline %d\n", client->argc);
+
+	lens = malloc(client->argc * sizeof(unsigned int));
+
+	/*
+	 * Find out how much mem we need
+	 */
+	for (i = 0, mem = 0; i < client->argc; i++) {
+		lens[i] = strlen(client->argv[i]) + 1;
+		mem += lens[i];
+	}
+
+	/*
+	 * We need one cmd_line_pdu, and argc number of cmd_single_line_pdu
+	 */
+	mem += sizeof(*clp) + (client->argc * sizeof(*cslp));
+
+	pdu = malloc(mem);
+	clp = pdu;
+	offset = sizeof(*clp);
+
+	for (i = 0; i < client->argc; i++) {
+		uint16_t arg_len = lens[i];
+
+		cslp = pdu + offset;
+		strcpy((char *) cslp->text, client->argv[i]);
+		cslp->len = cpu_to_le16(arg_len);
+		offset += sizeof(*cslp) + arg_len;
+	}
+
+	free(lens);
+	clp->lines = cpu_to_le16(client->argc);
+	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_JOBLINE, pdu, mem, 0);
+	free(pdu);
+	return ret;
+}
+
+int fio_clients_connect(void)
+{
+	struct fio_client *client;
+	struct flist_head *entry, *tmp;
+	int ret;
+
+	dprint(FD_NET, "client: connect all\n");
+
+	client_signal_handler();
+
+	flist_for_each_safe(entry, tmp, &client_list) {
+		client = flist_entry(entry, struct fio_client, list);
+
+		ret = fio_client_connect(client);
+		if (ret) {
+			remove_client(client);
+			continue;
+		}
+
+		probe_client(client);
+
+		if (client->argc > 1)
+			send_client_cmd_line(client);
+	}
+
+	return !nr_clients;
+}
+
+/*
+ * Send file contents to server backend. We could use sendfile(), but to remain
+ * more portable lets just read/write the darn thing.
+ */
+static int fio_client_send_ini(struct fio_client *client, const char *filename)
+{
+	struct stat sb;
+	char *p, *buf;
+	off_t len;
+	int fd, ret;
+
+	dprint(FD_NET, "send ini %s to %s\n", filename, client->hostname);
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0) {
+		log_err("fio: job file <%s> open: %s\n", filename, strerror(errno));
+		return 1;
+	}
+
+	if (fstat(fd, &sb) < 0) {
+		log_err("fio: job file stat: %s\n", strerror(errno));
+		close(fd);
+		return 1;
+	}
+
+	buf = malloc(sb.st_size);
+
+	len = sb.st_size;
+	p = buf;
+	do {
+		ret = read(fd, p, len);
+		if (ret > 0) {
+			len -= ret;
+			if (!len)
+				break;
+			p += ret;
+			continue;
+		} else if (!ret)
+			break;
+		else if (errno == EAGAIN || errno == EINTR)
+			continue;
+	} while (1);
+
+	if (len) {
+		log_err("fio: failed reading job file %s\n", filename);
+		close(fd);
+		free(buf);
+		return 1;
+	}
+
+	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_JOB, buf, sb.st_size, 0);
+	free(buf);
+	close(fd);
+	return ret;
+}
+
+int fio_clients_send_ini(const char *filename)
+{
+	struct fio_client *client;
+	struct flist_head *entry, *tmp;
+
+	flist_for_each_safe(entry, tmp, &client_list) {
+		client = flist_entry(entry, struct fio_client, list);
+
+		if (fio_client_send_ini(client, filename))
+			remove_client(client);
+	}
+
+	return !nr_clients;
+}
+
+static void convert_io_stat(struct io_stat *dst, struct io_stat *src)
+{
+	dst->max_val	= le64_to_cpu(src->max_val);
+	dst->min_val	= le64_to_cpu(src->min_val);
+	dst->samples	= le64_to_cpu(src->samples);
+
+	/*
+	 * Floats arrive as IEEE 754 encoded uint64_t, convert back to double
+	 */
+	dst->mean.u.f	= fio_uint64_to_double(le64_to_cpu(dst->mean.u.i));
+	dst->S.u.f	= fio_uint64_to_double(le64_to_cpu(dst->S.u.i));
+}
+
+static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
+{
+	int i, j;
+
+	dst->error	= le32_to_cpu(src->error);
+	dst->groupid	= le32_to_cpu(src->groupid);
+	dst->pid	= le32_to_cpu(src->pid);
+	dst->members	= le32_to_cpu(src->members);
+
+	for (i = 0; i < 2; i++) {
+		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]);
+		convert_io_stat(&dst->slat_stat[i], &src->slat_stat[i]);
+		convert_io_stat(&dst->lat_stat[i], &src->lat_stat[i]);
+		convert_io_stat(&dst->bw_stat[i], &src->bw_stat[i]);
+	}
+
+	dst->usr_time		= le64_to_cpu(src->usr_time);
+	dst->sys_time		= le64_to_cpu(src->sys_time);
+	dst->ctx		= le64_to_cpu(src->ctx);
+	dst->minf		= le64_to_cpu(src->minf);
+	dst->majf		= le64_to_cpu(src->majf);
+	dst->clat_percentiles	= le64_to_cpu(src->clat_percentiles);
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
+		fio_fp64_t *fps = &src->percentile_list[i];
+		fio_fp64_t *fpd = &dst->percentile_list[i];
+
+		fpd->u.f = fio_uint64_to_double(le64_to_cpu(fps->u.i));
+	}
+
+	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
+		dst->io_u_map[i]	= le32_to_cpu(src->io_u_map[i]);
+		dst->io_u_submit[i]	= le32_to_cpu(src->io_u_submit[i]);
+		dst->io_u_complete[i]	= le32_to_cpu(src->io_u_complete[i]);
+	}
+
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++) {
+		dst->io_u_lat_u[i]	= le32_to_cpu(src->io_u_lat_u[i]);
+		dst->io_u_lat_m[i]	= le32_to_cpu(src->io_u_lat_m[i]);
+	}
+
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
+			dst->io_u_plat[i][j] = le32_to_cpu(src->io_u_plat[i][j]);
+
+	for (i = 0; i < 3; i++) {
+		dst->total_io_u[i]	= le64_to_cpu(src->total_io_u[i]);
+		dst->short_io_u[i]	= le64_to_cpu(src->short_io_u[i]);
+	}
+
+	dst->total_submit	= le64_to_cpu(src->total_submit);
+	dst->total_complete	= le64_to_cpu(src->total_complete);
+
+	for (i = 0; i < 2; i++) {
+		dst->io_bytes[i]	= le64_to_cpu(src->io_bytes[i]);
+		dst->runtime[i]		= le64_to_cpu(src->runtime[i]);
+	}
+
+	dst->total_run_time	= le64_to_cpu(src->total_run_time);
+	dst->continue_on_error	= le16_to_cpu(src->continue_on_error);
+	dst->total_err_count	= le64_to_cpu(src->total_err_count);
+	dst->first_error	= le32_to_cpu(src->first_error);
+	dst->kb_base		= le32_to_cpu(src->kb_base);
+}
+
+static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		dst->max_run[i]		= le64_to_cpu(src->max_run[i]);
+		dst->min_run[i]		= le64_to_cpu(src->min_run[i]);
+		dst->max_bw[i]		= le64_to_cpu(src->max_bw[i]);
+		dst->min_bw[i]		= le64_to_cpu(src->min_bw[i]);
+		dst->io_kb[i]		= le64_to_cpu(src->io_kb[i]);
+		dst->agg[i]		= le64_to_cpu(src->agg[i]);
+	}
+
+	dst->kb_base	= le32_to_cpu(src->kb_base);
+	dst->groupid	= le32_to_cpu(src->groupid);
+}
+
+static void handle_ts(struct fio_net_cmd *cmd)
+{
+	struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
+
+	convert_ts(&p->ts, &p->ts);
+	convert_gs(&p->rs, &p->rs);
+
+	show_thread_status(&p->ts, &p->rs);
+
+	if (sum_stat_clients == 1)
+		return;
+
+	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr);
+	sum_group_stats(&client_gs, &p->rs);
+
+	client_ts.members++;
+	client_ts.groupid = p->ts.groupid;
+
+	if (++sum_stat_nr == sum_stat_clients) {
+		strcpy(client_ts.name, "All clients");
+		show_thread_status(&client_ts, &client_gs);
+	}
+}
+
+static void handle_gs(struct fio_net_cmd *cmd)
+{
+	struct group_run_stats *gs = (struct group_run_stats *) cmd->payload;
+
+	convert_gs(gs, gs);
+	show_group_stats(gs);
+}
+
+static void convert_agg(struct disk_util_agg *agg)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		agg->ios[i]	= le32_to_cpu(agg->ios[i]);
+		agg->merges[i]	= le32_to_cpu(agg->merges[i]);
+		agg->sectors[i]	= le64_to_cpu(agg->sectors[i]);
+		agg->ticks[i]	= le32_to_cpu(agg->ticks[i]);
+	}
+
+	agg->io_ticks		= le32_to_cpu(agg->io_ticks);
+	agg->time_in_queue	= le32_to_cpu(agg->time_in_queue);
+	agg->slavecount		= le32_to_cpu(agg->slavecount);
+	agg->max_util.u.f	= __le64_to_cpu(fio_uint64_to_double(agg->max_util.u.i));
+}
+
+static void convert_dus(struct disk_util_stat *dus)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		dus->ios[i]	= le32_to_cpu(dus->ios[i]);
+		dus->merges[i]	= le32_to_cpu(dus->merges[i]);
+		dus->sectors[i]	= le64_to_cpu(dus->sectors[i]);
+		dus->ticks[i]	= le32_to_cpu(dus->ticks[i]);
+	}
+
+	dus->io_ticks		= le32_to_cpu(dus->io_ticks);
+	dus->time_in_queue	= le32_to_cpu(dus->time_in_queue);
+	dus->msec		= le64_to_cpu(dus->msec);
+}
+
+static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
+{
+	struct cmd_du_pdu *du = (struct cmd_du_pdu *) cmd->payload;
+
+	convert_dus(&du->dus);
+	convert_agg(&du->agg);
+
+	if (!client->disk_stats_shown) {
+		client->disk_stats_shown = 1;
+		log_info("\nDisk stats (read/write):\n");
+	}
+
+	print_disk_util(&du->dus, &du->agg, terse_output);
+}
+
+static void convert_jobs_eta(struct jobs_eta *je)
+{
+	int i;
+
+	je->nr_running		= le32_to_cpu(je->nr_running);
+	je->nr_ramp		= le32_to_cpu(je->nr_ramp);
+	je->nr_pending		= le32_to_cpu(je->nr_pending);
+	je->files_open		= le32_to_cpu(je->files_open);
+	je->m_rate		= le32_to_cpu(je->m_rate);
+	je->t_rate		= le32_to_cpu(je->t_rate);
+	je->m_iops		= le32_to_cpu(je->m_iops);
+	je->t_iops		= le32_to_cpu(je->t_iops);
+
+	for (i = 0; i < 2; i++) {
+		je->rate[i]	= le32_to_cpu(je->rate[i]);
+		je->iops[i]	= le32_to_cpu(je->iops[i]);
+	}
+
+	je->elapsed_sec		= le64_to_cpu(je->elapsed_sec);
+	je->eta_sec		= le64_to_cpu(je->eta_sec);
+}
+
+static void sum_jobs_eta(struct jobs_eta *dst, struct jobs_eta *je)
+{
+	int i;
+
+	dst->nr_running		+= je->nr_running;
+	dst->nr_ramp		+= je->nr_ramp;
+	dst->nr_pending		+= je->nr_pending;
+	dst->files_open		+= je->files_open;
+	dst->m_rate		+= je->m_rate;
+	dst->t_rate		+= je->t_rate;
+	dst->m_iops		+= je->m_iops;
+	dst->t_iops		+= je->t_iops;
+
+	for (i = 0; i < 2; i++) {
+		dst->rate[i]	+= je->rate[i];
+		dst->iops[i]	+= je->iops[i];
+	}
+
+	dst->elapsed_sec	+= je->elapsed_sec;
+
+	if (je->eta_sec > dst->eta_sec)
+		dst->eta_sec = je->eta_sec;
+}
+
+static void dec_jobs_eta(struct client_eta *eta)
+{
+	if (!--eta->pending) {
+		display_thread_status(&eta->eta);
+		free(eta);
+	}
+}
+
+static void remove_reply_cmd(struct fio_client *client, struct fio_net_cmd *cmd)
+{
+	struct fio_net_int_cmd *icmd = NULL;
+	struct flist_head *entry;
+
+	flist_for_each(entry, &client->cmd_list) {
+		icmd = flist_entry(entry, struct fio_net_int_cmd, list);
+
+		if (cmd->tag == (uintptr_t) icmd)
+			break;
+
+		icmd = NULL;
+	}
+
+	if (!icmd) {
+		log_err("fio: client: unable to find matching tag\n");
+		return;
+	}
+
+	flist_del(&icmd->list);
+	cmd->tag = icmd->saved_tag;
+	free(icmd);
+}
+
+static void handle_eta(struct fio_client *client, struct fio_net_cmd *cmd)
+{
+	struct jobs_eta *je = (struct jobs_eta *) cmd->payload;
+	struct client_eta *eta = (struct client_eta *) (uintptr_t) cmd->tag;
+
+	dprint(FD_NET, "client: got eta tag %p, %d\n", eta, eta->pending);
+
+	assert(client->eta_in_flight == eta);
+
+	client->eta_in_flight = NULL;
+	flist_del_init(&client->eta_list);
+
+	convert_jobs_eta(je);
+	sum_jobs_eta(&eta->eta, je);
+	dec_jobs_eta(eta);
+}
+
+static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
+{
+	struct cmd_probe_pdu *probe = (struct cmd_probe_pdu *) cmd->payload;
+	const char *os, *arch;
+	char bit[16];
+
+	os = fio_get_os_string(probe->os);
+	if (!os)
+		os = "unknown";
+
+	arch = fio_get_arch_string(probe->arch);
+	if (!arch)
+		os = "unknown";
+
+	sprintf(bit, "%d-bit", probe->bpp * 8);
+
+	log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%u.%u.%u\n",
+		probe->hostname, probe->bigendian, bit, os, arch,
+		probe->fio_major, probe->fio_minor, probe->fio_patch);
+
+	if (!client->name)
+		client->name = strdup((char *) probe->hostname);
+}
+
+static int handle_client(struct fio_client *client)
+{
+	struct fio_net_cmd *cmd;
+
+	dprint(FD_NET, "client: handle %s\n", client->hostname);
+
+	cmd = fio_net_recv_cmd(client->fd);
+	if (!cmd)
+		return 0;
+
+	dprint(FD_NET, "client: got cmd op %s from %s\n",
+				fio_server_op(cmd->opcode), client->hostname);
+
+	switch (cmd->opcode) {
+	case FIO_NET_CMD_QUIT:
+		remove_client(client);
+		free(cmd);
+		break;
+	case FIO_NET_CMD_TEXT: {
+		const char *buf = (const char *) cmd->payload;
+		const char *name;
+		int fio_unused ret;
+
+		name = client->name ? client->name : client->hostname;
+
+		if (!client->skip_newline)
+			fprintf(f_out, "<%s> ", name);
+		ret = fwrite(buf, cmd->pdu_len, 1, f_out);
+		fflush(f_out);
+		client->skip_newline = strchr(buf, '\n') == NULL;
+		free(cmd);
+		break;
+		}
+	case FIO_NET_CMD_DU:
+		handle_du(client, cmd);
+		free(cmd);
+		break;
+	case FIO_NET_CMD_TS:
+		handle_ts(cmd);
+		free(cmd);
+		break;
+	case FIO_NET_CMD_GS:
+		handle_gs(cmd);
+		free(cmd);
+		break;
+	case FIO_NET_CMD_ETA:
+		remove_reply_cmd(client, cmd);
+		handle_eta(client, cmd);
+		free(cmd);
+		break;
+	case FIO_NET_CMD_PROBE:
+		remove_reply_cmd(client, cmd);
+		handle_probe(client, cmd);
+		free(cmd);
+		break;
+	case FIO_NET_CMD_START:
+		client->state = Client_started;
+		free(cmd);
+		break;
+	case FIO_NET_CMD_STOP:
+		client->state = Client_stopped;
+		free(cmd);
+		break;
+	default:
+		log_err("fio: unknown client op: %s\n", fio_server_op(cmd->opcode));
+		free(cmd);
+		break;
+	}
+
+	return 1;
+}
+
+static void request_client_etas(void)
+{
+	struct fio_client *client;
+	struct flist_head *entry;
+	struct client_eta *eta;
+	int skipped = 0;
+
+	dprint(FD_NET, "client: request eta (%d)\n", nr_clients);
+
+	eta = malloc(sizeof(*eta));
+	memset(&eta->eta, 0, sizeof(eta->eta));
+	eta->pending = nr_clients;
+
+	flist_for_each(entry, &client_list) {
+		client = flist_entry(entry, struct fio_client, list);
+
+		if (!flist_empty(&client->eta_list)) {
+			skipped++;
+			continue;
+		}
+
+		assert(!client->eta_in_flight);
+		flist_add_tail(&client->eta_list, &eta_list);
+		client->eta_in_flight = eta;
+		fio_net_send_simple_cmd(client->fd, FIO_NET_CMD_SEND_ETA,
+					(uintptr_t) eta, &client->cmd_list);
+	}
+
+	while (skipped--)
+		dec_jobs_eta(eta);
+
+	dprint(FD_NET, "client: requested eta tag %p\n", eta);
+}
+
+static int client_check_cmd_timeout(struct fio_client *client,
+				    struct timeval *now)
+{
+	struct fio_net_int_cmd *cmd;
+	struct flist_head *entry, *tmp;
+	int ret = 0;
+
+	flist_for_each_safe(entry, tmp, &client->cmd_list) {
+		cmd = flist_entry(entry, struct fio_net_int_cmd, list);
+
+		if (mtime_since(&cmd->tv, now) < FIO_NET_CLIENT_TIMEOUT)
+			continue;
+
+		log_err("fio: client %s, timeout on cmd %s\n", client->hostname,
+						fio_server_op(cmd->cmd.opcode));
+		flist_del(&cmd->list);
+		free(cmd);
+		ret = 1;
+	}
+
+	return flist_empty(&client->cmd_list) && ret;
+}
+
+static int fio_client_timed_out(void)
+{
+	struct fio_client *client;
+	struct flist_head *entry, *tmp;
+	struct timeval tv;
+	int ret = 0;
+
+	gettimeofday(&tv, NULL);
+
+	flist_for_each_safe(entry, tmp, &client_list) {
+		client = flist_entry(entry, struct fio_client, list);
+
+		if (flist_empty(&client->cmd_list))
+			continue;
+
+		if (!client_check_cmd_timeout(client, &tv))
+			continue;
+
+		log_err("fio: client %s timed out\n", client->hostname);
+		remove_client(client);
+		ret = 1;
+	}
+
+	return ret;
+}
+
+int fio_handle_clients(void)
+{
+	struct fio_client *client;
+	struct flist_head *entry;
+	struct pollfd *pfds;
+	int i, ret = 0;
+
+	gettimeofday(&eta_tv, NULL);
+
+	pfds = malloc(nr_clients * sizeof(struct pollfd));
+
+	sum_stat_clients = nr_clients;
+	init_thread_stat(&client_ts);
+	init_group_run_stat(&client_gs);
+
+	while (!exit_backend && nr_clients) {
+		i = 0;
+		flist_for_each(entry, &client_list) {
+			client = flist_entry(entry, struct fio_client, list);
+
+			pfds[i].fd = client->fd;
+			pfds[i].events = POLLIN;
+			i++;
+		}
+
+		assert(i == nr_clients);
+
+		do {
+			struct timeval tv;
+
+			gettimeofday(&tv, NULL);
+			if (mtime_since(&eta_tv, &tv) >= 900) {
+				request_client_etas();
+				memcpy(&eta_tv, &tv, sizeof(tv));
+
+				if (fio_client_timed_out())
+					break;
+			}
+
+			ret = poll(pfds, nr_clients, 100);
+			if (ret < 0) {
+				if (errno == EINTR)
+					continue;
+				log_err("fio: poll clients: %s\n", strerror(errno));
+				break;
+			} else if (!ret)
+				continue;
+		} while (ret <= 0);
+
+		for (i = 0; i < nr_clients; i++) {
+			if (!(pfds[i].revents & POLLIN))
+				continue;
+
+			client = find_client_by_fd(pfds[i].fd);
+			if (!client) {
+				log_err("fio: unknown client fd %d\n", pfds[i].fd);
+				continue;
+			}
+			if (!handle_client(client)) {
+				log_info("client: host=%s disconnected\n",
+						client->hostname);
+				remove_client(client);
+			}
+		}
+	}
+
+	free(pfds);
+	return 0;
+}
diff --git a/crc/crc16.c b/crc/crc16.c
index ac7983a..d9c4e49 100644
--- a/crc/crc16.c
+++ b/crc/crc16.c
@@ -43,11 +43,12 @@ unsigned short const crc16_table[256] = {
 	0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
 };
 
-unsigned short crc16(unsigned char const *buffer, unsigned int len)
+unsigned short crc16(const void *buffer, unsigned int len)
 {
+	const unsigned char *cp = (const unsigned char *) buffer;
 	unsigned short crc = 0;
 
 	while (len--)
-		crc = crc16_byte(crc, *buffer++);
+		crc = crc16_byte(crc, *cp++);
 	return crc;
 }
diff --git a/crc/crc16.h b/crc/crc16.h
index 841378d..6c078a4 100644
--- a/crc/crc16.h
+++ b/crc/crc16.h
@@ -17,7 +17,7 @@
 
 extern unsigned short const crc16_table[256];
 
-extern unsigned short crc16(const unsigned char *buffer, unsigned int len);
+extern unsigned short crc16(const void *buffer, unsigned int len);
 
 static inline unsigned short crc16_byte(unsigned short crc,
 					const unsigned char data)
diff --git a/debug.c b/debug.c
index 013cd53..5e98063 100644
--- a/debug.c
+++ b/debug.c
@@ -16,8 +16,8 @@ void __dprint(int type, const char *str, ...)
 	    && pid != *fio_debug_jobp)
 		return;
 
-	log_info("%-8s ", debug_levels[type].name);
-	log_info("%-5u ", (int) pid);
+	log_local("%-8s ", debug_levels[type].name);
+	log_local("%-5u ", (int) pid);
 
 	va_start(args, str);
 	log_valist(str, args);
diff --git a/debug.h b/debug.h
index 3473d6f..af71d62 100644
--- a/debug.h
+++ b/debug.h
@@ -18,6 +18,7 @@ enum {
 	FD_MUTEX,
 	FD_PROFILE,
 	FD_TIME,
+	FD_NET,
 	FD_DEBUG_MAX,
 };
 
diff --git a/diskutil.c b/diskutil.c
index 9fc3095..24e1782 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -14,7 +14,7 @@
 static int last_majdev, last_mindev;
 static struct disk_util *last_du;
 
-static struct flist_head disk_list = FLIST_HEAD_INIT(disk_list);
+FLIST_HEAD(disk_list);
 
 static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 		int majdev, int mindev, char *path);
@@ -33,13 +33,13 @@ static void disk_util_free(struct disk_util *du)
 	}
 	
 	fio_mutex_remove(du->lock);
-	sfree(du->name);
 	sfree(du);
 }
 
 static int get_io_ticks(struct disk_util *du, struct disk_util_stat *dus)
 {
 	unsigned in_flight;
+	unsigned long long sectors[2];
 	char line[256];
 	FILE *f;
 	char *p;
@@ -60,13 +60,15 @@ static int get_io_ticks(struct disk_util *du, struct disk_util_stat *dus)
 	dprint(FD_DISKUTIL, "%s: %s", du->path, p);
 
 	ret = sscanf(p, "%u %u %llu %u %u %u %llu %u %u %u %u\n", &dus->ios[0],
-					&dus->merges[0], &dus->sectors[0],
+					&dus->merges[0], &sectors[0],
 					&dus->ticks[0], &dus->ios[1],
-					&dus->merges[1], &dus->sectors[1],
+					&dus->merges[1], &sectors[1],
 					&dus->ticks[1], &in_flight,
 					&dus->io_ticks, &dus->time_in_queue);
 	fclose(f);
 	dprint(FD_DISKUTIL, "%s: stat read ok? %d\n", du->path, ret == 1);
+	dus->sectors[0] = sectors[0];
+	dus->sectors[1] = sectors[1];
 	return ret != 11;
 }
 
@@ -95,7 +97,7 @@ static void update_io_tick_disk(struct disk_util *du)
 	dus->time_in_queue += (__dus.time_in_queue - ldus->time_in_queue);
 
 	fio_gettime(&t, NULL);
-	du->msec += mtime_since(&du->time, &t);
+	dus->msec += mtime_since(&du->time, &t);
 	memcpy(&du->time, &t, sizeof(t));
 	memcpy(ldus, &__dus, sizeof(__dus));
 }
@@ -265,7 +267,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 	memset(du, 0, sizeof(*du));
 	INIT_FLIST_HEAD(&du->list);
 	sprintf(du->path, "%s/stat", path);
-	du->name = smalloc_strdup(basename(path));
+	strncpy((char *) du->dus.name, basename(path), FIO_DU_NAME_SZ);
 	du->sysfs_root = path;
 	du->major = majdev;
 	du->minor = mindev;
@@ -277,15 +279,15 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 	flist_for_each(entry, &disk_list) {
 		__du = flist_entry(entry, struct disk_util, list);
 
-		dprint(FD_DISKUTIL, "found %s in list\n", __du->name);
+		dprint(FD_DISKUTIL, "found %s in list\n", __du->dus.name);
 
-		if (!strcmp(du->name, __du->name)) {
+		if (!strcmp((char *) du->dus.name, (char *) __du->dus.name)) {
 			disk_util_free(du);
 			return __du;
 		}
 	}
 
-	dprint(FD_DISKUTIL, "add %s to list\n", du->name);
+	dprint(FD_DISKUTIL, "add %s to list\n", du->dus.name);
 
 	fio_gettime(&du->time, NULL);
 	get_io_ticks(du, &du->last_dus);
@@ -451,108 +453,136 @@ void init_disk_util(struct thread_data *td)
 		f->du = __init_disk_util(td, f);
 }
 
+static void show_agg_stats(struct disk_util_agg *agg, int terse)
+{
+	if (!agg->slavecount)
+		return;
+
+	if (!terse) {
+		log_info(", aggrios=%u/%u, aggrmerge=%u/%u, aggrticks=%u/%u,"
+				" aggrin_queue=%u, aggrutil=%3.2f%%",
+				agg->ios[0] / agg->slavecount,
+				agg->ios[1] / agg->slavecount,
+				agg->merges[0] / agg->slavecount,
+				agg->merges[1] / agg->slavecount,
+				agg->ticks[0] / agg->slavecount,
+				agg->ticks[1] / agg->slavecount,
+				agg->time_in_queue / agg->slavecount,
+				agg->max_util.u.f);
+	} else {
+		log_info("slaves;%u;%u;%u;%u;%u;%u;%u;%3.2f%%",
+				agg->ios[0] / agg->slavecount,
+				agg->ios[1] / agg->slavecount,
+				agg->merges[0] / agg->slavecount,
+				agg->merges[1] / agg->slavecount,
+				agg->ticks[0] / agg->slavecount,
+				agg->ticks[1] / agg->slavecount,
+				agg->time_in_queue / agg->slavecount,
+				agg->max_util.u.f);
+	}
+}
+
 static void aggregate_slaves_stats(struct disk_util *masterdu)
 {
+	struct disk_util_agg *agg = &masterdu->agg;
 	struct disk_util_stat *dus;
 	struct flist_head *entry;
 	struct disk_util *slavedu;
-	double util, max_util = 0;
-	int slavecount = 0;
-
-	unsigned merges[2] = { 0, };
-	unsigned ticks[2] = { 0, };
-	unsigned time_in_queue = { 0, };
-	unsigned long long sectors[2] = { 0, };
-	unsigned ios[2] = { 0, };
+	double util;
 
 	flist_for_each(entry, &masterdu->slaves) {
 		slavedu = flist_entry(entry, struct disk_util, slavelist);
 		dus = &slavedu->dus;
-		ios[0] += dus->ios[0];
-		ios[1] += dus->ios[1];
-		merges[0] += dus->merges[0];
-		merges[1] += dus->merges[1];
-		sectors[0] += dus->sectors[0];
-		sectors[1] += dus->sectors[1];
-		ticks[0] += dus->ticks[0];
-		ticks[1] += dus->ticks[1];
-		time_in_queue += dus->time_in_queue;
-		++slavecount;
-
-		util = (double) (100 * dus->io_ticks / (double) slavedu->msec);
+		agg->ios[0] += dus->ios[0];
+		agg->ios[1] += dus->ios[1];
+		agg->merges[0] += dus->merges[0];
+		agg->merges[1] += dus->merges[1];
+		agg->sectors[0] += dus->sectors[0];
+		agg->sectors[1] += dus->sectors[1];
+		agg->ticks[0] += dus->ticks[0];
+		agg->ticks[1] += dus->ticks[1];
+		agg->time_in_queue += dus->time_in_queue;
+		agg->slavecount++;
+
+		util = (double) (100 * dus->io_ticks / (double) slavedu->dus.msec);
 		/* System utilization is the utilization of the
 		 * component with the highest utilization.
 		 */
-		if (util > max_util)
-			max_util = util;
+		if (util > agg->max_util.u.f)
+			agg->max_util.u.f = util;
 
 	}
 
-	if (max_util > 100.0)
-		max_util = 100.0;
+	if (agg->max_util.u.f > 100.0)
+		agg->max_util.u.f = 100.0;
+}
 
-	log_info(", aggrios=%u/%u, aggrmerge=%u/%u, aggrticks=%u/%u,"
-			" aggrin_queue=%u, aggrutil=%3.2f%%",
-			ios[0]/slavecount, ios[1]/slavecount,
-			merges[0]/slavecount, merges[1]/slavecount,
-			ticks[0]/slavecount, ticks[1]/slavecount,
-			time_in_queue/slavecount, max_util);
+void free_disk_util(void)
+{
+	struct disk_util *du;
 
+	while (!flist_empty(&disk_list)) {
+		du = flist_entry(disk_list.next, struct disk_util, list);
+		flist_del(&du->list);
+		disk_util_free(du);
+	}
+
+	last_majdev = last_mindev = -1;
 }
 
-void show_disk_util(void)
+void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
+		     int terse)
 {
-	struct disk_util_stat *dus;
-	struct flist_head *entry, *next;
-	struct disk_util *du;
 	double util;
 
-	if (flist_empty(&disk_list))
-		return;
+	util = (double) 100 * dus->io_ticks / (double) dus->msec;
+	if (util > 100.0)
+		util = 100.0;
 
-	log_info("\nDisk stats (read/write):\n");
-
-	flist_for_each(entry, &disk_list) {
-		du = flist_entry(entry, struct disk_util, list);
-		dus = &du->dus;
-
-		util = (double) 100 * du->dus.io_ticks / (double) du->msec;
-		if (util > 100.0)
-			util = 100.0;
-
-		/* If this node is the slave of a master device, as
-		 * happens in case of software RAIDs, inward-indent
-		 * this stats line to reflect a master-slave
-		 * relationship. Because the master device gets added
-		 * before the slave devices, we can safely assume that
-		 * the master's stats line has been displayed in a
-		 * previous iteration of this loop.
-		 */
-		if (!flist_empty(&du->slavelist))
-			log_info("  ");
+	if (agg->slavecount)
+		log_info("  ");
 
+	if (!terse) {
 		log_info("  %s: ios=%u/%u, merge=%u/%u, ticks=%u/%u, "
-			 "in_queue=%u, util=%3.2f%%", du->name,
-						dus->ios[0], dus->ios[1],
-						dus->merges[0], dus->merges[1],
-						dus->ticks[0], dus->ticks[1],
-						dus->time_in_queue, util);
-
-		/* If the device has slaves, aggregate the stats for
-		 * those slave devices also.
-		 */
-		if (!flist_empty(&du->slaves))
-			aggregate_slaves_stats(du);
-
-		log_info("\n");
+			 "in_queue=%u, util=%3.2f%%", dus->name,
+					dus->ios[0], dus->ios[1],
+					dus->merges[0], dus->merges[1],
+					dus->ticks[0], dus->ticks[1],
+					dus->time_in_queue, util);
+	} else {
+		log_info(";%s;%u;%u;%u;%u;%lu;%lu;%u;%u;%u;%u;%3.2f%%",
+					dus->name, dus->ios[0], dus->ios[1],
+					dus->merges[0], dus->merges[1],
+					dus->ticks[0], dus->ticks[1],
+					dus->time_in_queue, util);
 	}
 
 	/*
-	 * now free the list
+	 * If the device has slaves, aggregate the stats for
+	 * those slave devices also.
 	 */
-	flist_for_each_safe(entry, next, &disk_list) {
-		flist_del(entry);
+	if (agg->slavecount)
+		show_agg_stats(agg, terse);
+
+	if (!terse)
+		log_info("\n");
+}
+
+void show_disk_util(int terse)
+{
+	struct flist_head *entry;
+	struct disk_util *du;
+
+	if (flist_empty(&disk_list))
+		return;
+
+	if (!terse)
+		log_info("\nDisk stats (read/write):\n");
+
+	flist_for_each(entry, &disk_list) {
 		du = flist_entry(entry, struct disk_util, list);
-		disk_util_free(du);
+
+		aggregate_slaves_stats(du);
+		print_disk_util(&du->dus, &du->agg, terse);
 	}
 }
diff --git a/diskutil.h b/diskutil.h
index dc89cc5..5a9b079 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -1,16 +1,31 @@
 #ifndef FIO_DISKUTIL_H
 #define FIO_DISKUTIL_H
 
+#define FIO_DU_NAME_SZ		64
+
 /*
  * Disk utils as read in /sys/block/<dev>/stat
  */
 struct disk_util_stat {
-	unsigned ios[2];
-	unsigned merges[2];
-	unsigned long long sectors[2];
-	unsigned ticks[2];
-	unsigned io_ticks;
-	unsigned time_in_queue;
+	uint8_t name[FIO_DU_NAME_SZ];
+	uint32_t ios[2];
+	uint32_t merges[2];
+	uint64_t sectors[2];
+	uint32_t ticks[2];
+	uint32_t io_ticks;
+	uint32_t time_in_queue;
+	uint64_t msec;
+};
+
+struct disk_util_agg {
+	uint32_t ios[2];
+	uint32_t merges[2];
+	uint64_t sectors[2];
+	uint32_t ticks[2];
+	uint32_t io_ticks;
+	uint32_t time_in_queue;
+	uint32_t slavecount;
+	fio_fp64_t max_util;
 };
 
 /*
@@ -31,6 +46,8 @@ struct disk_util {
 	struct disk_util_stat dus;
 	struct disk_util_stat last_dus;
 
+	struct disk_util_agg agg;
+
 	/* For software raids, this entry maintains pointers to the
 	 * entries for the slave devices. The disk_util entries for
 	 * the slaves devices should primarily be maintained through
@@ -40,7 +57,6 @@ struct disk_util {
 	 */
 	struct flist_head slaves;
 
-	unsigned long msec;
 	struct timeval time;
 
 	struct fio_mutex *lock;
@@ -76,15 +92,21 @@ static inline void disk_util_dec(struct disk_util *du)
 
 #define DISK_UTIL_MSEC	(250)
 
+extern struct flist_head disk_list;
+
 /*
  * disk util stuff
  */
 #ifdef FIO_HAVE_DISK_UTIL
-extern void show_disk_util(void);
+extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse);
+extern void show_disk_util(int terse);
+extern void free_disk_util(void);
 extern void init_disk_util(struct thread_data *);
 extern void update_io_ticks(void);
 #else
-#define show_disk_util()
+#define print_disk_util(dus, agg, terse)
+#define show_disk_util(terse)
+#define free_disk_util()
 #define init_disk_util(td)
 #define update_io_ticks()
 #endif
diff --git a/engines/net.c b/engines/net.c
index 6866ba2..d6821a4 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -14,7 +14,9 @@
 #include <netdb.h>
 #include <sys/poll.h>
 #include <sys/types.h>
+#include <sys/stat.h>
 #include <sys/socket.h>
+#include <sys/un.h>
 
 #include "../fio.h"
 
@@ -22,10 +24,11 @@ struct netio_data {
 	int listenfd;
 	int send_to_net;
 	int use_splice;
-	int net_protocol;
+	int type;
 	int pipes[2];
 	char host[64];
 	struct sockaddr_in addr;
+	struct sockaddr_un addr_un;
 };
 
 struct udp_close_msg {
@@ -36,6 +39,10 @@ struct udp_close_msg {
 enum {
 	FIO_LINK_CLOSE = 0x89,
 	FIO_LINK_CLOSE_MAGIC = 0x6c696e6b,
+
+	FIO_TYPE_TCP	= 1,
+	FIO_TYPE_UDP	= 2,
+	FIO_TYPE_UNIX	= 3,
 };
 
 /*
@@ -226,7 +233,7 @@ static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 	int ret, flags = OS_MSG_DONTWAIT;
 
 	do {
-		if (nd->net_protocol == IPPROTO_UDP) {
+		if (nd->type == FIO_TYPE_UDP) {
 			struct sockaddr *to = (struct sockaddr *) &nd->addr;
 
 			ret = sendto(io_u->file->fd, io_u->xfer_buf,
@@ -279,12 +286,8 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 	int ret, flags = OS_MSG_DONTWAIT;
 
 	do {
-		if (nd->net_protocol == IPPROTO_UDP) {
-#ifdef __hpux
-			int len = sizeof(nd->addr);
-#else
-			socklen_t len = sizeof(nd->addr);
-#endif
+		if (nd->type == FIO_TYPE_UDP) {
+			fio_socklen_t len = sizeof(nd->addr);
 			struct sockaddr *from = (struct sockaddr *) &nd->addr;
 
 			ret = recvfrom(io_u->file->fd, io_u->xfer_buf,
@@ -318,12 +321,14 @@ static int fio_netio_queue(struct thread_data *td, struct io_u *io_u)
 	fio_ro_check(td, io_u);
 
 	if (io_u->ddir == DDIR_WRITE) {
-		if (!nd->use_splice || nd->net_protocol == IPPROTO_UDP)
+		if (!nd->use_splice || nd->type == FIO_TYPE_UDP ||
+		    nd->type == FIO_TYPE_UNIX) 
 			ret = fio_netio_send(td, io_u);
 		else
 			ret = fio_netio_splice_out(td, io_u);
 	} else if (io_u->ddir == DDIR_READ) {
-		if (!nd->use_splice || nd->net_protocol == IPPROTO_UDP)
+		if (!nd->use_splice || nd->type == FIO_TYPE_UDP ||
+		    nd->type == FIO_TYPE_UDP)
 			ret = fio_netio_recv(td, io_u);
 		else
 			ret = fio_netio_splice_in(td, io_u);
@@ -354,25 +359,50 @@ static int fio_netio_queue(struct thread_data *td, struct io_u *io_u)
 static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 {
 	struct netio_data *nd = td->io_ops->data;
-	int type;
+	int type, domain;
 
-	if (nd->net_protocol == IPPROTO_TCP)
+	if (nd->type == FIO_TYPE_TCP) {
+		domain = AF_INET;
 		type = SOCK_STREAM;
-	else
+	} else if (nd->type == FIO_TYPE_UDP) {
+		domain = AF_INET;
 		type = SOCK_DGRAM;
+	} else if (nd->type == FIO_TYPE_UNIX) {
+		domain = AF_UNIX;
+		type = SOCK_STREAM;
+	} else {
+		log_err("fio: bad network type %d\n", nd->type);
+		f->fd = -1;
+		return 1;
+	}
 
-	f->fd = socket(AF_INET, type, nd->net_protocol);
+	f->fd = socket(domain, type, 0);
 	if (f->fd < 0) {
 		td_verror(td, errno, "socket");
 		return 1;
 	}
 
-	if (nd->net_protocol == IPPROTO_UDP)
+	if (nd->type == FIO_TYPE_UDP)
 		return 0;
+	else if (nd->type == FIO_TYPE_TCP) {
+		fio_socklen_t len = sizeof(nd->addr);
 
-	if (connect(f->fd, (struct sockaddr *) &nd->addr, sizeof(nd->addr)) < 0) {
-		td_verror(td, errno, "connect");
-		return 1;
+		if (connect(f->fd, (struct sockaddr *) &nd->addr, len) < 0) {
+			td_verror(td, errno, "connect");
+			close(f->fd);
+			return 1;
+		}
+	} else {
+		struct sockaddr_un *addr = &nd->addr_un;
+		fio_socklen_t len;
+
+		len = sizeof(addr->sun_family) + strlen(addr->sun_path) + 1;
+
+		if (connect(f->fd, (struct sockaddr *) addr, len) < 0) {
+			td_verror(td, errno, "connect");
+			close(f->fd);
+			return 1;
+		}
 	}
 
 	return 0;
@@ -381,13 +411,9 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
 {
 	struct netio_data *nd = td->io_ops->data;
-#ifdef __hpux
-	int socklen = sizeof(nd->addr);
-#else
-	socklen_t socklen = sizeof(nd->addr);
-#endif
+	fio_socklen_t socklen = sizeof(nd->addr);
 
-	if (nd->net_protocol == IPPROTO_UDP) {
+	if (nd->type == FIO_TYPE_UDP) {
 		f->fd = nd->listenfd;
 		return 0;
 	}
@@ -408,10 +434,16 @@ static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_open_file(struct thread_data *td, struct fio_file *f)
 {
+	int ret;
+
 	if (td_read(td))
-		return fio_netio_accept(td, f);
+		ret = fio_netio_accept(td, f);
 	else
-		return fio_netio_connect(td, f);
+		ret = fio_netio_connect(td, f);
+
+	if (ret)
+		f->fd = -1;
+	return ret;
 }
 
 static void fio_netio_udp_close(struct thread_data *td, struct fio_file *f)
@@ -438,14 +470,14 @@ static int fio_netio_close_file(struct thread_data *td, struct fio_file *f)
 	 * If this is an UDP connection, notify the receiver that we are
 	 * closing down the link
 	 */
-	if (nd->net_protocol == IPPROTO_UDP)
+	if (nd->type == FIO_TYPE_UDP)
 		fio_netio_udp_close(td, f);
 
 	return generic_close_file(td, f);
 }
 
-static int fio_netio_setup_connect(struct thread_data *td, const char *host,
-				   unsigned short port)
+static int fio_netio_setup_connect_inet(struct thread_data *td,
+					const char *host, unsigned short port)
 {
 	struct netio_data *nd = td->io_ops->data;
 
@@ -467,17 +499,72 @@ static int fio_netio_setup_connect(struct thread_data *td, const char *host,
 	return 0;
 }
 
-static int fio_netio_setup_listen(struct thread_data *td, short port)
+static int fio_netio_setup_connect_unix(struct thread_data *td,
+					const char *path)
+{
+	struct netio_data *nd = td->io_ops->data;
+	struct sockaddr_un *soun = &nd->addr_un;
+
+	soun->sun_family = AF_UNIX;
+	strcpy(soun->sun_path, path);
+	return 0;
+}
+
+static int fio_netio_setup_connect(struct thread_data *td, const char *host,
+				   unsigned short port)
+{
+	struct netio_data *nd = td->io_ops->data;
+
+	if (nd->type == FIO_TYPE_UDP || nd->type == FIO_TYPE_TCP)
+		return fio_netio_setup_connect_inet(td, host, port);
+	else
+		return fio_netio_setup_connect_unix(td, host);
+}
+
+static int fio_netio_setup_listen_unix(struct thread_data *td, const char *path)
+{
+	struct netio_data *nd = td->io_ops->data;
+	struct sockaddr_un *addr = &nd->addr_un;
+	mode_t mode;
+	int len, fd;
+
+	fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("fio: socket: %s\n", strerror(errno));
+		return -1;
+	}
+
+	mode = umask(000);
+
+	memset(addr, 0, sizeof(*addr));
+	addr->sun_family = AF_UNIX;
+	strcpy(addr->sun_path, path);
+	unlink(path);
+
+	len = sizeof(addr->sun_family) + strlen(path) + 1;
+
+	if (bind(fd, (struct sockaddr *) addr, len) < 0) {
+		log_err("fio: bind: %s\n", strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	umask(mode);
+	nd->listenfd = fd;
+	return 0;
+}
+
+static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 {
 	struct netio_data *nd = td->io_ops->data;
 	int fd, opt, type;
 
-	if (nd->net_protocol == IPPROTO_TCP)
+	if (nd->type == FIO_TYPE_TCP)
 		type = SOCK_STREAM;
 	else
 		type = SOCK_DGRAM;
 
-	fd = socket(AF_INET, type, nd->net_protocol);
+	fd = socket(AF_INET, type, 0);
 	if (fd < 0) {
 		td_verror(td, errno, "socket");
 		return 1;
@@ -503,12 +590,33 @@ static int fio_netio_setup_listen(struct thread_data *td, short port)
 		td_verror(td, errno, "bind");
 		return 1;
 	}
-	if (nd->net_protocol == IPPROTO_TCP && listen(fd, 1) < 0) {
+
+	nd->listenfd = fd;
+	return 0;
+}
+
+static int fio_netio_setup_listen(struct thread_data *td, const char *path,
+				  short port)
+{
+	struct netio_data *nd = td->io_ops->data;
+	int ret;
+
+	if (nd->type == FIO_TYPE_UDP || nd->type == FIO_TYPE_TCP)
+		ret = fio_netio_setup_listen_inet(td, port);
+	else
+		ret = fio_netio_setup_listen_unix(td, path);
+
+	if (ret)
+		return ret;
+	if (nd->type == FIO_TYPE_UDP)
+		return 0;
+
+	if (listen(nd->listenfd, 10) < 0) {
 		td_verror(td, errno, "listen");
+		nd->listenfd = -1;
 		return 1;
 	}
 
-	nd->listenfd = fd;
 	return 0;
 }
 
@@ -531,7 +639,7 @@ static int fio_netio_init(struct thread_data *td)
 
 	strcpy(buf, td->o.filename);
 
-	sep = strchr(buf, '/');
+	sep = strchr(buf, ',');
 	if (!sep)
 		goto bad_host;
 
@@ -543,31 +651,34 @@ static int fio_netio_init(struct thread_data *td)
 
 	modep = NULL;
 	portp = sep;
-	sep = strchr(portp, '/');
+	sep = strchr(portp, ',');
 	if (sep) {
 		*sep = '\0';
 		modep = sep + 1;
 	}
-		
-	port = strtol(portp, NULL, 10);
-	if (!port || port > 65535)
+
+	if (!strncmp("tcp", modep, strlen(modep)) ||
+	    !strncmp("TCP", modep, strlen(modep)))
+		nd->type = FIO_TYPE_TCP;
+	else if (!strncmp("udp", modep, strlen(modep)) ||
+		 !strncmp("UDP", modep, strlen(modep)))
+		nd->type = FIO_TYPE_UDP;
+	else if (!strncmp("unix", modep, strlen(modep)) ||
+		 !strncmp("UNIX", modep, strlen(modep)))
+		nd->type = FIO_TYPE_UNIX;
+	else
 		goto bad_host;
 
-	if (modep) {
-		if (!strncmp("tcp", modep, strlen(modep)) ||
-		    !strncmp("TCP", modep, strlen(modep)))
-			nd->net_protocol = IPPROTO_TCP;
-		else if (!strncmp("udp", modep, strlen(modep)) ||
-			 !strncmp("UDP", modep, strlen(modep)))
-			nd->net_protocol = IPPROTO_UDP;
-		else
+	if (nd->type != FIO_TYPE_UNIX) {
+		port = strtol(portp, NULL, 10);
+		if (!port || port > 65535)
 			goto bad_host;
 	} else
-		nd->net_protocol = IPPROTO_TCP;
+		port = 0;
 
 	if (td_read(td)) {
 		nd->send_to_net = 0;
-		ret = fio_netio_setup_listen(td, port);
+		ret = fio_netio_setup_listen(td, host, port);
 	} else {
 		nd->send_to_net = 1;
 		ret = fio_netio_setup_connect(td, host, port);
diff --git a/eta.c b/eta.c
index d93bf1a..6118d1a 100644
--- a/eta.c
+++ b/eta.c
@@ -230,32 +230,28 @@ static void calc_iops(unsigned long mtime, unsigned long long *io_iops,
  * Print status of the jobs we know about. This includes rate estimates,
  * ETA, thread state, etc.
  */
-void print_thread_status(void)
+int calc_thread_status(struct jobs_eta *je, int force)
 {
-	unsigned long elapsed = (mtime_since_genesis() + 999) / 1000;
-	int i, nr_ramp, nr_running, nr_pending, t_rate, m_rate;
-	int t_iops, m_iops, files_open;
 	struct thread_data *td;
-	char eta_str[128];
-	double perc = 0.0;
-	unsigned long long io_bytes[2], io_iops[2];
-	unsigned long rate_time, disp_time, bw_avg_time, *eta_secs, eta_sec;
+	int i;
+	unsigned long rate_time, disp_time, bw_avg_time, *eta_secs;
+	unsigned long long io_bytes[2];
+	unsigned long long io_iops[2];
 	struct timeval now;
 
 	static unsigned long long rate_io_bytes[2];
 	static unsigned long long disp_io_bytes[2];
 	static unsigned long long disp_io_iops[2];
 	static struct timeval rate_prev_time, disp_prev_time;
-	static unsigned int rate[2], iops[2];
-	static int linelen_last;
-	static int eta_good;
 	int i2p = 0;
 
-	if (temp_stall_ts || terse_output || eta_print == FIO_ETA_NEVER)
-		return;
+	if (!force) {
+		if (temp_stall_ts || terse_output || eta_print == FIO_ETA_NEVER)
+			return 0;
 
-	if (!isatty(STDOUT_FILENO) && (eta_print != FIO_ETA_ALWAYS))
-		return;
+		if (!isatty(STDOUT_FILENO) && (eta_print != FIO_ETA_ALWAYS))
+			return 0;
+	}
 
 	if (!rate_io_bytes[0] && !rate_io_bytes[1])
 		fill_start_time(&rate_prev_time);
@@ -265,32 +261,31 @@ void print_thread_status(void)
 	eta_secs = malloc(thread_number * sizeof(unsigned long));
 	memset(eta_secs, 0, thread_number * sizeof(unsigned long));
 
+	je->elapsed_sec = (mtime_since_genesis() + 999) / 1000;
+
 	io_bytes[0] = io_bytes[1] = 0;
 	io_iops[0] = io_iops[1] = 0;
-	nr_pending = nr_running = t_rate = m_rate = t_iops = m_iops = 0;
-	nr_ramp = 0;
 	bw_avg_time = ULONG_MAX;
-	files_open = 0;
 	for_each_td(td, i) {
 		if (td->o.bw_avg_time < bw_avg_time)
 			bw_avg_time = td->o.bw_avg_time;
 		if (td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING
 		    || td->runstate == TD_FSYNCING
 		    || td->runstate == TD_PRE_READING) {
-			nr_running++;
-			t_rate += td->o.rate[0] + td->o.rate[1];
-			m_rate += td->o.ratemin[0] + td->o.ratemin[1];
-			t_iops += td->o.rate_iops[0] + td->o.rate_iops[1];
-			m_iops += td->o.rate_iops_min[0] +
+			je->nr_running++;
+			je->t_rate += td->o.rate[0] + td->o.rate[1];
+			je->m_rate += td->o.ratemin[0] + td->o.ratemin[1];
+			je->t_iops += td->o.rate_iops[0] + td->o.rate_iops[1];
+			je->m_iops += td->o.rate_iops_min[0] +
 					td->o.rate_iops_min[1];
-			files_open += td->nr_open_files;
+			je->files_open += td->nr_open_files;
 		} else if (td->runstate == TD_RAMP) {
-			nr_running++;
-			nr_ramp++;
+			je->nr_running++;
+			je->nr_ramp++;
 		} else if (td->runstate < TD_RUNNING)
-			nr_pending++;
+			je->nr_pending++;
 
-		if (elapsed >= 3)
+		if (je->elapsed_sec >= 3)
 			eta_secs[i] = thread_eta(td);
 		else
 			eta_secs[i] = INT_MAX;
@@ -306,37 +301,32 @@ void print_thread_status(void)
 	}
 
 	if (exitall_on_terminate)
-		eta_sec = INT_MAX;
+		je->eta_sec = INT_MAX;
 	else
-		eta_sec = 0;
+		je->eta_sec = 0;
 
 	for_each_td(td, i) {
 		if (!i2p && is_power_of_2(td->o.kb_base))
 			i2p = 1;
 		if (exitall_on_terminate) {
-			if (eta_secs[i] < eta_sec)
-				eta_sec = eta_secs[i];
+			if (eta_secs[i] < je->eta_sec)
+				je->eta_sec = eta_secs[i];
 		} else {
-			if (eta_secs[i] > eta_sec)
-				eta_sec = eta_secs[i];
+			if (eta_secs[i] > je->eta_sec)
+				je->eta_sec = eta_secs[i];
 		}
 	}
 
 	free(eta_secs);
 
-	if (eta_sec != INT_MAX && elapsed) {
-		perc = (double) elapsed / (double) (elapsed + eta_sec);
-		eta_to_str(eta_str, eta_sec);
-	}
-
 	fio_gettime(&now, NULL);
 	rate_time = mtime_since(&rate_prev_time, &now);
 
 	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
-		calc_rate(rate_time, io_bytes, rate_io_bytes, rate);
+		calc_rate(rate_time, io_bytes, rate_io_bytes, je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
-		add_agg_sample(rate[DDIR_READ], DDIR_READ, 0);
-		add_agg_sample(rate[DDIR_WRITE], DDIR_WRITE, 0);
+		add_agg_sample(je->rate[DDIR_READ], DDIR_READ, 0);
+		add_agg_sample(je->rate[DDIR_WRITE], DDIR_WRITE, 0);
 	}
 
 	disp_time = mtime_since(&disp_prev_time, &now);
@@ -344,35 +334,55 @@ void print_thread_status(void)
 	/*
 	 * Allow a little slack, the target is to print it every 1000 msecs
 	 */
-	if (disp_time < 900)
-		return;
+	if (!force && disp_time < 900)
+		return 0;
 
-	calc_rate(disp_time, io_bytes, disp_io_bytes, rate);
-	calc_iops(disp_time, io_iops, disp_io_iops, iops);
+	calc_rate(disp_time, io_bytes, disp_io_bytes, je->rate);
+	calc_iops(disp_time, io_iops, disp_io_iops, je->iops);
 
 	memcpy(&disp_prev_time, &now, sizeof(now));
 
-	if (!nr_running && !nr_pending)
-		return;
+	if (!force && !je->nr_running && !je->nr_pending)
+		return 0;
+
+	je->nr_threads = thread_number;
+	memcpy(je->run_str, run_str, thread_number * sizeof(char));
+
+	return 1;
+}
 
-	printf("Jobs: %d (f=%d)", nr_running, files_open);
-	if (m_rate || t_rate) {
+void display_thread_status(struct jobs_eta *je)
+{
+	static int linelen_last;
+	static int eta_good;
+	char output[512], *p = output;
+	char eta_str[128];
+	double perc = 0.0;
+	int i2p = 0;
+
+	if (je->eta_sec != INT_MAX && je->elapsed_sec) {
+		perc = (double) je->elapsed_sec / (double) (je->elapsed_sec + je->eta_sec);
+		eta_to_str(eta_str, je->eta_sec);
+	}
+
+	p += sprintf(p, "Jobs: %d (f=%d)", je->nr_running, je->files_open);
+	if (je->m_rate || je->t_rate) {
 		char *tr, *mr;
 
-		mr = num2str(m_rate, 4, 0, i2p);
-		tr = num2str(t_rate, 4, 0, i2p);
-		printf(", CR=%s/%s KB/s", tr, mr);
+		mr = num2str(je->m_rate, 4, 0, i2p);
+		tr = num2str(je->t_rate, 4, 0, i2p);
+		p += sprintf(p, ", CR=%s/%s KB/s", tr, mr);
 		free(tr);
 		free(mr);
-	} else if (m_iops || t_iops)
-		printf(", CR=%d/%d IOPS", t_iops, m_iops);
-	if (eta_sec != INT_MAX && nr_running) {
+	} else if (je->m_iops || je->t_iops)
+		p += sprintf(p, ", CR=%d/%d IOPS", je->t_iops, je->m_iops);
+	if (je->eta_sec != INT_MAX && je->nr_running) {
 		char perc_str[32];
 		char *iops_str[2];
 		char *rate_str[2];
 		int l;
 
-		if ((!eta_sec && !eta_good) || nr_ramp == nr_running)
+		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running)
 			strcpy(perc_str, "-.-% done");
 		else {
 			eta_good = 1;
@@ -380,17 +390,18 @@ void print_thread_status(void)
 			sprintf(perc_str, "%3.1f%% done", perc);
 		}
 
-		rate_str[0] = num2str(rate[0], 5, 10, i2p);
-		rate_str[1] = num2str(rate[1], 5, 10, i2p);
+		rate_str[0] = num2str(je->rate[0], 5, 10, i2p);
+		rate_str[1] = num2str(je->rate[1], 5, 10, i2p);
 
-		iops_str[0] = num2str(iops[0], 4, 1, 0);
-		iops_str[1] = num2str(iops[1], 4, 1, 0);
+		iops_str[0] = num2str(je->iops[0], 4, 1, 0);
+		iops_str[1] = num2str(je->iops[1], 4, 1, 0);
 
-		l = printf(": [%s] [%s] [%s/%s /s] [%s/%s iops] [eta %s]",
-				 run_str, perc_str, rate_str[0], rate_str[1],
-				 iops_str[0], iops_str[1], eta_str);
+		l = sprintf(p, ": [%s] [%s] [%s/%s /s] [%s/%s iops] [eta %s]",
+				je->run_str, perc_str, rate_str[0],
+				rate_str[1], iops_str[0], iops_str[1], eta_str);
+		p += l;
 		if (l >= 0 && l < linelen_last)
-			printf("%*s", linelen_last - l, "");
+			p += sprintf(p, "%*s", linelen_last - l, "");
 		linelen_last = l;
 
 		free(rate_str[0]);
@@ -398,10 +409,30 @@ void print_thread_status(void)
 		free(iops_str[0]);
 		free(iops_str[1]);
 	}
-	printf("\r");
+	p += sprintf(p, "\r");
+
+	printf("%s", output);
 	fflush(stdout);
 }
 
+void print_thread_status(void)
+{
+	struct jobs_eta *je;
+	size_t size;
+
+	if (!thread_number)
+		return;
+
+	size = sizeof(*je) + thread_number * sizeof(char) + 1;
+	je = malloc(size);
+	memset(je, 0, size);
+
+	if (calc_thread_status(je, 0))
+		display_thread_status(je);
+
+	free(je);
+}
+
 void print_status_init(int thr_number)
 {
 	run_str[thr_number] = 'P';
diff --git a/examples/netio b/examples/netio
index 2aa0928..5b07468 100644
--- a/examples/netio
+++ b/examples/netio
@@ -1,8 +1,12 @@
 # Example network job, just defines two clients that send/recv data
 [global]
 ioengine=net
-#the below defaults to a tcp connection, add /udp at the end for udp
-filename=localhost/8888
+#this would use UDP over localhost, port 8888
+#filename=localhost,8888,udp
+#this would use a local domain socket /tmp/fio.sock
+#filename=/tmp/fio.sock,,unix
+#TCP, port 8888, localhost
+filename=localhost,8888,tcp
 bs=4k
 size=10g
 #set the below option to enable end-to-end data integrity tests
@@ -12,4 +16,5 @@ size=10g
 rw=read
 
 [sender]
+startdelay=1
 rw=write
diff --git a/filehash.c b/filehash.c
index 1df7db0..1bb1eb2 100644
--- a/filehash.c
+++ b/filehash.c
@@ -3,7 +3,7 @@
 
 #include "fio.h"
 #include "flist.h"
-#include "crc/crc16.h"
+#include "hash.h"
 
 #define HASH_BUCKETS	512
 #define HASH_MASK	(HASH_BUCKETS - 1)
@@ -15,7 +15,7 @@ static struct fio_mutex *hash_lock;
 
 static unsigned short hash(const char *name)
 {
-	return crc16((const unsigned char *) name, strlen(name)) & HASH_MASK;
+	return jhash(name, strlen(name), 0) & HASH_MASK;
 }
 
 void remove_file_hash(struct fio_file *f)
diff --git a/fio.1 b/fio.1
index 513caa9..2473b44 100644
--- a/fio.1
+++ b/fio.1
@@ -12,6 +12,11 @@ The typical use of fio is to write a job file matching the I/O load
 one wants to simulate.
 .SH OPTIONS
 .TP
+.BI \-\-debug \fR=\fPtype
+Enable verbose tracing of various fio actions. May be `all' for all types
+or individual types separated by a comma (eg \-\-debug=io,file). `help' will
+list all available tracing options.
+.TP
 .BI \-\-output \fR=\fPfilename
 Write output to \fIfilename\fR.
 .TP
@@ -27,6 +32,18 @@ Generate per-job bandwidth logs.
 .B \-\-minimal
 Print statistics in a terse, semicolon-delimited format.
 .TP
+.B \-\-version
+Display version information and exit.
+.TP
+.BI \-\-terse\-version \fR=\fPversion
+Set terse version output format.
+.TP
+.B \-\-help
+Display usage information and exit.
+.TP
+.BI \-\-cmdhelp \fR=\fPcommand
+Print help information for \fIcommand\fR.  May be `all' for all commands.
+.TP
 .BI \-\-showcmd \fR=\fPjobfile
 Convert \fIjobfile\fR to a set of command-line options.
 .TP
@@ -37,25 +54,29 @@ Enable read-only safety checks.
 Specifies when real-time ETA estimate should be printed.  \fIwhen\fR may
 be one of `always', `never' or `auto'.
 .TP
+.BI \-\-readonly
+Turn on safety read-only checks, preventing any attempted write.
+.TP
 .BI \-\-section \fR=\fPsec
-Only run section \fIsec\fR from job file.
+Only run section \fIsec\fR from job file. Multiple of these options can be given, adding more sections to run.
 .TP
-.BI \-\-cmdhelp \fR=\fPcommand
-Print help information for \fIcommand\fR.  May be `all' for all commands.
+.BI \-\-alloc\-size \fR=\fPkb
+Set the internal smalloc pool size to \fIkb\fP kilobytes.
 .TP
-.BI \-\-debug \fR=\fPtype
-Enable verbose tracing of various fio actions. May be `all' for all types
-or individual types separated by a comma (eg \-\-debug=io,file). `help' will
-list all available tracing options.
+.BI \-\-warnings\-fatal
+All fio parser warnings are fatal, causing fio to exit with an error.
 .TP
-.B \-\-help
-Display usage information and exit.
+.BI \-\-max\-jobs \fR=\fPnr
+Set the maximum allowed number of jobs (threads/processes) to suport.
 .TP
-.B \-\-version
-Display version information and exit.
+.BI \-\-server \fR=\fPargs
+Start a backend server, with \fIargs\fP specifying what to listen to. See client/server section.
+.TP
+.BI \-\-daemonize \fR=\fPpidfile
+Background a fio server, writing the pid to the given pid file.
 .TP
-.B \-\-terse\-version\fR=\fPtype
-Terse version output format
+.BI \-\-client \fR=\fPhost
+Instead of running the jobs locally, send and run them on the given host.
 .SH "JOB FILE FORMAT"
 Job files are in `ini' format. They consist of one or more
 job definitions, which begin with a job name in square brackets and
@@ -416,8 +437,9 @@ itself and for debugging and testing purposes.
 .TP
 .B net
 Transfer over the network.  \fBfilename\fR must be set appropriately to
-`\fIhost\fR/\fIport\fR' regardless of data direction.  If receiving, only the
-\fIport\fR argument is used.
+`\fIhost\fR,\fIport\fR,\fItype\fR' regardless of data direction. \fItype\fR
+is one of \fBtcp\fR, \fBudp\fR, or \fBunix\fR. For UNIX domain sockets,
+the \fIhost\fR parameter is a file system path.
 .TP
 .B netsplice
 Like \fBnet\fR, but uses \fIsplice\fR\|(2) and \fIvmsplice\fR\|(2) to map data
@@ -673,6 +695,10 @@ Terminate all jobs when one finishes.  Default: wait for each job to finish.
 Average bandwidth calculations over the given time in milliseconds.  Default:
 500ms.
 .TP
+.BI iopsavgtime \fR=\fPint
+Average IOPS calculations over the given time in milliseconds.  Default:
+500ms.
+.TP
 .BI create_serialize \fR=\fPbool
 If true, serialize file creation for the jobs.  Default: true.
 .TP
@@ -845,6 +871,11 @@ Same as \fBwrite_bw_log\fR, but writes I/O completion latencies.  If no
 filename is given with this option, the default filename of "jobname_type.log"
 is used. Even if the filename is given, fio will still append the type of log.
 .TP
+.BI write_iops_log \fR=\fPstr
+Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given with this
+option, the default filename of "jobname_type.log" is used. Even if the
+filename is given, fio will still append the type of log.
+.TP
 .BI disable_lat \fR=\fPbool
 Disable measurements of total latency numbers. Useful only for cutting
 back the number of calls to gettimeofday, as that does impact performance at
@@ -1094,7 +1125,7 @@ change.  The fields are:
 .P
 Read status:
 .RS
-.B Total I/O \fR(KB)\fP, bandwidth \fR(KB/s)\fP, runtime \fR(ms)\fP
+.B Total I/O \fR(KB)\fP, bandwidth \fR(KB/s)\fP, IOPS, runtime \fR(ms)\fP
 .P
 Submission latency:
 .RS
@@ -1104,6 +1135,10 @@ Completion latency:
 .RS
 .B min, max, mean, standard deviation
 .RE
+Completion latency percentiles (20 fields):
+.RS
+.B Xth percentile=usec
+.RE
 Total latency:
 .RS
 .B min, max, mean, standard deviation
@@ -1116,7 +1151,7 @@ Bandwidth:
 .P
 Write status:
 .RS
-.B Total I/O \fR(KB)\fP, bandwidth \fR(KB/s)\fP, runtime \fR(ms)\fP
+.B Total I/O \fR(KB)\fP, bandwidth \fR(KB/s)\fP, IOPS, runtime \fR(ms)\fP
 .P
 Submission latency:
 .RS
@@ -1126,6 +1161,10 @@ Completion latency:
 .RS
 .B min, max, mean, standard deviation
 .RE
+Completion latency percentiles (20 fields):
+.RS
+.B Xth percentile=usec
+.RE
 Total latency:
 .RS
 .B min, max, mean, standard deviation
@@ -1158,6 +1197,11 @@ Milliseconds:
 .RE
 .RE
 .P
+Disk utilization (1 for each disk used):
+.RS
+.B name, read ios, write ios, read merges, write merges, read ticks, write ticks, read in-queue time, write in-queue time, disk utilization percentage
+.RE
+.P
 Error Info (dependent on continue_on_error, default off):
 .RS
 .B total # errors, first error code 
@@ -1165,7 +1209,57 @@ Error Info (dependent on continue_on_error, default off):
 .P
 .B text description (if provided in config - appears on newline)
 .RE
+.SH CLIENT / SERVER
+Normally you would run fio as a stand-alone application on the machine
+where the IO workload should be generated. However, it is also possible to
+run the frontend and backend of fio separately. This makes it possible to
+have a fio server running on the machine(s) where the IO workload should
+be running, while controlling it from another machine.
+
+To start the server, you would do:
+
+\fBfio \-\-server=args\fR
+
+on that machine, where args defines what fio listens to. The arguments
+are of the form 'type:hostname or IP:port'. 'type' is either 'ip' for
+TCP/IP, or 'sock' for a local unix domain socket. 'hostname' is either
+a hostname or IP address, and 'port' is the port to listen to (only valid
+for TCP/IP, not a local socket). Some examples:
+
+1) fio --server
+
+   Start a fio server, listening on all interfaces on the default port (8765).
+
+2) fio --server=ip:hostname:4444
+
+   Start a fio server, listening on IP belonging to hostname and on port 4444.
+
+3) fio --server=:4444
+
+   Start a fio server, listening on all interfaces on port 4444.
+
+4) fio --server=1.2.3.4
+
+   Start a fio server, listening on IP 1.2.3.4 on the default port.
+
+5) fio --server=sock:/tmp/fio.sock
+
+   Start a fio server, listening on the local socket /tmp/fio.sock.
+
+When a server is running, you can connect to it from a client. The client
+is run with:
+
+fio --local-args --client=server --remote-args <job file(s)>
+
+where --local-args are arguments that are local to the client where it is
+running, 'server' is the connect string, and --remote-args and <job file(s)>
+are sent to the server. The 'server' string follows the same format as it
+does on the server side, to allow IP/hostname/socket and port strings.
+You can connect to multiple clients as well, to do that you could run:
+
+fio --client=server2 --client=server2 <job file(s)>
 .SH AUTHORS
+
 .B fio
 was written by Jens Axboe <jens.axboe@oracle.com>,
 now Jens Axboe <jaxboe@fusionio.com>.
diff --git a/fio.c b/fio.c
index b492889..e5d3bbf 100644
--- a/fio.c
+++ b/fio.c
@@ -46,6 +46,7 @@
 #include "profile.h"
 #include "lib/rand.h"
 #include "memalign.h"
+#include "server.h"
 
 unsigned long page_mask;
 unsigned long page_size;
@@ -61,6 +62,13 @@ int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
 
+/*
+ * Just expose an empty list, if the OS does not support disk util stats
+ */
+#ifndef FIO_HAVE_DISK_UTIL
+FLIST_HEAD(disk_list);
+#endif
+
 static struct fio_mutex *startup_mutex;
 static struct fio_mutex *writeout_mutex;
 static volatile int fio_abort;
@@ -74,9 +82,52 @@ unsigned long arch_flags = 0;
 
 struct io_log *agg_io_log[2];
 
-#define TERMINATE_ALL		(-1)
 #define JOB_START_TIMEOUT	(5 * 1000)
 
+static const char *fio_os_strings[os_nr] = {
+	"Invalid",
+	"Linux",
+	"AIX",
+	"FreeBSD",
+	"HP-UX",
+	"OSX",
+	"NetBSD",
+	"Solaris",
+	"Windows"
+};
+
+static const char *fio_arch_strings[arch_nr] = {
+	"Invalid",
+	"x86-64",
+	"x86",
+	"ppc",
+	"ia64",
+	"s390",
+	"alpha",
+	"sparc",
+	"sparc64",
+	"arm",
+	"sh",
+	"hppa",
+	"generic"
+};
+
+const char *fio_get_os_string(int nr)
+{
+	if (nr < os_nr)
+		return fio_os_strings[nr];
+
+	return NULL;
+}
+
+const char *fio_get_arch_string(int nr)
+{
+	if (nr < arch_nr)
+		return fio_arch_strings[nr];
+
+	return NULL;
+}
+
 void td_set_runstate(struct thread_data *td, int runstate)
 {
 	if (td->runstate == runstate)
@@ -87,7 +138,7 @@ void td_set_runstate(struct thread_data *td, int runstate)
 	td->runstate = runstate;
 }
 
-static void terminate_threads(int group_id)
+void fio_terminate_threads(int group_id)
 {
 	struct thread_data *td;
 	int i;
@@ -121,10 +172,15 @@ static void terminate_threads(int group_id)
 static void sig_int(int sig)
 {
 	if (threads) {
-		log_info("\nfio: terminating on signal %d\n", sig);
-		fflush(stdout);
-		exit_value = 128;
-		terminate_threads(TERMINATE_ALL);
+		if (is_backend)
+			fio_server_got_signal(sig);
+		else {
+			log_info("\nfio: terminating on signal %d\n", sig);
+			fflush(stdout);
+			exit_value = 128;
+		}
+
+		fio_terminate_threads(TERMINATE_ALL);
 	}
 }
 
@@ -137,7 +193,9 @@ static void *disk_thread_main(void *data)
 		if (!threads)
 			break;
 		update_io_ticks();
-		print_thread_status();
+
+		if (!is_backend)
+			print_thread_status();
 	}
 
 	return NULL;
@@ -178,6 +236,13 @@ static void set_sig_handlers(void)
 	act.sa_handler = sig_int;
 	act.sa_flags = SA_RESTART;
 	sigaction(SIGTERM, &act, NULL);
+
+	if (is_backend) {
+		memset(&act, 0, sizeof(act));
+		act.sa_handler = sig_int;
+		act.sa_flags = SA_RESTART;
+		sigaction(SIGPIPE, &act, NULL);
+	}
 }
 
 /*
@@ -205,7 +270,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 	if (mtime_since(&td->start, now) < 2000)
 		return 0;
 
-	iops += td->io_blocks[ddir];
+	iops += td->this_io_blocks[ddir];
 	bytes += td->this_io_bytes[ddir];
 	ratemin += td->o.ratemin[ddir];
 	rate_iops += td->o.rate_iops[ddir];
@@ -744,7 +809,7 @@ sync_done:
 		if (!in_ramp_time(td) && should_check_rate(td, bytes_done)) {
 			if (check_min_rate(td, &comp_time, bytes_done)) {
 				if (exitall_on_terminate)
-					terminate_threads(td->groupid);
+					fio_terminate_threads(td->groupid);
 				td_verror(td, EIO, "check_min_rate");
 				break;
 			}
@@ -972,8 +1037,10 @@ static int keep_running(struct thread_data *td)
 
 static void reset_io_counters(struct thread_data *td)
 {
-	td->ts.stat_io_bytes[0] = td->ts.stat_io_bytes[1] = 0;
+	td->stat_io_bytes[0] = td->stat_io_bytes[1] = 0;
 	td->this_io_bytes[0] = td->this_io_bytes[1] = 0;
+	td->stat_io_blocks[0] = td->stat_io_blocks[1] = 0;
+	td->this_io_blocks[0] = td->this_io_blocks[1] = 0;
 	td->zone_bytes = 0;
 	td->rate_bytes[0] = td->rate_bytes[1] = 0;
 	td->rate_blocks[0] = td->rate_blocks[1] = 0;
@@ -1167,19 +1234,17 @@ static void *thread_main(void *data)
 	}
 
 	fio_gettime(&td->epoch, NULL);
-	getrusage(RUSAGE_SELF, &td->ts.ru_start);
+	getrusage(RUSAGE_SELF, &td->ru_start);
 
 	clear_state = 0;
 	while (keep_running(td)) {
 		fio_gettime(&td->start, NULL);
-		memcpy(&td->ts.stat_sample_time[0], &td->start,
-				sizeof(td->start));
-		memcpy(&td->ts.stat_sample_time[1], &td->start,
-				sizeof(td->start));
+		memcpy(&td->bw_sample_time, &td->start, sizeof(td->start));
+		memcpy(&td->iops_sample_time, &td->start, sizeof(td->start));
 		memcpy(&td->tv_cache, &td->start, sizeof(td->start));
 
 		if (td->o.ratemin[0] || td->o.ratemin[1])
-			memcpy(&td->lastrate, &td->ts.stat_sample_time,
+			memcpy(&td->lastrate, &td->bw_sample_time,
 							sizeof(td->lastrate));
 
 		if (clear_state)
@@ -1228,40 +1293,48 @@ static void *thread_main(void *data)
 	td->ts.io_bytes[1] = td->io_bytes[1];
 
 	fio_mutex_down(writeout_mutex);
-	if (td->ts.bw_log) {
+	if (td->bw_log) {
 		if (td->o.bw_log_file) {
-			finish_log_named(td, td->ts.bw_log,
+			finish_log_named(td, td->bw_log,
 						td->o.bw_log_file, "bw");
 		} else
-			finish_log(td, td->ts.bw_log, "bw");
+			finish_log(td, td->bw_log, "bw");
 	}
-	if (td->ts.lat_log) {
+	if (td->lat_log) {
 		if (td->o.lat_log_file) {
-			finish_log_named(td, td->ts.lat_log,
+			finish_log_named(td, td->lat_log,
 						td->o.lat_log_file, "lat");
 		} else
-			finish_log(td, td->ts.lat_log, "lat");
+			finish_log(td, td->lat_log, "lat");
 	}
-	if (td->ts.slat_log) {
+	if (td->slat_log) {
 		if (td->o.lat_log_file) {
-			finish_log_named(td, td->ts.slat_log,
+			finish_log_named(td, td->slat_log,
 						td->o.lat_log_file, "slat");
 		} else
-			finish_log(td, td->ts.slat_log, "slat");
+			finish_log(td, td->slat_log, "slat");
 	}
-	if (td->ts.clat_log) {
+	if (td->clat_log) {
 		if (td->o.lat_log_file) {
-			finish_log_named(td, td->ts.clat_log,
+			finish_log_named(td, td->clat_log,
 						td->o.lat_log_file, "clat");
 		} else
-			finish_log(td, td->ts.clat_log, "clat");
+			finish_log(td, td->clat_log, "clat");
 	}
+	if (td->iops_log) {
+		if (td->o.iops_log_file) {
+			finish_log_named(td, td->iops_log,
+						td->o.iops_log_file, "iops");
+		} else
+			finish_log(td, td->iops_log, "iops");
+	}
+
 	fio_mutex_up(writeout_mutex);
 	if (td->o.exec_postrun)
 		exec_string(td->o.exec_postrun);
 
 	if (exitall_on_terminate)
-		terminate_threads(td->groupid);
+		fio_terminate_threads(td->groupid);
 
 err:
 	if (td->error)
@@ -1415,7 +1488,7 @@ reaped:
 	}
 
 	if (*nr_running == cputhreads && !pending && realthreads)
-		terminate_threads(TERMINATE_ALL);
+		fio_terminate_threads(TERMINATE_ALL);
 }
 
 static void *gtod_thread_main(void *data)
@@ -1477,6 +1550,8 @@ static void run_threads(void)
 	if (fio_gtod_offload && fio_start_gtod_thread())
 		return;
 
+	set_sig_handlers();
+
 	if (!terse_output) {
 		log_info("Starting ");
 		if (nr_thread)
@@ -1492,8 +1567,6 @@ static void run_threads(void)
 		fflush(stdout);
 	}
 
-	set_sig_handlers();
-
 	todo = thread_number;
 	nr_running = 0;
 	nr_started = 0;
@@ -1609,7 +1682,7 @@ static void run_threads(void)
 			dprint(FD_MUTEX, "wait on startup_mutex\n");
 			if (fio_mutex_down_timeout(startup_mutex, 10)) {
 				log_err("fio: job startup hung? exiting.\n");
-				terminate_threads(TERMINATE_ALL);
+				fio_terminate_threads(TERMINATE_ALL);
 				fio_abort = 1;
 				nr_started--;
 				break;
@@ -1677,48 +1750,31 @@ static void run_threads(void)
 
 		reap_threads(&nr_running, &t_rate, &m_rate);
 
-		if (todo)
-			usleep(100000);
+		if (todo) {
+			if (is_backend)
+				fio_server_idle_loop();
+			else
+				usleep(100000);
+		}
 	}
 
 	while (nr_running) {
 		reap_threads(&nr_running, &t_rate, &m_rate);
-		usleep(10000);
+
+		if (is_backend)
+			fio_server_idle_loop();
+		else
+			usleep(10000);
 	}
 
 	update_io_ticks();
 	fio_unpin_memory();
 }
 
-int main(int argc, char *argv[], char *envp[])
+int exec_run(void)
 {
-	long ps;
-
-	arch_init(envp);
-
-	sinit();
-
-	/*
-	 * We need locale for number printing, if it isn't set then just
-	 * go with the US format.
-	 */
-	if (!getenv("LC_NUMERIC"))
-		setlocale(LC_NUMERIC, "en_US");
-
-	ps = sysconf(_SC_PAGESIZE);
-	if (ps < 0) {
-		log_err("Failed to get page size\n");
-		return 1;
-	}
-
-	page_size = ps;
-	page_mask = ps - 1;
-
-	fio_keywords_init();
-
-	if (parse_options(argc, argv))
-		return 1;
-
+	if (nr_clients)
+		return fio_handle_clients();
 	if (exec_profile && load_profile(exec_profile))
 		return 1;
 
@@ -1762,3 +1818,80 @@ int main(int argc, char *argv[], char *envp[])
 	fio_mutex_remove(writeout_mutex);
 	return exit_value;
 }
+
+void reset_fio_state(void)
+{
+	groupid = 0;
+	thread_number = 0;
+	nr_process = 0;
+	nr_thread = 0;
+	done_secs = 0;
+}
+
+static int endian_check(void)
+{
+	union {
+		uint8_t c[8];
+		uint64_t v;
+	} u;
+	int le = 0, be = 0;
+
+	u.v = 0x12;
+	if (u.c[7] == 0x12)
+		be = 1;
+	else if (u.c[0] == 0x12)
+		le = 1;
+
+#if defined(FIO_LITTLE_ENDIAN)
+	if (be)
+		return 1;
+#elif defined(FIO_BIG_ENDIAN)
+	if (le)
+		return 1;
+#else
+	return 1;
+#endif
+
+	if (!le && !be)
+		return 1;
+
+	return 0;
+}
+
+int main(int argc, char *argv[], char *envp[])
+{
+	long ps;
+
+	if (endian_check()) {
+		log_err("fio: endianness settings appear wrong.\n");
+		log_err("fio: please report this to fio@vger.kernel.org\n");
+		return 1;
+	}
+
+	arch_init(envp);
+
+	sinit();
+
+	/*
+	 * We need locale for number printing, if it isn't set then just
+	 * go with the US format.
+	 */
+	if (!getenv("LC_NUMERIC"))
+		setlocale(LC_NUMERIC, "en_US");
+
+	ps = sysconf(_SC_PAGESIZE);
+	if (ps < 0) {
+		log_err("Failed to get page size\n");
+		return 1;
+	}
+
+	page_size = ps;
+	page_mask = ps - 1;
+
+	fio_keywords_init();
+
+	if (parse_options(argc, argv))
+		return 1;
+
+	return exec_run();
+}
diff --git a/fio.h b/fio.h
index 022ba57..04963cd 100644
--- a/fio.h
+++ b/fio.h
@@ -35,6 +35,8 @@ struct thread_data;
 #include "time.h"
 #include "lib/getopt.h"
 #include "lib/rand.h"
+#include "server.h"
+#include "stat.h"
 
 #ifdef FIO_HAVE_GUASI
 #include <guasi.h>
@@ -44,14 +46,6 @@ struct thread_data;
 #include <sys/asynch.h>
 #endif
 
-struct group_run_stats {
-	unsigned long long max_run[2], min_run[2];
-	unsigned long long max_bw[2], min_bw[2];
-	unsigned long long io_kb[2];
-	unsigned long long agg[2];
-	unsigned int kb_base;
-};
-
 /*
  * What type of allocation to use for io buffers
  */
@@ -71,172 +65,6 @@ enum {
 	RW_SEQ_IDENT,
 };
 
-/*
- * How many depth levels to log
- */
-#define FIO_IO_U_MAP_NR	7
-#define FIO_IO_U_LAT_U_NR 10
-#define FIO_IO_U_LAT_M_NR 12
-
-/*
- * Aggregate clat samples to report percentile(s) of them.
- *
- * EXECUTIVE SUMMARY
- *
- * FIO_IO_U_PLAT_BITS determines the maximum statistical error on the
- * value of resulting percentiles. The error will be approximately
- * 1/2^(FIO_IO_U_PLAT_BITS+1) of the value.
- *
- * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the maximum
- * range being tracked for latency samples. The maximum value tracked
- * accurately will be 2^(GROUP_NR + PLAT_BITS -1) microseconds.
- *
- * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the memory
- * requirement of storing those aggregate counts. The memory used will
- * be (FIO_IO_U_PLAT_GROUP_NR * 2^FIO_IO_U_PLAT_BITS) * sizeof(int)
- * bytes.
- *
- * FIO_IO_U_PLAT_NR is the total number of buckets.
- *
- * DETAILS
- *
- * Suppose the clat varies from 0 to 999 (usec), the straightforward
- * method is to keep an array of (999 + 1) buckets, in which a counter
- * keeps the count of samples which fall in the bucket, e.g.,
- * {[0],[1],...,[999]}. However this consumes a huge amount of space,
- * and can be avoided if an approximation is acceptable.
- *
- * One such method is to let the range of the bucket to be greater
- * than one. This method has low accuracy when the value is small. For
- * example, let the buckets be {[0,99],[100,199],...,[900,999]}, and
- * the represented value of each bucket be the mean of the range. Then
- * a value 0 has an round-off error of 49.5. To improve on this, we
- * use buckets with non-uniform ranges, while bounding the error of
- * each bucket within a ratio of the sample value. A simple example
- * would be when error_bound = 0.005, buckets are {
- * {[0],[1],...,[99]}, {[100,101],[102,103],...,[198,199]},..,
- * {[900,909],[910,919]...}  }. The total range is partitioned into
- * groups with different ranges, then buckets with uniform ranges. An
- * upper bound of the error is (range_of_bucket/2)/value_of_bucket
- *
- * For better efficiency, we implement this using base two. We group
- * samples by their Most Significant Bit (MSB), extract the next M bit
- * of them as an index within the group, and discard the rest of the
- * bits.
- *
- * E.g., assume a sample 'x' whose MSB is bit n (starting from bit 0),
- * and use M bit for indexing
- *
- *        | n |    M bits   | bit (n-M-1) ... bit 0 |
- *
- * Because x is at least 2^n, and bit 0 to bit (n-M-1) is at most
- * (2^(n-M) - 1), discarding bit 0 to (n-M-1) makes the round-off
- * error
- *
- *           2^(n-M)-1    2^(n-M)    1
- *      e <= --------- <= ------- = ---
- *             2^n          2^n     2^M
- *
- * Furthermore, we use "mean" of the range to represent the bucket,
- * the error e can be lowered by half to 1 / 2^(M+1). By using M bits
- * as the index, each group must contains 2^M buckets.
- *
- * E.g. Let M (FIO_IO_U_PLAT_BITS) be 6
- *      Error bound is 1/2^(6+1) = 0.0078125 (< 1%)
- *
- *	Group	MSB	#discarded	range of		#buckets
- *			error_bits	value
- *	----------------------------------------------------------------
- *	0*	0~5	0		[0,63]			64
- *	1*	6	0		[64,127]		64
- *	2	7	1		[128,255]		64
- *	3	8	2		[256,511]		64
- *	4	9	3		[512,1023]		64
- *	...	...	...		[...,...]		...
- *	18	23	17		[8838608,+inf]**	64
- *
- *  * Special cases: when n < (M-1) or when n == (M-1), in both cases,
- *    the value cannot be rounded off. Use all bits of the sample as
- *    index.
- *
- *  ** If a sample's MSB is greater than 23, it will be counted as 23.
- */
-
-#define FIO_IO_U_PLAT_BITS 6
-#define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
-#define FIO_IO_U_PLAT_GROUP_NR 19
-#define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
-#define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
-					list of percentiles */
-
-#define MAX_PATTERN_SIZE 512
-
-struct thread_stat {
-	char *name;
-	char *verror;
-	int error;
-	int groupid;
-	pid_t pid;
-	char *description;
-	int members;
-
-	struct io_log *slat_log;
-	struct io_log *clat_log;
-	struct io_log *lat_log;
-	struct io_log *bw_log;
-
-	/*
-	 * bandwidth and latency stats
-	 */
-	struct io_stat clat_stat[2];		/* completion latency */
-	struct io_stat slat_stat[2];		/* submission latency */
-	struct io_stat lat_stat[2];		/* total latency */
-	struct io_stat bw_stat[2];		/* bandwidth stats */
-
-	unsigned long long stat_io_bytes[2];
-	struct timeval stat_sample_time[2];
-
-	/*
-	 * fio system usage accounting
-	 */
-	struct rusage ru_start;
-	struct rusage ru_end;
-	unsigned long usr_time;
-	unsigned long sys_time;
-	unsigned long ctx;
-	unsigned long minf, majf;
-
-	/*
-	 * IO depth and latency stats
-	 */
-	unsigned int clat_percentiles;
-	double* percentile_list;
-
-	unsigned int io_u_map[FIO_IO_U_MAP_NR];
-	unsigned int io_u_submit[FIO_IO_U_MAP_NR];
-	unsigned int io_u_complete[FIO_IO_U_MAP_NR];
-	unsigned int io_u_lat_u[FIO_IO_U_LAT_U_NR];
-	unsigned int io_u_lat_m[FIO_IO_U_LAT_M_NR];
-	unsigned int io_u_plat[2][FIO_IO_U_PLAT_NR];
-	unsigned long total_io_u[3];
-	unsigned long short_io_u[3];
-	unsigned long total_submit;
-	unsigned long total_complete;
-
-	unsigned long long io_bytes[2];
-	unsigned long long runtime[2];
-	unsigned long total_run_time;
-
-	/*
-	 * IO Error related stats
-	 */
-	unsigned continue_on_error;
-	unsigned long total_err_count;
-	int first_error;
-
-	unsigned int kb_base;
-};
-
 struct bssplit {
 	unsigned int bs;
 	unsigned char perc;
@@ -307,6 +135,7 @@ struct thread_options {
 	unsigned int use_os_rand;
 	unsigned int write_lat_log;
 	unsigned int write_bw_log;
+	unsigned int write_iops_log;
 	unsigned int norandommap;
 	unsigned int softrandommap;
 	unsigned int bs_unaligned;
@@ -325,6 +154,7 @@ struct thread_options {
 	unsigned long long ramp_time;
 	unsigned int overwrite;
 	unsigned int bw_avg_time;
+	unsigned int iops_avg_time;
 	unsigned int loops;
 	unsigned long long zone_size;
 	unsigned long long zone_skip;
@@ -365,12 +195,13 @@ struct thread_options {
 	unsigned long long trim_backlog;
 	unsigned int clat_percentiles;
 	unsigned int overwrite_plist;
-	double percentile_list[FIO_IO_U_LIST_MAX_LEN];
+	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	char *read_iolog_file;
 	char *write_iolog_file;
 	char *bw_log_file;
 	char *lat_log_file;
+	char *iops_log_file;
 	char *replay_redirect;
 
 	/*
@@ -418,8 +249,6 @@ struct thread_options {
 	unsigned int userspace_libaio_reap;
 };
 
-#define FIO_VERROR_SIZE	128
-
 /*
  * This describes a single thread/process executing a fio job.
  */
@@ -430,6 +259,22 @@ struct thread_data {
 	int thread_number;
 	int groupid;
 	struct thread_stat ts;
+
+	struct io_log *slat_log;
+	struct io_log *clat_log;
+	struct io_log *lat_log;
+	struct io_log *bw_log;
+	struct io_log *iops_log;
+
+	uint64_t stat_io_bytes[2];
+	struct timeval bw_sample_time;
+
+	uint64_t stat_io_blocks[2];
+	struct timeval iops_sample_time;
+
+	struct rusage ru_start;
+	struct rusage ru_end;
+
 	struct fio_file **files;
 	unsigned int files_size;
 	unsigned int files_index;
@@ -523,6 +368,7 @@ struct thread_data {
 
 	unsigned long io_issues[2];
 	unsigned long long io_blocks[2];
+	unsigned long long this_io_blocks[2];
 	unsigned long long io_bytes[2];
 	unsigned long long io_skip_bytes;
 	unsigned long long this_io_bytes[2];
@@ -632,6 +478,9 @@ enum {
 #define td_vmsg(td, err, msg, func)	\
 	__td_verror((td), (err), (msg), (func))
 
+#define __fio_stringify_1(x)	#x
+#define __fio_stringify(x)	__fio_stringify_1(x)
+
 extern int exitall_on_terminate;
 extern int thread_number;
 extern int nr_process, nr_thread;
@@ -650,6 +499,10 @@ extern int fio_gtod_cpu;
 extern enum fio_cs fio_clock_source;
 extern int warnings_fatal;
 extern int terse_version;
+extern int is_backend;
+extern int nr_clients;
+extern int log_syslog;
+extern const fio_fp64_t def_percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 extern struct thread_data *threads;
 
@@ -690,6 +543,10 @@ static inline int should_fsync(struct thread_data *td)
  * Init/option functions
  */
 extern int __must_check parse_options(int, char **);
+extern int parse_jobs_ini(char *, int, int);
+extern int parse_cmd_line(int, char **);
+extern int exec_run(void);
+extern void reset_fio_state(void);
 extern int fio_options_parse(struct thread_data *, char **, int);
 extern void fio_keywords_init(void);
 extern int fio_cmd_option_parse(struct thread_data *, const char *, char *);
@@ -731,6 +588,8 @@ enum {
 };
 
 extern void td_set_runstate(struct thread_data *, int);
+#define TERMINATE_ALL		(-1)
+extern void fio_terminate_threads(int);
 
 /*
  * Memory helpers
@@ -842,4 +701,7 @@ static inline void td_io_u_free_notify(struct thread_data *td)
 		pthread_cond_signal(&td->free_cond);
 }
 
+extern const char *fio_get_arch_string(int);
+extern const char *fio_get_os_string(int);
+
 #endif
diff --git a/fio_generate_plots b/fio_generate_plots
index 21d7c6a..4285415 100755
--- a/fio_generate_plots
+++ b/fio_generate_plots
@@ -43,6 +43,24 @@ if [ "$PLOT_LINE"x != "x" ]; then
 fi
 
 PLOT_LINE=""
+for i in *iops.log; do
+	if [ ! -r $i ]; then
+		continue
+	fi
+	PT=$(echo $i | sed s/_iops.log//g)
+	if [ "$PLOT_LINE"x != "x" ]; then
+		PLOT_LINE=$PLOT_LINE", "
+	fi
+
+	PLOT_LINE=$PLOT_LINE"'$i' title '$PT' with lines"
+done
+
+if [ "$PLOT_LINE"x != "x" ]; then
+	echo Making bw logs
+	echo "set title 'IOPS - $TITLE'; set xlabel 'time (msec)'; set ylabel 'IOPS'; set terminal png size $XRES,$YRES; set output '$TITLE-IOPS.png'; plot " $PLOT_LINE | $GNUPLOT -
+fi
+
+PLOT_LINE=""
 for i in *slat.log; do
 	if [ ! -r $i ]; then
 		continue
diff --git a/fio_version.h b/fio_version.h
new file mode 100644
index 0000000..3008c64
--- /dev/null
+++ b/fio_version.h
@@ -0,0 +1,8 @@
+#ifndef FIO_VERSION_H
+#define FIO_VERSION_H
+
+#define FIO_MAJOR	1
+#define FIO_MINOR	99
+#define FIO_PATCH	6
+
+#endif
diff --git a/hash.h b/hash.h
index 73f961b..0c3cdda 100644
--- a/hash.h
+++ b/hash.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_HASH_H
 #define _LINUX_HASH_H
 
+#include <inttypes.h>
 #include "arch/arch.h"
 
 /* Fast hashing routine for a long.
@@ -59,4 +60,80 @@ static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
 {
 	return hash_long((unsigned long)ptr, bits);
 }
+
+/*
+ * Bob Jenkins jhash
+ */
+
+#define JHASH_INITVAL	GOLDEN_RATIO_PRIME
+
+static inline uint32_t rol32(uint32_t word, uint32_t shift)
+{
+	return (word << shift) | (word >> (32 - shift));
+}
+
+/* __jhash_mix -- mix 3 32-bit values reversibly. */
+#define __jhash_mix(a, b, c)			\
+{						\
+	a -= c;  a ^= rol32(c, 4);  c += b;	\
+	b -= a;  b ^= rol32(a, 6);  a += c;	\
+	c -= b;  c ^= rol32(b, 8);  b += a;	\
+	a -= c;  a ^= rol32(c, 16); c += b;	\
+	b -= a;  b ^= rol32(a, 19); a += c;	\
+	c -= b;  c ^= rol32(b, 4);  b += a;	\
+}
+
+/* __jhash_final - final mixing of 3 32-bit values (a,b,c) into c */
+#define __jhash_final(a, b, c)			\
+{						\
+	c ^= b; c -= rol32(b, 14);		\
+	a ^= c; a -= rol32(c, 11);		\
+	b ^= a; b -= rol32(a, 25);		\
+	c ^= b; c -= rol32(b, 16);		\
+	a ^= c; a -= rol32(c, 4);		\
+	b ^= a; b -= rol32(a, 14);		\
+	c ^= b; c -= rol32(b, 24);		\
+}
+
+static inline uint32_t jhash(const void *key, uint32_t length, uint32_t initval)
+{
+	const uint8_t *k = key;
+	uint32_t a, b, c;
+
+	/* Set up the internal state */
+	a = b = c = JHASH_INITVAL + length + initval;
+
+	/* All but the last block: affect some 32 bits of (a,b,c) */
+	while (length > 12) {
+		a += *k;
+		b += *(k + 4);
+		c += *(k + 8);
+		__jhash_mix(a, b, c);
+		length -= 12;
+		k += 12;
+	}
+
+	/* Last block: affect all 32 bits of (c) */
+	/* All the case statements fall through */
+	switch (length) {
+	case 12: c += (uint32_t) k[11] << 24;
+	case 11: c += (uint32_t) k[10] << 16;
+	case 10: c += (uint32_t) k[9] << 8;
+	case 9:  c += k[8];
+	case 8:  b += (uint32_t) k[7] << 24;
+	case 7:  b += (uint32_t) k[6] << 16;
+	case 6:  b += (uint32_t) k[5] << 8;
+	case 5:  b += k[4];
+	case 4:  a += (uint32_t) k[3] << 24;
+	case 3:  a += (uint32_t) k[2] << 16;
+	case 2:  a += (uint32_t) k[1] << 8;
+	case 1:  a += k[0];
+		 __jhash_final(a, b, c);
+	case 0: /* Nothing left to add */
+		break;
+	}
+
+	return c;
+}
+
 #endif /* _LINUX_HASH_H */
diff --git a/init.c b/init.c
index 0435dd0..5bea948 100644
--- a/init.c
+++ b/init.c
@@ -19,10 +19,20 @@
 #include "filehash.h"
 #include "verify.h"
 #include "profile.h"
+#include "server.h"
 
 #include "lib/getopt.h"
 
-static char fio_version_string[] = "fio 1.59";
+#include "fio_version.h"
+
+#if FIO_PATCH > 0
+static char fio_version_string[] =	__fio_stringify(FIO_MAJOR) "."	\
+					__fio_stringify(FIO_MINOR) "."	\
+					__fio_stringify(FIO_PATCH);
+#else
+static char fio_version_string[] =	__fio_stringify(FIO_MAJOR) "."	\
+					__fio_stringify(FIO_MINOR);
+#endif
 
 #define FIO_RANDSEED		(0xb1899bedUL)
 
@@ -45,6 +55,9 @@ int nr_job_sections = 0;
 char *exec_profile = NULL;
 int warnings_fatal = 0;
 int terse_version = 2;
+int is_backend = 0;
+int nr_clients = 0;
+int log_syslog = 0;
 
 int write_bw_log = 0;
 int read_only = 0;
@@ -58,6 +71,27 @@ unsigned int fio_debug_jobno = -1;
 unsigned int *fio_debug_jobp = NULL;
 
 static char cmd_optstr[256];
+static int did_arg;
+
+const fio_fp64_t def_percentile_list[FIO_IO_U_LIST_MAX_LEN] = {
+	{ .u.f	=  1.0 },
+	{ .u.f	=  5.0 },
+	{ .u.f	= 10.0 },
+	{ .u.f	= 20.0 },
+	{ .u.f	= 30.0 },
+	{ .u.f	= 40.0 },
+	{ .u.f	= 50.0 },
+	{ .u.f	= 60.0 },
+	{ .u.f	= 70.0 },
+	{ .u.f	= 80.0 },
+	{ .u.f	= 90.0 },
+	{ .u.f	= 95.0 },
+	{ .u.f	= 99.0 },
+	{ .u.f	= 99.5 },
+	{ .u.f	= 99.9 },
+};
+
+#define FIO_CLIENT_FLAG		(1 << 16)
 
 /*
  * Command line options. These will contain the above, plus a few
@@ -67,106 +101,178 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	{
 		.name		= (char *) "output",
 		.has_arg	= required_argument,
-		.val		= 'o',
+		.val		= 'o' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "timeout",
 		.has_arg	= required_argument,
-		.val		= 't',
+		.val		= 't' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "latency-log",
 		.has_arg	= required_argument,
-		.val		= 'l',
+		.val		= 'l' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "bandwidth-log",
 		.has_arg	= required_argument,
-		.val		= 'b',
+		.val		= 'b' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "minimal",
 		.has_arg	= optional_argument,
-		.val		= 'm',
+		.val		= 'm' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "version",
 		.has_arg	= no_argument,
-		.val		= 'v',
+		.val		= 'v' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "help",
 		.has_arg	= no_argument,
-		.val		= 'h',
+		.val		= 'h' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "cmdhelp",
 		.has_arg	= optional_argument,
-		.val		= 'c',
+		.val		= 'c' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "showcmd",
 		.has_arg	= no_argument,
-		.val		= 's',
+		.val		= 's' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "readonly",
 		.has_arg	= no_argument,
-		.val		= 'r',
+		.val		= 'r' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "eta",
 		.has_arg	= required_argument,
-		.val		= 'e',
+		.val		= 'e' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "debug",
 		.has_arg	= required_argument,
-		.val		= 'd',
+		.val		= 'd' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "section",
 		.has_arg	= required_argument,
-		.val		= 'x',
+		.val		= 'x' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "alloc-size",
 		.has_arg	= required_argument,
-		.val		= 'a',
+		.val		= 'a' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "profile",
 		.has_arg	= required_argument,
-		.val		= 'p',
+		.val		= 'p' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "warnings-fatal",
 		.has_arg	= no_argument,
-		.val		= 'w',
+		.val		= 'w' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "max-jobs",
 		.has_arg	= required_argument,
-		.val		= 'j',
+		.val		= 'j' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "terse-version",
 		.has_arg	= required_argument,
-		.val		= 'V',
+		.val		= 'V' | FIO_CLIENT_FLAG,
+	},
+	{
+		.name		= (char *) "server",
+		.has_arg	= optional_argument,
+		.val		= 'S',
+	},
+	{	.name		= (char *) "daemonize",
+		.has_arg	= required_argument,
+		.val		= 'D',
+	},
+	{
+		.name		= (char *) "client",
+		.has_arg	= required_argument,
+		.val		= 'C',
 	},
 	{
 		.name		= NULL,
 	},
 };
 
-FILE *get_f_out()
+static void free_shm(void)
 {
-	return f_out;
+	struct shmid_ds sbuf;
+
+	if (threads) {
+		void *tp = threads;
+
+		threads = NULL;
+		file_hash_exit();
+		fio_debug_jobp = NULL;
+		shmdt(tp);
+		shmctl(shm_id, IPC_RMID, &sbuf);
+	}
+
+	scleanup();
 }
 
-FILE *get_f_err()
+/*
+ * The thread area is shared between the main process and the job
+ * threads/processes. So setup a shared memory segment that will hold
+ * all the job info. We use the end of the region for keeping track of
+ * open files across jobs, for file sharing.
+ */
+static int setup_thread_area(void)
 {
-	return f_err;
+	void *hash;
+
+	if (threads)
+		return 0;
+
+	/*
+	 * 1024 is too much on some machines, scale max_jobs if
+	 * we get a failure that looks like too large a shm segment
+	 */
+	do {
+		size_t size = max_jobs * sizeof(struct thread_data);
+
+		size += file_hash_size;
+		size += sizeof(unsigned int);
+
+		shm_id = shmget(0, size, IPC_CREAT | 0600);
+		if (shm_id != -1)
+			break;
+		if (errno != EINVAL) {
+			perror("shmget");
+			break;
+		}
+
+		max_jobs >>= 1;
+	} while (max_jobs);
+
+	if (shm_id == -1)
+		return 1;
+
+	threads = shmat(shm_id, NULL, 0);
+	if (threads == (void *) -1) {
+		perror("shmat");
+		return 1;
+	}
+
+	memset(threads, 0, max_jobs * sizeof(struct thread_data));
+	hash = (void *) threads + max_jobs * sizeof(struct thread_data);
+	fio_debug_jobp = (void *) hash + file_hash_size;
+	*fio_debug_jobp = -1;
+	file_hash_init(hash);
+	return 0;
 }
 
 /*
@@ -178,6 +284,10 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent)
 
 	if (global)
 		return &def_thread;
+	if (setup_thread_area()) {
+		log_err("error: failed to setup shm segment\n");
+		return NULL;
+	}
 	if (thread_number >= max_jobs) {
 		log_err("error: maximum number of jobs (%d) reached.\n",
 				max_jobs);
@@ -627,9 +737,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 
 	td->ts.clat_percentiles = td->o.clat_percentiles;
 	if (td->o.overwrite_plist)
-		td->ts.percentile_list = td->o.percentile_list;
+		memcpy(td->ts.percentile_list, td->o.percentile_list, sizeof(td->o.percentile_list));
 	else
-		td->ts.percentile_list = NULL;
+		memcpy(td->ts.percentile_list, def_percentile_list, sizeof(def_percentile_list));
 
 	td->ts.clat_stat[0].min_val = td->ts.clat_stat[1].min_val = ULONG_MAX;
 	td->ts.slat_stat[0].min_val = td->ts.slat_stat[1].min_val = ULONG_MAX;
@@ -652,12 +762,14 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 		goto err;
 
 	if (td->o.write_lat_log) {
-		setup_log(&td->ts.lat_log);
-		setup_log(&td->ts.slat_log);
-		setup_log(&td->ts.clat_log);
+		setup_log(&td->lat_log);
+		setup_log(&td->slat_log);
+		setup_log(&td->clat_log);
 	}
 	if (td->o.write_bw_log)
-		setup_log(&td->ts.bw_log);
+		setup_log(&td->bw_log);
+	if (td->o.write_iops_log)
+		setup_log(&td->iops_log);
 
 	if (!td->o.name)
 		td->o.name = strdup(jobname);
@@ -800,7 +912,7 @@ static int is_empty_or_comment(char *line)
 /*
  * This is our [ini] type file parser.
  */
-static int parse_jobs_ini(char *file, int stonewall_flag)
+int parse_jobs_ini(char *file, int is_buf, int stonewall_flag)
 {
 	unsigned int global;
 	struct thread_data *td;
@@ -814,14 +926,18 @@ static int parse_jobs_ini(char *file, int stonewall_flag)
 	char **opts;
 	int i, alloc_opts, num_opts;
 
-	if (!strcmp(file, "-"))
-		f = stdin;
-	else
-		f = fopen(file, "r");
+	if (is_buf)
+		f = NULL;
+	else {
+		if (!strcmp(file, "-"))
+			f = stdin;
+		else
+			f = fopen(file, "r");
 
-	if (!f) {
-		perror("fopen job file");
-		return 1;
+		if (!f) {
+			perror("fopen job file");
+			return 1;
+		}
 	}
 
 	string = malloc(4096);
@@ -843,7 +959,10 @@ static int parse_jobs_ini(char *file, int stonewall_flag)
 		 * haven't handled.
 		 */
 		if (!skip_fgets) {
-			p = fgets(string, 4095, f);
+			if (is_buf)
+				p = strsep(&file, "\n");
+			else
+				p = fgets(string, 4095, f);
 			if (!p)
 				break;
 		}
@@ -897,7 +1016,14 @@ static int parse_jobs_ini(char *file, int stonewall_flag)
 		num_opts = 0;
 		memset(opts, 0, alloc_opts * sizeof(char *));
 
-		while ((p = fgets(string, 4096, f)) != NULL) {
+		while (1) {
+			if (is_buf)
+				p = strsep(&file, "\n");
+			else
+				p = fgets(string, 4096, f);
+			if (!p)
+				break;
+
 			if (is_empty_or_comment(p))
 				continue;
 
@@ -950,7 +1076,7 @@ static int parse_jobs_ini(char *file, int stonewall_flag)
 	free(string);
 	free(name);
 	free(opts);
-	if (f != stdin)
+	if (!is_buf && f != stdin)
 		fclose(f);
 	return ret;
 }
@@ -969,75 +1095,9 @@ static int fill_def_thread(void)
 	return 0;
 }
 
-static void free_shm(void)
-{
-	struct shmid_ds sbuf;
-
-	if (threads) {
-		void *tp = threads;
-
-		threads = NULL;
-		file_hash_exit();
-		fio_debug_jobp = NULL;
-		shmdt(tp);
-		shmctl(shm_id, IPC_RMID, &sbuf);
-	}
-
-	scleanup();
-}
-
-/*
- * The thread area is shared between the main process and the job
- * threads/processes. So setup a shared memory segment that will hold
- * all the job info. We use the end of the region for keeping track of
- * open files across jobs, for file sharing.
- */
-static int setup_thread_area(void)
-{
-	void *hash;
-
-	/*
-	 * 1024 is too much on some machines, scale max_jobs if
-	 * we get a failure that looks like too large a shm segment
-	 */
-	do {
-		size_t size = max_jobs * sizeof(struct thread_data);
-
-		size += file_hash_size;
-		size += sizeof(unsigned int);
-
-		shm_id = shmget(0, size, IPC_CREAT | 0600);
-		if (shm_id != -1)
-			break;
-		if (errno != EINVAL) {
-			perror("shmget");
-			break;
-		}
-
-		max_jobs >>= 1;
-	} while (max_jobs);
-
-	if (shm_id == -1)
-		return 1;
-
-	threads = shmat(shm_id, NULL, 0);
-	if (threads == (void *) -1) {
-		perror("shmat");
-		return 1;
-	}
-
-	memset(threads, 0, max_jobs * sizeof(struct thread_data));
-	hash = (void *) threads + max_jobs * sizeof(struct thread_data);
-	fio_debug_jobp = (void *) hash + file_hash_size;
-	*fio_debug_jobp = -1;
-	file_hash_init(hash);
-	atexit(free_shm);
-	return 0;
-}
-
 static void usage(const char *name)
 {
-	printf("%s\n", fio_version_string);
+	printf("fio %s\n", fio_version_string);
 	printf("%s [options] [job options] <job file(s)>\n", name);
 	printf("\t--debug=options\tEnable debug logging\n");
 	printf("\t--output\tWrite output to file\n");
@@ -1060,6 +1120,9 @@ static void usage(const char *name)
 		" (def 1024)\n");
 	printf("\t--warnings-fatal Fio parser warnings are fatal\n");
 	printf("\t--max-jobs\tMaximum number of threads/processes to support\n");
+	printf("\t--server=args\tStart a backend fio server\n");
+	printf("\t--daemonize=pidfile Background fio server, write pid to file\n");
+	printf("\t--client=hostname Talk to remote backend fio server at hostname\n");
 	printf("\nFio was written by Jens Axboe <jens.axboe@oracle.com>");
 	printf("\n                   Jens Axboe <jaxboe@fusionio.com>\n");
 }
@@ -1079,6 +1142,7 @@ struct debug_level debug_levels[] = {
 	{ .name = "mutex",	.shift = FD_MUTEX },
 	{ .name	= "profile",	.shift = FD_PROFILE },
 	{ .name = "time",	.shift = FD_TIME },
+	{ .name = "net",	.shift = FD_NET },
 	{ .name = NULL, },
 };
 
@@ -1163,13 +1227,51 @@ static void fio_options_fill_optstring(void)
 	ostr[c] = '\0';
 }
 
-static int parse_cmd_line(int argc, char *argv[])
+static int client_flag_set(char c)
+{
+	int i;
+
+	i = 0;
+	while (l_opts[i].name) {
+		int val = l_opts[i].val;
+
+		if (c == (val & 0xff))
+			return (val & FIO_CLIENT_FLAG);
+
+		i++;
+	}
+
+	return 0;
+}
+
+void parse_cmd_client(void *client, char *opt)
+{
+	fio_client_add_cmd_option(client, opt);
+}
+
+int parse_cmd_line(int argc, char *argv[])
 {
 	struct thread_data *td = NULL;
 	int c, ini_idx = 0, lidx, ret = 0, do_exit = 0, exit_val = 0;
 	char *ostr = cmd_optstr;
+	void *pid_file = NULL;
+	void *cur_client = NULL;
+	int backend = 0;
+
+	/*
+	 * Reset optind handling, since we may call this multiple times
+	 * for the backend.
+	 */
+	optind = 1;
 
 	while ((c = getopt_long_only(argc, argv, ostr, l_opts, &lidx)) != -1) {
+		did_arg = 1;
+
+		if ((c & FIO_CLIENT_FLAG) || client_flag_set(c)) {
+			parse_cmd_client(cur_client, argv[optind - 1]);
+			c &= ~FIO_CLIENT_FLAG;
+		}
+
 		switch (c) {
 		case 'a':
 			smalloc_pool_size = atoi(optarg);
@@ -1195,10 +1297,17 @@ static int parse_cmd_line(int argc, char *argv[])
 			terse_output = 1;
 			break;
 		case 'h':
-			usage(argv[0]);
-			exit(0);
+			if (!cur_client) {
+				usage(argv[0]);
+				do_exit++;
+			}
+			break;
 		case 'c':
-			exit(fio_show_option_help(optarg));
+			if (!cur_client) {
+				fio_show_option_help(optarg);
+				do_exit++;
+			}
+			break;
 		case 's':
 			dump_cmdline = 1;
 			break;
@@ -1206,11 +1315,14 @@ static int parse_cmd_line(int argc, char *argv[])
 			read_only = 1;
 			break;
 		case 'v':
-			log_info("%s\n", fio_version_string);
-			exit(0);
+			if (!cur_client) {
+				log_info("fio %s\n", fio_version_string);
+				do_exit++;
+			}
+			break;
 		case 'V':
 			terse_version = atoi(optarg);
-			if (terse_version != 2) {
+			if (terse_version != 3) {
 				log_err("fio: bad terse version format\n");
 				exit_val = 1;
 				do_exit++;
@@ -1284,22 +1396,64 @@ static int parse_cmd_line(int argc, char *argv[])
 				exit_val = 1;
 			}
 			break;
+		case 'S':
+			if (nr_clients) {
+				log_err("fio: can't be both client and server\n");
+				do_exit++;
+				exit_val = 1;
+				break;
+			}
+			if (optarg)
+				fio_server_set_arg(optarg);
+			is_backend = 1;
+			backend = 1;
+			break;
+		case 'D':
+			pid_file = strdup(optarg);
+			break;
+		case 'C':
+			if (is_backend) {
+				log_err("fio: can't be both client and server\n");
+				do_exit++;
+				exit_val = 1;
+				break;
+			}
+			if (fio_client_add(optarg, &cur_client)) {
+				log_err("fio: failed adding client %s\n", optarg);
+				do_exit++;
+				exit_val = 1;
+				break;
+			}
+			break;
 		default:
 			do_exit++;
 			exit_val = 1;
 			break;
 		}
+		if (do_exit)
+			break;
+	}
+
+	if (do_exit) {
+		if (exit_val && !(is_backend || nr_clients))
+			exit(exit_val);
 	}
 
-	if (do_exit)
-		exit(exit_val);
+	if (nr_clients && fio_clients_connect()) {
+		do_exit++;
+		exit_val = 1;
+		return -1;
+	}
+
+	if (is_backend && backend)
+		return fio_start_server(pid_file);
 
 	if (td) {
 		if (!ret)
 			ret = add_job(td, td->o.name ?: "fio", 0);
 	}
 
-	while (optind < argc) {
+	while (!ret && optind < argc) {
 		ini_idx++;
 		ini_file = realloc(ini_file, ini_idx * sizeof(char *));
 		ini_file[ini_idx - 1] = strdup(argv[optind]);
@@ -1319,19 +1473,27 @@ int parse_options(int argc, char *argv[])
 	fio_options_fill_optstring();
 	fio_options_dup_and_init(l_opts);
 
-	if (setup_thread_area())
-		return 1;
+	atexit(free_shm);
+
 	if (fill_def_thread())
 		return 1;
 
 	job_files = parse_cmd_line(argc, argv);
 
-	for (i = 0; i < job_files; i++) {
-		if (fill_def_thread())
-			return 1;
-		if (parse_jobs_ini(ini_file[i], i))
-			return 1;
-		free(ini_file[i]);
+	if (job_files > 0) {
+		for (i = 0; i < job_files; i++) {
+			if (fill_def_thread())
+				return 1;
+			if (nr_clients) {
+				if (fio_clients_send_ini(ini_file[i]))
+					return 1;
+				free(ini_file[i]);
+			} else if (!is_backend) {
+				if (parse_jobs_ini(ini_file[i], 0, i))
+					return 1;
+				free(ini_file[i]);
+			}
+		}
 	}
 
 	free(ini_file);
@@ -1342,10 +1504,19 @@ int parse_options(int argc, char *argv[])
 			return 0;
 		if (exec_profile)
 			return 0;
+		if (is_backend || nr_clients)
+			return 0;
+		if (did_arg)
+			return 0;
 
 		log_err("No jobs(s) defined\n\n");
-		usage(argv[0]);
-		return 1;
+
+		if (!did_arg) {
+			usage(argv[0]);
+			return 1;
+		}
+
+		return 0;
 	}
 
 	if (def_thread.o.gtod_offload) {
@@ -1354,6 +1525,8 @@ int parse_options(int argc, char *argv[])
 		fio_gtod_cpu = def_thread.o.gtod_cpu;
 	}
 
-	log_info("%s\n", fio_version_string);
+	if (!terse_output)
+		log_info("fio %s\n", fio_version_string);
+
 	return 0;
 }
diff --git a/io_u.c b/io_u.c
index 4dcb1fc..d1f66a9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1293,6 +1293,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (!td->o.disable_bw)
 		add_bw_sample(td, idx, bytes, &icd->time);
+
+	add_iops_sample(td, idx, &icd->time);
 }
 
 static void io_completed(struct thread_data *td, struct io_u *io_u,
@@ -1332,6 +1334,7 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 		int ret;
 
 		td->io_blocks[idx]++;
+		td->this_io_blocks[idx]++;
 		td->io_bytes[idx] += bytes;
 		td->this_io_bytes[idx] += bytes;
 
@@ -1347,7 +1350,7 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 			}
 		}
 
-		if (ramp_time_over(td)) {
+		if (ramp_time_over(td) && td->runstate == TD_RUNNING) {
 			account_io_completion(td, io_u, icd, idx, bytes);
 
 			if (__should_check_rate(td, idx)) {
diff --git a/iolog.c b/iolog.c
new file mode 100644
index 0000000..f962864
--- /dev/null
+++ b/iolog.c
@@ -0,0 +1,541 @@
+/*
+ * Code related to writing an iolog of what a thread is doing, and to
+ * later read that back and replay
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <libgen.h>
+#include <assert.h>
+#include "flist.h"
+#include "fio.h"
+#include "verify.h"
+#include "trim.h"
+
+static const char iolog_ver2[] = "fio version 2 iolog";
+
+void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
+{
+	flist_add_tail(&ipo->list, &td->io_log_list);
+	td->total_io_size += ipo->len;
+}
+
+void log_io_u(struct thread_data *td, struct io_u *io_u)
+{
+	const char *act[] = { "read", "write", "sync", "datasync",
+				"sync_file_range", "wait", "trim" };
+
+	assert(io_u->ddir <= 6);
+
+	if (!td->o.write_iolog_file)
+		return;
+
+	fprintf(td->iolog_f, "%s %s %llu %lu\n", io_u->file->file_name,
+						act[io_u->ddir], io_u->offset,
+						io_u->buflen);
+}
+
+void log_file(struct thread_data *td, struct fio_file *f,
+	      enum file_log_act what)
+{
+	const char *act[] = { "add", "open", "close" };
+
+	assert(what < 3);
+
+	if (!td->o.write_iolog_file)
+		return;
+
+
+	/*
+	 * this happens on the pre-open/close done before the job starts
+	 */
+	if (!td->iolog_f)
+		return;
+
+	fprintf(td->iolog_f, "%s %s\n", f->file_name, act[what]);
+}
+
+static void iolog_delay(struct thread_data *td, unsigned long delay)
+{
+	unsigned long usec = utime_since_now(&td->last_issue);
+
+	if (delay < usec)
+		return;
+
+	delay -= usec;
+
+	/*
+	 * less than 100 usec delay, just regard it as noise
+	 */
+	if (delay < 100)
+		return;
+
+	usec_sleep(td, delay);
+}
+
+static int ipo_special(struct thread_data *td, struct io_piece *ipo)
+{
+	struct fio_file *f;
+	int ret;
+
+	/*
+	 * Not a special ipo
+	 */
+	if (ipo->ddir != DDIR_INVAL)
+		return 0;
+
+	f = td->files[ipo->fileno];
+
+	switch (ipo->file_action) {
+	case FIO_LOG_OPEN_FILE:
+		ret = td_io_open_file(td, f);
+		if (!ret)
+			break;
+		td_verror(td, ret, "iolog open file");
+		return -1;
+	case FIO_LOG_CLOSE_FILE:
+		td_io_close_file(td, f);
+		break;
+	case FIO_LOG_UNLINK_FILE:
+		unlink(f->file_name);
+		break;
+	default:
+		log_err("fio: bad file action %d\n", ipo->file_action);
+		break;
+	}
+
+	return 1;
+}
+
+int read_iolog_get(struct thread_data *td, struct io_u *io_u)
+{
+	struct io_piece *ipo;
+	unsigned long elapsed;
+	
+	while (!flist_empty(&td->io_log_list)) {
+		int ret;
+
+		ipo = flist_entry(td->io_log_list.next, struct io_piece, list);
+		flist_del(&ipo->list);
+		remove_trim_entry(td, ipo);
+
+		ret = ipo_special(td, ipo);
+		if (ret < 0) {
+			free(ipo);
+			break;
+		} else if (ret > 0) {
+			free(ipo);
+			continue;
+		}
+
+		io_u->ddir = ipo->ddir;
+		if (ipo->ddir != DDIR_WAIT) {
+			io_u->offset = ipo->offset;
+			io_u->buflen = ipo->len;
+			io_u->file = td->files[ipo->fileno];
+			get_file(io_u->file);
+			dprint(FD_IO, "iolog: get %llu/%lu/%s\n", io_u->offset,
+						io_u->buflen, io_u->file->file_name);
+			if (ipo->delay)
+				iolog_delay(td, ipo->delay);
+		} else {
+			elapsed = mtime_since_genesis();
+			if (ipo->delay > elapsed)
+				usec_sleep(td, (ipo->delay - elapsed) * 1000);
+				
+		}
+
+		free(ipo);
+		
+		if (io_u->ddir != DDIR_WAIT)
+			return 0;
+	}
+
+	td->done = 1;
+	return 1;
+}
+
+void prune_io_piece_log(struct thread_data *td)
+{
+	struct io_piece *ipo;
+	struct rb_node *n;
+
+	while ((n = rb_first(&td->io_hist_tree)) != NULL) {
+		ipo = rb_entry(n, struct io_piece, rb_node);
+		rb_erase(n, &td->io_hist_tree);
+		remove_trim_entry(td, ipo);
+		td->io_hist_len--;
+		free(ipo);
+	}
+
+	while (!flist_empty(&td->io_hist_list)) {
+		ipo = flist_entry(td->io_hist_list.next, struct io_piece, list);
+		flist_del(&ipo->list);
+		remove_trim_entry(td, ipo);
+		td->io_hist_len--;
+		free(ipo);
+	}
+}
+
+/*
+ * log a successful write, so we can unwind the log for verify
+ */
+void log_io_piece(struct thread_data *td, struct io_u *io_u)
+{
+	struct rb_node **p, *parent;
+	struct io_piece *ipo, *__ipo;
+
+	ipo = malloc(sizeof(struct io_piece));
+	init_ipo(ipo);
+	ipo->file = io_u->file;
+	ipo->offset = io_u->offset;
+	ipo->len = io_u->buflen;
+
+	if (io_u_should_trim(td, io_u)) {
+		flist_add_tail(&ipo->trim_list, &td->trim_list);
+		td->trim_entries++;
+	}
+
+	/*
+	 * We don't need to sort the entries, if:
+	 *
+	 *	Sequential writes, or
+	 *	Random writes that lay out the file as it goes along
+	 *
+	 * For both these cases, just reading back data in the order we
+	 * wrote it out is the fastest.
+	 *
+	 * One exception is if we don't have a random map AND we are doing
+	 * verifies, in that case we need to check for duplicate blocks and
+	 * drop the old one, which we rely on the rb insert/lookup for
+	 * handling.
+	 */
+	if ((!td_random(td) || !td->o.overwrite) &&
+	      (file_randommap(td, ipo->file) || td->o.verify == VERIFY_NONE)) {
+		INIT_FLIST_HEAD(&ipo->list);
+		flist_add_tail(&ipo->list, &td->io_hist_list);
+		ipo->flags |= IP_F_ONLIST;
+		td->io_hist_len++;
+		return;
+	}
+
+	RB_CLEAR_NODE(&ipo->rb_node);
+
+	/*
+	 * Sort the entry into the verification list
+	 */
+restart:
+	p = &td->io_hist_tree.rb_node;
+	parent = NULL;
+	while (*p) {
+		parent = *p;
+
+		__ipo = rb_entry(parent, struct io_piece, rb_node);
+		if (ipo->file < __ipo->file)
+			p = &(*p)->rb_left;
+		else if (ipo->file > __ipo->file)
+			p = &(*p)->rb_right;
+		else if (ipo->offset < __ipo->offset)
+			p = &(*p)->rb_left;
+		else if (ipo->offset > __ipo->offset)
+			p = &(*p)->rb_right;
+		else {
+			assert(ipo->len == __ipo->len);
+			td->io_hist_len--;
+			rb_erase(parent, &td->io_hist_tree);
+			remove_trim_entry(td, __ipo);
+			free(__ipo);
+			goto restart;
+		}
+	}
+
+	rb_link_node(&ipo->rb_node, parent, p);
+	rb_insert_color(&ipo->rb_node, &td->io_hist_tree);
+	ipo->flags |= IP_F_ONRB;
+	td->io_hist_len++;
+}
+
+void write_iolog_close(struct thread_data *td)
+{
+	fflush(td->iolog_f);
+	fclose(td->iolog_f);
+	free(td->iolog_buf);
+	td->iolog_f = NULL;
+	td->iolog_buf = NULL;
+}
+
+/*
+ * Read version 2 iolog data. It is enhanced to include per-file logging,
+ * syncs, etc.
+ */
+static int read_iolog2(struct thread_data *td, FILE *f)
+{
+	unsigned long long offset;
+	unsigned int bytes;
+	int reads, writes, waits, fileno = 0, file_action = 0; /* stupid gcc */
+	char *fname, *act;
+	char *str, *p;
+	enum fio_ddir rw;
+
+	free_release_files(td);
+
+	/*
+	 * Read in the read iolog and store it, reuse the infrastructure
+	 * for doing verifications.
+	 */
+	str = malloc(4096);
+	fname = malloc(256+16);
+	act = malloc(256+16);
+
+	reads = writes = waits = 0;
+	while ((p = fgets(str, 4096, f)) != NULL) {
+		struct io_piece *ipo;
+		int r;
+
+		r = sscanf(p, "%256s %256s %llu %u", fname, act, &offset,
+									&bytes);
+		if (r == 4) {
+			/*
+			 * Check action first
+			 */
+			if (!strcmp(act, "wait"))
+				rw = DDIR_WAIT;
+			else if (!strcmp(act, "read"))
+				rw = DDIR_READ;
+			else if (!strcmp(act, "write"))
+				rw = DDIR_WRITE;
+			else if (!strcmp(act, "sync"))
+				rw = DDIR_SYNC;
+			else if (!strcmp(act, "datasync"))
+				rw = DDIR_DATASYNC;
+			else if (!strcmp(act, "trim"))
+				rw = DDIR_TRIM;
+			else {
+				log_err("fio: bad iolog file action: %s\n",
+									act);
+				continue;
+			}
+		} else if (r == 2) {
+			rw = DDIR_INVAL;
+			if (!strcmp(act, "add")) {
+				td->o.nr_files++;
+				fileno = add_file(td, fname);
+				file_action = FIO_LOG_ADD_FILE;
+				continue;
+			} else if (!strcmp(act, "open")) {
+				fileno = get_fileno(td, fname);
+				file_action = FIO_LOG_OPEN_FILE;
+			} else if (!strcmp(act, "close")) {
+				fileno = get_fileno(td, fname);
+				file_action = FIO_LOG_CLOSE_FILE;
+			} else {
+				log_err("fio: bad iolog file action: %s\n",
+									act);
+				continue;
+			}
+		} else {
+			log_err("bad iolog2: %s", p);
+			continue;
+		}
+
+		if (rw == DDIR_READ)
+			reads++;
+		else if (rw == DDIR_WRITE) {
+			/*
+			 * Don't add a write for ro mode
+			 */
+			if (read_only)
+				continue;
+			writes++;
+		} else if (rw == DDIR_WAIT) {
+			waits++;
+		} else if (rw == DDIR_INVAL) {
+		} else if (!ddir_sync(rw)) {
+			log_err("bad ddir: %d\n", rw);
+			continue;
+		}
+
+		/*
+		 * Make note of file
+		 */
+		ipo = malloc(sizeof(*ipo));
+		init_ipo(ipo);
+		ipo->ddir = rw;
+		if (rw == DDIR_WAIT) {
+			ipo->delay = offset;
+		} else {
+			ipo->offset = offset;
+			ipo->len = bytes;
+			if (bytes > td->o.max_bs[rw])
+				td->o.max_bs[rw] = bytes;
+			ipo->fileno = fileno;
+			ipo->file_action = file_action;
+		}
+			
+		queue_io_piece(td, ipo);
+	}
+
+	free(str);
+	free(act);
+	free(fname);
+
+	if (writes && read_only) {
+		log_err("fio: <%s> skips replay of %d writes due to"
+			" read-only\n", td->o.name, writes);
+		writes = 0;
+	}
+
+	if (!reads && !writes && !waits)
+		return 1;
+	else if (reads && !writes)
+		td->o.td_ddir = TD_DDIR_READ;
+	else if (!reads && writes)
+		td->o.td_ddir = TD_DDIR_WRITE;
+	else
+		td->o.td_ddir = TD_DDIR_RW;
+
+	return 0;
+}
+
+/*
+ * open iolog, check version, and call appropriate parser
+ */
+static int init_iolog_read(struct thread_data *td)
+{
+	char buffer[256], *p;
+	FILE *f;
+	int ret;
+
+	f = fopen(td->o.read_iolog_file, "r");
+	if (!f) {
+		perror("fopen read iolog");
+		return 1;
+	}
+
+	p = fgets(buffer, sizeof(buffer), f);
+	if (!p) {
+		td_verror(td, errno, "iolog read");
+		log_err("fio: unable to read iolog\n");
+		fclose(f);
+		return 1;
+	}
+
+	/*
+	 * version 2 of the iolog stores a specific string as the
+	 * first line, check for that
+	 */
+	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2)))
+		ret = read_iolog2(td, f);
+	else {
+		log_err("fio: iolog version 1 is no longer supported\n");
+		ret = 1;
+	}
+
+	fclose(f);
+	return ret;
+}
+
+/*
+ * Set up a log for storing io patterns.
+ */
+static int init_iolog_write(struct thread_data *td)
+{
+	struct fio_file *ff;
+	FILE *f;
+	unsigned int i;
+
+	f = fopen(td->o.write_iolog_file, "a");
+	if (!f) {
+		perror("fopen write iolog");
+		return 1;
+	}
+
+	/*
+	 * That's it for writing, setup a log buffer and we're done.
+	  */
+	td->iolog_f = f;
+	td->iolog_buf = malloc(8192);
+	setvbuf(f, td->iolog_buf, _IOFBF, 8192);
+
+	/*
+	 * write our version line
+	 */
+	if (fprintf(f, "%s\n", iolog_ver2) < 0) {
+		perror("iolog init\n");
+		return 1;
+	}
+
+	/*
+	 * add all known files
+	 */
+	for_each_file(td, ff, i)
+		log_file(td, ff, FIO_LOG_ADD_FILE);
+
+	return 0;
+}
+
+int init_iolog(struct thread_data *td)
+{
+	int ret = 0;
+
+	if (td->o.read_iolog_file) {
+		/*
+		 * Check if it's a blktrace file and load that if possible.
+		 * Otherwise assume it's a normal log file and load that.
+		 */
+		if (is_blktrace(td->o.read_iolog_file))
+			ret = load_blktrace(td, td->o.read_iolog_file);
+		else
+			ret = init_iolog_read(td);
+	} else if (td->o.write_iolog_file)
+		ret = init_iolog_write(td);
+
+	return ret;
+}
+
+void setup_log(struct io_log **log)
+{
+	struct io_log *l = malloc(sizeof(*l));
+
+	l->nr_samples = 0;
+	l->max_samples = 1024;
+	l->log = malloc(l->max_samples * sizeof(struct io_sample));
+	*log = l;
+}
+
+void __finish_log(struct io_log *log, const char *name)
+{
+	unsigned int i;
+	FILE *f;
+
+	f = fopen(name, "a");
+	if (!f) {
+		perror("fopen log");
+		return;
+	}
+
+	for (i = 0; i < log->nr_samples; i++) {
+		fprintf(f, "%lu, %lu, %u, %u\n", log->log[i].time,
+						log->log[i].val,
+						log->log[i].ddir,
+						log->log[i].bs);
+	}
+
+	fclose(f);
+	free(log->log);
+	free(log);
+}
+
+void finish_log_named(struct thread_data *td, struct io_log *log,
+		       const char *prefix, const char *postfix)
+{
+	char file_name[256], *p;
+
+	snprintf(file_name, 200, "%s_%s.log", prefix, postfix);
+	p = basename(file_name);
+	__finish_log(log, p);
+}
+
+void finish_log(struct thread_data *td, struct io_log *log, const char *name)
+{
+	finish_log_named(td, log, td->o.name, name);
+}
diff --git a/iolog.h b/iolog.h
index c35ce1e..53bb66c 100644
--- a/iolog.h
+++ b/iolog.h
@@ -1,16 +1,18 @@
 #ifndef FIO_IOLOG_H
 #define FIO_IOLOG_H
 
+#include "lib/ieee754.h"
+
 /*
  * Use for maintaining statistics
  */
 struct io_stat {
-	unsigned long max_val;
-	unsigned long min_val;
-	unsigned long samples;
+	uint64_t max_val;
+	uint64_t min_val;
+	uint64_t samples;
 
-	double mean;
-	double S;
+	fio_fp64_t mean;
+	fio_fp64_t S;
 };
 
 /*
@@ -91,7 +93,7 @@ extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, enum fio_ddir, unsigned int,
 				struct timeval *);
-extern void show_run_stats(void);
+extern void add_iops_sample(struct thread_data *, enum fio_ddir, struct timeval *);
 extern void init_disk_util(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void update_io_ticks(void);
diff --git a/lib/ieee754.c b/lib/ieee754.c
new file mode 100644
index 0000000..c7742a2
--- /dev/null
+++ b/lib/ieee754.c
@@ -0,0 +1,84 @@
+/*
+ * Shamelessly lifted from Beej's Guide to Network Programming, found here:
+ *
+ * http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html#serialization
+ *
+ * Below code was granted to the public domain.
+ */
+#include <inttypes.h>
+#include "ieee754.h"
+
+uint64_t pack754(long double f, unsigned bits, unsigned expbits)
+{
+	long double fnorm;
+	int shift;
+	long long sign, exp, significand;
+	unsigned significandbits = bits - expbits - 1; // -1 for sign bit
+
+	// get this special case out of the way
+	if (f == 0.0)
+		return 0;
+
+	// check sign and begin normalization
+	if (f < 0) {
+		sign = 1;
+		fnorm = -f;
+	} else {
+		sign = 0;
+		fnorm = f;
+	}
+
+	// get the normalized form of f and track the exponent
+	shift = 0;
+	while (fnorm >= 2.0) {
+		fnorm /= 2.0;
+		shift++;
+	}
+	while (fnorm < 1.0) {
+		fnorm *= 2.0;
+		shift--;
+	}
+	fnorm = fnorm - 1.0;
+
+	// calculate the binary form (non-float) of the significand data
+	significand = fnorm * ((1LL << significandbits) + 0.5f);
+
+	// get the biased exponent
+	exp = shift + ((1 << (expbits - 1)) - 1); // shift + bias
+
+	// return the final answer
+	return (sign << (bits - 1)) | (exp << (bits-expbits - 1)) | significand;
+}
+
+long double unpack754(uint64_t i, unsigned bits, unsigned expbits)
+{
+	long double result;
+	long long shift;
+	unsigned bias;
+	unsigned significandbits = bits - expbits - 1; // -1 for sign bit
+
+	if (i == 0)
+		return 0.0;
+
+	// pull the significand
+	result = (i & ((1LL << significandbits) - 1)); // mask
+	result /= (1LL << significandbits); // convert back to float
+	result += 1.0f; // add the one back on
+
+	// deal with the exponent
+	bias = (1 << (expbits - 1)) - 1;
+	shift = ((i >> significandbits) & ((1LL << expbits) - 1)) - bias;
+	while (shift > 0) {
+		result *= 2.0;
+		shift--;
+	}
+	while (shift < 0) {
+		result /= 2.0;
+		shift++;
+	}
+
+	// sign it
+	result *= (i >> (bits - 1)) & 1 ? -1.0 : 1.0;
+
+	return result;
+}
diff --git a/lib/ieee754.h b/lib/ieee754.h
new file mode 100644
index 0000000..5af9518
--- /dev/null
+++ b/lib/ieee754.h
@@ -0,0 +1,20 @@
+#ifndef FIO_IEEE754_H
+#define FIO_IEEE754_H
+
+#include <inttypes.h>
+
+extern uint64_t pack754(long double f, unsigned bits, unsigned expbits);
+extern long double unpack754(uint64_t i, unsigned bits, unsigned expbits);
+
+#define fio_double_to_uint64(val)	pack754((val), 64, 11)
+#define fio_uint64_to_double(val)	unpack754((val), 64, 11)
+
+typedef struct fio_fp64 {
+	union {
+		uint64_t i;
+		double f;
+		uint8_t filler[16];
+	} u;
+} fio_fp64_t;
+
+#endif
diff --git a/log.c b/log.c
index f962864..af974f8 100644
--- a/log.c
+++ b/log.c
@@ -1,541 +1,95 @@
-/*
- * Code related to writing an iolog of what a thread is doing, and to
- * later read that back and replay
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <libgen.h>
-#include <assert.h>
-#include "flist.h"
-#include "fio.h"
-#include "verify.h"
-#include "trim.h"
-
-static const char iolog_ver2[] = "fio version 2 iolog";
-
-void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
-{
-	flist_add_tail(&ipo->list, &td->io_log_list);
-	td->total_io_size += ipo->len;
-}
-
-void log_io_u(struct thread_data *td, struct io_u *io_u)
-{
-	const char *act[] = { "read", "write", "sync", "datasync",
-				"sync_file_range", "wait", "trim" };
-
-	assert(io_u->ddir <= 6);
-
-	if (!td->o.write_iolog_file)
-		return;
-
-	fprintf(td->iolog_f, "%s %s %llu %lu\n", io_u->file->file_name,
-						act[io_u->ddir], io_u->offset,
-						io_u->buflen);
-}
-
-void log_file(struct thread_data *td, struct fio_file *f,
-	      enum file_log_act what)
-{
-	const char *act[] = { "add", "open", "close" };
-
-	assert(what < 3);
+#include <unistd.h>
+#include <fcntl.h>
+#include <string.h>
+#include <stdarg.h>
+#include <syslog.h>
 
-	if (!td->o.write_iolog_file)
-		return;
-
-
-	/*
-	 * this happens on the pre-open/close done before the job starts
-	 */
-	if (!td->iolog_f)
-		return;
-
-	fprintf(td->iolog_f, "%s %s\n", f->file_name, act[what]);
-}
-
-static void iolog_delay(struct thread_data *td, unsigned long delay)
-{
-	unsigned long usec = utime_since_now(&td->last_issue);
-
-	if (delay < usec)
-		return;
-
-	delay -= usec;
-
-	/*
-	 * less than 100 usec delay, just regard it as noise
-	 */
-	if (delay < 100)
-		return;
-
-	usec_sleep(td, delay);
-}
-
-static int ipo_special(struct thread_data *td, struct io_piece *ipo)
-{
-	struct fio_file *f;
-	int ret;
-
-	/*
-	 * Not a special ipo
-	 */
-	if (ipo->ddir != DDIR_INVAL)
-		return 0;
-
-	f = td->files[ipo->fileno];
-
-	switch (ipo->file_action) {
-	case FIO_LOG_OPEN_FILE:
-		ret = td_io_open_file(td, f);
-		if (!ret)
-			break;
-		td_verror(td, ret, "iolog open file");
-		return -1;
-	case FIO_LOG_CLOSE_FILE:
-		td_io_close_file(td, f);
-		break;
-	case FIO_LOG_UNLINK_FILE:
-		unlink(f->file_name);
-		break;
-	default:
-		log_err("fio: bad file action %d\n", ipo->file_action);
-		break;
-	}
-
-	return 1;
-}
-
-int read_iolog_get(struct thread_data *td, struct io_u *io_u)
-{
-	struct io_piece *ipo;
-	unsigned long elapsed;
-	
-	while (!flist_empty(&td->io_log_list)) {
-		int ret;
-
-		ipo = flist_entry(td->io_log_list.next, struct io_piece, list);
-		flist_del(&ipo->list);
-		remove_trim_entry(td, ipo);
-
-		ret = ipo_special(td, ipo);
-		if (ret < 0) {
-			free(ipo);
-			break;
-		} else if (ret > 0) {
-			free(ipo);
-			continue;
-		}
-
-		io_u->ddir = ipo->ddir;
-		if (ipo->ddir != DDIR_WAIT) {
-			io_u->offset = ipo->offset;
-			io_u->buflen = ipo->len;
-			io_u->file = td->files[ipo->fileno];
-			get_file(io_u->file);
-			dprint(FD_IO, "iolog: get %llu/%lu/%s\n", io_u->offset,
-						io_u->buflen, io_u->file->file_name);
-			if (ipo->delay)
-				iolog_delay(td, ipo->delay);
-		} else {
-			elapsed = mtime_since_genesis();
-			if (ipo->delay > elapsed)
-				usec_sleep(td, (ipo->delay - elapsed) * 1000);
-				
-		}
-
-		free(ipo);
-		
-		if (io_u->ddir != DDIR_WAIT)
-			return 0;
-	}
-
-	td->done = 1;
-	return 1;
-}
-
-void prune_io_piece_log(struct thread_data *td)
-{
-	struct io_piece *ipo;
-	struct rb_node *n;
-
-	while ((n = rb_first(&td->io_hist_tree)) != NULL) {
-		ipo = rb_entry(n, struct io_piece, rb_node);
-		rb_erase(n, &td->io_hist_tree);
-		remove_trim_entry(td, ipo);
-		td->io_hist_len--;
-		free(ipo);
-	}
-
-	while (!flist_empty(&td->io_hist_list)) {
-		ipo = flist_entry(td->io_hist_list.next, struct io_piece, list);
-		flist_del(&ipo->list);
-		remove_trim_entry(td, ipo);
-		td->io_hist_len--;
-		free(ipo);
-	}
-}
-
-/*
- * log a successful write, so we can unwind the log for verify
- */
-void log_io_piece(struct thread_data *td, struct io_u *io_u)
-{
-	struct rb_node **p, *parent;
-	struct io_piece *ipo, *__ipo;
-
-	ipo = malloc(sizeof(struct io_piece));
-	init_ipo(ipo);
-	ipo->file = io_u->file;
-	ipo->offset = io_u->offset;
-	ipo->len = io_u->buflen;
-
-	if (io_u_should_trim(td, io_u)) {
-		flist_add_tail(&ipo->trim_list, &td->trim_list);
-		td->trim_entries++;
-	}
-
-	/*
-	 * We don't need to sort the entries, if:
-	 *
-	 *	Sequential writes, or
-	 *	Random writes that lay out the file as it goes along
-	 *
-	 * For both these cases, just reading back data in the order we
-	 * wrote it out is the fastest.
-	 *
-	 * One exception is if we don't have a random map AND we are doing
-	 * verifies, in that case we need to check for duplicate blocks and
-	 * drop the old one, which we rely on the rb insert/lookup for
-	 * handling.
-	 */
-	if ((!td_random(td) || !td->o.overwrite) &&
-	      (file_randommap(td, ipo->file) || td->o.verify == VERIFY_NONE)) {
-		INIT_FLIST_HEAD(&ipo->list);
-		flist_add_tail(&ipo->list, &td->io_hist_list);
-		ipo->flags |= IP_F_ONLIST;
-		td->io_hist_len++;
-		return;
-	}
-
-	RB_CLEAR_NODE(&ipo->rb_node);
-
-	/*
-	 * Sort the entry into the verification list
-	 */
-restart:
-	p = &td->io_hist_tree.rb_node;
-	parent = NULL;
-	while (*p) {
-		parent = *p;
-
-		__ipo = rb_entry(parent, struct io_piece, rb_node);
-		if (ipo->file < __ipo->file)
-			p = &(*p)->rb_left;
-		else if (ipo->file > __ipo->file)
-			p = &(*p)->rb_right;
-		else if (ipo->offset < __ipo->offset)
-			p = &(*p)->rb_left;
-		else if (ipo->offset > __ipo->offset)
-			p = &(*p)->rb_right;
-		else {
-			assert(ipo->len == __ipo->len);
-			td->io_hist_len--;
-			rb_erase(parent, &td->io_hist_tree);
-			remove_trim_entry(td, __ipo);
-			free(__ipo);
-			goto restart;
-		}
-	}
-
-	rb_link_node(&ipo->rb_node, parent, p);
-	rb_insert_color(&ipo->rb_node, &td->io_hist_tree);
-	ipo->flags |= IP_F_ONRB;
-	td->io_hist_len++;
-}
-
-void write_iolog_close(struct thread_data *td)
-{
-	fflush(td->iolog_f);
-	fclose(td->iolog_f);
-	free(td->iolog_buf);
-	td->iolog_f = NULL;
-	td->iolog_buf = NULL;
-}
+#include "fio.h"
 
-/*
- * Read version 2 iolog data. It is enhanced to include per-file logging,
- * syncs, etc.
- */
-static int read_iolog2(struct thread_data *td, FILE *f)
+int log_valist(const char *str, va_list args)
 {
-	unsigned long long offset;
-	unsigned int bytes;
-	int reads, writes, waits, fileno = 0, file_action = 0; /* stupid gcc */
-	char *fname, *act;
-	char *str, *p;
-	enum fio_ddir rw;
-
-	free_release_files(td);
-
-	/*
-	 * Read in the read iolog and store it, reuse the infrastructure
-	 * for doing verifications.
-	 */
-	str = malloc(4096);
-	fname = malloc(256+16);
-	act = malloc(256+16);
-
-	reads = writes = waits = 0;
-	while ((p = fgets(str, 4096, f)) != NULL) {
-		struct io_piece *ipo;
-		int r;
-
-		r = sscanf(p, "%256s %256s %llu %u", fname, act, &offset,
-									&bytes);
-		if (r == 4) {
-			/*
-			 * Check action first
-			 */
-			if (!strcmp(act, "wait"))
-				rw = DDIR_WAIT;
-			else if (!strcmp(act, "read"))
-				rw = DDIR_READ;
-			else if (!strcmp(act, "write"))
-				rw = DDIR_WRITE;
-			else if (!strcmp(act, "sync"))
-				rw = DDIR_SYNC;
-			else if (!strcmp(act, "datasync"))
-				rw = DDIR_DATASYNC;
-			else if (!strcmp(act, "trim"))
-				rw = DDIR_TRIM;
-			else {
-				log_err("fio: bad iolog file action: %s\n",
-									act);
-				continue;
-			}
-		} else if (r == 2) {
-			rw = DDIR_INVAL;
-			if (!strcmp(act, "add")) {
-				td->o.nr_files++;
-				fileno = add_file(td, fname);
-				file_action = FIO_LOG_ADD_FILE;
-				continue;
-			} else if (!strcmp(act, "open")) {
-				fileno = get_fileno(td, fname);
-				file_action = FIO_LOG_OPEN_FILE;
-			} else if (!strcmp(act, "close")) {
-				fileno = get_fileno(td, fname);
-				file_action = FIO_LOG_CLOSE_FILE;
-			} else {
-				log_err("fio: bad iolog file action: %s\n",
-									act);
-				continue;
-			}
-		} else {
-			log_err("bad iolog2: %s", p);
-			continue;
-		}
-
-		if (rw == DDIR_READ)
-			reads++;
-		else if (rw == DDIR_WRITE) {
-			/*
-			 * Don't add a write for ro mode
-			 */
-			if (read_only)
-				continue;
-			writes++;
-		} else if (rw == DDIR_WAIT) {
-			waits++;
-		} else if (rw == DDIR_INVAL) {
-		} else if (!ddir_sync(rw)) {
-			log_err("bad ddir: %d\n", rw);
-			continue;
-		}
-
-		/*
-		 * Make note of file
-		 */
-		ipo = malloc(sizeof(*ipo));
-		init_ipo(ipo);
-		ipo->ddir = rw;
-		if (rw == DDIR_WAIT) {
-			ipo->delay = offset;
-		} else {
-			ipo->offset = offset;
-			ipo->len = bytes;
-			if (bytes > td->o.max_bs[rw])
-				td->o.max_bs[rw] = bytes;
-			ipo->fileno = fileno;
-			ipo->file_action = file_action;
-		}
-			
-		queue_io_piece(td, ipo);
-	}
+	char buffer[1024];
+	size_t len;
 
-	free(str);
-	free(act);
-	free(fname);
+	len = vsnprintf(buffer, sizeof(buffer), str, args);
 
-	if (writes && read_only) {
-		log_err("fio: <%s> skips replay of %d writes due to"
-			" read-only\n", td->o.name, writes);
-		writes = 0;
-	}
-
-	if (!reads && !writes && !waits)
-		return 1;
-	else if (reads && !writes)
-		td->o.td_ddir = TD_DDIR_READ;
-	else if (!reads && writes)
-		td->o.td_ddir = TD_DDIR_WRITE;
+	if (log_syslog)
+		syslog(LOG_INFO, "%s", buffer);
 	else
-		td->o.td_ddir = TD_DDIR_RW;
+		len = fwrite(buffer, len, 1, f_out);
 
-	return 0;
+	return len;
 }
 
-/*
- * open iolog, check version, and call appropriate parser
- */
-static int init_iolog_read(struct thread_data *td)
+int log_local_buf(const char *buf, size_t len)
 {
-	char buffer[256], *p;
-	FILE *f;
-	int ret;
-
-	f = fopen(td->o.read_iolog_file, "r");
-	if (!f) {
-		perror("fopen read iolog");
-		return 1;
-	}
-
-	p = fgets(buffer, sizeof(buffer), f);
-	if (!p) {
-		td_verror(td, errno, "iolog read");
-		log_err("fio: unable to read iolog\n");
-		fclose(f);
-		return 1;
-	}
-
-	/*
-	 * version 2 of the iolog stores a specific string as the
-	 * first line, check for that
-	 */
-	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2)))
-		ret = read_iolog2(td, f);
-	else {
-		log_err("fio: iolog version 1 is no longer supported\n");
-		ret = 1;
-	}
+	if (log_syslog)
+		syslog(LOG_INFO, "%s", buf);
+	else
+		len = fwrite(buf, len, 1, f_out);
 
-	fclose(f);
-	return ret;
+	return len;
 }
 
-/*
- * Set up a log for storing io patterns.
- */
-static int init_iolog_write(struct thread_data *td)
+int log_local(const char *format, ...)
 {
-	struct fio_file *ff;
-	FILE *f;
-	unsigned int i;
-
-	f = fopen(td->o.write_iolog_file, "a");
-	if (!f) {
-		perror("fopen write iolog");
-		return 1;
-	}
-
-	/*
-	 * That's it for writing, setup a log buffer and we're done.
-	  */
-	td->iolog_f = f;
-	td->iolog_buf = malloc(8192);
-	setvbuf(f, td->iolog_buf, _IOFBF, 8192);
+	char buffer[1024];
+	va_list args;
+	size_t len;
 
-	/*
-	 * write our version line
-	 */
-	if (fprintf(f, "%s\n", iolog_ver2) < 0) {
-		perror("iolog init\n");
-		return 1;
-	}
+	va_start(args, format);
+	len = vsnprintf(buffer, sizeof(buffer), format, args);
+	va_end(args);
 
-	/*
-	 * add all known files
-	 */
-	for_each_file(td, ff, i)
-		log_file(td, ff, FIO_LOG_ADD_FILE);
+	if (log_syslog)
+		syslog(LOG_INFO, "%s", buffer);
+	else
+		len = fwrite(buffer, len, 1, f_out);
 
-	return 0;
+	return len;
 }
 
-int init_iolog(struct thread_data *td)
+int log_info(const char *format, ...)
 {
-	int ret = 0;
+	char buffer[1024];
+	va_list args;
+	size_t len;
 
-	if (td->o.read_iolog_file) {
-		/*
-		 * Check if it's a blktrace file and load that if possible.
-		 * Otherwise assume it's a normal log file and load that.
-		 */
-		if (is_blktrace(td->o.read_iolog_file))
-			ret = load_blktrace(td, td->o.read_iolog_file);
-		else
-			ret = init_iolog_read(td);
-	} else if (td->o.write_iolog_file)
-		ret = init_iolog_write(td);
+	va_start(args, format);
+	len = vsnprintf(buffer, sizeof(buffer), format, args);
+	va_end(args);
 
-	return ret;
+	if (is_backend)
+		return fio_server_text_output(buffer, len);
+	else if (log_syslog) {
+		syslog(LOG_INFO, "%s", buffer);
+		return len;
+	} else
+		return fwrite(buffer, len, 1, f_out);
 }
 
-void setup_log(struct io_log **log)
+int log_err(const char *format, ...)
 {
-	struct io_log *l = malloc(sizeof(*l));
+	char buffer[1024];
+	va_list args;
+	size_t len;
 
-	l->nr_samples = 0;
-	l->max_samples = 1024;
-	l->log = malloc(l->max_samples * sizeof(struct io_sample));
-	*log = l;
-}
+	va_start(args, format);
+	len = vsnprintf(buffer, sizeof(buffer), format, args);
+	va_end(args);
 
-void __finish_log(struct io_log *log, const char *name)
-{
-	unsigned int i;
-	FILE *f;
+	if (is_backend)
+		return fio_server_text_output(buffer, len);
+	else if (log_syslog) {
+		syslog(LOG_INFO, "%s", buffer);
+		return len;
+	} else {
+		if (f_err != stderr) {
+			int fio_unused ret;
 
-	f = fopen(name, "a");
-	if (!f) {
-		perror("fopen log");
-		return;
-	}
+			ret = fwrite(buffer, len, 1, stderr);
+		}
 
-	for (i = 0; i < log->nr_samples; i++) {
-		fprintf(f, "%lu, %lu, %u, %u\n", log->log[i].time,
-						log->log[i].val,
-						log->log[i].ddir,
-						log->log[i].bs);
+		return fwrite(buffer, len, 1, f_err);
 	}
-
-	fclose(f);
-	free(log->log);
-	free(log);
-}
-
-void finish_log_named(struct thread_data *td, struct io_log *log,
-		       const char *prefix, const char *postfix)
-{
-	char file_name[256], *p;
-
-	snprintf(file_name, 200, "%s_%s.log", prefix, postfix);
-	p = basename(file_name);
-	__finish_log(log, p);
-}
-
-void finish_log(struct thread_data *td, struct io_log *log, const char *name)
-{
-	finish_log_named(td, log, td->o.name, name);
 }
diff --git a/log.h b/log.h
index eea1129..fdf3d7b 100644
--- a/log.h
+++ b/log.h
@@ -2,23 +2,15 @@
 #define FIO_LOG_H
 
 #include <stdio.h>
+#include <stdarg.h>
 
 extern FILE *f_out;
 extern FILE *f_err;
 
-/*
- * If logging output to a file, stderr should go to both stderr and f_err
- */
-#define log_err(args, ...)	do {				\
-	fprintf(f_err, args,  ##__VA_ARGS__);		\
-	if (f_err != stderr)						\
-		fprintf(stderr, args,  ##__VA_ARGS__);	\
-	} while (0)
-
-#define log_info(args, ...)	fprintf(f_out, args, ##__VA_ARGS__)
-#define log_valist(str, args)	vfprintf(f_out, (str), (args))
-
-FILE *get_f_out(void);
-FILE *get_f_err(void);
+extern int log_err(const char *format, ...);
+extern int log_info(const char *format, ...);
+extern int log_local(const char *format, ...);
+extern int log_valist(const char *str, va_list);
+extern int log_local_buf(const char *buf, size_t);
 
 #endif
diff --git a/options.c b/options.c
index 5252477..48bb2a4 100644
--- a/options.c
+++ b/options.c
@@ -595,6 +595,14 @@ static char *get_next_file_name(char **ptr)
 	return start;
 }
 
+static int str_hostname_cb(void *data, const char *input)
+{
+	struct thread_data *td = data;
+
+	td->o.filename = strdup(input);
+	return 0;
+}
+
 static int str_filename_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
@@ -749,6 +757,17 @@ static int str_write_lat_log_cb(void *data, const char *str)
 	return 0;
 }
 
+static int str_write_iops_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = data;
+
+	if (str)
+		td->o.iops_log_file = strdup(str);
+
+	td->o.write_iops_log = 1;
+	return 0;
+}
+
 static int str_gtod_reduce_cb(void *data, int *il)
 {
 	struct thread_data *td = data;
@@ -758,6 +777,7 @@ static int str_gtod_reduce_cb(void *data, int *il)
 	td->o.disable_clat = !!val;
 	td->o.disable_slat = !!val;
 	td->o.disable_bw = !!val;
+	td->o.clat_percentiles = !val;
 	if (val)
 		td->tv_cache_mask = 63;
 
@@ -829,9 +849,6 @@ static int kb_base_verify(struct fio_option *o, void *data)
 	return 0;
 }
 
-#define __stringify_1(x)	#x
-#define __stringify(x)		__stringify_1(x)
-
 /*
  * Map of job/command line options
  */
@@ -864,6 +881,12 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "File(s) to use for the workload",
 	},
 	{
+		.name	= "hostname",
+		.type	= FIO_OPT_STR_STORE,
+		.cb	= str_hostname_cb,
+		.help	= "Hostname for net IO engine",
+	},
+	{
 		.name	= "kb_base",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(kb_base),
@@ -1824,6 +1847,15 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "Time window over which to calculate bandwidth"
 			  " (msec)",
 		.def	= "500",
+		.parent	= "write_bw_log",
+	},
+	{
+		.name	= "iopsavgtime",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(iops_avg_time),
+		.help	= "Time window over which to calculate IOPS (msec)",
+		.def	= "500",
+		.parent	= "write_iops_log",
 	},
 	{
 		.name	= "create_serialize",
@@ -1942,11 +1974,18 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "Write log of latency during run",
 	},
 	{
+		.name	= "write_iops_log",
+		.type	= FIO_OPT_STR,
+		.off1	= td_var_offset(write_iops_log),
+		.cb	= str_write_iops_log_cb,
+		.help	= "Write log of IOPS during run",
+	},
+	{
 		.name	= "hugepage-size",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(hugepage_size),
 		.help	= "When using hugepages, specify size of each page",
-		.def	= __stringify(FIO_HUGE_PAGE),
+		.def	= __fio_stringify(FIO_HUGE_PAGE),
 	},
 	{
 		.name	= "group_reporting",
@@ -1978,7 +2017,7 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(clat_percentiles),
 		.help	= "Enable the reporting of completion latency percentiles",
-		.def	= "0",
+		.def	= "1",
 	},
 	{
 		.name	= "percentile_list",
diff --git a/os/os-aix.h b/os/os-aix.h
index 91c8bcd..2f75bf8 100644
--- a/os/os-aix.h
+++ b/os/os-aix.h
@@ -1,6 +1,8 @@
 #ifndef FIO_OS_AIX_H
 #define FIO_OS_AIX_H
 
+#define	FIO_OS	os_aix
+
 #include <errno.h>
 #include <unistd.h>
 #include <sys/devinfo.h>
@@ -25,6 +27,17 @@
 #define OS_MAP_ANON		MAP_ANON
 #define OS_MSG_DONTWAIT		0
 
+#if BYTE_ORDER == BIG_ENDIAN
+#define FIO_BIG_ENDIAN
+#else
+#define FIO_LITTLE_ENDIAN
+#endif
+
+#define FIO_USE_GENERIC_SWAP
+
+#define FIO_OS_HAVE_SOCKLEN_T
+#define fio_socklen_t socklen_t
+
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
 	return EINVAL;
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 317d403..93205c3 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -1,10 +1,14 @@
 #ifndef FIO_OS_FREEBSD_H
 #define FIO_OS_FREEBSD_H
 
+#define	FIO_OS	os_freebsd
+
 #include <errno.h>
 #include <sys/sysctl.h>
 #include <sys/disk.h>
 #include <sys/thr.h>
+#include <sys/endian.h>
+#include <sys/socket.h>
 
 #include "../file.h"
 
@@ -18,6 +22,16 @@
 
 #define OS_MAP_ANON		MAP_ANON
 
+#if BYTE_ORDER == LITTLE_ENDIAN
+#define FIO_LITTLE_ENDIAN
+#else
+#define FIO_BIG_ENDIAN
+#endif
+
+#define fio_swap16(x)	bswap16(x)
+#define fio_swap32(x)	bswap32(x)
+#define fio_swap64(x)	bswap64(x)
+
 typedef off_t off64_t;
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
diff --git a/os/os-hpux.h b/os/os-hpux.h
index 4353a01..5943938 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -1,6 +1,8 @@
 #ifndef FIO_OS_HPUX_H
 #define FIO_OS_HPUX_H
 
+#define	FIO_OS	os_hpux
+
 #include <errno.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
@@ -13,6 +15,7 @@
 #include <sys/pstat.h>
 #include <time.h>
 #include <aio.h>
+#include <arm.h>
 
 #include "../file.h"
 
@@ -43,9 +46,20 @@
 #define MSG_WAITALL	0x40
 #endif
 
+#ifdef LITTLE_ENDIAN
+#define FIO_LITTLE_ENDIAN
+#else
+#define FIO_BIG_ENDIAN
+#endif
+
+#define FIO_USE_GENERIC_SWAP
+
 #define FIO_OS_HAVE_AIOCB_TYPEDEF
 typedef struct aiocb64 os_aiocb_t;
 
+#define FIO_OS_HAVE_SOCKLEN_T
+typedef int fio_socklen_t;
+
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
 	return EINVAL;
diff --git a/os/os-linux.h b/os/os-linux.h
index a36552b..9f547ff 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -1,6 +1,8 @@
 #ifndef FIO_OS_LINUX_H
 #define FIO_OS_LINUX_H
 
+#define	FIO_OS	os_linux
+
 #include <sys/ioctl.h>
 #include <sys/uio.h>
 #include <sys/syscall.h>
@@ -12,6 +14,7 @@
 #include <linux/unistd.h>
 #include <linux/raw.h>
 #include <linux/major.h>
+#include <endian.h>
 
 #include "indirect.h"
 #include "binject.h"
@@ -89,8 +92,8 @@ typedef struct drand48_data os_random_state_t;
 	sched_getaffinity((pid), (ptr))
 #endif
 
-#define fio_cpu_clear(mask, cpu)	CPU_CLR((cpu), (mask))
-#define fio_cpu_set(mask, cpu)		CPU_SET((cpu), (mask))
+#define fio_cpu_clear(mask, cpu)	(void) CPU_CLR((cpu), (mask))
+#define fio_cpu_set(mask, cpu)		(void) CPU_SET((cpu), (mask))
 
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
@@ -286,6 +289,18 @@ static inline int fio_lookup_raw(dev_t dev, int *majdev, int *mindev)
 #define FIO_MADV_FREE	MADV_REMOVE
 #endif
 
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define FIO_LITTLE_ENDIAN
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define FIO_BIG_ENDIAN
+#else
+#error "Unknown endianness"
+#endif
+
+#define fio_swap16(x)	__bswap_16(x)
+#define fio_swap32(x)	__bswap_32(x)
+#define fio_swap64(x)	__bswap_64(x)
+
 #define CACHE_LINE_FILE	\
 	"/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size"
 
diff --git a/os/os-mac.h b/os/os-mac.h
index eb55cd7..80c49f4 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -1,6 +1,8 @@
 #ifndef FIO_OS_APPLE_H
 #define FIO_OS_APPLE_H
 
+#define	FIO_OS	os_mac
+
 #include <errno.h>
 #include <fcntl.h>
 #include <sys/disk.h>
@@ -9,6 +11,8 @@
 #include <unistd.h>
 #include <signal.h>
 #include <mach/mach_init.h>
+#include <machine/endian.h>
+#include <libkern/OSByteOrder.h>
 
 #include "../file.h"
 
@@ -28,6 +32,18 @@
 
 #define OS_MAP_ANON		MAP_ANON
 
+#if defined(__LITTLE_ENDIAN__)
+#define FIO_LITTLE_ENDIAN
+#elif defined(__BIG_ENDIAN__)
+#define FIO_BIG_ENDIAN
+#else
+#error "Undefined byte order"
+#endif
+
+#define fio_swap16(x)	OSSwapInt16(x)
+#define fio_swap32(x)	OSSwapInt32(x)
+#define fio_swap64(x)	OSSwapInt64(x)
+
 /*
  * OSX has a pitifully small shared memory segment by default,
  * so default to a lower number of max jobs supported
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index e03866d..78ac135 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -1,9 +1,12 @@
 #ifndef FIO_OS_NETBSD_H
 #define FIO_OS_NETBSD_H
 
+#define	FIO_OS	os_netbsd
+
 #include <errno.h>
 #include <sys/param.h>
 #include <sys/thr.h>
+#include <sys/endian.h>
 /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
 #define	rb_node	_rb_node
 #include <sys/sysctl.h>
@@ -30,6 +33,16 @@
 #define PTHREAD_STACK_MIN 4096
 #endif
 
+#if BYTE_ORDER == LITTLE_ENDIAN
+#define FIO_LITTLE_ENDIAN
+#else
+#define FIO_BIG_ENDIAN
+#endif
+
+#define fio_swap16(x)	bswap16(x)
+#define fio_swap32(x)	bswap32(x)
+#define fio_swap64(x)	bswap64(x)
+
 typedef off_t off64_t;
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
diff --git a/os/os-solaris.h b/os/os-solaris.h
index c0d3c30..5bf868a 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -1,6 +1,8 @@
 #ifndef FIO_OS_SOLARIS_H
 #define FIO_OS_SOLARIS_H
 
+#define	FIO_OS	os_solaris
+
 #include <errno.h>
 #include <malloc.h>
 #include <sys/types.h>
@@ -8,6 +10,7 @@
 #include <sys/pset.h>
 #include <sys/mman.h>
 #include <sys/dkio.h>
+#include <sys/byteorder.h>
 
 #include "../file.h"
 
@@ -24,6 +27,16 @@
 #define OS_MAP_ANON		MAP_ANON
 #define OS_RAND_MAX		2147483648UL
 
+#if defined(_BIG_ENDIAN)
+#define FIO_BIG_ENDIAN
+#else
+#define FIO_LITTLE_ENDIAN
+#endif
+
+#define fio_swap16(x)	BSWAP_16(x)
+#define fio_swap32(x)	BSWAP_32(x)
+#define fio_swap64(x)	BSWAP_64(x)
+
 struct solaris_rand_seed {
 	unsigned short r[3];
 };
diff --git a/os/os-windows.h b/os/os-windows.h
index db4127b..8812cfa 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -1,10 +1,13 @@
 #ifndef FIO_OS_WINDOWS_H
 #define FIO_OS_WINDOWS_H
 
+#define FIO_OS	os_windows
+
 #include <sys/types.h>
 #include <errno.h>
 #include <windows.h>
 #include <psapi.h>
+#include <stdlib.h>
 
 #include "../smalloc.h"
 #include "../file.h"
@@ -18,6 +21,9 @@
 #define FIO_HAVE_WINDOWSAIO
 #define FIO_HAVE_GETTID
 
+#define FIO_OS_HAVE_SOCKLEN_T
+typedef int fio_socklen_t;
+
 #define FIO_USE_GENERIC_RAND
 
 #define OS_MAP_ANON		MAP_ANON
@@ -26,6 +32,11 @@
 
 #define FIO_PREFERRED_ENGINE	"windowsaio"
 
+#define FIO_LITTLE_ENDIAN
+#define fio_swap16(x)	_byteswap_ushort(x)
+#define fio_swap32(x)	_byteswap_ulong(x)
+#define fio_swap64(x)	_byteswap_uint64(x)
+
 typedef off_t off64_t;
 
 typedef struct {
diff --git a/os/os.h b/os/os.h
index 2eb38e8..1218815 100644
--- a/os/os.h
+++ b/os/os.h
@@ -6,6 +6,19 @@
 #include <unistd.h>
 #include <stdlib.h>
 
+enum {
+	os_linux = 1,
+	os_aix,
+	os_freebsd,
+	os_hpux,
+	os_mac,
+	os_netbsd,
+	os_solaris,
+	os_windows,
+
+	os_nr,
+};
+
 #if defined(__linux__)
 #include "os-linux.h"
 #elif defined(__FreeBSD__)
@@ -115,6 +128,75 @@ typedef unsigned long os_cpu_mask_t;
 #define FIO_MAX_JOBS		2048
 #endif
 
+#ifndef FIO_OS_HAVE_SOCKLEN_T
+typedef socklen_t fio_socklen_t;
+#endif
+
+#ifdef FIO_USE_GENERIC_SWAP
+static inline uint16_t fio_swap16(uint16_t val)
+{
+	return (val << 8) | (val >> 8);
+}
+
+static inline uint32_t fio_swap32(uint32_t val)
+{
+	val = ((val & 0xff00ff00UL) >> 8) | ((val & 0x00ff00ffUL) << 8);
+
+	return (val >> 16) | (val << 16);
+}
+
+static inline uint64_t fio_swap64(uint64_t val)
+{
+	val = ((val & 0xff00ff00ff00ff00ULL) >> 8) |
+	      ((val & 0x00ff00ff00ff00ffULL) << 8);
+	val = ((val & 0xffff0000ffff0000ULL) >> 16) |
+	      ((val & 0x0000ffff0000ffffULL) << 16);
+
+	return (val >> 32) | (val << 32);
+}
+#endif
+
+#ifdef FIO_LITTLE_ENDIAN
+#define __le16_to_cpu(x)		(x)
+#define __le32_to_cpu(x)		(x)
+#define __le64_to_cpu(x)		(x)
+#define __cpu_to_le16(x)		(x)
+#define __cpu_to_le32(x)		(x)
+#define __cpu_to_le64(x)		(x)
+#else
+#define __le16_to_cpu(x)		fio_swap16(x)
+#define __le32_to_cpu(x)		fio_swap32(x)
+#define __le64_to_cpu(x)		fio_swap64(x)
+#define __cpu_to_le16(x)		fio_swap16(x)
+#define __cpu_to_le32(x)		fio_swap32(x)
+#define __cpu_to_le64(x)		fio_swap64(x)
+#endif
+
+#define le16_to_cpu(val) ({			\
+	uint16_t *__val = &(val);		\
+	__le16_to_cpu(*__val);			\
+})
+#define le32_to_cpu(val) ({			\
+	uint32_t *__val = &(val);		\
+	__le32_to_cpu(*__val);			\
+})
+#define le64_to_cpu(val) ({			\
+	uint64_t *__val = &(val);		\
+	__le64_to_cpu(*__val);			\
+})
+#define cpu_to_le16(val) ({			\
+	uint16_t *__val = &(val);		\
+	__cpu_to_le16(*__val);			\
+})
+#define cpu_to_le32(val) ({			\
+	uint32_t *__val = &(val);		\
+	__cpu_to_le32(*__val);			\
+})
+#define cpu_to_le64(val) ({			\
+	uint64_t *__val = &(val);		\
+	__cpu_to_le64(*__val);			\
+})
+
 #ifndef FIO_HAVE_BLKTRACE
 static inline int is_blktrace(const char *fname)
 {
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 028c4cc..69a0e98 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -2,8 +2,8 @@
 <Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
 
 <?define VersionMajor = 1?>
-<?define VersionMinor = 59?>
-<?define VersionBuild = 0?>
+<?define VersionMinor = 99?>
+<?define VersionBuild = 6?>
 
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
diff --git a/os/windows/version.h b/os/windows/version.h
index 6c8a228..b7d3308 100644
--- a/os/windows/version.h
+++ b/os/windows/version.h
@@ -1,4 +1,6 @@
-#define FIO_VERSION_MAJOR 1
-#define FIO_VERSION_MINOR 59
-#define FIO_VERSION_BUILD 0
-#define FIO_VERSION_STRING "1.59"
+#include "../../fio_version.h"
+
+#define FIO_VERSION_MAJOR FIO_MAJOR
+#define FIO_VERSION_MINOR FIO_MINOR
+#define FIO_VERSION_BUILD FIO_PATCH
+#define FIO_VERSION_STRING "1.99.6"
diff --git a/parse.c b/parse.c
index 239e371..27e7336 100644
--- a/parse.c
+++ b/parse.c
@@ -44,24 +44,25 @@ static void posval_sort(struct fio_option *o, struct value_pair *vpmap)
 	qsort(vpmap, entries, sizeof(struct value_pair), vp_cmp);
 }
 
-static void show_option_range(struct fio_option *o, FILE *out)
+static void show_option_range(struct fio_option *o,
+				int (*logger)(const char *format, ...))
 {
 	if (o->type == FIO_OPT_FLOAT_LIST){
 		if (isnan(o->minfp) && isnan(o->maxfp))
 			return;
 
-		fprintf(out, "%20s: min=%f", "range", o->minfp);
+		logger("%20s: min=%f", "range", o->minfp);
 		if (!isnan(o->maxfp))
-			fprintf(out, ", max=%f", o->maxfp);
-		fprintf(out, "\n");
+			logger(", max=%f", o->maxfp);
+		logger("\n");
 	} else {
 		if (!o->minval && !o->maxval)
 			return;
 
-		fprintf(out, "%20s: min=%d", "range", o->minval);
+		logger("%20s: min=%d", "range", o->minval);
 		if (o->maxval)
-			fprintf(out, ", max=%d", o->maxval);
-		fprintf(out, "\n");
+			logger(", max=%d", o->maxval);
+		logger("\n");
 	}
 }
 
@@ -75,17 +76,17 @@ static void show_option_values(struct fio_option *o)
 		if (!vp->ival)
 			continue;
 
-		printf("%20s: %-10s", i == 0 ? "valid values" : "", vp->ival);
+		log_info("%20s: %-10s", i == 0 ? "valid values" : "", vp->ival);
 		if (vp->help)
-			printf(" %s", vp->help);
-		printf("\n");
+			log_info(" %s", vp->help);
+		log_info("\n");
 	}
 
 	if (i)
-		printf("\n");
+		log_info("\n");
 }
 
-static void show_option_help(struct fio_option *o, FILE *out)
+static void show_option_help(struct fio_option *o, int is_err)
 {
 	const char *typehelp[] = {
 		"invalid",
@@ -101,15 +102,21 @@ static void show_option_help(struct fio_option *o, FILE *out)
 		"no argument (opt)",
 		"deprecated",
 	};
+	int (*logger)(const char *format, ...);
+
+	if (is_err)
+		logger = log_err;
+	else
+		logger = log_info;
 
 	if (o->alias)
-		fprintf(out, "%20s: %s\n", "alias", o->alias);
+		logger("%20s: %s\n", "alias", o->alias);
 
-	fprintf(out, "%20s: %s\n", "type", typehelp[o->type]);
-	fprintf(out, "%20s: %s\n", "default", o->def ? o->def : "no default");
+	logger("%20s: %s\n", "type", typehelp[o->type]);
+	logger("%20s: %s\n", "default", o->def ? o->def : "no default");
 	if (o->prof_name)
-		fprintf(out, "%20s: only for profile '%s'\n", "valid", o->prof_name);
-	show_option_range(o, stdout);
+		logger("%20s: only for profile '%s'\n", "valid", o->prof_name);
+	show_option_range(o, logger);
 	show_option_values(o);
 }
 
@@ -357,7 +364,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 							o->type, ptr);
 
 	if (!ptr && o->type != FIO_OPT_STR_SET && o->type != FIO_OPT_STR) {
-		fprintf(stderr, "Option %s requires an argument\n", o->name);
+		log_err("Option %s requires an argument\n", o->name);
 		return 1;
 	}
 
@@ -411,12 +418,12 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			break;
 
 		if (o->maxval && ull > o->maxval) {
-			fprintf(stderr, "max value out of range: %lld"
+			log_err("max value out of range: %lld"
 					" (%d max)\n", ull, o->maxval);
 			return 1;
 		}
 		if (o->minval && ull < o->minval) {
-			fprintf(stderr, "min value out of range: %lld"
+			log_err("min value out of range: %lld"
 					" (%d min)\n", ull, o->minval);
 			return 1;
 		}
@@ -462,22 +469,21 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			*ilp = ul2;
 		}
 		if (curr >= o->maxlen) {
-			fprintf(stderr, "the list exceeding max length %d\n",
+			log_err("the list exceeding max length %d\n",
 					o->maxlen);
 			return 1;
 		}
 		if(!str_to_float(ptr, &uf)){
-			fprintf(stderr, "not a floating point value: %s\n",
-					ptr);
+			log_err("not a floating point value: %s\n", ptr);
 			return 1;
 		}
 		if (!isnan(o->maxfp) && uf > o->maxfp) {
-			fprintf(stderr, "value out of range: %f"
+			log_err("value out of range: %f"
 				" (range max: %f)\n", uf, o->maxfp);
 			return 1;
 		}
 		if (!isnan(o->minfp) && uf < o->minfp) {
-			fprintf(stderr, "value out of range: %f"
+			log_err("value out of range: %f"
 				" (range min: %f)\n", uf, o->minfp);
 			return 1;
 		}
@@ -603,12 +609,12 @@ match:
 			break;
 
 		if (o->maxval && il > (int) o->maxval) {
-			fprintf(stderr, "max value out of range: %d (%d max)\n",
+			log_err("max value out of range: %d (%d max)\n",
 								il, o->maxval);
 			return 1;
 		}
 		if (o->minval && il < o->minval) {
-			fprintf(stderr, "min value out of range: %d (%d min)\n",
+			log_err("min value out of range: %d (%d min)\n",
 								il, o->minval);
 			return 1;
 		}
@@ -635,10 +641,10 @@ match:
 		break;
 	}
 	case FIO_OPT_DEPRECATED:
-		fprintf(stdout, "Option %s is deprecated\n", o->name);
+		log_info("Option %s is deprecated\n", o->name);
 		break;
 	default:
-		fprintf(stderr, "Bad option type %u\n", o->type);
+		log_err("Bad option type %u\n", o->type);
 		ret = 1;
 	}
 
@@ -648,9 +654,9 @@ match:
 	if (o->verify) {
 		ret = o->verify(o, data);
 		if (ret) {
-			fprintf(stderr,"Correct format for offending option\n");
-			fprintf(stderr, "%20s: %s\n", o->name, o->help);
-			show_option_help(o, stderr);
+			log_err("Correct format for offending option\n");
+			log_err("%20s: %s\n", o->name, o->help);
+			show_option_help(o, 1);
 		}
 	}
 
@@ -776,14 +782,14 @@ int parse_cmd_option(const char *opt, const char *val,
 
 	o = find_option(options, opt);
 	if (!o) {
-		fprintf(stderr, "Bad option <%s>\n", opt);
+		log_err("Bad option <%s>\n", opt);
 		return 1;
 	}
 
 	if (!handle_option(o, val, data))
 		return 0;
 
-	fprintf(stderr, "fio: failed parsing %s=%s\n", opt, val);
+	log_err("fio: failed parsing %s=%s\n", opt, val);
 	return 1;
 }
 
@@ -804,7 +810,7 @@ static char *option_dup_subs(const char *opt)
 	size_t envlen;
 
 	if (strlen(opt) + 1 > OPT_LEN_MAX) {
-		fprintf(stderr, "OPT_LEN_MAX (%d) is too small\n", OPT_LEN_MAX);
+		log_err("OPT_LEN_MAX (%d) is too small\n", OPT_LEN_MAX);
 		return NULL;
 	}
 
@@ -852,7 +858,7 @@ int parse_option(const char *opt, struct fio_option *options, void *data)
 
 	o = get_option(tmp, options, &post);
 	if (!o) {
-		fprintf(stderr, "Bad option <%s>\n", tmp);
+		log_err("Bad option <%s>\n", tmp);
 		free(tmp);
 		return 1;
 	}
@@ -862,7 +868,7 @@ int parse_option(const char *opt, struct fio_option *options, void *data)
 		return 0;
 	}
 
-	fprintf(stderr, "fio: failed parsing %s\n", opt);
+	log_err("fio: failed parsing %s\n", opt);
 	free(tmp);
 	return 1;
 }
@@ -936,7 +942,7 @@ static void __print_option(struct fio_option *o, struct fio_option *org,
 
 	sprintf(p, "%s", o->name);
 
-	printf("%-24s: %s\n", name, o->help);
+	log_info("%-24s: %s\n", name, o->help);
 }
 
 static void print_option(struct fio_option *o)
@@ -1001,7 +1007,7 @@ int show_cmd_help(struct fio_option *options, const char *name)
 		if (show_all || match) {
 			found = 1;
 			if (match)
-				printf("%20s: %s\n", o->name, o->help);
+				log_info("%20s: %s\n", o->name, o->help);
 			if (show_all) {
 				if (!o->parent)
 					print_option(o);
@@ -1012,24 +1018,24 @@ int show_cmd_help(struct fio_option *options, const char *name)
 		if (!match)
 			continue;
 
-		show_option_help(o, stdout);
+		show_option_help(o, 0);
 	}
 
 	if (found)
 		return 0;
 
-	printf("No such command: %s", name);
+	log_err("No such command: %s", name);
 
 	/*
 	 * Only print an appropriately close option, one where the edit
 	 * distance isn't too big. Otherwise we get crazy matches.
 	 */
 	if (closest && best_dist < 3) {
-		printf(" - showing closest match\n");
-		printf("%20s: %s\n", closest->name, closest->help);
-		show_option_help(closest, stdout);
+		log_info(" - showing closest match\n");
+		log_info("%20s: %s\n", closest->name, closest->help);
+		show_option_help(closest, 0);
 	} else
-		printf("\n");
+		log_info("\n");
 
 	return 1;
 }
@@ -1061,20 +1067,17 @@ void option_init(struct fio_option *o)
 		o->maxfp = NAN;
 	}
 	if (o->type == FIO_OPT_STR_SET && o->def) {
-		fprintf(stderr, "Option %s: string set option with"
+		log_err("Option %s: string set option with"
 				" default will always be true\n", o->name);
 	}
-	if (!o->cb && (!o->off1 && !o->roff1)) {
-		fprintf(stderr, "Option %s: neither cb nor offset given\n",
-							o->name);
-	}
+	if (!o->cb && (!o->off1 && !o->roff1))
+		log_err("Option %s: neither cb nor offset given\n", o->name);
 	if (o->type == FIO_OPT_STR || o->type == FIO_OPT_STR_STORE ||
 	    o->type == FIO_OPT_STR_MULTI)
 		return;
 	if (o->cb && ((o->off1 || o->off2 || o->off3 || o->off4) ||
 		      (o->roff1 || o->roff2 || o->roff3 || o->roff4))) {
-		fprintf(stderr, "Option %s: both cb and offset given\n",
-							 o->name);
+		log_err("Option %s: both cb and offset given\n", o->name);
 	}
 }
 
diff --git a/server.c b/server.c
new file mode 100644
index 0000000..e7a9057
--- /dev/null
+++ b/server.c
@@ -0,0 +1,1134 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <unistd.h>
+#include <limits.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/poll.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/un.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <syslog.h>
+#include <signal.h>
+
+#include "fio.h"
+#include "server.h"
+#include "crc/crc16.h"
+#include "lib/ieee754.h"
+
+#include "fio_version.h"
+
+int fio_net_port = 8765;
+
+int exit_backend = 0;
+
+static int server_fd = -1;
+static char *fio_server_arg;
+static char *bind_sock;
+static struct sockaddr_in saddr_in;
+
+static const char *fio_server_ops[FIO_NET_CMD_NR] = {
+	"",
+	"QUIT",
+	"EXIT",
+	"JOB",
+	"JOBLINE",
+	"TEXT",
+	"TS",
+	"GS",
+	"SEND_ETA",
+	"ETA",
+	"PROBE",
+	"START",
+	"STOP",
+	"DISK_UTIL",
+};
+
+const char *fio_server_op(unsigned int op)
+{
+	static char buf[32];
+
+	if (op < FIO_NET_CMD_NR)
+		return fio_server_ops[op];
+
+	sprintf(buf, "UNKNOWN/%d", op);
+	return buf;
+}
+
+int fio_send_data(int sk, const void *p, unsigned int len)
+{
+	assert(len <= sizeof(struct fio_net_cmd) + FIO_SERVER_MAX_PDU);
+
+	do {
+		int ret = send(sk, p, len, 0);
+
+		if (ret > 0) {
+			len -= ret;
+			if (!len)
+				break;
+			p += ret;
+			continue;
+		} else if (!ret)
+			break;
+		else if (errno == EAGAIN || errno == EINTR)
+			continue;
+		else
+			break;
+	} while (!exit_backend);
+
+	if (!len)
+		return 0;
+
+	return 1;
+}
+
+int fio_recv_data(int sk, void *p, unsigned int len)
+{
+	do {
+		int ret = recv(sk, p, len, MSG_WAITALL);
+
+		if (ret > 0) {
+			len -= ret;
+			if (!len)
+				break;
+			p += ret;
+			continue;
+		} else if (!ret)
+			break;
+		else if (errno == EAGAIN || errno == EINTR)
+			continue;
+		else
+			break;
+	} while (!exit_backend);
+
+	if (!len)
+		return 0;
+
+	return -1;
+}
+
+static int verify_convert_cmd(struct fio_net_cmd *cmd)
+{
+	uint16_t crc;
+
+	cmd->cmd_crc16 = le16_to_cpu(cmd->cmd_crc16);
+	cmd->pdu_crc16 = le16_to_cpu(cmd->pdu_crc16);
+
+	crc = crc16(cmd, FIO_NET_CMD_CRC_SZ);
+	if (crc != cmd->cmd_crc16) {
+		log_err("fio: server bad crc on command (got %x, wanted %x)\n",
+				cmd->cmd_crc16, crc);
+		return 1;
+	}
+
+	cmd->version	= le16_to_cpu(cmd->version);
+	cmd->opcode	= le16_to_cpu(cmd->opcode);
+	cmd->flags	= le32_to_cpu(cmd->flags);
+	cmd->tag	= le64_to_cpu(cmd->tag);
+	cmd->pdu_len	= le32_to_cpu(cmd->pdu_len);
+
+	switch (cmd->version) {
+	case FIO_SERVER_VER:
+		break;
+	default:
+		log_err("fio: bad server cmd version %d\n", cmd->version);
+		return 1;
+	}
+
+	if (cmd->pdu_len > FIO_SERVER_MAX_PDU) {
+		log_err("fio: command payload too large: %u\n", cmd->pdu_len);
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Read (and defragment, if necessary) incoming commands
+ */
+struct fio_net_cmd *fio_net_recv_cmd(int sk)
+{
+	struct fio_net_cmd cmd, *cmdret = NULL;
+	size_t cmd_size = 0, pdu_offset = 0;
+	uint16_t crc;
+	int ret, first = 1;
+	void *pdu = NULL;
+
+	do {
+		ret = fio_recv_data(sk, &cmd, sizeof(cmd));
+		if (ret)
+			break;
+
+		/* We have a command, verify it and swap if need be */
+		ret = verify_convert_cmd(&cmd);
+		if (ret)
+			break;
+
+		if (first) {
+			/* if this is text, add room for \0 at the end */
+			cmd_size = sizeof(cmd) + cmd.pdu_len + 1;
+			assert(!cmdret);
+		} else
+			cmd_size += cmd.pdu_len;
+
+		cmdret = realloc(cmdret, cmd_size);
+
+		if (first)
+			memcpy(cmdret, &cmd, sizeof(cmd));
+		else
+			assert(cmdret->opcode == cmd.opcode);
+
+		if (!cmd.pdu_len)
+			break;
+
+		/* There's payload, get it */
+		pdu = (void *) cmdret->payload + pdu_offset;
+		ret = fio_recv_data(sk, pdu, cmd.pdu_len);
+		if (ret)
+			break;
+
+		/* Verify payload crc */
+		crc = crc16(pdu, cmd.pdu_len);
+		if (crc != cmd.pdu_crc16) {
+			log_err("fio: server bad crc on payload ");
+			log_err("(got %x, wanted %x)\n", cmd.pdu_crc16, crc);
+			ret = 1;
+			break;
+		}
+
+		pdu_offset += cmd.pdu_len;
+		if (!first)
+			cmdret->pdu_len += cmd.pdu_len;
+		first = 0;
+	} while (cmd.flags & FIO_NET_CMD_F_MORE);
+
+	if (ret) {
+		free(cmdret);
+		cmdret = NULL;
+	} else if (cmdret) {
+		/* zero-terminate text input */
+		if (cmdret->pdu_len && (cmdret->opcode == FIO_NET_CMD_TEXT ||
+		    cmdret->opcode == FIO_NET_CMD_JOB)) {
+			char *buf = (char *) cmdret->payload;
+
+			buf[cmdret->pdu_len ] = '\0';
+		}
+		/* frag flag is internal */
+		cmdret->flags &= ~FIO_NET_CMD_F_MORE;
+	}
+
+	return cmdret;
+}
+
+void fio_net_cmd_crc(struct fio_net_cmd *cmd)
+{
+	uint32_t pdu_len;
+
+	cmd->cmd_crc16 = __cpu_to_le16(crc16(cmd, FIO_NET_CMD_CRC_SZ));
+
+	pdu_len = le32_to_cpu(cmd->pdu_len);
+	if (pdu_len)
+		cmd->pdu_crc16 = __cpu_to_le16(crc16(cmd->payload, pdu_len));
+}
+
+int fio_net_send_cmd(int fd, uint16_t opcode, const void *buf, off_t size,
+		     uint64_t tag)
+{
+	struct fio_net_cmd *cmd = NULL;
+	size_t this_len, cur_len = 0;
+	int ret;
+
+	do {
+		this_len = size;
+		if (this_len > FIO_SERVER_MAX_PDU)
+			this_len = FIO_SERVER_MAX_PDU;
+
+		if (!cmd || cur_len < sizeof(*cmd) + this_len) {
+			if (cmd)
+				free(cmd);
+
+			cur_len = sizeof(*cmd) + this_len;
+			cmd = malloc(cur_len);
+		}
+
+		fio_init_net_cmd(cmd, opcode, buf, this_len, tag);
+
+		if (this_len < size)
+			cmd->flags = __cpu_to_le32(FIO_NET_CMD_F_MORE);
+
+		fio_net_cmd_crc(cmd);
+
+		ret = fio_send_data(fd, cmd, sizeof(*cmd) + this_len);
+		size -= this_len;
+		buf += this_len;
+	} while (!ret && size);
+
+	if (cmd)
+		free(cmd);
+
+	return ret;
+}
+
+static int fio_net_send_simple_stack_cmd(int sk, uint16_t opcode, uint64_t tag)
+{
+	struct fio_net_cmd cmd;
+
+	fio_init_net_cmd(&cmd, opcode, NULL, 0, tag);
+	fio_net_cmd_crc(&cmd);
+
+	return fio_send_data(sk, &cmd, sizeof(cmd));
+}
+
+/*
+ * If 'list' is non-NULL, then allocate and store the sent command for
+ * later verification.
+ */
+int fio_net_send_simple_cmd(int sk, uint16_t opcode, uint64_t tag,
+			    struct flist_head *list)
+{
+	struct fio_net_int_cmd *cmd;
+	int ret;
+
+	if (!list)
+		return fio_net_send_simple_stack_cmd(sk, opcode, tag);
+
+	cmd = malloc(sizeof(*cmd));
+
+	fio_init_net_cmd(&cmd->cmd, opcode, NULL, 0, (uintptr_t) cmd);
+	fio_net_cmd_crc(&cmd->cmd);
+
+	INIT_FLIST_HEAD(&cmd->list);
+	gettimeofday(&cmd->tv, NULL);
+	cmd->saved_tag = tag;
+
+	ret = fio_send_data(sk, &cmd->cmd, sizeof(cmd->cmd));
+	if (ret) {
+		free(cmd);
+		return ret;
+	}
+
+	flist_add_tail(&cmd->list, list);
+	return 0;
+}
+
+static int fio_server_send_quit_cmd(void)
+{
+	dprint(FD_NET, "server: sending quit\n");
+	return fio_net_send_simple_cmd(server_fd, FIO_NET_CMD_QUIT, 0, NULL);
+}
+
+static int handle_job_cmd(struct fio_net_cmd *cmd)
+{
+	char *buf = (char *) cmd->payload;
+	int ret;
+
+	if (parse_jobs_ini(buf, 1, 0)) {
+		fio_server_send_quit_cmd();
+		return -1;
+	}
+
+	fio_net_send_simple_cmd(server_fd, FIO_NET_CMD_START, 0, NULL);
+
+	ret = exec_run();
+	fio_server_send_quit_cmd();
+	reset_fio_state();
+	return ret;
+}
+
+static int handle_jobline_cmd(struct fio_net_cmd *cmd)
+{
+	void *pdu = cmd->payload;
+	struct cmd_single_line_pdu *cslp;
+	struct cmd_line_pdu *clp;
+	unsigned long offset;
+	char **argv;
+	int ret, i;
+
+	clp = pdu;
+	clp->lines = le16_to_cpu(clp->lines);
+	argv = malloc(clp->lines * sizeof(char *));
+	offset = sizeof(*clp);
+
+	dprint(FD_NET, "server: %d command line args\n", clp->lines);
+
+	for (i = 0; i < clp->lines; i++) {
+		cslp = pdu + offset;
+		argv[i] = (char *) cslp->text;
+
+		offset += sizeof(*cslp) + le16_to_cpu(cslp->len);
+		dprint(FD_NET, "server: %d: %s\n", i, argv[i]);
+	}
+
+	if (parse_cmd_line(clp->lines, argv)) {
+		fio_server_send_quit_cmd();
+		free(argv);
+		return -1;
+	}
+
+	free(argv);
+
+	fio_net_send_simple_cmd(server_fd, FIO_NET_CMD_START, 0, NULL);
+
+	ret = exec_run();
+	fio_server_send_quit_cmd();
+	reset_fio_state();
+	return ret;
+}
+
+static int handle_probe_cmd(struct fio_net_cmd *cmd)
+{
+	struct cmd_probe_pdu probe;
+
+	dprint(FD_NET, "server: sending probe reply\n");
+
+	memset(&probe, 0, sizeof(probe));
+	gethostname((char *) probe.hostname, sizeof(probe.hostname));
+#ifdef FIO_BIG_ENDIAN
+	probe.bigendian = 1;
+#endif
+	probe.fio_major = FIO_MAJOR;
+	probe.fio_minor = FIO_MINOR;
+	probe.fio_patch = FIO_PATCH;
+
+	probe.os	= FIO_OS;
+	probe.arch	= FIO_ARCH;
+
+	probe.bpp	= sizeof(void *);
+
+	return fio_net_send_cmd(server_fd, FIO_NET_CMD_PROBE, &probe, sizeof(probe), cmd->tag);
+}
+
+static int handle_send_eta_cmd(struct fio_net_cmd *cmd)
+{
+	struct jobs_eta *je;
+	size_t size;
+	int i;
+
+	if (!thread_number)
+		return 0;
+
+	size = sizeof(*je) + thread_number * sizeof(char) + 1;
+	je = malloc(size);
+	memset(je, 0, size);
+
+	if (!calc_thread_status(je, 1)) {
+		free(je);
+		return 0;
+	}
+
+	dprint(FD_NET, "server sending status\n");
+
+	je->nr_running		= cpu_to_le32(je->nr_running);
+	je->nr_ramp		= cpu_to_le32(je->nr_ramp);
+	je->nr_pending		= cpu_to_le32(je->nr_pending);
+	je->files_open		= cpu_to_le32(je->files_open);
+	je->m_rate		= cpu_to_le32(je->m_rate);
+	je->t_rate		= cpu_to_le32(je->t_rate);
+	je->m_iops		= cpu_to_le32(je->m_iops);
+	je->t_iops		= cpu_to_le32(je->t_iops);
+
+	for (i = 0; i < 2; i++) {
+		je->rate[i]	= cpu_to_le32(je->rate[i]);
+		je->iops[i]	= cpu_to_le32(je->iops[i]);
+	}
+
+	je->elapsed_sec		= cpu_to_le32(je->nr_running);
+	je->eta_sec		= cpu_to_le64(je->eta_sec);
+
+	fio_net_send_cmd(server_fd, FIO_NET_CMD_ETA, je, size, cmd->tag);
+	free(je);
+	return 0;
+}
+
+static int handle_command(struct fio_net_cmd *cmd)
+{
+	int ret;
+
+	dprint(FD_NET, "server: got op [%s], pdu=%u, tag=%lx\n",
+			fio_server_op(cmd->opcode), cmd->pdu_len, cmd->tag);
+
+	switch (cmd->opcode) {
+	case FIO_NET_CMD_QUIT:
+		fio_terminate_threads(TERMINATE_ALL);
+		return -1;
+	case FIO_NET_CMD_EXIT:
+		exit_backend = 1;
+		return -1;
+	case FIO_NET_CMD_JOB:
+		ret = handle_job_cmd(cmd);
+		break;
+	case FIO_NET_CMD_JOBLINE:
+		ret = handle_jobline_cmd(cmd);
+		break;
+	case FIO_NET_CMD_PROBE:
+		ret = handle_probe_cmd(cmd);
+		break;
+	case FIO_NET_CMD_SEND_ETA:
+		ret = handle_send_eta_cmd(cmd);
+		break;
+	default:
+		log_err("fio: unknown opcode: %s\n",fio_server_op(cmd->opcode));
+		ret = 1;
+	}
+
+	return ret;
+}
+
+static int handle_connection(int sk, int block)
+{
+	struct fio_net_cmd *cmd = NULL;
+	int ret = 0;
+
+	/* read forever */
+	while (!exit_backend) {
+		struct pollfd pfd = {
+			.fd	= sk,
+			.events	= POLLIN,
+		};
+
+		ret = 0;
+		do {
+			ret = poll(&pfd, 1, 100);
+			if (ret < 0) {
+				if (errno == EINTR)
+					break;
+				log_err("fio: poll: %s\n", strerror(errno));
+				break;
+			} else if (!ret) {
+				if (!block)
+					return 0;
+				continue;
+			}
+
+			if (pfd.revents & POLLIN)
+				break;
+			if (pfd.revents & (POLLERR|POLLHUP)) {
+				ret = 1;
+				break;
+			}
+		} while (!exit_backend);
+
+		if (ret < 0)
+			break;
+
+		cmd = fio_net_recv_cmd(sk);
+		if (!cmd) {
+			ret = -1;
+			break;
+		}
+
+		ret = handle_command(cmd);
+		if (ret)
+			break;
+
+		free(cmd);
+		cmd = NULL;
+	}
+
+	if (cmd)
+		free(cmd);
+
+	return ret;
+}
+
+void fio_server_idle_loop(void)
+{
+	if (server_fd != -1)
+		handle_connection(server_fd, 0);
+}
+
+static int accept_loop(int listen_sk)
+{
+	struct sockaddr_in addr;
+	fio_socklen_t len = sizeof(addr);
+	struct pollfd pfd;
+	int ret, sk, flags, exitval = 0;
+
+	dprint(FD_NET, "server enter accept loop\n");
+
+	flags = fcntl(listen_sk, F_GETFL);
+	flags |= O_NONBLOCK;
+	fcntl(listen_sk, F_SETFL, flags);
+again:
+	pfd.fd = listen_sk;
+	pfd.events = POLLIN;
+	do {
+		ret = poll(&pfd, 1, 100);
+		if (ret < 0) {
+			if (errno == EINTR)
+				break;
+			log_err("fio: poll: %s\n", strerror(errno));
+			goto out;
+		} else if (!ret)
+			continue;
+
+		if (pfd.revents & POLLIN)
+			break;
+	} while (!exit_backend);
+
+	if (exit_backend)
+		goto out;
+
+	sk = accept(listen_sk, (struct sockaddr *) &addr, &len);
+	if (sk < 0) {
+		log_err("fio: accept: %s\n", strerror(errno));
+		return -1;
+	}
+
+	dprint(FD_NET, "server: connect from %s\n", inet_ntoa(addr.sin_addr));
+
+	server_fd = sk;
+
+	exitval = handle_connection(sk, 1);
+
+	server_fd = -1;
+	close(sk);
+
+	if (!exit_backend)
+		goto again;
+
+out:
+	return exitval;
+}
+
+int fio_server_text_output(const char *buf, size_t len)
+{
+	if (server_fd != -1)
+		return fio_net_send_cmd(server_fd, FIO_NET_CMD_TEXT, buf, len, 0);
+
+	return log_local_buf(buf, len);
+}
+
+static void convert_io_stat(struct io_stat *dst, struct io_stat *src)
+{
+	dst->max_val	= cpu_to_le64(src->max_val);
+	dst->min_val	= cpu_to_le64(src->min_val);
+	dst->samples	= cpu_to_le64(src->samples);
+
+	/*
+	 * Encode to IEEE 754 for network transfer
+	 */
+	dst->mean.u.i	= __cpu_to_le64(fio_double_to_uint64(src->mean.u.f));
+	dst->S.u.i	= __cpu_to_le64(fio_double_to_uint64(src->S.u.f));
+}
+
+static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		dst->max_run[i]		= cpu_to_le64(src->max_run[i]);
+		dst->min_run[i]		= cpu_to_le64(src->min_run[i]);
+		dst->max_bw[i]		= cpu_to_le64(src->max_bw[i]);
+		dst->min_bw[i]		= cpu_to_le64(src->min_bw[i]);
+		dst->io_kb[i]		= cpu_to_le64(src->io_kb[i]);
+		dst->agg[i]		= cpu_to_le64(src->agg[i]);
+	}
+
+	dst->kb_base	= cpu_to_le32(src->kb_base);
+	dst->groupid	= cpu_to_le32(src->groupid);
+}
+
+/*
+ * Send a CMD_TS, which packs struct thread_stat and group_run_stats
+ * into a single payload.
+ */
+void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
+{
+	struct cmd_ts_pdu p;
+	int i, j;
+
+	dprint(FD_NET, "server sending end stats\n");
+
+	memset(&p, 0, sizeof(p));
+
+	strcpy(p.ts.name, ts->name);
+	strcpy(p.ts.verror, ts->verror);
+	strcpy(p.ts.description, ts->description);
+
+	p.ts.error	= cpu_to_le32(ts->error);
+	p.ts.groupid	= cpu_to_le32(ts->groupid);
+	p.ts.pid	= cpu_to_le32(ts->pid);
+	p.ts.members	= cpu_to_le32(ts->members);
+
+	for (i = 0; i < 2; i++) {
+		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]);
+		convert_io_stat(&p.ts.slat_stat[i], &ts->slat_stat[i]);
+		convert_io_stat(&p.ts.lat_stat[i], &ts->lat_stat[i]);
+		convert_io_stat(&p.ts.bw_stat[i], &ts->bw_stat[i]);
+	}
+
+	p.ts.usr_time		= cpu_to_le64(ts->usr_time);
+	p.ts.sys_time		= cpu_to_le64(ts->sys_time);
+	p.ts.ctx		= cpu_to_le64(ts->ctx);
+	p.ts.minf		= cpu_to_le64(ts->minf);
+	p.ts.majf		= cpu_to_le64(ts->majf);
+	p.ts.clat_percentiles	= cpu_to_le64(ts->clat_percentiles);
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
+		fio_fp64_t *src = &ts->percentile_list[i];
+		fio_fp64_t *dst = &p.ts.percentile_list[i];
+
+		dst->u.i = __cpu_to_le64(fio_double_to_uint64(src->u.f));
+	}
+
+	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
+		p.ts.io_u_map[i]	= cpu_to_le32(ts->io_u_map[i]);
+		p.ts.io_u_submit[i]	= cpu_to_le32(ts->io_u_submit[i]);
+		p.ts.io_u_complete[i]	= cpu_to_le32(ts->io_u_complete[i]);
+	}
+
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++) {
+		p.ts.io_u_lat_u[i]	= cpu_to_le32(ts->io_u_lat_u[i]);
+		p.ts.io_u_lat_m[i]	= cpu_to_le32(ts->io_u_lat_m[i]);
+	}
+
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
+			p.ts.io_u_plat[i][j] = cpu_to_le32(ts->io_u_plat[i][j]);
+
+	for (i = 0; i < 3; i++) {
+		p.ts.total_io_u[i]	= cpu_to_le64(ts->total_io_u[i]);
+		p.ts.short_io_u[i]	= cpu_to_le64(ts->short_io_u[i]);
+	}
+
+	p.ts.total_submit	= cpu_to_le64(ts->total_submit);
+	p.ts.total_complete	= cpu_to_le64(ts->total_complete);
+
+	for (i = 0; i < 2; i++) {
+		p.ts.io_bytes[i]	= cpu_to_le64(ts->io_bytes[i]);
+		p.ts.runtime[i]		= cpu_to_le64(ts->runtime[i]);
+	}
+
+	p.ts.total_run_time	= cpu_to_le64(ts->total_run_time);
+	p.ts.continue_on_error	= cpu_to_le16(ts->continue_on_error);
+	p.ts.total_err_count	= cpu_to_le64(ts->total_err_count);
+	p.ts.first_error	= cpu_to_le32(ts->first_error);
+	p.ts.kb_base		= cpu_to_le32(ts->kb_base);
+
+	convert_gs(&p.rs, rs);
+
+	fio_net_send_cmd(server_fd, FIO_NET_CMD_TS, &p, sizeof(p), 0);
+}
+
+void fio_server_send_gs(struct group_run_stats *rs)
+{
+	struct group_run_stats gs;
+
+	dprint(FD_NET, "server sending group run stats\n");
+
+	convert_gs(&gs, rs);
+	fio_net_send_cmd(server_fd, FIO_NET_CMD_GS, &gs, sizeof(gs), 0);
+}
+
+static void convert_agg(struct disk_util_agg *dst, struct disk_util_agg *src)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		dst->ios[i]	= cpu_to_le32(src->ios[i]);
+		dst->merges[i]	= cpu_to_le32(src->merges[i]);
+		dst->sectors[i]	= cpu_to_le64(src->sectors[i]);
+		dst->ticks[i]	= cpu_to_le32(src->ticks[i]);
+	}
+
+	dst->io_ticks		= cpu_to_le32(src->io_ticks);
+	dst->time_in_queue	= cpu_to_le32(src->time_in_queue);
+	dst->slavecount		= cpu_to_le32(src->slavecount);
+	dst->max_util.u.i	= __cpu_to_le64(fio_double_to_uint64(src->max_util.u.f));
+}
+
+static void convert_dus(struct disk_util_stat *dst, struct disk_util_stat *src)
+{
+	int i;
+
+	strcpy((char *) dst->name, (char *) src->name);
+
+	for (i = 0; i < 2; i++) {
+		dst->ios[i]	= cpu_to_le32(src->ios[i]);
+		dst->merges[i]	= cpu_to_le32(src->merges[i]);
+		dst->sectors[i]	= cpu_to_le64(src->sectors[i]);
+		dst->ticks[i]	= cpu_to_le32(src->ticks[i]);
+	}
+
+	dst->io_ticks		= cpu_to_le32(src->io_ticks);
+	dst->time_in_queue	= cpu_to_le32(src->time_in_queue);
+	dst->msec		= cpu_to_le64(src->msec);
+}
+
+void fio_server_send_du(void)
+{
+	struct disk_util *du;
+	struct flist_head *entry;
+	struct cmd_du_pdu pdu;
+
+	dprint(FD_NET, "server: sending disk_util %d\n", !flist_empty(&disk_list));
+
+	memset(&pdu, 0, sizeof(pdu));
+
+	flist_for_each(entry, &disk_list) {
+		du = flist_entry(entry, struct disk_util, list);
+
+		convert_dus(&pdu.dus, &du->dus);
+		convert_agg(&pdu.agg, &du->agg);
+
+		fio_net_send_cmd(server_fd, FIO_NET_CMD_DU, &pdu, sizeof(pdu), 0);
+	}
+}
+
+int fio_server_log(const char *format, ...)
+{
+	char buffer[1024];
+	va_list args;
+	size_t len;
+
+	dprint(FD_NET, "server log\n");
+
+	va_start(args, format);
+	len = vsnprintf(buffer, sizeof(buffer), format, args);
+	va_end(args);
+
+	return fio_server_text_output(buffer, len);
+}
+
+static int fio_init_server_ip(void)
+{
+	int sk, opt;
+
+	sk = socket(AF_INET, SOCK_STREAM, 0);
+	if (sk < 0) {
+		log_err("fio: socket: %s\n", strerror(errno));
+		return -1;
+	}
+
+	opt = 1;
+	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) < 0) {
+		log_err("fio: setsockopt: %s\n", strerror(errno));
+		close(sk);
+		return -1;
+	}
+#ifdef SO_REUSEPORT
+	if (setsockopt(sk, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)) < 0) {
+		log_err("fio: setsockopt: %s\n", strerror(errno));
+		close(sk);
+		return -1;
+	}
+#endif
+
+	saddr_in.sin_family = AF_INET;
+
+	if (bind(sk, (struct sockaddr *) &saddr_in, sizeof(saddr_in)) < 0) {
+		log_err("fio: bind: %s\n", strerror(errno));
+		close(sk);
+		return -1;
+	}
+
+	return sk;
+}
+
+static int fio_init_server_sock(void)
+{
+	struct sockaddr_un addr;
+	fio_socklen_t len;
+	mode_t mode;
+	int sk;
+
+	sk = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (sk < 0) {
+		log_err("fio: socket: %s\n", strerror(errno));
+		return -1;
+	}
+
+	mode = umask(000);
+
+	memset(&addr, 0, sizeof(addr));
+	addr.sun_family = AF_UNIX;
+	strcpy(addr.sun_path, bind_sock);
+	unlink(bind_sock);
+
+	len = sizeof(addr.sun_family) + strlen(bind_sock) + 1;
+
+	if (bind(sk, (struct sockaddr *) &addr, len) < 0) {
+		log_err("fio: bind: %s\n", strerror(errno));
+		close(sk);
+		return -1;
+	}
+
+	umask(mode);
+	return sk;
+}
+
+static int fio_init_server_connection(void)
+{
+	char bind_str[128];
+	int sk;
+
+	dprint(FD_NET, "starting server\n");
+
+	if (!bind_sock)
+		sk = fio_init_server_ip();
+	else
+		sk = fio_init_server_sock();
+
+	if (sk < 0)
+		return sk;
+
+	if (!bind_sock)
+		sprintf(bind_str, "%s:%u", inet_ntoa(saddr_in.sin_addr), fio_net_port);
+	else
+		strcpy(bind_str, bind_sock);
+
+	log_info("fio: server listening on %s\n", bind_str);
+
+	if (listen(sk, 0) < 0) {
+		log_err("fio: listen: %s\n", strerror(errno));
+		return -1;
+	}
+
+	return sk;
+}
+
+int fio_server_parse_string(const char *str, char **ptr, int *is_sock,
+			    int *port, struct in_addr *inp)
+{
+	*ptr = NULL;
+	*is_sock = 0;
+	*port = fio_net_port;
+
+	if (!strncmp(str, "sock:", 5)) {
+		*ptr = strdup(str + 5);
+		*is_sock = 1;
+	} else {
+		const char *host = str;
+		char *portp;
+		int lport = 0;
+
+		/*
+		 * Is it ip:<ip or host>:port
+		 */
+		if (!strncmp(host, "ip:", 3))
+			host += 3;
+		else if (host[0] == ':') {
+			/* String is :port */
+			host++;
+			lport = atoi(host);
+			if (!lport || lport > 65535) {
+				log_err("fio: bad server port %u\n", port);
+				return 1;
+			}
+			/* no hostname given, we are done */
+			*port = lport;
+			return 0;
+		}
+
+		/*
+		 * If no port seen yet, check if there's a last ':' at the end
+		 */
+		if (!lport) {
+			portp = strchr(host, ':');
+			if (portp) {
+				*portp = '\0';
+				portp++;
+				lport = atoi(portp);
+				if (!lport || lport > 65535) {
+					log_err("fio: bad server port %u\n", port);
+					return 1;
+				}
+			}
+		}
+
+		if (lport)
+			*port = lport;
+
+		*ptr = strdup(host);
+
+		if (inet_aton(host, inp) != 1) {
+			struct hostent *hent;
+
+			hent = gethostbyname(host);
+			if (!hent) {
+				free(*ptr);
+				*ptr = NULL;
+				return 1;
+			}
+
+			memcpy(inp, hent->h_addr, 4);
+		}
+	}
+
+	if (*port == 0)
+		*port = fio_net_port;
+
+	return 0;
+}
+
+/*
+ * Server arg should be one of:
+ *
+ * sock:/path/to/socket
+ *   ip:1.2.3.4
+ *      1.2.3.4
+ *
+ * Where sock uses unix domain sockets, and ip binds the server to
+ * a specific interface. If no arguments are given to the server, it
+ * uses IP and binds to 0.0.0.0.
+ *
+ */
+static int fio_handle_server_arg(void)
+{
+	int port = fio_net_port;
+	int is_sock, ret = 0;
+
+	saddr_in.sin_addr.s_addr = htonl(INADDR_ANY);
+
+	if (!fio_server_arg)
+		goto out;
+
+	ret = fio_server_parse_string(fio_server_arg, &bind_sock, &is_sock,
+					&port, &saddr_in.sin_addr);
+
+	if (!is_sock && bind_sock) {
+		free(bind_sock);
+		bind_sock = NULL;
+	}
+
+out:
+	fio_net_port = port;
+	saddr_in.sin_port = htons(port);
+	return ret;
+}
+
+static int fio_server(void)
+{
+	int sk, ret;
+
+	dprint(FD_NET, "starting server\n");
+
+	if (fio_handle_server_arg())
+		return -1;
+
+	sk = fio_init_server_connection();
+	if (sk < 0)
+		return -1;
+
+	ret = accept_loop(sk);
+
+	close(sk);
+
+	if (fio_server_arg) {
+		free(fio_server_arg);
+		fio_server_arg = NULL;
+	}
+	if (bind_sock)
+		free(bind_sock);
+
+	return ret;
+}
+
+void fio_server_got_signal(int signal)
+{
+	if (signal == SIGPIPE)
+		server_fd = -1;
+	else {
+		log_info("\nfio: terminating on signal %d\n", signal);
+		exit_backend = 1;
+	}
+}
+
+static int check_existing_pidfile(const char *pidfile)
+{
+	struct stat sb;
+	char buf[16];
+	pid_t pid;
+	FILE *f;
+
+	if (stat(pidfile, &sb))
+		return 0;
+
+	f = fopen(pidfile, "r");
+	if (!f)
+		return 0;
+
+	if (fread(buf, sb.st_size, 1, f) <= 0) {
+		fclose(f);
+		return 1;
+	}
+	fclose(f);
+
+	pid = atoi(buf);
+	if (kill(pid, SIGCONT) < 0)
+		return errno != ESRCH;
+
+	return 1;
+}
+
+static int write_pid(pid_t pid, const char *pidfile)
+{
+	FILE *fpid;
+
+	fpid = fopen(pidfile, "w");
+	if (!fpid) {
+		log_err("fio: failed opening pid file %s\n", pidfile);
+		return 1;
+	}
+
+	fprintf(fpid, "%u\n", (unsigned int) pid);
+	fclose(fpid);
+	return 0;
+}
+
+/*
+ * If pidfile is specified, background us.
+ */
+int fio_start_server(char *pidfile)
+{
+	pid_t pid;
+	int ret;
+
+	if (!pidfile)
+		return fio_server();
+
+	if (check_existing_pidfile(pidfile)) {
+		log_err("fio: pidfile %s exists and server appears alive\n",
+								pidfile);
+		return -1;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		log_err("fio: failed server fork: %s", strerror(errno));
+		free(pidfile);
+		return -1;
+	} else if (pid) {
+		int ret = write_pid(pid, pidfile);
+
+		exit(ret);
+	}
+
+	setsid();
+	openlog("fio", LOG_NDELAY|LOG_NOWAIT|LOG_PID, LOG_USER);
+	log_syslog = 1;
+	close(STDIN_FILENO);
+	close(STDOUT_FILENO);
+	close(STDERR_FILENO);
+	f_out = NULL;
+	f_err = NULL;
+
+	ret = fio_server();
+
+	closelog();
+	unlink(pidfile);
+	free(pidfile);
+	return ret;
+}
+
+void fio_server_set_arg(const char *arg)
+{
+	fio_server_arg = strdup(arg);
+}
diff --git a/server.h b/server.h
new file mode 100644
index 0000000..d709e98
--- /dev/null
+++ b/server.h
@@ -0,0 +1,144 @@
+#ifndef FIO_SERVER_H
+#define FIO_SERVER_H
+
+#include <inttypes.h>
+#include <string.h>
+#include <sys/time.h>
+
+#include "stat.h"
+#include "os/os.h"
+#include "diskutil.h"
+
+/*
+ * On-wire encoding is little endian
+ */
+struct fio_net_cmd {
+	uint16_t version;	/* protocol version */
+	uint16_t opcode;	/* command opcode */
+	uint32_t flags;		/* modifier flags */
+	uint64_t tag;		/* passed back on reply */
+	uint32_t pdu_len;	/* length of post-cmd layload */
+	/*
+	 * These must be immediately before the payload, anything before
+	 * these fields are checksummed.
+	 */
+	uint16_t cmd_crc16;	/* cmd checksum */
+	uint16_t pdu_crc16;	/* payload checksum */
+	uint8_t payload[0];	/* payload */
+};
+
+struct fio_net_int_cmd {
+	struct fio_net_cmd cmd;
+	struct flist_head list;
+	struct timeval tv;
+	uint64_t saved_tag;
+};
+
+enum {
+	FIO_SERVER_VER		= 5,
+
+	FIO_SERVER_MAX_PDU	= 1024,
+
+	FIO_NET_CMD_QUIT	= 1,
+	FIO_NET_CMD_EXIT	= 2,
+	FIO_NET_CMD_JOB		= 3,
+	FIO_NET_CMD_JOBLINE	= 4,
+	FIO_NET_CMD_TEXT	= 5,
+	FIO_NET_CMD_TS		= 6,
+	FIO_NET_CMD_GS		= 7,
+	FIO_NET_CMD_SEND_ETA	= 8,
+	FIO_NET_CMD_ETA		= 9,
+	FIO_NET_CMD_PROBE	= 10,
+	FIO_NET_CMD_START	= 11,
+	FIO_NET_CMD_STOP	= 12,
+	FIO_NET_CMD_DU		= 13,
+	FIO_NET_CMD_NR		= 14,
+
+	FIO_NET_CMD_F_MORE	= 1UL << 0,
+
+	/* crc does not include the crc fields */
+	FIO_NET_CMD_CRC_SZ	= sizeof(struct fio_net_cmd) -
+					2 * sizeof(uint16_t),
+
+	FIO_NET_CLIENT_TIMEOUT	= 5000,
+};
+
+struct cmd_ts_pdu {
+	struct thread_stat ts;
+	struct group_run_stats rs;
+};
+
+struct cmd_du_pdu {
+	struct disk_util_stat dus;
+	struct disk_util_agg agg;
+};
+
+struct cmd_probe_pdu {
+	uint8_t hostname[64];
+	uint8_t bigendian;
+	uint8_t fio_major;
+	uint8_t fio_minor;
+	uint8_t fio_patch;
+	uint8_t os;
+	uint8_t arch;
+	uint8_t bpp;
+};
+
+struct cmd_single_line_pdu {
+	uint16_t len;
+	uint8_t text[0];
+};
+
+struct cmd_line_pdu {
+	uint16_t lines;
+	struct cmd_single_line_pdu options[0];
+};
+
+extern int fio_start_server(char *);
+extern int fio_server_text_output(const char *, size_t);
+extern int fio_server_log(const char *format, ...);
+extern int fio_net_send_cmd(int, uint16_t, const void *, off_t, uint64_t);
+extern int fio_net_send_simple_cmd(int, uint16_t, uint64_t, struct flist_head *);
+extern void fio_server_set_arg(const char *);
+extern int fio_server_parse_string(const char *, char **, int *, int *, struct in_addr *);
+extern const char *fio_server_op(unsigned int);
+extern void fio_server_got_signal(int);
+
+struct thread_stat;
+struct group_run_stats;
+extern void fio_server_send_ts(struct thread_stat *, struct group_run_stats *);
+extern void fio_server_send_gs(struct group_run_stats *);
+extern void fio_server_send_du(void);
+extern void fio_server_idle_loop(void);
+
+extern int fio_clients_connect(void);
+extern int fio_clients_send_ini(const char *);
+extern int fio_handle_clients(void);
+extern int fio_client_add(const char *, void **);
+extern void fio_client_add_cmd_option(void *, const char *);
+
+extern int fio_recv_data(int sk, void *p, unsigned int len);
+extern int fio_send_data(int sk, const void *p, unsigned int len);
+extern void fio_net_cmd_crc(struct fio_net_cmd *);
+extern struct fio_net_cmd *fio_net_recv_cmd(int sk);
+
+extern int exit_backend;
+extern int fio_net_port;
+
+static inline void fio_init_net_cmd(struct fio_net_cmd *cmd, uint16_t opcode,
+				    const void *pdu, uint32_t pdu_len,
+				    uint64_t tag)
+{
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->version	= __cpu_to_le16(FIO_SERVER_VER);
+	cmd->opcode	= cpu_to_le16(opcode);
+	cmd->tag	= cpu_to_le64(tag);
+
+	if (pdu) {
+		cmd->pdu_len	= cpu_to_le32(pdu_len);
+		memcpy(&cmd->payload, pdu, pdu_len);
+	}
+}
+
+#endif
diff --git a/stat.c b/stat.c
index 3662fd9..d310686 100644
--- a/stat.c
+++ b/stat.c
@@ -9,23 +9,24 @@
 
 #include "fio.h"
 #include "diskutil.h"
+#include "lib/ieee754.h"
 
 void update_rusage_stat(struct thread_data *td)
 {
 	struct thread_stat *ts = &td->ts;
 
-	getrusage(RUSAGE_SELF, &ts->ru_end);
+	getrusage(RUSAGE_SELF, &td->ru_end);
 
-	ts->usr_time += mtime_since(&ts->ru_start.ru_utime,
-					&ts->ru_end.ru_utime);
-	ts->sys_time += mtime_since(&ts->ru_start.ru_stime,
-					&ts->ru_end.ru_stime);
-	ts->ctx += ts->ru_end.ru_nvcsw + ts->ru_end.ru_nivcsw
-			- (ts->ru_start.ru_nvcsw + ts->ru_start.ru_nivcsw);
-	ts->minf += ts->ru_end.ru_minflt - ts->ru_start.ru_minflt;
-	ts->majf += ts->ru_end.ru_majflt - ts->ru_start.ru_majflt;
+	ts->usr_time += mtime_since(&td->ru_start.ru_utime,
+					&td->ru_end.ru_utime);
+	ts->sys_time += mtime_since(&td->ru_start.ru_stime,
+					&td->ru_end.ru_stime);
+	ts->ctx += td->ru_end.ru_nvcsw + td->ru_end.ru_nivcsw
+			- (td->ru_start.ru_nvcsw + td->ru_start.ru_nivcsw);
+	ts->minf += td->ru_end.ru_minflt - td->ru_start.ru_minflt;
+	ts->majf += td->ru_end.ru_majflt - td->ru_start.ru_majflt;
 
-	memcpy(&ts->ru_start, &ts->ru_end, sizeof(ts->ru_end));
+	memcpy(&td->ru_start, &td->ru_end, sizeof(td->ru_end));
 }
 
 /*
@@ -101,72 +102,136 @@ static unsigned int plat_idx_to_val(unsigned int idx)
 
 static int double_cmp(const void *a, const void *b)
 {
-	const double fa = *(const double *)a;
-	const double fb = *(const double *)b;
+	const fio_fp64_t fa = *(const fio_fp64_t *) a;
+	const fio_fp64_t fb = *(const fio_fp64_t *) b;
 	int cmp = 0;
 
-	if (fa > fb)
+	if (fa.u.f > fb.u.f)
 		cmp = 1;
-	else if (fa < fb)
+	else if (fa.u.f < fb.u.f)
 		cmp = -1;
 
 	return cmp;
 }
 
-/*
- * Find and display the p-th percentile of clat
- */
-static void show_clat_percentiles(unsigned int* io_u_plat, unsigned long nr,
-				 double* user_list)
+static unsigned int calc_clat_percentiles(unsigned int *io_u_plat,
+					  unsigned long nr, fio_fp64_t *plist,
+					  unsigned int **output,
+					  unsigned int *maxv,
+					  unsigned int *minv)
 {
 	unsigned long sum = 0;
 	unsigned int len, i, j = 0;
-	const double *plist;
-	int is_last = 0;
-	static const double def_list[FIO_IO_U_LIST_MAX_LEN] = {
-			1.0, 5.0, 10.0, 20.0, 30.0,
-			40.0, 50.0, 60.0, 70.0, 80.0,
-			90.0, 95.0, 99.0, 99.5, 99.9};
+	unsigned int oval_len = 0;
+	unsigned int *ovals = NULL;
+	int is_last;
+
+	*minv = -1U;
+	*maxv = 0;
 
-	plist = user_list;
-	if (!plist)
-		plist = def_list;
+	len = 0;
+	while (len < FIO_IO_U_LIST_MAX_LEN && plist[len].u.f != 0.0)
+		len++;
 
-	for (len = 0; len <FIO_IO_U_LIST_MAX_LEN && plist[len] != 0; len++)
-		;
+	if (!len)
+		return 0;
 
 	/*
-	 * Sort the user-specified list. Note that this does not work
-	 * for NaN values
+	 * Sort the percentile list. Note that it may already be sorted if
+	 * we are using the default values, but since it's a short list this
+	 * isn't a worry. Also note that this does not work for NaN values.
 	 */
-	if (user_list && len > 1)
-		qsort((void*)user_list, len, sizeof(user_list[0]), double_cmp);
-
-	log_info("    clat percentiles (usec) :");
+	if (len > 1)
+		qsort((void*)plist, len, sizeof(plist[0]), double_cmp);
 
+	/*
+	 * Calculate bucket values, note down max and min values
+	 */
+	is_last = 0;
 	for (i = 0; i < FIO_IO_U_PLAT_NR && !is_last; i++) {
 		sum += io_u_plat[i];
-		while (sum >= (plist[j] / 100 * nr)) {
-			assert(plist[j] <= 100.0);
+		while (sum >= (plist[j].u.f / 100.0 * nr)) {
+			assert(plist[j].u.f <= 100.0);
 
-			/* for formatting */
-			if (j != 0 && (j % 4) == 0)
-				log_info("                             ");
-
-			/* end of the list */
-			is_last = (j == len - 1);
+			if (j == oval_len) {
+				oval_len += 100;
+				ovals = realloc(ovals, oval_len * sizeof(unsigned int));
+			}
 
-			log_info(" %2.2fth=%u%c", plist[j], plat_idx_to_val(i),
-				 (is_last? '\n' : ','));
+			ovals[j] = plat_idx_to_val(i);
+			if (ovals[j] < *minv)
+				*minv = ovals[j];
+			if (ovals[j] > *maxv)
+				*maxv = ovals[j];
 
+			is_last = (j == len - 1);
 			if (is_last)
 				break;
 
-			if (j % 4 == 3)	/* for formatting */
-				log_info("\n");
 			j++;
 		}
 	}
+
+	*output = ovals;
+	return len;
+}
+
+/*
+ * Find and display the p-th percentile of clat
+ */
+static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
+				  fio_fp64_t *plist)
+{
+	unsigned int len, j = 0, minv, maxv;
+	unsigned int *ovals;
+	int is_last, scale_down;
+
+	len = calc_clat_percentiles(io_u_plat, nr, plist, &ovals, &maxv, &minv);
+	if (!len)
+		goto out;
+
+	/*
+	 * We default to usecs, but if the value range is such that we
+	 * should scale down to msecs, do that.
+	 */
+	if (minv > 2000 && maxv > 99999) {
+		scale_down = 1;
+		log_info("    clat percentiles (msec):\n     |");
+	} else {
+		scale_down = 0;
+		log_info("    clat percentiles (usec):\n     |");
+	}
+
+	for (j = 0; j < len; j++) {
+		char fbuf[8];
+
+		/* for formatting */
+		if (j != 0 && (j % 4) == 0)
+			log_info("     |");
+
+		/* end of the list */
+		is_last = (j == len - 1);
+
+		if (plist[j].u.f < 10.0)
+			sprintf(fbuf, " %2.2f", plist[j].u.f);
+		else
+			sprintf(fbuf, "%2.2f", plist[j].u.f);
+
+		if (scale_down)
+			ovals[j] = (ovals[j] + 999) / 1000;
+
+		log_info(" %sth=[%5u]%c", fbuf, ovals[j], is_last ? '\n' : ',');
+
+		if (is_last)
+			break;
+
+		if (j % 4 == 3)	/* for formatting */
+			log_info("\n");
+	}
+
+out:
+	if (ovals)
+		free(ovals);
 }
 
 static int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
@@ -181,23 +246,23 @@ static int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 	*max = is->max_val;
 
 	n = (double) is->samples;
-	*mean = is->mean;
+	*mean = is->mean.u.f;
 
 	if (n > 1.0)
-		*dev = sqrt(is->S / (n - 1.0));
+		*dev = sqrt(is->S.u.f / (n - 1.0));
 	else
 		*dev = 0;
 
 	return 1;
 }
 
-static void show_group_stats(struct group_run_stats *rs, int id)
+void show_group_stats(struct group_run_stats *rs)
 {
 	char *p1, *p2, *p3, *p4;
 	const char *ddir_str[] = { "   READ", "  WRITE" };
 	int i;
 
-	log_info("\nRun status group %d (all jobs):\n", id);
+	log_info("Run status group %d (all jobs):\n", rs->groupid);
 
 	for (i = 0; i <= DDIR_WRITE; i++) {
 		const int i2p = is_power_of_2(rs->kb_base);
@@ -378,7 +443,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		double p_of_agg;
 
 		p_of_agg = mean * 100 / (double) rs->agg[ddir];
-		log_info("    bw (KB/s) : min=%5lu, max=%5lu, per=%3.2f%%,"
+		log_info("     bw (KB/s) : min=%5lu, max=%5lu, per=%3.2f%%,"
 			 " avg=%5.02f, stdev=%5.02f\n", min, max, p_of_agg,
 							mean, dev);
 	}
@@ -433,8 +498,7 @@ static void show_latencies(double *io_u_lat_u, double *io_u_lat_m)
 	log_info("\n");
 }
 
-static void show_thread_status(struct thread_stat *ts,
-			       struct group_run_stats *rs)
+void show_thread_status(struct thread_stat *ts, struct group_run_stats *rs)
 {
 	double usr_cpu, sys_cpu;
 	unsigned long runtime;
@@ -456,7 +520,7 @@ static void show_thread_status(struct thread_stat *ts,
 					ts->error, ts->verror, (int) ts->pid);
 	}
 
-	if (ts->description)
+	if (strlen(ts->description))
 		log_info("  Description  : [%s]\n", ts->description);
 
 	if (ts->io_bytes[DDIR_READ])
@@ -517,16 +581,23 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 				   struct group_run_stats *rs, int ddir)
 {
 	unsigned long min, max;
-	unsigned long long bw;
+	unsigned long long bw, iops;
+	unsigned int *ovals = NULL;
 	double mean, dev;
+	unsigned int len, minv, maxv;
+	int i;
 
 	assert(ddir_rw(ddir));
 
-	bw = 0;
-	if (ts->runtime[ddir])
-		bw = ts->io_bytes[ddir] / ts->runtime[ddir];
+	iops = bw = 0;
+	if (ts->runtime[ddir]) {
+		uint64_t runt = ts->runtime[ddir];
+
+		bw = ts->io_bytes[ddir] / runt;
+		iops = (1000 * (uint64_t) ts->total_io_u[ddir]) / runt;
+	}
 
-	log_info(";%llu;%llu;%llu", ts->io_bytes[ddir] >> 10, bw,
+	log_info(";%llu;%llu;%llu;%llu", ts->io_bytes[ddir] >> 10, bw, iops,
 							ts->runtime[ddir]);
 
 	if (calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev))
@@ -544,6 +615,24 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	else
 		log_info(";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
 
+	if (ts->clat_percentiles) {
+		len = calc_clat_percentiles(ts->io_u_plat[ddir],
+					ts->clat_stat[ddir].samples,
+					ts->percentile_list, &ovals, &maxv,
+					&minv);
+	} else
+		len = 0;
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
+		if (i >= len) {
+			log_info(";0%%=0");
+			continue;
+		}
+		log_info(";%2.2f%%=%u", ts->percentile_list[i].u.f, ovals[i]);
+	}
+	if (ovals)
+		free(ovals);
+
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg;
 
@@ -553,7 +642,7 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 		log_info(";%lu;%lu;%f%%;%f;%f", 0UL, 0UL, 0.0, 0.0, 0.0);
 }
 
-#define FIO_TERSE_VERSION	"2"
+#define FIO_TERSE_VERSION	"3"
 
 static void show_thread_status_terse(struct thread_stat *ts,
 				     struct group_run_stats *rs)
@@ -602,16 +691,18 @@ static void show_thread_status_terse(struct thread_stat *ts,
 	/* Millisecond latency */
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		log_info(";%3.2f%%", io_u_lat_m[i]);
+
+	/* disk util stats, if any */
+	show_disk_util(1);
+
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
 		log_info(";%lu;%d", ts->total_err_count, ts->first_error);
 	log_info("\n");
 
 	/* Additional output if description is set */
-	if (ts->description)
+	if (strlen(ts->description))
 		log_info(";%s", ts->description);
-
-	log_info("\n");
 }
 
 static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
@@ -630,23 +721,114 @@ static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
 	 *  #Parallel_algorithm>
 	 */
 	if (nr == 1) {
-		mean = src->mean;
-		S = src->S;
+		mean = src->mean.u.f;
+		S = src->S.u.f;
 	} else {
-		double delta = src->mean - dst->mean;
+		double delta = src->mean.u.f - dst->mean.u.f;
 
-		mean = ((src->mean * src->samples) +
-			(dst->mean * dst->samples)) /
+		mean = ((src->mean.u.f * src->samples) +
+			(dst->mean.u.f * dst->samples)) /
 			(dst->samples + src->samples);
 
-		S =  src->S + dst->S + pow(delta, 2.0) *
+		S =  src->S.u.f + dst->S.u.f + pow(delta, 2.0) *
 			(dst->samples * src->samples) /
 			(dst->samples + src->samples);
 	}
 
 	dst->samples += src->samples;
-	dst->mean = mean;
-	dst->S = S;
+	dst->mean.u.f = mean;
+	dst->S.u.f = S;
+}
+
+void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		if (dst->max_run[i] < src->max_run[i])
+			dst->max_run[i] = src->max_run[i];
+		if (dst->min_run[i] && dst->min_run[i] > src->min_run[i])
+			dst->min_run[i] = src->min_run[i];
+		if (dst->max_bw[i] < src->max_bw[i])
+			dst->max_bw[i] = src->max_bw[i];
+		if (dst->min_bw[i] && dst->min_bw[i] > src->min_bw[i])
+			dst->min_bw[i] = src->min_bw[i];
+
+		dst->io_kb[i] += src->io_kb[i];
+		dst->agg[i] += src->agg[i];
+	}
+
+}
+
+void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr)
+{
+	int l, k;
+
+	for (l = 0; l <= DDIR_WRITE; l++) {
+		sum_stat(&dst->clat_stat[l], &src->clat_stat[l], nr);
+		sum_stat(&dst->slat_stat[l], &src->slat_stat[l], nr);
+		sum_stat(&dst->lat_stat[l], &src->lat_stat[l], nr);
+		sum_stat(&dst->bw_stat[l], &src->bw_stat[l], nr);
+
+		dst->io_bytes[l] += src->io_bytes[l];
+
+		if (dst->runtime[l] < src->runtime[l])
+			dst->runtime[l] = src->runtime[l];
+	}
+
+	dst->usr_time += src->usr_time;
+	dst->sys_time += src->sys_time;
+	dst->ctx += src->ctx;
+	dst->majf += src->majf;
+	dst->minf += src->minf;
+
+	for (k = 0; k < FIO_IO_U_MAP_NR; k++)
+		dst->io_u_map[k] += src->io_u_map[k];
+	for (k = 0; k < FIO_IO_U_MAP_NR; k++)
+		dst->io_u_submit[k] += src->io_u_submit[k];
+	for (k = 0; k < FIO_IO_U_MAP_NR; k++)
+		dst->io_u_complete[k] += src->io_u_complete[k];
+	for (k = 0; k < FIO_IO_U_LAT_U_NR; k++)
+		dst->io_u_lat_u[k] += src->io_u_lat_u[k];
+	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++)
+		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
+
+	for (k = 0; k <= 2; k++) {
+		dst->total_io_u[k] += src->total_io_u[k];
+		dst->short_io_u[k] += src->short_io_u[k];
+	}
+
+	for (k = 0; k <= DDIR_WRITE; k++) {
+		int m;
+		for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
+			dst->io_u_plat[k][m] += src->io_u_plat[k][m];
+	}
+
+	dst->total_run_time += src->total_run_time;
+	dst->total_submit += src->total_submit;
+	dst->total_complete += src->total_complete;
+}
+
+void init_group_run_stat(struct group_run_stats *gs)
+{
+	memset(gs, 0, sizeof(*gs));
+	gs->min_bw[0] = gs->min_run[0] = ~0UL;
+	gs->min_bw[1] = gs->min_run[1] = ~0UL;
+}
+
+void init_thread_stat(struct thread_stat *ts)
+{
+	int j;
+
+	memset(ts, 0, sizeof(*ts));
+
+	for (j = 0; j <= DDIR_WRITE; j++) {
+		ts->lat_stat[j].min_val = -1UL;
+		ts->clat_stat[j].min_val = -1UL;
+		ts->slat_stat[j].min_val = -1UL;
+		ts->bw_stat[j].min_val = -1UL;
+	}
+	ts->groupid = -1;
 }
 
 void show_run_stats(void)
@@ -654,18 +836,13 @@ void show_run_stats(void)
 	struct group_run_stats *runstats, *rs;
 	struct thread_data *td;
 	struct thread_stat *threadstats, *ts;
-	int i, j, k, l, nr_ts, last_ts, idx;
+	int i, j, nr_ts, last_ts, idx;
 	int kb_base_warned = 0;
 
 	runstats = malloc(sizeof(struct group_run_stats) * (groupid + 1));
 
-	for (i = 0; i < groupid + 1; i++) {
-		rs = &runstats[i];
-
-		memset(rs, 0, sizeof(*rs));
-		rs->min_bw[0] = rs->min_run[0] = ~0UL;
-		rs->min_bw[1] = rs->min_run[1] = ~0UL;
-	}
+	for (i = 0; i < groupid + 1; i++)
+		init_group_run_stat(&runstats[i]);
 
 	/*
 	 * find out how many threads stats we need. if group reporting isn't
@@ -687,18 +864,8 @@ void show_run_stats(void)
 
 	threadstats = malloc(nr_ts * sizeof(struct thread_stat));
 
-	for (i = 0; i < nr_ts; i++) {
-		ts = &threadstats[i];
-
-		memset(ts, 0, sizeof(*ts));
-		for (j = 0; j <= DDIR_WRITE; j++) {
-			ts->lat_stat[j].min_val = -1UL;
-			ts->clat_stat[j].min_val = -1UL;
-			ts->slat_stat[j].min_val = -1UL;
-			ts->bw_stat[j].min_val = -1UL;
-		}
-		ts->groupid = -1;
-	}
+	for (i = 0; i < nr_ts; i++)
+		init_thread_stat(&threadstats[i]);
 
 	j = 0;
 	last_ts = -1;
@@ -716,9 +883,9 @@ void show_run_stats(void)
 
 		ts->clat_percentiles = td->o.clat_percentiles;
 		if (td->o.overwrite_plist)
-			ts->percentile_list = td->o.percentile_list;
+			memcpy(ts->percentile_list, td->o.percentile_list, sizeof(td->o.percentile_list));
 		else
-			ts->percentile_list = NULL;
+			memcpy(ts->percentile_list, def_percentile_list, sizeof(def_percentile_list));
 
 		idx++;
 		ts->members++;
@@ -727,8 +894,13 @@ void show_run_stats(void)
 			/*
 			 * These are per-group shared already
 			 */
-			ts->name = td->o.name;
-			ts->description = td->o.description;
+			strncpy(ts->name, td->o.name, FIO_JOBNAME_SIZE);
+			if (td->o.description)
+				strncpy(ts->description, td->o.description,
+						FIO_JOBNAME_SIZE);
+			else
+				memset(ts->description, 0, FIO_JOBNAME_SIZE);
+
 			ts->groupid = td->groupid;
 
 			/*
@@ -750,58 +922,14 @@ void show_run_stats(void)
 			if (!td->error && td->o.continue_on_error &&
 			    td->first_error) {
 				ts->error = td->first_error;
-				ts->verror = td->verror;
+				strcpy(ts->verror, td->verror);
 			} else  if (td->error) {
 				ts->error = td->error;
-				ts->verror = td->verror;
+				strcpy(ts->verror, td->verror);
 			}
 		}
 
-		for (l = 0; l <= DDIR_WRITE; l++) {
-			sum_stat(&ts->clat_stat[l], &td->ts.clat_stat[l], idx);
-			sum_stat(&ts->slat_stat[l], &td->ts.slat_stat[l], idx);
-			sum_stat(&ts->lat_stat[l], &td->ts.lat_stat[l], idx);
-			sum_stat(&ts->bw_stat[l], &td->ts.bw_stat[l], idx);
-
-			ts->stat_io_bytes[l] += td->ts.stat_io_bytes[l];
-			ts->io_bytes[l] += td->ts.io_bytes[l];
-
-			if (ts->runtime[l] < td->ts.runtime[l])
-				ts->runtime[l] = td->ts.runtime[l];
-		}
-
-		ts->usr_time += td->ts.usr_time;
-		ts->sys_time += td->ts.sys_time;
-		ts->ctx += td->ts.ctx;
-		ts->majf += td->ts.majf;
-		ts->minf += td->ts.minf;
-
-		for (k = 0; k < FIO_IO_U_MAP_NR; k++)
-			ts->io_u_map[k] += td->ts.io_u_map[k];
-		for (k = 0; k < FIO_IO_U_MAP_NR; k++)
-			ts->io_u_submit[k] += td->ts.io_u_submit[k];
-		for (k = 0; k < FIO_IO_U_MAP_NR; k++)
-			ts->io_u_complete[k] += td->ts.io_u_complete[k];
-		for (k = 0; k < FIO_IO_U_LAT_U_NR; k++)
-			ts->io_u_lat_u[k] += td->ts.io_u_lat_u[k];
-		for (k = 0; k < FIO_IO_U_LAT_M_NR; k++)
-			ts->io_u_lat_m[k] += td->ts.io_u_lat_m[k];
-
-
-		for (k = 0; k <= 2; k++) {
-			ts->total_io_u[k] += td->ts.total_io_u[k];
-			ts->short_io_u[k] += td->ts.short_io_u[k];
-		}
-
-		for (k = 0; k <= DDIR_WRITE; k++) {
-			int m;
-			for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
-				ts->io_u_plat[k][m] += td->ts.io_u_plat[k][m];
-		}
-
-		ts->total_run_time += td->ts.total_run_time;
-		ts->total_submit += td->ts.total_submit;
-		ts->total_complete += td->ts.total_complete;
+		sum_thread_stats(ts, &td->ts, idx);
 	}
 
 	for (i = 0; i < nr_ts; i++) {
@@ -858,17 +986,31 @@ void show_run_stats(void)
 		ts = &threadstats[i];
 		rs = &runstats[ts->groupid];
 
-		if (terse_output)
+		if (is_backend)
+			fio_server_send_ts(ts, rs);
+		else if (terse_output)
 			show_thread_status_terse(ts, rs);
 		else
 			show_thread_status(ts, rs);
 	}
 
 	if (!terse_output) {
-		for (i = 0; i < groupid + 1; i++)
-			show_group_stats(&runstats[i], i);
+		for (i = 0; i < groupid + 1; i++) {
+			rs = &runstats[i];
+
+			rs->groupid = i;
+			if (is_backend)
+				fio_server_send_gs(rs);
+			else
+				show_group_stats(rs);
+		}
+
+		if (is_backend)
+			fio_server_send_du();
+		else
+			show_disk_util(0);
 
-		show_disk_util();
+		free_disk_util();
 	}
 
 	free(runstats);
@@ -885,10 +1027,10 @@ static inline void add_stat_sample(struct io_stat *is, unsigned long data)
 	if (data < is->min_val)
 		is->min_val = data;
 
-	delta = val - is->mean;
+	delta = val - is->mean.u.f;
 	if (delta) {
-		is->mean += delta / (is->samples + 1.0);
-		is->S += delta * (val - is->mean);
+		is->mean.u.f += delta / (is->samples + 1.0);
+		is->S.u.f += delta * (val - is->mean.u.f);
 	}
 
 	is->samples++;
@@ -954,8 +1096,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->clat_stat[ddir], usec);
 
-	if (ts->clat_log)
-		add_log_sample(td, ts->clat_log, usec, ddir, bs);
+	if (td->clat_log)
+		add_log_sample(td, td->clat_log, usec, ddir, bs);
 
 	if (ts->clat_percentiles)
 		add_clat_percentile_sample(ts, usec, ddir);
@@ -971,8 +1113,8 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->slat_stat[ddir], usec);
 
-	if (ts->slat_log)
-		add_log_sample(td, ts->slat_log, usec, ddir, bs);
+	if (td->slat_log)
+		add_log_sample(td, td->slat_log, usec, ddir, bs);
 }
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
@@ -985,8 +1127,8 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->lat_stat[ddir], usec);
 
-	if (ts->lat_log)
-		add_log_sample(td, ts->lat_log, usec, ddir, bs);
+	if (td->lat_log)
+		add_log_sample(td, td->lat_log, usec, ddir, bs);
 }
 
 void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
@@ -998,17 +1140,43 @@ void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
 	if (!ddir_rw(ddir))
 		return;
 
-	spent = mtime_since(&ts->stat_sample_time[ddir], t);
+	spent = mtime_since(&td->bw_sample_time, t);
 	if (spent < td->o.bw_avg_time)
 		return;
 
-	rate = (td->this_io_bytes[ddir] - ts->stat_io_bytes[ddir]) *
+	rate = (td->this_io_bytes[ddir] - td->stat_io_bytes[ddir]) *
 			1000 / spent / 1024;
 	add_stat_sample(&ts->bw_stat[ddir], rate);
 
-	if (ts->bw_log)
-		add_log_sample(td, ts->bw_log, rate, ddir, bs);
+	if (td->bw_log)
+		add_log_sample(td, td->bw_log, rate, ddir, bs);
+
+	fio_gettime(&td->bw_sample_time, NULL);
+	td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
+}
+
+void add_iops_sample(struct thread_data *td, enum fio_ddir ddir,
+		     struct timeval *t)
+{
+	struct thread_stat *ts = &td->ts;
+	unsigned long spent, iops;
+
+	if (!ddir_rw(ddir))
+		return;
+
+	spent = mtime_since(&td->iops_sample_time, t);
+	if (spent < td->o.iops_avg_time)
+		return;
+
+	iops = ((td->this_io_blocks[ddir] - td->stat_io_blocks[ddir]) * 1000) / spent;
+
+	add_stat_sample(&ts->iops_stat[ddir], iops);
+
+	if (td->iops_log) {
+		assert(iops);
+		add_log_sample(td, td->iops_log, iops, ddir, 0);
+	}
 
-	fio_gettime(&ts->stat_sample_time[ddir], NULL);
-	ts->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
+	fio_gettime(&td->iops_sample_time, NULL);
+	td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
 }
diff --git a/stat.h b/stat.h
new file mode 100644
index 0000000..3115539
--- /dev/null
+++ b/stat.h
@@ -0,0 +1,201 @@
+#ifndef FIO_STAT_H
+#define FIO_STAT_H
+
+struct group_run_stats {
+	uint64_t max_run[2], min_run[2];
+	uint64_t max_bw[2], min_bw[2];
+	uint64_t io_kb[2];
+	uint64_t agg[2];
+	uint32_t kb_base;
+	uint32_t groupid;
+};
+
+/*
+ * How many depth levels to log
+ */
+#define FIO_IO_U_MAP_NR	7
+#define FIO_IO_U_LAT_U_NR 10
+#define FIO_IO_U_LAT_M_NR 12
+
+/*
+ * Aggregate clat samples to report percentile(s) of them.
+ *
+ * EXECUTIVE SUMMARY
+ *
+ * FIO_IO_U_PLAT_BITS determines the maximum statistical error on the
+ * value of resulting percentiles. The error will be approximately
+ * 1/2^(FIO_IO_U_PLAT_BITS+1) of the value.
+ *
+ * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the maximum
+ * range being tracked for latency samples. The maximum value tracked
+ * accurately will be 2^(GROUP_NR + PLAT_BITS -1) microseconds.
+ *
+ * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the memory
+ * requirement of storing those aggregate counts. The memory used will
+ * be (FIO_IO_U_PLAT_GROUP_NR * 2^FIO_IO_U_PLAT_BITS) * sizeof(int)
+ * bytes.
+ *
+ * FIO_IO_U_PLAT_NR is the total number of buckets.
+ *
+ * DETAILS
+ *
+ * Suppose the clat varies from 0 to 999 (usec), the straightforward
+ * method is to keep an array of (999 + 1) buckets, in which a counter
+ * keeps the count of samples which fall in the bucket, e.g.,
+ * {[0],[1],...,[999]}. However this consumes a huge amount of space,
+ * and can be avoided if an approximation is acceptable.
+ *
+ * One such method is to let the range of the bucket to be greater
+ * than one. This method has low accuracy when the value is small. For
+ * example, let the buckets be {[0,99],[100,199],...,[900,999]}, and
+ * the represented value of each bucket be the mean of the range. Then
+ * a value 0 has an round-off error of 49.5. To improve on this, we
+ * use buckets with non-uniform ranges, while bounding the error of
+ * each bucket within a ratio of the sample value. A simple example
+ * would be when error_bound = 0.005, buckets are {
+ * {[0],[1],...,[99]}, {[100,101],[102,103],...,[198,199]},..,
+ * {[900,909],[910,919]...}  }. The total range is partitioned into
+ * groups with different ranges, then buckets with uniform ranges. An
+ * upper bound of the error is (range_of_bucket/2)/value_of_bucket
+ *
+ * For better efficiency, we implement this using base two. We group
+ * samples by their Most Significant Bit (MSB), extract the next M bit
+ * of them as an index within the group, and discard the rest of the
+ * bits.
+ *
+ * E.g., assume a sample 'x' whose MSB is bit n (starting from bit 0),
+ * and use M bit for indexing
+ *
+ *        | n |    M bits   | bit (n-M-1) ... bit 0 |
+ *
+ * Because x is at least 2^n, and bit 0 to bit (n-M-1) is at most
+ * (2^(n-M) - 1), discarding bit 0 to (n-M-1) makes the round-off
+ * error
+ *
+ *           2^(n-M)-1    2^(n-M)    1
+ *      e <= --------- <= ------- = ---
+ *             2^n          2^n     2^M
+ *
+ * Furthermore, we use "mean" of the range to represent the bucket,
+ * the error e can be lowered by half to 1 / 2^(M+1). By using M bits
+ * as the index, each group must contains 2^M buckets.
+ *
+ * E.g. Let M (FIO_IO_U_PLAT_BITS) be 6
+ *      Error bound is 1/2^(6+1) = 0.0078125 (< 1%)
+ *
+ *	Group	MSB	#discarded	range of		#buckets
+ *			error_bits	value
+ *	----------------------------------------------------------------
+ *	0*	0~5	0		[0,63]			64
+ *	1*	6	0		[64,127]		64
+ *	2	7	1		[128,255]		64
+ *	3	8	2		[256,511]		64
+ *	4	9	3		[512,1023]		64
+ *	...	...	...		[...,...]		...
+ *	18	23	17		[8838608,+inf]**	64
+ *
+ *  * Special cases: when n < (M-1) or when n == (M-1), in both cases,
+ *    the value cannot be rounded off. Use all bits of the sample as
+ *    index.
+ *
+ *  ** If a sample's MSB is greater than 23, it will be counted as 23.
+ */
+
+#define FIO_IO_U_PLAT_BITS 6
+#define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
+#define FIO_IO_U_PLAT_GROUP_NR 19
+#define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
+#define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
+					list of percentiles */
+
+#define MAX_PATTERN_SIZE	512
+#define FIO_JOBNAME_SIZE	128
+#define FIO_VERROR_SIZE		128
+
+struct thread_stat {
+	char name[FIO_JOBNAME_SIZE];
+	char verror[FIO_VERROR_SIZE];
+	uint32_t error;
+	uint32_t groupid;
+	uint32_t pid;
+	char description[FIO_JOBNAME_SIZE];
+	uint32_t members;
+
+	/*
+	 * bandwidth and latency stats
+	 */
+	struct io_stat clat_stat[2];		/* completion latency */
+	struct io_stat slat_stat[2];		/* submission latency */
+	struct io_stat lat_stat[2];		/* total latency */
+	struct io_stat bw_stat[2];		/* bandwidth stats */
+	struct io_stat iops_stat[2];		/* IOPS stats */
+
+	/*
+	 * fio system usage accounting
+	 */
+	uint64_t usr_time;
+	uint64_t sys_time;
+	uint64_t ctx;
+	uint64_t minf, majf;
+
+	/*
+	 * IO depth and latency stats
+	 */
+	uint64_t clat_percentiles;
+	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
+
+	uint32_t io_u_map[FIO_IO_U_MAP_NR];
+	uint32_t io_u_submit[FIO_IO_U_MAP_NR];
+	uint32_t io_u_complete[FIO_IO_U_MAP_NR];
+	uint32_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
+	uint32_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
+	uint32_t io_u_plat[2][FIO_IO_U_PLAT_NR];
+	uint64_t total_io_u[3];
+	uint64_t short_io_u[3];
+	uint64_t total_submit;
+	uint64_t total_complete;
+
+	uint64_t io_bytes[2];
+	uint64_t runtime[2];
+	uint64_t total_run_time;
+
+	/*
+	 * IO Error related stats
+	 */
+	uint16_t continue_on_error;
+	uint64_t total_err_count;
+	uint32_t first_error;
+
+	uint32_t kb_base;
+};
+
+struct jobs_eta {
+	uint32_t nr_running;
+	uint32_t nr_ramp;
+	uint32_t nr_pending;
+	uint32_t files_open;
+	uint32_t m_rate, t_rate;
+	uint32_t m_iops, t_iops;
+	uint32_t rate[2];
+	uint32_t iops[2];
+	uint64_t elapsed_sec;
+	uint64_t eta_sec;
+
+	/*
+	 * Network 'copy' of run_str[]
+	 */
+	uint32_t nr_threads;
+	uint8_t run_str[0];
+};
+
+extern void show_thread_status(struct thread_stat *ts, struct group_run_stats *rs);
+extern void show_group_stats(struct group_run_stats *rs);
+extern int calc_thread_status(struct jobs_eta *je, int force);
+extern void display_thread_status(struct jobs_eta *je);
+extern void show_run_stats(void);
+extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr);
+extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src);
+extern void init_thread_stat(struct thread_stat *ts);
+extern void init_group_run_stat(struct group_run_stats *gs);
+
+#endif
diff --git a/t/ieee754.c b/t/ieee754.c
new file mode 100644
index 0000000..afc25f3
--- /dev/null
+++ b/t/ieee754.c
@@ -0,0 +1,21 @@
+#include <stdio.h>
+#include "../ieee754.h"
+
+static double values[] = { -17.23, 17.23, 123.4567, 98765.4321, 0.0 };
+
+int main(int argc, char *argv[])
+{
+	uint64_t i;
+	double f;
+	int j;
+
+	j = 0;
+	do {
+		i = fio_double_to_uint64(values[j]);
+		f = fio_uint64_to_double(i);
+		printf("%f -> %f\n", values[j], f);
+		j++;
+	} while (values[j] != 0.0);
+
+	return 0;
+}
diff --git a/t/log.c b/t/log.c
new file mode 100644
index 0000000..7f1de27
--- /dev/null
+++ b/t/log.c
@@ -0,0 +1,15 @@
+#include <stdio.h>
+#include <stdarg.h>
+
+int log_err(const char *format, ...)
+{
+	char buffer[1024];
+	va_list args;
+	size_t len;
+
+	va_start(args, format);
+	len = vsnprintf(buffer, sizeof(buffer), format, args);
+	va_end(args);
+
+	return fwrite(buffer, len, 1, stderr);
+}
