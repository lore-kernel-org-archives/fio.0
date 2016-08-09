Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbcHIMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Aug 2016 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bX5hX-0007OQ-Qm
	for fio@vger.kernel.org; Tue, 09 Aug 2016 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160809120006.9D4B62C00A2@kernel.dk>
Date: Tue,  9 Aug 2016 06:00:06 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 93168285bc564941d832deea172dc1f68de68666:

  stat: fixups to histogram logging (2016-08-07 15:18:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9973b0f961a57c19f885ffca05f86ae6ef85f8c7:

  iolog: silence warning on pointer cast on 32-bit compiles (2016-08-08 11:32:34 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      iolog: hist_sum() should return unsigned long
      ioengines: fixup td_io_unlink_file() error propagation
      Fix spelling error
      iolog: silence warning on pointer cast on 32-bit compiles

Tomohiro Kusumi (6):
      Use char* for pid_file path
      Change --output-format argument from optional to required
      Make local const string array static
      Add missing FIO_NET_CMD entry to fio_server_ops[]
      Use a pointer to const char* for I/O engine name (in response to aa2b823c)
      Check if sysfs ioscheduler entry is "none"

mrturtledev (1):
      Add 'unlink_each_loop' option

 HOWTO             |  4 +++-
 backend.c         | 36 +++++++++++++++++++++++++++++++++++-
 cconv.c           |  2 ++
 engines/pmemblk.c |  2 +-
 filesetup.c       |  6 +++++-
 fio.1             |  3 +++
 init.c            | 10 ++--------
 io_ddir.h         |  2 +-
 ioengine.h        |  2 +-
 ioengines.c       | 11 +++++++++--
 iolog.c           |  9 +++++----
 options.c         | 12 +++++++++++-
 server.c          |  1 +
 server.h          |  2 +-
 thread_options.h  |  3 ++-
 15 files changed, 82 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0085b74..5bf7125 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1295,7 +1295,7 @@ iopsavgtime=int	Average the calculated IOPS over the given time. Value
 		through 'write_iops_log', then the minimum of this option and
 		'log_avg_msec' will be used.  Default: 500ms.
 
-create_serialize=bool	If true, serialize the file creating for the jobs.
+create_serialize=bool	If true, serialize the file creation for the jobs.
 			This may be handy to avoid interleaving of data
 			files, which may greatly depend on the filesystem
 			used and even the number of processors in the system.
@@ -1334,6 +1334,8 @@ unlink=bool	Unlink the job files when done. Not the default, as repeated
 		runs of that job would then waste time recreating the file
 		set again and again.
 
+unlink_each_loop=bool	Unlink job files after each iteration or loop.
+
 loops=int	Run the specified number of iterations of this job. Used
 		to repeat the same workload a given number of times. Defaults
 		to 1.
diff --git a/backend.c b/backend.c
index c3ad831..6bf5d67 100644
--- a/backend.c
+++ b/backend.c
@@ -571,6 +571,28 @@ static inline bool io_in_polling(struct thread_data *td)
 	return !td->o.iodepth_batch_complete_min &&
 		   !td->o.iodepth_batch_complete_max;
 }
+/*
+ * Unlinks files from thread data fio_file structure
+ */
+static int unlink_all_files(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+	int ret = 0;
+
+	for_each_file(td, f, i) {
+		if (f->filetype != FIO_TYPE_FILE)
+			continue;
+		ret = td_io_unlink_file(td, f);
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		td_verror(td, ret, "unlink_all_files");
+
+	return ret;
+}
 
 /*
  * The main verify engine. Runs over the writes we previously submitted,
@@ -1309,6 +1331,14 @@ static int switch_ioscheduler(struct thread_data *td)
 	 */
 	tmp[strlen(tmp) - 1] = '\0';
 
+	/*
+	 * Write to "none" entry doesn't fail, so check the result here.
+	 */
+	if (!strcmp(tmp, "none")) {
+		log_err("fio: io scheduler is not tunable\n");
+		fclose(f);
+		return 0;
+	}
 
 	sprintf(tmp2, "[%s]", td->o.ioscheduler);
 	if (!strstr(tmp, tmp2)) {
@@ -1667,9 +1697,13 @@ static void *thread_main(void *data)
 		fio_gettime(&td->start, NULL);
 		memcpy(&td->tv_cache, &td->start, sizeof(td->start));
 
-		if (clear_state)
+		if (clear_state) {
 			clear_io_state(td, 0);
 
+			if (o->unlink_each_loop && unlink_all_files(td))
+				break;
+		}
+
 		prune_io_piece_log(td);
 
 		if (td->o.verify_only && (td_write(td) || td_rw(td)))
diff --git a/cconv.c b/cconv.c
index 837963d..8d9a0a8 100644
--- a/cconv.c
+++ b/cconv.c
@@ -174,6 +174,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_batch = le32_to_cpu(top->verify_batch);
 	o->use_thread = le32_to_cpu(top->use_thread);
 	o->unlink = le32_to_cpu(top->unlink);
+	o->unlink_each_loop = le32_to_cpu(top->unlink_each_loop);
 	o->do_disk_util = le32_to_cpu(top->do_disk_util);
 	o->override_sync = le32_to_cpu(top->override_sync);
 	o->rand_repeatable = le32_to_cpu(top->rand_repeatable);
@@ -367,6 +368,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->verify_batch = cpu_to_le32(o->verify_batch);
 	top->use_thread = cpu_to_le32(o->use_thread);
 	top->unlink = cpu_to_le32(o->unlink);
+	top->unlink_each_loop = cpu_to_le32(o->unlink_each_loop);
 	top->do_disk_util = cpu_to_le32(o->do_disk_util);
 	top->override_sync = cpu_to_le32(o->override_sync);
 	top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 6d19864..ca72697 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -475,7 +475,7 @@ static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
 
 	pmb_parse_path(f->file_name, &path, &bsize, &fsize);
 	if (!path)
-		return 1;
+		return ENOENT;
 
 	unlink(path);
 	free(path);
diff --git a/filesetup.c b/filesetup.c
index 1ecdda6..42a9f41 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -58,8 +58,12 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		unlink_file = 1;
 
 	if (unlink_file || new_layout) {
+		int ret;
+
 		dprint(FD_FILE, "layout unlink %s\n", f->file_name);
-		if ((td_io_unlink_file(td, f) < 0) && (errno != ENOENT)) {
+
+		ret = td_io_unlink_file(td, f);
+		if (ret != 0 && ret != ENOENT) {
 			td_verror(td, errno, "unlink");
 			return 1;
 		}
diff --git a/fio.1 b/fio.1
index d1acebc..696664a 100644
--- a/fio.1
+++ b/fio.1
@@ -1246,6 +1246,9 @@ multiple times. Thus it will not work on eg network or splice IO.
 .BI unlink \fR=\fPbool
 Unlink job files when done.  Default: false.
 .TP
+.BI unlink_each_loop \fR=\fPbool
+Unlink job files after each iteration or loop.  Default: false.
+.TP
 .BI loops \fR=\fPint
 Specifies the number of iterations (runs of the same workload) of this job.
 Default: 1.
diff --git a/init.c b/init.c
index 048bd5d..fb07daa 100644
--- a/init.c
+++ b/init.c
@@ -114,7 +114,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	},
 	{
 		.name		= (char *) "output-format",
-		.has_arg	= optional_argument,
+		.has_arg	= required_argument,
 		.val		= 'F' | FIO_CLIENT_FLAG,
 	},
 	{
@@ -2302,7 +2302,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 	struct thread_data *td = NULL;
 	int c, ini_idx = 0, lidx, ret = 0, do_exit = 0, exit_val = 0;
 	char *ostr = cmd_optstr;
-	void *pid_file = NULL;
+	char *pid_file = NULL;
 	void *cur_client = NULL;
 	int backend = 0;
 
@@ -2352,12 +2352,6 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			output_format = FIO_OUTPUT_TERSE;
 			break;
 		case 'F':
-			if (!optarg) {
-				log_err("fio: missing --output-format argument\n");
-				exit_val = 1;
-				do_exit++;
-				break;
-			}
 			if (parse_output_format(optarg)) {
 				log_err("fio: failed parsing output-format\n");
 				exit_val = 1;
diff --git a/io_ddir.h b/io_ddir.h
index 763e826..2141119 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -61,7 +61,7 @@ static inline int ddir_rw(enum fio_ddir ddir)
 
 static inline const char *ddir_str(enum td_ddir ddir)
 {
-	const char *__str[] = { NULL, "read", "write", "rw", NULL,
+	static const char *__str[] = { NULL, "read", "write", "rw", NULL,
 				"randread", "randwrite", "randrw",
 				"trim", NULL, NULL, NULL, "randtrim" };
 
diff --git a/ioengine.h b/ioengine.h
index 0effade..ceed329 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -138,7 +138,7 @@ enum {
 
 struct ioengine_ops {
 	struct flist_head list;
-	char name[16];
+	const char *name;
 	int version;
 	int flags;
 	int (*setup)(struct thread_data *);
diff --git a/ioengines.c b/ioengines.c
index 4129ac2..a06909e 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -521,8 +521,15 @@ int td_io_unlink_file(struct thread_data *td, struct fio_file *f)
 {
 	if (td->io_ops->unlink_file)
 		return td->io_ops->unlink_file(td, f);
-	else
-		return unlink(f->file_name);
+	else {
+		int ret;
+
+		ret = unlink(f->file_name);
+		if (ret < 0)
+			return errno;
+
+		return 0;
+	}
 }
 
 int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
diff --git a/iolog.c b/iolog.c
index a9cbd5b..975ce6f 100644
--- a/iolog.c
+++ b/iolog.c
@@ -661,9 +661,10 @@ void free_log(struct io_log *log)
 	sfree(log);
 }
 
-static inline int hist_sum(int j, int stride, unsigned int *io_u_plat)
+static inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat)
 {
-	int k, sum;
+	unsigned long sum;
+	int k;
 
 	for (k = sum = 0; k < stride; k++)
 		sum += io_u_plat[j + k];
@@ -691,11 +692,11 @@ void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
-		io_u_plat = (unsigned int *) s->val;
+		io_u_plat = (unsigned int *) (uintptr_t) s->val;
 		fprintf(f, "%lu, %u, %u, ", (unsigned long)s->time,
 		        io_sample_ddir(s), s->bs);
 		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
-			fprintf(f, "%lu, ", (unsigned long) hist_sum(j, stride, io_u_plat)); 
+			fprintf(f, "%lu, ", hist_sum(j, stride, io_u_plat));
 		}
 		fprintf(f, "%lu\n", (unsigned long) 
 		        hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat));
diff --git a/options.c b/options.c
index 56d3e2b..56e51fc 100644
--- a/options.c
+++ b/options.c
@@ -3241,7 +3241,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Create serialize",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(create_serialize),
-		.help	= "Serialize creating of job files",
+		.help	= "Serialize creation of job files",
 		.def	= "1",
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
@@ -3433,6 +3433,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "unlink_each_loop",
+		.lname	= "Unlink file after each loop of a job",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(unlink_each_loop),
+		.help	= "Unlink created files after each loop in a job has completed",
+		.def	= "0",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "exitall",
 		.lname	= "Exit-all on terminate",
 		.type	= FIO_OPT_STR_SET,
diff --git a/server.c b/server.c
index 667a66c..2fd9b45 100644
--- a/server.c
+++ b/server.c
@@ -114,6 +114,7 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 	"LOAD_FILE",
 	"VTRIGGER",
 	"SENDFILE",
+	"JOB_OPT",
 };
 
 static void sk_lock(struct sk_out *sk_out)
diff --git a/server.h b/server.h
index c17c3bb..fb384fb 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 55,
+	FIO_SERVER_VER			= 56,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 449c66f..d70fda3 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -121,6 +121,7 @@ struct thread_options {
 	unsigned int verify_state_save;
 	unsigned int use_thread;
 	unsigned int unlink;
+	unsigned int unlink_each_loop;
 	unsigned int do_disk_util;
 	unsigned int override_sync;
 	unsigned int rand_repeatable;
@@ -378,6 +379,7 @@ struct thread_options_pack {
 	uint32_t verify_state_save;
 	uint32_t use_thread;
 	uint32_t unlink;
+	uint32_t unlink_each_loop;
 	uint32_t do_disk_util;
 	uint32_t override_sync;
 	uint32_t rand_repeatable;
@@ -396,7 +398,6 @@ struct thread_options_pack {
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
 	uint32_t bs_is_seq_rand;
-	uint32_t pad1;
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
