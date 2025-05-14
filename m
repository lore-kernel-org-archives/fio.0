Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA7204F9B
	for <fio@vger.kernel.org>; Wed, 14 May 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747224010; cv=none; b=gxCdTw9FSCKas+I7eRUut4NaQhqdYFuHPaet6n4HFY1ehvs+DLpVJOJyF4AYOGZdblA4DxDH8mwwoBUd6StH9l5hILPPSxOZLQTzHDpqKgGfcw0GFJpLQ+EmzVv9BnE6/VJYI1N+Q09LJjLPefJf69+HdKPT2drCYqdjtAaTACk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747224010; c=relaxed/simple;
	bh=6kEgE0dsQtQ59VJfQCN8+T93i9l6QZ9sWWGs0vlOSOc=;
	h=Subject:From:To:Message-Id:Date; b=GaAaOK4Q9fC2kP22Fe+vY7ZUmL/kDB2B3BpzcDIAxHxd82J4GeW6DvwExn/1CVth618j+GvFfx5FzEa2tbUsWgqpeGHrne7rlH8Y0AcY9vbv24r6THvGPrQFeDxhePve10hH2cOpWLL61i23GUz+RS+Bx+86iIXbS1UG8o7oRXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SDh7dnM1; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SDh7dnM1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=w9SZYTYjBJyS3hiCGYu8uk7Y7EdAhnb7D3wZ5WgYbnE=; b=SDh7dnM1JPKmc+yWHmKGQfUeSG
	SezCv8Y+0IV8bqWdVFGmRwW7nFTb1CN/w3yIM720Oc+KQxG+PsUcCf+0JDdkm8efNCXG232+cqPcu
	577fLEnqiaBsoJWAOyG3PuzBGv3gRob2Ow29z5ylsoMCeIuH8EGqmnEfiwpVolWeyDO8zr8IHmTAn
	hHDpdIrzk1Wypyar2qJh1C8S27l78iUYatPO3mxiak1GmYwLmTjkgIIGUN/BvW2zX4RPiNsfLTmgG
	HdrnD9tKI2jfyz4QOU5r4UaMAwVY4sK1TVisodFquFMden5mk3gcSBlBvSF8Sx2QrtOP74ZKlPA+2
	gEiWXj0A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uFAmK-0000000H8hR-2jhu
	for fio@vger.kernel.org;
	Wed, 14 May 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 820E71BC0164; Wed, 14 May 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250514120001.820E71BC0164@kernel.dk>
Date: Wed, 14 May 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f4e54d3fa7bf94a17648a4439f06ca7dab4291c0:

  man: Fix recover_zbd_write_error option description (2025-05-09 08:40:30 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 171e18146a3ea26491b087a29c6ee7b0ad21e719:

  configure: Fix libnfs cflags and libs (2025-05-14 06:56:13 -0400)

----------------------------------------------------------------
Damien Le Moal (1):
      configure: Fix libnfs cflags and libs

Shin'ichiro Kawasaki (1):
      fio_sem, diskutil: introduce fio_shared_sem and use it for diskutil lock

 Makefile              |  2 +-
 ci/actions-install.sh |  2 ++
 configure             |  4 ++--
 diskutil.c            |  4 ++--
 fio_sem.h             |  2 ++
 fio_shared_sem.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 51 insertions(+), 5 deletions(-)
 create mode 100644 fio_shared_sem.c

---

Diff of recent changes:

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
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index ad352317..30b815f3 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -32,6 +32,7 @@ DPKGCFG
         libcunit1-dev
         libcurl4-openssl-dev
         libfl-dev
+	libgnutls28-dev
         libnuma-dev
 	libnfs-dev
         valgrind
@@ -106,6 +107,7 @@ install_fedora() {
         bison-devel
         git
         flex-devel
+	gnutls-devel
         gperftools
         isa-l-devel
         kernel-devel
diff --git a/configure b/configure
index 715f0602..986eb0a6 100755
--- a/configure
+++ b/configure
@@ -2361,8 +2361,8 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 if test "$libnfs" != "no" ; then
   if $(pkg-config libnfs > /dev/null 2>&1); then
     libnfs="yes"
-    libnfs_cflags=$(pkg-config --cflags libnfs)
-    libnfs_libs=$(pkg-config --libs libnfs)
+    libnfs_cflags=$(pkg-config --cflags libnfs gnutls)
+    libnfs_libs=$(pkg-config --libs libnfs gnutls)
   else
     if test "$libnfs" = "yes" ; then
       feature_not_found "libnfs" "libnfs"
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
index 00000000..bc26bbe7
--- /dev/null
+++ b/fio_shared_sem.c
@@ -0,0 +1,42 @@
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
+	struct fio_sem *sem;
+
+	sem = smalloc(sizeof(struct fio_sem));
+	if (!sem)
+		return NULL;
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
