Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 2/7] Add new trimwrite rw= mode for trims preceding writes
Date: Wed, 15 Apr 2015 10:41:30 -0700
Message-Id: <1429119695-22425-3-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
References: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

In this new mode, sequential trims and writes are interspersed by first
doing a trim at a particular offset, then doing writes starting from
that offset until the start of the next trim block, then another trim,
etc. This workload is designed to match the requirements of NAND flash,
if trims are implemented as erases.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 HOWTO     |  8 +++++++-
 backend.c |  5 +++++
 fio.1     |  4 ++++
 io_ddir.h |  3 +++
 io_u.c    | 12 +++++++++++-
 options.c |  4 ++++
 stat.c    |  4 ++++
 7 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 3f258db..04e1b31 100644
--- a/HOWTO
+++ b/HOWTO
@@ -383,10 +383,16 @@ rw=str		Type of io pattern. Accepted values are:
 
 			read		Sequential reads
 			write		Sequential writes
-			randwrite	Random writes
+			trim		Sequential trim
 			randread	Random reads
+			randwrite	Random writes
+			randtrim	Random trims
 			rw,readwrite	Sequential mixed reads and writes
 			randrw		Random mixed reads and writes
+			trimwrite	Trims alternating with writes, with
+					trims preceding writes to the same
+					locations at their respective block
+					sizes
 
 		For the mixed io types, the default is to split them 50/50.
 		For certain types of io the result may still be skewed a bit,
diff --git a/backend.c b/backend.c
index 2be7149..25479b4 100644
--- a/backend.c
+++ b/backend.c
@@ -744,6 +744,11 @@ static uint64_t do_io(struct thread_data *td)
 	   (td_write(td) && td->o.verify_backlog))
 		total_bytes += td->o.size;
 
+	/* In trimwrite mode, each byte is trimmed and then written, so
+	 * allow total_bytes to be twice as big */
+	if (td_trimwrite(td))
+		total_bytes += td->total_io_size;
+
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
 		(!flist_empty(&td->trim_list)) || !io_issue_bytes_exceeded(td) ||
 		td->o.time_based) {
diff --git a/fio.1 b/fio.1
index b94fb43..6e41d35 100644
--- a/fio.1
+++ b/fio.1
@@ -286,6 +286,10 @@ Mixed sequential reads and writes.
 .TP
 .B randrw 
 Mixed random reads and writes.
+.TP
+.B trimwrite
+Trims alternating with writes, with trims preceding writes to the same location
+at their respective block sizes.
 .RE
 .P
 For mixed I/O, the default split is 50/50. For certain types of io the result
diff --git a/io_ddir.h b/io_ddir.h
index b16a6b9..e5eff68 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -35,6 +35,7 @@ enum td_ddir {
 	TD_DDIR_RANDWRITE	= TD_DDIR_WRITE | TD_DDIR_RAND,
 	TD_DDIR_RANDRW		= TD_DDIR_RW | TD_DDIR_RAND,
 	TD_DDIR_RANDTRIM	= TD_DDIR_TRIM | TD_DDIR_RAND,
+	TD_DDIR_TRIMWRITE	= TD_DDIR_TRIM | TD_DDIR_WRITE,
 };
 
 #define td_read(td)		((td)->o.td_ddir & TD_DDIR_READ)
@@ -43,6 +44,8 @@ enum td_ddir {
 #define td_rw(td)		(((td)->o.td_ddir & TD_DDIR_RW) == TD_DDIR_RW)
 #define td_random(td)		((td)->o.td_ddir & TD_DDIR_RAND)
 #define file_randommap(td, f)	(!(td)->o.norandommap && fio_file_axmap((f)))
+#define td_trimwrite(td)	(((td)->o.td_ddir & TD_DDIR_TRIMWRITE) \
+					== TD_DDIR_TRIMWRITE)
 
 static inline int ddir_sync(enum fio_ddir ddir)
 {
diff --git a/io_u.c b/io_u.c
index 975d242..7153ba2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -657,7 +657,17 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 
 static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 {
-	io_u->ddir = io_u->acct_ddir = get_rw_ddir(td);
+	enum fio_ddir ddir = get_rw_ddir(td);
+
+	if (td_trimwrite(td)) {
+		struct fio_file *f = io_u->file;
+		if (f->last_pos[DDIR_WRITE] == f->last_pos[DDIR_TRIM])
+			ddir = DDIR_TRIM;
+		else
+			ddir = DDIR_WRITE;
+	}
+
+	io_u->ddir = io_u->acct_ddir = ddir;
 
 	if (io_u->ddir == DDIR_WRITE && (td->io_ops->flags & FIO_BARRIER) &&
 	    td->o.barrier_blocks &&
diff --git a/options.c b/options.c
index 337fecd..ba2692c 100644
--- a/options.c
+++ b/options.c
@@ -1408,6 +1408,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = TD_DDIR_RANDRW,
 			    .help = "Random read and write mix"
 			  },
+			  { .ival = "trimwrite",
+			    .oval = TD_DDIR_TRIMWRITE,
+			    .help = "Write and trim mix, trims preceding writes"
+			  },
 		},
 	},
 	{
diff --git a/stat.c b/stat.c
index 85bd728..252b2dc 100644
--- a/stat.c
+++ b/stat.c
@@ -1296,6 +1296,10 @@ void __show_run_stats(void)
 		ts->latency_percentile = td->o.latency_percentile;
 		ts->latency_window = td->o.latency_window;
 
+		ts->nr_block_infos = td->ts.nr_block_infos;
+		for (i = 0; i < ts->nr_block_infos; i++)
+			ts->block_infos[i] = td->ts.block_infos[i];
+
 		sum_thread_stats(ts, &td->ts, idx);
 	}
 
-- 
2.2.0.rc0.207.ga3a616c


