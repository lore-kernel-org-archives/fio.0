Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39920 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfDTMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 Apr 2019 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hHof9-0004vW-EX
        for fio@vger.kernel.org; Sat, 20 Apr 2019 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190420120002.791A92C0104@kernel.dk>
Date: Sat, 20 Apr 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ff547caad147b437f654881717fedc750c0c9b17:

  fio: Add advise THP option to mmap engine (2019-04-18 10:46:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7f125e7f3879d23e79bc2ef5eed678ddab3b5c70:

  zbd: Fix zone report handling (2019-04-19 09:11:34 -0600)

----------------------------------------------------------------
Damien Le Moal (1):
      zbd: Fix zone report handling

 zbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index 2da742b7..1c46b452 100644
--- a/zbd.c
+++ b/zbd.c
@@ -186,11 +186,14 @@ static bool zbd_verify_bs(void)
  * size of @buf.
  *
  * Returns 0 upon success and a negative error code upon failure.
+ * If the zone report is empty, always assume an error (device problem) and
+ * return -EIO.
  */
 static int read_zone_info(int fd, uint64_t start_sector,
 			  void *buf, unsigned int bufsz)
 {
 	struct blk_zone_report *hdr = buf;
+	int ret;
 
 	if (bufsz < sizeof(*hdr))
 		return -EINVAL;
@@ -199,7 +202,12 @@ static int read_zone_info(int fd, uint64_t start_sector,
 
 	hdr->nr_zones = (bufsz - sizeof(*hdr)) / sizeof(struct blk_zone);
 	hdr->sector = start_sector;
-	return ioctl(fd, BLKREPORTZONE, hdr) >= 0 ? 0 : -errno;
+	ret = ioctl(fd, BLKREPORTZONE, hdr);
+	if (ret)
+		return -errno;
+	if (!hdr->nr_zones)
+		return -EIO;
+	return 0;
 }
 
 /*

