Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597D5C43217
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiKHIt5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiKHItx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:53 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EDA2E683
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897392; x=1699433392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/fS8CrSi6pbeXivtN/MIGVC6nXX68refD7Du2WklIxM=;
  b=aqxQQLaYf3v9yh6FEcDxe/p1x0eLYq8r3krksQTzi9FonNKcx4cNdap9
   aEBIOcTbIzJiulXy4ua3/R6eYwkv2OEx3U+nL0ME1g9V1ZLdJ5MaO3b84
   XyrQkVzjZI1kiWy69wUFLUEo/wY1uHXJcrY49YSHbco1OmRxZmNvSX3xh
   FFxW2Qf9QOIRkz4VlyN5UlYoSOGnz/3gN2BADIx2e9NtlzRp0BTHeBZ4E
   aBMzQy9BO61lJRXpUWCsCeF1/MZumojCiBNdFsYUZORJtibubNGWR/k6L
   dG7ny9Bum/X4fFVszxcjzliQU2gE+QV7FPjP7xSLvoX2+9t7qOGEG/rDi
   w==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="215743472"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:52 +0800
IronPort-SDR: ElKZZ58lVZOfZGd7Van9QuWZLl5mQbpBWWts6GyEuZXU8RZ482ZxQsLn/jN6/4Granob7p9Yj2
 QTU0a9fZgmjkUvttGmLCUc13CNP0HOJBN5BtJyO8kA5LOK1SSMastvEy53A3l3aBWImMhBaI2f
 gkbTzgo9Thb8/PkddIRq9q8Sh6D5or65zxQ9uA2RJX27aG5RZZUV7HCpozdWor/Mh5eCL0vtpu
 DJMzmu6qcW4Rno+baCodFUx5c/Eqf6MDe3+XlZjb1QRNd34v0mKGgCoe16T63CP6+eoQefSo9/
 K90=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:13 -0800
IronPort-SDR: Y/xtpAJa2w/Jlxd8a1DDmBgzsHnEkqdxeGsqBVVm3668vQBzMkNk9ZYuGt7mct6DJ1pksvUOVl
 +FeDsx65JsaazVGkxZSCKpgYUsbdlmFeOhve9lRRGUOSTtM4B8WohsNbKBQ6sx7vPY5WCP5m4Z
 3Qp2opzACaU7ttFOT7ha65+7ZQUN19OHUV3Aglu2chFHdnnwX/Q8QKeFUnhtMF+QoMN2K5nNAb
 Y33zEVR3hkKZ729MZxPjc3rEvr1DDMS9vPTyYZKix2MhIk0bQGCP8fzFWC29GnTmgNI9kMaM9H
 5vk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:52 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 08/13] zbd: prevent experimental verify with zonemode=zbd
Date:   Tue,  8 Nov 2022 17:49:35 +0900
Message-Id: <20221108084940.1574939-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When the experimental_verify option is specified, fio does not record
normal I/O metadata to create verify read unit. Instead, fio resets file
status after normal I/O and before verify start, then replay I/Os to
regenerate write unit and adjust it to verify read. This I/O replay does
not work for zonemode=zbd since zone status needs to be restored at
verify start to the status before the normal I/O. However, such status
restore moves write pointers and erases data pattern for verify.

Check that the options experimental_verify and zonemode=zbd are not
specified together and error out in case they are both specified. Also
remove the helper function zbd_replay_write_order() which is called from
zbd_adjust_block(). This function adjusts verify read unit to meet zone
write restrictions for experimental verify, but such adjustment does not
work because zone status is not restored before verify start.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 46 ++++++----------------------------------------
 zbd.h |  2 --
 2 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/zbd.c b/zbd.c
index 6faacdac..547c727f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -291,7 +291,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	z->wp = z->start;
-	z->verify_block = 0;
 
 	td->ts.nr_zone_resets++;
 
@@ -1085,6 +1084,11 @@ int zbd_setup_files(struct thread_data *td)
 	if (!zbd_verify_bs())
 		return 1;
 
+	if (td->o.experimental_verify) {
+		log_err("zonemode=zbd does not support experimental verify\n");
+		return 1;
+	}
+
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd = f->zbd_info;
 		struct fio_zone_info *z;
@@ -1521,42 +1525,6 @@ out:
 	return z;
 }
 
-/* The caller must hold z->mutex. */
-static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
-						    struct io_u *io_u,
-						    struct fio_zone_info *z)
-{
-	const struct fio_file *f = io_u->file;
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
-
-	if (!zbd_open_zone(td, f, z)) {
-		zone_unlock(z);
-		z = zbd_convert_to_open_zone(td, io_u);
-		assert(z);
-	}
-
-	if (z->verify_block * min_bs >= z->capacity) {
-		log_err("%s: %d * %"PRIu64" >= %"PRIu64"\n",
-			f->file_name, z->verify_block, min_bs, z->capacity);
-		/*
-		 * If the assertion below fails during a test run, adding
-		 * "--experimental_verify=1" to the command line may help.
-		 */
-		assert(false);
-	}
-
-	io_u->offset = z->start + z->verify_block * min_bs;
-	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
-		log_err("%s: %llu + %llu >= %"PRIu64"\n",
-			f->file_name, io_u->offset, io_u->buflen,
-			zbd_zone_capacity_end(z));
-		assert(false);
-	}
-	z->verify_block += io_u->buflen / min_bs;
-
-	return z;
-}
-
 /*
  * Find another zone which has @min_bytes of readable data. Search in zones
  * @zb + 1 .. @zl. For random workload, also search in zones @zb - 1 .. @zf.
@@ -1907,10 +1875,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		if (td->runstate == TD_VERIFYING && td_write(td)) {
-			zb = zbd_replay_write_order(td, io_u, zb);
+		if (td->runstate == TD_VERIFYING && td_write(td))
 			goto accept;
-		}
 
 		/*
 		 * Check that there is enough written data in the zone to do an
diff --git a/zbd.h b/zbd.h
index 0a73b41d..d425707e 100644
--- a/zbd.h
+++ b/zbd.h
@@ -25,7 +25,6 @@ enum io_u_action {
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
  * @capacity: maximum size usable from the start of a zone (bytes)
- * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
@@ -39,7 +38,6 @@ struct fio_zone_info {
 	uint64_t		start;
 	uint64_t		wp;
 	uint64_t		capacity;
-	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		has_wp:1;
-- 
2.37.1

