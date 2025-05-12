Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902B01EB1A1
	for <fio@vger.kernel.org>; Mon, 12 May 2025 01:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013431; cv=none; b=QxsI2hBww4fa3WA+Irvi2TdXBzIxa9mxwpqftEKjgh5xQzSeQ4Gsed6YrtosRxUOPGBZwmPK2dNe1XX2e82jsLk/zq8WT9QJ9mTwDmBVWY7muLviI3dC17TlH1RHIbl3/tcxtaFHGigRqzB9wvXTvPwpxlP0lPGFKfIX9z8ZGaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013431; c=relaxed/simple;
	bh=mX49TOuu90HlnCj9EIbOl4exT9DXXurOdm6+IkAg7ck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QoY5Z2OJ8BVIowXgOQJTrCYzvCTdvtNkq8vOinmNTusE1I3Oe0SA8FZqubsJc1ZMpSEZ9Z6/BQvZBUvttIvrRYmXR+d3jUaMjHvJ64Uu6Rivx4tZ6hW2w/KJAh3cbiDX2b2ap/b3aGESoIKRSVeaGCNPrnGvcW5EuiZDAcyhOg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EDQtVzlH; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EDQtVzlH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1747013429; x=1778549429;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mX49TOuu90HlnCj9EIbOl4exT9DXXurOdm6+IkAg7ck=;
  b=EDQtVzlHFonJraGQON57tD74ybuieJwUGpKCILtQ5s6RGRvdXg/IdmzD
   L8BdB/y9J4EXgGYZ9uWcRqdAj4YVBoIoQR/6y/0zdXgHl4OXvUMsVpFUB
   p0RVQdEv6gtvUNXw2/mSXjvQXwzbzfGnAl/mB3VfpsBlYOYgujf6nJOmY
   Yby2vXM0BFUVshiDMS3AaEL7u9WBvpfhVrb8xRX+pemYjyxCpFWRq7OPu
   0Ow/RstiUWo+sDvZViUhCapXNyA+WFAx+r7Ue3xv/GsCt5MxRSc+Z1Pga
   cdDA+NH3JnGPPVti115V1farpCB1uAE3ntmLUtKmJVQvzumRtODYHLvQ+
   g==;
X-CSE-ConnectionGUID: Roa+LqrXRDWIlMuF2Sf+0Q==
X-CSE-MsgGUID: yqp40mbvTZa7lFLixrpvdA==
X-IronPort-AV: E=Sophos;i="6.15,281,1739808000"; 
   d="scan'208";a="80052596"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 May 2025 09:30:23 +0800
IronPort-SDR: 682140f8_xSSHUXTXY4rTzmybiib/HpZEFUuwpteFRkepnHmheezLtc1
 3/gqGG/qdHMREsYktZN5D01q77+BV8rnGNUDbXQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 May 2025 17:29:45 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 11 May 2025 18:30:23 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] fio_sem, diskutil: introduce fio_shared_sem and use it for diskutil lock
Date: Mon, 12 May 2025 10:30:22 +0900
Message-ID: <20250512013022.64633-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To report disk utilization statistics, fio allocates struct disk_util
objects for each disk of the I/O target files. These struct disk_util
objects are allocated via smalloc() from the fio shared memory, allowing
them to be allocated or freed by any fio process. The disk_util objects
are managed with the global list disk_list and are all freed by the fio
main process at the end of fio_backend() through
disk_util_prune_entries().

The struct disk_util contains the field struct fio_sem *lock which
points to the lock object. This object is allocated via mmap() with
MAP_SHARED flag. When allocated by parent process, this lock can be
shared across fio processes after forking child processes; however, the
parent process can not either access or free it when the lock object is
allocated by child processes. This lock object is also freed by the fio
main process alongside with the disk_util objects.

The commit c492cb1a9b1c ("iolog: fix disk stats issue") modified
init_iolog() to call init_disk_util(), which allocates the fio_sem lock
object for the struct disk_util. This commit enabled the disk
utilization report feature for the files recorded in the I/O replay
files. However, since the added init_disk_util() call is executed in
the child fio job processes, the disk_util object and the fio_sem lock
objects are allocated by the child processes. While allocation by child
process is acceptable for the disk_util object, it causes segmentation
faults when the fio_sem lock objects are freed at the end of the fio
main process.

The segmentation fault can be recreated by running two jobs: one job
does regular I/O to a system disk file. The other job replays I/O to
another disk. It can be triggered using the following command and the
files:

  $ sudo fio recreate.fio

  recreate.fio
  ============
  [dev_a]
  filename=test_file
  rw=read
  size=4096
  [dev_b]
  read_iolog=recreate.iolog

  recreate.iolog
  ==============
  fio version 3 iolog
  0 /dev/nullb0 add
  1 /dev/nullb0 open
  2 /dev/nullb0 read 0 4096
  3 /dev/nullb0 close

This fault happens only when fio jobs are handled as processes. When
thread=1 option is specified, fio jobs are threads and reside within
single memory space, then the fault is not observed.

To prevent the segmentation fault, allocate the fio_sem lock object not
by mmap() but by smalloc(). This ensures the fio main process can free
the fio_sem lock objects along with the disk_util objects. To achieve
this, introduce two new helper functions, fio_shared_sem_init() and
fio_shared_sem_remove(). These functions behave exactly same as the
existing functions fio_sem_init() and fio_sem_remove() except the memory
allocation method.

Do not implement the new functions in the existing source file
fio_sem.c, because it implements fio_sem_init() and fio_sem_remove()
which are used for smalloc() implementation. If the two new functions
were implemented in fio_sem.c, it would create circular references and
cause build failures. Instead, add a new source file fio_shared_sem.c to
implement the new functions.

Fixes: c492cb1a9b1c ("iolog: fix disk stats issue")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 Makefile         |  2 +-
 diskutil.c       |  4 ++--
 fio_sem.h        |  2 ++
 fio_shared_sem.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+), 3 deletions(-)
 create mode 100644 fio_shared_sem.c

diff --git a/Makefile b/Makefile
index 173378fa..f3a80882 100644
--- a/Makefile
+++ b/Makefile
@@ -53,7 +53,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/lib/*.c))) \
 		gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c fio_sem.c rwlock.c \
-		pshared.c options.c \
+		pshared.c options.c fio_shared_sem.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		engines/ftruncate.c engines/fileoperations.c \
diff --git a/diskutil.c b/diskutil.c
index 69b3dd26..f018015c 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -38,7 +38,7 @@ static void disk_util_free(struct disk_util *du)
 		slave->users--;
 	}
 
-	fio_sem_remove(du->lock);
+	fio_shared_sem_remove(du->lock);
 	free(du->sysfs_root);
 	sfree(du);
 }
@@ -327,7 +327,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 	du->minor = mindev;
 	INIT_FLIST_HEAD(&du->slavelist);
 	INIT_FLIST_HEAD(&du->slaves);
-	du->lock = fio_sem_init(FIO_SEM_UNLOCKED);
+	du->lock = fio_shared_sem_init(FIO_SEM_UNLOCKED);
 	du->users = 0;
 
 	fio_sem_down(disk_util_sem);
diff --git a/fio_sem.h b/fio_sem.h
index a796ddd7..a06f6eb7 100644
--- a/fio_sem.h
+++ b/fio_sem.h
@@ -21,8 +21,10 @@ enum {
 
 extern int __fio_sem_init(struct fio_sem *, int);
 extern struct fio_sem *fio_sem_init(int);
+extern struct fio_sem *fio_shared_sem_init(int);
 extern void __fio_sem_remove(struct fio_sem *);
 extern void fio_sem_remove(struct fio_sem *);
+extern void fio_shared_sem_remove(struct fio_sem *);
 extern void fio_sem_up(struct fio_sem *);
 extern void fio_sem_down(struct fio_sem *);
 extern bool fio_sem_down_trylock(struct fio_sem *);
diff --git a/fio_shared_sem.c b/fio_shared_sem.c
new file mode 100644
index 00000000..95e07400
--- /dev/null
+++ b/fio_shared_sem.c
@@ -0,0 +1,44 @@
+/*
+ * Separate out the two helper functions for fio_sem from "fio_sem.c".
+ * These two functions depend on fio shared memory. Other fio_sem
+ * functions in "fio_sem.c" are used for fio shared memory. This file
+ * separation is required to avoid build failures caused by circular
+ * dependency.
+ */
+
+#include <stdio.h>
+
+#include "fio_sem.h"
+#include "smalloc.h"
+
+/*
+ * Allocate and initialize fio_sem lock object in the same manner as
+ * fio_sem_init(), except the lock object is allocated from the fio
+ * shared memory. This allows the parent process to free the lock
+ * allocated by child processes.
+ */
+struct fio_sem *fio_shared_sem_init(int value)
+{
+	struct fio_sem *sem = NULL;
+
+	sem = smalloc(sizeof(struct fio_sem));
+	if (!sem) {
+		perror("fio: smalloc for semaphore failed");
+		return NULL;
+	}
+
+	if (!__fio_sem_init(sem, value))
+		return sem;
+
+	fio_shared_sem_remove(sem);
+	return NULL;
+}
+
+/*
+ * Free the fio_sem lock object allocated by fio_shared_sem_init().
+ */
+void fio_shared_sem_remove(struct fio_sem *sem)
+{
+	__fio_sem_remove(sem);
+	sfree(sem);
+}
-- 
2.49.0

