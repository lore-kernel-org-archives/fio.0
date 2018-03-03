Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbeCCNAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 3 Mar 2018 08:00:11 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1es6ln-0005hl-E7
        for fio@vger.kernel.org; Sat, 03 Mar 2018 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180303130002.6241D2C0085@kernel.dk>
Date: Sat,  3 Mar 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 892930839558edf72052e0471714f227c1391132:

  Merge branch 'hotfix_counter_overflow' of https://github.com/ifke/fio (2018-03-01 09:18:43 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 316bc2d48fefa6f9dbf01e83948dfe847cf3ea0e:

  Merge branch 'mpath_nvme_diskutil' of https://github.com/sitsofe/fio (2018-03-02 12:02:08 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'mpath_nvme_diskutil' of https://github.com/sitsofe/fio

Potnuri Bharat Teja (1):
      diskutil: try additional slave device path if first fails

Sitsofe Wheeler (1):
      diskutil: minor style cleanup

 diskutil.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/diskutil.c b/diskutil.c
index 618cae8..789071d 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -246,7 +246,7 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		 * devices?
 		 */
 		linklen = readlink(temppath, slavepath, PATH_MAX - 1);
-		if (linklen  < 0) {
+		if (linklen < 0) {
 			perror("readlink() for slave device.");
 			closedir(dirhandle);
 			return;
@@ -254,8 +254,10 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		slavepath[linklen] = '\0';
 
 		sprintf(temppath, "%s/%s/dev", slavesdir, slavepath);
+		if (access(temppath, F_OK) != 0)
+			sprintf(temppath, "%s/%s/device/dev", slavesdir, slavepath);
 		if (read_block_dev_entry(temppath, &majdev, &mindev)) {
-			perror("Error getting slave device numbers.");
+			perror("Error getting slave device numbers");
 			closedir(dirhandle);
 			return;
 		}
