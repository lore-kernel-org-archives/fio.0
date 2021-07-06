Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 01/11] manpage: fix formatting
Date: Tue,  6 Jul 2021 09:17:33 +0900
Message-Id: <20210706001743.10818-2-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

For ioengine options supported by multiple ioengines, remove spaces
after commas in the ioengine list to have troff correctly format in bold
the entire ioengine list and option name. Also add "=int" indicators
missing for some options.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fio.1 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fio.1 b/fio.1
index 5aa54a4d..1101a75d 100644
--- a/fio.1
+++ b/fio.1
@@ -1918,7 +1918,7 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 \fBioengine\fR that defines them is selected.
 .TP
-.BI (io_uring, libaio)cmdprio_percentage \fR=\fPint
+.BI (io_uring,libaio)cmdprio_percentage \fR=\fPint
 Set the percentage of I/O that will be issued with higher priority by setting
 the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentage``.
 This option cannot be used with the `prio` or `prioclass` options. For this
@@ -1999,20 +1999,20 @@ Detect when I/O threads are done, then exit.
 .BI (libhdfs)namenode \fR=\fPstr
 The hostname or IP address of a HDFS cluster namenode to contact.
 .TP
-.BI (libhdfs)port
+.BI (libhdfs)port \fR=\fPint
 The listening port of the HFDS cluster namenode.
 .TP
-.BI (netsplice,net)port
+.BI (netsplice,net)port \fR=\fPint
 The TCP or UDP port to bind to or connect to. If this is used with
 \fBnumjobs\fR to spawn multiple instances of the same job type, then
 this will be the starting port number since fio will use a range of
 ports.
 .TP
-.BI (rdma, librpma_*)port
+.BI (rdma,librpma_*)port \fR=\fPint
 The port to use for RDMA-CM communication. This should be the same
 value on the client and the server side.
 .TP
-.BI (netsplice,net, rdma)hostname \fR=\fPstr
+.BI (netsplice,net,rdma)hostname \fR=\fPstr
 The hostname or IP address to use for TCP, UDP or RDMA-CM based I/O.
 If the job is a TCP listener or UDP reader, the hostname is not used
 and must be omitted unless it is a valid UDP multicast address.
-- 
2.31.1


