Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 8/8] Remove/Move Linux specific sysfs_root field from thread_data
Date: Tue, 24 Jan 2017 00:13:11 +0900
Message-Id: <1485184391-11036-8-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

struct thread_data is better without having a Linux specific field
(even if sysfs_root is simply unused on non Linux environment) given
that other Linux specific code such as diskutil/cgroup/blktrace/etc
are compiled only on Linux.

This commit uses td->files[0]->du->sysfs_root instead of td->sysfs_root,
but results the same from the way diskutil is currently implemented.
Besides being platform independent, it's also better in terms of data
structure since sysfs_root isn't always per-td attribute as mentioned
below.

For example, when N(>1) files are specified via filename= option
(e.g. filename=/dev/sdb:/dev/sdc for N=2), td:files is 1:N, therefore
td:du and td:du->sysfs_root are also 1:N in case of /dev/sdb:/dev/sdc,
however td:td->sysfs_root is obviously 1:1 which in this case means
td->sysfs_root is sysfs root for /dev/sdb (regardless of other files)
from the way td->sysfs_root is set only if it hasn't yet been set.

In other words, if filename=/dev/sdb:/dev/sdc is given, ioscheduler=
option only works against /dev/sdb, which could be different from what
users would expect, but this commit just removes sysfs_root from
struct thread_data without any functional change.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c   | 7 ++++++-
 diskutil.c  | 9 +--------
 filesetup.c | 1 -
 fio.h       | 2 --
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/backend.c b/backend.c
index 27e36bb..1c1f2f9 100644
--- a/backend.c
+++ b/backend.c
@@ -1261,6 +1261,10 @@ static int init_io_u(struct thread_data *td)
 	return 0;
 }
 
+/*
+ * This function is Linux specific.
+ * FIO_HAVE_IOSCHED_SWITCH enabled currently means it's Linux.
+ */
 static int switch_ioscheduler(struct thread_data *td)
 {
 #ifdef FIO_HAVE_IOSCHED_SWITCH
@@ -1271,7 +1275,8 @@ static int switch_ioscheduler(struct thread_data *td)
 	if (td_ioengine_flagged(td, FIO_DISKLESSIO))
 		return 0;
 
-	sprintf(tmp, "%s/queue/scheduler", td->sysfs_root);
+	assert(td->files && td->files[0]);
+	sprintf(tmp, "%s/queue/scheduler", td->files[0]->du->sysfs_root);
 
 	f = fopen(tmp, "r+");
 	if (!f) {
diff --git a/diskutil.c b/diskutil.c
index c34841a..c3bcec9 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -431,9 +431,6 @@ static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 		sprintf(path, "%s", tmp);
 	}
 
-	if (td->o.ioscheduler && !td->sysfs_root)
-		td->sysfs_root = strdup(path);
-
 	return disk_util_add(td, majdev, mindev, path);
 }
 
@@ -452,12 +449,8 @@ static struct disk_util *init_per_file_disk_util(struct thread_data *td,
 			mindev);
 
 	du = disk_util_exists(majdev, mindev);
-	if (du) {
-		if (td->o.ioscheduler && !td->sysfs_root)
-			td->sysfs_root = strdup(du->sysfs_root);
-
+	if (du)
 		return du;
-	}
 
 	/*
 	 * for an fs without a device, we will repeatedly stat through
diff --git a/filesetup.c b/filesetup.c
index 4aaa903..eb28826 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1208,7 +1208,6 @@ void close_and_free_files(struct thread_data *td)
 	td->o.filename = NULL;
 	free(td->files);
 	free(td->file_locks);
-	free(td->sysfs_root);
 	td->files_index = 0;
 	td->files = NULL;
 	td->file_locks = NULL;
diff --git a/fio.h b/fio.h
index 14950fc..19ac0af 100644
--- a/fio.h
+++ b/fio.h
@@ -205,8 +205,6 @@ struct thread_data {
 	void *iolog_buf;
 	FILE *iolog_f;
 
-	char *sysfs_root;
-
 	unsigned long rand_seeds[FIO_RAND_NR_OFFS];
 
 	struct frand_state bsrange_state;
-- 
2.5.5


