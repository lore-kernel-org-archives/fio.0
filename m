Return-Path: <fio-owner@vger.kernel.org>
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:35891 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235081AbhBXLSo (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 24 Feb 2021 06:18:44 -0500
Received: from pps.filterd (m0209325.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11OAsrWQ029989
        for <fio@vger.kernel.org>; Wed, 24 Feb 2021 10:54:53 GMT
Received: from apc01-sg2-obe.outbound.protection.outlook.com (mail-sg2apc01lp2058.outbound.protection.outlook.com [104.47.125.58])
        by mx08-001d1705.pphosted.com with ESMTP id 36wh2rg6rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Wed, 24 Feb 2021 10:54:52 +0000
From: <Friendy.Su@sony.com>
Subject: RE: [PATCH v1 1/1] engines: add engine for file delete
Date: Wed, 24 Feb 2021 10:54:25 +0000
Message-ID: <TYAPR04MB2399A354EA8C745256EC5C0AFD9F9@TYAPR04MB2399.apcprd04.prod.outlook.com>
References: <HK0PR04MB2388F3AF9F2D1F04CA21E722FD819@HK0PR04MB2388.apcprd04.prod.outlook.com>
In-Reply-To: <HK0PR04MB2388F3AF9F2D1F04CA21E722FD819@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Friendy.Su@sony.com, Kento.A.Kobayashi@sony.com, Wataru.Aoyama@sony.com

More explanation:

The purpose of 'file delete' engine is same as 'file stat' engine which is =
added last year.
In the practice, file operation performance like how many files can be dele=
ted within a specified time slot is also important to evaluate a file syste=
m other than IO throughput.

-----Original Message-----
From: Su, Friendy=20
Sent: Monday, February 22, 2021 6:43 PM
To: fio <fio@vger.kernel.org>
Cc: Su, Friendy <Friendy.Su@sony.com>; Kobayashi, Kento (Sony) <Kento.A.Kob=
ayashi@sony.com>; Aoyama, Wataru (Sony) <Wataru.Aoyama@sony.com>
Subject: [PATCH v1 1/1] engines: add engine for file delete

This engine is to measure performance of deleting files.

In practice, it is an important benchmark for a file system that how quick =
it can release the disk space of deleted files.

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 HOWTO                            |   5 ++
 Makefile                         |   2 +-
 engines/filedelete.c             | 108 +++++++++++++++++++++++++++++++
 examples/filedelete-ioengine.fio |  23 +++++++
 fio.1                            |   5 ++
 5 files changed, 142 insertions(+), 1 deletion(-)  create mode 100644 engi=
nes/filedelete.c  create mode 100644 examples/filedelete-ioengine.fio

diff --git a/HOWTO b/HOWTO
index b6d1b58a..ea728439 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2033,6 +2033,11 @@ I/O engine
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
 			mounted with DAX on a persistent memory device through the PMDK diff --=
git a/Makefile b/Makefile index 612344d1..11ffa089 100644
--- a/Makefile
+++ b/Makefile
@@ -51,7 +51,7 @@ SOURCE :=3D	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(=
SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c engines/filestat.c \
+		engines/ftruncate.c engines/filecreate.c engines/filestat.c=20
+engines/filedelete.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \ diff --git =
a/engines/filedelete.c b/engines/filedelete.c new file mode 100644 index 00=
000000..71977b22
--- /dev/null
+++ b/engines/filedelete.c
@@ -0,0 +1,108 @@
+/*
+ * file delete engine
+ *
+ * IO engine that doesn't do any IO, just delete files and tracks the=20
+latency
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
+static int delete_file(struct thread_data *td, struct fio_file *f) {
+	struct timespec start;
+	int do_lat =3D !td->o.disable_lat;
+	int ret;
+
+	dprint(FD_FILE, "fd delete %s\n", f->file_name);
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
+	.name		=3D "filedelete",
+	.version	=3D FIO_IOOPS_VERSION,
+	.init		=3D init,
+	.cleanup	=3D cleanup,
+	.queue		=3D queue_io,
+	.get_file_size	=3D generic_get_file_size,
+	.open_file	=3D delete_file,
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
diff --git a/examples/filedelete-ioengine.fio b/examples/filedelete-ioengin=
e.fio
new file mode 100644
index 00000000..58002c8a
--- /dev/null
+++ b/examples/filedelete-ioengine.fio
@@ -0,0 +1,23 @@
+# Example filedelete job
+
+# 'filedelete' engine only do 'unlink(filename)', file will not be open().
+# 'invalidate' should be set to 0 since file will not be open(), posix_fad=
vise(fd,....) will fail.
+# 'filesize' must be set, then files will be created at setup stage.
+# 'unlink' must be set to 0, since the file is deleted in measurement.
+
+[global]
+ioengine=3Dfiledelete
+numjobs=3D1
+filesize=3D4k
+invalidate=3D0
+nrfiles=3D200
+unlink=3D0
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
+
+
diff --git a/fio.1 b/fio.1
index aa248a3b..4b1ef80d 100644
--- a/fio.1
+++ b/fio.1
@@ -1819,6 +1819,11 @@ Simply do stat() and do no I/O to the file. You need=
 to set 'filesize'
 and 'nrfiles', so that files will be created.
 This engine is to measure file lookup and meta data access.
 .TP
+.B filestat
+Simply delete files by unlink() and do no I/O to the file. You need to set=
 'filesize'
+and 'nrfiles', so that files will be created.
+This engine is to measure file delete.
+.TP
 .B libpmem
 Read and write using mmap I/O to a file on a filesystem  mounted with DAX =
on a persistent memory device through the PMDK
--
2.17.1


