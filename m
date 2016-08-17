Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcHQMAS (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Aug 2016 08:00:18 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bZzVs-0003CL-4i
	for fio@vger.kernel.org; Wed, 17 Aug 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160817120001.EB1152C0051@kernel.dk>
Date: Wed, 17 Aug 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8aa89d70f44eb3fe9d9581fd9bcc3cebca22621b:

  Various cleanups (2016-08-15 23:36:11 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c22825bb537af1f84a18dcb4af6d8c6844f751ac:

  Fix backwards reads with --size smaller than the file size (2016-08-16 15:22:17 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'histogram-delta' of https://github.com/cronburg/fio into histogram
      histogram: style and list fixups
      Fix backwards reads with --size smaller than the file size

Karl Cronburg (1):
      Make histogram samples non-cumulative by tracking a linked-list     of the most recent histogram and differencing it when we print     to the log file(s). Linked list of pointers used to minimize     runtime impact on recording side, instead choosing to do     subtraction on the logging (when logs get printed to file) side.

 io_u.c                          | 18 ++++++++++---
 iolog.c                         | 44 +++++++++++++++++++++++++-------
 iolog.h                         |  1 +
 stat.c                          |  9 ++++---
 stat.h                          |  5 ++++
 tools/hist/fiologparser_hist.py | 56 ++++++++++-------------------------------
 6 files changed, 73 insertions(+), 60 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 2270127..dcf7a40 100644
--- a/io_u.c
+++ b/io_u.c
@@ -362,8 +362,12 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	if (f->last_pos[ddir] < f->real_file_size) {
 		uint64_t pos;
 
-		if (f->last_pos[ddir] == f->file_offset && o->ddir_seq_add < 0)
-			f->last_pos[ddir] = f->real_file_size;
+		if (f->last_pos[ddir] == f->file_offset && o->ddir_seq_add < 0) {
+			if (f->real_file_size > f->io_size)
+				f->last_pos[ddir] = f->io_size;
+			else
+				f->last_pos[ddir] = f->real_file_size;
+		}
 
 		pos = f->last_pos[ddir] - f->file_offset;
 		if (pos && o->ddir_seq_add) {
@@ -378,8 +382,14 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 			if (pos >= f->real_file_size) {
 				if (o->ddir_seq_add > 0)
 					pos = f->file_offset;
-				else
-					pos = f->real_file_size + o->ddir_seq_add;
+				else {
+					if (f->real_file_size > f->io_size)
+						pos = f->io_size;
+					else
+						pos = f->real_file_size;
+
+					pos += o->ddir_seq_add;
+				}
 			}
 		}
 
diff --git a/iolog.c b/iolog.c
index b0c948b..d4213db 100644
--- a/iolog.c
+++ b/iolog.c
@@ -576,6 +576,9 @@ void setup_log(struct io_log **log, struct log_params *p,
 	       const char *filename)
 {
 	struct io_log *l;
+	int i;
+	struct io_u_plat_entry *entry;
+	struct flist_head *list;
 
 	l = scalloc(1, sizeof(*l));
 	INIT_FLIST_HEAD(&l->io_logs);
@@ -589,6 +592,16 @@ void setup_log(struct io_log **log, struct log_params *p,
 	l->filename = strdup(filename);
 	l->td = p->td;
 
+	/* Initialize histogram lists for each r/w direction,
+	 * with initial io_u_plat of all zeros:
+	 */
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		list = &l->hist_window[i].list;
+		INIT_FLIST_HEAD(list);
+		entry = calloc(1, sizeof(struct io_u_plat_entry));
+		flist_add(&entry->list, list);
+	}
+
 	if (l->td && l->td->o.io_submit_mode != IO_MODE_OFFLOAD) {
 		struct io_logs *p;
 
@@ -661,13 +674,14 @@ void free_log(struct io_log *log)
 	sfree(log);
 }
 
-static inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat)
+static inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
+		unsigned int *io_u_plat_last)
 {
 	unsigned long sum;
 	int k;
 
 	for (k = sum = 0; k < stride; k++)
-		sum += io_u_plat[j + k];
+		sum += io_u_plat[j + k] - io_u_plat_last[j + k];
 
 	return sum;
 }
@@ -678,7 +692,9 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 	struct io_sample *s;
 	int log_offset;
 	uint64_t i, j, nr_samples;
+	struct io_u_plat_entry *entry, *entry_before;
 	unsigned int *io_u_plat;
+	unsigned int *io_u_plat_before;
 
 	int stride = 1 << hist_coarseness;
 	
@@ -692,15 +708,25 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
-		io_u_plat = (unsigned int *) (uintptr_t) s->val;
-		fprintf(f, "%lu, %u, %u, ", (unsigned long)s->time,
-		        io_sample_ddir(s), s->bs);
+
+		entry = (struct io_u_plat_entry *) s->val;
+		io_u_plat = entry->io_u_plat;
+
+		entry_before = flist_first_entry(&entry->list, struct io_u_plat_entry, list);
+		io_u_plat_before = entry_before->io_u_plat;
+
+		fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
+						io_sample_ddir(s), s->bs);
 		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
-			fprintf(f, "%lu, ", hist_sum(j, stride, io_u_plat));
+			fprintf(f, "%lu, ", hist_sum(j, stride, io_u_plat,
+						io_u_plat_before));
 		}
-		fprintf(f, "%lu\n", (unsigned long) 
-		        hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat));
-		free(io_u_plat);
+		fprintf(f, "%lu\n", (unsigned long)
+		        hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat,
+					io_u_plat_before));
+
+		flist_del(&entry_before->list);
+		free(entry_before);
 	}
 }
 
diff --git a/iolog.h b/iolog.h
index 93e970e..ca344f1 100644
--- a/iolog.h
+++ b/iolog.h
@@ -21,6 +21,7 @@ struct io_stat {
 struct io_hist {
 	uint64_t samples;
 	unsigned long hist_last;
+	struct flist_head list;
 };
 
 /*
diff --git a/stat.c b/stat.c
index 6f5f002..5e7c593 100644
--- a/stat.c
+++ b/stat.c
@@ -2221,7 +2221,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		
 		if (this_window >= iolog->hist_msec) {
 			unsigned int *io_u_plat;
-			unsigned int *dst;
+			struct io_u_plat_entry *dst;
 
 			/*
 			 * Make a byte-for-byte copy of the latency histogram
@@ -2231,10 +2231,11 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			 * log file.
 			 */
 			io_u_plat = (unsigned int *) td->ts.io_u_plat[ddir];
-			dst = malloc(FIO_IO_U_PLAT_NR * sizeof(unsigned int));
-			memcpy(dst, io_u_plat,
+			dst = malloc(sizeof(struct io_u_plat_entry));
+			memcpy(&(dst->io_u_plat), io_u_plat,
 				FIO_IO_U_PLAT_NR * sizeof(unsigned int));
-			__add_log_sample(iolog, (unsigned long )dst, ddir, bs,
+			flist_add(&dst->list, &hw->list);
+			__add_log_sample(iolog, (unsigned long)dst, ddir, bs,
 						elapsed, offset);
 
 			/*
diff --git a/stat.h b/stat.h
index c3e343d..e6f7759 100644
--- a/stat.h
+++ b/stat.h
@@ -240,6 +240,11 @@ struct jobs_eta {
 	uint8_t run_str[];
 } __attribute__((packed));
 
+struct io_u_plat_entry {
+	struct flist_head list;
+	unsigned int io_u_plat[FIO_IO_U_PLAT_NR];
+};
+
 extern struct fio_mutex *stat_mutex;
 
 extern struct jobs_eta *get_jobs_eta(bool force, size_t *size);
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index ce98d2e..5891427 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -46,9 +46,7 @@
       to get weighted histograms.
     
     * We convert files given on the command line, assumed to be fio histogram files,
-      on-the-fly into their corresponding differenced files i.e. non-cumulative histograms
-      because fio outputs cumulative histograms, but we want histograms corresponding
-      to individual time intervals. An individual histogram file can contain the cumulative
+      An individual histogram file can contain the
       histograms for multiple different r/w directions (notably when --rw=randrw). This
       is accounted for by tracking each r/w direction separately. In the statistics
       reported we ultimately merge *all* histograms (regardless of r/w direction).
@@ -188,23 +186,8 @@ __HIST_COLUMNS = 1216
 __NON_HIST_COLUMNS = 3
 __TOTAL_COLUMNS = __HIST_COLUMNS + __NON_HIST_COLUMNS
     
-def sequential_diffs(head_row, times, rws, hists):
-    """ Take the difference of sequential (in time) histograms with the same
-        r/w direction, returning a new array of differenced histograms.  """
-    result = np.empty(shape=(0, __HIST_COLUMNS))
-    result_times = np.empty(shape=(1, 0))
-    for i in range(8):
-        idx = np.where(rws == i)
-        diff = np.diff(np.append(head_row[i], hists[idx], axis=0), axis=0).astype(int)
-        result = np.append(diff, result, axis=0)
-        result_times = np.append(times[idx], result_times)
-    idx = np.argsort(result_times)
-    return result[idx]
-
-def read_chunk(head_row, rdr, sz):
-    """ Read the next chunk of size sz from the given reader, computing the
-        differences across neighboring histogram samples.
-    """
+def read_chunk(rdr, sz):
+    """ Read the next chunk of size sz from the given reader. """
     try:
         """ StopIteration occurs when the pandas reader is empty, and AttributeError
             occurs if rdr is None due to the file being empty. """
@@ -212,32 +195,20 @@ def read_chunk(head_row, rdr, sz):
     except (StopIteration, AttributeError):
         return None    
 
-    """ Extract array of just the times, and histograms matrix without times column.
-        Then, take the sequential difference of each of the rows in the histogram
-        matrix. This is necessary because fio outputs *cumulative* histograms as
-        opposed to histograms with counts just for a particular interval. """
+    """ Extract array of just the times, and histograms matrix without times column. """
     times, rws, szs = new_arr[:,0], new_arr[:,1], new_arr[:,2]
     hists = new_arr[:,__NON_HIST_COLUMNS:]
-    hists_diff   = sequential_diffs(head_row, times, rws, hists)
     times = times.reshape((len(times),1))
-    arr = np.append(times, hists_diff, axis=1)
+    arr = np.append(times, hists, axis=1)
 
-    """ hists[-1] will be the row we need to start our differencing with the
-        next time we call read_chunk() on the same rdr """
-    return arr, hists[-1]
+    return arr
 
 def get_min(fps, arrs):
     """ Find the file with the current first row with the smallest start time """
-    return min([fp for fp in fps if not arrs[fp] is None], key=lambda fp: arrs.get(fp)[0][0][0])
+    return min([fp for fp in fps if not arrs[fp] is None], key=lambda fp: arrs.get(fp)[0][0])
 
 def histogram_generator(ctx, fps, sz):
     
-    """ head_row for a particular file keeps track of the last (cumulative)
-        histogram we read so that we have a reference point to subtract off
-        when computing sequential differences. """
-    head_row  = np.zeros(shape=(1, __HIST_COLUMNS))
-    head_rows = {fp: {i: head_row for i in range(8)} for fp in fps}
-
     # Create a chunked pandas reader for each of the files:
     rdrs = {}
     for fp in fps:
@@ -250,8 +221,8 @@ def histogram_generator(ctx, fps, sz):
             else:
                 raise(e)
 
-    # Initial histograms and corresponding head_rows:
-    arrs = {fp: read_chunk(head_rows[fp], rdr, sz) for fp,rdr in rdrs.items()}
+    # Initial histograms from disk:
+    arrs = {fp: read_chunk(rdr, sz) for fp,rdr in rdrs.items()}
     while True:
 
         try:
@@ -259,13 +230,12 @@ def histogram_generator(ctx, fps, sz):
             fp = get_min(fps, arrs)
         except ValueError:
             return
-        arr, head_row = arrs[fp]
+        arr = arrs[fp]
         yield np.insert(arr[0], 1, fps.index(fp))
-        arrs[fp] = arr[1:], head_row
-        head_rows[fp] = head_row
+        arrs[fp] = arr[1:]
 
-        if arrs[fp][0].shape[0] == 0:
-            arrs[fp] = read_chunk(head_rows[fp], rdrs[fp], sz)
+        if arrs[fp].shape[0] == 0:
+            arrs[fp] = read_chunk(rdrs[fp], sz)
 
 def _plat_idx_to_val(idx, edge=0.5, FIO_IO_U_PLAT_BITS=6, FIO_IO_U_PLAT_VAL=64):
     """ Taken from fio's stat.c for calculating the latency value of a bin
