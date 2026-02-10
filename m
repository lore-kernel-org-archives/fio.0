Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577BB31984E
	for <fio@vger.kernel.org>; Tue, 10 Feb 2026 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770728410; cv=none; b=kG3XcLZ0xyHMiupIFarHZ0YcKcckn88ncU+tXZRahpC9MVUUOsrv0Qfhuz4+kCP6+QgGErc+kY1YCJVn+DTTmwjbCvUlOBPVYpia9qkZzPDDQCStMg12SDdTcIx+2WHd/5c9hAmpCdtpyzSCpr1Cnr8eWheseKDoSH4PXHMw7uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770728410; c=relaxed/simple;
	bh=3On8KBXy/gEfNthO2kPNENLE2+IGhcVVATbR3zybsnY=;
	h=Subject:From:To:Date:Message-Id; b=s4TbJtZPRaUJ13RT7heDYEj6tjMfSvnU2gDuunaS30J0iVOX5Fmzq+OemxtgxcO/X+WP/siKKTY8TxtHzCJe6wpdarJFpx/lBIdKJf6BoxfY20NiXSTp6Tvxs/wsUIl8O/4EFBwkYUW2AFnjOtTUH8fjlQpTxHqwFznI6eLLsMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y0tzQWzH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y0tzQWzH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=3h6Lg9EKraM9oP33QrgwZFvXhdhKiLg3MFFSQlXkTSc=; b=Y0tzQWzHLh/u0iPT7Phm+SC+My
	/3pGtr3mnXYxz/4C3SlpXWcVeThOOOyC6THl3QpzoosFIwwPB/kGj0Yo/bq0nm97PAwlIX6BGdvCm
	lRL4sADswQJHv8HuXDRZP4a9oTJMrezRq/UmTf+E9oksg7VwrcHvUI71dqa4L/E4OKu3SZC7PI886
	Sm9EQ75BKk8biZGr1tKTuyR39QANcmql1Evstw5RPaY3j8UIHICzgqnGWWz9xhflWVf63p91+/yoQ
	w+NbdhNPGVwxtY0B4dhcG5szd0Q4J4gcO9G3r+EXPCJ7EpqrGnriJPylTD4qnpHs+OnY0g9UbUkbW
	yKVdvvvQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpnLY-0000000B6SJ-1v2x
	for fio@vger.kernel.org;
	Tue, 10 Feb 2026 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3D80C1BC0149; Tue, 10 Feb 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 10 Feb 2026 06:00:01 -0700
Message-Id: <20260210130001.3D80C1BC0149@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6783ccc569c8e427cb3cfe4e8b37e18fa0601d9f:

  options: ensure callback handlers handle NULL input (2026-02-08 08:39:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 05b2e9fe7722af4470139465a53c629c40936cb4:

  fio: bump server version for new option (2026-02-10 07:36:17 -0500)

----------------------------------------------------------------
Charles Henry (1):
      SPRandom Cache Size Behavior Implementation

Vincent Fu (2):
      Merge branch 'sprandom-cache-implementation' of https://github.com/cachyyyk/fio-spr-cache
      fio: bump server version for new option

 HOWTO.rst        | 18 +++++++++++++
 cconv.c          |  2 ++
 fio.1            | 18 +++++++++++++
 options.c        | 13 ++++++++++
 server.h         |  2 +-
 sprandom.c       | 77 +++++++++++++++++++++++++++++++++++++++++++++++---------
 sprandom.h       |  1 +
 t/sprandom.py    | 41 +++++++++++++++++++++++++++++-
 thread_options.h |  2 ++
 9 files changed, 160 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index fcb8a914..d31851e9 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1674,6 +1674,24 @@ I/O type
         Default=0.15
 
 
+.. option:: spr_cs=int
+
+	See :option:`sprandom`. Define a cache size in bytes, as specified
+	    by the SSD manufacturer. When this is non-zero, delay invalidating
+		writes by one region in order to make sure that all original
+		writes from a region are flushed from cache before the later
+		invalidating writes are sent to the device. This deferral
+		prevents the original write and the later invalidating write
+		from being present in the device's cache at the same time which
+		would allow the device to ignore the original write and prevent
+		sprandom from achieving its target validity fractions. The
+		actual cache size is used to ensure that the number of regions
+		is not set so large that the size of a region is smaller than
+		the device cache.
+
+        Default=0
+
+
 Block size
 ~~~~~~~~~~
 
diff --git a/cconv.c b/cconv.c
index 3d7b3d14..9f82c724 100644
--- a/cconv.c
+++ b/cconv.c
@@ -233,6 +233,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->sprandom = le32_to_cpu(top->sprandom);
 	o->spr_num_regions = le32_to_cpu(top->spr_num_regions);
 	o->spr_over_provisioning.u.f = fio_uint64_to_double(le64_to_cpu(top->spr_over_provisioning.u.i));
+	o->spr_cache_size = le64_to_cpu(top->spr_cache_size);
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
 	o->fsync_on_close = le32_to_cpu(top->fsync_on_close);
 	o->bs_is_seq_rand = le32_to_cpu(top->bs_is_seq_rand);
@@ -486,6 +487,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->sprandom = cpu_to_le32(o->sprandom);
 	top->spr_num_regions = cpu_to_le32(o->spr_num_regions);
 	top->spr_over_provisioning.u.i = __cpu_to_le64(fio_double_to_uint64(o->spr_over_provisioning.u.f));
+	top->spr_cache_size = __cpu_to_le64(o->spr_cache_size);
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
 	top->fsync_on_close = cpu_to_le32(o->fsync_on_close);
 	top->bs_is_seq_rand = cpu_to_le32(o->bs_is_seq_rand);
diff --git a/fio.1 b/fio.1
index 014916ea..bc3efa5f 100644
--- a/fio.1
+++ b/fio.1
@@ -1469,6 +1469,24 @@ For large devices it is better to use more regions, to increase precision
 and reduce memory allocation. The allocation is proportional to the region size.
 .RE
 .TP
+.B spr_cs=int
+See
+.BR sprandom .
+Define a cache size in bytes, as specified by the SSD manufacturer.
+.P
+.RS
+When this is non-zero, delay invalidating writes by one region in order
+to make sure that all original writes from a region are flushed from
+cache before the later invalidating writes are sent to the device.
+This deferral prevents the original write and the later invalidating
+write from being present in the device's cache at the same time which
+would allow the device to ignore the original write and prevent
+sprandom from achieving its target validity fractions. The actual
+cache size is used to ensure that the number of regions is not set
+so large that the size of a region is smaller than the device cache.
+The default is 0.
+.RE
+.TP
 .B spr_op=float
 See
 .BR sprandom .
diff --git a/options.c b/options.c
index 68189be7..f592bc24 100644
--- a/options.c
+++ b/options.c
@@ -2710,6 +2710,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
 	},
+	{
+		.name	= "spr_cs",
+		.lname	= "SPRandom Device cache size",
+		.type	= FIO_OPT_ULL,
+		.off1	= offsetof(struct thread_options, spr_cache_size),
+		.help	= "Cache Size in bytes for SPRandom",
+		.parent	= "sprandom",
+		.maxlen = 1,
+		.hide	= 1,
+		.def    = "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
 	{
 		.name	= "random_generator",
 		.lname	= "Random Generator",
diff --git a/server.h b/server.h
index a1e71a44..e0a921b8 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 117,
+	FIO_SERVER_VER			= 118,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/sprandom.c b/sprandom.c
index 5565b1a1..429a7754 100644
--- a/sprandom.c
+++ b/sprandom.c
@@ -570,6 +570,7 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 			  uint64_t align_bs)
 {
 	double over_provisioning = spr_info->over_provisioning;
+	int ret = 0;
 	uint64_t physical_size;
 	uint64_t region_sz;
 	uint64_t region_write_count;
@@ -584,8 +585,10 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 
 	validity_dist = compute_validity_dist(spr_info->num_regions,
 					      spr_info->over_provisioning);
-	if (!validity_dist)
-		return -ENOMEM;
+	if (!validity_dist) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	/* Initialize validity_distribution */
 	print_d_array("validity resampled:", validity_dist, spr_info->num_regions);
@@ -593,8 +596,10 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 	/* Precompute invalidity percentage array */
 	spr_info->invalid_pct = calloc(spr_info->num_regions,
 				       sizeof(spr_info->invalid_pct[0]));
-	if (!spr_info->invalid_pct)
+	if (!spr_info->invalid_pct) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	total_alloc += spr_info->num_regions * sizeof(spr_info->invalid_pct[0]);
 
@@ -606,8 +611,24 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 	region_sz = physical_size / spr_info->num_regions;
 	region_write_count = region_sz / align_bs;
 
-	invalid_capacity = estimate_inv_capacity(region_write_count,
-						 validity_dist[0]);
+	if ((spr_info->cache_sz) && (spr_info->cache_sz > region_sz)) {
+		log_err("fio: sprandom: spr_cs [%"PRIu64"] must be smaller than"
+			" region_sz [%"PRIu64"] which means [%"PRIu64"] regions"
+			" allowed", spr_info->cache_sz, region_sz,
+		    (physical_size / spr_info->cache_sz));
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (spr_info->cache_sz) {
+		/* Need 2x size to be safe since we wait to invalidate until after next region */
+		invalid_capacity = estimate_inv_capacity(region_write_count,
+							validity_dist[0]) * 2;
+	} else {
+		invalid_capacity = estimate_inv_capacity(region_write_count,
+							validity_dist[0]);
+	}
+
 	spr_info->invalid_capacity = invalid_capacity;
 
 	spr_info->invalid_buf = pcb_alloc(invalid_capacity);
@@ -633,6 +654,10 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 	dprint(FD_SPRANDOM, "  op: %02f\n", spr_info->over_provisioning);
 	dprint(FD_SPRANDOM, "  region_size:        %"PRIu64"\n", region_sz);
 	dprint(FD_SPRANDOM, "  num_regions:        %u\n", spr_info->num_regions);
+	dprint(FD_SPRANDOM, "  cache_size:         %"PRIu64": %s\n",
+		spr_info->cache_sz,
+		bytes2str_simple(bytes2str_buf, sizeof(bytes2str_buf),
+						 spr_info->cache_sz));
 	dprint(FD_SPRANDOM, "  region_write_count: %"PRIu64"\n", region_write_count);
 	dprint(FD_SPRANDOM, "  invalid_capacity:   %zu\n", invalid_capacity);
 	dprint(FD_SPRANDOM, "  dynamic memory:     %zu: %s\n",
@@ -644,7 +669,7 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 err:
 	free(validity_dist);
 	free(spr_info->invalid_pct);
-	return -ENOMEM;
+	return ret;
 }
 
 /**
@@ -717,16 +742,32 @@ int sprandom_get_next_offset(struct sprandom_info *info, struct fio_file *f, uin
 	uint64_t offset = 0;
 	uint32_t phase = info->curr_phase;
 
-	/* replay invalidation */
-	if (pcb_pop(info->invalid_buf, &offset)) {
-		sprandom_add_with_probability(info, offset,  phase ^ 1);
-		dprint(FD_SPRANDOM, "Write %"PRIu64" over %d\n",
-		       offset, info->current_region);
-		goto out;
+	if (!info->cache_sz) {
+		/* replay invalidation at start of next region prior to moving
+		 * to new region.
+		 */
+		if (pcb_pop(info->invalid_buf, &offset)) {
+			sprandom_add_with_probability(info, offset,  phase ^ 1);
+			dprint(FD_SPRANDOM, "Write %"PRIu64" over %d\n",
+				offset, info->current_region);
+			goto out;
+		}
 	}
 
 	/* Move to next region */
 	if (info->writes_remaining == 0) {
+		if (info->cache_sz) {
+			/* replay invalidation for previous region at end of this
+			 * region to avoid invalidations hitting the defined cache.
+			 */
+			if (pcb_pop(info->invalid_buf, &offset)) {
+				sprandom_add_with_probability(info, offset,  phase ^ 1);
+				dprint(FD_SPRANDOM, "Cache Defer Write %"PRIu64" "
+					" over %d\n", offset, info->current_region);
+				goto out;
+			}
+		}
+
 		if (info->current_region >= info->num_regions) {
 			dprint(FD_SPRANDOM, "End: Last Region %d cur%d\n",
 			       info->current_region, info->num_regions);
@@ -747,6 +788,17 @@ int sprandom_get_next_offset(struct sprandom_info *info, struct fio_file *f, uin
 
 	/* Fetch new offset */
 	if (lfsr_next(&f->lfsr, &offset)) {
+		if (info->cache_sz) {
+			/* Since we defer invalidation to the end of next region we
+			 * need to take into account end of lfsr case
+			 */
+			if (pcb_pop(info->invalid_buf, &offset)) {
+				dprint(FD_SPRANDOM, "lfsr cache exit Write %"PRIu64" "
+					" over %d\n", offset, info->current_region);
+				goto out;
+			}
+		}
+
 		dprint(FD_SPRANDOM, "End: LFSR exhausted %d [%zu] [%zu]\n",
 			info->current_region,
 			info->invalid_count[phase],
@@ -802,6 +854,7 @@ int sprandom_init(struct thread_data *td, struct fio_file *f)
 	over_provisioning = td->o.spr_over_provisioning.u.f;
 	info->num_regions = td->o.spr_num_regions;
 	info->over_provisioning = over_provisioning;
+	info->cache_sz = td->o.spr_cache_size;
 	td->o.io_size = sprandom_physical_size(over_provisioning,
 					       logical_size, align_bs);
 	info->rand_state = &td->sprandom_state;
diff --git a/sprandom.h b/sprandom.h
index 175df8f5..d50c5afb 100644
--- a/sprandom.h
+++ b/sprandom.h
@@ -31,6 +31,7 @@
 struct sprandom_info {
 	double    over_provisioning;
 	uint64_t  region_sz;
+	uint64_t  cache_sz;
 	uint32_t  num_regions;
 
 	uint32_t  *invalid_pct;
diff --git a/t/sprandom.py b/t/sprandom.py
index e1b3a5e0..a4b2fcbc 100755
--- a/t/sprandom.py
+++ b/t/sprandom.py
@@ -25,6 +25,7 @@ from fiotestcommon import SUCCESS_DEFAULT, SUCCESS_NONZERO
 SPRANDOM_OPT_LIST = [
     'spr_op',
     'spr_num_regions',
+    'spr_cs',
     'size',
     'norandommap',
     'random_generator',
@@ -66,6 +67,7 @@ TEST_LIST = [
         "fio_opts": {
             "spr_op": "0.10",
             "spr_num_regions": "50",
+            "spr_cs": "0",
             "size": "32M",
         },
         "success": SUCCESS_DEFAULT,
@@ -76,6 +78,7 @@ TEST_LIST = [
         "fio_opts": {
             "spr_op": "0.25",
             "spr_num_regions": "100",
+            "spr_cs": "0",
             "size": "64M",
         },
         "success": SUCCESS_DEFAULT,
@@ -86,6 +89,7 @@ TEST_LIST = [
         "fio_opts": {
             "spr_op": "0.50",
             "spr_num_regions": "200",
+            "spr_cs": "0",
             "size": "128M",
             "random_generator": "tausworthe",
         },
@@ -97,6 +101,7 @@ TEST_LIST = [
         "fio_opts": {
             "spr_op": "0.75",
             "spr_num_regions": "400",
+            "spr_cs": "0",
             "size": "256M",
             "norandommap": "0"
         },
@@ -105,10 +110,11 @@ TEST_LIST = [
         "test_class": FioSPrandomTest,
     },
     {
-        "test_id": 4,
+        "test_id": 5,
         "fio_opts": {
             "spr_op": "0.75",
             "spr_num_regions": "400",
+            "spr_cs": "0",
             "size": "256M",
             "rw": "randread",
         },
@@ -116,6 +122,39 @@ TEST_LIST = [
         "success": SUCCESS_NONZERO,
         "test_class": FioSPrandomTest,
     },
+    {
+        "test_id": 6,
+        "fio_opts": {
+            "spr_op": "0.10",
+            "spr_num_regions": "100",
+            "spr_cs": "32K",
+            "size": "32M",
+        },
+        "success": SUCCESS_DEFAULT,
+        "test_class": FioSPrandomTest,
+    },
+    {
+        "test_id": 7,
+        "fio_opts": {
+            "spr_op": "0.10",
+            "spr_num_regions": "2000",
+            "spr_cs": "32K",
+            "size": "32M",
+        },
+        "success": SUCCESS_NONZERO,
+        "test_class": FioSPrandomTest,
+    },
+    {
+        "test_id": 8,
+        "fio_opts": {
+            "spr_op": "0.10",
+            "spr_num_regions": "50",
+            "spr_cs": "32M",
+            "size": "32M",
+        },
+        "success": SUCCESS_NONZERO,
+        "test_class": FioSPrandomTest,
+    },
 ]
 
 
diff --git a/thread_options.h b/thread_options.h
index 4a52f981..3e66d477 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -180,6 +180,7 @@ struct thread_options {
 	unsigned int softrandommap;
 	unsigned int sprandom;
 	unsigned int spr_num_regions;
+	unsigned long long spr_cache_size;
 	fio_fp64_t spr_over_provisioning;
 	unsigned int bs_unaligned;
 	unsigned int fsync_on_close;
@@ -517,6 +518,7 @@ struct thread_options_pack {
 	uint32_t softrandommap;
 	uint32_t sprandom;
 	uint32_t spr_num_regions;
+	uint64_t spr_cache_size;
 	fio_fp64_t spr_over_provisioning;
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
