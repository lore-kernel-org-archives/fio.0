Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404107AbhAZNAp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Jan 2021 08:00:45 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC86C0611C2
        for <fio@vger.kernel.org>; Tue, 26 Jan 2021 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l4Nwx-0005Mj-CX
        for fio@vger.kernel.org; Tue, 26 Jan 2021 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210126130001.EFE391BC015D@kernel.dk>
Date: Tue, 26 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 42664db2e3ba38faae8ee4c8375f8958206a8c5d:

  Merge branch 'esx-timerfd-bypass' of https://github.com/brianredbeard/fio (2021-01-23 11:04:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e493ceaeccfaebda9d30435cbbe30e97058313a7:

  HOWTO: add sg 'hipri' option (2021-01-25 14:06:48 -0700)

----------------------------------------------------------------
Douglas Gilbert (1):
      fio: add hipri option to sg engine

Eric Sandeen (2):
      fio: move dynamic library handle to io_ops structure
      fio: fix dlopen refcounting of dynamic engines

Jens Axboe (1):
      HOWTO: add sg 'hipri' option

 HOWTO        | 12 ++++++++++++
 engines/sg.c | 22 +++++++++++++++++++++-
 fio.1        | 10 ++++++++++
 fio.h        |  1 -
 init.c       |  9 +++------
 ioengines.c  | 16 ++++++++++------
 ioengines.h  |  3 ++-
 7 files changed, 58 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 372f268f..3ec86aff 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2359,6 +2359,18 @@ with the caveat that when used on the command line, they must come after the
 		transferred to the device. The writefua option is ignored with this
 		selection.
 
+.. option:: hipri : [sg]
+
+	If this option is set, fio will attempt to use polled IO completions.
+	This will have a similar effect as (io_uring)hipri. Only SCSI READ and
+	WRITE commands will have the SGV4_FLAG_HIPRI set (not UNMAP (trim) nor
+	VERIFY). Older versions of the Linux sg driver that do not support
+	hipri will simply ignore this flag and do normal IO. The Linux SCSI
+	Low Level Driver (LLD) that "owns" the device also needs to support
+	hipri (also known as iopoll and mq_poll). The MegaRAID driver is an
+	example of a SCSI LLD. Default: clear (0) which does normal
+	(interrupted based) IO.
+
 .. option:: http_host=str : [http]
 
 	Hostname to connect to. For S3, this could be the bucket hostname.
diff --git a/engines/sg.c b/engines/sg.c
index a1a6de4c..0c2d2c8b 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -60,6 +60,10 @@
 
 #ifdef FIO_HAVE_SGIO
 
+#ifndef SGV4_FLAG_HIPRI
+#define SGV4_FLAG_HIPRI 0x800
+#endif
+
 enum {
 	FIO_SG_WRITE		= 1,
 	FIO_SG_WRITE_VERIFY	= 2,
@@ -68,12 +72,22 @@ enum {
 
 struct sg_options {
 	void *pad;
+	unsigned int hipri;
 	unsigned int readfua;
 	unsigned int writefua;
 	unsigned int write_mode;
 };
 
 static struct fio_option options[] = {
+        {
+                .name   = "hipri",
+                .lname  = "High Priority",
+                .type   = FIO_OPT_STR_SET,
+                .off1   = offsetof(struct sg_options, hipri),
+                .help   = "Use polled IO completions",
+                .category = FIO_OPT_C_ENGINE,
+                .group  = FIO_OPT_G_SG,
+        },
 	{
 		.name	= "readfua",
 		.lname	= "sg engine read fua flag support",
@@ -527,6 +541,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 		else
 			hdr->cmdp[0] = 0x88; // read(16)
 
+		if (o->hipri)
+			hdr->flags |= SGV4_FLAG_HIPRI;
 		if (o->readfua)
 			hdr->cmdp[1] |= 0x08;
 
@@ -542,6 +558,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 				hdr->cmdp[0] = 0x2a; // write(10)
 			else
 				hdr->cmdp[0] = 0x8a; // write(16)
+			if (o->hipri)
+				hdr->flags |= SGV4_FLAG_HIPRI;
 			if (o->writefua)
 				hdr->cmdp[1] |= 0x08;
 			break;
@@ -865,6 +883,7 @@ static int fio_sgio_init(struct thread_data *td)
 {
 	struct sgio_data *sd;
 	struct sgio_trim *st;
+	struct sg_io_hdr *h3p;
 	int i;
 
 	sd = calloc(1, sizeof(*sd));
@@ -880,12 +899,13 @@ static int fio_sgio_init(struct thread_data *td)
 #ifdef FIO_SGIO_DEBUG
 	sd->trim_queue_map = calloc(td->o.iodepth, sizeof(int));
 #endif
-	for (i = 0; i < td->o.iodepth; i++) {
+	for (i = 0, h3p = sd->sgbuf; i < td->o.iodepth; i++, ++h3p) {
 		sd->trim_queues[i] = calloc(1, sizeof(struct sgio_trim));
 		st = sd->trim_queues[i];
 		st->unmap_param = calloc(td->o.iodepth + 1, sizeof(char[16]));
 		st->unmap_range_count = 0;
 		st->trim_io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
+		h3p->interface_id = 'S';
 	}
 
 	td->io_ops_data = sd;
diff --git a/fio.1 b/fio.1
index d477b508..9636a85f 100644
--- a/fio.1
+++ b/fio.1
@@ -2114,6 +2114,16 @@ client and the server or in certain loopback configurations.
 Specify stat system call type to measure lookup/getattr performance.
 Default is \fBstat\fR for \fBstat\fR\|(2).
 .TP
+.BI (sg)hipri
+If this option is set, fio will attempt to use polled IO completions. This
+will have a similar effect as (io_uring)hipri. Only SCSI READ and WRITE
+commands will have the SGV4_FLAG_HIPRI set (not UNMAP (trim) nor VERIFY).
+Older versions of the Linux sg driver that do not support hipri will simply
+ignore this flag and do normal IO. The Linux SCSI Low Level Driver (LLD)
+that "owns" the device also needs to support hipri (also known as iopoll
+and mq_poll). The MegaRAID driver is an example of a SCSI LLD.
+Default: clear (0) which does normal (interrupted based) IO.
+.TP
 .BI (sg)readfua \fR=\fPbool
 With readfua option set to 1, read operations include the force
 unit access (fua) flag. Default: 0.
diff --git a/fio.h b/fio.h
index ee582a72..062abfa7 100644
--- a/fio.h
+++ b/fio.h
@@ -281,7 +281,6 @@ struct thread_data {
 	 * IO engine private data and dlhandle.
 	 */
 	void *io_ops_data;
-	void *io_ops_dlhandle;
 
 	/*
 	 * Queue depth of io_u's that fio MIGHT do
diff --git a/init.c b/init.c
index 1d14df16..d6dbaf7c 100644
--- a/init.c
+++ b/init.c
@@ -1104,18 +1104,15 @@ int ioengine_load(struct thread_data *td)
 		 * for this name and see if they match. If they do, then
 		 * the engine is unchanged.
 		 */
-		dlhandle = td->io_ops_dlhandle;
+		dlhandle = td->io_ops->dlhandle;
 		ops = load_ioengine(td);
 		if (!ops)
 			goto fail;
 
-		if (ops == td->io_ops && dlhandle == td->io_ops_dlhandle) {
-			if (dlhandle)
-				dlclose(dlhandle);
+		if (ops == td->io_ops && dlhandle == td->io_ops->dlhandle)
 			return 0;
-		}
 
-		if (dlhandle && dlhandle != td->io_ops_dlhandle)
+		if (dlhandle && dlhandle != td->io_ops->dlhandle)
 			dlclose(dlhandle);
 
 		/* Unload the old engine. */
diff --git a/ioengines.c b/ioengines.c
index 5ac512ae..f88b0537 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -95,6 +95,7 @@ static void *dlopen_external(struct thread_data *td, const char *engine)
 
 	sprintf(engine_path, "%s/fio-%s.so", FIO_EXT_ENG_DIR, engine);
 
+	dprint(FD_IO, "dlopen external %s\n", engine_path);
 	dlhandle = dlopen(engine_path, RTLD_LAZY);
 	if (!dlhandle)
 		log_info("Engine %s not found; Either name is invalid, was not built, or fio-engine-%s package is missing.\n",
@@ -116,7 +117,7 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	    !strncmp(engine_lib, "aio", 3))
 		engine_lib = "libaio";
 
-	dprint(FD_IO, "dload engine %s\n", engine_lib);
+	dprint(FD_IO, "dlopen engine %s\n", engine_lib);
 
 	dlerror();
 	dlhandle = dlopen(engine_lib, RTLD_LAZY);
@@ -155,7 +156,7 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 		return NULL;
 	}
 
-	td->io_ops_dlhandle = dlhandle;
+	ops->dlhandle = dlhandle;
 	return ops;
 }
 
@@ -194,7 +195,9 @@ struct ioengine_ops *load_ioengine(struct thread_data *td)
 	 * so as not to break job files not using the prefix.
 	 */
 	ops = __load_ioengine(td->o.ioengine);
-	if (!ops)
+
+	/* We do re-dlopen existing handles, for reference counting */
+	if (!ops || ops->dlhandle)
 		ops = dlopen_ioengine(td, name);
 
 	/*
@@ -228,9 +231,10 @@ void free_ioengine(struct thread_data *td)
 		td->eo = NULL;
 	}
 
-	if (td->io_ops_dlhandle) {
-		dlclose(td->io_ops_dlhandle);
-		td->io_ops_dlhandle = NULL;
+	if (td->io_ops->dlhandle) {
+		dprint(FD_IO, "dlclose ioengine %s\n", td->io_ops->name);
+		dlclose(td->io_ops->dlhandle);
+		td->io_ops->dlhandle = NULL;
 	}
 
 	td->io_ops = NULL;
diff --git a/ioengines.h b/ioengines.h
index a928b211..839b318d 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -8,7 +8,7 @@
 #include "io_u.h"
 #include "zbd_types.h"
 
-#define FIO_IOOPS_VERSION	27
+#define FIO_IOOPS_VERSION	28
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -30,6 +30,7 @@ struct ioengine_ops {
 	const char *name;
 	int version;
 	int flags;
+	void *dlhandle;
 	int (*setup)(struct thread_data *);
 	int (*init)(struct thread_data *);
 	int (*post_init)(struct thread_data *);

