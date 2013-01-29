Return-Path: <fio-owner@vger.kernel.org>
Received: from pbit-mailserver.permabit.com ([66.202.84.83]:49088 "EHLO
	pbit-mailserver.permabit.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580Ab3A2BsW (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 28 Jan 2013 20:48:22 -0500
From: Ken Raeburn <raeburn@permabit.com>
Subject: [PATCH] Fix crash with absurdly but not impossibly deeply nested device stacks.
References: <6eham0rdc3.fsf@just-testing.permabit.com>
Date: Mon, 28 Jan 2013 20:48:21 -0500
In-Reply-To: <6eham0rdc3.fsf@just-testing.permabit.com> (Ken Raeburn's message
	of "Mon, 28 Jan 2013 20:24:12 -0500")
Message-ID: <6ea9rsrc7u.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

diskutil.c: Check for overflow in disk_util.path.
diskutil.h: Expand disk_util.path to PATH_MAX.
---
 diskutil.c |    8 +++++++-
 diskutil.h |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/diskutil.c b/diskutil.c
index fbc4268..22dc58f 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -276,13 +276,19 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 {
 	struct disk_util *du, *__du;
 	struct flist_head *entry;
+	int l;
 
 	dprint(FD_DISKUTIL, "add maj/min %d/%d: %s\n", majdev, mindev, path);
 
 	du = smalloc(sizeof(*du));
 	memset(du, 0, sizeof(*du));
 	INIT_FLIST_HEAD(&du->list);
-	sprintf(du->path, "%s/stat", path);
+	l = snprintf(du->path, sizeof(du->path), "%s/stat", path);
+	if (l < 0 || l >= sizeof(du->path)) {
+		log_err("constructed path \"%.100s[...]/stat\" larger than buffer (%zu bytes)\n",
+			path, sizeof(du->path) - 1);
+		exit(1);
+	}
 	strncpy((char *) du->dus.name, basename(path), FIO_DU_NAME_SZ);
 	du->sysfs_root = path;
 	du->major = majdev;
diff --git a/diskutil.h b/diskutil.h
index b89aacc..ddd6471 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -42,7 +42,7 @@ struct disk_util {
 
 	char *name;
 	char *sysfs_root;
-	char path[256];
+	char path[PATH_MAX];
 	int major, minor;
 
 	struct disk_util_stat dus;
-- 
1.7.9.5

