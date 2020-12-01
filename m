Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 2/9] Introducing new offsets for the copy operation.
Date: Tue,  1 Dec 2020 17:10:27 +0530
Message-Id: <20201201114034.8307-3-krish.reddy@samsung.com>
In-Reply-To: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114054epcas5p2cf4bff491f02c4a29a386ae44d5e42c7@epcas5p2.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 options.c | 11 ++++++++++-
 parse.c   | 28 ++++++++++++++++++++++++++++
 parse.h   |  2 ++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/options.c b/options.c
index 1e91b3e9..f68ae8c2 100644
--- a/options.c
+++ b/options.c
@@ -2154,6 +2154,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, bs[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, bs[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, bs[DDIR_TRIM]),
+		.off4	= offsetof(struct thread_options, bs[DDIR_COPY]),
 		.minval = 1,
 		.help	= "Block size unit",
 		.def	= "4096",
@@ -2171,6 +2172,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, ba[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, ba[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, ba[DDIR_TRIM]),
+		.off4	= offsetof(struct thread_options, ba[DDIR_COPY]),
 		.minval	= 1,
 		.help	= "IO block offset alignment",
 		.parent	= "rw",
@@ -2190,6 +2192,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off4	= offsetof(struct thread_options, max_bs[DDIR_WRITE]),
 		.off5	= offsetof(struct thread_options, min_bs[DDIR_TRIM]),
 		.off6	= offsetof(struct thread_options, max_bs[DDIR_TRIM]),
+		.off7	= offsetof(struct thread_options, min_bs[DDIR_COPY]),
+		.off8	= offsetof(struct thread_options, max_bs[DDIR_COPY]),
 		.minval = 1,
 		.help	= "Set block size range (in more detail than bs)",
 		.parent = "rw",
@@ -2349,9 +2353,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, perc_rand[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, perc_rand[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, perc_rand[DDIR_TRIM]),
+		.off4	= offsetof(struct thread_options, perc_rand[DDIR_COPY]),
 		.maxval	= 100,
 		.help	= "Percentage of seq/random mix that should be random",
-		.def	= "100,100,100",
+		.def	= "100,100,100,100",
 		.interval = 5,
 		.inverse = "percentage_sequential",
 		.category = FIO_OPT_C_IO,
@@ -3579,6 +3584,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, rate[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, rate[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, rate[DDIR_TRIM]),
+		.off4	= offsetof(struct thread_options, rate[DDIR_COPY]),
 		.help	= "Set bandwidth rate",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RATE,
@@ -3591,6 +3597,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, ratemin[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, ratemin[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, ratemin[DDIR_TRIM]),
+		.off4	= offsetof(struct thread_options, ratemin[DDIR_COPY]),
 		.help	= "Job must meet this rate or it will be shutdown",
 		.parent	= "rate",
 		.hide	= 1,
@@ -3604,6 +3611,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, rate_iops[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, rate_iops[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, rate_iops[DDIR_TRIM]),
+		.off4	= offsetof(struct thread_options, rate_iops[DDIR_COPY]),
 		.help	= "Limit IO used to this number of IO operations/sec",
 		.hide	= 1,
 		.category = FIO_OPT_C_IO,
@@ -3616,6 +3624,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, rate_iops_min[DDIR_READ]),
 		.off2	= offsetof(struct thread_options, rate_iops_min[DDIR_WRITE]),
 		.off3	= offsetof(struct thread_options, rate_iops_min[DDIR_TRIM]),
+		.off4	= offsetof(struct thread_options, rate_iops_min[DDIR_COPY]),
 		.help	= "Job must meet this rate or it will be shut down",
 		.parent	= "rate_iops",
 		.hide	= 1,
diff --git a/parse.c b/parse.c
index f4cefcf6..84d24435 100644
--- a/parse.c
+++ b/parse.c
@@ -669,6 +669,10 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 					if (o->off3)
 						val_store(ilp, ull, o->off3, 0, data, o);
 				}
+				if (curr == 3) {
+					if (o->off4)
+						val_store(ilp, ull, o->off4, 0, data, o);
+				}
 				if (!more) {
 					if (curr < 1) {
 						if (o->off2)
@@ -678,6 +682,10 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 						if (o->off3)
 							val_store(ilp, ull, o->off3, 0, data, o);
 					}
+					if (curr < 3) {
+						if (o->off4)
+							val_store(ilp, ull, o->off4, 0, data, o);
+					}
 				}
 			} else if (o->type == FIO_OPT_ULL) {
 				if (first)
@@ -690,6 +698,10 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 					if (o->off3)
 						val_store(ullp, ull, o->off3, 0, data, o);
 				}
+				if (curr == 3) {
+					if (o->off4)
+						val_store(ullp, ull, o->off4, 0, data, o);
+				}
 				if (!more) {
 					if (curr < 1) {
 						if (o->off2)
@@ -699,6 +711,10 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 						if (o->off3)
 							val_store(ullp, ull, o->off3, 0, data, o);
 					}
+					if (curr < 3) {
+						if (o->off4)
+							val_store(ullp, ull, o->off4, 0, data, o);
+					}
 				}
 			} else {
 				if (first)
@@ -879,6 +895,12 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 					val_store(ullp, ull2, o->off6, 0, data, o);
 				}
 			}
+			if (curr == 3) {
+				if (o->off7 && o->off8) {
+					val_store(ullp, ull1, o->off7, 0, data, o);
+					val_store(ullp, ull2, o->off8, 0, data, o);
+				}
+			}
 			if (!more) {
 				if (curr < 1) {
 					if (o->off3 && o->off4) {
@@ -892,6 +914,12 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 						val_store(ullp, ull2, o->off6, 0, data, o);
 					}
 				}
+				if (curr < 3) {
+					if (o->off7 && o->off8) {
+						val_store(ullp, ull1, o->off7, 0, data, o);
+						val_store(ullp, ull2, o->off8, 0, data, o);
+					}
+				}
 			}
 		}
 
diff --git a/parse.h b/parse.h
index e6663ed4..643cd8dc 100644
--- a/parse.h
+++ b/parse.h
@@ -54,6 +54,8 @@ struct fio_option {
 	unsigned int off4;
 	unsigned int off5;
 	unsigned int off6;
+	unsigned int off7;
+	unsigned int off8;
 	unsigned long long maxval;		/* max and min value */
 	int minval;
 	double maxfp;			/* max and min floating value */
-- 
2.17.1


