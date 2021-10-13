Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B38C433F5
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2142160E53
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhJMGLK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:11:10 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:53709 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhJMGLJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 02:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634105347; x=1665641347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bv+MGXFRDFL34Q6uMYWzEIyvXt5O/4wp5wQuVs/mx6c=;
  b=YAzfORBRQLIRuT7Sq2BCIYrQN9f4qBeukffpEWSipQa/rCSH+FGrePug
   6GHo/73CXp+X3Ak9kuLi5/HUsfzpd+XNcrsxCrYYJzJckD7PYS0L3jpCS
   jI4DFPfObA7KSERQ2u3o24KXd1VA36hk1sJ3+31NSUFOVUxjqpso5iJTN
   c6GjbmcgoCmn6FtyrxWaqMvPQYM9U7Efif4x1VsjCS0aEh+PTVgR26oxS
   hCby2OKWMeJysVpKnInC5nPmtOohBRZ2l16NmNYKx58zJozovlLhPHEVG
   IRa40PfNEeG7O8rcieTABORPnTvccbtbQELWTeI53m/iPMvEkCPZmbADp
   g==;
X-IronPort-AV: E=Sophos;i="5.85,369,1624291200"; 
   d="scan'208";a="181718911"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 14:09:06 +0800
IronPort-SDR: 8vC2f+PeC5w+hgznOYBsGERYD4tXVZBhvpnbXT3jJVWVAzvv7zUh2YAdNzi6aOxvEisekD/9WU
 ZpgXTx9Mpcnwjbi+q8JtqENPmrBxtVkhplm/nG80GmI1uYdIlcqllt0SZZa+DxFiU/xEa+ekpt
 LZzg+BAEGW8wcx8+rAh0SFfuGupj1TlwfEGmpyVRdMUGfO9M4BAc0GWI4lHhawOg5S/MnwUjZF
 uBM+jFT8wAtzsry3d6BgCYeU1Rq3zzvlbsVkE8KQi1BGobuuC1Saw4m+cb2i9x5veisxym8k9B
 ihY1l+85w4h53DLaVAg/Xack
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 22:43:20 -0700
IronPort-SDR: R95ext9Uw38FV2xDED7A8NPUwTY9zIryhQDyUw5CHfsIdtlDS+5rnqtFMTFPn6jdLSYzNA5Wev
 UuG+/AkKd7HH9ZvIOUqrQlhcoW8XX1MGesTfoSO5ld05fNxradT2zzR7TNowGk4PFDSa+90VNy
 ksmX2xKbIwqM0TtG18Ck3JKkaE8KJz+zG0vcKRz9qQHzaeXSJk4eQnTv7EDbhO6V2IpaaNcHBb
 I70+a4ATw43ZBgxbXU7O8X+TfL55cz0dvc6PgqIGt8pv7M/pF5HZBHPnRutf8eFWV/j4CniipX
 vFE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Oct 2021 23:09:06 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/5] zbd: Remove cast to unsigned long long for printf
Date:   Wed, 13 Oct 2021 15:08:59 +0900
Message-Id: <20211013060903.166543-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Many of the variables in zbd.c have type uint64_t. They are casted to
unsigned long long and printed with printf %llu format to handle
uint64_t types difference among architectures. This requires many
lengthy casts to unsigned long long.

To simplify the code, remove the casts to unsigned long long. Some of
the casts are simply unnecessary. To remove other casts, replace the
printf format %llu with PRIu64 so that uint64_t type difference among
architectures is handled accordingly.

Fio build pass of this change was confirmed with 32bit ARM cross
compiler and 64bit x86 compiler.

Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 91 +++++++++++++++++++++++++++--------------------------------
 1 file changed, 42 insertions(+), 49 deletions(-)

diff --git a/zbd.c b/zbd.c
index c0b0b81c..f175d490 100644
--- a/zbd.c
+++ b/zbd.c
@@ -83,12 +83,12 @@ int zbd_report_zones(struct thread_data *td, struct fio_file *f,
 		ret = blkzoned_report_zones(td, f, offset, zones, nr_zones);
 	if (ret < 0) {
 		td_verror(td, errno, "report zones failed");
-		log_err("%s: report zones from sector %llu failed (%d).\n",
-			f->file_name, (unsigned long long)offset >> 9, errno);
+		log_err("%s: report zones from sector %"PRIu64" failed (%d).\n",
+			f->file_name, offset >> 9, errno);
 	} else if (ret == 0) {
 		td_verror(td, errno, "Empty zone report");
-		log_err("%s: report zones from sector %llu is empty.\n",
-			f->file_name, (unsigned long long)offset >> 9);
+		log_err("%s: report zones from sector %"PRIu64" is empty.\n",
+			f->file_name, offset >> 9);
 		ret = -EIO;
 	}
 
@@ -116,9 +116,8 @@ int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
 		ret = blkzoned_reset_wp(td, f, offset, length);
 	if (ret < 0) {
 		td_verror(td, errno, "resetting wp failed");
-		log_err("%s: resetting wp for %llu sectors at sector %llu failed (%d).\n",
-			f->file_name, (unsigned long long)length >> 9,
-			(unsigned long long)offset >> 9, errno);
+		log_err("%s: resetting wp for %"PRIu64" sectors at sector %"PRIu64" failed (%d).\n",
+			f->file_name, length >> 9, offset >> 9, errno);
 	}
 
 	return ret;
@@ -318,16 +317,16 @@ static bool zbd_verify_sizes(void)
 					return false;
 				}
 			} else if (td->o.zone_size != f->zbd_info->zone_size) {
-				log_err("%s: job parameter zonesize %llu does not match disk zone size %llu.\n",
-					f->file_name, (unsigned long long) td->o.zone_size,
-					(unsigned long long) f->zbd_info->zone_size);
+				log_err("%s: job parameter zonesize %llu does not match disk zone size %"PRIu64".\n",
+					f->file_name, td->o.zone_size,
+					f->zbd_info->zone_size);
 				return false;
 			}
 
 			if (td->o.zone_skip % td->o.zone_size) {
 				log_err("%s: zoneskip %llu is not a multiple of the device zone size %llu.\n",
-					f->file_name, (unsigned long long) td->o.zone_skip,
-					(unsigned long long) td->o.zone_size);
+					f->file_name, td->o.zone_skip,
+					td->o.zone_size);
 				return false;
 			}
 
@@ -341,9 +340,9 @@ static bool zbd_verify_sizes(void)
 						 f->file_name);
 					return false;
 				}
-				log_info("%s: rounded up offset from %llu to %llu\n",
-					 f->file_name, (unsigned long long) f->file_offset,
-					 (unsigned long long) new_offset);
+				log_info("%s: rounded up offset from %"PRIu64" to %"PRIu64"\n",
+					 f->file_name, f->file_offset,
+					 new_offset);
 				f->io_size -= (new_offset - f->file_offset);
 				f->file_offset = new_offset;
 			}
@@ -357,9 +356,9 @@ static bool zbd_verify_sizes(void)
 						 f->file_name);
 					return false;
 				}
-				log_info("%s: rounded down io_size from %llu to %llu\n",
-					 f->file_name, (unsigned long long) f->io_size,
-					 (unsigned long long) new_end - f->file_offset);
+				log_info("%s: rounded down io_size from %"PRIu64" to %"PRIu64"\n",
+					 f->file_name, f->io_size,
+					 new_end - f->file_offset);
 				f->io_size = new_end - f->file_offset;
 			}
 		}
@@ -388,17 +387,17 @@ static bool zbd_verify_bs(void)
 				continue;
 			zone_size = f->zbd_info->zone_size;
 			if (td_trim(td) && td->o.bs[DDIR_TRIM] != zone_size) {
-				log_info("%s: trim block size %llu is not the zone size %llu\n",
+				log_info("%s: trim block size %llu is not the zone size %"PRIu64"\n",
 					 f->file_name, td->o.bs[DDIR_TRIM],
-					 (unsigned long long)zone_size);
+					 zone_size);
 				return false;
 			}
 			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
 				    zone_size % td->o.bs[k] != 0) {
-					log_info("%s: block size %llu is not a divisor of the zone size %llu\n",
+					log_info("%s: block size %llu is not a divisor of the zone size %"PRIu64"\n",
 						 f->file_name, td->o.bs[k],
-						 (unsigned long long)zone_size);
+						 zone_size);
 					return false;
 				}
 			}
@@ -448,8 +447,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 
 	if (zone_capacity > zone_size) {
 		log_err("%s: job parameter zonecapacity %llu is larger than zone size %llu\n",
-			f->file_name, (unsigned long long) td->o.zone_capacity,
-			(unsigned long long) td->o.zone_size);
+			f->file_name, td->o.zone_capacity, td->o.zone_size);
 		return 1;
 	}
 
@@ -525,15 +523,14 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	if (td->o.zone_size == 0) {
 		td->o.zone_size = zone_size;
 	} else if (td->o.zone_size != zone_size) {
-		log_err("fio: %s job parameter zonesize %llu does not match disk zone size %llu.\n",
-			f->file_name, (unsigned long long) td->o.zone_size,
-			(unsigned long long) zone_size);
+		log_err("fio: %s job parameter zonesize %llu does not match disk zone size %"PRIu64".\n",
+			f->file_name, td->o.zone_size, zone_size);
 		ret = -EINVAL;
 		goto out;
 	}
 
-	dprint(FD_ZBD, "Device %s has %d zones of size %llu KB\n", f->file_name,
-	       nr_zones, (unsigned long long) zone_size / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n", f->file_name,
+	       nr_zones, zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -587,9 +584,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 					   ZBD_REPORT_MAX_ZONES));
 		if (nrz < 0) {
 			ret = nrz;
-			log_info("fio: report zones (offset %llu) failed for %s (%d).\n",
-			 	 (unsigned long long)offset,
-				 f->file_name, -ret);
+			log_info("fio: report zones (offset %"PRIu64") failed for %s (%d).\n",
+				 offset, f->file_name, -ret);
 			goto out;
 		}
 	}
@@ -1440,8 +1436,8 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	}
 
 	if (z->verify_block * min_bs >= z->capacity) {
-		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
-			min_bs, (unsigned long long)z->capacity);
+		log_err("%s: %d * %d >= %"PRIu64"\n", f->file_name, z->verify_block,
+			min_bs, z->capacity);
 		/*
 		 * If the assertion below fails during a test run, adding
 		 * "--experimental_verify=1" to the command line may help.
@@ -1450,8 +1446,8 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	}
 	io_u->offset = z->start + z->verify_block * min_bs;
 	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
-		log_err("%s: %llu + %llu >= %llu\n", f->file_name, io_u->offset,
-			io_u->buflen, (unsigned long long) zbd_zone_capacity_end(z));
+		log_err("%s: %llu + %llu >= %"PRIu64"\n", f->file_name, io_u->offset,
+			io_u->buflen, zbd_zone_capacity_end(z));
 		assert(false);
 	}
 	z->verify_block += io_u->buflen / min_bs;
@@ -1672,10 +1668,9 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	    f->last_pos[ddir] >= zbd_zone_capacity_end(z)) {
 		dprint(FD_ZBD,
 		       "%s: Jump from zone capacity limit to zone end:"
-		       " (%llu -> %llu) for zone %u (%llu)\n",
-		       f->file_name, (unsigned long long) f->last_pos[ddir],
-		       (unsigned long long) zbd_zone_end(z), zone_idx,
-		       (unsigned long long) z->capacity);
+		       " (%"PRIu64" -> %"PRIu64") for zone %u (%"PRIu64")\n",
+		       f->file_name, f->last_pos[ddir],
+		       zbd_zone_end(z), zone_idx, z->capacity);
 		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
 		f->last_pos[ddir] = zbd_zone_end(z);
 	}
@@ -1785,9 +1780,9 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 		if (io_u->offset + min_bs > (zb + 1)->start) {
 			dprint(FD_IO,
-			       "%s: off=%llu + min_bs=%u > next zone %llu\n",
+			       "%s: off=%llu + min_bs=%u > next zone %"PRIu64"\n",
 			       f->file_name, io_u->offset,
-			       min_bs, (unsigned long long) (zb + 1)->start);
+			       min_bs, (zb + 1)->start);
 			io_u->offset = zb->start + (zb + 1)->start - io_u->offset;
 			new_len = min(io_u->buflen, (zb + 1)->start - io_u->offset);
 		} else {
@@ -1878,9 +1873,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		if (io_u->buflen > zbdi->zone_size) {
 			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
 			dprint(FD_IO,
-			       "%s: I/O buflen %llu exceeds zone size %llu\n",
-			       f->file_name, io_u->buflen,
-			       (unsigned long long) zbdi->zone_size);
+			       "%s: I/O buflen %llu exceeds zone size %"PRIu64"\n",
+			       f->file_name, io_u->buflen, zbdi->zone_size);
 			goto eof;
 		}
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
@@ -1917,9 +1911,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 			if (zb->capacity < min_bs) {
 				td_verror(td, EINVAL, "ZCAP is less min_bs");
-				log_err("zone capacity %llu smaller than minimum block size %d\n",
-					(unsigned long long)zb->capacity,
-					min_bs);
+				log_err("zone capacity %"PRIu64" smaller than minimum block size %d\n",
+					zb->capacity, min_bs);
 				goto eof;
 			}
 		}
@@ -2006,7 +1999,7 @@ char *zbd_write_status(const struct thread_stat *ts)
 {
 	char *res;
 
-	if (asprintf(&res, "; %llu zone resets", (unsigned long long) ts->nr_zone_resets) < 0)
+	if (asprintf(&res, "; %"PRIu64" zone resets", ts->nr_zone_resets) < 0)
 		return NULL;
 	return res;
 }
-- 
2.31.1

