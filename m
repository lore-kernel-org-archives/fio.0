Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcHPMcW (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Aug 2016 08:32:22 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bZd2J-000359-HF
	for fio@vger.kernel.org; Tue, 16 Aug 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160816120002.91A4C2C0051@kernel.dk>
Date: Tue, 16 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1651e4310feb3eab7c7c8cf0bd23d159cb410628:

  Only enable atomic io_u flag setting/clearing if we need it (2016-08-14 21:31:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8aa89d70f44eb3fe9d9581fd9bcc3cebca22621b:

  Various cleanups (2016-08-15 23:36:11 -0600)

----------------------------------------------------------------
Jens Axboe (11):
      options: remove dependency of 'o' being first in 'td'
      fio: move thread_options
      fio: inherit IO engine flags to 'td'
      options: pass in right pointer to options free
      Option updates
      Fixup correct sparse warnings
      parse: get rid of __td_var()
      parse: remove dead code
      gfio: fix link error
      gfio: fix auto-start of backend
      Various cleanups

 HOWTO                     |   2 +-
 backend.c                 |  12 +-
 client.c                  |   2 +-
 client.h                  |   5 +-
 diskutil.c                |   2 +-
 engines/e4defrag.c        |   2 +
 engines/glusterfs_async.c |   2 +-
 engines/libhdfs.c         |   6 +-
 engines/mtd.c             |   4 +-
 engines/net.c             |   2 +
 eta.c                     |  14 +-
 file.h                    |   4 +-
 filesetup.c               |  10 +-
 fio.c                     |   2 +
 fio.h                     |  61 +++---
 gclient.c                 |   6 +-
 gfio.c                    |   2 +
 init.c                    |  24 +--
 io_u.c                    |   6 +-
 ioengines.c               |   8 +-
 iolog.c                   |   4 +-
 iolog.h                   |   9 +-
 lib/bloom.c               |   2 +-
 lib/mountcheck.c          |   2 +
 lib/strntol.c             |   2 +
 memory.c                  |   4 +-
 options.c                 | 487 +++++++++++++++++++++++-----------------------
 options.h                 |   5 +-
 oslib/libmtd.c            |   2 +-
 oslib/linux-dev-lookup.c  |   1 +
 oslib/strlcat.c           |   1 +
 parse.c                   |   2 +-
 parse.h                   |  14 +-
 rate-submit.c             |   3 -
 server.c                  |   4 +-
 stat.c                    |  14 +-
 stat.h                    |  12 +-
 verify.c                  |   9 +-
 38 files changed, 392 insertions(+), 361 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 5bf7125..c1b768d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1951,7 +1951,7 @@ be the starting port number since fio will use a range of ports.
 [mtd] skip_bad=bool	Skip operations against known bad blocks.
 
 [libhdfs] hdfsdirectory	libhdfs will create chunk in this HDFS directory
-[libhdfs] chunck_size	the size of the chunck to use for each file.
+[libhdfs] chunk_size	the size of the chunk to use for each file.
 
 
 6.0 Interpreting the output
diff --git a/backend.c b/backend.c
index c051c13..b43486d 100644
--- a/backend.c
+++ b/backend.c
@@ -1024,7 +1024,7 @@ reap:
 		if (ret < 0)
 			break;
 		if (!ddir_rw_sum(td->bytes_done) &&
-		    !(td->io_ops->flags & FIO_NOIO))
+		    !td_ioengine_flagged(td, FIO_NOIO))
 			continue;
 
 		if (!in_ramp_time(td) && should_check_rate(td)) {
@@ -1175,7 +1175,7 @@ static int init_io_u(struct thread_data *td)
 	td->orig_buffer_size = (unsigned long long) max_bs
 					* (unsigned long long) max_units;
 
-	if ((td->io_ops->flags & FIO_NOIO) || !(td_read(td) || td_write(td)))
+	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) || td_write(td)))
 		data_xfer = 0;
 
 	err = 0;
@@ -1195,7 +1195,7 @@ static int init_io_u(struct thread_data *td)
 	 * lucky and the allocator gives us an aligned address.
 	 */
 	if (td->o.odirect || td->o.mem_align || td->o.oatomic ||
-	    (td->io_ops->flags & FIO_RAWIO))
+	    td_ioengine_flagged(td, FIO_RAWIO))
 		td->orig_buffer_size += page_mask + td->o.mem_align;
 
 	if (td->o.mem_type == MEM_SHMHUGE || td->o.mem_type == MEM_MMAPHUGE) {
@@ -1214,7 +1214,7 @@ static int init_io_u(struct thread_data *td)
 		return 1;
 
 	if (td->o.odirect || td->o.mem_align || td->o.oatomic ||
-	    (td->io_ops->flags & FIO_RAWIO))
+	    td_ioengine_flagged(td, FIO_RAWIO))
 		p = PAGE_ALIGN(td->orig_buffer) + td->o.mem_align;
 	else
 		p = td->orig_buffer;
@@ -1288,7 +1288,7 @@ static int switch_ioscheduler(struct thread_data *td)
 	FILE *f;
 	int ret;
 
-	if (td->io_ops->flags & FIO_DISKLESSIO)
+	if (td_ioengine_flagged(td, FIO_DISKLESSIO))
 		return 0;
 
 	sprintf(tmp, "%s/queue/scheduler", td->sysfs_root);
@@ -1748,7 +1748,7 @@ static void *thread_main(void *data)
 
 		if (!o->do_verify ||
 		    o->verify == VERIFY_NONE ||
-		    (td->io_ops->flags & FIO_UNIDIR))
+		    td_ioengine_flagged(td, FIO_UNIDIR))
 			continue;
 
 		clear_io_state(td, 0);
diff --git a/client.c b/client.c
index d502a4b..238c93f 100644
--- a/client.c
+++ b/client.c
@@ -557,7 +557,7 @@ int fio_client_terminate(struct fio_client *client)
 	return fio_net_send_quit(client->fd);
 }
 
-void fio_clients_terminate(void)
+static void fio_clients_terminate(void)
 {
 	struct flist_head *entry;
 	struct fio_client *client;
diff --git a/client.h b/client.h
index ddacf78..fc9c196 100644
--- a/client.h
+++ b/client.h
@@ -131,7 +131,6 @@ extern struct fio_client *fio_client_add_explicit(struct client_ops *, const cha
 extern void fio_client_add_cmd_option(void *, const char *);
 extern int fio_client_add_ini_file(void *, const char *, bool);
 extern int fio_client_terminate(struct fio_client *);
-extern void fio_clients_terminate(void);
 extern struct fio_client *fio_get_client(struct fio_client *);
 extern void fio_put_client(struct fio_client *);
 extern int fio_client_update_options(struct fio_client *, struct thread_options *, uint64_t *);
@@ -145,5 +144,9 @@ enum {
 	FIO_CLIENT_TYPE_GUI		= 2,
 };
 
+extern int sum_stat_clients;
+extern struct thread_stat client_ts;
+extern struct group_run_stats client_gs;
+
 #endif
 
diff --git a/diskutil.c b/diskutil.c
index a1077d4..0f7a642 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -491,7 +491,7 @@ void init_disk_util(struct thread_data *td)
 	unsigned int i;
 
 	if (!td->o.do_disk_util ||
-	    (td->io_ops->flags & (FIO_DISKLESSIO | FIO_NODISKUTIL)))
+	    td_ioengine_flagged(td, FIO_DISKLESSIO | FIO_NODISKUTIL))
 		return;
 
 	for_each_file(td, f, i)
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index c599c98..e53636e 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -45,6 +45,7 @@ struct e4defrag_options {
 static struct fio_option options[] = {
 	{
 		.name	= "donorname",
+		.lname	= "Donor Name",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= offsetof(struct e4defrag_options, donor_name),
 		.help	= "File used as a block donor",
@@ -53,6 +54,7 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "inplace",
+		.lname	= "In Place",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct e4defrag_options, inplace),
 		.minval	= 0,
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 8e42a84..f46cb26 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -137,7 +137,7 @@ failed:
 	return FIO_Q_COMPLETED;
 }
 
-int fio_gf_async_setup(struct thread_data *td)
+static int fio_gf_async_setup(struct thread_data *td)
 {
 	struct gf_data *g;
 	int r;
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index fba17c4..96a0871 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -80,7 +80,9 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_HDFS,
 	},
 	{
-		.name	= "chunck_size",
+		.name	= "chunk_size",
+		.alias	= "chunck_size",
+		.lname	= "Chunk size",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct hdfsio_options, chunck_size),
 		.def    = "1048576",
@@ -90,6 +92,7 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "single_instance",
+		.lname	= "Single Instance",
 		.type	= FIO_OPT_BOOL,
 		.off1	= offsetof(struct hdfsio_options, single_instance),
 		.def    = "1",
@@ -99,6 +102,7 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "hdfs_use_direct",
+		.lname	= "HDFS Use Direct",
 		.type	= FIO_OPT_BOOL,
 		.off1	= offsetof(struct hdfsio_options, use_direct),
 		.def    = "0",
diff --git a/engines/mtd.c b/engines/mtd.c
index 7b92c83..3c22a1b 100644
--- a/engines/mtd.c
+++ b/engines/mtd.c
@@ -16,7 +16,7 @@
 #include "../verify.h"
 #include "../oslib/libmtd.h"
 
-libmtd_t desc;
+static libmtd_t desc;
 
 struct fio_mtd_data {
 	struct mtd_dev_info info;
@@ -168,7 +168,7 @@ static int fio_mtd_close_file(struct thread_data *td, struct fio_file *f)
 	return generic_close_file(td, f);
 }
 
-int fio_mtd_get_file_size(struct thread_data *td, struct fio_file *f)
+static int fio_mtd_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	struct mtd_dev_info info;
 
diff --git a/engines/net.c b/engines/net.c
index f24efc1..5f1401c 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -135,6 +135,7 @@ static struct fio_option options[] = {
 #ifdef CONFIG_TCP_NODELAY
 	{
 		.name	= "nodelay",
+		.lname	= "No Delay",
 		.type	= FIO_OPT_BOOL,
 		.off1	= offsetof(struct netio_options, nodelay),
 		.help	= "Use TCP_NODELAY on TCP connections",
@@ -153,6 +154,7 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "pingpong",
+		.lname	= "Ping Pong",
 		.type	= FIO_OPT_STR_SET,
 		.off1	= offsetof(struct netio_options, pingpong),
 		.help	= "Ping-pong IO requests",
diff --git a/eta.c b/eta.c
index ffab34e..3c1aeee 100644
--- a/eta.c
+++ b/eta.c
@@ -337,7 +337,7 @@ static void calc_iops(int unified_rw_rep, unsigned long mtime,
  * Print status of the jobs we know about. This includes rate estimates,
  * ETA, thread state, etc.
  */
-int calc_thread_status(struct jobs_eta *je, int force)
+bool calc_thread_status(struct jobs_eta *je, int force)
 {
 	struct thread_data *td;
 	int i, unified_rw_rep;
@@ -354,12 +354,12 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	if (!force) {
 		if (!(output_format & FIO_OUTPUT_NORMAL) &&
 		    f_out == stdout)
-			return 0;
+			return false;
 		if (temp_stall_ts || eta_print == FIO_ETA_NEVER)
-			return 0;
+			return false;
 
 		if (!isatty(STDOUT_FILENO) && (eta_print != FIO_ETA_ALWAYS))
-			return 0;
+			return false;
 	}
 
 	if (!ddir_rw_sum(rate_io_bytes))
@@ -479,7 +479,7 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	 * Allow a little slack, the target is to print it every 1000 msecs
 	 */
 	if (!force && disp_time < 900)
-		return 0;
+		return false;
 
 	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
 	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
@@ -487,12 +487,12 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	memcpy(&disp_prev_time, &now, sizeof(now));
 
 	if (!force && !je->nr_running && !je->nr_pending)
-		return 0;
+		return false;
 
 	je->nr_threads = thread_number;
 	update_condensed_str(__run_str, run_str);
 	memcpy(je->run_str, run_str, strlen(run_str));
-	return 1;
+	return true;
 }
 
 void display_thread_status(struct jobs_eta *je)
diff --git a/file.h b/file.h
index 0cf622f..f7e5d20 100644
--- a/file.h
+++ b/file.h
@@ -209,7 +209,7 @@ extern void dup_files(struct thread_data *, struct thread_data *);
 extern int get_fileno(struct thread_data *, const char *);
 extern void free_release_files(struct thread_data *);
 extern void filesetup_mem_free(void);
-void fio_file_reset(struct thread_data *, struct fio_file *);
-int fio_files_done(struct thread_data *);
+extern void fio_file_reset(struct thread_data *, struct fio_file *);
+extern int fio_files_done(struct thread_data *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index 42a9f41..5db44c2 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -52,7 +52,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	 */
 	if (td_read(td) ||
 	   (td_write(td) && td->o.overwrite && !td->o.file_append) ||
-	    (td_write(td) && td->io_ops->flags & FIO_NOEXTEND))
+	    (td_write(td) && td_ioengine_flagged(td, FIO_NOEXTEND)))
 		new_layout = 1;
 	if (td_write(td) && !td->o.overwrite && !td->o.file_append)
 		unlink_file = 1;
@@ -217,7 +217,7 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 	unsigned int bs;
 	char *b;
 
-	if (td->io_ops->flags & FIO_PIPEIO)
+	if (td_ioengine_flagged(td, FIO_PIPEIO))
 		return 0;
 
 	if (!fio_file_open(f)) {
@@ -827,7 +827,7 @@ int setup_files(struct thread_data *td)
 	 * device/file sizes are zero and no size given, punt
 	 */
 	if ((!total_size || total_size == -1ULL) && !o->size &&
-	    !(td->io_ops->flags & FIO_NOIO) && !o->fill_device &&
+	    !td_ioengine_flagged(td, FIO_NOIO) && !o->fill_device &&
 	    !(o->nr_files && (o->file_size_low || o->file_size_high))) {
 		log_err("%s: you need to specify size=\n", o->name);
 		td_verror(td, EINVAL, "total_file_size");
@@ -903,7 +903,7 @@ int setup_files(struct thread_data *td)
 
 		if (f->filetype == FIO_TYPE_FILE &&
 		    (f->io_size + f->file_offset) > f->real_file_size &&
-		    !(td->io_ops->flags & FIO_DISKLESSIO)) {
+		    !td_ioengine_flagged(td, FIO_DISKLESSIO)) {
 			if (!o->create_on_open) {
 				need_extend++;
 				extend_size += (f->io_size + f->file_offset);
@@ -1374,7 +1374,7 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	/*
 	 * init function, io engine may not be loaded yet
 	 */
-	if (td->io_ops && (td->io_ops->flags & FIO_DISKLESSIO))
+	if (td->io_ops && td_ioengine_flagged(td, FIO_DISKLESSIO))
 		f->real_file_size = -1ULL;
 
 	f->file_name = smalloc_strdup(file_name);
diff --git a/fio.c b/fio.c
index 69014dd..7b3a50b 100644
--- a/fio.c
+++ b/fio.c
@@ -32,6 +32,8 @@ int main(int argc, char *argv[], char *envp[])
 {
 	int ret = 1;
 
+	compiletime_assert(TD_NR <= TD_ENG_FLAG_SHIFT, "TD_ENG_FLAG_SHIFT");
+
 	if (initialize_fio(envp))
 		return 1;
 
diff --git a/fio.h b/fio.h
index 7f685ea..0da0bc5 100644
--- a/fio.h
+++ b/fio.h
@@ -126,11 +126,10 @@ struct zone_split_index {
  * This describes a single thread/process executing a fio job.
  */
 struct thread_data {
-	struct thread_options o;
 	struct flist_head opt_list;
 	unsigned long flags;
+	struct thread_options o;
 	void *eo;
-	char verror[FIO_VERROR_SIZE];
 	pthread_t thread;
 	unsigned int thread_number;
 	unsigned int subjob_number;
@@ -394,6 +393,8 @@ struct thread_data {
 	void *prof_data;
 
 	void *pinned_mem;
+
+	char verror[FIO_VERROR_SIZE];
 };
 
 /*
@@ -450,7 +451,6 @@ extern int read_only;
 extern int eta_print;
 extern int eta_new_line;
 extern unsigned long done_secs;
-extern char *job_section;
 extern int fio_gtod_offload;
 extern int fio_gtod_cpu;
 extern enum fio_cs fio_clock_source;
@@ -513,7 +513,7 @@ extern void td_fill_verify_state_seed(struct thread_data *);
 extern void add_job_opts(const char **, int);
 extern char *num2str(uint64_t, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
-extern int parse_dryrun(void);
+extern bool parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
 extern int fio_set_fd_nonblocking(int, const char *);
 extern void sig_show_status(int sig);
@@ -555,8 +555,27 @@ enum {
 	TD_EXITED,
 	TD_REAPED,
 	TD_LAST,
+	TD_NR,
 };
 
+#define TD_ENG_FLAG_SHIFT	16
+#define TD_ENG_FLAG_MASK	((1U << 16) - 1)
+
+static inline enum fio_ioengine_flags td_ioengine_flags(struct thread_data *td)
+{
+	return (td->flags >> TD_ENG_FLAG_SHIFT) & TD_ENG_FLAG_MASK;
+}
+
+static inline void td_set_ioengine_flags(struct thread_data *td)
+{
+	td->flags |= (td->io_ops->flags << TD_ENG_FLAG_SHIFT);
+}
+
+static inline bool td_ioengine_flagged(struct thread_data *td, unsigned int val)
+{
+	return ((td->flags >> TD_ENG_FLAG_SHIFT) & val) != 0;
+}
+
 extern void td_set_runstate(struct thread_data *, int);
 extern int td_bump_runstate(struct thread_data *, int);
 extern void td_restore_runstate(struct thread_data *, int);
@@ -623,17 +642,17 @@ extern void lat_target_reset(struct thread_data *);
 	}	\
 } while (0)
 
-static inline int fio_fill_issue_time(struct thread_data *td)
+static inline bool fio_fill_issue_time(struct thread_data *td)
 {
 	if (td->o.read_iolog_file ||
 	    !td->o.disable_clat || !td->o.disable_slat || !td->o.disable_bw)
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
-static inline int __should_check_rate(struct thread_data *td,
-				      enum fio_ddir ddir)
+static inline bool __should_check_rate(struct thread_data *td,
+				       enum fio_ddir ddir)
 {
 	struct thread_options *o = &td->o;
 
@@ -642,23 +661,21 @@ static inline int __should_check_rate(struct thread_data *td,
 	 */
 	if (o->rate[ddir] || o->ratemin[ddir] || o->rate_iops[ddir] ||
 	    o->rate_iops_min[ddir])
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
-static inline int should_check_rate(struct thread_data *td)
+static inline bool should_check_rate(struct thread_data *td)
 {
-	int ret = 0;
-
-	if (td->bytes_done[DDIR_READ])
-		ret |= __should_check_rate(td, DDIR_READ);
-	if (td->bytes_done[DDIR_WRITE])
-		ret |= __should_check_rate(td, DDIR_WRITE);
-	if (td->bytes_done[DDIR_TRIM])
-		ret |= __should_check_rate(td, DDIR_TRIM);
-
-	return ret;
+	if (td->bytes_done[DDIR_READ] && __should_check_rate(td, DDIR_READ))
+		return true;
+	if (td->bytes_done[DDIR_WRITE] && __should_check_rate(td, DDIR_WRITE))
+		return true;
+	if (td->bytes_done[DDIR_TRIM] && __should_check_rate(td, DDIR_TRIM))
+		return true;
+
+	return false;
 }
 
 static inline unsigned int td_max_bs(struct thread_data *td)
diff --git a/gclient.c b/gclient.c
index 9c32474..23b0899 100644
--- a/gclient.c
+++ b/gclient.c
@@ -280,10 +280,6 @@ static void gfio_disk_util_op(struct fio_client *client, struct fio_net_cmd *cmd
 	gdk_threads_leave();
 }
 
-extern int sum_stat_clients;
-extern struct thread_stat client_ts;
-extern struct group_run_stats client_gs;
-
 static int sum_stat_nr;
 
 static void gfio_thread_status_op(struct fio_client *client,
@@ -1012,7 +1008,7 @@ static void gfio_show_lat(GtkWidget *vbox, const char *name, unsigned long min,
 	char *minp, *maxp;
 	char tmp[64];
 
-	if (!usec_to_msec(&min, &max, &mean, &dev))
+	if (usec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
 
 	minp = num2str(min, 6, 1, 0, 0);
diff --git a/gfio.c b/gfio.c
index 37c1818..ce18091 100644
--- a/gfio.c
+++ b/gfio.c
@@ -459,10 +459,12 @@ static int send_job_file(struct gui_entry *ge)
 
 static void *server_thread(void *arg)
 {
+	fio_server_create_sk_key();
 	is_backend = 1;
 	gfio_server_running = 1;
 	fio_start_server(NULL);
 	gfio_server_running = 0;
+	fio_server_destroy_sk_key();
 	return NULL;
 }
 
diff --git a/init.c b/init.c
index fb07daa..5ff7385 100644
--- a/init.c
+++ b/init.c
@@ -47,7 +47,6 @@ static char **job_sections;
 static int nr_job_sections;
 
 int exitall_on_terminate = 0;
-int exitall_on_terminate_error = 0;
 int output_format = FIO_OUTPUT_NORMAL;
 int eta_print = FIO_ETA_AUTO;
 int eta_new_line = 0;
@@ -677,7 +676,7 @@ static int fixup_options(struct thread_data *td)
 			"verify limited\n");
 		ret = warnings_fatal;
 	}
-	if (o->bs_unaligned && (o->odirect || td->io_ops->flags & FIO_RAWIO))
+	if (o->bs_unaligned && (o->odirect || td_ioengine_flagged(td, FIO_RAWIO)))
 		log_err("fio: bs_unaligned may not work with raw io\n");
 
 	/*
@@ -764,7 +763,7 @@ static int fixup_options(struct thread_data *td)
 
 	if (o->pre_read) {
 		o->invalidate_cache = 0;
-		if (td->io_ops->flags & FIO_PIPEIO) {
+		if (td_ioengine_flagged(td, FIO_PIPEIO)) {
 			log_info("fio: cannot pre-read files with an IO engine"
 				 " that isn't seekable. Pre-read disabled.\n");
 			ret = warnings_fatal;
@@ -772,7 +771,7 @@ static int fixup_options(struct thread_data *td)
 	}
 
 	if (!o->unit_base) {
-		if (td->io_ops->flags & FIO_BIT_BASED)
+		if (td_ioengine_flagged(td, FIO_BIT_BASED))
 			o->unit_base = 1;
 		else
 			o->unit_base = 8;
@@ -795,7 +794,7 @@ static int fixup_options(struct thread_data *td)
 	 * Windows doesn't support O_DIRECT or O_SYNC with the _open interface,
 	 * so fail if we're passed those flags
 	 */
-	if ((td->io_ops->flags & FIO_SYNCIO) && (td->o.odirect || td->o.sync_io)) {
+	if (td_ioengine_flagged(td, FIO_SYNCIO) && (td->o.odirect || td->o.sync_io)) {
 		log_err("fio: Windows does not support direct or non-buffered io with"
 				" the synchronous ioengines. Use the 'windowsaio' ioengine"
 				" with 'direct=1' and 'iodepth=1' instead.\n");
@@ -844,7 +843,7 @@ static int fixup_options(struct thread_data *td)
 	if (fio_option_is_set(&td->o, rand_seed))
 		td->o.rand_repeatable = 0;
 
-	if ((td->io_ops->flags & FIO_NOEXTEND) && td->o.file_append) {
+	if (td_ioengine_flagged(td, FIO_NOEXTEND) && td->o.file_append) {
 		log_err("fio: can't append/extent with IO engine %s\n", td->io_ops->name);
 		ret = 1;
 	}
@@ -1069,6 +1068,10 @@ int ioengine_load(struct thread_data *td)
 		*(struct thread_data **)td->eo = td;
 	}
 
+	if (td->o.odirect)
+		td->io_ops->flags |= FIO_RAWIO;
+
+	td_set_ioengine_flags(td);
 	return 0;
 }
 
@@ -1244,7 +1247,7 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 	return buf;
 }
 
-int parse_dryrun(void)
+bool parse_dryrun(void)
 {
 	return dump_cmdline || parse_only;
 }
@@ -1340,9 +1343,6 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (ioengine_load(td))
 		goto err;
 
-	if (o->odirect)
-		td->io_ops->flags |= FIO_RAWIO;
-
 	file_alloced = 0;
 	if (!o->filename && !td->files_index && !o->read_iolog_file) {
 		file_alloced = 1;
@@ -1373,7 +1373,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (td->eo)
 		*(struct thread_data **)td->eo = NULL;
 
-	if (td->io_ops->flags & FIO_DISKLESSIO) {
+	if (td_ioengine_flagged(td, FIO_DISKLESSIO)) {
 		struct fio_file *f;
 
 		for_each_file(td, f, i)
@@ -1537,7 +1537,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			if (is_backend && !recursed)
 				fio_server_send_add_job(td);
 
-			if (!(td->io_ops->flags & FIO_NOIO)) {
+			if (!td_ioengine_flagged(td, FIO_NOIO)) {
 				char *c1, *c2, *c3, *c4;
 				char *c5 = NULL, *c6 = NULL;
 
diff --git a/io_u.c b/io_u.c
index 34acc56..2270127 100644
--- a/io_u.c
+++ b/io_u.c
@@ -768,7 +768,7 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 
 	io_u->ddir = io_u->acct_ddir = ddir;
 
-	if (io_u->ddir == DDIR_WRITE && (td->io_ops->flags & FIO_BARRIER) &&
+	if (io_u->ddir == DDIR_WRITE && td_ioengine_flagged(td, FIO_BARRIER) &&
 	    td->o.barrier_blocks &&
 	   !(td->io_issues[DDIR_WRITE] % td->o.barrier_blocks) &&
 	     td->io_issues[DDIR_WRITE])
@@ -843,7 +843,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	unsigned int is_random;
 
-	if (td->io_ops->flags & FIO_NOIO)
+	if (td_ioengine_flagged(td, FIO_NOIO))
 		goto out;
 
 	set_rw_ddir(td, io_u);
@@ -1622,7 +1622,7 @@ struct io_u *get_io_u(struct thread_data *td)
 	assert(fio_file_open(f));
 
 	if (ddir_rw(io_u->ddir)) {
-		if (!io_u->buflen && !(td->io_ops->flags & FIO_NOIO)) {
+		if (!io_u->buflen && !td_ioengine_flagged(td, FIO_NOIO)) {
 			dprint(FD_IO, "get_io_u: zero buflen on %p\n", io_u);
 			goto err_put;
 		}
diff --git a/ioengines.c b/ioengines.c
index 1c7a93b..ae55f95 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -272,7 +272,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	io_u->error = 0;
 	io_u->resid = 0;
 
-	if (td->io_ops->flags & FIO_SYNCIO) {
+	if (td_ioengine_flagged(td, FIO_SYNCIO)) {
 		if (fio_fill_issue_time(td))
 			fio_gettime(&io_u->issue_time, NULL);
 
@@ -346,7 +346,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 		}
 	}
 
-	if ((td->io_ops->flags & FIO_SYNCIO) == 0) {
+	if (!td_ioengine_flagged(td, FIO_SYNCIO)) {
 		if (fio_fill_issue_time(td))
 			fio_gettime(&io_u->issue_time, NULL);
 
@@ -375,7 +375,7 @@ int td_io_init(struct thread_data *td)
 			td->error = ret;
 	}
 
-	if (!ret && (td->io_ops->flags & FIO_NOIO))
+	if (!ret && td_ioengine_flagged(td, FIO_NOIO))
 		td->flags |= TD_F_NOIO;
 
 	return ret;
@@ -441,7 +441,7 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-	if (td->io_ops->flags & FIO_DISKLESSIO)
+	if (td_ioengine_flagged(td, FIO_DISKLESSIO))
 		goto done;
 
 	if (td->o.invalidate_cache && file_invalidate_cache(td, f))
diff --git a/iolog.c b/iolog.c
index 975ce6f..b0c948b 100644
--- a/iolog.c
+++ b/iolog.c
@@ -672,8 +672,8 @@ static inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat)
 	return sum;
 }
 
-void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
-			uint64_t sample_size)
+static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
+			       uint64_t sample_size)
 {
 	struct io_sample *s;
 	int log_offset;
diff --git a/iolog.h b/iolog.h
index 011179a..93e970e 100644
--- a/iolog.h
+++ b/iolog.h
@@ -109,10 +109,11 @@ struct io_log {
 	unsigned long avg_msec;
 	unsigned long avg_last;
 
-  /*
-   * Windowed latency histograms, for keeping track of when we need to
-   * save a copy of the histogram every approximately hist_msec milliseconds.
-   */
+	/*
+	 * Windowed latency histograms, for keeping track of when we need to
+	 * save a copy of the histogram every approximately hist_msec
+	 * milliseconds.
+	 */
 	struct io_hist hist_window[DDIR_RWDIR_CNT];
 	unsigned long hist_msec;
 	int hist_coarseness;
diff --git a/lib/bloom.c b/lib/bloom.c
index ee4ba0b..f4eff57 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -35,7 +35,7 @@ static uint32_t bloom_fnv(const void *buf, uint32_t len, uint32_t seed)
 
 #define BLOOM_SEED	0x8989
 
-struct bloom_hash hashes[] = {
+static struct bloom_hash hashes[] = {
 	{
 		.seed = BLOOM_SEED,
 		.fn = jhash,
diff --git a/lib/mountcheck.c b/lib/mountcheck.c
index e37e9f9..e8780eb 100644
--- a/lib/mountcheck.c
+++ b/lib/mountcheck.c
@@ -4,6 +4,8 @@
 #ifdef CONFIG_GETMNTENT
 #include <mntent.h>
 
+#include "lib/mountcheck.h"
+
 #define MTAB	"/etc/mtab"
 
 int device_is_mounted(const char *dev)
diff --git a/lib/strntol.c b/lib/strntol.c
index 713f63b..adf45bd 100644
--- a/lib/strntol.c
+++ b/lib/strntol.c
@@ -2,6 +2,8 @@
 #include <stdlib.h>
 #include <limits.h>
 
+#include "lib/strntol.h"
+
 long strntol(const char *str, size_t sz, char **end, int base)
 {
 	/* Expect that digit representation of LONG_MAX/MIN
diff --git a/memory.c b/memory.c
index af4d5ef..9124117 100644
--- a/memory.c
+++ b/memory.c
@@ -215,13 +215,13 @@ int allocate_io_mem(struct thread_data *td)
 	size_t total_mem;
 	int ret = 0;
 
-	if (td->io_ops->flags & FIO_NOIO)
+	if (td_ioengine_flagged(td, FIO_NOIO))
 		return 0;
 
 	total_mem = td->orig_buffer_size;
 
 	if (td->o.odirect || td->o.mem_align || td->o.oatomic ||
-	    (td->io_ops->flags & FIO_MEMALIGN)) {
+	    td_ioengine_flagged(td, FIO_MEMALIGN)) {
 		total_mem += page_mask;
 		if (td->o.mem_align && td->o.mem_align > page_size)
 			total_mem += td->o.mem_align - page_size;
diff --git a/options.c b/options.c
index 56e51fc..517ee68 100644
--- a/options.c
+++ b/options.c
@@ -20,6 +20,8 @@
 
 char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 
+#define cb_data_to_td(data)	container_of(data, struct thread_data, o)
+
 struct pattern_fmt_desc fmt_desc[] = {
 	{
 		.fmt   = "%o",
@@ -223,7 +225,7 @@ static int str_split_parse(struct thread_data *td, char *str, split_parse_fn *fn
 
 static int str_bssplit_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	char *str, *p;
 	int ret = 0;
 
@@ -324,7 +326,7 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 
 static int str_ignore_error_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	char *str, *p, *n;
 	int type = 0, ret = 1;
 
@@ -352,7 +354,7 @@ static int str_ignore_error_cb(void *data, const char *input)
 
 static int str_rw_cb(void *data, const char *str)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	struct thread_options *o = &td->o;
 	char *nr;
 
@@ -386,7 +388,7 @@ static int str_rw_cb(void *data, const char *str)
 
 static int str_mem_cb(void *data, const char *mem)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	if (td->o.mem_type == MEM_MMAPHUGE || td->o.mem_type == MEM_MMAP ||
 	    td->o.mem_type == MEM_MMAPSHARED)
@@ -397,7 +399,7 @@ static int str_mem_cb(void *data, const char *mem)
 
 static int fio_clock_source_cb(void *data, const char *str)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	fio_clock_source = td->o.clocksource;
 	fio_clock_source_set = 1;
@@ -407,7 +409,7 @@ static int fio_clock_source_cb(void *data, const char *str)
 
 static int str_rwmix_read_cb(void *data, unsigned long long *val)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	td->o.rwmix[DDIR_READ] = *val;
 	td->o.rwmix[DDIR_WRITE] = 100 - *val;
@@ -416,7 +418,7 @@ static int str_rwmix_read_cb(void *data, unsigned long long *val)
 
 static int str_rwmix_write_cb(void *data, unsigned long long *val)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	td->o.rwmix[DDIR_WRITE] = *val;
 	td->o.rwmix[DDIR_READ] = 100 - *val;
@@ -454,7 +456,7 @@ int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu_index)
 
 static int str_cpumask_cb(void *data, unsigned long long *val)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	unsigned int i;
 	long max_cpu;
 	int ret;
@@ -554,7 +556,7 @@ static int set_cpus_allowed(struct thread_data *td, os_cpu_mask_t *mask,
 
 static int str_cpus_allowed_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	if (parse_dryrun())
 		return 0;
@@ -564,7 +566,7 @@ static int str_cpus_allowed_cb(void *data, const char *input)
 
 static int str_verify_cpus_allowed_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	if (parse_dryrun())
 		return 0;
@@ -575,7 +577,7 @@ static int str_verify_cpus_allowed_cb(void *data, const char *input)
 #ifdef CONFIG_ZLIB
 static int str_log_cpus_allowed_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	if (parse_dryrun())
 		return 0;
@@ -589,7 +591,7 @@ static int str_log_cpus_allowed_cb(void *data, const char *input)
 #ifdef CONFIG_LIBNUMA
 static int str_numa_cpunodes_cb(void *data, char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	struct bitmask *verify_bitmask;
 
 	if (parse_dryrun())
@@ -614,7 +616,7 @@ static int str_numa_cpunodes_cb(void *data, char *input)
 
 static int str_numa_mpol_cb(void *data, char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	const char * const policy_types[] =
 		{ "default", "prefer", "bind", "interleave", "local", NULL };
 	int i;
@@ -723,7 +725,7 @@ out:
 
 static int str_fst_cb(void *data, const char *str)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	double val;
 	bool done = false;
 	char *nr;
@@ -803,7 +805,7 @@ static int str_fst_cb(void *data, const char *str)
 #ifdef CONFIG_SYNC_FILE_RANGE
 static int str_sfr_cb(void *data, const char *str)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	char *nr = get_opt_postfix(str);
 
 	td->sync_file_range_nr = 1;
@@ -1006,7 +1008,7 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input)
 
 static int str_random_distribution_cb(void *data, const char *str)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	double val;
 	char *nr;
 
@@ -1151,7 +1153,7 @@ int set_name_idx(char *target, size_t tlen, char *input, int index,
 
 static int str_filename_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	char *fname, *str, *p;
 
 	p = str = strdup(input);
@@ -1174,7 +1176,7 @@ static int str_filename_cb(void *data, const char *input)
 
 static int str_directory_cb(void *data, const char fio_unused *unused)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	struct stat sb;
 	char *dirname, *str, *p;
 	int ret = 0;
@@ -1205,7 +1207,7 @@ out:
 
 static int str_opendir_cb(void *data, const char fio_unused *str)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	if (parse_dryrun())
 		return 0;
@@ -1218,7 +1220,7 @@ static int str_opendir_cb(void *data, const char fio_unused *str)
 
 static int str_buffer_pattern_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	int ret;
 
 	/* FIXME: for now buffer pattern does not support formats */
@@ -1239,7 +1241,7 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 
 static int str_buffer_compress_cb(void *data, unsigned long long *il)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	td->flags |= TD_F_COMPRESS;
 	td->o.compress_percentage = *il;
@@ -1248,7 +1250,7 @@ static int str_buffer_compress_cb(void *data, unsigned long long *il)
 
 static int str_dedupe_cb(void *data, unsigned long long *il)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	td->flags |= TD_F_COMPRESS;
 	td->o.dedupe_percentage = *il;
@@ -1258,7 +1260,7 @@ static int str_dedupe_cb(void *data, unsigned long long *il)
 
 static int str_verify_pattern_cb(void *data, const char *input)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	int ret;
 
 	td->o.verify_fmt_sz = ARRAY_SIZE(td->o.verify_fmt);
@@ -1281,7 +1283,7 @@ static int str_verify_pattern_cb(void *data, const char *input)
 
 static int str_gtod_reduce_cb(void *data, int *il)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	int val = *il;
 
 	td->o.disable_lat = !!val;
@@ -1297,7 +1299,7 @@ static int str_gtod_reduce_cb(void *data, int *il)
 
 static int str_size_cb(void *data, unsigned long long *__val)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 	unsigned long long v = *__val;
 
 	if (parse_is_percent(v)) {
@@ -1311,7 +1313,7 @@ static int str_size_cb(void *data, unsigned long long *__val)
 
 static int rw_verify(struct fio_option *o, void *data)
 {
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	if (read_only && td_write(td)) {
 		log_err("fio: job <%s> has write bit set, but fio is in"
@@ -1325,7 +1327,7 @@ static int rw_verify(struct fio_option *o, void *data)
 static int gtod_cpu_verify(struct fio_option *o, void *data)
 {
 #ifndef FIO_HAVE_CPU_AFFINITY
-	struct thread_data *td = data;
+	struct thread_data *td = cb_data_to_td(data);
 
 	if (td->o.gtod_cpu) {
 		log_err("fio: platform must support CPU affinity for"
@@ -1345,7 +1347,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "description",
 		.lname	= "Description of job",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(description),
+		.off1	= offsetof(struct thread_options, description),
 		.help	= "Text job description",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_DESC,
@@ -1354,7 +1356,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "name",
 		.lname	= "Job name",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(name),
+		.off1	= offsetof(struct thread_options, name),
 		.help	= "Name of this job",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_DESC,
@@ -1363,7 +1365,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "wait_for",
 		.lname	= "Waitee name",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(wait_for),
+		.off1	= offsetof(struct thread_options, wait_for),
 		.help	= "Name of the job this one wants to wait for before starting",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_DESC,
@@ -1372,7 +1374,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "filename",
 		.lname	= "Filename(s)",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(filename),
+		.off1	= offsetof(struct thread_options, filename),
 		.cb	= str_filename_cb,
 		.prio	= -1, /* must come after "directory" */
 		.help	= "File(s) to use for the workload",
@@ -1383,7 +1385,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "directory",
 		.lname	= "Directory",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(directory),
+		.off1	= offsetof(struct thread_options, directory),
 		.cb	= str_directory_cb,
 		.help	= "Directory to store files in",
 		.category = FIO_OPT_C_FILE,
@@ -1393,7 +1395,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "filename_format",
 		.lname	= "Filename Format",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(filename_format),
+		.off1	= offsetof(struct thread_options, filename_format),
 		.prio	= -1, /* must come after "directory" */
 		.help	= "Override default $jobname.$jobnum.$filenum naming",
 		.def	= "$jobname.$jobnum.$filenum",
@@ -1404,7 +1406,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "unique_filename",
 		.lname	= "Unique Filename",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(unique_filename),
+		.off1	= offsetof(struct thread_options, unique_filename),
 		.help	= "For network clients, prefix file with source IP",
 		.def	= "1",
 		.category = FIO_OPT_C_FILE,
@@ -1414,7 +1416,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "lockfile",
 		.lname	= "Lockfile",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(file_lock_mode),
+		.off1	= offsetof(struct thread_options, file_lock_mode),
 		.help	= "Lock file when doing IO to it",
 		.prio	= 1,
 		.parent	= "filename",
@@ -1442,7 +1444,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "opendir",
 		.lname	= "Open directory",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(opendir),
+		.off1	= offsetof(struct thread_options, opendir),
 		.cb	= str_opendir_cb,
 		.help	= "Recursively add files from this directory and down",
 		.category = FIO_OPT_C_FILE,
@@ -1454,7 +1456,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "readwrite",
 		.type	= FIO_OPT_STR,
 		.cb	= str_rw_cb,
-		.off1	= td_var_offset(td_ddir),
+		.off1	= offsetof(struct thread_options, td_ddir),
 		.help	= "IO direction",
 		.def	= "read",
 		.verify	= rw_verify,
@@ -1507,7 +1509,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "rw_sequencer",
 		.lname	= "RW Sequencer",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(rw_seq),
+		.off1	= offsetof(struct thread_options, rw_seq),
 		.help	= "IO offset generator modifier",
 		.def	= "sequential",
 		.category = FIO_OPT_C_IO,
@@ -1528,7 +1530,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "ioengine",
 		.lname	= "IO Engine",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(ioengine),
+		.off1	= offsetof(struct thread_options, ioengine),
 		.help	= "IO engine to use",
 		.def	= FIO_PREFERRED_ENGINE,
 		.category = FIO_OPT_C_IO,
@@ -1661,7 +1663,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "iodepth",
 		.lname	= "IO Depth",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iodepth),
+		.off1	= offsetof(struct thread_options, iodepth),
 		.help	= "Number of IO buffers to keep in flight",
 		.minval = 1,
 		.interval = 1,
@@ -1674,7 +1676,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "IO Depth batch",
 		.alias	= "iodepth_batch_submit",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iodepth_batch),
+		.off1	= offsetof(struct thread_options, iodepth_batch),
 		.help	= "Number of IO buffers to submit in one go",
 		.parent	= "iodepth",
 		.hide	= 1,
@@ -1688,7 +1690,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Min IO depth batch complete",
 		.alias	= "iodepth_batch_complete",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iodepth_batch_complete_min),
+		.off1	= offsetof(struct thread_options, iodepth_batch_complete_min),
 		.help	= "Min number of IO buffers to retrieve in one go",
 		.parent	= "iodepth",
 		.hide	= 1,
@@ -1702,7 +1704,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "iodepth_batch_complete_max",
 		.lname	= "Max IO depth batch complete",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iodepth_batch_complete_max),
+		.off1	= offsetof(struct thread_options, iodepth_batch_complete_max),
 		.help	= "Max number of IO buffers to retrieve in one go",
 		.parent	= "iodepth",
 		.hide	= 1,
@@ -1715,7 +1717,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "iodepth_low",
 		.lname	= "IO Depth batch low",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iodepth_low),
+		.off1	= offsetof(struct thread_options, iodepth_low),
 		.help	= "Low water mark for queuing depth",
 		.parent	= "iodepth",
 		.hide	= 1,
@@ -1727,7 +1729,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "io_submit_mode",
 		.lname	= "IO submit mode",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(io_submit_mode),
+		.off1	= offsetof(struct thread_options, io_submit_mode),
 		.help	= "How IO submissions and completions are done",
 		.def	= "inline",
 		.category = FIO_OPT_C_IO,
@@ -1748,7 +1750,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Size",
 		.type	= FIO_OPT_STR_VAL,
 		.cb	= str_size_cb,
-		.off1	= td_var_offset(size),
+		.off1	= offsetof(struct thread_options, size),
 		.help	= "Total size of device or files",
 		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
@@ -1759,7 +1761,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "io_limit",
 		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(io_limit),
+		.off1	= offsetof(struct thread_options, io_limit),
 		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
@@ -1769,7 +1771,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Fill device",
 		.alias	= "fill_fs",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(fill_device),
+		.off1	= offsetof(struct thread_options, fill_device),
 		.help	= "Write until an ENOSPC error occurs",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -1779,8 +1781,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "filesize",
 		.lname	= "File size",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(file_size_low),
-		.off2	= td_var_offset(file_size_high),
+		.off1	= offsetof(struct thread_options, file_size_low),
+		.off2	= offsetof(struct thread_options, file_size_high),
 		.minval = 1,
 		.help	= "Size of individual files",
 		.interval = 1024 * 1024,
@@ -1791,7 +1793,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "file_append",
 		.lname	= "File append",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(file_append),
+		.off1	= offsetof(struct thread_options, file_append),
 		.help	= "IO will start at the end of the file(s)",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -1802,7 +1804,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "IO offset",
 		.alias	= "fileoffset",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(start_offset),
+		.off1	= offsetof(struct thread_options, start_offset),
 		.help	= "Start IO from this offset",
 		.def	= "0",
 		.interval = 1024 * 1024,
@@ -1813,7 +1815,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "offset_increment",
 		.lname	= "IO offset increment",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(offset_increment),
+		.off1	= offsetof(struct thread_options, offset_increment),
 		.help	= "What is the increment from one offset to the next",
 		.parent = "offset",
 		.hide	= 1,
@@ -1826,7 +1828,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "number_ios",
 		.lname	= "Number of IOs to perform",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(number_ios),
+		.off1	= offsetof(struct thread_options, number_ios),
 		.help	= "Force job completion after this number of IOs",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
@@ -1837,9 +1839,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Block size",
 		.alias	= "blocksize",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(bs[DDIR_READ]),
-		.off2	= td_var_offset(bs[DDIR_WRITE]),
-		.off3	= td_var_offset(bs[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, bs[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, bs[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, bs[DDIR_TRIM]),
 		.minval = 1,
 		.help	= "Block size unit",
 		.def	= "4k",
@@ -1854,9 +1856,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Block size align",
 		.alias	= "blockalign",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(ba[DDIR_READ]),
-		.off2	= td_var_offset(ba[DDIR_WRITE]),
-		.off3	= td_var_offset(ba[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, ba[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, ba[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, ba[DDIR_TRIM]),
 		.minval	= 1,
 		.help	= "IO block offset alignment",
 		.parent	= "rw",
@@ -1870,12 +1872,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Block size range",
 		.alias	= "blocksize_range",
 		.type	= FIO_OPT_RANGE,
-		.off1	= td_var_offset(min_bs[DDIR_READ]),
-		.off2	= td_var_offset(max_bs[DDIR_READ]),
-		.off3	= td_var_offset(min_bs[DDIR_WRITE]),
-		.off4	= td_var_offset(max_bs[DDIR_WRITE]),
-		.off5	= td_var_offset(min_bs[DDIR_TRIM]),
-		.off6	= td_var_offset(max_bs[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, min_bs[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, max_bs[DDIR_READ]),
+		.off3	= offsetof(struct thread_options, min_bs[DDIR_WRITE]),
+		.off4	= offsetof(struct thread_options, max_bs[DDIR_WRITE]),
+		.off5	= offsetof(struct thread_options, min_bs[DDIR_TRIM]),
+		.off6	= offsetof(struct thread_options, max_bs[DDIR_TRIM]),
 		.minval = 1,
 		.help	= "Set block size range (in more detail than bs)",
 		.parent = "rw",
@@ -1889,7 +1891,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Block size split",
 		.type	= FIO_OPT_STR,
 		.cb	= str_bssplit_cb,
-		.off1	= td_var_offset(bssplit),
+		.off1	= offsetof(struct thread_options, bssplit),
 		.help	= "Set a specific mix of block sizes",
 		.parent	= "rw",
 		.hide	= 1,
@@ -1901,7 +1903,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Block size unaligned",
 		.alias	= "blocksize_unaligned",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(bs_unaligned),
+		.off1	= offsetof(struct thread_options, bs_unaligned),
 		.help	= "Don't sector align IO buffer sizes",
 		.parent = "rw",
 		.hide	= 1,
@@ -1912,7 +1914,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "bs_is_seq_rand",
 		.lname	= "Block size division is seq/random (not read/write)",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(bs_is_seq_rand),
+		.off1	= offsetof(struct thread_options, bs_is_seq_rand),
 		.help	= "Consider any blocksize setting to be sequential,random",
 		.def	= "0",
 		.parent = "blocksize",
@@ -1923,7 +1925,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "randrepeat",
 		.lname	= "Random repeatable",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(rand_repeatable),
+		.off1	= offsetof(struct thread_options, rand_repeatable),
 		.help	= "Use repeatable random IO pattern",
 		.def	= "1",
 		.parent = "rw",
@@ -1935,7 +1937,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "randseed",
 		.lname	= "The random generator seed",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(rand_seed),
+		.off1	= offsetof(struct thread_options, rand_seed),
 		.help	= "Set the random generator seed value",
 		.def	= "0x89",
 		.parent = "rw",
@@ -1946,7 +1948,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "use_os_rand",
 		.lname	= "Use OS random",
 		.type	= FIO_OPT_DEPRECATED,
-		.off1	= td_var_offset(dep_use_os_rand),
+		.off1	= offsetof(struct thread_options, dep_use_os_rand),
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
 	},
@@ -1954,7 +1956,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "norandommap",
 		.lname	= "No randommap",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(norandommap),
+		.off1	= offsetof(struct thread_options, norandommap),
 		.help	= "Accept potential duplicate random blocks",
 		.parent = "rw",
 		.hide	= 1,
@@ -1966,7 +1968,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "softrandommap",
 		.lname	= "Soft randommap",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(softrandommap),
+		.off1	= offsetof(struct thread_options, softrandommap),
 		.help	= "Set norandommap if randommap allocation fails",
 		.parent	= "norandommap",
 		.hide	= 1,
@@ -1978,7 +1980,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "random_generator",
 		.lname	= "Random Generator",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(random_generator),
+		.off1	= offsetof(struct thread_options, random_generator),
 		.help	= "Type of random number generator to use",
 		.def	= "tausworthe",
 		.posval	= {
@@ -2003,7 +2005,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "random_distribution",
 		.lname	= "Random Distribution",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(random_distribution),
+		.off1	= offsetof(struct thread_options, random_distribution),
 		.cb	= str_random_distribution_cb,
 		.help	= "Random offset distribution generator",
 		.def	= "random",
@@ -2037,9 +2039,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "percentage_random",
 		.lname	= "Percentage Random",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(perc_rand[DDIR_READ]),
-		.off2	= td_var_offset(perc_rand[DDIR_WRITE]),
-		.off3	= td_var_offset(perc_rand[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, perc_rand[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, perc_rand[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, perc_rand[DDIR_TRIM]),
 		.maxval	= 100,
 		.help	= "Percentage of seq/random mix that should be random",
 		.def	= "100,100,100",
@@ -2059,7 +2061,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "allrandrepeat",
 		.lname	= "All Random Repeat",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(allrand_repeatable),
+		.off1	= offsetof(struct thread_options, allrand_repeatable),
 		.help	= "Use repeatable random numbers for everything",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
@@ -2070,7 +2072,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Number of files",
 		.alias	= "nr_files",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(nr_files),
+		.off1	= offsetof(struct thread_options, nr_files),
 		.help	= "Split job workload between this number of files",
 		.def	= "1",
 		.interval = 1,
@@ -2081,7 +2083,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "openfiles",
 		.lname	= "Number of open files",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(open_files),
+		.off1	= offsetof(struct thread_options, open_files),
 		.help	= "Number of files to keep open at the same time",
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
@@ -2091,7 +2093,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "File service type",
 		.type	= FIO_OPT_STR,
 		.cb	= str_fst_cb,
-		.off1	= td_var_offset(file_service_type),
+		.off1	= offsetof(struct thread_options, file_service_type),
 		.help	= "How to select which file to service next",
 		.def	= "roundrobin",
 		.category = FIO_OPT_C_FILE,
@@ -2130,7 +2132,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "fallocate",
 		.lname	= "Fallocate",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(fallocate_mode),
+		.off1	= offsetof(struct thread_options, fallocate_mode),
 		.help	= "Whether pre-allocation is performed when laying out files",
 		.def	= "posix",
 		.category = FIO_OPT_C_FILE,
@@ -2173,7 +2175,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "fadvise_hint",
 		.lname	= "Fadvise hint",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(fadvise_hint),
+		.off1	= offsetof(struct thread_options, fadvise_hint),
 		.help	= "Use fadvise() to advise the kernel on IO pattern",
 		.def	= "1",
 		.category = FIO_OPT_C_FILE,
@@ -2184,7 +2186,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "fadvise_stream",
 		.lname	= "Fadvise stream",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(fadvise_stream),
+		.off1	= offsetof(struct thread_options, fadvise_stream),
 		.help	= "Use fadvise() to set stream ID",
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
@@ -2201,7 +2203,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "fsync",
 		.lname	= "Fsync",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(fsync_blocks),
+		.off1	= offsetof(struct thread_options, fsync_blocks),
 		.help	= "Issue fsync for writes every given number of blocks",
 		.def	= "0",
 		.interval = 1,
@@ -2212,7 +2214,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "fdatasync",
 		.lname	= "Fdatasync",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(fdatasync_blocks),
+		.off1	= offsetof(struct thread_options, fdatasync_blocks),
 		.help	= "Issue fdatasync for writes every given number of blocks",
 		.def	= "0",
 		.interval = 1,
@@ -2223,7 +2225,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "write_barrier",
 		.lname	= "Write barrier",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(barrier_blocks),
+		.off1	= offsetof(struct thread_options, barrier_blocks),
 		.help	= "Make every Nth write a barrier write",
 		.def	= "0",
 		.interval = 1,
@@ -2254,7 +2256,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		},
 		.type	= FIO_OPT_STR_MULTI,
 		.cb	= str_sfr_cb,
-		.off1	= td_var_offset(sync_file_range),
+		.off1	= offsetof(struct thread_options, sync_file_range),
 		.help	= "Use sync_file_range()",
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
@@ -2271,7 +2273,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "direct",
 		.lname	= "Direct I/O",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(odirect),
+		.off1	= offsetof(struct thread_options, odirect),
 		.help	= "Use O_DIRECT IO (negates buffered)",
 		.def	= "0",
 		.inverse = "buffered",
@@ -2282,7 +2284,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "atomic",
 		.lname	= "Atomic I/O",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(oatomic),
+		.off1	= offsetof(struct thread_options, oatomic),
 		.help	= "Use Atomic IO with O_DIRECT (implies O_DIRECT)",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
@@ -2292,7 +2294,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "buffered",
 		.lname	= "Buffered I/O",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(odirect),
+		.off1	= offsetof(struct thread_options, odirect),
 		.neg	= 1,
 		.help	= "Use buffered IO (negates direct)",
 		.def	= "1",
@@ -2304,7 +2306,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "overwrite",
 		.lname	= "Overwrite",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(overwrite),
+		.off1	= offsetof(struct thread_options, overwrite),
 		.help	= "When writing, set whether to overwrite current data",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -2314,7 +2316,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "loops",
 		.lname	= "Loops",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(loops),
+		.off1	= offsetof(struct thread_options, loops),
 		.help	= "Number of times to run the job",
 		.def	= "1",
 		.interval = 1,
@@ -2325,7 +2327,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "numjobs",
 		.lname	= "Number of jobs",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(numjobs),
+		.off1	= offsetof(struct thread_options, numjobs),
 		.help	= "Duplicate this job this many times",
 		.def	= "1",
 		.interval = 1,
@@ -2336,8 +2338,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "startdelay",
 		.lname	= "Start delay",
 		.type	= FIO_OPT_STR_VAL_TIME,
-		.off1	= td_var_offset(start_delay),
-		.off2	= td_var_offset(start_delay_high),
+		.off1	= offsetof(struct thread_options, start_delay),
+		.off2	= offsetof(struct thread_options, start_delay_high),
 		.help	= "Only start job when this period has passed",
 		.def	= "0",
 		.is_seconds = 1,
@@ -2350,7 +2352,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Runtime",
 		.alias	= "timeout",
 		.type	= FIO_OPT_STR_VAL_TIME,
-		.off1	= td_var_offset(timeout),
+		.off1	= offsetof(struct thread_options, timeout),
 		.help	= "Stop workload when this amount of time has passed",
 		.def	= "0",
 		.is_seconds = 1,
@@ -2362,7 +2364,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "time_based",
 		.lname	= "Time based",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(time_based),
+		.off1	= offsetof(struct thread_options, time_based),
 		.help	= "Keep running until runtime/timeout is met",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_RUNTIME,
@@ -2371,7 +2373,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify_only",
 		.lname	= "Verify only",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(verify_only),
+		.off1	= offsetof(struct thread_options, verify_only),
 		.help	= "Verifies previously written data is still valid",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_RUNTIME,
@@ -2380,7 +2382,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "ramp_time",
 		.lname	= "Ramp time",
 		.type	= FIO_OPT_STR_VAL_TIME,
-		.off1	= td_var_offset(ramp_time),
+		.off1	= offsetof(struct thread_options, ramp_time),
 		.help	= "Ramp up time before measuring performance",
 		.is_seconds = 1,
 		.is_time = 1,
@@ -2392,7 +2394,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Clock source",
 		.type	= FIO_OPT_STR,
 		.cb	= fio_clock_source_cb,
-		.off1	= td_var_offset(clocksource),
+		.off1	= offsetof(struct thread_options, clocksource),
 		.help	= "What type of timing source to use",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CLOCK,
@@ -2423,7 +2425,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "I/O Memory",
 		.type	= FIO_OPT_STR,
 		.cb	= str_mem_cb,
-		.off1	= td_var_offset(mem_type),
+		.off1	= offsetof(struct thread_options, mem_type),
 		.help	= "Backing type for IO buffers",
 		.def	= "malloc",
 		.category = FIO_OPT_C_IO,
@@ -2466,7 +2468,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "mem_align",
 		.lname	= "I/O memory alignment",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(mem_align),
+		.off1	= offsetof(struct thread_options, mem_align),
 		.minval	= 0,
 		.help	= "IO memory buffer offset alignment",
 		.def	= "0",
@@ -2479,7 +2481,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify",
 		.lname	= "Verify",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(verify),
+		.off1	= offsetof(struct thread_options, verify),
 		.help	= "Verify data written",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
@@ -2556,7 +2558,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "do_verify",
 		.lname	= "Perform verify step",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(do_verify),
+		.off1	= offsetof(struct thread_options, do_verify),
 		.help	= "Run verification stage after write",
 		.def	= "1",
 		.parent = "verify",
@@ -2568,7 +2570,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verifysort",
 		.lname	= "Verify sort",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(verifysort),
+		.off1	= offsetof(struct thread_options, verifysort),
 		.help	= "Sort written verify blocks for read back",
 		.def	= "1",
 		.parent = "verify",
@@ -2580,7 +2582,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verifysort_nr",
 		.lname	= "Verify Sort Nr",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(verifysort_nr),
+		.off1	= offsetof(struct thread_options, verifysort_nr),
 		.help	= "Pre-load and sort verify blocks for a read workload",
 		.minval	= 0,
 		.maxval	= 131072,
@@ -2593,7 +2595,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name   = "verify_interval",
 		.lname	= "Verify interval",
 		.type   = FIO_OPT_INT,
-		.off1   = td_var_offset(verify_interval),
+		.off1   = offsetof(struct thread_options, verify_interval),
 		.minval	= 2 * sizeof(struct verify_header),
 		.help   = "Store verify buffer header every N bytes",
 		.parent	= "verify",
@@ -2607,7 +2609,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Verify offset",
 		.type	= FIO_OPT_INT,
 		.help	= "Offset verify header location by N bytes",
-		.off1	= td_var_offset(verify_offset),
+		.off1	= offsetof(struct thread_options, verify_offset),
 		.minval	= sizeof(struct verify_header),
 		.parent	= "verify",
 		.hide	= 1,
@@ -2619,7 +2621,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Verify pattern",
 		.type	= FIO_OPT_STR,
 		.cb	= str_verify_pattern_cb,
-		.off1	= td_var_offset(verify_pattern),
+		.off1	= offsetof(struct thread_options, verify_pattern),
 		.help	= "Fill pattern for IO buffers",
 		.parent	= "verify",
 		.hide	= 1,
@@ -2630,7 +2632,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify_fatal",
 		.lname	= "Verify fatal",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(verify_fatal),
+		.off1	= offsetof(struct thread_options, verify_fatal),
 		.def	= "0",
 		.help	= "Exit on a single verify failure, don't continue",
 		.parent = "verify",
@@ -2642,7 +2644,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify_dump",
 		.lname	= "Verify dump",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(verify_dump),
+		.off1	= offsetof(struct thread_options, verify_dump),
 		.def	= "0",
 		.help	= "Dump contents of good and bad blocks on failure",
 		.parent = "verify",
@@ -2654,7 +2656,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify_async",
 		.lname	= "Verify asynchronously",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(verify_async),
+		.off1	= offsetof(struct thread_options, verify_async),
 		.def	= "0",
 		.help	= "Number of async verifier threads to use",
 		.parent	= "verify",
@@ -2666,7 +2668,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify_backlog",
 		.lname	= "Verify backlog",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(verify_backlog),
+		.off1	= offsetof(struct thread_options, verify_backlog),
 		.help	= "Verify after this number of blocks are written",
 		.parent	= "verify",
 		.hide	= 1,
@@ -2677,7 +2679,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify_backlog_batch",
 		.lname	= "Verify backlog batch",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(verify_batch),
+		.off1	= offsetof(struct thread_options, verify_batch),
 		.help	= "Verify this number of IO blocks",
 		.parent	= "verify",
 		.hide	= 1,
@@ -2690,7 +2692,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Async verify CPUs",
 		.type	= FIO_OPT_STR,
 		.cb	= str_verify_cpus_allowed_cb,
-		.off1	= td_var_offset(verify_cpumask),
+		.off1	= offsetof(struct thread_options, verify_cpumask),
 		.help	= "Set CPUs allowed for async verify threads",
 		.parent	= "verify_async",
 		.hide	= 1,
@@ -2708,7 +2710,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "experimental_verify",
 		.lname	= "Experimental Verify",
-		.off1	= td_var_offset(experimental_verify),
+		.off1	= offsetof(struct thread_options, experimental_verify),
 		.type	= FIO_OPT_BOOL,
 		.help	= "Enable experimental verification",
 		.parent	= "verify",
@@ -2718,7 +2720,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "verify_state_load",
 		.lname	= "Load verify state",
-		.off1	= td_var_offset(verify_state),
+		.off1	= offsetof(struct thread_options, verify_state),
 		.type	= FIO_OPT_BOOL,
 		.help	= "Load verify termination state",
 		.parent	= "verify",
@@ -2728,7 +2730,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "verify_state_save",
 		.lname	= "Save verify state",
-		.off1	= td_var_offset(verify_state_save),
+		.off1	= offsetof(struct thread_options, verify_state_save),
 		.type	= FIO_OPT_BOOL,
 		.def	= "1",
 		.help	= "Save verify state on termination",
@@ -2741,7 +2743,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "trim_percentage",
 		.lname	= "Trim percentage",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(trim_percentage),
+		.off1	= offsetof(struct thread_options, trim_percentage),
 		.minval = 0,
 		.maxval = 100,
 		.help	= "Number of verify blocks to discard/trim",
@@ -2757,7 +2759,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Verify trim zero",
 		.type	= FIO_OPT_BOOL,
 		.help	= "Verify that trim/discarded blocks are returned as zeroes",
-		.off1	= td_var_offset(trim_zero),
+		.off1	= offsetof(struct thread_options, trim_zero),
 		.parent	= "trim_percentage",
 		.hide	= 1,
 		.def	= "1",
@@ -2768,7 +2770,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "trim_backlog",
 		.lname	= "Trim backlog",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(trim_backlog),
+		.off1	= offsetof(struct thread_options, trim_backlog),
 		.help	= "Trim after this number of blocks are written",
 		.parent	= "trim_percentage",
 		.hide	= 1,
@@ -2780,7 +2782,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "trim_backlog_batch",
 		.lname	= "Trim backlog batch",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(trim_batch),
+		.off1	= offsetof(struct thread_options, trim_batch),
 		.help	= "Trim this number of IO blocks",
 		.parent	= "trim_percentage",
 		.hide	= 1,
@@ -2818,7 +2820,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "write_iolog",
 		.lname	= "Write I/O log",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(write_iolog_file),
+		.off1	= offsetof(struct thread_options, write_iolog_file),
 		.help	= "Store IO pattern to file",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IOLOG,
@@ -2827,7 +2829,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "read_iolog",
 		.lname	= "Read I/O log",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(read_iolog_file),
+		.off1	= offsetof(struct thread_options, read_iolog_file),
 		.help	= "Playback IO pattern from file",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IOLOG,
@@ -2836,7 +2838,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "replay_no_stall",
 		.lname	= "Don't stall on replay",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(no_stall),
+		.off1	= offsetof(struct thread_options, no_stall),
 		.def	= "0",
 		.parent	= "read_iolog",
 		.hide	= 1,
@@ -2848,7 +2850,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "replay_redirect",
 		.lname	= "Redirect device for replay",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(replay_redirect),
+		.off1	= offsetof(struct thread_options, replay_redirect),
 		.parent	= "read_iolog",
 		.hide	= 1,
 		.help	= "Replay all I/O onto this device, regardless of trace device",
@@ -2859,7 +2861,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "replay_scale",
 		.lname	= "Replace offset scale factor",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(replay_scale),
+		.off1	= offsetof(struct thread_options, replay_scale),
 		.parent	= "read_iolog",
 		.def	= "1",
 		.help	= "Align offsets to this blocksize",
@@ -2870,7 +2872,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "replay_align",
 		.lname	= "Replace alignment",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(replay_align),
+		.off1	= offsetof(struct thread_options, replay_align),
 		.parent	= "read_iolog",
 		.help	= "Scale offset down by this factor",
 		.category = FIO_OPT_C_IO,
@@ -2881,7 +2883,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(exec_prerun),
+		.off1	= offsetof(struct thread_options, exec_prerun),
 		.help	= "Execute this file prior to running job",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
@@ -2890,7 +2892,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "exec_postrun",
 		.lname	= "Post-execute runnable",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(exec_postrun),
+		.off1	= offsetof(struct thread_options, exec_postrun),
 		.help	= "Execute this file after running job",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
@@ -2900,7 +2902,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "ioscheduler",
 		.lname	= "I/O scheduler",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(ioscheduler),
+		.off1	= offsetof(struct thread_options, ioscheduler),
 		.help	= "Use this IO scheduler on the backing device",
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
@@ -2917,7 +2919,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "zonesize",
 		.lname	= "Zone size",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(zone_size),
+		.off1	= offsetof(struct thread_options, zone_size),
 		.help	= "Amount of data to read per zone",
 		.def	= "0",
 		.interval = 1024 * 1024,
@@ -2928,7 +2930,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "zonerange",
 		.lname	= "Zone range",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(zone_range),
+		.off1	= offsetof(struct thread_options, zone_range),
 		.help	= "Give size of an IO zone",
 		.def	= "0",
 		.interval = 1024 * 1024,
@@ -2939,7 +2941,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "zoneskip",
 		.lname	= "Zone skip",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(zone_skip),
+		.off1	= offsetof(struct thread_options, zone_skip),
 		.help	= "Space between IO zones",
 		.def	= "0",
 		.interval = 1024 * 1024,
@@ -2950,7 +2952,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "lockmem",
 		.lname	= "Lock memory",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= td_var_offset(lockmem),
+		.off1	= offsetof(struct thread_options, lockmem),
 		.help	= "Lock down this amount of memory (per worker)",
 		.def	= "0",
 		.interval = 1024 * 1024,
@@ -2962,7 +2964,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Read/write mix read",
 		.type	= FIO_OPT_INT,
 		.cb	= str_rwmix_read_cb,
-		.off1	= td_var_offset(rwmix[DDIR_READ]),
+		.off1	= offsetof(struct thread_options, rwmix[DDIR_READ]),
 		.maxval	= 100,
 		.help	= "Percentage of mixed workload that is reads",
 		.def	= "50",
@@ -2976,7 +2978,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Read/write mix write",
 		.type	= FIO_OPT_INT,
 		.cb	= str_rwmix_write_cb,
-		.off1	= td_var_offset(rwmix[DDIR_WRITE]),
+		.off1	= offsetof(struct thread_options, rwmix[DDIR_WRITE]),
 		.maxval	= 100,
 		.help	= "Percentage of mixed workload that is writes",
 		.def	= "50",
@@ -2996,7 +2998,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "nice",
 		.lname	= "Nice",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(nice),
+		.off1	= offsetof(struct thread_options, nice),
 		.help	= "Set job CPU nice value",
 		.minval	= -19,
 		.maxval	= 20,
@@ -3010,7 +3012,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "prio",
 		.lname	= "I/O nice priority",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(ioprio),
+		.off1	= offsetof(struct thread_options, ioprio),
 		.help	= "Set job IO priority value",
 		.minval	= IOPRIO_MIN_PRIO,
 		.maxval	= IOPRIO_MAX_PRIO,
@@ -3034,7 +3036,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "prioclass",
 		.lname	= "I/O nice priority class",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(ioprio_class),
+		.off1	= offsetof(struct thread_options, ioprio_class),
 		.help	= "Set job IO priority class",
 		.minval	= IOPRIO_MIN_PRIO_CLASS,
 		.maxval	= IOPRIO_MAX_PRIO_CLASS,
@@ -3054,7 +3056,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "thinktime",
 		.lname	= "Thinktime",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(thinktime),
+		.off1	= offsetof(struct thread_options, thinktime),
 		.help	= "Idle time between IO buffers (usec)",
 		.def	= "0",
 		.is_time = 1,
@@ -3065,7 +3067,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "thinktime_spin",
 		.lname	= "Thinktime spin",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(thinktime_spin),
+		.off1	= offsetof(struct thread_options, thinktime_spin),
 		.help	= "Start think time by spinning this amount (usec)",
 		.def	= "0",
 		.is_time = 1,
@@ -3078,7 +3080,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "thinktime_blocks",
 		.lname	= "Thinktime blocks",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(thinktime_blocks),
+		.off1	= offsetof(struct thread_options, thinktime_blocks),
 		.help	= "IO buffer period between 'thinktime'",
 		.def	= "1",
 		.parent	= "thinktime",
@@ -3090,9 +3092,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "rate",
 		.lname	= "I/O rate",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(rate[DDIR_READ]),
-		.off2	= td_var_offset(rate[DDIR_WRITE]),
-		.off3	= td_var_offset(rate[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, rate[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, rate[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, rate[DDIR_TRIM]),
 		.help	= "Set bandwidth rate",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RATE,
@@ -3102,9 +3104,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "ratemin",
 		.lname	= "I/O min rate",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(ratemin[DDIR_READ]),
-		.off2	= td_var_offset(ratemin[DDIR_WRITE]),
-		.off3	= td_var_offset(ratemin[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, ratemin[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, ratemin[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, ratemin[DDIR_TRIM]),
 		.help	= "Job must meet this rate or it will be shutdown",
 		.parent	= "rate",
 		.hide	= 1,
@@ -3115,9 +3117,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "rate_iops",
 		.lname	= "I/O rate IOPS",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(rate_iops[DDIR_READ]),
-		.off2	= td_var_offset(rate_iops[DDIR_WRITE]),
-		.off3	= td_var_offset(rate_iops[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, rate_iops[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, rate_iops[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, rate_iops[DDIR_TRIM]),
 		.help	= "Limit IO used to this number of IO operations/sec",
 		.hide	= 1,
 		.category = FIO_OPT_C_IO,
@@ -3127,9 +3129,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "rate_iops_min",
 		.lname	= "I/O min rate IOPS",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(rate_iops_min[DDIR_READ]),
-		.off2	= td_var_offset(rate_iops_min[DDIR_WRITE]),
-		.off3	= td_var_offset(rate_iops_min[DDIR_TRIM]),
+		.off1	= offsetof(struct thread_options, rate_iops_min[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, rate_iops_min[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, rate_iops_min[DDIR_TRIM]),
 		.help	= "Job must meet this rate or it will be shut down",
 		.parent	= "rate_iops",
 		.hide	= 1,
@@ -3140,7 +3142,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "rate_process",
 		.lname	= "Rate Process",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(rate_process),
+		.off1	= offsetof(struct thread_options, rate_process),
 		.help	= "What process controls how rated IO is managed",
 		.def	= "linear",
 		.category = FIO_OPT_C_IO,
@@ -3163,7 +3165,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "ratecycle",
 		.lname	= "I/O rate cycle",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(ratecycle),
+		.off1	= offsetof(struct thread_options, ratecycle),
 		.help	= "Window average for rate limits (msec)",
 		.def	= "1000",
 		.parent = "rate",
@@ -3175,7 +3177,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "max_latency",
 		.lname	= "Max Latency",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(max_latency),
+		.off1	= offsetof(struct thread_options, max_latency),
 		.help	= "Maximum tolerated IO latency (usec)",
 		.is_time = 1,
 		.category = FIO_OPT_C_IO,
@@ -3185,7 +3187,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "latency_target",
 		.lname	= "Latency Target (usec)",
 		.type	= FIO_OPT_STR_VAL_TIME,
-		.off1	= td_var_offset(latency_target),
+		.off1	= offsetof(struct thread_options, latency_target),
 		.help	= "Ramp to max queue depth supporting this latency",
 		.is_time = 1,
 		.category = FIO_OPT_C_IO,
@@ -3195,7 +3197,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "latency_window",
 		.lname	= "Latency Window (usec)",
 		.type	= FIO_OPT_STR_VAL_TIME,
-		.off1	= td_var_offset(latency_window),
+		.off1	= offsetof(struct thread_options, latency_window),
 		.help	= "Time to sustain latency_target",
 		.is_time = 1,
 		.category = FIO_OPT_C_IO,
@@ -3205,7 +3207,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "latency_percentile",
 		.lname	= "Latency Percentile",
 		.type	= FIO_OPT_FLOAT_LIST,
-		.off1	= td_var_offset(latency_percentile),
+		.off1	= offsetof(struct thread_options, latency_percentile),
 		.help	= "Percentile of IOs must be below latency_target",
 		.def	= "100",
 		.maxlen	= 1,
@@ -3218,7 +3220,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "invalidate",
 		.lname	= "Cache invalidate",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(invalidate_cache),
+		.off1	= offsetof(struct thread_options, invalidate_cache),
 		.help	= "Invalidate buffer/page cache prior to running job",
 		.def	= "1",
 		.category = FIO_OPT_C_IO,
@@ -3228,7 +3230,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "sync",
 		.lname	= "Synchronous I/O",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(sync_io),
+		.off1	= offsetof(struct thread_options, sync_io),
 		.help	= "Use O_SYNC for buffered writes",
 		.def	= "0",
 		.parent = "buffered",
@@ -3240,7 +3242,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "create_serialize",
 		.lname	= "Create serialize",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(create_serialize),
+		.off1	= offsetof(struct thread_options, create_serialize),
 		.help	= "Serialize creation of job files",
 		.def	= "1",
 		.category = FIO_OPT_C_FILE,
@@ -3250,7 +3252,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "create_fsync",
 		.lname	= "Create fsync",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(create_fsync),
+		.off1	= offsetof(struct thread_options, create_fsync),
 		.help	= "fsync file after creation",
 		.def	= "1",
 		.category = FIO_OPT_C_FILE,
@@ -3260,7 +3262,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "create_on_open",
 		.lname	= "Create on open",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(create_on_open),
+		.off1	= offsetof(struct thread_options, create_on_open),
 		.help	= "Create files when they are opened for IO",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -3270,7 +3272,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "create_only",
 		.lname	= "Create Only",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(create_only),
+		.off1	= offsetof(struct thread_options, create_only),
 		.help	= "Only perform file creation phase",
 		.category = FIO_OPT_C_FILE,
 		.def	= "0",
@@ -3279,7 +3281,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "allow_file_create",
 		.lname	= "Allow file create",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(allow_create),
+		.off1	= offsetof(struct thread_options, allow_create),
 		.help	= "Permit fio to create files, if they don't exist",
 		.def	= "1",
 		.category = FIO_OPT_C_FILE,
@@ -3289,7 +3291,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "allow_mounted_write",
 		.lname	= "Allow mounted write",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(allow_mounted_write),
+		.off1	= offsetof(struct thread_options, allow_mounted_write),
 		.help	= "Allow writes to a mounted partition",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -3299,7 +3301,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "pre_read",
 		.lname	= "Pre-read files",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(pre_read),
+		.off1	= offsetof(struct thread_options, pre_read),
 		.help	= "Pre-read files before starting official testing",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -3311,7 +3313,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "CPU mask",
 		.type	= FIO_OPT_INT,
 		.cb	= str_cpumask_cb,
-		.off1	= td_var_offset(cpumask),
+		.off1	= offsetof(struct thread_options, cpumask),
 		.help	= "CPU affinity mask",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
@@ -3321,7 +3323,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "CPUs allowed",
 		.type	= FIO_OPT_STR,
 		.cb	= str_cpus_allowed_cb,
-		.off1	= td_var_offset(cpumask),
+		.off1	= offsetof(struct thread_options, cpumask),
 		.help	= "Set CPUs allowed",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
@@ -3330,7 +3332,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "cpus_allowed_policy",
 		.lname	= "CPUs allowed distribution policy",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(cpus_allowed_policy),
+		.off1	= offsetof(struct thread_options, cpus_allowed_policy),
 		.help	= "Distribution policy for cpus_allowed",
 		.parent = "cpus_allowed",
 		.prio	= 1,
@@ -3373,7 +3375,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "NUMA CPU Nodes",
 		.type	= FIO_OPT_STR,
 		.cb	= str_numa_cpunodes_cb,
-		.off1	= td_var_offset(numa_cpunodes),
+		.off1	= offsetof(struct thread_options, numa_cpunodes),
 		.help	= "NUMA CPU nodes bind",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
@@ -3383,7 +3385,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "NUMA Memory Policy",
 		.type	= FIO_OPT_STR,
 		.cb	= str_numa_mpol_cb,
-		.off1	= td_var_offset(numa_memnodes),
+		.off1	= offsetof(struct thread_options, numa_memnodes),
 		.help	= "NUMA memory policy setup",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
@@ -3406,7 +3408,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "end_fsync",
 		.lname	= "End fsync",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(end_fsync),
+		.off1	= offsetof(struct thread_options, end_fsync),
 		.help	= "Include fsync at the end of job",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -3416,7 +3418,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "fsync_on_close",
 		.lname	= "Fsync on close",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(fsync_on_close),
+		.off1	= offsetof(struct thread_options, fsync_on_close),
 		.help	= "fsync files on close",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -3426,7 +3428,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "unlink",
 		.lname	= "Unlink file",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(unlink),
+		.off1	= offsetof(struct thread_options, unlink),
 		.help	= "Unlink created files after job has completed",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -3436,7 +3438,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "unlink_each_loop",
 		.lname	= "Unlink file after each loop of a job",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(unlink_each_loop),
+		.off1	= offsetof(struct thread_options, unlink_each_loop),
 		.help	= "Unlink created files after each loop in a job has completed",
 		.def	= "0",
 		.category = FIO_OPT_C_FILE,
@@ -3455,7 +3457,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "exitall_on_error",
 		.lname	= "Exit-all on terminate in error",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(exitall_error),
+		.off1	= offsetof(struct thread_options, exitall_error),
 		.help	= "Terminate all jobs when one exits in error",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_PROCESS,
@@ -3465,7 +3467,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Wait for previous",
 		.alias	= "wait_for_previous",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(stonewall),
+		.off1	= offsetof(struct thread_options, stonewall),
 		.help	= "Insert a hard barrier between this job and previous",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_PROCESS,
@@ -3474,7 +3476,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "new_group",
 		.lname	= "New group",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(new_group),
+		.off1	= offsetof(struct thread_options, new_group),
 		.help	= "Mark the start of a new group (for reporting)",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_PROCESS,
@@ -3483,7 +3485,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "thread",
 		.lname	= "Thread",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(use_thread),
+		.off1	= offsetof(struct thread_options, use_thread),
 		.help	= "Use threads instead of processes",
 #ifdef CONFIG_NO_SHM
 		.def	= "1",
@@ -3496,7 +3498,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "per_job_logs",
 		.lname	= "Per Job Logs",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(per_job_logs),
+		.off1	= offsetof(struct thread_options, per_job_logs),
 		.help	= "Include job number in generated log files or not",
 		.def	= "1",
 		.category = FIO_OPT_C_LOG,
@@ -3506,7 +3508,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "write_bw_log",
 		.lname	= "Write bandwidth log",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(bw_log_file),
+		.off1	= offsetof(struct thread_options, bw_log_file),
 		.help	= "Write log of bandwidth during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3515,7 +3517,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "write_lat_log",
 		.lname	= "Write latency log",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(lat_log_file),
+		.off1	= offsetof(struct thread_options, lat_log_file),
 		.help	= "Write log of latency during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3524,7 +3526,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "write_iops_log",
 		.lname	= "Write IOPS log",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(iops_log_file),
+		.off1	= offsetof(struct thread_options, iops_log_file),
 		.help	= "Write log of IOPS during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3533,7 +3535,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_avg_msec",
 		.lname	= "Log averaging (msec)",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(log_avg_msec),
+		.off1	= offsetof(struct thread_options, log_avg_msec),
 		.help	= "Average bw/iops/lat logs over this period of time",
 		.def	= "0",
 		.category = FIO_OPT_C_LOG,
@@ -3543,7 +3545,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_hist_msec",
 		.lname	= "Log histograms (msec)",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(log_hist_msec),
+		.off1	= offsetof(struct thread_options, log_hist_msec),
 		.help	= "Dump completion latency histograms at frequency of this time value",
 		.def	= "0",
 		.category = FIO_OPT_C_LOG,
@@ -3553,7 +3555,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_hist_coarseness",
 		.lname	= "Histogram logs coarseness",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(log_hist_coarseness),
+		.off1	= offsetof(struct thread_options, log_hist_coarseness),
 		.help	= "Integer in range [0,6]. Higher coarseness outputs"
 			" fewer histogram bins per sample. The number of bins for"
 			" these are [1216, 608, 304, 152, 76, 38, 19] respectively.",
@@ -3565,7 +3567,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "write_hist_log",
 		.lname	= "Write latency histogram logs",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(hist_log_file),
+		.off1	= offsetof(struct thread_options, hist_log_file),
 		.help	= "Write log of latency histograms during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3574,7 +3576,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_max_value",
 		.lname	= "Log maximum instead of average",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(log_max),
+		.off1	= offsetof(struct thread_options, log_max),
 		.help	= "Log max sample in a window instead of average",
 		.def	= "0",
 		.category = FIO_OPT_C_LOG,
@@ -3584,7 +3586,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_offset",
 		.lname	= "Log offset of IO",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(log_offset),
+		.off1	= offsetof(struct thread_options, log_offset),
 		.help	= "Include offset of IO for each log entry",
 		.def	= "0",
 		.category = FIO_OPT_C_LOG,
@@ -3595,7 +3597,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_compression",
 		.lname	= "Log compression",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(log_gz),
+		.off1	= offsetof(struct thread_options, log_gz),
 		.help	= "Log in compressed chunks of this size",
 		.minval	= 1024ULL,
 		.maxval	= 512 * 1024 * 1024ULL,
@@ -3608,7 +3610,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Log Compression CPUs",
 		.type	= FIO_OPT_STR,
 		.cb	= str_log_cpus_allowed_cb,
-		.off1	= td_var_offset(log_gz_cpumask),
+		.off1	= offsetof(struct thread_options, log_gz_cpumask),
 		.parent = "log_compression",
 		.help	= "Limit log compression to these CPUs",
 		.category = FIO_OPT_C_LOG,
@@ -3626,7 +3628,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_store_compressed",
 		.lname	= "Log store compressed",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(log_gz_store),
+		.off1	= offsetof(struct thread_options, log_gz_store),
 		.help	= "Store logs in a compressed format",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3649,7 +3651,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "block_error_percentiles",
 		.lname	= "Block error percentiles",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(block_error_hist),
+		.off1	= offsetof(struct thread_options, block_error_hist),
 		.help	= "Record trim block errors and make a histogram",
 		.def	= "0",
 		.category = FIO_OPT_C_LOG,
@@ -3659,7 +3661,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "bwavgtime",
 		.lname	= "Bandwidth average time",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(bw_avg_time),
+		.off1	= offsetof(struct thread_options, bw_avg_time),
 		.help	= "Time window over which to calculate bandwidth"
 			  " (msec)",
 		.def	= "500",
@@ -3673,7 +3675,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "iopsavgtime",
 		.lname	= "IOPS average time",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iops_avg_time),
+		.off1	= offsetof(struct thread_options, iops_avg_time),
 		.help	= "Time window over which to calculate IOPS (msec)",
 		.def	= "500",
 		.parent	= "write_iops_log",
@@ -3686,7 +3688,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "group_reporting",
 		.lname	= "Group reporting",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(group_reporting),
+		.off1	= offsetof(struct thread_options, group_reporting),
 		.help	= "Do reporting on a per-group basis",
 		.category = FIO_OPT_C_STAT,
 		.group	= FIO_OPT_G_INVALID,
@@ -3695,7 +3697,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "zero_buffers",
 		.lname	= "Zero I/O buffers",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(zero_buffers),
+		.off1	= offsetof(struct thread_options, zero_buffers),
 		.help	= "Init IO buffers to all zeroes",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_BUF,
@@ -3704,7 +3706,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "refill_buffers",
 		.lname	= "Refill I/O buffers",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= td_var_offset(refill_buffers),
+		.off1	= offsetof(struct thread_options, refill_buffers),
 		.help	= "Refill IO buffers on every IO submit",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_BUF,
@@ -3713,7 +3715,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "scramble_buffers",
 		.lname	= "Scramble I/O buffers",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(scramble_buffers),
+		.off1	= offsetof(struct thread_options, scramble_buffers),
 		.help	= "Slightly scramble buffers on every IO submit",
 		.def	= "1",
 		.category = FIO_OPT_C_IO,
@@ -3724,7 +3726,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Buffer pattern",
 		.type	= FIO_OPT_STR,
 		.cb	= str_buffer_pattern_cb,
-		.off1	= td_var_offset(buffer_pattern),
+		.off1	= offsetof(struct thread_options, buffer_pattern),
 		.help	= "Fill pattern for IO buffers",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_BUF,
@@ -3734,7 +3736,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Buffer compression percentage",
 		.type	= FIO_OPT_INT,
 		.cb	= str_buffer_compress_cb,
-		.off1	= td_var_offset(compress_percentage),
+		.off1	= offsetof(struct thread_options, compress_percentage),
 		.maxval	= 100,
 		.minval	= 0,
 		.help	= "How compressible the buffer is (approximately)",
@@ -3746,7 +3748,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "buffer_compress_chunk",
 		.lname	= "Buffer compression chunk size",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(compress_chunk),
+		.off1	= offsetof(struct thread_options, compress_chunk),
 		.parent	= "buffer_compress_percentage",
 		.hide	= 1,
 		.help	= "Size of compressible region in buffer",
@@ -3759,7 +3761,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Dedupe percentage",
 		.type	= FIO_OPT_INT,
 		.cb	= str_dedupe_cb,
-		.off1	= td_var_offset(dedupe_percentage),
+		.off1	= offsetof(struct thread_options, dedupe_percentage),
 		.maxval	= 100,
 		.minval	= 0,
 		.help	= "Percentage of buffers that are dedupable",
@@ -3771,7 +3773,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "clat_percentiles",
 		.lname	= "Completion latency percentiles",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(clat_percentiles),
+		.off1	= offsetof(struct thread_options, clat_percentiles),
 		.help	= "Enable the reporting of completion latency percentiles",
 		.def	= "1",
 		.category = FIO_OPT_C_STAT,
@@ -3781,8 +3783,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "percentile_list",
 		.lname	= "Percentile list",
 		.type	= FIO_OPT_FLOAT_LIST,
-		.off1	= td_var_offset(percentile_list),
-		.off2	= td_var_offset(percentile_precision),
+		.off1	= offsetof(struct thread_options, percentile_list),
+		.off2	= offsetof(struct thread_options, percentile_precision),
 		.help	= "Specify a custom list of percentiles to report for "
 			  "completion latency and block errors",
 		.def    = "1:5:10:20:30:40:50:60:70:80:90:95:99:99.5:99.9:99.95:99.99",
@@ -3798,7 +3800,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "disk_util",
 		.lname	= "Disk utilization",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(do_disk_util),
+		.off1	= offsetof(struct thread_options, do_disk_util),
 		.help	= "Log disk utilization statistics",
 		.def	= "1",
 		.category = FIO_OPT_C_STAT,
@@ -3827,7 +3829,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "disable_lat",
 		.lname	= "Disable all latency stats",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(disable_lat),
+		.off1	= offsetof(struct thread_options, disable_lat),
 		.help	= "Disable latency numbers",
 		.parent	= "gtod_reduce",
 		.hide	= 1,
@@ -3839,7 +3841,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "disable_clat",
 		.lname	= "Disable completion latency stats",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(disable_clat),
+		.off1	= offsetof(struct thread_options, disable_clat),
 		.help	= "Disable completion latency numbers",
 		.parent	= "gtod_reduce",
 		.hide	= 1,
@@ -3851,7 +3853,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "disable_slat",
 		.lname	= "Disable submission latency stats",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(disable_slat),
+		.off1	= offsetof(struct thread_options, disable_slat),
 		.help	= "Disable submission latency numbers",
 		.parent	= "gtod_reduce",
 		.hide	= 1,
@@ -3863,7 +3865,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "disable_bw_measurement",
 		.lname	= "Disable bandwidth stats",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(disable_bw),
+		.off1	= offsetof(struct thread_options, disable_bw),
 		.help	= "Disable bandwidth logging",
 		.parent	= "gtod_reduce",
 		.hide	= 1,
@@ -3875,7 +3877,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "gtod_cpu",
 		.lname	= "Dedicated gettimeofday() CPU",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(gtod_cpu),
+		.off1	= offsetof(struct thread_options, gtod_cpu),
 		.help	= "Set up dedicated gettimeofday() thread on this CPU",
 		.verify	= gtod_cpu_verify,
 		.category = FIO_OPT_C_GENERAL,
@@ -3885,7 +3887,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "unified_rw_reporting",
 		.lname	= "Unified RW Reporting",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(unified_rw_rep),
+		.off1	= offsetof(struct thread_options, unified_rw_rep),
 		.help	= "Unify reporting across data direction",
 		.def	= "0",
 		.category = FIO_OPT_C_GENERAL,
@@ -3895,7 +3897,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "continue_on_error",
 		.lname	= "Continue on error",
 		.type	= FIO_OPT_STR,
-		.off1	= td_var_offset(continue_on_error),
+		.off1	= offsetof(struct thread_options, continue_on_error),
 		.help	= "Continue on non-fatal errors during IO",
 		.def	= "none",
 		.category = FIO_OPT_C_GENERAL,
@@ -3940,7 +3942,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Ignore Error",
 		.type	= FIO_OPT_STR,
 		.cb	= str_ignore_error_cb,
-		.off1	= td_var_offset(ignore_error_nr),
+		.off1	= offsetof(struct thread_options, ignore_error_nr),
 		.help	= "Set a specific list of errors to ignore",
 		.parent	= "rw",
 		.category = FIO_OPT_C_GENERAL,
@@ -3950,7 +3952,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "error_dump",
 		.lname	= "Error Dump",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(error_dump),
+		.off1	= offsetof(struct thread_options, error_dump),
 		.def	= "0",
 		.help	= "Dump info on each error",
 		.category = FIO_OPT_C_GENERAL,
@@ -3960,7 +3962,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "profile",
 		.lname	= "Profile",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(profile),
+		.off1	= offsetof(struct thread_options, profile),
 		.help	= "Select a specific builtin performance test",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_INVALID,
@@ -3969,7 +3971,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "cgroup",
 		.lname	= "Cgroup",
 		.type	= FIO_OPT_STR_STORE,
-		.off1	= td_var_offset(cgroup),
+		.off1	= offsetof(struct thread_options, cgroup),
 		.help	= "Add job to cgroup of this name",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CGROUP,
@@ -3978,7 +3980,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "cgroup_nodelete",
 		.lname	= "Cgroup no-delete",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(cgroup_nodelete),
+		.off1	= offsetof(struct thread_options, cgroup_nodelete),
 		.help	= "Do not delete cgroups after job completion",
 		.def	= "0",
 		.parent	= "cgroup",
@@ -3989,7 +3991,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "cgroup_weight",
 		.lname	= "Cgroup weight",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(cgroup_weight),
+		.off1	= offsetof(struct thread_options, cgroup_weight),
 		.help	= "Use given weight for cgroup",
 		.minval = 100,
 		.maxval	= 1000,
@@ -4001,7 +4003,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "uid",
 		.lname	= "User ID",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(uid),
+		.off1	= offsetof(struct thread_options, uid),
 		.help	= "Run job with this user ID",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
@@ -4010,7 +4012,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "gid",
 		.lname	= "Group ID",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(gid),
+		.off1	= offsetof(struct thread_options, gid),
 		.help	= "Run job with this group ID",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
@@ -4019,7 +4021,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "kb_base",
 		.lname	= "KB Base",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(kb_base),
+		.off1	= offsetof(struct thread_options, kb_base),
 		.prio	= 1,
 		.def	= "1024",
 		.posval = {
@@ -4040,7 +4042,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "unit_base",
 		.lname	= "Base unit for reporting (Bits or Bytes)",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(unit_base),
+		.off1	= offsetof(struct thread_options, unit_base),
 		.prio	= 1,
 		.posval = {
 			  { .ival = "0",
@@ -4064,7 +4066,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "hugepage-size",
 		.lname	= "Hugepage size",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(hugepage_size),
+		.off1	= offsetof(struct thread_options, hugepage_size),
 		.help	= "When using hugepages, specify size of each page",
 		.def	= __fio_stringify(FIO_HUGE_PAGE),
 		.interval = 1024 * 1024,
@@ -4075,7 +4077,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "flow_id",
 		.lname	= "I/O flow ID",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(flow_id),
+		.off1	= offsetof(struct thread_options, flow_id),
 		.help	= "The flow index ID to use",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
@@ -4085,7 +4087,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "flow",
 		.lname	= "I/O flow weight",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(flow),
+		.off1	= offsetof(struct thread_options, flow),
 		.help	= "Weight for flow control of this job",
 		.parent	= "flow_id",
 		.hide	= 1,
@@ -4097,7 +4099,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "flow_watermark",
 		.lname	= "I/O flow watermark",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(flow_watermark),
+		.off1	= offsetof(struct thread_options, flow_watermark),
 		.help	= "High watermark for flow control. This option"
 			" should be set to the same value for all threads"
 			" with non-zero flow.",
@@ -4111,7 +4113,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "flow_sleep",
 		.lname	= "I/O flow sleep",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(flow_sleep),
+		.off1	= offsetof(struct thread_options, flow_sleep),
 		.help	= "How many microseconds to sleep after being held"
 			" back by the flow control mechanism",
 		.parent	= "flow_id",
@@ -4124,7 +4126,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "skip_bad",
 		.lname	= "Skip operations against bad blocks",
 		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(skip_bad),
+		.off1	= offsetof(struct thread_options, skip_bad),
 		.help	= "Skip operations against known bad blocks.",
 		.hide	= 1,
 		.def	= "0",
@@ -4474,7 +4476,7 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 	for (ret = 0, i = 0, unknown = 0; i < num_opts; i++) {
 		struct fio_option *o;
 		int newret = parse_option(opts_copy[i], opts[i], fio_options,
-						&o, td, &td->opt_list);
+						&o, &td->o, &td->opt_list);
 
 		if (!newret && o)
 			fio_option_mark_set(&td->o, o);
@@ -4527,7 +4529,7 @@ int fio_cmd_option_parse(struct thread_data *td, const char *opt, char *val)
 {
 	int ret;
 
-	ret = parse_cmd_option(opt, val, fio_options, td, &td->opt_list);
+	ret = parse_cmd_option(opt, val, fio_options, &td->o, &td->opt_list);
 	if (!ret) {
 		struct fio_option *o;
 
@@ -4549,7 +4551,7 @@ int fio_cmd_ioengine_option_parse(struct thread_data *td, const char *opt,
 void fio_fill_default_options(struct thread_data *td)
 {
 	td->o.magic = OPT_MAGIC;
-	fill_default_options(td, fio_options);
+	fill_default_options(&td->o, fio_options);
 }
 
 int fio_show_option_help(const char *opt)
@@ -4590,7 +4592,8 @@ void fio_options_mem_dupe(struct thread_data *td)
 
 unsigned int fio_get_kb_base(void *data)
 {
-	struct thread_options *o = data;
+	struct thread_data *td = cb_data_to_td(data);
+	struct thread_options *o = &td->o;
 	unsigned int kb_base = 0;
 
 	/*
@@ -4686,7 +4689,7 @@ void del_opt_posval(const char *optname, const char *ival)
 
 void fio_options_free(struct thread_data *td)
 {
-	options_free(fio_options, td);
+	options_free(fio_options, &td->o);
 	if (td->eo && td->io_ops && td->io_ops->options) {
 		options_free(td->io_ops->options, td->eo);
 		free(td->eo);
diff --git a/options.h b/options.h
index 539a636..83a58e2 100644
--- a/options.h
+++ b/options.h
@@ -9,8 +9,6 @@
 #include "flist.h"
 #include "lib/types.h"
 
-#define td_var_offset(var)	((size_t) &((struct thread_options *)0)->var)
-
 int add_option(struct fio_option *);
 void invalidate_profile_options(const char *);
 extern char *exec_profile;
@@ -19,7 +17,6 @@ void add_opt_posval(const char *, const char *, const char *);
 void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
-char *get_name_idx(char *, int);
 int set_name_idx(char *, size_t, char *, int, bool);
 
 extern char client_sockaddr_str[];  /* used with --client option */
@@ -30,7 +27,7 @@ extern bool __fio_option_is_set(struct thread_options *, unsigned int off);
 
 #define fio_option_is_set(__td, name)					\
 ({									\
-	const unsigned int off = td_var_offset(name);			\
+	const unsigned int off = offsetof(struct thread_options, name);	\
 	bool __r = __fio_option_is_set((__td), off);			\
 	__r;								\
 })
diff --git a/oslib/libmtd.c b/oslib/libmtd.c
index 5c9eac2..5b22d6a 100644
--- a/oslib/libmtd.c
+++ b/oslib/libmtd.c
@@ -1190,7 +1190,7 @@ int mtd_write(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb,
 	return 0;
 }
 
-int do_oob_op(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
+static int do_oob_op(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
 	      uint64_t start, uint64_t length, void *data, unsigned int cmd64,
 	      unsigned int cmd)
 {
diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 3a415dd..2bbd14a 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -6,6 +6,7 @@
 #include <unistd.h>
 
 #include "../os/os.h"
+#include "oslib/linux-dev-lookup.h"
 
 int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
 			   unsigned int min)
diff --git a/oslib/strlcat.c b/oslib/strlcat.c
index 643d496..3329b83 100644
--- a/oslib/strlcat.c
+++ b/oslib/strlcat.c
@@ -1,4 +1,5 @@
 #include <string.h>
+#include "oslib/strlcat.h"
 
 size_t strlcat(char *dst, const char *src, size_t size)
 {
diff --git a/parse.c b/parse.c
index 086f786..8ed4619 100644
--- a/parse.c
+++ b/parse.c
@@ -1250,7 +1250,7 @@ void fill_default_options(void *data, struct fio_option *options)
 			handle_option(o, o->def, data);
 }
 
-void option_init(struct fio_option *o)
+static void option_init(struct fio_option *o)
 {
 	if (o->type == FIO_OPT_DEPRECATED || o->type == FIO_OPT_UNSUPPORTED)
 		return;
diff --git a/parse.h b/parse.h
index aa00a67..d852ddc 100644
--- a/parse.h
+++ b/parse.h
@@ -80,14 +80,11 @@ struct fio_option {
 	int pow2;			/* must be a power-of-2 */
 };
 
-typedef int (str_cb_fn)(void *, char *);
-
 extern int parse_option(char *, const char *, struct fio_option *, struct fio_option **, void *, struct flist_head *);
 extern void sort_options(char **, struct fio_option *, int);
 extern int parse_cmd_option(const char *t, const char *l, struct fio_option *, void *, struct flist_head *);
 extern int show_cmd_help(struct fio_option *, const char *);
 extern void fill_default_options(void *, struct fio_option *);
-extern void option_init(struct fio_option *);
 extern void options_init(struct fio_option *);
 extern void options_free(struct fio_option *, void *);
 
@@ -107,18 +104,19 @@ extern int string_distance_ok(const char *s1, int dist);
 typedef int (fio_opt_str_fn)(void *, const char *);
 typedef int (fio_opt_str_val_fn)(void *, long long *);
 typedef int (fio_opt_int_fn)(void *, int *);
-typedef int (fio_opt_str_set_fn)(void *);
-
-#define __td_var(start, offset)	((char *) start + (offset))
 
 struct thread_options;
 static inline void *td_var(struct thread_options *to, struct fio_option *o,
 			   unsigned int offset)
 {
+	void *ret;
+
 	if (o->prof_opts)
-		return __td_var(o->prof_opts, offset);
+		ret = o->prof_opts;
+	else
+		ret = to;
 
-	return __td_var(to, offset);
+	return ret + offset;
 }
 
 static inline int parse_is_percent(unsigned long long val)
diff --git a/rate-submit.c b/rate-submit.c
index 48b7a58..2efbdcb 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -110,9 +110,6 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	if (ioengine_load(td))
 		goto err;
 
-	if (td->o.odirect)
-		td->io_ops->flags |= FIO_RAWIO;
-
 	td->pid = gettid();
 
 	INIT_FLIST_HEAD(&td->io_log_list);
diff --git a/server.c b/server.c
index 2fd9b45..9f2220d 100644
--- a/server.c
+++ b/server.c
@@ -622,7 +622,7 @@ static int fio_net_queue_quit(void)
 {
 	dprint(FD_NET, "server: sending quit\n");
 
-	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, 0, SK_F_SIMPLE);
+	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, NULL, SK_F_SIMPLE);
 }
 
 int fio_net_send_quit(int sk)
@@ -1883,7 +1883,7 @@ void fio_server_send_start(struct thread_data *td)
 
 	assert(sk_out->sk != -1);
 
-	fio_net_queue_cmd(FIO_NET_CMD_SERVER_START, NULL, 0, 0, SK_F_SIMPLE);
+	fio_net_queue_cmd(FIO_NET_CMD_SERVER_START, NULL, 0, NULL, SK_F_SIMPLE);
 }
 
 int fio_server_get_verify_state(const char *name, int threadnumber,
diff --git a/stat.c b/stat.c
index ef9fe7d..6f5f002 100644
--- a/stat.c
+++ b/stat.c
@@ -257,13 +257,13 @@ out:
 		free(ovals);
 }
 
-int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
-	     double *mean, double *dev)
+bool calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
+	      double *mean, double *dev)
 {
 	double n = (double) is->samples;
 
 	if (n == 0)
-		return 0;
+		return false;
 
 	*min = is->min_val;
 	*max = is->max_val;
@@ -274,7 +274,7 @@ int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 	else
 		*dev = 0;
 
-	return 1;
+	return true;
 }
 
 void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
@@ -364,7 +364,7 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 	const char *base = "(usec)";
 	char *minp, *maxp;
 
-	if (!usec_to_msec(&min, &max, &mean, &dev))
+	if (usec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
 
 	minp = num2str(min, 6, 1, 0, 0);
@@ -1090,8 +1090,8 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 	log_buf(out, "\n");
 }
 
-void json_add_job_opts(struct json_object *root, const char *name,
-		       struct flist_head *opt_list, bool num_jobs)
+static void json_add_job_opts(struct json_object *root, const char *name,
+			      struct flist_head *opt_list, bool num_jobs)
 {
 	struct json_object *dir_object;
 	struct flist_head *entry;
diff --git a/stat.h b/stat.h
index 86f1a0b..c3e343d 100644
--- a/stat.h
+++ b/stat.h
@@ -249,7 +249,7 @@ extern void stat_exit(void);
 
 extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs, struct flist_head *, struct buf_output *);
 extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
-extern int calc_thread_status(struct jobs_eta *je, int force);
+extern bool calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void show_run_stats(void);
 extern void __show_run_stats(void);
@@ -261,7 +261,7 @@ extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats
 extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
-extern int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max, double *mean, double *dev);
+extern bool calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max, double *mean, double *dev);
 extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr, fio_fp64_t *plist, unsigned int **output, unsigned int *maxv, unsigned int *minv);
 extern void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat);
@@ -286,18 +286,18 @@ extern int calc_log_samples(void);
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern int write_bw_log;
 
-static inline int usec_to_msec(unsigned long *min, unsigned long *max,
-			       double *mean, double *dev)
+static inline bool usec_to_msec(unsigned long *min, unsigned long *max,
+				double *mean, double *dev)
 {
 	if (*min > 1000 && *max > 1000 && *mean > 1000.0 && *dev > 1000.0) {
 		*min /= 1000;
 		*max /= 1000;
 		*mean /= 1000.0;
 		*dev /= 1000.0;
-		return 0;
+		return true;
 	}
 
-	return 1;
+	return false;
 }
 /*
  * Worst level condensing would be 1:5, so allow enough room for that
diff --git a/verify.c b/verify.c
index 40cfbab..790ab31 100644
--- a/verify.c
+++ b/verify.c
@@ -41,13 +41,14 @@ void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len)
 	(void)cpy_pattern(td->o.buffer_pattern, td->o.buffer_pattern_bytes, p, len);
 }
 
-void __fill_buffer(struct thread_options *o, unsigned long seed, void *p,
-		   unsigned int len)
+static void __fill_buffer(struct thread_options *o, unsigned long seed, void *p,
+			  unsigned int len)
 {
 	__fill_random_buf_percentage(seed, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
 }
 
-unsigned long fill_buffer(struct thread_data *td, void *p, unsigned int len)
+static unsigned long fill_buffer(struct thread_data *td, void *p,
+				 unsigned int len)
 {
 	struct frand_state *fs = &td->verify_state;
 	struct thread_options *o = &td->o;
@@ -802,7 +803,7 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 	 * If the IO engine is faking IO (like null), then just pretend
 	 * we verified everything.
 	 */
-	if (td->io_ops->flags & FIO_FAKEIO)
+	if (td_ioengine_flagged(td, FIO_FAKEIO))
 		return 0;
 
 	if (io_u->flags & IO_U_F_TRIMMED) {
