Return-Path: <fio-owner@vger.kernel.org>
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:9366 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230030AbhDNEEU (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 14 Apr 2021 00:04:20 -0400
From: <Friendy.Su@sony.com>
Subject: RE: [PATCH v4 1/1] engines: add engine for file delete
Date: Wed, 14 Apr 2021 04:03:47 +0000
Message-ID: <PU1PR04MB2390056120F7AD031B698DF3FD4E9@PU1PR04MB2390.apcprd04.prod.outlook.com>
References: <PU1PR04MB23909EA73FD1006DE2D5D8D5FD4E9@PU1PR04MB2390.apcprd04.prod.outlook.com>
In-Reply-To: <PU1PR04MB23909EA73FD1006DE2D5D8D5FD4E9@PU1PR04MB2390.apcprd04.prod.outlook.com>
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: sitsofe@gmail.com, Kento.A.Kobayashi@sony.com, Wataru.Aoyama@sony.com, Friendy.Su@sony.com

Updated from v3 to v4:

1. in example job file, highlight 'disable_clat' and 'gtod_reduce' can not =
be set for file delete engine since they disable completion latency output.
2. in example job file, remove 'numjobs' option, since there is no requirem=
ent about it for file delete engine.
3. trivial message string fix.

-----Original Message-----
From: Su, Friendy=20
Sent: Wednesday, April 14, 2021 11:57 AM
To: fio <fio@vger.kernel.org>
Cc: 'Sitsofe Wheeler' <sitsofe@gmail.com>; Kobayashi, Kento (SGC) <Kento.A.=
Kobayashi@sony.com>; Aoyama, Wataru (SGC) <Wataru.Aoyama@sony.com>; Su, Fri=
endy <Friendy.Su@sony.com>
Subject: [PATCH v4 1/1] engines: add engine for file delete

This engine is to measure the performance of deleting files.

In practice, it is an important benchmark for a file system that
how quick it can release the disk space of deleted files.

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 HOWTO                            |   5 ++
 Makefile                         |   2 +-
 engines/filedelete.c             | 115 +++++++++++++++++++++++++++++++
 examples/filedelete-ioengine.fio |  18 +++++
 fio.1                            |   5 ++
 5 files changed, 144 insertions(+), 1 deletion(-)
 create mode 100644 engines/filedelete.c
 create mode 100644 examples/filedelete-ioengine.fio

diff --git a/HOWTO b/HOWTO
index 2788670d..e6078c5f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2055,6 +2055,11 @@ I/O engine
 			and 'nrfiles', so that files will be created.
 			This engine is to measure file lookup and meta data access.
=20
+		**filedelete**
+			Simply delete the files by unlink() and do no I/O to them. You need to =
set 'filesize'
+			and 'nrfiles', so that the files will be created.
+			This engine is to measure file delete.
+
 		**libpmem**
 			Read and write using mmap I/O to a file on a filesystem
 			mounted with DAX on a persistent memory device through the PMDK
diff --git a/Makefile b/Makefile
index fce3d0d1..ba027b2e 100644
--- a/Makefile
+++ b/Makefile
@@ -51,7 +51,7 @@ SOURCE :=3D	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(=
SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c engines/filestat.c \
+		engines/ftruncate.c engines/filecreate.c engines/filestat.c engines/file=
delete.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/filedelete.c b/engines/filedelete.c
new file mode 100644
index 00000000..64c58639
--- /dev/null
+++ b/engines/filedelete.c
@@ -0,0 +1,115 @@
+/*
+ * file delete engine
+ *
+ * IO engine that doesn't do any IO, just delete files and track the laten=
cy
+ * of the file deletion.
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include "../fio.h"
+
+struct fc_data {
+	enum fio_ddir stat_ddir;
+};
+
+static int delete_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat =3D !td->o.disable_lat;
+	int ret;
+
+	dprint(FD_FILE, "fd delete %s\n", f->file_name);
+
+	if (f->filetype !=3D FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+	if (do_lat)
+		fio_gettime(&start, NULL);
+
+	ret =3D unlink(f->file_name);
+
+	if (ret =3D=3D -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e =3D errno;
+
+		snprintf(buf, sizeof(buf), "delete(%s)", f->file_name);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		struct fc_data *data =3D td->io_ops_data;
+		uint64_t nsec;
+
+		nsec =3D ntime_since_now(&start);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+	}
+
+	return 0;
+}
+
+
+static enum fio_q_status queue_io(struct thread_data *td, struct io_u fio_=
unused *io_u)
+{
+	return FIO_Q_COMPLETED;
+}
+
+static int init(struct thread_data *td)
+{
+	struct fc_data *data;
+
+	data =3D calloc(1, sizeof(*data));
+
+	if (td_read(td))
+		data->stat_ddir =3D DDIR_READ;
+	else if (td_write(td))
+		data->stat_ddir =3D DDIR_WRITE;
+
+	td->io_ops_data =3D data;
+	return 0;
+}
+
+static int delete_invalidate(struct thread_data *td, struct fio_file *f)
+{
+    /* do nothing because file not opened */
+    return 0;
+}
+
+static void cleanup(struct thread_data *td)
+{
+	struct fc_data *data =3D td->io_ops_data;
+
+	free(data);
+}
+
+static struct ioengine_ops ioengine =3D {
+	.name		=3D "filedelete",
+	.version	=3D FIO_IOOPS_VERSION,
+	.init		=3D init,
+	.invalidate	=3D delete_invalidate,
+	.cleanup	=3D cleanup,
+	.queue		=3D queue_io,
+	.get_file_size	=3D generic_get_file_size,
+	.open_file	=3D delete_file,
+	.flags		=3D  FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static void fio_init fio_filedelete_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_filedelete_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/filedelete-ioengine.fio b/examples/filedelete-ioengin=
e.fio
new file mode 100644
index 00000000..3c0028f9
--- /dev/null
+++ b/examples/filedelete-ioengine.fio
@@ -0,0 +1,18 @@
+# Example filedelete job
+
+# 'filedelete' engine only do 'unlink(filename)', file will not be open().
+# 'filesize' must be set, then files will be created at setup stage.
+# 'unlink' is better set to 0, since the file is deleted in measurement.
+# the options disabled completion latency output such as 'disable_clat' an=
d 'gtod_reduce' must not set.
+[global]
+ioengine=3Dfiledelete
+filesize=3D4k
+nrfiles=3D200
+unlink=3D0
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
diff --git a/fio.1 b/fio.1
index f959e00d..c59a8002 100644
--- a/fio.1
+++ b/fio.1
@@ -1847,6 +1847,11 @@ Simply do stat() and do no I/O to the file. You need=
 to set 'filesize'
 and 'nrfiles', so that files will be created.
 This engine is to measure file lookup and meta data access.
 .TP
+.B filedelete
+Simply delete files by unlink() and do no I/O to the file. You need to set=
 'filesize'
+and 'nrfiles', so that files will be created.
+This engine is to measure file delete.
+.TP
 .B libpmem
 Read and write using mmap I/O to a file on a filesystem
 mounted with DAX on a persistent memory device through the PMDK
--=20
2.17.1


