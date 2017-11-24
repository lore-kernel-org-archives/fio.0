Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53023 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753469AbdKXNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Nov 2017 08:00:08 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eIDaS-0008BV-1t
        for fio@vger.kernel.org; Fri, 24 Nov 2017 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171124130002.403BF2C011A@kernel.dk>
Date: Fri, 24 Nov 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b9c153b9023c3de65f01aeac4d1e993986a7107e:

  Merge branch 'cleanup' of https://github.com/sitsofe/fio (2017-11-22 19:58:21 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 609ac152d5a7d0bc5c645f8c50bf2415e7b2d4d3:

  docs: Add documention for RDMA ioengine options. (2017-11-23 22:08:48 -0700)

----------------------------------------------------------------
Stephen Bates (1):
      docs: Add documention for RDMA ioengine options.

 HOWTO | 29 +++++++++++++++++++++++++----
 fio.1 | 30 +++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4d3a8c8..164ba2b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1751,7 +1751,8 @@ I/O engine
 		**rdma**
 			The RDMA I/O engine supports both RDMA memory semantics
 			(RDMA_WRITE/RDMA_READ) and channel semantics (Send/Recv) for the
-			InfiniBand, RoCE and iWARP protocols.
+			InfiniBand, RoCE and iWARP protocols. This engine defines engine
+			specific options.
 
 		**falloc**
 			I/O engine that does regular fallocate to simulate data transfer as
@@ -1893,10 +1894,15 @@ with the caveat that when used on the command line, they must come after the
 		this will be the starting port number since fio will use a range of
 		ports.
 
-.. option:: hostname=str : [netsplice] [net]
+   [rdma]
+
+		The port to use for RDMA-CM communication. This should be the same value
+		on the client and the server side.
+
+.. option:: hostname=str : [netsplice] [net] [rdma]
 
-	The hostname or IP address to use for TCP or UDP based I/O.  If the job is
-	a TCP listener or UDP reader, the hostname is not used and must be omitted
+	The hostname or IP address to use for TCP, UDP or RDMA-CM based I/O.  If the job
+	is a TCP listener or UDP reader, the hostname is not used and must be omitted
 	unless it is a valid UDP multicast address.
 
 .. option:: interface=str : [netsplice] [net]
@@ -2002,6 +2008,21 @@ with the caveat that when used on the command line, they must come after the
 
 	The size of the chunk to use for each file.
 
+.. option:: verb=str : [rdma]
+
+	The RDMA verb to use on this side of the RDMA ioengine connection. Valid
+	values are write, read, send and recv. These correspond to the equivalent
+	RDMA verbs (e.g. write = rdma_write etc.). Note that this only needs to be
+	specified on the client side of the connection. See the examples folder.
+
+.. option:: bindname=str : [rdma]
+
+	The name to use to bind the local RDMA-CM connection to a local RDMA device.
+	This could be a hostname or an IPv4 or IPv6 address. On the server side this
+	will be passed into the rdma_bind_addr() function and on the client site it
+	will be used in the rdma_resolve_add() function. This can be useful when
+	multiple paths exist between the client and the server or in certain loopback
+	configurations.
 
 I/O depth
 ~~~~~~~~~
diff --git a/fio.1 b/fio.1
index 3224e9a..a4b0ea6 100644
--- a/fio.1
+++ b/fio.1
@@ -1525,7 +1525,8 @@ for more info on GUASI.
 .B rdma
 The RDMA I/O engine supports both RDMA memory semantics
 (RDMA_WRITE/RDMA_READ) and channel semantics (Send/Recv) for the
-InfiniBand, RoCE and iWARP protocols.
+InfiniBand, RoCE and iWARP protocols. This engine defines engine
+specific options.
 .TP
 .B falloc
 I/O engine that does regular fallocate to simulate data transfer as
@@ -1654,10 +1655,14 @@ The TCP or UDP port to bind to or connect to. If this is used with
 this will be the starting port number since fio will use a range of
 ports.
 .TP
-.BI (netsplice,net)hostname \fR=\fPstr
-The hostname or IP address to use for TCP or UDP based I/O. If the job is
-a TCP listener or UDP reader, the hostname is not used and must be omitted
-unless it is a valid UDP multicast address.
+.BI (rdma)port
+The port to use for RDMA-CM communication. This should be the same
+value on the client and the server side.
+.TP
+.BI (netsplice,net, rdma)hostname \fR=\fPstr
+The hostname or IP address to use for TCP, UDP or RDMA-CM based I/O.
+If the job is a TCP listener or UDP reader, the hostname is not used
+and must be omitted unless it is a valid UDP multicast address.
 .TP
 .BI (netsplice,net)interface \fR=\fPstr
 The IP address of the network interface used to send or receive UDP
@@ -1757,6 +1762,21 @@ libhdfs will create chunk in this HDFS directory.
 .TP
 .BI (libhdfs)chunk_size
 The size of the chunk to use for each file.
+.TP
+.BI (rdma)verb \fR=\fPstr
+The RDMA verb to use on this side of the RDMA ioengine
+connection. Valid values are write, read, send and recv. These
+correspond to the equivalent RDMA verbs (e.g. write = rdma_write
+etc.). Note that this only needs to be specified on the client side of
+the connection. See the examples folder.
+.TP
+.BI (rdma)bindname \fR=\fPstr
+The name to use to bind the local RDMA-CM connection to a local RDMA
+device. This could be a hostname or an IPv4 or IPv6 address. On the
+server side this will be passed into the rdma_bind_addr() function and
+on the client site it will be used in the rdma_resolve_add()
+function. This can be useful when multiple paths exist between the
+client and the server or in certain loopback configurations.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
