Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A762EC43217
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbiKNCN2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiKNCN0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:26 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F94220
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392003; x=1699928003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cbzXMAu+CJYlvADpUBKjYCkzMPz9XVfSyR2up2n/ris=;
  b=Cpx5bCGDFDC8yjexdUvKzna0gC593xpB3lhBoVNvLso8eRhtijA+oxtU
   mTxqEwrK+Ju82B3952qVZprTNIkXLSS7LsOhbMqHGarKSQeCoKhASVzZr
   M8Ae6zBe3p9NjthP5xYNbIXGZidZQ+ZDKURi2kVlXT4v+vCwaLzJte31Y
   QmthWjhKrNUVuyURn6t2PCx1uSUi/iwDNsNwxMXNF/Pa0cYu8j8T7R8ru
   nV3wSud9G8JR0tYpkU6C1xhAOGfQMWXrT7K4vQuwj92fjfmdLlx0f4Itg
   Tz0p+78Dx6oxItWZde9OSYwtXZqQh38mvjO/nqte+B0XXe/VH3mvXTpeU
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279226"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:23 +0800
IronPort-SDR: AesfALyELIfMcT6W/KXr0eu2EEn1v0tLSV1L9Zk7xr/VV5WI4x36YS7Cl/rDRlne8G5IHc1ThD
 ipdASo84eUSmEX4eRA9VWMjLX5OF1zFdt5w68+XnhF9jZ3k1qTjOcpnCoJnyQ9JZauwLMumByk
 8NrNIODMGMfSNU+7xhG7rNtYJUkKhQwEv8xPDWSGAbHYjy7LfV8ge+HnPMe4N4oA49eaXPPDtc
 Yblrd7mT4DQsam+smq/hnkHk5vqpC+LZsDMzc9L+8+xJxoFs0fKf5rjH/esITLO/FUw5P96lir
 nh8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:22 -0800
IronPort-SDR: qpd8QRgoIiQ79+/CwkDhqgm4uHl3pEH25aszMxpkofQTHNNiwVW79SLPStDo60XiiUvYfl1f39
 SUvOW8I3W/MnQmB7ACGcB6Ne9ITxeI2zWn91ZMPNtv+LncPCAxABVzCOvGfH5iFFbV1u07zgfJ
 Vqv+bbm5/wlZprs+6YkWktSCPTX7hOstpquIq1k0WyPeq84zKZJp9JM44ixSKJ12xmFx2dskaT
 E/Je72MhaCmRo3nAL08Fne0b0/4LZrWiZwNO4w3l33VitHYC1k3MXtiBAp/LJ9fuMeYp0+B90d
 GhQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:23 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 06/13] zbd, verify: verify before zone reset for zone_reset_threshold/frequency
Date:   Mon, 14 Nov 2022 11:13:01 +0900
Message-Id: <20221114021308.1684141-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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

