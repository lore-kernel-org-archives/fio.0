Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH v3 4/4] docs: serialize_overlap=1 with io_submit_mode=offload no longer requires threads
Date: Wed, 17 Oct 2018 12:03:25 -0400
Message-Id: <20181017160325.16866-5-vincentfu@gmail.com>
In-Reply-To: <20181017160325.16866-1-vincentfu@gmail.com>
References: <20181017160325.16866-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org, vincentfu@gmail.com
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

---
 HOWTO | 2 +-
 fio.1 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 72ef8725..468772d7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2343,7 +2343,7 @@ I/O depth
 	This option only applies to I/Os issued for a single job except when it is
 	enabled along with :option:`io_submit_mode`=offload. In offload mode, fio
 	will check for overlap among all I/Os submitted by offload jobs with :option:`serialize_overlap`
-	enabled. Threads must be used for all such jobs.
+	enabled.
 
 	Default: false.
 
diff --git a/fio.1 b/fio.1
index 7691b2b1..ed492682 100644
--- a/fio.1
+++ b/fio.1
@@ -2075,7 +2075,7 @@ this option can reduce both performance and the \fBiodepth\fR achieved.
 This option only applies to I/Os issued for a single job except when it is
 enabled along with \fBio_submit_mode\fR=offload. In offload mode, fio
 will check for overlap among all I/Os submitted by offload jobs with \fBserialize_overlap\fR
-enabled. Threads must be used for all such jobs.
+enabled.
 .P
 Default: false.
 .RE
-- 
2.17.1


