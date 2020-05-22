Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgEVMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 May 2020 08:00:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F27C061A0E
        for <fio@vger.kernel.org>; Fri, 22 May 2020 05:00:13 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jc6LV-00005l-3n
        for fio@vger.kernel.org; Fri, 22 May 2020 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200522120002.311AD1BC0183@kernel.dk>
Date: Fri, 22 May 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0e21f5c6f64a73bcede20e1a29a885845e453b8e:

  Merge branch 'testing' of https://github.com/vincentkfu/fio (2020-05-20 14:19:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1bb1bcade4acbd3cf69ba1c825ad01eebf0b3cdf:

  zbd: make zbd_info->mutex non-recursive (2020-05-21 17:23:13 -0600)

----------------------------------------------------------------
Alexey Dobriyan (5):
      verify: decouple seed generation from buffer fill
      zbd: bump ZBD_MAX_OPEN_ZONES
      zbd: don't lock zones outside working area
      zbd: introduce per job maximum open zones limit
      zbd: make zbd_info->mutex non-recursive

Jens Axboe (1):
      Merge branch 'latency_run' of https://github.com/liu-song-6/fio

Song Liu (1):
      Add option latency_run to continue enable latency_target

 HOWTO            |   7 ++++
 backend.c        |   6 ---
 cconv.c          |   2 +
 file.h           |   3 ++
 fio.1            |  11 +++++-
 fio.h            |   2 +
 io_u.c           |  18 ++++++++-
 options.c        |  26 +++++++++++--
 server.h         |   2 +-
 thread_options.h |   3 ++
 verify.c         |  20 ++++------
 zbd.c            | 110 ++++++++++++++++++++++++++++++++++++++-----------------
 zbd.h            |   3 ++
 zbd_types.h      |   2 +-
 14 files changed, 155 insertions(+), 60 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cd628552..9e71a619 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2552,6 +2552,13 @@ I/O latency
 	defaults to 100.0, meaning that all I/Os must be equal or below to the value
 	set by :option:`latency_target`.
 
+.. option:: latency_run=bool
+
+	Used with :option:`latency_target`. If false (default), fio will find
+	the highest queue depth that meets :option:`latency_target` and exit. If
+	true, fio will continue running and try to meet :option:`latency_target`
+	by adjusting queue depth.
+
 .. option:: max_latency=time
 
 	If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
diff --git a/backend.c b/backend.c
index f519728c..0075a733 100644
--- a/backend.c
+++ b/backend.c
@@ -1006,12 +1006,6 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ &&
 		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
 
-			if (!td->o.verify_pattern_bytes) {
-				io_u->rand_seed = __rand(&td->verify_state);
-				if (sizeof(int) != sizeof(long *))
-					io_u->rand_seed *= __rand(&td->verify_state);
-			}
-
 			if (verify_state_should_stop(td, io_u)) {
 				put_io_u(td, io_u);
 				break;
diff --git a/cconv.c b/cconv.c
index 48218dc4..449bcf7b 100644
--- a/cconv.c
+++ b/cconv.c
@@ -288,6 +288,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->latency_window = le64_to_cpu(top->latency_window);
 	o->max_latency = le64_to_cpu(top->max_latency);
 	o->latency_percentile.u.f = fio_uint64_to_double(le64_to_cpu(top->latency_percentile.u.i));
+	o->latency_run = le32_to_cpu(top->latency_run);
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
 	o->compress_chunk = le32_to_cpu(top->compress_chunk);
 	o->dedupe_percentage = le32_to_cpu(top->dedupe_percentage);
@@ -487,6 +488,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->latency_window = __cpu_to_le64(o->latency_window);
 	top->max_latency = __cpu_to_le64(o->max_latency);
 	top->latency_percentile.u.i = __cpu_to_le64(fio_double_to_uint64(o->latency_percentile.u.f));
+	top->latency_run = __cpu_to_le32(o->latency_run);
 	top->compress_percentage = cpu_to_le32(o->compress_percentage);
 	top->compress_chunk = cpu_to_le32(o->compress_chunk);
 	top->dedupe_percentage = cpu_to_le32(o->dedupe_percentage);
diff --git a/file.h b/file.h
index ae0e6fc8..375bbfd3 100644
--- a/file.h
+++ b/file.h
@@ -104,6 +104,9 @@ struct fio_file {
 	 * Zoned block device information. See also zonemode=zbd.
 	 */
 	struct zoned_block_device_info *zbd_info;
+	/* zonemode=zbd working area */
+	uint32_t min_zone;	/* inclusive */
+	uint32_t max_zone;	/* exclusive */
 
 	/*
 	 * Track last end and last start of IO for a given data direction
diff --git a/fio.1 b/fio.1
index 9e9e1b1a..47bc1592 100644
--- a/fio.1
+++ b/fio.1
@@ -804,7 +804,11 @@ so. Default: false.
 When running a random write test across an entire drive many more zones will be
 open than in a typical application workload. Hence this command line option
 that allows to limit the number of open zones. The number of open zones is
-defined as the number of zones to which write commands are issued.
+defined as the number of zones to which write commands are issued by all
+threads/processes.
+.TP
+.BI job_max_open_zones \fR=\fPint
+Limit on the number of simultaneously opened zones per single thread/process.
 .TP
 .BI zone_reset_threshold \fR=\fPfloat
 A number between zero and one that indicates the ratio of logical blocks with
@@ -2276,6 +2280,11 @@ The percentage of I/Os that must fall within the criteria specified by
 defaults to 100.0, meaning that all I/Os must be equal or below to the value
 set by \fBlatency_target\fR.
 .TP
+.BI latency_run \fR=\fPbool
+Used with \fBlatency_target\fR. If false (default), fio will find the highest
+queue depth that meets \fBlatency_target\fR and exit. If true, fio will continue
+running and try to meet \fBlatency_target\fR by adjusting queue depth.
+.TP
 .BI max_latency \fR=\fPtime
 If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
 maximum latency. When the unit is omitted, the value is interpreted in
diff --git a/fio.h b/fio.h
index dbdfdf86..8045c32f 100644
--- a/fio.h
+++ b/fio.h
@@ -260,6 +260,7 @@ struct thread_data {
 	struct frand_state prio_state;
 
 	struct zone_split_index **zone_state_index;
+	unsigned int num_open_zones;
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
@@ -377,6 +378,7 @@ struct thread_data {
 	unsigned int latency_qd_high;
 	unsigned int latency_qd_low;
 	unsigned int latency_failed;
+	unsigned int latency_stable_count;
 	uint64_t latency_ios;
 	int latency_end_run;
 
diff --git a/io_u.c b/io_u.c
index aa8808b8..ae1438fd 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1391,6 +1391,7 @@ static bool __lat_target_failed(struct thread_data *td)
 		td->latency_qd_low--;
 
 	td->latency_qd = (td->latency_qd + td->latency_qd_low) / 2;
+	td->latency_stable_count = 0;
 
 	dprint(FD_RATE, "Ramped down: %d %d %d\n", td->latency_qd_low, td->latency_qd, td->latency_qd_high);
 
@@ -1440,6 +1441,21 @@ static void lat_target_success(struct thread_data *td)
 
 	td->latency_qd_low = td->latency_qd;
 
+	if (td->latency_qd + 1 == td->latency_qd_high) {
+		/*
+		 * latency_qd will not incease on lat_target_success(), so
+		 * called stable. If we stick with this queue depth, the
+		 * final latency is likely lower than latency_target. Fix
+		 * this by increasing latency_qd_high slowly. Use a naive
+		 * heuristic here. If we get lat_target_success() 3 times
+		 * in a row, increase latency_qd_high by 1.
+		 */
+		if (++td->latency_stable_count >= 3) {
+			td->latency_qd_high++;
+			td->latency_stable_count = 0;
+		}
+	}
+
 	/*
 	 * If we haven't failed yet, we double up to a failing value instead
 	 * of bisecting from highest possible queue depth. If we have set
@@ -1459,7 +1475,7 @@ static void lat_target_success(struct thread_data *td)
 	 * Same as last one, we are done. Let it run a latency cycle, so
 	 * we get only the results from the targeted depth.
 	 */
-	if (td->latency_qd == qd) {
+	if (!o->latency_run && td->latency_qd == qd) {
 		if (td->latency_end_run) {
 			dprint(FD_RATE, "We are done\n");
 			td->done = 1;
diff --git a/options.c b/options.c
index b18cea33..f2d98fa6 100644
--- a/options.c
+++ b/options.c
@@ -3360,12 +3360,22 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "max_open_zones",
-		.lname	= "Maximum number of open zones",
+		.lname	= "Per device/file maximum number of open zones",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, max_open_zones),
 		.maxval	= ZBD_MAX_OPEN_ZONES,
-		.help	= "Limit random writes to SMR drives to the specified"
-			  " number of sequential zones",
+		.help	= "Limit on the number of simultaneously opened sequential write zones with zonemode=zbd",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "job_max_open_zones",
+		.lname	= "Job maximum number of open zones",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, job_max_open_zones),
+		.maxval	= ZBD_MAX_OPEN_ZONES,
+		.help	= "Limit on the number of simultaneously opened sequential write zones with zonemode=zbd by one thread/process",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
@@ -3672,6 +3682,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_LATPROF,
 	},
+	{
+		.name	= "latency_run",
+		.lname	= "Latency Run",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, latency_run),
+		.help	= "Keep adjusting queue depth to match latency_target",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_LATPROF,
+	},
 	{
 		.name	= "invalidate",
 		.lname	= "Cache invalidate",
diff --git a/server.h b/server.h
index 279b6917..de01a5c8 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 82,
+	FIO_SERVER_VER			= 83,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index c78ed43d..968ea0ab 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -324,6 +324,7 @@ struct thread_options {
 	unsigned long long latency_target;
 	unsigned long long latency_window;
 	fio_fp64_t latency_percentile;
+	uint32_t latency_run;
 
 	unsigned int sig_figs;
 
@@ -342,6 +343,7 @@ struct thread_options {
 	/* Parameters that affect zonemode=zbd */
 	unsigned int read_beyond_wp;
 	int max_open_zones;
+	unsigned int job_max_open_zones;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 };
@@ -612,6 +614,7 @@ struct thread_options_pack {
 	uint64_t latency_window;
 	uint64_t max_latency;
 	fio_fp64_t latency_percentile;
+	uint32_t latency_run;
 
 	uint32_t sig_figs;
 
diff --git a/verify.c b/verify.c
index cf299ebf..b7fa6693 100644
--- a/verify.c
+++ b/verify.c
@@ -46,15 +46,6 @@ static void __fill_buffer(struct thread_options *o, uint64_t seed, void *p,
 	__fill_random_buf_percentage(seed, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
 }
 
-static uint64_t fill_buffer(struct thread_data *td, void *p,
-			    unsigned int len)
-{
-	struct frand_state *fs = &td->verify_state;
-	struct thread_options *o = &td->o;
-
-	return fill_random_buf_percentage(fs, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
-}
-
 void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 			 struct io_u *io_u, uint64_t seed, int use_seed)
 {
@@ -63,10 +54,13 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 	if (!o->verify_pattern_bytes) {
 		dprint(FD_VERIFY, "fill random bytes len=%u\n", len);
 
-		if (use_seed)
-			__fill_buffer(o, seed, p, len);
-		else
-			io_u->rand_seed = fill_buffer(td, p, len);
+		if (!use_seed) {
+			seed = __rand(&td->verify_state);
+			if (sizeof(int) != sizeof(long *))
+				seed *= (unsigned long)__rand(&td->verify_state);
+		}
+		io_u->rand_seed = seed;
+		__fill_buffer(o, seed, p, len);
 		return;
 	}
 
diff --git a/zbd.c b/zbd.c
index 36de29fb..72352db0 100644
--- a/zbd.c
+++ b/zbd.c
@@ -156,8 +156,14 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 		z->wp + required > z->start + f->zbd_info->zone_size;
 }
 
-static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
+static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zone_info *z)
 {
+	struct zoned_block_device_info *zbd = f->zbd_info;
+	uint32_t nz = z - zbd->zone_info;
+
+	/* A thread should never lock zones outside its working area. */
+	assert(f->min_zone <= nz && nz < f->max_zone);
+
 	/*
 	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
 	 * is changed or when io_u completes and zbd_put_io() executed.
@@ -291,6 +297,9 @@ static bool zbd_verify_sizes(void)
 					 (unsigned long long) new_end - f->file_offset);
 				f->io_size = new_end - f->file_offset;
 			}
+
+			f->min_zone = zbd_zone_idx(f, f->file_offset);
+			f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
 		}
 	}
 
@@ -366,9 +375,9 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		return -ENOMEM;
 
 	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	pthread_mutexattr_setpshared(&attr, true);
 	pthread_mutex_init(&zbd_info->mutex, &attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (i = 0; i < nr_zones; i++, p++) {
@@ -410,7 +419,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	int i, j, ret = 0;
 
 	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	pthread_mutexattr_setpshared(&attr, true);
 
 	zones = calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));
@@ -447,6 +455,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	if (!zbd_info)
 		goto out;
 	pthread_mutex_init(&zbd_info->mutex, &attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (offset = 0, j = 0; j < nr_zones;) {
@@ -539,8 +548,10 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 		return -EINVAL;
 	}
 
-	if (ret == 0)
+	if (ret == 0) {
 		f->zbd_info->model = zbd_model;
+		f->zbd_info->max_open_zones = td->o.max_open_zones;
+	}
 	return ret;
 }
 
@@ -614,6 +625,25 @@ int zbd_setup_files(struct thread_data *td)
 	if (!zbd_verify_bs())
 		return 1;
 
+	for_each_file(td, f, i) {
+		struct zoned_block_device_info *zbd = f->zbd_info;
+
+		if (!zbd)
+			continue;
+
+		zbd->max_open_zones = zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;
+
+		if (td->o.max_open_zones > 0 &&
+		    zbd->max_open_zones != td->o.max_open_zones) {
+			log_err("Different 'max_open_zones' values\n");
+			return 1;
+		}
+		if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
+			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZONES);
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -701,6 +731,7 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
 		sizeof(f->zbd_info->open_zones[0]));
 	f->zbd_info->num_open_zones--;
+	td->num_open_zones--;
 	f->zbd_info->zone_info[zone_idx].open = 0;
 }
 
@@ -731,7 +762,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 		if (!zbd_zone_swr(z))
 			continue;
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (all_zones) {
 			unsigned int i;
 
@@ -763,14 +794,20 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
  * Reset zbd_info.write_cnt, the counter that counts down towards the next
  * zone reset.
  */
-static void zbd_reset_write_cnt(const struct thread_data *td,
-				const struct fio_file *f)
+static void _zbd_reset_write_cnt(const struct thread_data *td,
+				 const struct fio_file *f)
 {
 	assert(0 <= td->o.zrf.u.f && td->o.zrf.u.f <= 1);
 
-	pthread_mutex_lock(&f->zbd_info->mutex);
 	f->zbd_info->write_cnt = td->o.zrf.u.f ?
 		min(1.0 / td->o.zrf.u.f, 0.0 + UINT_MAX) : UINT_MAX;
+}
+
+static void zbd_reset_write_cnt(const struct thread_data *td,
+				const struct fio_file *f)
+{
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	_zbd_reset_write_cnt(td, f);
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 }
 
@@ -784,7 +821,7 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	if (f->zbd_info->write_cnt)
 		write_cnt = --f->zbd_info->write_cnt;
 	if (write_cnt == 0)
-		zbd_reset_write_cnt(td, f);
+		_zbd_reset_write_cnt(td, f);
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	return write_cnt == 0;
@@ -854,14 +891,12 @@ static void zbd_init_swd(struct fio_file *f)
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
-	uint32_t zone_idx_e;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
 
-	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
-	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
-	ze = &f->zbd_info->zone_info[zone_idx_e];
+	zb = &f->zbd_info->zone_info[f->min_zone];
+	ze = &f->zbd_info->zone_info[f->max_zone];
 	zbd_init_swd(f);
 	/*
 	 * If data verification is enabled reset the affected zones before
@@ -880,8 +915,9 @@ static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	int i;
 
-	assert(td->o.max_open_zones <= ARRAY_SIZE(zbdi->open_zones));
-	assert(zbdi->num_open_zones <= td->o.max_open_zones);
+	assert(td->o.job_max_open_zones == 0 || td->num_open_zones <= td->o.job_max_open_zones);
+	assert(td->o.job_max_open_zones <= zbdi->max_open_zones);
+	assert(zbdi->num_open_zones <= zbdi->max_open_zones);
 
 	for (i = 0; i < zbdi->num_open_zones; i++)
 		if (zbdi->open_zones[i] == zone_idx)
@@ -914,18 +950,19 @@ static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
 	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
 		return false;
 
-	/* Zero means no limit */
-	if (!td->o.max_open_zones)
-		return true;
-
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	if (is_zone_open(td, f, zone_idx))
 		goto out;
 	res = false;
-	if (f->zbd_info->num_open_zones >= td->o.max_open_zones)
+	/* Zero means no limit */
+	if (td->o.job_max_open_zones > 0 &&
+	    td->num_open_zones >= td->o.job_max_open_zones)
+		goto out;
+	if (f->zbd_info->num_open_zones >= f->zbd_info->max_open_zones)
 		goto out;
 	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
 	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] = zone_idx;
+	td->num_open_zones++;
 	z->open = 1;
 	res = true;
 
@@ -952,7 +989,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 						      struct io_u *io_u)
 {
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
-	const struct fio_file *f = io_u->file;
+	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z;
 	unsigned int open_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
@@ -960,7 +997,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (td->o.max_open_zones) {
+	if (td->o.job_max_open_zones) {
 		/*
 		 * This statement accesses f->zbd_info->open_zones[] on purpose
 		 * without locking.
@@ -969,6 +1006,10 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	} else {
 		zone_idx = zbd_zone_idx(f, io_u->offset);
 	}
+	if (zone_idx < f->min_zone)
+		zone_idx = f->min_zone;
+	else if (zone_idx >= f->max_zone)
+		zone_idx = f->max_zone - 1;
 	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
 	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
 
@@ -983,9 +1024,9 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		if (td->o.max_open_zones == 0)
+		if (td->o.job_max_open_zones == 0)
 			goto examine_zone;
 		if (f->zbd_info->num_open_zones == 0) {
 			pthread_mutex_unlock(&f->zbd_info->mutex);
@@ -1009,8 +1050,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 			if (tmp_idx >= f->zbd_info->num_open_zones)
 				tmp_idx = 0;
 			tmpz = f->zbd_info->open_zones[tmp_idx];
-
-			if (is_valid_offset(f, f->zbd_info->zone_info[tmpz].start)) {
+			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
 				open_zone_idx = tmp_idx;
 				goto found_candidate_zone;
 			}
@@ -1042,7 +1082,7 @@ examine_zone:
 	}
 	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
 	       zone_idx);
-	if (td->o.max_open_zones)
+	if (td->o.job_max_open_zones)
 		zbd_close_zone(td, f, open_zone_idx);
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
@@ -1055,11 +1095,11 @@ examine_zone:
 		z++;
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
-			zone_idx = zbd_zone_idx(f, f->file_offset);
+			zone_idx = f->min_zone;
 			z = &f->zbd_info->zone_info[zone_idx];
 		}
 		assert(is_valid_offset(f, z->start));
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (z->open)
 			continue;
 		if (zbd_open_zone(td, io_u, zone_idx))
@@ -1072,12 +1112,14 @@ examine_zone:
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	for (i = 0; i < f->zbd_info->num_open_zones; i++) {
 		zone_idx = f->zbd_info->open_zones[i];
+		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
+			continue;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		pthread_mutex_unlock(&z->mutex);
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (z->wp + min_bs <= (z+1)->start)
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
@@ -1129,7 +1171,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	      struct fio_zone_info *zb, struct fio_zone_info *zl)
 {
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
-	const struct fio_file *f = io_u->file;
+	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z1, *z2;
 	const struct fio_zone_info *const zf =
 		&f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
@@ -1140,7 +1182,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	 */
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
 		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
-			zone_lock(td, z1);
+			zone_lock(td, f, z1);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
 			pthread_mutex_unlock(&z1->mutex);
@@ -1149,7 +1191,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		}
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
-			zone_lock(td, z2);
+			zone_lock(td, f, z2);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
 			pthread_mutex_unlock(&z2->mutex);
@@ -1401,7 +1443,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	zbd_check_swd(f);
 
-	zone_lock(td, zb);
+	zone_lock(td, f, zb);
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
diff --git a/zbd.h b/zbd.h
index e8dd3d6d..9c447af4 100644
--- a/zbd.h
+++ b/zbd.h
@@ -45,6 +45,8 @@ struct fio_zone_info {
 /**
  * zoned_block_device_info - zoned block device characteristics
  * @model: Device model.
+ * @max_open_zones: global limit on the number of simultaneously opened
+ *	sequential write zones.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in units of 512 bytes
@@ -65,6 +67,7 @@ struct fio_zone_info {
  */
 struct zoned_block_device_info {
 	enum zbd_zoned_model	model;
+	uint32_t		max_open_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		sectors_with_data;
diff --git a/zbd_types.h b/zbd_types.h
index 2f2f1324..d63c0d0a 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -8,7 +8,7 @@
 
 #include <inttypes.h>
 
-#define ZBD_MAX_OPEN_ZONES	128
+#define ZBD_MAX_OPEN_ZONES	4096
 
 /*
  * Zoned block device models.

