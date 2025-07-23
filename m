Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19E146BF
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753272014; cv=none; b=dapOfYj4Bg/qoF13kShje+GvOAnDYThL2iRpSDEDBui+5NLX91B50tdqzHOhww36KqnwsfZKocdZWcmyUDd5qrp40IXgSjmN2cCk/Am+sLhxBieyTHhfb/8Z66ebBt5sfVuRj8zzRyjCoqvGhphDeNGQaX6D2F2ermrCyGFE/kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753272014; c=relaxed/simple;
	bh=7IlYb5cKdR/e0kha1rrJEwIxl5qkW8X7auddgSKFEC8=;
	h=Subject:From:To:Message-Id:Date; b=DjLyeOcLoi+yRNM+Wsh39jL4OfpGUZX+Eh/xespJkuWEo6a0cx1wI0x3BCe5c52cRZkbkq22pFVs8nc9UvSO8aZeKBWQJFkSdwiV94NXTZqZnaY3Trjk1+5SqdH1QvQq+MDz97NyOVsQwzwfb2YfAyOT+9cfE7XjDBvMEatJ/1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QiEQsNsh; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QiEQsNsh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=8Ofis37Xa8Ccaa7O1RLIAlXM4kYPgHCTzQMSn9c3tc4=; b=QiEQsNshAWGBbySk8plfNne8Qz
	5FrJYwve/qEnlGqVhEIpzgbduAVfFnUunVq8u7nTqgrXE8J0nK1lBiF4Rp7KIfnGrrfgOYX9Y/P+S
	pzU72GhfD66SkymR0smZEgo5/pGIVNQc5UFnF40jGVk/IUJiRgVMxCUEw5huviUP38WkVoOQKLDxm
	ODMSApMHhvpJ2hsZMErCoCtcVpek0+/9cZNRgnt707OWTMekmr3nbIYNXcUhbGJ1aar3G/7h4N6rO
	cJ3GRBoClYrYVssRMfyMZTO/9L5VuR/eCnTT37ia3J2yBEk9d7CRtpBfjV1faOkMbtz3yV6eMU32R
	tStqFB/w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueY8j-0000000BSm6-08zf
	for fio@vger.kernel.org;
	Wed, 23 Jul 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 2B3451BC015E; Wed, 23 Jul 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250723120002.2B3451BC015E@kernel.dk>
Date: Wed, 23 Jul 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 60c19edf22e4a81fe0320370c2386c5b42127dc0:

  Merge branch 'fix/io_uring-cq-reap' of https://github.com/calebsander/fio (2025-07-18 12:38:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 258e96aa863a48c86439a1dac54da7703252ee70:

  Merge branch 'filetype-option' of https://github.com/struschev/fio (2025-07-22 09:47:31 -0400)

----------------------------------------------------------------
Sergey Truschev (1):
      fio: add filetype option

Vincent Fu (1):
      Merge branch 'filetype-option' of https://github.com/struschev/fio

 HOWTO.rst        | 16 ++++++++++++++++
 cconv.c          |  2 ++
 filesetup.c      |  5 ++++-
 fio.1            | 22 ++++++++++++++++++++++
 options.c        | 16 ++++++++++++++++
 server.h         |  2 +-
 thread_options.h |  3 ++-
 7 files changed, 63 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index e5ddc89d..55ebc388 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -854,6 +854,22 @@ Target file/device
 	generated filenames (with a directory specified) with the source of the
 	client connecting. To disable this behavior, set this option to 0.
 
+.. option:: filetype=str
+
+	Assume that all files defined in a job are of this type. By default fio
+	will do :manpage:`stat(2)` for each file to know its file type. For huge
+	filesets it might be a bottleneck, so the option can be used to skip the
+	huge number of syscalls. The file types are:
+
+		**none**
+			Unset. The default.
+		**file**
+			Regular file.
+		**block**
+			Block device file.
+		**char**
+			Char device file.
+
 .. option:: opendir=str
 
         Recursively open any files below directory `str`. This accepts only a
diff --git a/cconv.c b/cconv.c
index d2faf83e..4e72ae16 100644
--- a/cconv.c
+++ b/cconv.c
@@ -172,6 +172,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->create_fsync = le32_to_cpu(top->create_fsync);
 	o->create_on_open = le32_to_cpu(top->create_on_open);
 	o->create_only = le32_to_cpu(top->create_only);
+	o->filetype = le32_to_cpu(top->filetype);
 	o->end_fsync = le32_to_cpu(top->end_fsync);
 	o->pre_read = le32_to_cpu(top->pre_read);
 	o->sync_io = le32_to_cpu(top->sync_io);
@@ -436,6 +437,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->create_fsync = cpu_to_le32(o->create_fsync);
 	top->create_on_open = cpu_to_le32(o->create_on_open);
 	top->create_only = cpu_to_le32(o->create_only);
+	top->filetype = cpu_to_le32(o->filetype);
 	top->end_fsync = cpu_to_le32(o->end_fsync);
 	top->pre_read = cpu_to_le32(o->pre_read);
 	top->sync_io = cpu_to_le32(o->sync_io);
diff --git a/filesetup.c b/filesetup.c
index 50406c69..a94d3b38 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1833,7 +1833,10 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	/* can't handle smalloc failure from here */
 	assert(f->file_name);
 
-	get_file_type(f);
+	if (td->o.filetype)
+		f->filetype = td->o.filetype;
+	else
+		get_file_type(f);
 
 	switch (td->o.file_lock_mode) {
 	case FILE_LOCK_NONE:
diff --git a/fio.1 b/fio.1
index cba1273b..5bcb1d46 100644
--- a/fio.1
+++ b/fio.1
@@ -635,6 +635,28 @@ To avoid collisions between networked clients, fio defaults to prefixing any
 generated filenames (with a directory specified) with the source of the
 client connecting. To disable this behavior, set this option to 0.
 .TP
+.BI filetype \fR=\fPstr
+Assume that all files defined in a job are of this type. By default fio will do
+\fBstat\fR\|(2) for each file to know its file type. For huge filesets it might
+be a bottleneck, so the option can be used to skip the huge number of syscalls.
+The file types are:
+.RS
+.RS
+.TP
+.B none
+Unset. The default.
+.TP
+.B file
+Regular file.
+.TP
+.B block
+Block device file.
+.TP
+.B char
+Char device file.
+.RE
+.RE
+.TP
 .BI opendir \fR=\fPstr
 Recursively open any files below directory \fIstr\fR. This accepts only a
 single directory and unlike related options, colons appearing in the path must
diff --git a/options.c b/options.c
index cfece3fe..6295a616 100644
--- a/options.c
+++ b/options.c
@@ -1954,6 +1954,22 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_FILENAME,
 	},
+	{
+		.name   = "filetype",
+		.lname  = "file_type",
+		.type   = FIO_OPT_STR,
+		.off1   = offsetof(struct thread_options, filetype),
+		.help   = "Assume all files defined in a job are of this type",
+		.def    = "none",
+		.group  = FIO_OPT_G_IO_BASIC,
+		.category = FIO_OPT_C_FILE,
+		.posval = {
+			  { .ival = "none",  .oval = 0 },
+			  { .ival = "file",  .oval = FIO_TYPE_FILE },
+			  { .ival = "block", .oval = FIO_TYPE_BLOCK },
+			  { .ival = "char",  .oval = FIO_TYPE_CHAR },
+		},
+	},
 	{
 		.name	= "directory",
 		.lname	= "Directory",
diff --git a/server.h b/server.h
index 713fd8e4..f0b15a22 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 111,
+	FIO_SERVER_VER			= 112,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 6c9dd80a..1b26ab58 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -127,6 +127,7 @@ struct thread_options {
 
 	unsigned int nr_files;
 	unsigned int open_files;
+	unsigned int filetype;
 	enum file_lock_mode file_lock_mode;
 
 	unsigned int odirect;
@@ -461,6 +462,7 @@ struct thread_options_pack {
 
 	uint32_t nr_files;
 	uint32_t open_files;
+	uint32_t filetype;
 	uint32_t file_lock_mode;
 
 	uint32_t odirect;
@@ -519,7 +521,6 @@ struct thread_options_pack {
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
-	uint32_t pad2;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
