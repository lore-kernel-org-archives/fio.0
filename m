Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 1/2] stat: update description of clat accounting in stat.h
Date: Mon,  9 Oct 2017 10:47:11 -0400
Message-Id: <1507560432-28946-2-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1507560432-28946-1-git-send-email-vincentfu@gmail.com>
References: <1507560432-28946-1-git-send-email-vincentfu@gmail.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

The description in stat.h of the data structure used for
storing completion latency percentiles had not been updated
to reflect the transition to nanosecond timing. This patch
updates the description to be consistent with the nanosecond
changes. There have been a few instances on github and the
mailing list where this had caused confusion.
---
 stat.h | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/stat.h b/stat.h
index 848331b..3fda084 100644
--- a/stat.h
+++ b/stat.h
@@ -24,6 +24,16 @@ struct group_run_stats {
 #define FIO_IO_U_LAT_M_NR 12
 
 /*
+ * Constants for clat percentiles
+ */
+#define FIO_IO_U_PLAT_BITS 6
+#define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
+#define FIO_IO_U_PLAT_GROUP_NR 29
+#define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
+#define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
+					list of percentiles */
+
+/*
  * Aggregate clat samples to report percentile(s) of them.
  *
  * EXECUTIVE SUMMARY
@@ -34,7 +44,7 @@ struct group_run_stats {
  *
  * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the maximum
  * range being tracked for latency samples. The maximum value tracked
- * accurately will be 2^(GROUP_NR + PLAT_BITS -1) microseconds.
+ * accurately will be 2^(GROUP_NR + PLAT_BITS - 1) nanoseconds.
  *
  * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the memory
  * requirement of storing those aggregate counts. The memory used will
@@ -98,22 +108,15 @@ struct group_run_stats {
  *	3	8	2		[256,511]		64
  *	4	9	3		[512,1023]		64
  *	...	...	...		[...,...]		...
- *	18	23	17		[8838608,+inf]**	64
+ *	28	33	27		[8589934592,+inf]**	64
  *
  *  * Special cases: when n < (M-1) or when n == (M-1), in both cases,
  *    the value cannot be rounded off. Use all bits of the sample as
  *    index.
  *
- *  ** If a sample's MSB is greater than 23, it will be counted as 23.
+ *  ** If a sample's MSB is greater than 33, it will be counted as 33.
  */
 
-#define FIO_IO_U_PLAT_BITS 6
-#define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
-#define FIO_IO_U_PLAT_GROUP_NR 29
-#define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
-#define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
-					list of percentiles */
-
 /*
  * Trim cycle count measurements
  */
-- 
2.7.4


