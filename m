Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 07/15] Mention cpuio never finishes without real I/O in documentation
Date: Wed, 27 Jul 2016 22:37:12 +0900
Message-Id: <1469626640-13335-7-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

reap_threads() terminates cpuio threads only when there is
at least one real I/O thread that is exiting.

>	if (*nr_running == cputhreads && !pending && realthreads)
>		fio_terminate_threads(TERMINATE_ALL);

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 HOWTO | 3 ++-
 fio.1 | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 7f25bbc..cfcc81f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -757,7 +757,8 @@ ioengine=str	Defines how the job issues io to the file. The following
 				85% of the CPU. In case of SMP machines,
 				use numjobs=<no_of_cpu> to get desired CPU
 				usage, as the cpuload only loads a single
-				CPU at the desired rate.
+				CPU at the desired rate. A job never finishes
+				unless there is at least one non-cpuio job.
 
 			guasi	The GUASI IO engine is the Generic Userspace
 				Asyncronous Syscall Interface approach
diff --git a/fio.1 b/fio.1
index 739d950..cff95ee 100644
--- a/fio.1
+++ b/fio.1
@@ -656,7 +656,8 @@ and send/receive. This ioengine defines engine specific options.
 .TP
 .B cpuio
 Doesn't transfer any data, but burns CPU cycles according to \fBcpuload\fR and
-\fBcpuchunks\fR parameters.
+\fBcpuchunks\fR parameters. A job never finishes unless there is at least one
+non-cpuio job.
 .TP
 .B guasi
 The GUASI I/O engine is the Generic Userspace Asynchronous Syscall Interface
-- 
2.5.5


