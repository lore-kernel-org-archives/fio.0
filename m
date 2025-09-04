Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF62EB871
	for <fio@vger.kernel.org>; Thu,  4 Sep 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756987212; cv=none; b=a7/UfJcccrsAZJbwDu/JLSV0WKct1e+2PWvtcCtRmQyfVYHCUOYNf8ZeUQ1hiaIIIjvApqPnRJum5u1ZRwWmq/j4vZBy5dvNI/wZ0c79S73jahyN/rN0S0Qc+Hx6KPFuEAtsWp9PtFKzfVCuT4chh4ZadRXEzpo081FqqcgscX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756987212; c=relaxed/simple;
	bh=4XSox8U5UNFv5XrYJPXK/1XAbn27bcZPvzHlopEx2uM=;
	h=Subject:From:To:Message-Id:Date; b=s8D7FwHoxroxxbTmyCkAtbCdaD4AuFJRq1TYBl5UcQ2AOa3Vr7abt2nStl+1evhn2t8xa6EfSKDhoH2H1778GOFnammHZVjWI4UVoJyTwyLnCxB8Y+ZSyWcmvkiyjGuEByK/VDIojNpFC2gXJeQOV7lB2r/iYXbUQsdM3lL4LBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jEKpQzOU; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jEKpQzOU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4BZlC+LatytYg9pyMLYwaSk4fqQJyYOWRz/aD2s8WRA=; b=jEKpQzOUiPSag39JQxPoeROffG
	xskHu8mOZ3ugo/Frk+a2vGri+79J3j0K95TOifuxGjOZOWp9oMQ4/yltSaM4aR7lVTK2f/wr9PVc7
	cOG3Pcs0QxZGWmUWhKYd3iJK6i07b4tMOKkR8xeAn2GGeWDHoaajC6zaR7SuiqiXoMSUNEyFXVCe1
	YovqJtesg3CqbJ5dZ36cQRdylLQizgy/+YZ7lBBMW8LDiVamkNR+nor58z91OXS95YGIN1VSzhik/
	PJ/B+gue/vHxTBhfmIR9dTf4gL0GgovsFftqa0fRAFxzTU89P5QYHU1WI2356DlN3uvUC8jKQOCAu
	RdxuIfbA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uu8dJ-00000004LTT-2stk
	for fio@vger.kernel.org;
	Thu, 04 Sep 2025 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D165A1BC013F; Thu,  4 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250904120001.D165A1BC013F@kernel.dk>
Date: Thu,  4 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d6acda3d2e3992dbbb51e6ce2ba5d69e5ef85570:

  Merge branch 'patch-1' of https://github.com/neheb/fio (2025-08-26 19:56:42 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d4b1dce71cf9fa0f0ba1f53286315a3ebb2147dd:

  Merge branch 'sprandom-fixes' of https://github.com/tomas-winkler-sndk/fio (2025-09-03 20:33:23 -0400)

----------------------------------------------------------------
Tomas Winkler (4):
      sprandom: setup SPRandom before total_io_size is computed
      sprandom: fix debug printout for offset
      sprandom: free invalid_pct buffer
      sprandom: drop validity_dist after use

Vincent Fu (1):
      Merge branch 'sprandom-fixes' of https://github.com/tomas-winkler-sndk/fio

 filesetup.c | 20 ++++++++++----------
 sprandom.c  | 12 ++++++------
 sprandom.h  |  3 +--
 3 files changed, 17 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 597bf4c5..1e5f2fa7 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1390,6 +1390,16 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
 
+	if (td->o.sprandom) {
+		if (td->o.nr_files != 1) {
+			 log_err("fio: SPRandom supports only one file");
+			 goto err_out;
+		}
+		err = sprandom_init(td, td->files[0]);
+		if (err)
+			goto err_out;
+	}
+
 	if (o->io_size)
 		td->total_io_size = o->io_size * o->loops;
 	else
@@ -1402,16 +1412,6 @@ done:
 			goto err_out;
 	}
 
-	if (td->o.sprandom) {
-		if (td->o.nr_files != 1) {
-			 log_err("fio: SPRandom supports only one file");
-			 goto err_out;
-		}
-		err = sprandom_init(td, td->files[0]);
-		if (err)
-			goto err_out;
-	}
-
 	if (o->create_only)
 		td->done = 1;
 
diff --git a/sprandom.c b/sprandom.c
index 93e8609d..05e8c88a 100644
--- a/sprandom.c
+++ b/sprandom.c
@@ -590,9 +590,6 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 	/* Initialize validity_distribution */
 	print_d_array("validity resampled:", validity_dist, spr_info->num_regions);
 
-	spr_info->validity_dist = validity_dist;
-	total_alloc += spr_info->num_regions * sizeof(spr_info->validity_dist[0]);
-
 	/* Precompute invalidity percentage array */
 	spr_info->invalid_pct = calloc(spr_info->num_regions,
 				       sizeof(spr_info->invalid_pct[0]));
@@ -605,6 +602,8 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 		double inv = (1.0 - validity_dist[i]) * (double)PCT_PRECISION;
 		spr_info->invalid_pct[i] = (int)round(inv);
 	}
+	free(validity_dist);
+	validity_dist = NULL;
 
 	region_sz = physical_size / spr_info->num_regions;
 	region_write_count = region_sz / align_bs;
@@ -644,7 +643,7 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 
 	return 0;
 err:
-	free(spr_info->validity_dist);
+	free(validity_dist);
 	free(spr_info->invalid_pct);
 	return -ENOMEM;
 }
@@ -722,7 +721,8 @@ int sprandom_get_next_offset(struct sprandom_info *info, struct fio_file *f, uin
 	/* replay invalidation */
 	if (pcb_pop(info->invalid_buf, &offset)) {
 		sprandom_add_with_probability(info, offset,  phase ^ 1);
-		dprint(FD_SPRANDOM, "Write %"PRIu64" over %d\n", *b, info->current_region);
+		dprint(FD_SPRANDOM, "Write %"PRIu64" over %d\n",
+		       offset, info->current_region);
 		goto out;
 	}
 
@@ -829,7 +829,7 @@ void sprandom_free(struct sprandom_info *info)
 	if (!info)
 		return;
 
-	free(info->validity_dist);
+	free(info->invalid_pct);
 	free(info->invalid_buf);
 	free(info);
 }
diff --git a/sprandom.h b/sprandom.h
index ea8b829d..175df8f5 100644
--- a/sprandom.h
+++ b/sprandom.h
@@ -33,12 +33,11 @@ struct sprandom_info {
 	uint64_t  region_sz;
 	uint32_t  num_regions;
 
-	double    *validity_dist;
 	uint32_t  *invalid_pct;
 
 	/* Invalidation list*/
 	struct pc_buf *invalid_buf;
-	uint64_t  invalid_capacity;
+	uint64_t invalid_capacity;
 	size_t   invalid_count[2];
 	uint32_t current_region;
 	uint32_t curr_phase;
