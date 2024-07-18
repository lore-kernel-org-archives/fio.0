Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A9B13B58F
	for <fio@vger.kernel.org>; Thu, 18 Jul 2024 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721304015; cv=none; b=tXKEdCxey/gOafkyhIcdWtwtJ02m+7JvS54RpgIOv65srcq86BGLbQH/C4an6wvtfcZMrBScr8ZXTiaUUVO0T10VaGZScEhFQH7NQ7CIwO4O2XGn8+Uy1fPiNVhS+rSrjIiVV3z4uc/Eugs4xBL/XrJEOZK6WSL33YKm96+mWpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721304015; c=relaxed/simple;
	bh=LlUEGzgsngrzPLvj+/ZISTWJZJDLQeh/dJlXs5fz1Ss=;
	h=Subject:From:To:Message-Id:Date; b=Dc0Yxg6mdehH45C1MDlMBSJ9TXNbSNr3HsDphHKp9v1DdwudHhsFGT8N98+Ce5xd7IzwtYu9yML+C9aXCeIjZkrHsnpV8O0xOdcipUxus2ufGGCgi7Al5jusiRR2x2irsOC58PkHTN0GakZwosM8Kl0Kl+oXn8qPcL6ni0rdGtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bc+4p3sM; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bc+4p3sM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=oPgEL77r/lrLXJRX5oiNUt24e5jMJXfpftBIWHj28OI=; b=bc+4p3sMkKj/ujGKp81zJKYUkE
	HsCBMJg9Rc0WkzFcMjCr7+bhGxaqCM8mi7EOL9j7sIAVg/qEmCqk2x87SxTOgvxHGTldUFypDx3Gk
	xaCn66APKapRSbgomOR4rOt5aE7nOY+QJouJJvVCkffBxPumPR1iK9AMNohRcNfckuOT2T05uB8GO
	izDo+VLsv0W4xK+TkYeO9kpMkxsf5wpIn2HddW+PNEBvkSu7yNECZiAcD42kggmiTnZuimq2wpUev
	1dF7kd1JbAbA8VsVRXooZqQlLiuvI0fCfFniVb5RhlXx+F8GaVlcLcaGtJ5yUP/nSvRDhtRj3jsLz
	Gl4YBzPg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sUPnq-00000002XYX-3hK9
	for fio@vger.kernel.org;
	Thu, 18 Jul 2024 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 598331BC012E; Thu, 18 Jul 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240718120001.598331BC012E@kernel.dk>
Date: Thu, 18 Jul 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 791f697320637fb39375ce4a80c287afaff8f395:

  t/nvmept_fdp: accommodate devices with many RUHS (2024-07-15 20:12:02 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c63e8658bb776f2d50cde992ad07232a61e6d031:

  Merge branch 'fdp/pid_limit_fix' of https://github.com/ankit-sam/fio (2024-07-17 17:30:14 -0400)

----------------------------------------------------------------
Ankit Kumar (3):
      dataplacement: remove FDP_MAX_RUHS
      dataplacement: change log_info to log_err for error messages
      ioengines: bump up FIO_IOOPS_VERSION

Vincent Fu (1):
      Merge branch 'fdp/pid_limit_fix' of https://github.com/ankit-sam/fio

 dataplacement.c | 27 +++++++++++++--------------
 dataplacement.h |  1 -
 ioengines.h     |  2 +-
 3 files changed, 14 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/dataplacement.c b/dataplacement.c
index ec1427c8..399659be 100644
--- a/dataplacement.c
+++ b/dataplacement.c
@@ -52,7 +52,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 			log_err("fio: stream IDs must be provided for dataplacement=streams\n");
 			return -EINVAL;
 		}
-		ruhs = scalloc(1, sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(*ruhs->plis));
+		ruhs = scalloc(1, sizeof(*ruhs) + FIO_MAX_DP_IDS * sizeof(*ruhs->plis));
 		if (!ruhs)
 			return -ENOMEM;
 
@@ -71,16 +71,16 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	ruhs = calloc(1, sizeof(*ruhs));
 	ret = fdp_ruh_info(td, f, ruhs);
 	if (ret) {
-		log_info("fio: ruh info failed for %s (%d)\n",
-			 f->file_name, -ret);
+		log_err("fio: ruh info failed for %s (%d)\n",
+			f->file_name, -ret);
 		goto out;
 	}
 
 	nr_ruhs = ruhs->nr_ruhs;
 	ruhs = realloc(ruhs, sizeof(*ruhs) + nr_ruhs * sizeof(*ruhs->plis));
 	if (!ruhs) {
-		log_info("fio: ruhs buffer realloc failed for %s\n",
-			 f->file_name);
+		log_err("fio: ruhs buffer realloc failed for %s\n",
+			f->file_name);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -88,21 +88,20 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	ruhs->nr_ruhs = nr_ruhs;
 	ret = fdp_ruh_info(td, f, ruhs);
 	if (ret) {
-		log_info("fio: ruh info failed for %s (%d)\n",
-			 f->file_name, -ret);
+		log_err("fio: ruh info failed for %s (%d)\n",
+			f->file_name, -ret);
 		goto out;
 	}
 
 	if (td->o.dp_nr_ids == 0) {
-		if (ruhs->nr_ruhs > FDP_MAX_RUHS)
-			ruhs->nr_ruhs = FDP_MAX_RUHS;
+		if (ruhs->nr_ruhs > FIO_MAX_DP_IDS)
+			ruhs->nr_ruhs = FIO_MAX_DP_IDS;
 	} else {
-		if (td->o.dp_nr_ids > FDP_MAX_RUHS) {
-			ret = -EINVAL;
-			goto out;
-		}
 		for (i = 0; i < td->o.dp_nr_ids; i++) {
 			if (td->o.dp_ids[i] >= ruhs->nr_ruhs) {
+				log_err("fio: for %s PID index %d must be smaller than %d\n",
+					f->file_name, td->o.dp_ids[i],
+					ruhs->nr_ruhs);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -152,7 +151,7 @@ static int init_ruh_scheme(struct thread_data *td, struct fio_file *f)
 
 	if (!scheme_fp) {
 		log_err("fio: ruh scheme failed to open scheme file %s\n",
-			 td->o.dp_scheme_file);
+			td->o.dp_scheme_file);
 		ret = -errno;
 		goto out;
 	}
diff --git a/dataplacement.h b/dataplacement.h
index 3267a460..84b7be5b 100644
--- a/dataplacement.h
+++ b/dataplacement.h
@@ -5,7 +5,6 @@
 
 #define STREAMS_DIR_DTYPE	1
 #define FDP_DIR_DTYPE		2
-#define FDP_MAX_RUHS		128
 #define FIO_MAX_DP_IDS 		128
 #define DP_MAX_SCHEME_ENTRIES	32
 
diff --git a/ioengines.h b/ioengines.h
index d5b0cafe..6039d41e 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "dataplacement.h"
 
-#define FIO_IOOPS_VERSION	34
+#define FIO_IOOPS_VERSION	35
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
