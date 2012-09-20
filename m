Return-Path: <rjevskiy@gmail.com>
Sender: Dmitry Monakhov <rjevskiy@gmail.com>
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] update documentation for falloc and e4defrag engines
Date: Thu, 20 Sep 2012 15:37:17 +0400
Message-Id: <1348141037-16303-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348141037-16303-1-git-send-email-dmonakhov@openvz.org>
References: <1348141037-16303-1-git-send-email-dmonakhov@openvz.org>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
List-ID: <fio@vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 HOWTO              |   20 ++++++++++-
 examples/e4defrag  |   49 +++++++++++++++++------------
 examples/e4defrag2 |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/falloc    |   54 ++++++++++++++++++++++++++++++++
 fio.1              |   29 +++++++++++++++++
 5 files changed, 218 insertions(+), 22 deletions(-)
 create mode 100644 examples/e4defrag2
 create mode 100644 examples/falloc

diff --git a/HOWTO b/HOWTO
index 3eb5510..f6406b0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -602,8 +602,16 @@ ioengine=str	Defines how the job issues io to the file. The following
 				channel semantics (Send/Recv) for the
 				InfiniBand, RoCE and iWARP protocols.
 
-			falloc  Perform fallocate/punch_hole to files
-	
+			falloc   IO engine that does regular fallocate to
+				 simulate data transfer as fio ioengine.
+				 DDIR_READ  does fallocate(,mode = keep_size,)
+				 DDIR_WRITE does fallocate(,mode = 0)  
+				 DDIR_TRIM  does fallocate(,mode = punch_hole)
+
+			e4defrag IO engine that does regular EXT4_IOC_MOVE_EXT
+				 ioctls to simulate defragment activity in
+				 request to DDIR_WRITE event
+	      
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
 				filename, eg ioengine=external:/tmp/foo.o
@@ -1318,6 +1326,14 @@ that defines them is selected.
 [net] listen	For TCP network connections, tell fio to listen for incoming
 		connections rather than initiating an outgoing connection. The
 		hostname must be omitted if this option is used.
+[e4defrag] donorname=str
+	        File will be used as a block donor(swap extents between files)
+[e4defrag] inplace=int
+		Configure donor file blocks allocation strategy		
+		0(default): Preallocate donor's file on init
+		1 	  : allocate space immidietly inside defragment event,
+			    and free right after event
+
 
 
 6.0 Interpreting the output
diff --git a/examples/e4defrag b/examples/e4defrag
index d392149..cb94e85 100644
--- a/examples/e4defrag
+++ b/examples/e4defrag
@@ -1,32 +1,41 @@
 [global]
-
-direct=0
-buffered=0
+ioengine=e4defrag
 directory=/scratch
-
 nrfiles=1
+filesize=100M
+size=100M
+bs=32k
+#group_reporting
 
-filesize=4G
-fadvise_hint=0
-
-group_reporting
+[isolated-e4defrag]
+# It is important to disable buffered io
+buffered=0
+donorname=file.def
+filename=file1
+inplace=0
+rw=write
 
-[defrag-fuzzer-8k]
+# Run e4defrag and aio-dio workers in parallel
+[e4defrag]
+stonewall
+time_based=30
+runtime=30
 ioengine=e4defrag
-iodepth=1
-size=1G
-bs=8k
+buffered=0
 donorname=file.def
-filename=file
+filename=file1
 inplace=0
-rw=randwrite
-numjobs=1
+rw=write
 
 [random-aio-32k]
 ioengine=libaio
+runtime=30
+verify=md5
+direct=1
+bs=64k
 iodepth=128
-bs=32k
-size=4G
-filename=file
-rw=randwrite
-numjobs=1
+filename=file1
+rw=randrw
+numjobs=4
+
+
diff --git a/examples/e4defrag2 b/examples/e4defrag2
new file mode 100644
index 0000000..818618a
--- /dev/null
+++ b/examples/e4defrag2
@@ -0,0 +1,88 @@
+#################################################
+# Hardcode defragmentation patterns
+# Please be carefull, it can trigger kernel panic
+#################################################
+[global]
+ioengine=e4defrag
+group_reporting
+directory=/scratch
+nrfiles=1
+filesize=100M
+size=100M
+donorname=file.def
+bs=32k
+
+###########
+# Run several defragmentation threads for different files, but
+# use shared donor file
+[parallel-e4defrag]
+buffered=0
+inplace=0
+rw=write
+numjobs=4
+
+########
+# Run two defragmentation threads, each thread use another's file
+# as donor file
+
+[e4defrag-1]
+stonewall
+inplace=0
+rw=write
+donorname=e4defrag-2
+
+[e4defrag-2]
+inplace=0
+rw=write
+donorname=e4defrag-1
+
+###########
+# Run random defragment activity 
+[e4defrag-fuzzer-4k]
+stonewall
+inplace=1
+bs=4k
+rw=randwrite
+filename=file
+donorname=file.def
+
+########
+# Run random e4defrag and various aio workers in parallel
+[e4defrag-fuzzer-4k]
+stonewall
+continue_on_error=all
+inplace=1
+bs=4k
+donorname=file3.def
+filename=file3
+time_based=30
+rw=randwrite
+
+[buffered-aio-32k]
+continue_on_error=none
+verify=md5
+buffered=1
+ioengine=libaio
+iodepth=128
+bs=32k
+filename=file3
+rw=randrw
+runtime=30
+time_based=30
+numjobs=4
+
+[direct-aio-32k]
+continue_on_error=none
+verify=md5
+buffered=0
+direct=1
+ioengine=libaio
+iodepth=128
+bs=32k
+filename=file3
+rw=randrw
+runtime=30
+time_based=30
+numjobs=4
+
+
diff --git a/examples/falloc b/examples/falloc
new file mode 100644
index 0000000..fa30731
--- /dev/null
+++ b/examples/falloc
@@ -0,0 +1,54 @@
+[global]
+ioengine=falloc
+iodepth=1
+direct=0
+buffered=0
+directory=/scratch
+nrfiles=1
+size=100M
+filesize=100M
+group_reporting
+
+
+# Run falloc and punch_hole threads in parallel
+# After activity file will be highly fragmented
+[falloc-fuzzer]
+stonewall
+runtime=10
+time_based=10
+bssplit=4k/10:64k/50:32k/40
+rw=randwrite
+numjobs=1
+filename=fragmented_file
+
+[punch hole-fuzzer]
+bs=4k
+runtime=10
+time_based=10
+rw=randtrim
+numjobs=2
+filename=fragmented_file
+
+## Mesure IO performance on fragmented file
+[sequential aio-dio write]
+stonewall
+ioengine=libaio
+numjobs=1
+iodepth=128
+buffered=0
+direct=1
+rw=write
+bs=64k
+filename=fragmented_file
+
+[sequential buffered read]
+stonewall
+ioengine=sync
+numjobs=1
+iodepth=1
+buffered=1
+direct=0
+rw=read
+bs=64k
+filename=fragmented_file
+
diff --git a/fio.1 b/fio.1
index 086cf9d..3b8ed32 100644
--- a/fio.1
+++ b/fio.1
@@ -472,6 +472,21 @@ and channel semantics (Send/Recv) for the InfiniBand, RoCE and iWARP protocols.
 .B external
 Loads an external I/O engine object file.  Append the engine filename as
 `:\fIenginepath\fR'.
+.TP
+.B falloc
+   IO engine that does regular linux native fallocate callt to simulate data
+transfer as fio ioengine
+.br
+  DDIR_READ  does fallocate(,mode = FALLOC_FL_KEEP_SIZE,)
+.br
+  DIR_WRITE does fallocate(,mode = 0) 
+.br
+  DDIR_TRIM does fallocate(,mode = FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE)
+.TP
+.B e4defrag
+IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate defragment activity
+request to DDIR_WRITE event
+.TP
 .RE
 .RE
 .TP
@@ -1057,6 +1072,20 @@ used and the port is invalid.
 For TCP network connections, tell fio to listen for incoming
 connections rather than initiating an outgoing connection. The
 hostname must be omitted if this option is used.
+.TP
+.BI (e4defrag,donorname) \fR=\fPstr
+File will be used as a block donor (swap extents between files)
+.TP
+.BI (e4defrag,inplace) \fR=\fPint
+Configure donor file block allocation strategy		
+.RS
+.BI 0(default) :
+Preallocate donor's file on init
+.TP
+.BI 1:
+allocate space immidietly inside defragment event, and free right after event
+.RE
+.TP
 .SH OUTPUT
 While running, \fBfio\fR will display the status of the created jobs.  For
 example:
-- 
1.7.7.6


