Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdGZMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Jul 2017 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1daKyz-0003vB-Pu
        for fio@vger.kernel.org; Wed, 26 Jul 2017 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170726120001.946E32C1196@kernel.dk>
Date: Wed, 26 Jul 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 800334db17a22029553488b41a5ede8af909c66d:

  Correctly detect whether ioengine_load can exit early (2017-07-19 12:27:57 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e1933299ed9f1525e010e0489f0185c063d6d129:

  drop logging when blkdev invalidation failed on unsupported platforms (2017-07-25 13:56:21 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (4):
      HOWTO: fix "should be to to"
      man: fix broken ioengine specific option format
      HOWTO: add missing [netsplice] for ioengine specific options
      drop logging when blkdev invalidation failed on unsupported platforms

 HOWTO       | 10 +++++-----
 filesetup.c |  2 --
 fio.1       | 12 ++++++------
 3 files changed, 11 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e544634..2fa8fc2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1255,7 +1255,7 @@ I/O type
 
 	* 60% of accesses should be to the first 10%
 	* 30% of accesses should be to the next 20%
-	* 8% of accesses should be to to the next 30%
+	* 8% of accesses should be to the next 30%
 	* 2% of accesses should be to the next 40%
 
 	we can define that through zoning of the random accesses. For the above
@@ -1889,13 +1889,13 @@ caveat that when used on the command line, they must come after the
 	hostname if the job is a TCP listener or UDP reader. For unix sockets, the
 	normal filename option should be used and the port is invalid.
 
-.. option:: listen : [net]
+.. option:: listen : [netsplice] [net]
 
 	For TCP network connections, tell fio to listen for incoming connections
 	rather than initiating an outgoing connection. The :option:`hostname` must
 	be omitted if this option is used.
 
-.. option:: pingpong : [net]
+.. option:: pingpong : [netsplice] [net]
 
 	Normally a network writer will just continue writing data, and a network
 	reader will just consume packages. If ``pingpong=1`` is set, a writer will
@@ -1907,11 +1907,11 @@ caveat that when used on the command line, they must come after the
 	``pingpong=1`` should only be set for a single reader when multiple readers
 	are listening to the same address.
 
-.. option:: window_size : [net]
+.. option:: window_size : [netsplice] [net]
 
 	Set the desired socket buffer size for the connection.
 
-.. option:: mss : [net]
+.. option:: mss : [netsplice] [net]
 
 	Set the TCP maximum segment size (TCP_MAXSEG).
 
diff --git a/filesetup.c b/filesetup.c
index 38ad9ed..3b2ebd9 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -528,8 +528,6 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		}
 		if (ret < 0)
 			errval = errno;
-		else if (ret) /* probably not supported */
-			errval = ret;
 	} else if (f->filetype == FIO_TYPE_CHAR ||
 		   f->filetype == FIO_TYPE_PIPE) {
 		dprint(FD_IO, "invalidate not supported %s\n", f->file_name);
diff --git a/fio.1 b/fio.1
index 7fe96e0..768b209 100644
--- a/fio.1
+++ b/fio.1
@@ -1143,7 +1143,7 @@ given a criteria of:
 30% of accesses should be to the next 20%
 .RE
 .RS
-8% of accesses should be to to the next 30%
+8% of accesses should be to the next 30%
 .RE
 .RS
 2% of accesses should be to the next 40%
@@ -2069,7 +2069,7 @@ For TCP network connections, tell fio to listen for incoming
 connections rather than initiating an outgoing connection. The
 hostname must be omitted if this option is used.
 .TP
-.BI (net, pingpong) \fR=\fPbool
+.BI (net,netsplice)pingpong \fR=\fPbool
 Normally a network writer will just continue writing data, and a network reader
 will just consume packets. If pingpong=1 is set, a writer will send its normal
 payload to the reader, then wait for the reader to send the same payload back.
@@ -2079,16 +2079,16 @@ completion latency measures how long it took for the other end to receive and
 send back. For UDP multicast traffic pingpong=1 should only be set for a single
 reader when multiple readers are listening to the same address.
 .TP
-.BI (net, window_size) \fR=\fPint
+.BI (net,netsplice)window_size \fR=\fPint
 Set the desired socket buffer size for the connection.
 .TP
-.BI (net, mss) \fR=\fPint
+.BI (net,netsplice)mss \fR=\fPint
 Set the TCP maximum segment size (TCP_MAXSEG).
 .TP
-.BI (e4defrag,donorname) \fR=\fPstr
+.BI (e4defrag)donorname \fR=\fPstr
 File will be used as a block donor (swap extents between files)
 .TP
-.BI (e4defrag,inplace) \fR=\fPint
+.BI (e4defrag)inplace \fR=\fPint
 Configure donor file block allocation strategy
 .RS
 .BI 0(default) :
