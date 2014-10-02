Return-Path: <axboe@kernel.dk>
Message-ID: <542D9C6B.1020302@kernel.dk>
Date: Thu, 02 Oct 2014 12:41:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net> <542B52B3.5060908@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net> <542B5632.8030404@kernel.dk> <542B784F.5090405@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC85F9@G4W3202.americas.hpqcorp.net> <542CA321.5090608@kernel.dk> <542CA44D.1030700@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CCAA76@G4W3202.americas.hpqcorp.net> <542D9A26.6060204@kernel.dk>
In-Reply-To: <542D9A26.6060204@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------080205080406040505000603"
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080205080406040505000603
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 10/02/2014 12:32 PM, Jens Axboe wrote:
> On 10/02/2014 12:21 PM, Elliott, Robert (Server Storage) wrote:
>>>>> It might be better to continue to attempt to run the
>>>>> other jobs.
>>>>
>>>> We should just go for the simpler create/nocreate solution, I prefer
>>>> that. This is too involved, and it's hard to get all the cases right
>>>> since there are a bunch of different ways that files are added. Which
>>>> was why this patch only focused on filename=, since that is the one that
>>>> is the most interesting. But it still isn't pretty. If we add the
>>>> allow_file_create option, it's basically a two-liner change in a few
>>>> places to not use O_CREAT.
>>>
>>> That took roughly 4 minutes... Does this work? Set allow_file_create=0
>>> to disallow creating new files.
>>>
>>
>> Mostly.  
>>
>> With no size= setting or size=xx%, the error messages it prints are 
>> about the lack of size, not the fact that file creation is disallowed.
>> It does proceed to run the jobs that have valid filenames.
>>
>> drive_af: you need to specify size=
>> fio: pid=0, err=22/file:filesetup.c:822, func=total_file_size, error=Invalid argument
>> drive_af: you need to specify size=
>> fio: pid=0, err=22/file:filesetup.c:822, func=total_file_size, error=Invalid argument
>> ...
>> drive_ag: you need to specify size=
>> fio: pid=0, err=22/file:filesetup.c:822, func=total_file_size, error=Invalid argument
>> Jobs: 168 (f=168): [r(168),X(24)] [0.0% done] [2449MB/0KB/0KB /s] [627K/0/0 iops] [eta 02d:11h:58m:33s]
> 
> Fio always does this, if the file does not exist and no size is given.
> The reason is that it doesn't know what size to create. But we can
> augment that a little bit if allow_file_create == 0, since the size
> setting would not change that.
> 
>> With size=xxm (a fixed size), it prints complaints about O_DIRECT.
>> It does proceed to run the jobs that have valid filenames.
>>
>> fio: looks like your file system does not support direct=1/buffered=0
>> fio: destination does not support O_DIRECT
>> fio: pid=21834, err=22/file:filesetup.c:613, func=open(/dev/sdaf), error=Invalid argument
>> fio: looks like your file system does not support direct=1/buffered=0
>> fio: destination does not support O_DIRECT
>> fio: pid=21846, err=22/file:filesetup.c:613, func=open(/dev/sdag), error=Invalid argument
>> fio: looks like your file system does not support direct=1/buffered=0
>> fio: destination does not support O_DIRECT
>> ...
>> fio: pid=21856, err=22/file:filesetup.c:613, func=open(/dev/sdag), error=Invalid argument
>> Jobs: 168 (f=168): [r(168),X(24)] [0.0% done] [2449MB/0KB/0KB /s] [627K/0/0 iops] [eta 02d:11h:58m:50s]
> 
> OK, let me test that, will spin a new one.

This works for me - though I cannot reproduce your O_DIRECT warning
above, what was run to generate that?

-- 
Jens Axboe


--------------080205080406040505000603
Content-Type: text/x-patch;
 name="create-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="create-v2.patch"

diff --git a/HOWTO b/HOWTO
index 693eeb11b12a..854843df5ea9 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1160,6 +1160,11 @@ create_only=bool	If true, fio will only run the setup phase of the job.
 			that will be done. The actual job contents are not
 			executed.
 
+allow_file_create=bool	If true, fio is permitted to create files as part
+		of its workload. This is the default behavior. If this
+		option is false, then fio will error out if the files it
+		needs to use don't already exist.
+
 pre_read=bool	If this is given, files will be pre-read into memory before
 		starting the given IO operation. This will also clear
 		the 'invalidate' flag, since it is pointless to pre-read
diff --git a/cconv.c b/cconv.c
index 4a40ed0d647b..913313b68d47 100644
--- a/cconv.c
+++ b/cconv.c
@@ -69,6 +69,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->profile, top->profile);
 	string_to_cpu(&o->cgroup, top->cgroup);
 
+	o->allow_create = le32_to_cpu(top->allow_create);
 	o->td_ddir = le32_to_cpu(top->td_ddir);
 	o->rw_seq = le32_to_cpu(top->rw_seq);
 	o->kb_base = le32_to_cpu(top->kb_base);
@@ -278,6 +279,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->profile, o->profile);
 	string_to_net(top->cgroup, o->cgroup);
 
+	top->allow_create = cpu_to_le32(o->allow_create);
 	top->td_ddir = cpu_to_le32(o->td_ddir);
 	top->rw_seq = cpu_to_le32(o->rw_seq);
 	top->kb_base = cpu_to_le32(o->kb_base);
diff --git a/filesetup.c b/filesetup.c
index 43146ba7671f..cca877634e95 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -65,7 +65,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-	flags = O_WRONLY | O_CREAT;
+	flags = O_WRONLY;
+	if (td->o.allow_create)
+		flags |= O_CREAT;
 	if (new_layout)
 		flags |= O_TRUNC;
 
@@ -76,7 +78,13 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	dprint(FD_FILE, "open file %s, flags %x\n", f->file_name, flags);
 	f->fd = open(f->file_name, flags, 0644);
 	if (f->fd < 0) {
-		td_verror(td, errno, "open");
+		int err = errno;
+
+		if (err == ENOENT && !td->o.allow_create)
+			log_err("fio: file creation disallowed by "
+					"allow_file_create=0\n");
+		else
+			td_verror(td, err, "open");
 		return 1;
 	}
 
@@ -557,7 +565,7 @@ int generic_open_file(struct thread_data *td, struct fio_file *f)
 	}
 	if (td->o.sync_io)
 		flags |= O_SYNC;
-	if (td->o.create_on_open)
+	if (td->o.create_on_open && td->o.allow_create)
 		flags |= O_CREAT;
 skip_flags:
 	if (f->filetype != FIO_TYPE_FILE)
@@ -568,7 +576,7 @@ open_again:
 		if (!read_only)
 			flags |= O_RDWR;
 
-		if (f->filetype == FIO_TYPE_FILE)
+		if (f->filetype == FIO_TYPE_FILE && td->o.allow_create)
 			flags |= O_CREAT;
 
 		if (is_std)
diff --git a/fio.1 b/fio.1
index d64fbb7ab5e0..ef53bd6302a7 100644
--- a/fio.1
+++ b/fio.1
@@ -1029,6 +1029,11 @@ If true, fio will only run the setup phase of the job. If files need to be
 laid out or updated on disk, only that will be done. The actual job contents
 are not executed.
 .TP
+.BI allow_file_create \fR=\fPbool
+If true, fio is permitted to create files as part of its workload. This is
+the default behavior. If this option is false, then fio will error out if the
+files it needs to use don't already exist.
+.TP
 .BI pre_read \fR=\fPbool
 If this is given, files will be pre-read into memory before starting the given
 IO operation. This will also clear the \fR \fBinvalidate\fR flag, since it is
diff --git a/options.c b/options.c
index 918de8e8e34b..a7dd58adb418 100644
--- a/options.c
+++ b/options.c
@@ -2962,6 +2962,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.def	= "0",
 	},
 	{
+		.name	= "allow_file_create",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(allow_create),
+		.help	= "Permit fio to create files, if they don't exist",
+		.def	= "1",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_FILENAME,
+	},
+	{
 		.name	= "pre_read",
 		.lname	= "Pre-read files",
 		.type	= FIO_OPT_BOOL,
diff --git a/server.h b/server.h
index 1b131b92f08a..5213e6ac9e08 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 36,
+	FIO_SERVER_VER			= 37,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index a45d7b79b7ef..5cf697d2bb9c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -40,6 +40,7 @@ struct thread_options {
 	char *opendir;
 	char *ioengine;
 	char *mmapfile;
+	unsigned int allow_create;
 	enum td_ddir td_ddir;
 	unsigned int rw_seq;
 	unsigned int kb_base;
@@ -271,6 +272,7 @@ struct thread_options_pack {
 	uint8_t opendir[FIO_TOP_STR_MAX];
 	uint8_t ioengine[FIO_TOP_STR_MAX];
 	uint8_t mmapfile[FIO_TOP_STR_MAX];
+	uint32_t allow_create;
 	uint32_t td_ddir;
 	uint32_t rw_seq;
 	uint32_t kb_base;

--------------080205080406040505000603--

