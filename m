Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/2] doc: clarify what --alloc-size does
Date: Wed, 11 Sep 2019 10:56:39 -0400
Message-Id: <20190911145640.30005-2-vincentfu@gmail.com>
In-Reply-To: <20190911145640.30005-1-vincentfu@gmail.com>
References: <20190911145640.30005-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

The alloc-size option actually directs fio to allocate additional shared
memory pools of the specified size, augmenting the default allocation.
---
 HOWTO | 4 ++--
 fio.1 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/HOWTO b/HOWTO
index 6b449e97..4fef1504 100644
--- a/HOWTO
+++ b/HOWTO
@@ -222,8 +222,8 @@ Command line options
 
 .. option:: --alloc-size=kb
 
-	Set the internal smalloc pool size to `kb` in KiB.  The
-	``--alloc-size`` switch allows one to use a larger pool size for smalloc.
+	Allocate additional internal smalloc pools of size `kb` in KiB.  The
+	``--alloc-size`` option increases shared memory set aside for use by fio.
 	If running large jobs with randommap enabled, fio can run out of memory.
 	Smalloc is an internal allocator for shared structures from a fixed size
 	memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
diff --git a/fio.1 b/fio.1
index e0283f7f..77a2d799 100644
--- a/fio.1
+++ b/fio.1
@@ -112,8 +112,8 @@ only applies to job sections. The reserved *global* section is always
 parsed and used.
 .TP
 .BI \-\-alloc\-size \fR=\fPkb
-Set the internal smalloc pool size to \fIkb\fR in KiB. The
-\fB\-\-alloc\-size\fR switch allows one to use a larger pool size for smalloc.
+Allocate additional internal smalloc pools of size \fIkb\fR in KiB. The
+\fB\-\-alloc\-size\fR option increases shared memory set aside for use by fio.
 If running large jobs with randommap enabled, fio can run out of memory.
 Smalloc is an internal allocator for shared structures from a fixed size
 memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
-- 
2.17.1


