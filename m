Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr1320114.outbound.protection.outlook.com ([40.107.132.114]:51376
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbfLQK2z (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Dec 2019 05:28:55 -0500
From: "Su, Friendy" <Friendy.Su@sony.com>
Subject: RE: [PATCH] engines: add engine for file stat
Date: Tue, 17 Dec 2019 10:28:48 +0000
Message-ID: <SG2PR04MB24922EC985717BABB283905EFD500@SG2PR04MB2492.apcprd04.prod.outlook.com>
References: <925A83423110DA4D836092D40AC7A7E8085CB462@APYOKXMS108.ap.sony.com>
In-Reply-To: <925A83423110DA4D836092D40AC7A7E8085CB462@APYOKXMS108.ap.sony.com>
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'fio@vger.kernel.org'" <fio@vger.kernel.org>
Cc: "Kobayashi, Kento (Sony)" <Kento.A.Kobayashi@sony.com>

In real world, how fast to find the specific file is exact important for a =
file system.
So we implement this new engine. Bonnie++ also has such measurement item.
Is there anyone also interested in this?

-----Original Message-----
From: Su, Friendy=20
Sent: Wednesday, December 4, 2019 6:08 PM
To: fio@vger.kernel.org
Cc: Kobayashi, Kento (Sony) <Kento.A.Kobayashi@sony.com>; Su, Friendy <Frie=
ndy.Su@sony.com>
Subject: [PATCH] engines: add engine for file stat

From 1ee08ca5ed9d3c852c9b536dae719b4a49e7524e Mon Sep 17 00:00:00 2001
From: friendy-su <friendy.su@sony.com>
Date: Mon, 2 Dec 2019 18:25:05 +0800
Subject: [PATCH] engines: add engine for file stat

This engine is to measure performance of accessing file's meta data.
This is for the actual access pattern which does not do real IO, but just l=
ook up the file and get file's attribute.

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 Makefile                       |   2 +-
 engines/filestat.c             | 109 +++++++++++++++++++++++++++++++++
 examples/filestat-ioengine.fio |  20 ++++++
 3 files changed, 130 insertions(+), 1 deletion(-)  create mode 100644 engi=
nes/filestat.c  create mode 100644 examples/filestat-ioengine.fio

diff --git a/Makefile b/Makefile
index 7aab6abd..ab85ceac 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,7 @@ SOURCE :=3D	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(=
SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c \
+		engines/ftruncate.c engines/filecreate.c engines/filestat.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \ diff --git =
a/engines/filestat.c b/engines/filestat.c new file mode 100644 index 000000=
00..9c6636a8
--- /dev/null
+++ b/engines/filestat.c
@@ -0,0 +1,109 @@
+/*
+ * filestat engine
+ *
+ * IO engine that doesn't do any IO, just stat files and tracks the=20
+latency
+ * of the file stat.
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include "../fio.h"
+
+struct fc_data {
+	enum fio_ddir stat_ddir;
+};
+
+static int stat_file(struct thread_data *td, struct fio_file *f) {
+	struct timespec start;
+	int do_lat =3D !td->o.disable_lat;
+	struct stat statbuf;
+	int ret;
+
+	dprint(FD_FILE, "fd stat %s\n", f->file_name);
+
+	if (f->filetype !=3D FIO_TYPE_FILE) {
+		log_err("fio: only files are supported fallocate \n");
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
+	ret =3D stat(f->file_name, &statbuf);
+
+	if (ret =3D=3D -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e =3D errno;
+
+		snprintf(buf, sizeof(buf), "stat(%s)", f->file_name);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		struct fc_data *data =3D td->io_ops_data;
+		uint64_t nsec;
+
+		nsec =3D ntime_since_now(&start);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0);
+	}
+
+	return 0;
+}
+
+static enum fio_q_status queue_io(struct thread_data *td, struct io_u=20
+fio_unused *io_u) {
+	return FIO_Q_COMPLETED;
+}
+
+static int init(struct thread_data *td) {
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
+static void cleanup(struct thread_data *td) {
+	struct fc_data *data =3D td->io_ops_data;
+
+	free(data);
+}
+
+static struct ioengine_ops ioengine =3D {
+	.name		=3D "filestat",
+	.version	=3D FIO_IOOPS_VERSION,
+	.init		=3D init,
+	.cleanup	=3D cleanup,
+	.queue		=3D queue_io,
+	.get_file_size	=3D generic_get_file_size,
+	.open_file	=3D stat_file,
+	.flags		=3D  FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static void fio_init fio_filecreate_register(void) {
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_filecreate_unregister(void) {
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/filestat-ioengine.fio b/examples/filestat-ioengine.fi=
o new file mode 100644 index 00000000..9a771160
--- /dev/null
+++ b/examples/filestat-ioengine.fio
@@ -0,0 +1,20 @@
+# Example filestat job
+
+# 'filestat' engine only do 'stat(filename)', file will not be open().
+# 'invalidate' should be set to 0 since file will not be open(), posix_fad=
vise(fd,....) will fail.
+# 'filesize' must be set, then files will be created at setup stage.
+
+[global]
+ioengine=3Dfilestat
+numjobs=3D1
+filesize=3D4k
+invalidate=3D0
+nrfiles=3D200
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
+
--
2.17.1


