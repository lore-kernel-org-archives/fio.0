Return-Path: <axboe@kernel.dk>
Message-ID: <542B784F.5090405@kernel.dk>
Date: Tue, 30 Sep 2014 21:43:11 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net> <542B52B3.5060908@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net> <542B5632.8030404@kernel.dk>
In-Reply-To: <542B5632.8030404@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------080006090909030403040706"
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080006090909030403040706
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-09-30 19:17, Jens Axboe wrote:
> On 2014-09-30 19:12, Elliott, Robert (Server Storage) wrote:
>>
>>
>>> -----Original Message-----
>>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> ...
>>> I'd much rather keep fio ignorant of any "special" directories, even if
>>> it means that sometimes you do potentially run into issues like the
>>> above, where you specify a block device that does not exist.
>>
>> How about an option in the script:
>> direct=2   file must exist and be a block device, otherwise skip it
>
> Might be a bit nasty to overload direct= like that. But I'd be open to
> adding an option that says must_be_bdev or something, which can be a
> bool as well.

Totally untested patch attached (it compiles). There's a new option, 
filetype. If not set, if will allow any file type. Can be set to:

any        default, allow any file type
file       regular file
bdev       block device
chardev    character device
pipe       pipe

So for your case, you'd set

filetype=bdev

and you'd avoid the issue. Note that it only works for files specified 
with filename=. Any other way of adding a file (blktrace replay, 
opendir=, or fio added files when no filename= given) will ignore the 
filetype setting.

-- 
Jens Axboe


--------------080006090909030403040706
Content-Type: text/x-patch;
 name="filetype.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="filetype.patch"

diff --git a/cconv.c b/cconv.c
index 4a40ed0d647b..61867625282a 100644
--- a/cconv.c
+++ b/cconv.c
@@ -69,6 +69,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->profile, top->profile);
 	string_to_cpu(&o->cgroup, top->cgroup);
 
+	o->filetype = le32_to_cpu(top->filetype);
 	o->td_ddir = le32_to_cpu(top->td_ddir);
 	o->rw_seq = le32_to_cpu(top->rw_seq);
 	o->kb_base = le32_to_cpu(top->kb_base);
@@ -278,6 +279,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->profile, o->profile);
 	string_to_net(top->cgroup, o->cgroup);
 
+	top->filetype = cpu_to_le32(o->filetype);
 	top->td_ddir = cpu_to_le32(o->td_ddir);
 	top->rw_seq = cpu_to_le32(o->rw_seq);
 	top->kb_base = cpu_to_le32(o->kb_base);
diff --git a/engines/net.c b/engines/net.c
index 8087207e505b..9ed4660d77b7 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1194,7 +1194,7 @@ static int fio_netio_setup(struct thread_data *td)
 	struct netio_data *nd;
 
 	if (!td->files_index) {
-		add_file(td, td->o.filename ?: "net", 0, 0);
+		add_file(td, td->o.filename ?: "net", 0, 0, 0);
 		td->o.nr_files = td->o.nr_files ?: 1;
 		td->o.open_files++;
 	}
diff --git a/engines/rbd.c b/engines/rbd.c
index 6fe87b8d010c..9b28c9f099ad 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -407,7 +407,7 @@ static int fio_rbd_setup(struct thread_data *td)
 	 * The size of the RBD is set instead of a artificial file.
 	 */
 	if (!td->files_index) {
-		add_file(td, td->o.filename ? : "rbd", 0, 0);
+		add_file(td, td->o.filename ? : "rbd", 0, 0, 0);
 		td->o.nr_files = td->o.nr_files ? : 1;
 		td->o.open_files++;
 	}
diff --git a/file.h b/file.h
index add77730fdb4..fd35ef7ef07e 100644
--- a/file.h
+++ b/file.h
@@ -13,12 +13,24 @@
  * The type of object we are working on
  */
 enum fio_filetype {
-	FIO_TYPE_FILE = 1,		/* plain file */
+	FIO_TYPE_ANY = 0,
+	FIO_TYPE_FILE,			/* plain file */
 	FIO_TYPE_BD,			/* block device */
 	FIO_TYPE_CHAR,			/* character device */
 	FIO_TYPE_PIPE,			/* pipe */
+	FIO_TYPE_END,
 };
 
+static inline const char *file_type_name(int type)
+{
+	static const char *name[] = { "any", "file", "bdev", "chardev", "pipe", };
+
+	if (type < FIO_TYPE_END)
+		return name[type];
+
+	return "invalid";
+}
+
 enum fio_file_flags {
 	FIO_FILE_open		= 1 << 0,	/* file is open */
 	FIO_FILE_closing	= 1 << 1,	/* file being closed */
@@ -167,7 +179,7 @@ extern int __must_check generic_close_file(struct thread_data *, struct fio_file
 extern int __must_check generic_get_file_size(struct thread_data *, struct fio_file *);
 extern int __must_check file_lookup_open(struct fio_file *f, int flags);
 extern int __must_check pre_read_files(struct thread_data *);
-extern int add_file(struct thread_data *, const char *, int, int);
+extern int add_file(struct thread_data *, const char *, int, int, int);
 extern int add_file_exclusive(struct thread_data *, const char *);
 extern void get_file(struct fio_file *);
 extern int __must_check put_file(struct thread_data *, struct fio_file *);
diff --git a/filesetup.c b/filesetup.c
index 43146ba7671f..f621813bb138 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1241,7 +1241,8 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 	return f;
 }
 
-int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
+int add_file(struct thread_data *td, const char *fname, int numjob, int inc,
+	     int check_type)
 {
 	int cur_files = td->files_index;
 	char file_name[PATH_MAX];
@@ -1298,6 +1299,18 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 
 	get_file_type(f);
 
+	if (td->o.filetype != FIO_TYPE_ANY && f->filetype != td->o.filetype &&
+	    check_type) {
+		sfree(f->file_name);
+		td->files[cur_files] = NULL;
+		sfree(f);
+		log_err("fio: dropping file '%s' of wrong type\n", file_name);
+		log_err("fio: wanted %s, got %s\n",
+					file_type_name(td->o.filetype),
+					file_type_name(f->filetype));
+		return -1;
+	}
+
 	switch (td->o.file_lock_mode) {
 	case FILE_LOCK_NONE:
 		break;
@@ -1337,7 +1350,7 @@ int add_file_exclusive(struct thread_data *td, const char *fname)
 			return i;
 	}
 
-	return add_file(td, fname, 0, 1);
+	return add_file(td, fname, 0, 1, 0);
 }
 
 void get_file(struct fio_file *f)
@@ -1450,7 +1463,7 @@ static int recurse_dir(struct thread_data *td, const char *dirname)
 		}
 
 		if (S_ISREG(sb.st_mode)) {
-			add_file(td, full_path, 0, 1);
+			add_file(td, full_path, 0, 1, 0);
 			continue;
 		}
 		if (!S_ISDIR(sb.st_mode))
diff --git a/init.c b/init.c
index e20845163279..d96154c1ceaf 100644
--- a/init.c
+++ b/init.c
@@ -1110,10 +1110,16 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		file_alloced = 1;
 
 		if (o->nr_files == 1 && exists_and_not_file(jobname))
-			add_file(td, jobname, job_add_num, 0);
+			add_file(td, jobname, job_add_num, 0, 0);
 		else {
-			for (i = 0; i < o->nr_files; i++)
-				add_file(td, make_filename(fname, sizeof(fname), o, jobname, job_add_num, i), job_add_num, 0);
+			for (i = 0; i < o->nr_files; i++) {
+				char *name;
+
+				name = make_filename(fname, sizeof(fname),
+							o, jobname,
+							job_add_num, i);
+				add_file(td, name, job_add_num, 0, 0);
+			}
 		}
 	}
 
diff --git a/iolog.c b/iolog.c
index 4a7d939af251..9c9ff3788c70 100644
--- a/iolog.c
+++ b/iolog.c
@@ -356,7 +356,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 		} else if (r == 2) {
 			rw = DDIR_INVAL;
 			if (!strcmp(act, "add")) {
-				fileno = add_file(td, fname, 0, 1);
+				fileno = add_file(td, fname, 0, 1, 0);
 				file_action = FIO_LOG_ADD_FILE;
 				continue;
 			} else if (!strcmp(act, "open")) {
diff --git a/options.c b/options.c
index 918de8e8e34b..7ddbf2793a1d 100644
--- a/options.c
+++ b/options.c
@@ -850,6 +850,7 @@ static int str_filename_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
 	char *fname, *str, *p;
+	int bad, good;
 
 	p = str = strdup(input);
 
@@ -859,13 +860,22 @@ static int str_filename_cb(void *data, const char *input)
 	if (!td->files_index)
 		td->o.nr_files = 0;
 
+	good = bad = 0;
 	while ((fname = get_next_name(&str)) != NULL) {
 		if (!strlen(fname))
 			break;
-		add_file(td, fname, 0, 1);
+		if (add_file(td, fname, 0, 1, 1) != -1) {
+			good++;
+			continue;
+		}
+		bad++;
 	}
 
 	free(p);
+
+	if (bad && !good)
+		return 1;
+
 	return 0;
 }
 
@@ -1359,6 +1369,39 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_FILENAME,
 	},
 	{
+		.name	= "filetype",
+		.type	= FIO_OPT_STR,
+		.off1	= td_var_offset(filetype),
+		.help	= "File must match this filetype",
+		.def	= "any",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_FILENAME,
+		.posval = {
+			  { .ival = "any",
+			    .oval = FIO_TYPE_ANY,
+			    .help = "Any filetype",
+			  },
+			  { .ival = "file",
+			    .oval = FIO_TYPE_FILE,
+			    .help = "Regular file",
+			  },
+			  { .ival = "bdev",
+			    .oval = FIO_TYPE_BD,
+			    .help = "Block device",
+			  },
+			  {
+			    .ival = "chardev",
+			    .oval = FIO_TYPE_CHAR,
+			    .help = "Character device",
+			  },
+			  {
+			    .ival = "pipe",
+			    .oval = FIO_TYPE_PIPE,
+			    .help = "Pipe",
+			  },
+		},
+	},
+	{
 		.name	= "lockfile",
 		.lname	= "Lockfile",
 		.type	= FIO_OPT_STR,
diff --git a/thread_options.h b/thread_options.h
index a45d7b79b7ef..d90d3d7de683 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -40,6 +40,7 @@ struct thread_options {
 	char *opendir;
 	char *ioengine;
 	char *mmapfile;
+	unsigned int filetype;
 	enum td_ddir td_ddir;
 	unsigned int rw_seq;
 	unsigned int kb_base;
@@ -271,6 +272,7 @@ struct thread_options_pack {
 	uint8_t opendir[FIO_TOP_STR_MAX];
 	uint8_t ioengine[FIO_TOP_STR_MAX];
 	uint8_t mmapfile[FIO_TOP_STR_MAX];
+	uint32_t filetype;
 	uint32_t td_ddir;
 	uint32_t rw_seq;
 	uint32_t kb_base;

--------------080006090909030403040706--

