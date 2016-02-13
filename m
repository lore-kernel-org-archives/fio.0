Return-Path: <fio-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:39322 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbcBMNAi (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 13 Feb 2016 08:00:38 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aUZnv-00041Q-Ck
	for fio@vger.kernel.org; Sat, 13 Feb 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160213130002.3F11D2C015D@kernel.dk>
Date: Sat, 13 Feb 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8a768c2e725d6a527b904570949f6099c3f1434a:

  server: don't make SO_REUSEPORT errors fatal (2016-02-10 08:32:13 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e0ee7a8ba4e6badc6cb73814315aa11c15d86ef9:

  fio.1: man page fixes (2016-02-12 15:00:39 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Update documentation
      fio.1: man page fixes

 HOWTO |   3 +-
 fio.1 | 208 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 200 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 6d80360..5e765d4 100644
--- a/HOWTO
+++ b/HOWTO
@@ -10,6 +10,7 @@ Table of contents
 7. Terse output
 8. Trace file format
 9. CPU idleness profiling
+10. Verification and triggers
 
 1.0 Overview and history
 ------------------------
@@ -2219,7 +2220,7 @@ localbox$ fio --client=server --trigger-file=/tmp/my-trigger --trigger="ipmi-reb
 For this case, fio would wait for the server to send us the write state,
 then execute 'ipmi-reboot server' when that happened.
 
-10.1 Loading verify state
+10.2 Loading verify state
 -------------------------
 To load store write state, read verification job file must contain
 the verify_state_load option. If that is set, fio will load the previously
diff --git a/fio.1 b/fio.1
index 246bcd2..690c8f4 100644
--- a/fio.1
+++ b/fio.1
@@ -1988,6 +1988,194 @@ Error Info (dependent on continue_on_error, default off):
 .P
 .B text description (if provided in config - appears on newline)
 .RE
+.SH TRACE FILE FORMAT
+There are two trace file format that you can encounter. The older (v1) format
+is unsupported since version 1.20-rc3 (March 2008). It will still be described
+below in case that you get an old trace and want to understand it.
+
+In any case the trace is a simple text file with a single action per line.
+
+.P
+.B Trace file format v1
+.RS
+Each line represents a single io action in the following format:
+
+rw, offset, length
+
+where rw=0/1 for read/write, and the offset and length entries being in bytes.
+
+This format is not supported in Fio versions => 1.20-rc3.
+
+.RE
+.P
+.B Trace file format v2
+.RS
+The second version of the trace file format was added in Fio version 1.17.
+It allows to access more then one file per trace and has a bigger set of
+possible file actions.
+
+The first line of the trace file has to be:
+
+\fBfio version 2 iolog\fR
+
+Following this can be lines in two different formats, which are described below.
+The file management format:
+
+\fBfilename action\fR
+
+The filename is given as an absolute path. The action can be one of these:
+
+.P
+.PD 0
+.RS
+.TP
+.B add
+Add the given filename to the trace
+.TP
+.B open
+Open the file with the given filename. The filename has to have been previously
+added with the \fBadd\fR action.
+.TP
+.B close
+Close the file with the given filename. The file must have previously been
+opened.
+.RE
+.PD
+.P
+
+The file io action format:
+
+\fBfilename action offset length\fR
+
+The filename is given as an absolute path, and has to have been added and opened
+before it can be used with this format. The offset and length are given in
+bytes. The action can be one of these:
+
+.P
+.PD 0
+.RS
+.TP
+.B wait
+Wait for 'offset' microseconds. Everything below 100 is discarded.  The time is
+relative to the previous wait statement.
+.TP
+.B read
+Read \fBlength\fR bytes beginning from \fBoffset\fR
+.TP
+.B write
+Write \fBlength\fR bytes beginning from \fBoffset\fR
+.TP
+.B sync
+fsync() the file
+.TP
+.B datasync
+fdatasync() the file
+.TP
+.B trim
+trim the given file from the given \fBoffset\fR for \fBlength\fR bytes
+.RE
+.PD
+.P
+
+.SH CPU IDLENESS PROFILING
+In some cases, we want to understand CPU overhead in a test. For example,
+we test patches for the specific goodness of whether they reduce CPU usage.
+fio implements a balloon approach to create a thread per CPU that runs at
+idle priority, meaning that it only runs when nobody else needs the cpu.
+By measuring the amount of work completed by the thread, idleness of each
+CPU can be derived accordingly.
+
+An unit work is defined as touching a full page of unsigned characters. Mean
+and standard deviation of time to complete an unit work is reported in "unit
+work" section. Options can be chosen to report detailed percpu idleness or
+overall system idleness by aggregating percpu stats.
+
+.SH VERIFICATION AND TRIGGERS
+Fio is usually run in one of two ways, when data verification is done. The
+first is a normal write job of some sort with verify enabled. When the
+write phase has completed, fio switches to reads and verifies everything
+it wrote. The second model is running just the write phase, and then later
+on running the same job (but with reads instead of writes) to repeat the
+same IO patterns and verify the contents. Both of these methods depend
+on the write phase being completed, as fio otherwise has no idea how much
+data was written.
+
+With verification triggers, fio supports dumping the current write state
+to local files. Then a subsequent read verify workload can load this state
+and know exactly where to stop. This is useful for testing cases where
+power is cut to a server in a managed fashion, for instance.
+
+A verification trigger consists of two things:
+
+.RS
+Storing the write state of each job
+.LP
+Executing a trigger command
+.RE
+
+The write state is relatively small, on the order of hundreds of bytes
+to single kilobytes. It contains information on the number of completions
+done, the last X completions, etc.
+
+A trigger is invoked either through creation (\fBtouch\fR) of a specified
+file in the system, or through a timeout setting. If fio is run with
+\fB\-\-trigger\-file=/tmp/trigger-file\fR, then it will continually check for
+the existence of /tmp/trigger-file. When it sees this file, it will
+fire off the trigger (thus saving state, and executing the trigger
+command).
+
+For client/server runs, there's both a local and remote trigger. If
+fio is running as a server backend, it will send the job states back
+to the client for safe storage, then execute the remote trigger, if
+specified. If a local trigger is specified, the server will still send
+back the write state, but the client will then execute the trigger.
+
+.RE
+.P
+.B Verification trigger example
+.RS
+
+Lets say we want to run a powercut test on the remote machine 'server'.
+Our write workload is in write-test.fio. We want to cut power to 'server'
+at some point during the run, and we'll run this test from the safety
+or our local machine, 'localbox'. On the server, we'll start the fio
+backend normally:
+
+server# \fBfio \-\-server\fR
+
+and on the client, we'll fire off the workload:
+
+localbox$ \fBfio \-\-client=server \-\-trigger\-file=/tmp/my\-trigger \-\-trigger-remote="bash \-c "echo b > /proc/sysrq-triger""\fR
+
+We set \fB/tmp/my-trigger\fR as the trigger file, and we tell fio to execute
+
+\fBecho b > /proc/sysrq-trigger\fR
+
+on the server once it has received the trigger and sent us the write
+state. This will work, but it's not \fIreally\fR cutting power to the server,
+it's merely abruptly rebooting it. If we have a remote way of cutting
+power to the server through IPMI or similar, we could do that through
+a local trigger command instead. Lets assume we have a script that does
+IPMI reboot of a given hostname, ipmi-reboot. On localbox, we could
+then have run fio with a local trigger instead:
+
+localbox$ \fBfio \-\-client=server \-\-trigger\-file=/tmp/my\-trigger \-\-trigger="ipmi-reboot server"\fR
+
+For this case, fio would wait for the server to send us the write state,
+then execute 'ipmi-reboot server' when that happened.
+
+.RE
+.P
+.B Loading verify state
+.RS
+To load store write state, read verification job file must contain
+the verify_state_load option. If that is set, fio will load the previously
+stored state. For a local fio run this is done by loading the files directly,
+and on a client/server run, the server backend will ask the client to send
+the files over and load them from there.
+
+.RE
+
 .SH CLIENT / SERVER
 Normally you would run fio as a stand-alone application on the machine
 where the IO workload should be generated. However, it is also possible to
@@ -2005,34 +2193,34 @@ for TCP/IP v4, 'ip6' for TCP/IP v6, or 'sock' for a local unix domain
 socket. 'hostname' is either a hostname or IP address, and 'port' is the port to
 listen to (only valid for TCP/IP, not a local socket). Some examples:
 
-1) fio \-\-server
+1) \fBfio \-\-server\fR
 
    Start a fio server, listening on all interfaces on the default port (8765).
 
-2) fio \-\-server=ip:hostname,4444
+2) \fBfio \-\-server=ip:hostname,4444\fR
 
    Start a fio server, listening on IP belonging to hostname and on port 4444.
 
-3) fio \-\-server=ip6:::1,4444
+3) \fBfio \-\-server=ip6:::1,4444\fR
 
    Start a fio server, listening on IPv6 localhost ::1 and on port 4444.
 
-4) fio \-\-server=,4444
+4) \fBfio \-\-server=,4444\fR
 
    Start a fio server, listening on all interfaces on port 4444.
 
-5) fio \-\-server=1.2.3.4
+5) \fBfio \-\-server=1.2.3.4\fR
 
    Start a fio server, listening on IP 1.2.3.4 on the default port.
 
-6) fio \-\-server=sock:/tmp/fio.sock
+6) \fBfio \-\-server=sock:/tmp/fio.sock\fR
 
    Start a fio server, listening on the local socket /tmp/fio.sock.
 
 When a server is running, you can connect to it from a client. The client
 is run with:
 
-fio \-\-local-args \-\-client=server \-\-remote-args <job file(s)>
+\fBfio \-\-local-args \-\-client=server \-\-remote-args <job file(s)>\fR
 
 where \-\-local-args are arguments that are local to the client where it is
 running, 'server' is the connect string, and \-\-remote-args and <job file(s)>
@@ -2040,12 +2228,12 @@ are sent to the server. The 'server' string follows the same format as it
 does on the server side, to allow IP/hostname/socket and port strings.
 You can connect to multiple clients as well, to do that you could run:
 
-fio \-\-client=server2 \-\-client=server2 <job file(s)>
+\fBfio \-\-client=server2 \-\-client=server2 <job file(s)>\fR
 
 If the job file is located on the fio server, then you can tell the server
 to load a local file as well. This is done by using \-\-remote-config:
 
-fio \-\-client=server \-\-remote-config /path/to/file.fio
+\fBfio \-\-client=server \-\-remote-config /path/to/file.fio\fR
 
 Then fio will open this local (to the server) job file instead
 of being passed one from the client.
@@ -2060,7 +2248,7 @@ host2.your.dns.domain
 
 The fio command would then be:
 
-fio \-\-client=host.list <job file>
+\fBfio \-\-client=host.list <job file>\fR
 
 In this mode, you cannot input server-specific parameters or job files, and all
 servers receive the same job file.
