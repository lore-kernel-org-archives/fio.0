Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BEA34DCD3
	for <fio@vger.kernel.org>; Fri,  5 Sep 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757073611; cv=none; b=sf6lrvNIrWvH0xFw8mctxXAJO7sqB35UhWDAoyNI/d7IB/w702W1B9NA0egnQv4B+GdFqZ7UXsEJewL+Xh3Oz1ZM375PR1SKzG1kNFsm32npQXD/H49cNLGWb9YmhB7drAOPo1HP3Tdx29Vw7G5y06yiqrvw3ndK64UIj4+rsI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757073611; c=relaxed/simple;
	bh=YPwtEJW8ossWa3yhziJvDxQqrShxZxr9pqAkpA/rGHM=;
	h=Subject:From:To:Message-Id:Date; b=gZitwJbWtebc5mQYMbxoVQD2wrcwsVoK/8/F/xNllqkImvVtniiWOsHvi5idPkNzfPpHM6zF/MBdcIvMdNQfBfW8t+vXimPCRvTCjsDxlsSLwxOLkAnil7XqRIIzemXFiNDU/7zNDtbxWaexJOhAbArJVgeMYxl//PeRKbqTloQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EdRmVwMi; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EdRmVwMi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=6fF/QwfYAlSeA3EEVmk/MZClZbi1E08nWOzd5vSgmkk=; b=EdRmVwMi0v41fJsHcAS/7tmg4o
	r8fg0PVTJydQHm6WGfMI/yGPw9aT6Ysm0mWUYy+XC4QmGvEa34z+NIbqIQSwktj9q7Mx+BiEb90oV
	Ogvb793RhFlZaFbOw4fPXWT7lpp9oFM6r3NE4UfSP0KImzgZySwR2C59SupPGSdPAhf0jJjl5VIJ0
	c/NiDpDDodpLZd6u45Sb6Vt/nAF+Q7kbV7VHGJvbztm7dD+TyS1QFDyx7uH+0YLX1XDKKzxe7FuHp
	lflFVrIEl70xUUdKlPmLa7/mlxuSITH3gY9ycxNUP2ouXDr9uVBu3veURUvKB7H6NWEYV3n8hAhMi
	Pu3GQBLQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uuV6q-00000004Vvp-0Twb
	for fio@vger.kernel.org;
	Fri, 05 Sep 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id DD3E01BC0179; Fri,  5 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250905120001.DD3E01BC0179@kernel.dk>
Date: Fri,  5 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d4b1dce71cf9fa0f0ba1f53286315a3ebb2147dd:

  Merge branch 'sprandom-fixes' of https://github.com/tomas-winkler-sndk/fio (2025-09-03 20:33:23 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 83a809bea583b06f9893003fd76eab7c36c212b1:

  Merge branch 'fix_verify-state' of https://github.com/sitsofe/fio (2025-09-04 17:27:53 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix_verify-state' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      t/verify-state: synchronise verify state version
      t/verify-state: improve verify state inflight output

Vincent Fu (1):
      sprandom: wait to free validity_dist

 fio.h            |  2 --
 sprandom.c       |  3 +--
 t/verify-state.c | 11 ++++++++---
 verify-state.h   |  2 ++
 4 files changed, 11 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index 44788899..037678d1 100644
--- a/fio.h
+++ b/fio.h
@@ -73,8 +73,6 @@ struct fio_sem;
 
 #define MAX_TRIM_RANGE	256
 
-#define INVALID_NUMBERIO UINT64_MAX
-
 /*
  * Range for trim command
  */
diff --git a/sprandom.c b/sprandom.c
index 05e8c88a..7262eee3 100644
--- a/sprandom.c
+++ b/sprandom.c
@@ -602,8 +602,6 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 		double inv = (1.0 - validity_dist[i]) * (double)PCT_PRECISION;
 		spr_info->invalid_pct[i] = (int)round(inv);
 	}
-	free(validity_dist);
-	validity_dist = NULL;
 
 	region_sz = physical_size / spr_info->num_regions;
 	region_write_count = region_sz / align_bs;
@@ -641,6 +639,7 @@ static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
 		total_alloc,
 		bytes2str_simple(bytes2str_buf, sizeof(bytes2str_buf), total_alloc));
 
+	free(validity_dist);
 	return 0;
 err:
 	free(validity_dist);
diff --git a/t/verify-state.c b/t/verify-state.c
index e1b92ee8..9d76e501 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -29,8 +29,13 @@ static void show_s(struct thread_io_list *s, unsigned int no_s)
 	if (!s->depth)
 		return;
 	for (i = s->depth - 1; i >= 0; i--) {
-		printf("\t%llu\n",
-				(unsigned long long) s->inflight[i].numberio);
+		uint64_t numberio;
+		numberio = s->inflight[i].numberio;
+		if (numberio == INVALID_NUMBERIO)
+			printf("\tNot inflight\n");
+		else
+			printf("\t%llu\n",
+			       (unsigned long long) s->inflight[i].numberio);
 	}
 }
 
@@ -84,7 +89,7 @@ static void show_verify_state(void *buf, size_t size)
 		return;
 	}
 
-	if (hdr->version == 0x04)
+	if (hdr->version == VSTATE_HDR_VERSION)
 		show(s, size);
 	else
 		log_err("Unsupported version %d\n", (int) hdr->version);
diff --git a/verify-state.h b/verify-state.h
index d8997ace..27eb9e9a 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -101,4 +101,6 @@ static inline void verify_state_gen_name(char *out, size_t size,
 	out[size - 1] = '\0';
 }
 
+#define INVALID_NUMBERIO UINT64_MAX
+
 #endif
