Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 01/11] manpage: fix formatting
Date: Fri, 3 Sep 2021 15:20:20 +0000
Message-ID: <20210903152012.18035-2-Niklas.Cassel@wdc.com>
References: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Damien Le Moal <damien.lemoal@wdc.com>

For ioengine options supported by multiple ioengines, remove spaces
after commas in the ioengine list to have troff correctly format in bold
the entire ioengine list and option name. Also add "=3Dint" indicators
missing for some options.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 fio.1 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fio.1 b/fio.1
index 382cebfc..25d9f545 100644
--- a/fio.1
+++ b/fio.1
@@ -1962,7 +1962,7 @@ In addition, there are some parameters which are only=
 valid when a specific
 with the caveat that when used on the command line, they must come after t=
he
 \fBioengine\fR that defines them is selected.
 .TP
-.BI (io_uring, libaio)cmdprio_percentage \fR=3D\fPint
+.BI (io_uring,libaio)cmdprio_percentage \fR=3D\fPint
 Set the percentage of I/O that will be issued with higher priority by sett=
ing
 the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentag=
e``.
 This option cannot be used with the `prio` or `prioclass` options. For thi=
s
@@ -2043,20 +2043,20 @@ Detect when I/O threads are done, then exit.
 .BI (libhdfs)namenode \fR=3D\fPstr
 The hostname or IP address of a HDFS cluster namenode to contact.
 .TP
-.BI (libhdfs)port
+.BI (libhdfs)port \fR=3D\fPint
 The listening port of the HFDS cluster namenode.
 .TP
-.BI (netsplice,net)port
+.BI (netsplice,net)port \fR=3D\fPint
 The TCP or UDP port to bind to or connect to. If this is used with
 \fBnumjobs\fR to spawn multiple instances of the same job type, then
 this will be the starting port number since fio will use a range of
 ports.
 .TP
-.BI (rdma, librpma_*)port
+.BI (rdma,librpma_*)port \fR=3D\fPint
 The port to use for RDMA-CM communication. This should be the same
 value on the client and the server side.
 .TP
-.BI (netsplice,net, rdma)hostname \fR=3D\fPstr
+.BI (netsplice,net,rdma)hostname \fR=3D\fPstr
 The hostname or IP address to use for TCP, UDP or RDMA-CM based I/O.
 If the job is a TCP listener or UDP reader, the hostname is not used
 and must be omitted unless it is a valid UDP multicast address.
--=20
2.31.1

