Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403896AbfHBRD4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Aug 2019 13:03:56 -0400
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH] nbd: Document the NBD-specific uri parameter.
Date: Fri,  2 Aug 2019 18:03:52 +0100
Message-Id: <20190802170352.17682-2-rjones@redhat.com>
In-Reply-To: <20190802170352.17682-1-rjones@redhat.com>
References: <20190802170352.17682-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: eblake@redhat.com, axboe@kernel.dk

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 HOWTO | 11 ++++++++++-
 fio.1 | 16 ++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 955ea43c..41b959d1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1999,7 +1999,7 @@ I/O engine
 		**libiscsi**
 			Read and write iscsi lun with libiscsi.
 		**nbd**
-			Synchronous read and write a Network Block Device (NBD).
+			Read and write a Network Block Device (NBD).
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -2301,6 +2301,15 @@ with the caveat that when used on the command line, they must come after the
 	turns on verbose logging from libcurl, 2 additionally enables
 	HTTP IO tracing. Default is **0**
 
+.. option:: uri=str : [nbd]
+
+	Specify the NBD URI of the server to test.  The string
+	is a standard NBD URI
+	(see https://github.com/NetworkBlockDevice/nbd/tree/master/doc).
+	Example URIs: nbd://localhost:10809
+	nbd+unix:///?socket=/tmp/socket
+	nbds://tlshost/exportname
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/fio.1 b/fio.1
index 30b17f02..97371d77 100644
--- a/fio.1
+++ b/fio.1
@@ -2022,6 +2022,22 @@ blocksize=8k will write 16 sectors with each command. fio will still
 generate 8k of data for each command butonly the first 512 bytes will
 be used and transferred to the device. The writefua option is ignored
 with this selection.
+.RE
+.RE
+.TP
+.BI (nbd)uri \fR=\fPstr
+Specify the NBD URI of the server to test.
+The string is a standard NBD URI (see
+\fIhttps://github.com/NetworkBlockDevice/nbd/tree/master/doc\fR).
+Example URIs:
+.RS
+.RS
+.TP
+\fInbd://localhost:10809\fR
+.TP
+\fInbd+unix:///?socket=/tmp/socket\fR
+.TP
+\fInbds://tlshost/exportname\fR
 
 .SS "I/O depth"
 .TP
-- 
2.22.0


