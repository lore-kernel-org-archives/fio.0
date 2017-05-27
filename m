Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56066 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756051AbdE0MAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 May 2017 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dEaO4-00074H-13
        for fio@vger.kernel.org; Sat, 27 May 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170527120002.1A0942C246B@kernel.dk>
Date: Sat, 27 May 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8dd0eca30caeda7f62df4d09748286592956fcc5:

  lib/output_buffer: harden buf_output_free() and kill buf_output_clear() (2017-05-24 10:21:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e5123c4ad9b0626e25d9b243f1111fa89082308b:

  manpage: update URL links to HOWTO/README (2017-05-26 13:29:00 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (3):
      verify: add missing free(ptr);
      verify: mention some default option values
      manpage: update URL links to HOWTO/README

 HOWTO    | 3 ++-
 fio.1    | 6 +++---
 verify.c | 1 +
 3 files changed, 6 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a899b90..6c9e9a4 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2467,6 +2467,7 @@ Verification
 	contents to one or more separate threads. If using this offload option, even
 	sync I/O engines can benefit from using an :option:`iodepth` setting higher
 	than 1, as it allows them to have I/O in flight while verifies are running.
+	Defaults to 0 async threads, i.e. verification is not asynchronous.
 
 .. option:: verify_async_cpus=str
 
@@ -2503,7 +2504,7 @@ Verification
 
 	<type> is "local" for a local run, "sock" for a client/server socket
 	connection, and "ip" (192.168.0.1, for instance) for a networked
-	client/server connection.
+	client/server connection. Defaults to true.
 
 .. option:: verify_state_load=bool
 
diff --git a/fio.1 b/fio.1
index 301a708..9956867 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "March 2017" "User Manual"
+.TH fio 1 "May 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -2594,7 +2594,7 @@ Sample jobfiles are available in the \fBexamples\fR directory.
 .br
 These are typically located under /usr/share/doc/fio.
 
-\fBHOWTO\fR:  http://git.kernel.dk/?p=fio.git;a=blob_plain;f=HOWTO
+\fBHOWTO\fR:  http://git.kernel.dk/cgit/fio/plain/HOWTO
 .br
-\fBREADME\fR: http://git.kernel.dk/?p=fio.git;a=blob_plain;f=README
+\fBREADME\fR: http://git.kernel.dk/cgit/fio/plain/README
 .br
diff --git a/verify.c b/verify.c
index cadfe9c..1c39fa2 100644
--- a/verify.c
+++ b/verify.c
@@ -271,6 +271,7 @@ static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 	fd = open(fname, O_CREAT | O_TRUNC | O_WRONLY, 0644);
 	if (fd < 0) {
 		perror("open verify buf file");
+		free(ptr);
 		return;
 	}
 
