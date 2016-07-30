Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41128 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbcG3MAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Jul 2016 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bTSw3-0002Bv-K0
	for fio@vger.kernel.org; Sat, 30 Jul 2016 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160730120002.4C1942C00D9@kernel.dk>
Date: Sat, 30 Jul 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit be6bb2b72608d7efbec13d06c67446e229136afa:

  Fix overflow caused by signed long division by unsigned long. The over flow seems to occurr when the value of 'log_avg_msec' option is relatively large. (2016-07-29 09:25:17 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 99955d3d3e290ccb06583a821a8112210e4b332d:

  backend: do_dry_run(): get_io_u() can return an error pointer (2016-07-29 09:59:38 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      gettime: remove unneeded 'ret' in {utime,mtime}_since()
      backend: do_dry_run(): get_io_u() can return an error pointer

Tomohiro Kusumi (4):
      Use in-place path separator "/" for Linux specific code
      Make switch_ioscheduler() return 0 if FIO_HAVE_IOSCHED_SWITCH is undefined
      Null terminate before (or after) strncpy(3)
      Use larger local buffer for I/O engine name

 backend.c                |  6 +++++-
 cgroup.c                 |  6 +++---
 diskutil.c               |  8 +++++---
 gettime.c                | 11 +++--------
 ioengines.c              |  3 ++-
 oslib/linux-dev-lookup.c |  2 +-
 6 files changed, 19 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index ad2d7da..8a71490 100644
--- a/backend.c
+++ b/backend.c
@@ -1261,6 +1261,7 @@ static int init_io_u(struct thread_data *td)
 
 static int switch_ioscheduler(struct thread_data *td)
 {
+#ifdef FIO_HAVE_IOSCHED_SWITCH
 	char tmp[256], tmp2[128];
 	FILE *f;
 	int ret;
@@ -1319,6 +1320,9 @@ static int switch_ioscheduler(struct thread_data *td)
 
 	fclose(f);
 	return 0;
+#else
+	return 0;
+#endif
 }
 
 static bool keep_running(struct thread_data *td)
@@ -1395,7 +1399,7 @@ static uint64_t do_dry_run(struct thread_data *td)
 			break;
 
 		io_u = get_io_u(td);
-		if (!io_u)
+		if (IS_ERR_OR_NULL(io_u))
 			break;
 
 		io_u_set(io_u, IO_U_F_FLIGHT);
diff --git a/cgroup.c b/cgroup.c
index 34b61de..a297e2a 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -102,9 +102,9 @@ static char *get_cgroup_root(struct thread_data *td, char *mnt)
 	char *str = malloc(64);
 
 	if (td->o.cgroup)
-		sprintf(str, "%s%s%s", mnt, FIO_OS_PATH_SEPARATOR, td->o.cgroup);
+		sprintf(str, "%s/%s", mnt, td->o.cgroup);
 	else
-		sprintf(str, "%s%s%s", mnt, FIO_OS_PATH_SEPARATOR, td->o.name);
+		sprintf(str, "%s/%s", mnt, td->o.name);
 
 	return str;
 }
@@ -116,7 +116,7 @@ static int write_int_to_file(struct thread_data *td, const char *path,
 	char tmp[256];
 	FILE *f;
 
-	sprintf(tmp, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, filename);
+	sprintf(tmp, "%s/%s", path, filename);
 	f = fopen(tmp, "w");
 	if (!f) {
 		td_verror(td, errno, onerr);
diff --git a/diskutil.c b/diskutil.c
index 8031d5d..a1077d4 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -179,6 +179,7 @@ static int get_device_numbers(char *file_name, int *maj, int *min)
 		/*
 		 * must be a file, open "." in that path
 		 */
+		tempname[PATH_MAX - 1] = '\0';
 		strncpy(tempname, file_name, PATH_MAX - 1);
 		p = dirname(tempname);
 		if (stat(p, &st)) {
@@ -239,7 +240,7 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		    !strcmp(dirent->d_name, ".."))
 			continue;
 
-		sprintf(temppath, "%s%s%s", slavesdir, FIO_OS_PATH_SEPARATOR, dirent->d_name);
+		sprintf(temppath, "%s/%s", slavesdir, dirent->d_name);
 		/* Can we always assume that the slaves device entries
 		 * are links to the real directories for the slave
 		 * devices?
@@ -266,7 +267,7 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		if (slavedu)
 			continue;
 
-		sprintf(temppath, "%s%s%s", slavesdir, FIO_OS_PATH_SEPARATOR, slavepath);
+		sprintf(temppath, "%s/%s", slavesdir, slavepath);
 		__init_per_file_disk_util(td, majdev, mindev, temppath);
 		slavedu = disk_util_exists(majdev, mindev);
 
@@ -370,7 +371,7 @@ static int find_block_dir(int majdev, int mindev, char *path, int link_ok)
 		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
 			continue;
 
-		sprintf(full_path, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, dir->d_name);
+		sprintf(full_path, "%s/%s", path, dir->d_name);
 
 		if (!strcmp(dir->d_name, "dev")) {
 			if (!check_dev_match(majdev, mindev, full_path)) {
@@ -426,6 +427,7 @@ static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 			log_err("unknown sysfs layout\n");
 			return NULL;
 		}
+		tmp[PATH_MAX - 1] = '\0';
 		strncpy(tmp, p, PATH_MAX - 1);
 		sprintf(path, "%s", tmp);
 	}
diff --git a/gettime.c b/gettime.c
index 964a52f..73b48b0 100644
--- a/gettime.c
+++ b/gettime.c
@@ -382,7 +382,6 @@ void fio_clock_init(void)
 uint64_t utime_since(const struct timeval *s, const struct timeval *e)
 {
 	long sec, usec;
-	uint64_t ret;
 
 	sec = e->tv_sec - s->tv_sec;
 	usec = e->tv_usec - s->tv_usec;
@@ -397,9 +396,7 @@ uint64_t utime_since(const struct timeval *s, const struct timeval *e)
 	if (sec < 0 || (sec == 0 && usec < 0))
 		return 0;
 
-	ret = sec * 1000000ULL + usec;
-
-	return ret;
+	return usec + (sec * 1000000);
 }
 
 uint64_t utime_since_now(const struct timeval *s)
@@ -412,7 +409,7 @@ uint64_t utime_since_now(const struct timeval *s)
 
 uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
 {
-	long sec, usec, ret;
+	long sec, usec;
 
 	sec = e->tv_sec - s->tv_sec;
 	usec = e->tv_usec - s->tv_usec;
@@ -426,9 +423,7 @@ uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
 
 	sec *= 1000;
 	usec /= 1000;
-	ret = sec + usec;
-
-	return ret;
+	return sec + usec;
 }
 
 uint64_t mtime_since_now(const struct timeval *s)
diff --git a/ioengines.c b/ioengines.c
index 918b50a..4129ac2 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -126,10 +126,11 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 {
 	struct ioengine_ops *ops;
-	char engine[16];
+	char engine[64];
 
 	dprint(FD_IO, "load ioengine %s\n", name);
 
+	engine[sizeof(engine) - 1] = '\0';
 	strncpy(engine, name, sizeof(engine) - 1);
 
 	/*
diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 4d5f356..3a415dd 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -25,7 +25,7 @@ int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
 		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
 			continue;
 
-		sprintf(full_path, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, dir->d_name);
+		sprintf(full_path, "%s/%s", path, dir->d_name);
 		if (lstat(full_path, &st) == -1) {
 			perror("lstat");
 			break;
