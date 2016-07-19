Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/7] Fix wrong cpuio option name in documentation
Date: Wed, 20 Jul 2016 01:33:41 +0900
Message-Id: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

The name of an option for cpuio engine is "cpuchunks",
though the code internally uses "cpucycle" for variables.

(If the option name "cpuchunks" is the incorrect one,
I'll resubmit a patch that corrects the option name)

 # fio --enghelp=cpuio
 cpuload                 : Use this percentage of CPU
   cpuchunks             : Length of the CPU burn cycles (usecs)
   exit_on_io_done         : Exit when IO threads finish

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 HOWTO | 2 +-
 fio.1 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index a50f93e..2a4f4d0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -749,7 +749,7 @@ ioengine=str	Defines how the job issues io to the file. The following
 
 			cpuio	Doesn't transfer any data, but burns CPU
 				cycles according to the cpuload= and
-				cpucycle= options. Setting cpuload=85
+				cpuchunks= options. Setting cpuload=85
 				will cause that job to do nothing but burn
 				85% of the CPU. In case of SMP machines,
 				use numjobs=<no_of_cpu> to get desired CPU
diff --git a/fio.1 b/fio.1
index 353f8ff..e89c3d1 100644
--- a/fio.1
+++ b/fio.1
@@ -654,7 +654,7 @@ and send/receive. This ioengine defines engine specific options.
 .TP
 .B cpuio
 Doesn't transfer any data, but burns CPU cycles according to \fBcpuload\fR and
-\fBcpucycles\fR parameters.
+\fBcpuchunks\fR parameters.
 .TP
 .B guasi
 The GUASI I/O engine is the Generic Userspace Asynchronous Syscall Interface
-- 
2.5.5


