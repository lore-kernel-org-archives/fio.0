Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/4] Use in-place path separator "/" for Linux specific code
Date: Sat, 30 Jul 2016 00:05:57 +0900
Message-Id: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

diskutil,cgroup,blktrace related code fully depend on Linux kernel,
so sprintf variants can use in-place path separator "/" instead of
FIO_OS_PATH_SEPARATOR.

In fact these Linux specific files are mix of two types within the
same file depending on who wrote them, where they were originally
using "/".

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 cgroup.c                 |    6 +++---
 diskutil.c               |    6 +++---
 oslib/linux-dev-lookup.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

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
index 8031d5d..294d2d3 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -239,7 +239,7 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		    !strcmp(dirent->d_name, ".."))
 			continue;
 
-		sprintf(temppath, "%s%s%s", slavesdir, FIO_OS_PATH_SEPARATOR, dirent->d_name);
+		sprintf(temppath, "%s/%s", slavesdir, dirent->d_name);
 		/* Can we always assume that the slaves device entries
 		 * are links to the real directories for the slave
 		 * devices?
@@ -266,7 +266,7 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		if (slavedu)
 			continue;
 
-		sprintf(temppath, "%s%s%s", slavesdir, FIO_OS_PATH_SEPARATOR, slavepath);
+		sprintf(temppath, "%s/%s", slavesdir, slavepath);
 		__init_per_file_disk_util(td, majdev, mindev, temppath);
 		slavedu = disk_util_exists(majdev, mindev);
 
@@ -370,7 +370,7 @@ static int find_block_dir(int majdev, int mindev, char *path, int link_ok)
 		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
 			continue;
 
-		sprintf(full_path, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, dir->d_name);
+		sprintf(full_path, "%s/%s", path, dir->d_name);
 
 		if (!strcmp(dir->d_name, "dev")) {
 			if (!check_dev_match(majdev, mindev, full_path)) {
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
-- 
1.7.1


