Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33788 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbcKNNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Nov 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6Grj-0002Cf-RH
        for fio@vger.kernel.org; Mon, 14 Nov 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161114130002.5DFB02C008C@kernel.dk>
Date: Mon, 14 Nov 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 206c546d6015fe3809b8e52ea95f56114b8e9f25:

  rbd: fix crash with zero sized image (2016-11-12 08:36:23 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 471bb52b2e75413d18e8def5bb7d301aab7541e9:

  Fix memory leak on tmp_buf (2016-11-14 00:05:37 +0000)

----------------------------------------------------------------
Colin Ian King (1):
      Fix memory leak on tmp_buf

 oslib/libmtd.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/oslib/libmtd.c b/oslib/libmtd.c
index 5b22d6a..24e9db9 100644
--- a/oslib/libmtd.c
+++ b/oslib/libmtd.c
@@ -1116,6 +1116,7 @@ static int legacy_auto_oob_layout(const struct mtd_dev_info *mtd, int fd,
 		len = mtd->oob_size - start;
 		memcpy(oob + start, tmp_buf + start, len);
 	}
+	free(tmp_buf);
 
 	return 0;
 }
