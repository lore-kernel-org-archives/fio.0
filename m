Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36697 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759899AbdEWMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 May 2017 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dD8Tu-00025I-KP
        for fio@vger.kernel.org; Tue, 23 May 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170523120001.D90FB2C246B@kernel.dk>
Date: Tue, 23 May 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4641daa9b2e33bc63197dfec48584eaf05890a01:

  Fio 2.20 (2017-05-19 08:25:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to af13d1e88158d3e37940648be139d7a46fe00431:

  Merge branch 'bugfix' of https://github.com/YukiKita/fio (2017-05-22 10:23:25 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      Merge branch 'android-26-shm' of https://github.com/omor1/fio
      Merge branch 'alignment' of https://github.com/omor1/fio
      Fix typo in man page / HOWTO for block size defaults
      Merge branch 'alignment' of https://github.com/sitsofe/fio
      Merge branch 'android_cgroup' of https://github.com/omor1/fio
      Merge branch 'bugfix' of https://github.com/YukiKita/fio

Omri Mor (5):
      flist.h: replace offsetof macros by stddef.h include
      Android: add support for cgroups
      configure: fix _Static_assert check
      os/os-android.h: fix alignment problems in shared memory functions     Fixes: #356 ("Android: SIGBUS due to unaligned access")
      os/os-android.h: fix compilation for Android O

Sitsofe Wheeler (2):
      fio: fix some struct alignment issues
      server: bump protocol version

YukiKita (1):
      Fixed json_print_value so that ending double quote of JSON string value will not disappear

 HOWTO           |  2 +-
 Makefile        |  2 +-
 configure       | 11 +----------
 fio.1           |  2 +-
 fio.h           |  2 +-
 flist.h         |  8 +-------
 json.c          | 10 +++++++---
 libfio.c        |  3 +++
 os/os-android.h | 39 ++++++++++++++++++++-------------------
 server.h        |  2 +-
 stat.h          |  6 +++---
 11 files changed, 40 insertions(+), 47 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d9e881a..a899b90 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1290,7 +1290,7 @@ Block size
 			means default for reads, 8k for writes and trims.
 
 		**bs=,8k,**
-			means default for reads, 8k for writes, and default for writes.
+			means default for reads, 8k for writes, and default for trims.
 
 .. option:: blocksize_range=irange[,irange][,irange], bsrange=irange[,irange][,irange]
 
diff --git a/Makefile b/Makefile
index 1f0f5d0..c3e551d 100644
--- a/Makefile
+++ b/Makefile
@@ -140,7 +140,7 @@ ifeq ($(CONFIG_TARGET_OS), Linux)
   LDFLAGS += -rdynamic
 endif
 ifeq ($(CONFIG_TARGET_OS), Android)
-  SOURCE += diskutil.c fifo.c blktrace.c trim.c profiles/tiobench.c \
+  SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
 		oslib/linux-dev-lookup.c
   LIBS += -ldl
   LDFLAGS += -rdynamic
diff --git a/configure b/configure
index 21bcaf4..0327578 100755
--- a/configure
+++ b/configure
@@ -1930,16 +1930,7 @@ fi
 cat > $TMPC << EOF
 #include <assert.h>
 #include <stdlib.h>
-#undef offsetof
-#ifdef __compiler_offsetof
-#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
-#else
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-#endif
-
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+#include <stddef.h>
 
 struct foo {
   int a, b;
diff --git a/fio.1 b/fio.1
index 0167c23..301a708 100644
--- a/fio.1
+++ b/fio.1
@@ -533,7 +533,7 @@ bs=256k    means 256k for reads, writes and trims
 bs=8k,32k  means 8k for reads, 32k for writes and trims
 bs=8k,32k, means 8k for reads, 32k for writes, and default for trims
 bs=,8k     means default for reads, 8k for writes and trims
-bs=,8k,    means default for reads, 8k for writes, and default for writes
+bs=,8k,    means default for reads, 8k for writes, and default for trims
 .fi
 .TP
 .BI blocksize_range \fR=\fPirange[,irange][,irange] "\fR,\fB bsrange" \fR=\fPirange[,irange][,irange]
diff --git a/fio.h b/fio.h
index e11a039..ed631bc 100644
--- a/fio.h
+++ b/fio.h
@@ -149,7 +149,7 @@ struct thread_data {
 	unsigned int thread_number;
 	unsigned int subjob_number;
 	unsigned int groupid;
-	struct thread_stat ts;
+	struct thread_stat ts __attribute__ ((aligned));
 
 	int client_type;
 
diff --git a/flist.h b/flist.h
index b4fe6e6..2ca3d77 100644
--- a/flist.h
+++ b/flist.h
@@ -2,13 +2,7 @@
 #define _LINUX_FLIST_H
 
 #include <stdlib.h>
-
-#undef offsetof
-#ifdef __compiler_offsetof
-#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
-#else
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-#endif
+#include <stddef.h>
 
 #define container_of(ptr, type, member) ({			\
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
diff --git a/json.c b/json.c
index e0227ec..2160d29 100644
--- a/json.c
+++ b/json.c
@@ -340,9 +340,13 @@ static void json_print_array(struct json_array *array, struct buf_output *out)
 static void json_print_value(struct json_value *value, struct buf_output *out)
 {
 	switch (value->type) {
-	case JSON_TYPE_STRING:
-		log_buf(out, "\"%s\"", value->string);
-		break;
+	case JSON_TYPE_STRING: {
+			const char delimiter = '"';
+			buf_output_add(out, &delimiter, sizeof(delimiter));
+			buf_output_add(out, value->string, strlen(value->string));
+			buf_output_add(out, &delimiter, sizeof(delimiter));
+			break;
+		}
 	case JSON_TYPE_INTEGER:
 		log_buf(out, "%lld", value->integer_number);
 		break;
diff --git a/libfio.c b/libfio.c
index 8310708..da22456 100644
--- a/libfio.c
+++ b/libfio.c
@@ -353,14 +353,17 @@ int initialize_fio(char *envp[])
 	 * can run into problems on archs that fault on unaligned fp
 	 * access (ARM).
 	 */
+	compiletime_assert((offsetof(struct thread_data, ts) % sizeof(void *)) == 0, "ts");
 	compiletime_assert((offsetof(struct thread_stat, percentile_list) % 8) == 0, "stat percentile_list");
 	compiletime_assert((offsetof(struct thread_stat, total_run_time) % 8) == 0, "total_run_time");
 	compiletime_assert((offsetof(struct thread_stat, total_err_count) % 8) == 0, "total_err_count");
 	compiletime_assert((offsetof(struct thread_stat, latency_percentile) % 8) == 0, "stat latency_percentile");
+	compiletime_assert((offsetof(struct thread_data, ts.clat_stat) % 8) == 0, "ts.clat_stat");
 	compiletime_assert((offsetof(struct thread_options_pack, zipf_theta) % 8) == 0, "zipf_theta");
 	compiletime_assert((offsetof(struct thread_options_pack, pareto_h) % 8) == 0, "pareto_h");
 	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "percentile_list");
 	compiletime_assert((offsetof(struct thread_options_pack, latency_percentile) % 8) == 0, "latency_percentile");
+	compiletime_assert((offsetof(struct jobs_eta, m_rate) % 8) == 0, "m_rate");
 
 	err = endian_check();
 	if (err) {
diff --git a/os/os-android.h b/os/os-android.h
index 6c3e098..c56d682 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -32,6 +32,7 @@
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_BLKTRACE
 #define FIO_HAVE_CL_SIZE
+#define FIO_HAVE_CGROUPS
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_TRIM
 #define FIO_HAVE_GETTID
@@ -59,19 +60,17 @@
 
 #ifndef CONFIG_NO_SHM
 /*
- * The Android NDK doesn't currently export <sys/shm.h>, so define the
- * necessary stuff here.
+ * Bionic doesn't support SysV shared memeory, so implement it using ashmem
  */
-
-#include <sys/shm.h>
-#define SHM_HUGETLB    04000
-
 #include <stdio.h>
 #include <linux/ashmem.h>
+#include <linux/shm.h>
+#define shmid_ds shmid64_ds
+#define SHM_HUGETLB    04000
 
 #define ASHMEM_DEVICE	"/dev/ashmem"
 
-static inline int shmctl (int __shmid, int __cmd, struct shmid_ds *__buf)
+static inline int shmctl(int __shmid, int __cmd, struct shmid_ds *__buf)
 {
 	int ret=0;
 	if (__cmd == IPC_RMID)
@@ -84,7 +83,7 @@ static inline int shmctl (int __shmid, int __cmd, struct shmid_ds *__buf)
 	return ret;
 }
 
-static inline int shmget (key_t __key, size_t __size, int __shmflg)
+static inline int shmget(key_t __key, size_t __size, int __shmflg)
 {
 	int fd,ret;
 	char keybuf[11];
@@ -98,7 +97,8 @@ static inline int shmget (key_t __key, size_t __size, int __shmflg)
 	if (ret < 0)
 		goto error;
 
-	ret = ioctl(fd, ASHMEM_SET_SIZE, __size);
+	/* Stores size in first 8 bytes, allocate extra space */
+	ret = ioctl(fd, ASHMEM_SET_SIZE, __size + sizeof(uint64_t));
 	if (ret < 0)
 		goto error;
 
@@ -109,21 +109,22 @@ error:
 	return ret;
 }
 
-static inline void *shmat (int __shmid, const void *__shmaddr, int __shmflg)
+static inline void *shmat(int __shmid, const void *__shmaddr, int __shmflg)
 {
-	size_t *ptr, size = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
-	ptr = mmap(NULL, size + sizeof(size_t), PROT_READ | PROT_WRITE, MAP_SHARED, __shmid, 0);
-	*ptr = size;    //save size at beginning of buffer, for use with munmap
-	return &ptr[1];
+	size_t size = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
+	/* Needs to be 8-byte aligned to prevent SIGBUS on 32-bit ARM */
+	uint64_t *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, __shmid, 0);
+	/* Save size at beginning of buffer, for use with munmap */
+	*ptr = size;
+	return ptr + 1;
 }
 
 static inline int shmdt (const void *__shmaddr)
 {
-	size_t *ptr, size;
-	ptr = (size_t *)__shmaddr;
-	ptr--;
-	size = *ptr;    //find mmap size which we stored at the beginning of the buffer
-	return munmap((void *)ptr, size + sizeof(size_t));
+	/* Find mmap size which we stored at the beginning of the buffer */
+	uint64_t *ptr = (uint64_t *)__shmaddr - 1;
+	size_t size = *ptr;
+	return munmap(ptr, size);
 }
 #endif
 
diff --git a/server.h b/server.h
index 5c720d4..fff6804 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 61,
+	FIO_SERVER_VER			= 62,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.h b/stat.h
index aa4ad80..d8a0803 100644
--- a/stat.h
+++ b/stat.h
@@ -242,17 +242,17 @@ struct jobs_eta {
 	uint32_t nr_pending;
 	uint32_t nr_setting_up;
 
-	uint32_t files_open;
-
 	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
-	uint32_t m_iops[DDIR_RWDIR_CNT], t_iops[DDIR_RWDIR_CNT];
 	uint64_t rate[DDIR_RWDIR_CNT];
+	uint32_t m_iops[DDIR_RWDIR_CNT], t_iops[DDIR_RWDIR_CNT];
 	uint32_t iops[DDIR_RWDIR_CNT];
 	uint64_t elapsed_sec;
 	uint64_t eta_sec;
 	uint32_t is_pow2;
 	uint32_t unit_base;
 
+	uint32_t files_open;
+
 	/*
 	 * Network 'copy' of run_str[]
 	 */
