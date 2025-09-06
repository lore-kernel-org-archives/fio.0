Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA272727FC
	for <fio@vger.kernel.org>; Sat,  6 Sep 2025 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757160018; cv=none; b=s+bFsxtW/3tdys8wbJ+Lty9NphJg/RfhV4aapT4jrPqK42aEDUj5Ey0kFk897ob9WloIY5YGSH24cUiy9WLchFkCEdMueGtrmOdO0gfeJoOO1wU8nsUslNw3BboLkHnw58+xKmESC0/wqWi38+i+/7KjKXZH45jKMW+Hao2rAsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757160018; c=relaxed/simple;
	bh=HuCfby33JL3r0cJZbx/40cVTnnRxK1g/fl/Up4ZzDAQ=;
	h=Subject:From:To:Message-Id:Date; b=bgxOrOxNadvvkRPNehEtZUxP0GirCwekXy2l8TE0iPrblLG0Ijld7wlhV6Edf/Ne5yJytO4rQIsGF2yer1mJ1Gj0ckLewkqrfct44ST8VPgWqu66/Lkj7jxE0zsEoiuSNpWnLeZgZD1K1JSIx0vfrQlgX12ocOnPHmDzObzouM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QLdHTYil; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QLdHTYil"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=srb4VAJs9i2+zkFoq2sQGE5ke+I43GQ+rpuO3ecWwhk=; b=QLdHTYilcI8KuWFyPRBWoiHBrq
	MJu7tkQ+Dn/44GFskq6Ddi4hhAkjCRUr9Xb9BO6qWnATyhJ0zSEyxYqku2Ct7Tvsmjn0suL4sfIhF
	2huQo9FLxHElWqjGD5OcYRJ/RVf/fbTURSZ3s6i1M4Xwjn/lKEiRgaIMpIlEWL5Cdir+ftDxth1+7
	ofV3OmTc2jv2gDBrYeoZ0VcNpQpoxTZzS7qEHgT71EO5mYWdq0mgXL/EV8DTcxmO6Vn1JHaLf1qav
	GQfkRwOlirCRJWfy82n85MOXg+3mGJU5PWRrDRnz5QP0EG+4r5LFp4ow8atC4b+SqlrQBRP+jPTkF
	59nH7lKw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uuraO-0000000CznB-2iBc
	for fio@vger.kernel.org;
	Sat, 06 Sep 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E27F61BC014E; Sat,  6 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250906120001.E27F61BC014E@kernel.dk>
Date: Sat,  6 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 83a809bea583b06f9893003fd76eab7c36c212b1:

  Merge branch 'fix_verify-state' of https://github.com/sitsofe/fio (2025-09-04 17:27:53 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fc8f9c7f98156d42fc73fbd6df3c4aa9683df621:

  Merge branch 'improve_flushing_darwin' of https://github.com/Developer-Ecosystem-Engineering/fio (2025-09-05 18:05:55 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fio 3.41
      Merge branch 'improve_flushing_darwin' of https://github.com/Developer-Ecosystem-Engineering/fio

Sitsofe Wheeler (2):
      mac: implement (file) cache invalidation
      mac: add readahead control to the posix_fadvise() shim

 FIO-VERSION-GEN |  2 +-
 Makefile        |  1 +
 os/mac/posix.c  | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 os/mac/posix.h  | 11 +++++++
 os/os-mac.h     |  4 +++
 5 files changed, 116 insertions(+), 1 deletion(-)
 create mode 100644 os/mac/posix.c
 create mode 100644 os/mac/posix.h

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index f9db3568..f92f5a46 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.40
+DEF_VER=fio-3.41
 
 LF='
 '
diff --git a/Makefile b/Makefile
index ba7ad6dc..2fef67d3 100644
--- a/Makefile
+++ b/Makefile
@@ -270,6 +270,7 @@ ifeq ($(CONFIG_TARGET_OS), HP-UX)
 endif
 ifeq ($(CONFIG_TARGET_OS), Darwin)
   LIBS	 += -lpthread -ldl
+  SOURCE += os/mac/posix.c
 endif
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   SOURCE += os/windows/cpu-affinity.c os/windows/posix.c os/windows/dlls.c
diff --git a/os/mac/posix.c b/os/mac/posix.c
new file mode 100644
index 00000000..421b2260
--- /dev/null
+++ b/os/mac/posix.c
@@ -0,0 +1,99 @@
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/param.h>
+
+#include "../../log.h"
+
+#include "posix.h"
+
+#define MMAP_CHUNK_SIZE		(16LL * 1024 * 1024 * 1024)
+
+/*
+ * NB: performance of discard_pages() will be slower under Rosetta.
+ */
+static int discard_pages(int fd, off_t offset, off_t len)
+{
+	/* Align offset and len to page size */
+	long pagesize = sysconf(_SC_PAGESIZE);
+	long offset_pad = offset % pagesize;
+	offset -= offset_pad;
+	len += offset_pad;
+	len = (len + pagesize - 1) & -pagesize;
+
+	while (len > 0) {
+		int saved_errno;
+		size_t mmap_len = MIN(MMAP_CHUNK_SIZE, len);
+		void *addr = mmap(0, mmap_len, PROT_NONE, MAP_SHARED, fd,
+				  offset);
+
+		if (addr == MAP_FAILED) {
+			saved_errno = errno;
+			log_err("discard_pages: failed to mmap (%s), "
+				"offset = %llu, len = %zu\n",
+				strerror(errno), offset, mmap_len);
+			return saved_errno;
+		}
+
+		if (msync(addr, mmap_len, MS_INVALIDATE)) {
+			saved_errno = errno;
+			log_err("discard_pages: msync failed to free cache "
+				"pages\n");
+
+			if (munmap(addr, mmap_len) < 0)
+				log_err("discard_pages: munmap failed (%s)\n",
+					strerror(errno));
+			return saved_errno;
+		}
+
+		if (munmap(addr, mmap_len) < 0) {
+			saved_errno = errno;
+			log_err("discard_pages: munmap failed (%s), "
+				"len = %zu)\n", strerror(errno), mmap_len);
+			return saved_errno;
+		}
+
+		len -= mmap_len;
+		offset += mmap_len;
+	}
+
+	return 0;
+}
+
+static inline int set_readhead(int fd, bool enabled) {
+	int ret;
+
+	ret = fcntl(fd, F_RDAHEAD, enabled ? 1 : 0);
+	if (ret == -1) {
+		ret = errno;
+	}
+
+	return ret;
+}
+
+int posix_fadvise(int fd, off_t offset, off_t len, int advice)
+{
+	int ret;
+
+	switch(advice) {
+	case POSIX_FADV_NORMAL:
+		ret = 0;
+		break;
+	case POSIX_FADV_RANDOM:
+		ret = set_readhead(fd, false);
+		break;
+	case POSIX_FADV_SEQUENTIAL:
+		ret = set_readhead(fd, true);
+		break;
+	case POSIX_FADV_DONTNEED:
+		ret = discard_pages(fd, offset, len);
+		break;
+	default:
+		ret = EINVAL;
+	}
+
+	return ret;
+}
diff --git a/os/mac/posix.h b/os/mac/posix.h
new file mode 100644
index 00000000..6ef7854a
--- /dev/null
+++ b/os/mac/posix.h
@@ -0,0 +1,11 @@
+#ifndef FIO_MAC_POSIX_H
+#define FIO_MAC_POSIX_H
+
+#define POSIX_FADV_NORMAL       (0)
+#define POSIX_FADV_RANDOM       (1)
+#define POSIX_FADV_SEQUENTIAL   (2)
+#define POSIX_FADV_DONTNEED     (4)
+
+extern int posix_fadvise(int fd, off_t offset, off_t len, int advice);
+
+#endif
diff --git a/os/os-mac.h b/os/os-mac.h
index c9103c45..3ade499f 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -17,6 +17,8 @@
 #include "../arch/arch.h"
 #include "../file.h"
 
+#include "mac/posix.h"
+
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CHARDEV_SIZE
@@ -117,3 +119,5 @@ static inline bool os_cpu_has(cpu_features feature)
 }
 
 #endif
+
+#define CONFIG_POSIX_FADVISE
