Return-Path: <axboe@kernel.dk>
Subject: Re: Unlink after each loop in job
References: <CAG6KGPRQf7Mii35T1drhL=u0mZB8PQEeOMnmuBFWSNgBy4E31A@mail.gmail.com>
 <CAG6KGPSthqs28GTQYSnFGcs_XzQWdALQ8knUS7ook2-_wurcmw@mail.gmail.com>
 <4ac1a598-480e-bfa6-3704-929c909be5da@kernel.dk>
 <b67f4217-97f3-f9f9-46a1-92c9b43ba9b9@kernel.dk>
 <CAG6KGPSukQwdmfcJiE7CSHZf4hYV4niHm2QQcM1tyE=kBHBtzw@mail.gmail.com>
 <0523eea4-0332-2b8e-a595-fd66cd6ae3de@kernel.dk>
 <1678347027.185727.1470640779017.JavaMail.zimbra@redhat.com>
 <c9875949-57c5-aac6-4665-d50cf6e34261@kernel.dk>
 <1464993948.447706.1470665651090.JavaMail.zimbra@redhat.com>
 <6881e50d-9779-01e0-7a54-c3131c09dc6b@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bdaafdc4-50ac-d720-9470-e3547d34a972@kernel.dk>
Date: Mon, 8 Aug 2016 09:33:22 -0600
MIME-Version: 1.0
In-Reply-To: <6881e50d-9779-01e0-7a54-c3131c09dc6b@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <evelu@redhat.com>
Cc: Martin Dev <mrturtledev@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/08/2016 08:18 AM, Jens Axboe wrote:
> On 08/08/2016 08:14 AM, Erwan Velu wrote:
>> Sorry, I was'nt that clear in my message :/
>>
>> The guy that offered the patch have passed through the #fio channel on
>> OFTC and we spoke about the need of that patch.  > I was just curious
>> to read it and wasn't able to find where the patch that is under
>> discussion is.
>
> It just needs a little polish, then it can go in.

Martin, can you check if this one works as you expect? It's building on
top of yours, adding the missing bits, and fixing up td_io_unlink_file()
error propagation as well.


diff --git a/HOWTO b/HOWTO
index 0085b7471ff6..9d71a96cc844 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1334,6 +1334,8 @@ unlink=bool	Unlink the job files when done. Not 
the default, as repeated
  		runs of that job would then waste time recreating the file
  		set again and again.

+unlink_each_loop=bool	Unlink job files after each iteration or loop.
+
  loops=int	Run the specified number of iterations of this job. Used
  		to repeat the same workload a given number of times. Defaults
  		to 1.
diff --git a/backend.c b/backend.c
index c3ad8312de67..58727114ab8f 100644
--- a/backend.c
+++ b/backend.c
@@ -571,6 +571,28 @@ static inline bool io_in_polling(struct thread_data 
*td)
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
@@ -1667,9 +1689,13 @@ static void *thread_main(void *data)
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
index 837963d37354..8d9a0a8e00e9 100644
--- a/cconv.c
+++ b/cconv.c
@@ -174,6 +174,7 @@ void convert_thread_options_to_cpu(struct 
thread_options *o,
  	o->verify_batch = le32_to_cpu(top->verify_batch);
  	o->use_thread = le32_to_cpu(top->use_thread);
  	o->unlink = le32_to_cpu(top->unlink);
+	o->unlink_each_loop = le32_to_cpu(top->unlink_each_loop);
  	o->do_disk_util = le32_to_cpu(top->do_disk_util);
  	o->override_sync = le32_to_cpu(top->override_sync);
  	o->rand_repeatable = le32_to_cpu(top->rand_repeatable);
@@ -367,6 +368,7 @@ void convert_thread_options_to_net(struct 
thread_options_pack *top,
  	top->verify_batch = cpu_to_le32(o->verify_batch);
  	top->use_thread = cpu_to_le32(o->use_thread);
  	top->unlink = cpu_to_le32(o->unlink);
+	top->unlink_each_loop = cpu_to_le32(o->unlink_each_loop);
  	top->do_disk_util = cpu_to_le32(o->do_disk_util);
  	top->override_sync = cpu_to_le32(o->override_sync);
  	top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 6d19864ae0db..ca7269781951 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -475,7 +475,7 @@ static int fio_pmemblk_unlink_file(struct 
thread_data *td, struct fio_file *f)

  	pmb_parse_path(f->file_name, &path, &bsize, &fsize);
  	if (!path)
-		return 1;
+		return ENOENT;

  	unlink(path);
  	free(path);
diff --git a/filesetup.c b/filesetup.c
index 1ecdda61c3f4..42a9f4155fbf 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -58,8 +58,12 @@ static int extend_file(struct thread_data *td, struct 
fio_file *f)
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
index d1acebcdeef1..696664afb081 100644
--- a/fio.1
+++ b/fio.1
@@ -1246,6 +1246,9 @@ multiple times. Thus it will not work on eg 
network or splice IO.
  .BI unlink \fR=\fPbool
  Unlink job files when done.  Default: false.
  .TP
+.BI unlink_each_loop \fR=\fPbool
+Unlink job files after each iteration or loop.  Default: false.
+.TP
  .BI loops \fR=\fPint
  Specifies the number of iterations (runs of the same workload) of this 
job.
  Default: 1.
diff --git a/ioengines.c b/ioengines.c
index 4129ac2363b9..a06909e0ff9d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -521,8 +521,15 @@ int td_io_unlink_file(struct thread_data *td, 
struct fio_file *f)
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
diff --git a/options.c b/options.c
index 56d3e2b6027e..7cd5121988c0 100644
--- a/options.c
+++ b/options.c
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
diff --git a/server.h b/server.h
index c17c3bb571ae..fb384fb15feb 100644
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
index 449c66f5b8af..d70fda3f9491 100644
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

-- 
Jens Axboe


