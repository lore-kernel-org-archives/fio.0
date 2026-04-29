Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA4CA4E
	for <fio@vger.kernel.org>; Wed, 29 Apr 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464011; cv=none; b=DujcDW+SbjwvCcPU55vcGWOgS3qkQaMu0mjiYXMTTPxVcTKW3bEb1JqQLXF6qUGbRqfob3s0tAZfLCLI+vYANxHDOgNzZsuRaWX/eZOzgDNOceDZbpAFAAhdhBkwzOR51GuJu6ybT38t+loR3wfNUUo/iyI3ZakW8/bvvjvh5lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464011; c=relaxed/simple;
	bh=R2XOqlU5nVYBOTV8PxD5RWPeJJ6nCQ3DZtMx5sImBw8=;
	h=Subject:From:To:Date:Message-Id; b=dpQEe5wn3K0YaFHQNWfAko9ZUNu917+s8y99JDO+Q7BdroN4cEbZ+bxjV0TV1AM3twcS1Oqra1ajYWNeHFWwaeP4ftaihuA7hOQhGugZXfIiI6RTPm3DX2vsaUo6GR+O2Bp6jhJr2u4iwYN7ieKJoS8BNyfxKP+ENcstbxfC7V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GCuwJ/VW; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GCuwJ/VW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fktPfiIfH2e8R6m7ocjdM4rZRJjmvmN1qfwhfF1hScM=; b=GCuwJ/VWaabb8N4zMRmoCfGB+O
	O7xTwqySBIuLIpcJSx4ICmSaqHcpJLKWlVQPEjnuYIft32t1pE5fLHRLQskmqAHOsiicMQgOiY5DV
	z17cllgHTDIb2wPMSmIbFvg4iCdxwChp3qjYHt8ahO0k9hp38Ngey+Wr2hKWatEtG1LpiTKr7NhGk
	yXSmZnLmXzgUuJ2vVZGxCyGG0kTlz3FxiiC8BsZywzTTSX2PzkxRd02rInUKkWbMCbt10jfl9ZOuq
	fPdN/3TR/nTL1bchUN/hsK2qyfyKqkpY7ZVcdN3LhSDeB6km5hA9E1eLfTNWU4SIDU3iNjFiTI1WH
	SwLgbvAQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wI3aG-00000005W5q-3rX1
	for fio@vger.kernel.org;
	Wed, 29 Apr 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5A7331BC0165; Wed, 29 Apr 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 29 Apr 2026 06:00:01 -0600
Message-Id: <20260429120001.5A7331BC0165@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7b1fa07c9c7d4624fefd31d40d36742e900f6e44:

  Merge branch 'prevent_large_trim_size_and_high_iodepth_causing_oom' of https://github.com/dennischerchang/fio (2026-04-22 15:59:15 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a95f84caad2300e73ec9bf7077879f30246f3185:

  sprandom: relax power of 2 block size requirement (2026-04-28 12:25:01 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      Merge branch 'run_HSMR' of https://github.com/rorychen/fio-HSMR
      sprandom: relax power of 2 block size requirement

rorychen (1):
      libzbc: fix fio abort prematurely when encounting SOBR zones

 engines/libzbc.c | 3 +++
 sprandom.c       | 8 +-------
 zbd.h            | 2 +-
 zbd_types.h      | 1 +
 4 files changed, 6 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 0fa6bfd1..b271cf1e 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -240,6 +240,9 @@ static int libzbc_report_zones(struct thread_data *td, struct fio_file *f,
 		case ZBC_ZT_SEQUENTIAL_PREF:
 			zbdz->type = ZBD_ZONE_TYPE_SWP;
 			break;
+		case ZBC_ZT_SEQ_OR_BEF_REQ:
+			zbdz->type = ZBD_ZONE_TYPE_SOBR;
+			break;
 		default:
 			td_verror(td, errno, "invalid zone type");
 			log_err("%s: invalid type for zone at sector %llu.\n",
diff --git a/sprandom.c b/sprandom.c
index 429a7754..63eb200b 100644
--- a/sprandom.c
+++ b/sprandom.c
@@ -533,7 +533,7 @@ static uint64_t sprandom_physical_size(double over_provisioning, uint64_t logica
 	uint64_t size;
 
 	size = logical_sz + ceil((double)logical_sz * over_provisioning);
-	return (size + (align_bs - 1)) & ~(align_bs - 1);
+	return size - (size % align_bs);
 }
 
 /**
@@ -840,12 +840,6 @@ int sprandom_init(struct thread_data *td, struct fio_file *f)
 	if (!td->o.sprandom)
 		return 0;
 
-	if (!is_power_of_2(align_bs)) {
-		log_err("fio: sprandom: bs [%"PRIu64"] should be power of 2",
-			align_bs);
-		return -EINVAL;
-	}
-
 	info = calloc(1, sizeof(*info));
 	if (!info)
 		return -ENOMEM;
diff --git a/zbd.h b/zbd.h
index 14204316..676cfaef 100644
--- a/zbd.h
+++ b/zbd.h
@@ -44,7 +44,7 @@ struct fio_zone_info {
 	uint64_t		capacity;
 	uint32_t		writes_in_flight;
 	uint32_t		max_write_error_offset;
-	enum zbd_zone_type	type:2;
+	enum zbd_zone_type	type:4;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		has_wp:1;
 	unsigned int		write:1;
diff --git a/zbd_types.h b/zbd_types.h
index 5f44f308..53e4df6b 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -26,6 +26,7 @@ enum zbd_zone_type {
 	ZBD_ZONE_TYPE_CNV	= 0x1,	/* Conventional */
 	ZBD_ZONE_TYPE_SWR	= 0x2,	/* Sequential write required */
 	ZBD_ZONE_TYPE_SWP	= 0x3,	/* Sequential write preferred */
+	ZBD_ZONE_TYPE_SOBR	= 0x4,	/* Sequential Of Before Required */
 };
 
 /*
