Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B5CC433EF
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFA460E74
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhJMGLM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:11:12 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:53709 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhJMGLK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 02:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634105348; x=1665641348;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Vcl1RdaGDbF1RZ81Sh2oBd8xc8+Ayv2jEKX0snk494=;
  b=OVoB9j6cL0W7vEE66x6nJrCPgxT2qLwTbqWVFfIli81b5eXedpYrUFFt
   /Q73k5VwnKaRJxvxmKoa8xqwLDOCxEWuucIqWerREE0M3Te5E5WTxB2q0
   K8Sk6E+oDAoG44GBDycU8tS7M1/5ZCxT7e6Vk6YylRnRzcHqTKLbGbY39
   Uy7nWmnKBIbqyhEwQ/DAtDOd9nMM+ZyBwqJq0HLA3aI0WM5jQp3AmjtSI
   VYBnwgpSDtPqFeV/L+4VCl8/GJ0ZVKIHlKDrZMGTc9FNnncpvlE8OHyxB
   pMOZbLK0t7VuuHVoEaxnEEDoowQHFYQxjkr0rTkCbW3I6iewavpZjmpBZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,369,1624291200"; 
   d="scan'208";a="181718913"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 14:09:08 +0800
IronPort-SDR: kCXaQkImagCcExIf6wPC1hkrW15+x/ufhccMnJ4w8T3ewYWBdS/35S4WLDGsWEobIHTVLVcqMT
 rf3aZlg2RUohTklhgTTN7Q9qc0tPRxncEYsO/77yD0DV4QS4KT2mvnGMnqv1x5RTf9FTxfcK2u
 uHm5UtoAOcaYT31AESNuX1eKDWMDSj8SrK+0OnntTlBj1NeDxeOD/iCZD7sp+DDhVLKlc4NE1C
 yaHQ86naj5e2PaoZTLPIcsUOjJiAhnztIETC0OKrYJMtgjLZWl/87NE2AeQoPySfC51Rnzi3ZW
 mEud7A7F4KZYYI6yuh91lTE9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 22:43:21 -0700
IronPort-SDR: VCRH6SJo8uYQlWwQDw3RTdQq3gv6POuZHN02BwhQqHqEdl/Eihd1qJUhxWPF8Ju+tgp14oT10O
 xqQCtmi0TSh35v4rixY5mOnbtQgonKk/Gfv6x7BIRbzyWetWaZ9L6HBBKvX5Nx87AZJfWHCmlJ
 BeppTLS5dNIWe+DYJwNAhZgIBn0mkZEOc8Iu1kN0NO4mpvj3gKpiWmWDp5TW1mUFwYYW8l1VUL
 p0ax106TY3XNjViJ6avYzgqGs1q1eUZ74PcdJdorw2gR6neY6YobYvlAZLf//s34gxXvnIvMYS
 M3U=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Oct 2021 23:09:07 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/5] zbd: Fix type of local variable min_bs
Date:   Wed, 13 Oct 2021 15:09:00 +0900
Message-Id: <20211013060903.166543-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

In zbd.c, thread option min_bs[] is referred and stored in the local
variable min_bs. Elements of min_bs[] have type unsigned long long, but
the local variable min_bs has type uint32_t. When an element of min_bs[]
has value larger than UINT32_MAX, it overflows on assignment to min_bs.

To avoid the overflow, fix type of the local variable min_bs from
uint32_t to uint64_t. Use uint64_t rather than unsigned long long to be
more specific about data size and consistency in zbd.c. The variable is
passed to the helper function zbd_find_zone(), then fix the type of the
argument of the function also.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/zbd.c b/zbd.c
index f175d490..c18998c4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -968,7 +968,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const ze)
 {
 	struct fio_zone_info *z;
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	int res = 0;
 
 	assert(min_bs);
@@ -1141,7 +1141,7 @@ static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
 static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 			  uint32_t zone_idx)
 {
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z = get_zone(f, zone_idx);
 	bool res = true;
@@ -1224,7 +1224,7 @@ static bool any_io_in_flight(void)
 static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 						      struct io_u *io_u)
 {
-	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	const uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
@@ -1427,7 +1427,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 						    struct fio_zone_info *z)
 {
 	const struct fio_file *f = io_u->file;
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 
 	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
 		zone_unlock(z);
@@ -1436,7 +1436,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	}
 
 	if (z->verify_block * min_bs >= z->capacity) {
-		log_err("%s: %d * %d >= %"PRIu64"\n", f->file_name, z->verify_block,
+		log_err("%s: %d * %"PRIu64" >= %"PRIu64"\n", f->file_name, z->verify_block,
 			min_bs, z->capacity);
 		/*
 		 * If the assertion below fails during a test run, adding
@@ -1463,7 +1463,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
  * pointer, hold the mutex for the zone.
  */
 static struct fio_zone_info *
-zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint32_t min_bytes,
+zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint64_t min_bytes,
 	      struct fio_zone_info *zb, struct fio_zone_info *zl)
 {
 	struct fio_file *f = io_u->file;
@@ -1495,7 +1495,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint32_t min_bytes,
 				zone_unlock(z2);
 		}
 	}
-	dprint(FD_ZBD, "%s: no zone has %d bytes of readable data\n",
+	dprint(FD_ZBD, "%s: no zone has %"PRIu64" bytes of readable data\n",
 	       f->file_name, min_bytes);
 	return NULL;
 }
@@ -1754,7 +1754,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
-	uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	uint64_t new_len;
 	int64_t range;
 
@@ -1780,7 +1780,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 		if (io_u->offset + min_bs > (zb + 1)->start) {
 			dprint(FD_IO,
-			       "%s: off=%llu + min_bs=%u > next zone %"PRIu64"\n",
+			       "%s: off=%llu + min_bs=%"PRIu64" > next zone %"PRIu64"\n",
 			       f->file_name, io_u->offset,
 			       min_bs, (zb + 1)->start);
 			io_u->offset = zb->start + (zb + 1)->start - io_u->offset;
@@ -1911,7 +1911,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 			if (zb->capacity < min_bs) {
 				td_verror(td, EINVAL, "ZCAP is less min_bs");
-				log_err("zone capacity %"PRIu64" smaller than minimum block size %d\n",
+				log_err("zone capacity %"PRIu64" smaller than minimum block size %"PRIu64"\n",
 					zb->capacity, min_bs);
 				goto eof;
 			}
@@ -1942,7 +1942,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		td_verror(td, EIO, "zone remainder too small");
-		log_err("zone remainder %lld smaller than min block size %d\n",
+		log_err("zone remainder %lld smaller than min block size %"PRIu64"\n",
 			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
 		goto eof;
 	case DDIR_TRIM:
-- 
2.31.1

