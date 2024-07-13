Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A7E61FD5
	for <fio@vger.kernel.org>; Sat, 13 Jul 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720872012; cv=none; b=MkIb8O9XNQsFl8S+EgY4u1WaMoN6Tnj+KcJmpU7RvALmPnmDdndTq01+DsykylwXFbdedokrvdWAExBtNaGrAm8HXc41oqFNLOfmpmzfDMEV5ngwK6eL7ehJgVuhYrRLeYCWkS9HkUw4xvL8Tzio3OvwbVGk0bEE0/FG6vYJ3cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720872012; c=relaxed/simple;
	bh=3srAP0w6gdhCwa9t6hUZgFJrtR8hNRnMJnZrTmZtPz8=;
	h=Subject:From:To:Message-Id:Date; b=JyCjBaNK1NDln6Th64sR8+yRWWSj0/ywffwRy0MCMUJuJJi26fzbOxGdd+JKnXC8irCtL3WyDwy/oPTp2G/dlzYpOBsHU1W3oTZ15zPRetZG/Z79kSyjOomcNqkJ/5AkaCM2BQdGlqGxXDGDXTzbZeCRIGTC2ZDn2ZbbwdXSaSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y4GGC9Sm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y4GGC9Sm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=kHr+4AHLAy7paAa/8GcP85GZr1M76bklbUwC+CBYCy4=; b=Y4GGC9SmbZXB5TZcxEpDYzaHYe
	bREVBo3MtmT5lvDrP1vzsTjDIyuzsborI3dBiOMgZSZEnHVesqG/nMjHACWuc87EerpXKYLwakFEz
	x2ukMKSRs2XxhN8O5+YXOmlZiSb0swf6u8jwJ40j6Cf03UDN3wIefjijNMtb8ffAH5No2FM3tcGdb
	1rG/tFvkn2nuREIJiGKaM79xKeTpYYgcDWoXMSkVgSD1+yX4K9JY6JGqzjuLtxVR5K7yYs2NlOJOO
	RQrsRDLI4B7li/RJ+G2xeDuWSX2Gw3jX64izB+wBLLeOTuRFtPKm29ilTSydq4qTrOrpwiWb4WhXL
	GKCYMJyA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sSbQ5-0000000DWN2-0rFV
	for fio@vger.kernel.org;
	Sat, 13 Jul 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 07D2F1BC014C; Sat, 13 Jul 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240713120002.07D2F1BC014C@kernel.dk>
Date: Sat, 13 Jul 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 89fc4019e2a5ecb23be181a6a1dcda1902cdcfcc:

  Merge branch 'io-uring-cmd/nvme/add-flush' of https://github.com/minwooim/fio (2024-07-11 09:59:48 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2cb0841a1452f34a20ffe8fc1821b305f10b3f63:

  os/os-qnx: fix overwrite of 'errno' (2024-07-12 10:52:33 -0600)

----------------------------------------------------------------
Huang weiliang(weller) (1):
      Support QNX OS platform

Jens Axboe (2):
      Merge branch 'master' of https://github.com/huangweiliang/fio_for_qnx
      os/os-qnx: fix overwrite of 'errno'

 configure          |  6 ++++
 engines/e4defrag.c |  1 +
 os/os-qnx.h        | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 os/os.h            |  3 ++
 4 files changed, 109 insertions(+)
 create mode 100755 os/os-qnx.h

---

Diff of recent changes:

diff --git a/configure b/configure
index 3eef022b..f3cb18a0 100755
--- a/configure
+++ b/configure
@@ -366,6 +366,8 @@ elif check_define __sun__ ; then
   CFLAGS="$CFLAGS -D_REENTRANT"
 elif check_define _WIN32 ; then
   targetos='CYGWIN'
+elif check_define __QNX__ ; then
+  targetos='QNX'
 else
   targetos=`uname -s`
 fi
@@ -466,6 +468,9 @@ CYGWIN*)
   pthread_condattr_setclock="no"
   pthread_affinity="no"
   ;;
+QNX)
+  LIBS="-lsocket"
+  ;;
 esac
 
 # Now we know the target platform we can have another guess at the preferred
@@ -1090,6 +1095,7 @@ if test "$have_vasprintf" != "yes" ; then
 fi
 cat > $TMPC << EOF
 #include <stdio.h>
+#include <stdarg.h>
 
 int main(int argc, char **argv)
 {
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 37cc2ada..65ef0da7 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <stdint.h>
 
 #include "../fio.h"
 #include "../optgroup.h"
diff --git a/os/os-qnx.h b/os/os-qnx.h
new file mode 100755
index 00000000..447c9957
--- /dev/null
+++ b/os/os-qnx.h
@@ -0,0 +1,99 @@
+#ifndef FIO_OS_QNX_H
+#define FIO_OS_QNX_H
+
+#define	FIO_OS	os_qnx
+#include <stdint.h>
+#include <stdio.h>
+#include <errno.h>
+#include <sys/param.h>
+#include <sys/statvfs.h>
+#include <sys/ioctl.h>
+#include <sys/utsname.h>
+#include <sys/sysctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/dcmd_cam.h>
+
+/* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
+#undef RB_BLACK
+#undef RB_RED
+#undef RB_ROOT
+
+#include "../file.h"
+
+/* QNX is not supporting SA_RESTART. Use SA_NOCLDSTOP instead of it */
+#ifndef SA_RESTART
+#define SA_RESTART SA_NOCLDSTOP
+#endif
+
+#define FIO_NO_HAVE_SHM_H
+
+typedef uint64_t __u64;
+typedef unsigned int __u32;
+
+#define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_FS_STAT
+#define FIO_HAVE_GETTID
+
+#define OS_MAP_ANON		MAP_ANON
+
+#ifndef PTHREAD_STACK_MIN
+#define PTHREAD_STACK_MIN 4096
+#endif
+
+#define fio_swap16(x)	swap16(x)
+#define fio_swap32(x)	swap32(x)
+#define fio_swap64(x)	swap64(x)
+
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
+static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
+{
+	struct stat statbuf;
+
+	if (fstat(f->fd, &statbuf) == -1) {
+		*bytes = 0;
+		return errno;
+	}
+
+	*bytes = (unsigned long long)(statbuf.st_blocksize * statbuf.st_nblocks);
+	return 0;
+}
+
+static inline int blockdev_invalidate_cache(struct fio_file *f)
+{
+	return ENOTSUP;
+}
+
+static inline unsigned long long os_phys_mem(void)
+{
+	int mib[2] = { CTL_HW, HW_PHYSMEM64 };
+	uint64_t mem;
+	size_t len = sizeof(mem);
+
+	sysctl(mib, 2, &mem, &len, NULL, 0);
+	return mem;
+}
+
+static inline unsigned long long get_fs_free_size(const char *path)
+{
+	unsigned long long ret;
+	struct statvfs s;
+
+	if (statvfs(path, &s) < 0)
+		return -1ULL;
+
+	ret = s.f_frsize;
+	ret *= (unsigned long long) s.f_bfree;
+	return ret;
+}
+
+#ifdef MADV_FREE
+#define FIO_MADV_FREE	MADV_FREE
+#endif
+
+#endif
diff --git a/os/os.h b/os/os.h
index 0f182324..d54e7c0d 100644
--- a/os/os.h
+++ b/os/os.h
@@ -24,6 +24,7 @@ enum {
 	os_windows,
 	os_android,
 	os_dragonfly,
+	os_qnx,
 
 	os_nr,
 };
@@ -39,6 +40,8 @@ typedef enum {
 #include "os-freebsd.h"
 #elif defined(__OpenBSD__)
 #include "os-openbsd.h"
+#elif defined(__QNX__)
+#include "os-qnx.h"
 #elif defined(__NetBSD__)
 #include "os-netbsd.h"
 #elif defined(__sun__)
