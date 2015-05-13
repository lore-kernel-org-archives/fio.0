Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbEMMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 May 2015 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YsVKV-00037S-Ci
	for fio@vger.kernel.org; Wed, 13 May 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150513120002.2D3B22C1079@kernel.dk>
Date: Wed, 13 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3a5db9201bf7b1717f63cb8f7dbd025903117f70:

  Add 'per_job_logs' option (2015-05-11 13:39:36 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2378826d96532b390bd4cb08d3946b497a9b0e51:

  Add 'allow_file_create' option (2015-05-12 11:31:32 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      Add 'allow_file_create' option

 HOWTO            |  5 +++++
 cconv.c          |  2 ++
 filesetup.c      | 16 ++++++++++++----
 fio.1            |  5 +++++
 options.c        |  9 +++++++++
 server.h         |  2 +-
 thread_options.h |  4 ++++
 7 files changed, 38 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 406cfca..7447512 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1199,6 +1199,11 @@ create_only=bool	If true, fio will only run the setup phase of the job.
 			that will be done. The actual job contents are not
 			executed.
 
+allow_file_create=bool	If true, fio is permitted to create files as part
+		of its workload. This is the default behavior. If this
+		option is false, then fio will error out if the files it
+		needs to use don't already exist. Default: true.
+
 pre_read=bool	If this is given, files will be pre-read into memory before
 		starting the given IO operation. This will also clear
 		the 'invalidate' flag, since it is pointless to pre-read
diff --git a/cconv.c b/cconv.c
index bc9edb2..b0becb8 100644
--- a/cconv.c
+++ b/cconv.c
@@ -72,6 +72,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->profile, top->profile);
 	string_to_cpu(&o->cgroup, top->cgroup);
 
+	o->allow_create = le32_to_cpu(top->allow_create);
 	o->td_ddir = le32_to_cpu(top->td_ddir);
 	o->rw_seq = le32_to_cpu(top->rw_seq);
 	o->kb_base = le32_to_cpu(top->kb_base);
@@ -288,6 +289,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->profile, o->profile);
 	string_to_net(top->cgroup, o->cgroup);
 
+	top->allow_create = cpu_to_le32(o->allow_create);
 	top->td_ddir = cpu_to_le32(o->td_ddir);
 	top->rw_seq = cpu_to_le32(o->rw_seq);
 	top->kb_base = cpu_to_le32(o->kb_base);
diff --git a/filesetup.c b/filesetup.c
index aee7ece..cf8ae94 100644
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
 
@@ -539,7 +547,7 @@ int generic_open_file(struct thread_data *td, struct fio_file *f)
 	}
 	if (td->o.sync_io)
 		flags |= O_SYNC;
-	if (td->o.create_on_open)
+	if (td->o.create_on_open && td->o.allow_create)
 		flags |= O_CREAT;
 skip_flags:
 	if (f->filetype != FIO_TYPE_FILE)
@@ -550,7 +558,7 @@ open_again:
 		if (!read_only)
 			flags |= O_RDWR;
 
-		if (f->filetype == FIO_TYPE_FILE)
+		if (f->filetype == FIO_TYPE_FILE && td->o.allow_create)
 			flags |= O_CREAT;
 
 		if (is_std)
diff --git a/fio.1 b/fio.1
index 6c4e5c8..d5e5536 100644
--- a/fio.1
+++ b/fio.1
@@ -1075,6 +1075,11 @@ If true, fio will only run the setup phase of the job. If files need to be
 laid out or updated on disk, only that will be done. The actual job contents
 are not executed.
 .TP
+.BI allow_file_create \fR=\fPbool
+If true, fio is permitted to create files as part of its workload. This is
+the default behavior. If this option is false, then fio will error out if the
+files it needs to use don't already exist. Default: true.
+.TP
 .BI pre_read \fR=\fPbool
 If this is given, files will be pre-read into memory before starting the given
 IO operation. This will also clear the \fR \fBinvalidate\fR flag, since it is
diff --git a/options.c b/options.c
index 5c6ec23..ce1d11e 100644
--- a/options.c
+++ b/options.c
@@ -3040,6 +3040,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
index b0cea15..b94c221 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 44,
+	FIO_SERVER_VER			= 45,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index f967a8a..aed39c8 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -270,6 +270,8 @@ struct thread_options {
 	unsigned int replay_scale;
 
 	unsigned int per_job_logs;
+
+	unsigned int allow_create;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -505,6 +507,8 @@ struct thread_options_pack {
 	uint32_t replay_scale;
 
 	uint32_t per_job_logs;
+
+	uint32_t allow_create;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
