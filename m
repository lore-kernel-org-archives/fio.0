Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 1/1] Intoducing a new option max_latency_rw. The current
 max_latency option exits the FIO job, if latency of an I/O exceeds
 max_latency.
Date: Fri, 12 Feb 2021 13:23:01 +0530
Message-Id: <20210212075301.24490-2-krish.reddy@samsung.com>
In-Reply-To: <20210212075301.24490-1-krish.reddy@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
References: <20210212075301.24490-1-krish.reddy@samsung.com>
	<CGME20210212075338epcas5p3be8b36e09bcebe34608e935e1e9a80ec@epcas5p3.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

For mixed workload if user wants to exit the FIO job only if latency
exceeds for a particular workload, i.e. either for read / write the support is not present.

The new option max_latency_rw accepts read, write or mixed (Default) as option.
If user specifies read, the FIO job will exit only if read latency exceeds max_latency.

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 HOWTO            | 17 +++++++++++++++++
 cconv.c          |  2 ++
 fio.1            | 18 ++++++++++++++++++
 init.c           |  3 +++
 io_u.c           | 10 ++++++++--
 options.c        | 23 +++++++++++++++++++++++
 thread_options.h |  8 ++++++++
 7 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index b6d1b58a..80089bc5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2667,6 +2667,23 @@ I/O latency
 	maximum latency. When the unit is omitted, the value is interpreted in
 	microseconds.
 
+.. option:: max_latency_rw=str
+
+	Used with :option:`max_latency`. In case of mixed workload it specifies
+	when to exit the job. Default: mixed.
+
+	Accepted values are:
+
+		**read**
+				Exit only if read latency exceeds
+				:option:`max_latency`.
+		**write**
+				Exit only if write latency exceeds
+				:option:`max_latency`.
+		**mixed**
+				Exit if either of read, write latency exceeds
+				:option:`max_latency`.
+
 .. option:: rate_cycle=int
 
 	Average bandwidth for :option:`rate` and :option:`rate_min` over this number
diff --git a/cconv.c b/cconv.c
index b10868fb..9391b7b3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -290,6 +290,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->latency_target = le64_to_cpu(top->latency_target);
 	o->latency_window = le64_to_cpu(top->latency_window);
 	o->max_latency = le64_to_cpu(top->max_latency);
+	o->max_latency_rw = le32_to_cpu(top->max_latency_rw);
 	o->latency_percentile.u.f = fio_uint64_to_double(le64_to_cpu(top->latency_percentile.u.i));
 	o->latency_run = le32_to_cpu(top->latency_run);
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
@@ -492,6 +493,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->latency_target = __cpu_to_le64(o->latency_target);
 	top->latency_window = __cpu_to_le64(o->latency_window);
 	top->max_latency = __cpu_to_le64(o->max_latency);
+	top->max_latency_rw = __cpu_to_le32(o->max_latency_rw);
 	top->latency_percentile.u.i = __cpu_to_le64(fio_double_to_uint64(o->latency_percentile.u.f));
 	top->latency_run = __cpu_to_le32(o->latency_run);
 	top->compress_percentage = cpu_to_le32(o->compress_percentage);
diff --git a/fio.1 b/fio.1
index aa248a3b..69b56e33 100644
--- a/fio.1
+++ b/fio.1
@@ -2402,6 +2402,24 @@ If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
 maximum latency. When the unit is omitted, the value is interpreted in
 microseconds.
 .TP
+.BI max_latency_rw \fR=\fPstr
+Used with \fBmax_latency\fR. In case of mixed workload it specifies when to
+exit the job. The allowed values are:
+.RS
+.RS
+.TP
+.B read
+Exit only if read latency exceeds \fBmax_latency\fR.
+.TP
+.B write
+Exit only if write latency exceeds \fBmax_latency\fR.
+.TP
+.B mixed
+Exits if either of read, write latency exceeds \fBmax_latency\fR. Default
+.PD
+.RE
+.RE
+.TP
 .BI rate_cycle \fR=\fPint
 Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number
 of milliseconds. Defaults to 1000.
diff --git a/init.c b/init.c
index d6dbaf7c..5183f381 100644
--- a/init.c
+++ b/init.c
@@ -964,6 +964,9 @@ static int fixup_options(struct thread_data *td)
 	o->max_latency *= 1000ULL;
 	o->latency_target *= 1000ULL;
 
+	if (!o->max_latency && o->max_latency_rw)
+		log_info("fio: max latency not specified.\n");
+
 	return ret;
 }
 
diff --git a/io_u.c b/io_u.c
index 00a219c2..7835bcb7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1888,8 +1888,14 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 				icd->error = ops->io_u_lat(td, tnsec);
 		}
 
-		if (td->o.max_latency && tnsec > td->o.max_latency)
-			lat_fatal(td, icd, tnsec, td->o.max_latency);
+		if (td->o.max_latency && tnsec > td->o.max_latency) {
+			if (td_rw(td)) {
+				if ((io_u->ddir == DDIR_WRITE && td->o.max_latency_rw != RW_READ) ||
+				    (io_u->ddir == DDIR_READ && td->o.max_latency_rw != RW_WRITE))
+					lat_fatal(td, icd, tnsec, td->o.max_latency);
+			} else
+				lat_fatal(td, icd, tnsec, td->o.max_latency);
+		}
 		if (td->o.latency_target && tnsec > td->o.latency_target) {
 			if (lat_target_failed(td))
 				lat_fatal(td, icd, tnsec, td->o.latency_target);
diff --git a/options.c b/options.c
index e62e0cfb..40f635b7 100644
--- a/options.c
+++ b/options.c
@@ -3735,6 +3735,29 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group = FIO_OPT_G_LATPROF,
 	},
+	{
+		.name	= "max_latency_rw",
+		.lname	= "Max Latency mixed workload",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, max_latency_rw),
+		.help	= "Maximum tolerated IO latency for Read / Write during mixed workload",
+		.def	= "mixed",
+		.parent	= "max_latency",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_LATPROF,
+		.posval = {
+			  { .ival = "read",
+			    .oval = RW_READ,
+			  },
+			  { .ival = "write",
+			    .oval = RW_WRITE,
+			  },
+			  { .ival = "mixed",
+			    .oval = RW_MIXED,
+			  },
+		},
+	},
 	{
 		.name	= "latency_target",
 		.lname	= "Latency Target (usec)",
diff --git a/thread_options.h b/thread_options.h
index f6b15403..2c5bc6ba 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -18,6 +18,12 @@ enum fio_zone_mode {
 	ZONE_MODE_ZBD		= 3,
 };
 
+enum fio_mix_workload {
+	RW_READ		= 0,
+	RW_WRITE	= 1,
+	RW_MIXED	= 2,
+};
+
 /*
  * What type of allocation to use for io buffers
  */
@@ -204,6 +210,7 @@ struct thread_options {
 	unsigned int mem_align;
 
 	unsigned long long max_latency;
+	unsigned int max_latency_rw;
 
 	unsigned int exit_what;
 	unsigned int stonewall;
@@ -647,6 +654,7 @@ struct thread_options_pack {
 	uint32_t allow_mounted_write;
 
 	uint32_t zone_mode;
+	uint32_t max_latency_rw;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
-- 
2.30.0-rc0


