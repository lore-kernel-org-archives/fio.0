Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A53C4332F
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiJUGei (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiJUGef (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:35 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C52414031
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334066; x=1697870066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Qg114d2j6J6vN227Don86kr5zbhcAQhw0N6eRyfros=;
  b=LnSEhB1Qz1PaEYVbGCfXfN3OElzfhBPwLtcLRV7/f1K+3lfge3WtapF+
   Ayyng7iJhoAtAR8H7CGlG5zn/LC6d8zDuwoUm7Wk59WQUpmNdjtRDPXXx
   qGlwV4FXmt5Mz6tG4KzhMS8lPF36lXgiE4ZC4gUUVPpwbezWqfJMa0ZmX
   893FiKRsNOiVmbLAtzrRQNrRHwDEW/vgstC74vjmPQpW4YEqrPtk2Iq54
   gSJ0mQfSFmGKASqozT5mVY3ctsv66cXuVYn9tByR2xxX/mVhnAqcsnNjh
   v7i6qCtpJHvO8Vhb3usSbT2abYKtPkB3Ba254xFRCv+R6NZZHznVxnp4Y
   w==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733110"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:25 +0800
IronPort-SDR: 0CvPA6VXvg6gIYbVbNei27PHG4V6jgnJLaHq52Nd2gf0UxonC90yCxdyeMK2sKl7eusT/3nXx1
 dWZZXegmXHROuR3ldXA6uGExlWZVB56uAo8AhZYM8fx6moefpk8bPbkTBI9N+SFoz/iJlXPuhp
 fpeLsH1JLjGpiKoqDOqBGZKnXJis7LEZM3dporID9xs1Wf7VRX/bpw/7cNEpEXnKMEagaN9555
 gB0ako+Wv0PGc8CBObRMrqbag0C3w55YagTFogGN9Fys72ZkWWuV9cQLRzvrQjx3chgI/mLu9D
 jOaYG53gn+0uaehxclyVLOLB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:13 -0700
IronPort-SDR: 4QSq3zcn0qDUNecF9jNIkfBsft7T25SMRB6QUCAyOLpEaSLzH8LLgi75pNkUotR+kYlCaFl4Q4
 BMcNPEOgcVy/6PmIfMQFl+SiJiyi96CICpHmzO6sxbQivV1MVkmLxX3RBbtV+BxCjXK6ws/+Oe
 KHOikSC8DC0QXRzWAbolW+/FTB/fOVdfdJYYA4kBqWA954fSpJcHM+8yQ/l2X3Tg6QFz4BzYrJ
 /Z0cz7vnIYv2ab67tkFpPzPQmRlWM3vKfNMucSYyW2HgbX2x027/ZQZEHT1ZflqTjY1hnRrlyq
 5bE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:25 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 06/11] zbd: fix zone reset condition for verify_backlog option
Date:   Fri, 21 Oct 2022 15:34:11 +0900
Message-Id: <20221021063416.860438-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When verify options is specified, zbd_file_reset() resets zones only
when td status is not TD_VERIFYING so that the data to read back for
verify is not wiped out. However, when verify_backlog option is set, the
verify data can be left even if td status is not TD_VERIFYING . This
causes verify failure.

Fix this by improving the condition to reset zones in zbd_file_reset().
Refer not only td status but also verify_batch and io_hist_len values to
avoid zone reset when verify_backlog option is set. This is same check
as check_get_verify().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 3855ab0e..b2f43860 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1246,6 +1246,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
 	uint64_t swd;
+	bool verify_ongoing;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
@@ -1262,7 +1263,10 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing any data to avoid that a zone reset has to be issued while
 	 * writing data, which causes data loss.
 	 */
-	if (td->o.verify != VERIFY_NONE && td->runstate != TD_VERIFYING)
+	verify_ongoing = td->runstate == TD_VERIFYING || td->verify_batch;
+	if (td->io_hist_len && td->o.verify_backlog)
+		verify_ongoing = td->io_hist_len % td->o.verify_backlog;
+	if (td->o.verify != VERIFY_NONE && !verify_ongoing)
 		zbd_reset_zones(td, f, zb, ze);
 	zbd_reset_write_cnt(td, f);
 }
-- 
2.37.1

