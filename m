Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB77C433FE
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiKHIuB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiKHIt4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:56 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B454A2E6A5
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897394; x=1699433394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cbzXMAu+CJYlvADpUBKjYCkzMPz9XVfSyR2up2n/ris=;
  b=Yma8zLnr3yRXMHvHC7CoV/PY4/p1Npyz+heKcOlEDs31YLfI9hCW98ej
   QmRmwSULuJxTvETe5ii+dKcVbstbw+8cKWjNE+0UXLBWqyazNI9cYWBRZ
   vAZyqtLLblTMmMXlTL8X/mG40dkHiAvboZDlg+6p2wnSb27i3mK33g16d
   Or20PvK1Wan1WbRrC6fhwEDcwW9N3qb1vpXp6MOAnA9oXfvnJRcgy7PRf
   iGx3CL1kk1305ZAFLvHxpyf/FCqB7U/7rCrWsEEHwVstzYVocqD6+qPI2
   oSmsikXHXFrthgY8CHm2Iez9PxMH33RZOHmQdPFPSXdxMB17IP1I7R4FH
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="214025965"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:50 +0800
IronPort-SDR: 23XtnkBuO4k94lW8behpFxZKQn2M33HXlzGPXHAaez5eeIqf/d8zPSU4RIqXaDaYGbtRnBOwaF
 WgYB4KigmeO4l7xuFOA1YmnKViinIKiwOFYSF2C5b4pevlVsD9HJKxL+hbnu8oZyvc/hFz6eM8
 zskRtjys9ZfZWlp004WjUNoemGUgHBMbGHaFMtIHNLhQEB2lD882mNFiyCRcx1glCdaxOqVrzE
 0b+vQFZbXRML0LX8mZIqYcoHNn6L75NYCGzmY4C6NLVMkvPLTgRATqpEuLsXOINVmC+fJZR9He
 HiM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:10 -0800
IronPort-SDR: 17qwkEYhAff+3iu41nMrtM805pbHwwkKeWMbGO3ve77SVuIAlmJTg/R2RekJTBnzd+tUVD3viB
 Wf+9x47DYgHnM4LoFw7Hg+5F8cu54NKUVKNlp9tEEu7TkI0zy8x7io8PvqaYyy9eDwaD2ktEep
 XhvwWuKxIooiWh/PWJ8jvh25Bn/L+ftTf1dVOyfoSYOTK/UMRqN/1Xrkw5zXgY3aYMUkn4i+D5
 FMkHo/CWFCArtmtgkrBWKFu8qwi3VwWB9vwMgGWk5JoFkAhA6JXNJoqYLGM3k1R7+PrbyMxgwx
 vFc=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:49 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 06/13] zbd, verify: verify before zone reset for zone_reset_threshold/frequency
Date:   Tue,  8 Nov 2022 17:49:33 +0900
Message-Id: <20221108084940.1574939-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zone_reset_threshold and zone_reset_frequency options are specified
with zonemode=zbd, it resets zones not full. When verify option is
specified on top of that, the zone reset of non-full zones erases data
for verify and causes verify failure. Current implementation avoids this
scenario by assert.

To allow zone_reset_threshold/frequency options together with verify,
do verify before the zone reset. When zone reset is required to an open
zone with verify data, call get_next_verify() to get io_u for verify
read and return it from zbd_adjust_block(). When io_u->file is set,
get_next_verify() assumes the io_u is requeued and does nothing. Unset
io_u->file to tell get_next_verify() is not requeued.

Also modify verify_io_u() to skip rand_seed check when the option
zone_reset_frequency is set. When the option is set, random seed is not
reset for verify reads in same manner as verify_backlog option, then
this check is not valid.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 verify.c |  6 ++++--
 zbd.c    | 14 +++++++++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/verify.c b/verify.c
index d6a229ca..ddfadcc8 100644
--- a/verify.c
+++ b/verify.c
@@ -917,9 +917,11 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		hdr = p;
 
 		/*
-		 * Make rand_seed check pass when have verify_backlog.
+		 * Make rand_seed check pass when have verify_backlog or
+		 * zone reset frequency for zonemode=zbd.
 		 */
-		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG))
+		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
+		    td->o.zrf.u.f)
 			io_u->rand_seed = hdr->rand_seed;
 
 		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
diff --git a/zbd.c b/zbd.c
index 6f4e5ab2..fadeb458 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2032,7 +2032,19 @@ retry:
 
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
-			assert(td->o.verify == VERIFY_NONE);
+			if (td->o.verify != VERIFY_NONE) {
+				/*
+				 * Unset io-u->file to tell get_next_verify()
+				 * that this IO is not requeue.
+				 */
+				io_u->file = NULL;
+				if (!get_next_verify(td, io_u)) {
+					zone_unlock(zb);
+					return io_u_accept;
+				}
+				io_u->file = f;
+			}
+
 			/*
 			 * Since previous write requests may have been submitted
 			 * asynchronously and since we will submit the zone
-- 
2.37.1

