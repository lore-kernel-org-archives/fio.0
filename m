Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 5/9] Added the changes for copy operation support in FIO.
Date: Tue,  1 Dec 2020 17:10:30 +0530
Message-Id: <20201201114034.8307-6-krish.reddy@samsung.com>
In-Reply-To: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114103epcas5p1bbf3d8ca05252935c14fed68f44dab2d@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

The source ranges for copy operation uses the existing offset generation
algorithm. As each copy operation has num_range source ranges
the get_next_offset will be called that many times. The data buffer
will now contain a range list, with each entry having a start offset
and the length in bytes for that source range.
For generating the destination offset added a new function.
Each successful copy operation will copy 'num_range' * 'block_size'
amount of data.

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 backend.c     |  22 +++++++++--
 file.h        |   3 ++
 filesetup.c   |  61 ++++++++++++++++++++++++++++++
 fio.h         |  12 ++++++
 init.c        |  39 +++++++++++--------
 io_u.c        | 103 +++++++++++++++++++++++++++++++++++++++++---------
 rate-submit.c |   2 +
 zbd.c         |   2 +
 8 files changed, 207 insertions(+), 37 deletions(-)

diff --git a/backend.c b/backend.c
index 2f4d6ac4..c0569c59 100644
--- a/backend.c
+++ b/backend.c
@@ -521,8 +521,13 @@ sync_done:
 		 */
 		if (td->io_ops->commit == NULL)
 			io_u_queued(td, io_u);
-		if (bytes_issued)
-			*bytes_issued += io_u->xfer_buflen;
+		if (bytes_issued) {
+			if (io_u->ddir == DDIR_COPY) {
+				*bytes_issued += (((io_u->xfer_buflen) * td->o.bs[DDIR_COPY]) /
+						   sizeof(struct source_range));
+			} else
+				*bytes_issued += io_u->xfer_buflen;
+		}
 		break;
 	case FIO_Q_BUSY:
 		if (!from_verify)
@@ -721,6 +726,10 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					io_u->ddir = DDIR_READ;
 					populate_verify_io_u(td, io_u);
 					break;
+				} else if (io_u->ddir == DDIR_COPY) {
+					td->io_issues[DDIR_COPY]++;
+					put_io_u(td, io_u);
+					continue;
 				} else {
 					put_io_u(td, io_u);
 					continue;
@@ -802,6 +811,8 @@ static bool io_bytes_exceeded(struct thread_data *td, uint64_t *this_bytes)
 		bytes = this_bytes[DDIR_WRITE];
 	else if (td_read(td))
 		bytes = this_bytes[DDIR_READ];
+	else if (td_copy(td))
+		bytes = this_bytes[DDIR_COPY];
 	else
 		bytes = this_bytes[DDIR_TRIM];
 
@@ -1278,7 +1289,8 @@ int init_io_u_buffers(struct thread_data *td)
 	td->orig_buffer_size = (unsigned long long) max_bs
 					* (unsigned long long) max_units;
 
-	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) || td_write(td)))
+	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) ||
+	    td_write(td) || td_copy(td)))
 		data_xfer = 0;
 
 	/*
@@ -1751,13 +1763,15 @@ static void *thread_main(void *data)
 	memcpy(&td->ss.prev_time, &td->epoch, sizeof(td->epoch));
 
 	if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
-			o->ratemin[DDIR_TRIM]) {
+	    o->ratemin[DDIR_TRIM] || o->ratemin[DDIR_COPY]) {
 	        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,
 					sizeof(td->bw_sample_time));
 	        memcpy(&td->lastrate[DDIR_WRITE], &td->bw_sample_time,
 					sizeof(td->bw_sample_time));
 	        memcpy(&td->lastrate[DDIR_TRIM], &td->bw_sample_time,
 					sizeof(td->bw_sample_time));
+	        memcpy(&td->lastrate[DDIR_COPY], &td->bw_sample_time,
+					sizeof(td->bw_sample_time));
 	}
 
 	memset(bytes_done, 0, sizeof(bytes_done));
diff --git a/file.h b/file.h
index 493ec04a..f5a794e4 100644
--- a/file.h
+++ b/file.h
@@ -99,6 +99,7 @@ struct fio_file {
 	 */
 	uint64_t real_file_size;
 	uint64_t file_offset;
+	uint64_t file_dest_offset;
 	uint64_t io_size;
 
 	/*
@@ -113,6 +114,7 @@ struct fio_file {
 	 * Track last end and last start of IO for a given data direction
 	 */
 	uint64_t last_pos[DDIR_RWDIR_CNT];
+	uint64_t last_pos_dest[DDIR_RWDIR_CNT];
 	uint64_t last_start[DDIR_RWDIR_CNT];
 
 	uint64_t first_write;
@@ -199,6 +201,7 @@ struct thread_data;
 extern void close_files(struct thread_data *);
 extern void close_and_free_files(struct thread_data *);
 extern uint64_t get_start_offset(struct thread_data *, struct fio_file *);
+extern uint64_t get_dest_offset(struct thread_data *, struct fio_file *);
 extern int __must_check setup_files(struct thread_data *);
 extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_file *);
 #ifdef __cplusplus
diff --git a/filesetup.c b/filesetup.c
index 42c5f630..68a21fac 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -679,6 +679,14 @@ open_again:
 		else
 			flags |= O_RDONLY;
 
+		if (is_std)
+			f->fd = dup(STDIN_FILENO);
+		else
+			from_hash = file_lookup_open(f, flags);
+	} else if (td_copy(td)) {
+		if (!read_only)
+			flags |= O_RDWR;
+
 		if (is_std)
 			f->fd = dup(STDIN_FILENO);
 		else
@@ -911,6 +919,54 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 	return offset;
 }
 
+uint64_t get_dest_offset(struct thread_data *td, struct fio_file *f)
+{
+	bool align = false;
+	struct thread_options *o = &td->o;
+	unsigned long long align_bs;
+	unsigned long long offset;
+	unsigned long long increment;
+
+	if (o->offset_increment_percent) {
+		assert(!o->offset_increment);
+		increment = o->offset_increment_percent * f->real_file_size / 100;
+		align = true;
+	} else
+		increment = o->offset_increment;
+
+	if (o->dest_offset_percent > 0) {
+		/* calculate the raw offset */
+		offset = (f->real_file_size * o->dest_offset_percent / 100) +
+			(td->subjob_number * increment);
+
+		align = true;
+	} else {
+		/* start_offset_percent not set */
+		offset = o->dest_offset +
+				td->subjob_number * increment;
+	}
+
+	if (align) {
+		/*
+		 * if offset_align is provided, use it
+		 */
+		if (fio_option_is_set(o, start_offset_align)) {
+			align_bs = o->start_offset_align;
+		} else {
+			/* else take the minimum block size */
+			align_bs = td_min_bs(td);
+		}
+
+		/*
+		 * block align the offset at the next available boundary at
+		 * ceiling(offset / align_bs) * align_bs
+		 */
+		offset = (offset / align_bs + (offset % align_bs != 0)) * align_bs;
+	}
+
+	return offset;
+}
+
 /*
  * Find longest path component that exists and return its length
  */
@@ -1172,6 +1228,9 @@ int setup_files(struct thread_data *td)
 				    td_ioengine_flagged(td, FIO_FAKEIO)))
 				f->real_file_size = f->io_size + f->file_offset;
 		}
+
+		if (td_copy(td))
+			f->file_dest_offset = get_dest_offset(td, f);
 	}
 
 	if (td->o.block_error_hist) {
@@ -1310,6 +1369,7 @@ static void __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 	uint64_t fsize;
 
 	range_size = min(td->o.min_bs[DDIR_READ], td->o.min_bs[DDIR_WRITE]);
+	range_size = min((unsigned long long)range_size, td->o.min_bs[DDIR_COPY]);
 	fsize = min(f->real_file_size, f->io_size);
 
 	nranges = (fsize + range_size - 1ULL) / range_size;
@@ -1956,6 +2016,7 @@ void fio_file_reset(struct thread_data *td, struct fio_file *f)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		f->last_pos[i] = f->file_offset;
 		f->last_start[i] = -1ULL;
+		f->last_pos_dest[i] = f->file_dest_offset;
 	}
 
 	if (fio_file_axmap(f))
diff --git a/fio.h b/fio.h
index fffec001..5c1a7c88 100644
--- a/fio.h
+++ b/fio.h
@@ -70,6 +70,14 @@
 
 struct fio_sem;
 
+/*
+ * Source range data for copy command
+ */
+struct source_range {
+       uint64_t  start;
+       uint64_t  len;
+};
+
 /*
  * offset generator types
  */
@@ -123,6 +131,7 @@ enum {
 	FIO_RAND_BS_OFF		= 0,
 	FIO_RAND_BS1_OFF,
 	FIO_RAND_BS2_OFF,
+	FIO_RAND_BS3_OFF,
 	FIO_RAND_VER_OFF,
 	FIO_RAND_MIX_OFF,
 	FIO_RAND_FILE_OFF,
@@ -133,6 +142,7 @@ enum {
 	FIO_RAND_SEQ_RAND_READ_OFF,
 	FIO_RAND_SEQ_RAND_WRITE_OFF,
 	FIO_RAND_SEQ_RAND_TRIM_OFF,
+	FIO_RAND_SEQ_RAND_COPY_OFF,
 	FIO_RAND_START_DELAY,
 	FIO_DEDUPE_OFF,
 	FIO_RAND_POISSON_OFF,
@@ -774,6 +784,7 @@ static inline unsigned long long td_max_bs(struct thread_data *td)
 	unsigned long long max_bs;
 
 	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
+	max_bs = max(td->o.max_bs[DDIR_COPY], max_bs);
 	return max(td->o.max_bs[DDIR_TRIM], max_bs);
 }
 
@@ -782,6 +793,7 @@ static inline unsigned long long td_min_bs(struct thread_data *td)
 	unsigned long long min_bs;
 
 	min_bs = min(td->o.min_bs[DDIR_READ], td->o.min_bs[DDIR_WRITE]);
+	min_bs = min(td->o.min_bs[DDIR_COPY], min_bs);
 	return min(td->o.min_bs[DDIR_TRIM], min_bs);
 }
 
diff --git a/init.c b/init.c
index f9c20bdb..e5835b7b 100644
--- a/init.c
+++ b/init.c
@@ -592,8 +592,10 @@ static int fixed_block_size(struct thread_options *o)
 	return o->min_bs[DDIR_READ] == o->max_bs[DDIR_READ] &&
 		o->min_bs[DDIR_WRITE] == o->max_bs[DDIR_WRITE] &&
 		o->min_bs[DDIR_TRIM] == o->max_bs[DDIR_TRIM] &&
+		o->min_bs[DDIR_COPY] == o->max_bs[DDIR_COPY] &&
 		o->min_bs[DDIR_READ] == o->min_bs[DDIR_WRITE] &&
-		o->min_bs[DDIR_READ] == o->min_bs[DDIR_TRIM];
+		o->min_bs[DDIR_READ] == o->min_bs[DDIR_TRIM] &&
+		o->min_bs[DDIR_READ] == o->min_bs[DDIR_COPY];
 }
 
 /*
@@ -616,8 +618,8 @@ static int fixup_options(struct thread_data *td)
 	struct thread_options *o = &td->o;
 	int ret = 0;
 
-	if (read_only && (td_write(td) || td_trim(td))) {
-		log_err("fio: trim and write operations are not allowed"
+	if (read_only && (td_write(td) || td_trim(td) || td_copy(td))) {
+		log_err("fio: trim, copy and write operations are not allowed"
 			 " with the --readonly parameter.\n");
 		ret |= 1;
 	}
@@ -670,9 +672,9 @@ static int fixup_options(struct thread_data *td)
 		o->zone_range = o->zone_size;
 
 	/*
-	 * Reads can do overwrites, we always need to pre-create the file
+	 * Reads and copies can do overwrites, we always need to pre-create the file
 	 */
-	if (td_read(td))
+	if (td_read(td) && td_copy(td))
 		o->overwrite = 1;
 
 	for_each_rw_ddir(ddir) {
@@ -697,7 +699,8 @@ static int fixup_options(struct thread_data *td)
 
 	if ((o->ba[DDIR_READ] != o->min_bs[DDIR_READ] ||
 	    o->ba[DDIR_WRITE] != o->min_bs[DDIR_WRITE] ||
-	    o->ba[DDIR_TRIM] != o->min_bs[DDIR_TRIM]) &&
+	    o->ba[DDIR_TRIM] != o->min_bs[DDIR_TRIM] ||
+	    o->ba[DDIR_COPY] != o->min_bs[DDIR_COPY]) &&
 	    !o->norandommap) {
 		log_err("fio: Any use of blockalign= turns off randommap\n");
 		o->norandommap = 1;
@@ -765,10 +768,10 @@ static int fixup_options(struct thread_data *td)
 	if (o->open_files > o->nr_files || !o->open_files)
 		o->open_files = o->nr_files;
 
-	if (((o->rate[DDIR_READ] + o->rate[DDIR_WRITE] + o->rate[DDIR_TRIM]) &&
-	    (o->rate_iops[DDIR_READ] + o->rate_iops[DDIR_WRITE] + o->rate_iops[DDIR_TRIM])) ||
-	    ((o->ratemin[DDIR_READ] + o->ratemin[DDIR_WRITE] + o->ratemin[DDIR_TRIM]) &&
-	    (o->rate_iops_min[DDIR_READ] + o->rate_iops_min[DDIR_WRITE] + o->rate_iops_min[DDIR_TRIM]))) {
+	if (((o->rate[DDIR_READ] + o->rate[DDIR_WRITE] + o->rate[DDIR_TRIM] + o->rate[DDIR_COPY]) &&
+	    (o->rate_iops[DDIR_READ] + o->rate_iops[DDIR_WRITE] + o->rate_iops[DDIR_TRIM] + o->rate_iops[DDIR_COPY])) ||
+	    ((o->ratemin[DDIR_READ] + o->ratemin[DDIR_WRITE] + o->ratemin[DDIR_TRIM] + o->ratemin[DDIR_COPY]) &&
+	    (o->rate_iops_min[DDIR_READ] + o->rate_iops_min[DDIR_WRITE] + o->rate_iops_min[DDIR_TRIM] + o->rate_iops_min[DDIR_COPY]))) {
 		log_err("fio: rate and rate_iops are mutually exclusive\n");
 		ret |= 1;
 	}
@@ -1000,6 +1003,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	uint64_t read_seed = td->rand_seeds[FIO_RAND_BS_OFF];
 	uint64_t write_seed = td->rand_seeds[FIO_RAND_BS1_OFF];
 	uint64_t trim_seed = td->rand_seeds[FIO_RAND_BS2_OFF];
+	uint64_t copy_seed = td->rand_seeds[FIO_RAND_BS3_OFF];
 	int i;
 
 	/*
@@ -1017,6 +1021,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->bsrange_state[DDIR_READ], read_seed, use64);
 	init_rand_seed(&td->bsrange_state[DDIR_WRITE], write_seed, use64);
 	init_rand_seed(&td->bsrange_state[DDIR_TRIM], trim_seed, use64);
+	init_rand_seed(&td->bsrange_state[DDIR_COPY], copy_seed, use64);
 
 	td_fill_verify_state_seed(td);
 	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], false);
@@ -1675,7 +1680,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 				fio_server_send_add_job(td);
 
 			if (!td_ioengine_flagged(td, FIO_NOIO)) {
-				char *c1, *c2, *c3, *c4;
+				char *c1, *c2, *c3, *c4, *c7, *c8;
 				char *c5 = NULL, *c6 = NULL;
 				int i2p = is_power_of_2(o->kb_base);
 				struct buf_output out;
@@ -1684,6 +1689,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 				c2 = num2str(o->max_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
 				c3 = num2str(o->min_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
 				c4 = num2str(o->max_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
+				c7 = num2str(o->min_bs[DDIR_COPY], o->sig_figs, 1, i2p, N2S_BYTE);
+				c8 = num2str(o->max_bs[DDIR_COPY], o->sig_figs, 1, i2p, N2S_BYTE);
 
 				if (!o->bs_is_seq_rand) {
 					c5 = num2str(o->min_bs[DDIR_TRIM], o->sig_figs, 1, i2p, N2S_BYTE);
@@ -1696,11 +1703,11 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 							ddir_str(o->td_ddir));
 
 				if (o->bs_is_seq_rand)
-					__log_buf(&out, "bs=(R) %s-%s, (W) %s-%s, bs_is_seq_rand, ",
-							c1, c2, c3, c4);
+					__log_buf(&out, "bs=(R) %s-%s, (W) %s-%s, (C) %s-%s, bs_is_seq_rand, ",
+							c1, c2, c3, c4, c7, c8);
 				else
-					__log_buf(&out, "bs=(R) %s-%s, (W) %s-%s, (T) %s-%s, ",
-							c1, c2, c3, c4, c5, c6);
+					__log_buf(&out, "bs=(R) %s-%s, (W) %s-%s, (T) %s-%s, (C) %s-%s, ",
+							c1, c2, c3, c4, c5, c6, c7, c8);
 
 				__log_buf(&out, "ioengine=%s, iodepth=%u\n",
 						td->io_ops->name, o->iodepth);
@@ -1713,6 +1720,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 				free(c4);
 				free(c5);
 				free(c6);
+				free(c7);
+				free(c8);
 			}
 		} else if (job_add_num == 1)
 			log_info("...\n");
diff --git a/io_u.c b/io_u.c
index f30fc037..83c7960a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -405,6 +405,29 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	return 1;
 }
 
+static void get_next_dest_seq_offset(struct thread_data *td, struct fio_file *f,
+				     enum fio_ddir ddir, uint64_t num_range,
+				     uint64_t *offset)
+{
+	struct thread_options *o = &td->o;
+
+	assert(ddir_rw(ddir));
+
+	if (f->last_pos_dest[ddir] >= f->io_size + f->file_dest_offset &&
+	    o->time_based) {
+		f->last_pos_dest[ddir] =  f->file_dest_offset;
+		loop_cache_invalidate(td, f);
+	}
+	*offset = f->last_pos_dest[ddir];
+	if (f->last_pos_dest[ddir] >= f->real_file_size)
+		f->last_pos_dest[ddir] = f->file_dest_offset;
+	else {
+		f->last_pos_dest[ddir] += (num_range) * (td->o.bs[ddir]);
+		if (f->last_pos_dest[ddir] >= f->real_file_size)
+			f->last_pos_dest[ddir] =  f->file_dest_offset;
+	}
+}
+
 static int get_next_block(struct thread_data *td, struct io_u *io_u,
 			  enum fio_ddir ddir, int rw_seq,
 			  bool *is_random)
@@ -752,6 +775,8 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 		ddir = DDIR_WRITE;
 	else if (td_trim(td))
 		ddir = DDIR_TRIM;
+	else if (td_copy(td))
+		ddir = DDIR_COPY;
 	else
 		ddir = DDIR_INVAL;
 
@@ -905,8 +930,12 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	bool is_random;
-	uint64_t offset;
+	uint64_t offset, dest_offset, i = 0;
 	enum io_u_action ret;
+	struct fio_file *f = io_u->file;
+	enum fio_ddir ddir = io_u->ddir;
+	uint8_t *buf_point;
+	struct source_range entry;
 
 	if (td_ioengine_flagged(td, FIO_NOIO))
 		goto out;
@@ -928,22 +957,52 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	else if (td->o.zone_mode == ZONE_MODE_ZBD)
 		setup_zbd_zone_mode(td, io_u);
 
-	/*
-	 * No log, let the seq/rand engine retrieve the next buflen and
-	 * position.
-	 */
-	if (get_next_offset(td, io_u, &is_random)) {
-		dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
-		return 1;
-	}
+	if (io_u->ddir == DDIR_COPY) {
+		buf_point = io_u->buf;
+		offset = 0;
 
-	io_u->buflen = get_next_buflen(td, io_u, is_random);
-	if (!io_u->buflen) {
-		dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
-		return 1;
+		while (i < td->o.num_range) {
+			if (get_next_offset(td, io_u, &is_random)) {
+				dprint(FD_IO, "io_u %p, failed getting offset\n",
+				       io_u);
+				return 1;
+			}
+
+			offset = io_u->offset;
+			entry.start = offset;
+			entry.len = td->o.bs[ddir];
+			memcpy(buf_point, &entry, sizeof(struct source_range));
+			buf_point += sizeof(struct source_range);
+			f->last_start[io_u->ddir] = io_u->offset;
+			f->last_pos[io_u->ddir] = io_u->offset + entry.len;
+			i++;
+
+			if (td_random(td) && file_randommap(td, io_u->file))
+				mark_random_map(td, io_u, offset, td->o.bs[ddir]);
+		}
+		get_next_dest_seq_offset(td, f, io_u->ddir, td->o.num_range, &dest_offset);
+		io_u->offset = dest_offset;
+
+		io_u->buflen = i * sizeof(struct source_range);
+	} else {
+		/*
+		 * No log, let the seq/rand engine retrieve the next buflen and
+		 * position.
+		 */
+		if (get_next_offset(td, io_u, &is_random)) {
+			dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
+			return 1;
+		}
+
+		io_u->buflen = get_next_buflen(td, io_u, is_random);
+		if (!io_u->buflen) {
+			dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
+			return 1;
+		}
+
+		offset = io_u->offset;
 	}
 
-	offset = io_u->offset;
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
 		ret = zbd_adjust_block(td, io_u);
 		if (ret == io_u_eof)
@@ -961,13 +1020,16 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * mark entry before potentially trimming io_u
 	 */
-	if (td_random(td) && file_randommap(td, io_u->file))
+	if (!(io_u->ddir == DDIR_COPY) && td_random(td) && file_randommap(td, io_u->file))
 		io_u->buflen = mark_random_map(td, io_u, offset, io_u->buflen);
 
 out:
 	dprint_io_u(io_u, "fill");
 	io_u->verify_offset = io_u->offset;
-	td->zone_bytes += io_u->buflen;
+	if (!(io_u->ddir == DDIR_COPY))
+		td->zone_bytes += io_u->buflen;
+	else
+		td->zone_bytes += (td->o.num_range * td->o.bs[DDIR_COPY]);
 	return 0;
 }
 
@@ -1759,7 +1821,7 @@ struct io_u *get_io_u(struct thread_data *td)
 
 	assert(fio_file_open(f));
 
-	if (ddir_rw(io_u->ddir)) {
+	if (ddir_rw(io_u->ddir) && !(io_u->ddir == DDIR_COPY)) {
 		if (!io_u->buflen && !td_ioengine_flagged(td, FIO_NOIO)) {
 			dprint(FD_IO, "get_io_u: zero buflen on %p\n", io_u);
 			goto err_put;
@@ -1982,9 +2044,14 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	td->last_ddir = ddir;
 
 	if (!io_u->error && ddir_rw(ddir)) {
-		unsigned long long bytes = io_u->xfer_buflen - io_u->resid;
+		unsigned long long bytes;
 		int ret;
 
+		if (io_u->ddir == DDIR_COPY)
+			bytes = (((io_u->xfer_buflen) * td->o.bs[DDIR_COPY]) /
+						   sizeof(struct source_range));
+		else
+			bytes = io_u->xfer_buflen - io_u->resid;
 		/*
 		 * Make sure we notice short IO from here, and requeue them
 		 * appropriately!
diff --git a/rate-submit.c b/rate-submit.c
index 13dbe7a2..de99906e 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -269,6 +269,8 @@ static void io_workqueue_update_acct_fn(struct submit_worker *sw)
 		sum_ddir(dst, src, DDIR_WRITE);
 	if (td_trim(src))
 		sum_ddir(dst, src, DDIR_TRIM);
+	if (td_copy(src))
+		sum_ddir(dst, src, DDIR_COPY);
 
 }
 
diff --git a/zbd.c b/zbd.c
index 9327816a..58fed98e 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1682,6 +1682,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_LAST:
 	case DDIR_INVAL:
 		goto accept;
+	case DDIR_COPY:
+		goto eof;
 	}
 
 	assert(false);
-- 
2.17.1


