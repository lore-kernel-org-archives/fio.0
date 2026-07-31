Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067A73F23D1
	for <fio@vger.kernel.org>; Fri, 31 Jul 2026 11:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785496862; cv=none; b=fxUc6+TRuzc7T66rVtofe9OXqrIRg35vNWE8WCCVyowVd8JTSJfzpViYW4Dmy4a6XmTKJhAmJuOsTxtajyIMCF+5nRXo0AZvEC8Dx6wdUmzdswwjRENgobIt6xnIwuHmRYm4qrnW5GD2Ygif92M1UT7PZIu6EyG2cBuieHe7BP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785496862; c=relaxed/simple;
	bh=Yt0ZC+1256t9fXhYiUzydDfuANv8brR3X4ItEedf3U4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Llnx7gBQOG9G0RFMNzgitYf6bfJjcEqSKe3roT/VEwIcSRbmNlBadVwhMGDYG7DPzj6dU6PVTsuiKNoAOC01LbUtVG9iCa17HlI+h5nTlUupoZe3twDb+2ul00ClyfTCfPno5F/WLGZ8Y43EKewC2gnE7cSQxOAIxG0/hMNQjrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=vCYIcoa5; arc=none smtp.client-ip=178.154.239.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="vCYIcoa5"
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:b47:0:640:7767:0])
	by forward101b.mail.yandex.net (postfix) with ESMTPS id 8C273C1CBA;
	Fri, 31 Jul 2026 14:20:49 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp) with ESMTPSA id mKe4FNJfHqM0-hl820hmn;
	Fri, 31 Jul 2026 14:20:49 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1785496849; bh=BuXNxYcO/1RZ8MacAiEP+uAjJ+ftMA4mNi27wwxwtgU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=vCYIcoa5YBy4D/ZOyupIDXahZUDs/gOt+2YH7c6CUwt6XwNhjE2UJImXL9/PkmT9R
	 VjaDfw3yFlOY88t53hA2gSCUFcREcvU5EmU2Hi9ytMfy2OEcQzNSbCDTe4u12q/Z6G
	 qcr+6DdUiuTrV/9edKK9A2qLsMoOtZxpb7vM+2kg=
Authentication-Results: mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] fio: new engine based on copy_file_range() system call
Date: Fri, 31 Jul 2026 14:20:16 +0300
Message-ID: <20260731112016.21014-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simple engine based on copy_file_range(2) Linux-specific system call.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 Makefile                     |   3 +
 configure                    |  21 +++++++
 engines/copy_file_range.c    | 107 +++++++++++++++++++++++++++++++++++
 examples/copy-file-range.fio |  13 +++++
 file.h                       |   2 +
 filesetup.c                  |   7 ++-
 6 files changed, 150 insertions(+), 3 deletions(-)
 create mode 100644 engines/copy_file_range.c
 create mode 100644 examples/copy-file-range.fio

diff --git a/Makefile b/Makefile
index 4f87adba..98d71700 100644
--- a/Makefile
+++ b/Makefile
@@ -124,6 +124,9 @@ endif
 ifdef CONFIG_LINUX_SPLICE
   SOURCE += engines/splice.c
 endif
+ifdef CONFIG_LINUX_COPY_FILE_RANGE
+  SOURCE += engines/copy_file_range.c
+endif
 ifdef CONFIG_SOLARISAIO
   SOURCE += engines/solarisaio.c
 endif
diff --git a/configure b/configure
index cdfefa59..2bdeac88 100755
--- a/configure
+++ b/configure
@@ -1409,6 +1409,24 @@ if compile_prog "" "" "linux splice"; then
 fi
 print_config "Linux splice(2)" "$linux_splice"
 
+##########################################
+# copy_file_range probe
+if test "$linux_copy_file_range" != "yes" ; then
+  linux_copy_file_range="no"
+fi
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <unistd.h>
+int main(int argc, char **argv)
+{
+  return copy_file_range(0, NULL, 0, NULL, 0, 0);
+}
+EOF
+if compile_prog "" "" "linux copy_file_range"; then
+  linux_copy_file_range="yes"
+fi
+print_config "Linux copy_file_range(2)" "$linux_copy_file_range"
+
 ##########################################
 # libnuma probe
 if test "$libnuma" != "yes" ; then
@@ -3228,6 +3246,9 @@ fi
 if test "$linux_splice" = "yes" ; then
   output_sym "CONFIG_LINUX_SPLICE"
 fi
+if test "$linux_copy_file_range" = "yes" ; then
+  output_sym "CONFIG_LINUX_COPY_FILE_RANGE"
+fi
 if test "$libnuma_v2" = "yes" ; then
   output_sym "CONFIG_LIBNUMA"
 fi
diff --git a/engines/copy_file_range.c b/engines/copy_file_range.c
new file mode 100644
index 00000000..2e9c1b05
--- /dev/null
+++ b/engines/copy_file_range.c
@@ -0,0 +1,107 @@
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <sys/user.h>
+
+#include "../fio.h"
+
+#ifndef MAX_RW_COUNT
+#define MAX_RW_COUNT (INT_MAX & PAGE_MASK)
+#endif
+
+static int
+fio_copy_file_range_prep(struct thread_data *td, struct io_u *io_u)
+{
+	return io_u->xfer_buflen > MAX_RW_COUNT ? EINVAL : 0;
+}
+
+static int
+fio_copy_file_range_close(struct thread_data *td, struct fio_file *f)
+{
+	int ret = generic_close_file(td, f);
+
+	if (!ret && td->o.unlink) {
+		struct fio_file *pf = f->engine_data;
+
+		if (fio_file_open(pf))
+			td_io_close_file(td, pf);
+		td_io_unlink_file(td, pf);
+		fio_file_free(pf);
+
+		f->engine_data = NULL;
+	}
+	return ret;
+}
+
+static int
+fio_copy_file_range_open(struct thread_data *td, struct fio_file *f)
+{
+	int ret = generic_open_file(td, f);
+
+	if (!ret) {
+		char fname[PATH_MAX];
+		struct fio_file *pf;
+
+		snprintf(fname, PATH_MAX, "%s.p", f->file_name);
+		pf = alloc_new_file(td);
+		pf->file_name = smalloc_strdup(fname);
+		pf->real_file_size = f->real_file_size;
+		extend_file(td, pf);
+
+		f->engine_data = pf;
+	}
+	return ret;
+}
+
+static enum fio_q_status
+fio_copy_file_range_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file, *pf = f->engine_data;
+	off_t off_in = io_u->offset, off_out = io_u->offset;
+	ssize_t ret;
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_READ)
+		ret = copy_file_range(f->fd, &off_in, pf->fd,
+				      &off_out, io_u->xfer_buflen, 0);
+	else if (io_u->ddir == DDIR_WRITE)
+		ret = copy_file_range(pf->fd, &off_in, f->fd,
+				      &off_out, io_u->xfer_buflen, 0);
+	else {
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
+	}
+
+	if (ret != io_u->xfer_buflen) {
+		if (ret >= 0) {
+			io_u->resid = io_u->xfer_buflen - ret;
+			io_u->offset += ret;
+			io_u->error = 0;
+		} else
+			io_u->error = errno;
+	} else
+		io_u->offset += ret;
+
+	return FIO_Q_COMPLETED;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "copy_file_range",
+	.version	= FIO_IOOPS_VERSION,
+	.prep		= fio_copy_file_range_prep,
+	.queue		= fio_copy_file_range_queue,
+	.open_file	= fio_copy_file_range_open,
+	.close_file	= fio_copy_file_range_close,
+	.flags		= FIO_SYNCIO,
+};
+
+static void fio_init fio_copy_file_range_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_copy_file_range_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/copy-file-range.fio b/examples/copy-file-range.fio
new file mode 100644
index 00000000..2d4684c1
--- /dev/null
+++ b/examples/copy-file-range.fio
@@ -0,0 +1,13 @@
+[global]
+ioengine=copy_file_range
+thread=1
+buffered=0
+rw=randrw
+bs=128k
+size=128m
+directory=/tmp
+unlink=1
+
+[file1]
+numjobs=1
+iodepth=1
diff --git a/file.h b/file.h
index 6fcf409b..a195970c 100644
--- a/file.h
+++ b/file.h
@@ -229,6 +229,8 @@ extern int __must_check generic_prepopulate_file(struct thread_data *, struct fi
 extern int __must_check file_lookup_open(struct fio_file *f, int flags);
 extern bool __must_check pre_read_files(struct thread_data *);
 extern unsigned long long get_rand_file_size(struct thread_data *td);
+extern struct fio_file *alloc_new_file(struct thread_data *);
+extern int extend_file(struct thread_data *, struct fio_file *);
 extern int add_file(struct thread_data *, const char *, int, int);
 extern int add_file_exclusive(struct thread_data *, const char *);
 extern void get_file(struct fio_file *);
diff --git a/filesetup.c b/filesetup.c
index 740a2f47..6438a74e 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -117,7 +117,7 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 /*
  * Leaves f->fd open on success, caller must close
  */
-static int extend_file(struct thread_data *td, struct fio_file *f)
+int extend_file(struct thread_data *td, struct fio_file *f)
 {
 	int new_layout = 0, unlink_file = 0, flags;
 	unsigned long long left;
@@ -153,7 +153,8 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-	flags = O_WRONLY;
+	/* FIXME: read is required by copy_file_range(2) engine */
+	flags = O_RDWR;
 	if (td->o.allow_create)
 		flags |= O_CREAT;
 	if (new_layout)
@@ -1814,7 +1815,7 @@ static void free_already_allocated(void)
 	fio_file_hash_unlock();
 }
 
-static struct fio_file *alloc_new_file(struct thread_data *td)
+struct fio_file *alloc_new_file(struct thread_data *td)
 {
 	struct fio_file *f;
 
-- 
2.55.0

