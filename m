Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdISMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 19 Sep 2017 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1duHCL-0008SD-2H
        for fio@vger.kernel.org; Tue, 19 Sep 2017 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170919120002.493B12C0128@kernel.dk>
Date: Tue, 19 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9acb08a9957b1111a06fbca6af113fa0c98dbd7c:

  Merge branch 'doc-patches' of https://github.com/vincentkfu/fio (2017-09-14 11:37:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 51102e0d64a2ae08472ecb90a72737f08de942fb:

  add fio_set_directio() error message for platforms without direct I/O (2017-09-18 12:43:27 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (4):
      lib/memalign: don't malloc size twice
      fix strncpy(3) copy length
      add "invalid block size" to "first direct IO errored." message
      add fio_set_directio() error message for platforms without direct I/O

 filesetup.c        | 1 +
 ioengines.c        | 4 ++--
 lib/memalign.c     | 2 +-
 os/windows/posix.c | 3 ++-
 server.c           | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index b51ab35..891a55a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1868,6 +1868,7 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
 
 	return 0;
 #else
+	log_err("fio: direct IO is not supported on this host operating system\n");
 	return -1;
 #endif
 }
diff --git a/ioengines.c b/ioengines.c
index fa4acab..9638d80 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -342,8 +342,8 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	    td->o.odirect) {
 
 		log_info("fio: first direct IO errored. File system may not "
-			 "support direct IO, or iomem_align= is bad. Try "
-			 "setting direct=0.\n");
+			 "support direct IO, or iomem_align= is bad, or "
+			 "invalid block size. Try setting direct=0.\n");
 	}
 
 	if (!td->io_ops->commit || io_u->ddir == DDIR_TRIM) {
diff --git a/lib/memalign.c b/lib/memalign.c
index 137cc8e..bfbd1e8 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -18,7 +18,7 @@ void *fio_memalign(size_t alignment, size_t size)
 
 	assert(!(alignment & (alignment - 1)));
 
-	ptr = malloc(size + alignment + size + sizeof(*f) - 1);
+	ptr = malloc(size + alignment + sizeof(*f) - 1);
 	if (ptr) {
 		ret = PTR_ALIGN(ptr, alignment - 1);
 		f = ret + size;
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 488d0ed..00f0335 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -584,7 +584,8 @@ char *basename(char *path)
 	while (path[i] != '\\' && path[i] != '/' && i >= 0)
 		i--;
 
-	strncpy(name, path + i + 1, MAX_PATH);
+	name[MAX_PATH - 1] = '\0';
+	strncpy(name, path + i + 1, MAX_PATH - 1);
 
 	return name;
 }
diff --git a/server.c b/server.c
index 0469cea..e6ea4cd 100644
--- a/server.c
+++ b/server.c
@@ -856,7 +856,7 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 #ifdef CONFIG_BIG_ENDIAN
 	probe.bigendian = 1;
 #endif
-	strncpy((char *) probe.fio_version, fio_version_string, sizeof(probe.fio_version));
+	strncpy((char *) probe.fio_version, fio_version_string, sizeof(probe.fio_version) - 1);
 
 	probe.os	= FIO_OS;
 	probe.arch	= FIO_ARCH;
