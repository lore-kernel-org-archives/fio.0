Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3FEC001DC
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjGGDPK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjGGDPJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:09 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C544C1BC9
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699708; x=1720235708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gwyudbJLVFszNA9qQzMbIsVu8TkSi8k0mkw0S2hi5R4=;
  b=XvMzyRmPEFRuZcTLdgD11lWTOXpwsFe1rjoYpNnBlVAHMfAXl+EmqMMg
   zBQ8dSxv3bD29l+DfpETUzMb4N2wn8UJgSfaywiUbM0AjCggt/3POgwKn
   N9ugiWEWozgp9C4nQ+LaONtUtTMJEVQdFqXCdxT3FUpwxO73aqclmb0Xc
   PpKXJ6AuVNdx2PT6sezXbCtFGWpLA245JzrSDhUSaORABGJfJCvnbP/Gq
   1Ketk8yvjIwLh2zsvtiDoYqgLTWw/jIjgV0fywurlxbUseErupClZbzni
   J3VhoeabnTEHNO/r3AIv5scV0Q7bNj4d1hM/JZoguF9Xs/WIBN06zvKpC
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468792"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:08 +0800
IronPort-SDR: VMUM9mmczVVDRFji8l9CT9NOJmRkCbln+Bw54B5iEDzN3KMaKK8f+PaVJXJCSvocldqbLlJAkB
 RAdj5iaMx3dBi0PIcqhH+nur/f4bkd0VD984iNPjFoYOyrXItEGNxf4pvAYUCClcNh92ufW6w7
 DrEBHxrrg5tfTpZEdFWw136PACIj8aSLGDkbPF0e2rqtHCwrkqx6oDkjr2cbXI5j4IxzwAfQgp
 PuCKNAa1Nl9IiE1PS9KY+yuel3XcMon2nMhiGdtwXcg9a53mm/AS2MVfdCzNv8yYJuXjv/rIe3
 7uU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:15 -0700
IronPort-SDR: r7Hr24hAhergrnMFxiYnk3g/2wJrczOL6nYNpK6eZmCthi7lcwdHDaThqLXkYfLRqV6OPB2rAb
 Ea1w84VnkGf/44XryWWmqR7jLQrrcl7UQt/mE3LORPnLoSPIQ+4LfCAcUWtosZ8YDyEjnS5vXE
 NDo06JPfb5WfiP3uG/hAslVTHKb5PlF0f3PBIK5XqFhpy5AJqj0BWIfRerk8LZNAwEfP5wQWaM
 0fpe1GEzUmQNvdYWCV0t+3arl5CLD5r/mnafACDn3Eg8l9J7oFHm/Pskd7myCLP/DATFk5iud0
 olQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:07 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 01/13] zbd: refer max_active_zones sysfs attribute
Date:   Fri,  7 Jul 2023 12:14:53 +0900
Message-Id: <20230707031505.3468915-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As a preparation to improve open zones accounting for devices with the
max_active_zones limit, refer max_active_zones sysfs attribute. Then
keep the limit value in the struct zoned_block_device_info.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 oslib/blkzoned.h       |  9 +++++++++
 oslib/linux-blkzoned.c | 23 +++++++++++++++++++++++
 zbd.c                  |  8 ++++++++
 zbd.h                  |  4 ++++
 4 files changed, 44 insertions(+)

diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 29fb034f..e598bd4f 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -18,6 +18,9 @@ extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				       unsigned int *max_open_zones);
+extern int blkzoned_get_max_active_zones(struct thread_data *td,
+					 struct fio_file *f,
+					 unsigned int *max_active_zones);
 extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 #else
@@ -53,6 +56,12 @@ static inline int blkzoned_get_max_open_zones(struct thread_data *td, struct fio
 {
 	return -EIO;
 }
+static inline int blkzoned_get_max_active_zones(struct thread_data *td,
+						struct fio_file *f,
+						unsigned int *max_open_zones)
+{
+	return -EIO;
+}
 static inline int blkzoned_finish_zone(struct thread_data *td,
 				       struct fio_file *f,
 				       uint64_t offset, uint64_t length)
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 722e0992..2c3ecf33 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -186,6 +186,29 @@ int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 	return 0;
 }
 
+int blkzoned_get_max_active_zones(struct thread_data *td, struct fio_file *f,
+				  unsigned int *max_active_zones)
+{
+	char *max_active_str;
+
+	if (f->filetype != FIO_TYPE_BLOCK)
+		return -EIO;
+
+	max_active_str = blkzoned_get_sysfs_attr(f->file_name, "queue/max_active_zones");
+	if (!max_active_str) {
+		*max_active_zones = 0;
+		return 0;
+	}
+
+	dprint(FD_ZBD, "%s: max active zones supported by device: %s\n",
+	       f->file_name, max_active_str);
+	*max_active_zones = atoll(max_active_str);
+
+	free(max_active_str);
+
+	return 0;
+}
+
 static uint64_t zone_capacity(struct blk_zone_report *hdr,
 			      struct blk_zone *blkz)
 {
diff --git a/zbd.c b/zbd.c
index d4565215..9743b60e 100644
--- a/zbd.c
+++ b/zbd.c
@@ -922,6 +922,14 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	/* a sentinel */
 	zbd_info->zone_info[nr_zones].start = offset;
 
+	ret = blkzoned_get_max_active_zones(td, f,
+					    &zbd_info->max_active_zones);
+	if (ret < 0) {
+		dprint(FD_ZBD, "%s: max_active_zones is not available\n",
+		       f->file_name);
+		zbd_info->max_active_zones = 0;
+	}
+
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
diff --git a/zbd.h b/zbd.h
index f0ac9876..a5cf59d1 100644
--- a/zbd.h
+++ b/zbd.h
@@ -52,6 +52,9 @@ struct fio_zone_info {
  *      are simultaneously written. A zero value means unlimited zones of
  *      simultaneous writes and that write target zones will not be tracked in
  *      the write_zones array.
+ * @max_active_zones: device side limit on the number of sequential write zones
+ *	in open or closed conditions. A zero value means unlimited number of
+ *	zones in the conditions.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
@@ -75,6 +78,7 @@ struct fio_zone_info {
 struct zoned_block_device_info {
 	enum zbd_zoned_model	model;
 	uint32_t		max_write_zones;
+	uint32_t		max_active_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		wp_valid_data_bytes;
-- 
2.40.1

