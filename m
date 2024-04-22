Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16350152197
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808547; cv=none; b=oFztt/w9ehW63wmlCDwfG5FexHou1CTfAHt739CR6TfkfDnlmgfkfkoHT6X/SlISQUZr+6myXzBBl2ksvIFN1dXI3JOAjXYRsU+daTNVrmx/TeCWdXVOZPsHUwgx1RzgqMcAN8GoRUQJsfEb8p0pmPdci/D2qDXxJ+wU/8uQGTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808547; c=relaxed/simple;
	bh=1FWCXaQTkz40K42dEqE08SO2Wyp8d8024UCUGMaNhek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huij/gAET28uVan8jRTxY2CkoCsOa9Jy9F+U6eBmhNEZuxQP9NUSVi+FIFkixawvD3BAsqSYMylQh35kdIKI7YGg3uMDAV4Bw2su3CJOfUM8wzXkaAPgZzytM8klgDFp18TkTa3KsYsZ6XPup7Mh02TFeCBL21xO4bJZdDKS/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kEHlpris; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kEHlpris"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6181d032bf9so44515567b3.3
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808545; x=1714413345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPpE7pcc2hDWEteqbKaSQUffdlXH92ju86RHGd7NI4Q=;
        b=kEHlprisBhr5C11pirswOinCdyBCSe1iqxKdwRDKfIX2A9s7z4MNp2DJ9WrlGeyuSI
         RILPTOjS4GzrjGOeAU1810ABUdfChFAdFGB7Tv1H+g87ccRMAa6Sc8RaJtB9hSvmu9mw
         DVVcK3oq9xPkGqCc5QdPhUTkzR6OxklmAxKxA7jv9GS7uhpnTEyWz/yzqavpSeIc5OwQ
         GPNR79W379RDsahPD/r1xmbkOLprMCAGv7/RILDkztMlEwO/cMZkxxxPcbM2FzUE81jS
         zaySfrTTn/DjYiCV7FmwsXsLSlIZRUjkADh6mf3KzN1OCZy3MI7LJ452WBPDOPGIAOQA
         Ka9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808545; x=1714413345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPpE7pcc2hDWEteqbKaSQUffdlXH92ju86RHGd7NI4Q=;
        b=Kl9SJ3Tb4u4Ft+IKgVTI53giFpOTVf2l2iedhAhg7RqPt9tYBLamr82irvzKBKcd1I
         eec7UYr1V6Hjz1hYQC9Z8aWHGV8BZO5vOcwqc+BrVvNvSHhcB7cdscBKXZvYiTpqloa+
         io/1N6qHjldt1nsyZRFMdUDpdFWJwYLmas882FNTYPvFgsfSC8jxZZgHQAo37cjshNID
         LP+BtNpK/2FLm8dGGkQk0z986mnQoGEPHx2VrTyNXsW1KDZmATqdNX96hy/U8qpbMw4C
         PNs7Pdij7Co+/9ASrDuKL9L98lZ+TOfTQnBETcUPWfAIrMNvSnFdZz8ihG2ow8u/acfS
         KymA==
X-Forwarded-Encrypted: i=1; AJvYcCU+9XYcd9PkBZO4efsEbBVXk9QnNBLm68/ajhZOayWgyoceMEsnb3IHRqRuPn1naLohDkOd8yTUgrpZth1YNmMDS7Dy
X-Gm-Message-State: AOJu0YxbT519/nTjp/dWoxGtz1lt9oJtCGCH8O7Lrq3RO0J7AOW5iqej
	RJfJxqQQunzM1ntn49U714HRkJKEETT0Ra73rOyXZnDpkdnB1VYQ
X-Google-Smtp-Source: AGHT+IG/gqqGmqqOw5X51IDBLjf6QZdNVbR6Y8bsTL/Qp9HYsnKpAYMHIqryNTp/KA5wXYGrjiUH/Q==
X-Received: by 2002:a25:86c9:0:b0:dd1:55b6:e671 with SMTP id y9-20020a2586c9000000b00dd155b6e671mr9864174ybm.21.1713808544865;
        Mon, 22 Apr 2024 10:55:44 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:43 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/9] fio: rename fdp.[c,h] to dataplacement.[c,h]
Date: Mon, 22 Apr 2024 13:49:47 -0400
Message-ID: <20240422175522.4614-2-vincent.fu@samsung.com>
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

We can use code in the files to support NVMe streams.  Streams also
falls under the umbrella of data placement, so it seems reasonable to
put streams and FDP code in the same source files.

Also change the prefix of some functions from fdp_ to dp_ to indicate
that they are not specific to FDP but apply more generally to the two
data placement features.

No functional change.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 Makefile                 |  2 +-
 fdp.c => dataplacement.c |  6 +++---
 fdp.h => dataplacement.h | 10 +++++-----
 engines/xnvme.c          |  2 +-
 filesetup.c              |  2 +-
 io_u.c                   |  2 +-
 ioengines.h              |  2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)
 rename fdp.c => dataplacement.c (95%)
 rename fdp.h => dataplacement.h (65%)

diff --git a/Makefile b/Makefile
index cc8164b2..be57e296 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c zone-dist.c zbd.c dedupe.c fdp.c
+		steadystate.c zone-dist.c zbd.c dedupe.c dataplacement.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/fdp.c b/dataplacement.c
similarity index 95%
rename from fdp.c
rename to dataplacement.c
index 49c80d2c..7518d193 100644
--- a/fdp.c
+++ b/dataplacement.c
@@ -13,7 +13,7 @@
 #include "file.h"
 
 #include "pshared.h"
-#include "fdp.h"
+#include "dataplacement.h"
 
 static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
 			struct fio_ruhs_info *ruhs)
@@ -86,7 +86,7 @@ out:
 	return ret;
 }
 
-int fdp_init(struct thread_data *td)
+int dp_init(struct thread_data *td)
 {
 	struct fio_file *f;
 	int i, ret = 0;
@@ -107,7 +107,7 @@ void fdp_free_ruhs_info(struct fio_file *f)
 	f->ruhs_info = NULL;
 }
 
-void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
+void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_ruhs_info *ruhs = f->ruhs_info;
diff --git a/fdp.h b/dataplacement.h
similarity index 65%
rename from fdp.h
rename to dataplacement.h
index accbac38..72bd4c08 100644
--- a/fdp.h
+++ b/dataplacement.h
@@ -1,5 +1,5 @@
-#ifndef FIO_FDP_H
-#define FIO_FDP_H
+#ifndef FIO_DATAPLACEMENT_H
+#define FIO_DATAPLACEMENT_H
 
 #include "io_u.h"
 
@@ -22,8 +22,8 @@ struct fio_ruhs_info {
 	uint16_t plis[];
 };
 
-int fdp_init(struct thread_data *td);
+int dp_init(struct thread_data *td);
 void fdp_free_ruhs_info(struct fio_file *f);
-void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u);
+void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u);
 
-#endif /* FIO_FDP_H */
+#endif /* FIO_DATAPLACEMENT_H */
diff --git a/engines/xnvme.c b/engines/xnvme.c
index a8137286..6ba4aa46 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -13,7 +13,7 @@
 #include "fio.h"
 #include "verify.h"
 #include "zbd_types.h"
-#include "fdp.h"
+#include "dataplacement.h"
 #include "optgroup.h"
 
 static pthread_mutex_t g_serialize = PTHREAD_MUTEX_INITIALIZER;
diff --git a/filesetup.c b/filesetup.c
index 2d277a64..8923f2b3 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1412,7 +1412,7 @@ done:
 	td_restore_runstate(td, old_state);
 
 	if (td->o.fdp) {
-		err = fdp_init(td);
+		err = dp_init(td);
 		if (err)
 			goto err_out;
 	}
diff --git a/io_u.c b/io_u.c
index 83895893..735d9005 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1066,7 +1066,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (td->o.fdp)
-		fdp_fill_dspec_data(td, io_u);
+		dp_fill_dspec_data(td, io_u);
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
 		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
diff --git a/ioengines.h b/ioengines.h
index 4fe9bb98..d5b0cafe 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -7,7 +7,7 @@
 #include "flist.h"
 #include "io_u.h"
 #include "zbd_types.h"
-#include "fdp.h"
+#include "dataplacement.h"
 
 #define FIO_IOOPS_VERSION	34
 
-- 
2.43.0

