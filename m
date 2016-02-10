Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcBJNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Feb 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aTUNH-0003zD-VH
	for fio@vger.kernel.org; Wed, 10 Feb 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160210130002.3D2052C2157@kernel.dk>
Date: Wed, 10 Feb 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 820ba1f9c31bbe92e9b8f71d587907819919c0f8:

  io_ddir: io_ddir_name array should be static (2016-02-05 08:42:26 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 03d189b7d77f66ce4f4dba9885d34c7a55ff4e53:

  diskutil: don't print terse disk util twice for json,terse output format (2016-02-09 13:45:50 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      diskutil: fix segfault for both json and terse output
      diskutil: don't print terse disk util twice for json,terse output format

 diskutil.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/diskutil.c b/diskutil.c
index c3181b5..c25c5c9 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -695,6 +695,7 @@ void show_disk_util(int terse, struct json_object *parent,
 {
 	struct flist_head *entry;
 	struct disk_util *du;
+	bool do_json;
 
 	if (!disk_util_mutex)
 		return;
@@ -706,15 +707,17 @@ void show_disk_util(int terse, struct json_object *parent,
 		return;
 	}
 
-	if (output_format & FIO_OUTPUT_JSON)
-		assert(parent);
+	if ((output_format & FIO_OUTPUT_JSON) && parent)
+		do_json = true;
+	else
+		do_json = false;
 
-	if (!terse && !(output_format & FIO_OUTPUT_JSON))
+	if (!terse && !do_json)
 		log_buf(out, "\nDisk stats (read/write):\n");
 
-	if (output_format & FIO_OUTPUT_JSON)
+	if (do_json)
 		json_object_add_disk_utils(parent, &disk_list);
-	if (output_format & ~(FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS)) {
+	else if (output_format & ~(FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS)) {
 		flist_for_each(entry, &disk_list) {
 			du = flist_entry(entry, struct disk_util, list);
 
