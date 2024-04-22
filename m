Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856C9152197
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808550; cv=none; b=i0PUCvIpkvy6f8yihzlLqE+3Y6Aj7eCtGJXskILqTPik1iAd1fUKbl9vamd76eiy05k92WUklPAR2dSRDEb/2ULHGdRuJWFO4lHRUbhNWhMctweHdh7M5eNZpaJF6D/aTC7Poh/3dA1ebVzmzG8dBwKrJlWlZHqOV6llma/O5Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808550; c=relaxed/simple;
	bh=Xsfc9fZwy/3754mnn2aXc4hcyk/bImpAMfMBl9Dmq9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfgePVbqQJe7jpgXaEb5U9/0qmoNTwzHr+t/F9R2Tjt/9JZASLINohSiExZVQNs8HFhrF5/kPh1yifwCsfnvDKuNu82loqzxd1Pq4RUosAwvuGEls8+s0DUG5tco/qfoyRwlNKxPGR+Kfw9xP9WxmYZSTeBxtOqqIwzsQ6ekTXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6iEYBuC; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6iEYBuC"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-de45dba157cso3802146276.3
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808547; x=1714413347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlvP9UlbH+jSOKn5vp+hhz7y1wb6qzcTVnJKmqJ3JKc=;
        b=m6iEYBuCkIoeVcPl/06YG9ZT0TpWbD8SAhblEmf/8m3wBhwMo0qGqiibc65rYx1tWz
         tqsuF/sCmBGdi6VfMiRxx+uRrtTbpTJ+8z1fnAJ7w4qSzgzH2CaaZEkQ2AQjCaGCJNg5
         cPWsfLMpzICFqEZszNo4yrrpG+Dn9k09vDGHR8CY2v3vt7IimLbiCUhwhUcmXZrNbIZa
         XQph4rVgzCFrEdzQ9zr/v/DltU3HN+tQKR7RqTfujjmvf7z37SigHSCVpXlp1jg1kHx0
         8Rwd2gppY2SYw0vqEMOUd/QtK814HLMiKMmzIyeNtklg9mGZfesGHEeeh9lyNBO8QcYV
         fxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808547; x=1714413347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlvP9UlbH+jSOKn5vp+hhz7y1wb6qzcTVnJKmqJ3JKc=;
        b=hMGtg9rg1oY+lGf5O5bdB/D7cEkwZwsTIwBLGYzGyNoBSIRZlmbzv7HerV7LsXNsMG
         oCSKOy+bypf4SexKaqTBurm38POAnP9dvLpdvXlBAFufkHfHP4RVLQQitesyp55Twqv/
         r79UoZFQV4rqwRED5hvgM5YOAgnzw0kWJaW1fp9YDiiMFFnRUy3bkVoSuCy6kHEhuXFu
         Ara6IMiAaDdBGqAnSRvxL4jLyU3RtMbVYbmT+OTIzNErbf70V8yt6bLWTCyGd4Fy2w8O
         gqkofPED2RZEWS6x4pzkhIBhGcPgw/YI162B5nHvljJzekBxf9YL2jqwcip+EaDVWTkG
         /ksw==
X-Forwarded-Encrypted: i=1; AJvYcCU0oiH0DJdb33dhjxrhdPHuJZdTIhjVFcTEi2YFN86dz/cDHj0a0FZOCV61SOk80iHvcCoPUq/rM61rtT3uh4+er1hl
X-Gm-Message-State: AOJu0YyLi35Q0XTsTHVAiHvC+NPayoqCl+7a3MJ3ebVh9PKgfNfnpyrB
	hE8ROEdLJTrdCV6gl+yeivCb7eqqeSnpRnyqrza+5a5U35l2gzJ9
X-Google-Smtp-Source: AGHT+IEUc5l4A8ywPx/8I+J0n/JxOggn972UARhBmViGF/b+dzQANdal8XVPyt7aBuFIKhtsaVYK1A==
X-Received: by 2002:a5b:70d:0:b0:dc7:45c6:f8bc with SMTP id g13-20020a5b070d000000b00dc745c6f8bcmr10520607ybq.4.1713808547120;
        Mon, 22 Apr 2024 10:55:47 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:46 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 4/9] fio: support NVMe streams
Date: Mon, 22 Apr 2024 13:49:50 -0400
Message-ID: <20240422175522.4614-5-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240422175522.4614-1-vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make small adjustments to the code supporting FDP to accommodate NVMe
streams.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 dataplacement.c | 16 +++++++++++++++-
 dataplacement.h |  7 ++++---
 filesetup.c     |  2 +-
 io_u.c          |  2 +-
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/dataplacement.c b/dataplacement.c
index a7170863..a409b825 100644
--- a/dataplacement.c
+++ b/dataplacement.c
@@ -49,6 +49,20 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	if (!ruhs)
 		return -ENOMEM;
 
+	/* set up the data structure used for FDP to work with the supplied stream IDs */
+	if (td->o.dp_type == FIO_DP_STREAMS) {
+		if (!td->o.dp_nr_ids) {
+			log_err("fio: stream IDs must be provided for dataplacement=streams\n");
+			return -EINVAL;
+		}
+		ruhs->nr_ruhs = td->o.dp_nr_ids;
+		for (int i = 0; i < ruhs->nr_ruhs; i++)
+			ruhs->plis[i] = td->o.dp_ids[i];
+
+		f->ruhs_info = ruhs;
+		return 0;
+	}
+
 	ret = fdp_ruh_info(td, f, ruhs);
 	if (ret) {
 		log_info("fio: ruh info failed for %s (%d)\n",
@@ -129,6 +143,6 @@ void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		dspec = ruhs->plis[ruhs->pli_loc];
 	}
 
-	io_u->dtype = FDP_DIR_DTYPE;
+	io_u->dtype = td->o.dp_type == FIO_DP_FDP ? FDP_DIR_DTYPE : STREAMS_DIR_DTYPE;
 	io_u->dspec = dspec;
 }
diff --git a/dataplacement.h b/dataplacement.h
index b6ceb5bc..b5718c86 100644
--- a/dataplacement.h
+++ b/dataplacement.h
@@ -3,9 +3,10 @@
 
 #include "io_u.h"
 
-#define FDP_DIR_DTYPE	2
-#define FDP_MAX_RUHS	128
-#define FIO_MAX_DP_IDS 	16
+#define STREAMS_DIR_DTYPE	1
+#define FDP_DIR_DTYPE		2
+#define FDP_MAX_RUHS		128
+#define FIO_MAX_DP_IDS 		16
 
 /*
  * How fio chooses what placement identifier to use next. Choice of
diff --git a/filesetup.c b/filesetup.c
index 6fbfced5..cb42a852 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1411,7 +1411,7 @@ done:
 
 	td_restore_runstate(td, old_state);
 
-	if (td->o.dp_type == FIO_DP_FDP) {
+	if (td->o.dp_type != FIO_DP_NONE) {
 		err = dp_init(td);
 		if (err)
 			goto err_out;
diff --git a/io_u.c b/io_u.c
index e9b94c48..1f4d7af5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1065,7 +1065,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		}
 	}
 
-	if (td->o.dp_type == FIO_DP_FDP)
+	if (td->o.dp_type != FIO_DP_NONE)
 		dp_fill_dspec_data(td, io_u);
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
-- 
2.43.0

