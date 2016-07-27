Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 09/15] Use correct I/O engine name "cpuio" instead of "cpu"
Date: Wed, 27 Jul 2016 22:37:14 +0900
Message-Id: <1469626640-13335-9-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

"cpuio" is the name of the engine/option, though the filename is cpu.c.

 # grep "ioengine =" engines/cpu.c -A1
 static struct ioengine_ops ioengine = {
 	.name           = "cpuio",

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 HOWTO         | 6 +++---
 engines/cpu.c | 4 ++--
 fio.1         | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/HOWTO b/HOWTO
index cfcc81f..bc69ab0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1840,12 +1840,12 @@ that defines them is selected.
 [psyncv2] hipri		Set RWF_HIPRI on IO, indicating to the kernel that
 			it's of higher priority than normal.
 
-[cpu] cpuload=int Attempt to use the specified percentage of CPU cycles.
+[cpuio] cpuload=int Attempt to use the specified percentage of CPU cycles.
 
-[cpu] cpuchunks=int Split the load into cycles of the given time. In
+[cpuio] cpuchunks=int Split the load into cycles of the given time. In
 		microseconds.
 
-[cpu] exit_on_io_done=bool Detect when IO threads are done, then exit.
+[cpuio] exit_on_io_done=bool Detect when IO threads are done, then exit.
 
 [netsplice] hostname=str
 [net] hostname=str The host name or IP address to use for TCP or UDP based IO.
diff --git a/engines/cpu.c b/engines/cpu.c
index 7643a8c..3d855e3 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -88,8 +88,8 @@ static int fio_cpuio_init(struct thread_data *td)
 
 	o->nr_files = o->open_files = 1;
 
-	log_info("%s: ioengine=cpu, cpuload=%u, cpucycle=%u\n", td->o.name,
-						co->cpuload, co->cpucycle);
+	log_info("%s: ioengine=%s, cpuload=%u, cpucycle=%u\n",
+		td->o.name, td->io_ops->name, co->cpuload, co->cpucycle);
 
 	return 0;
 }
diff --git a/fio.1 b/fio.1
index cff95ee..8387cbd 100644
--- a/fio.1
+++ b/fio.1
@@ -1696,13 +1696,13 @@ Some parameters are only valid when a specific ioengine is in use. These are
 used identically to normal parameters, with the caveat that when used on the
 command line, they must come after the ioengine.
 .TP
-.BI (cpu)cpuload \fR=\fPint
+.BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles.
 .TP
-.BI (cpu)cpuchunks \fR=\fPint
+.BI (cpuio)cpuchunks \fR=\fPint
 Split the load into cycles of the given time. In microseconds.
 .TP
-.BI (cpu)exit_on_io_done \fR=\fPbool
+.BI (cpuio)exit_on_io_done \fR=\fPbool
 Detect when IO threads are done, then exit.
 .TP
 .BI (libaio)userspace_reap
-- 
2.5.5


