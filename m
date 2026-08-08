Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F9B3D16FC
	for <fio@vger.kernel.org>; Sat,  8 Aug 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786190414; cv=none; b=gsNftLYo3KrLWkRjG8y9rn/EIN6upkexOZu/DMj18n5z94IewreqedIzaOzXQRPHyqF/sMtN052xlh/0BtWR+3wjjwOwrJbQpRz8W5UkjJ4gAYGTOVuX4JXdjWHinJqHs8J6D/Rvtlt/B07DiS7/W0axzhj3iUeAc7PtJNMkVi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786190414; c=relaxed/simple;
	bh=k2sOAhukMYAzSEntcOtp7bsB0OUw7ITWPtrB5o+MelU=;
	h=Subject:From:To:Date:Message-Id; b=fm6P9h/J7L3Eto3l/z2oc1GAMt5vCe4lHUCw435rsiMrbcX2g9DBkve9mcqOAhxnKx9b9TdT9Pt6xuEG37RQLpbHyo7VXwdAedJl3XXWsK53zO8gJdf3ErZeZhNoijWE9P6IYCxzw45VlhL2TJzrop+aIBkzGLIOUe6zdpwpBmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=THIPWUFP; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="THIPWUFP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=8x4leMkRSE9rV97k8LJxNjnb2GCPlI791vDpbQ0krFY=; b=THIPWUFPwpvtx1AlIsmNFslWI+
	Nai1QzsvBolTa6JL7g6fd2y0DxvXQN6Js+go+U0SY8r1jDToVAW9dqjm8vWGsRqG2iCL8a41F6aTG
	gZOJibwTjfVYOSDHalGtnR5hc3GaJW3IrQ+2ZCxp13M4TdMkMgX8ooNKu9NhzxUhacCPxAEAKmfGb
	9nJ+WBS1f4/jbvHbLVxlcaUBk7437W94qqGhgPUrdPLjPrrFY4O1N8sJuKSOMJLt4qd4dUfm9cPs8
	LwdgywjUtvHEidxvyof3rj90sJPlCOYw6RROOtpBV7y6Hs3jA5XjhzoUlx7n7k92pnklGaPPokSVM
	cz+K3+/Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wsfig-0000000Cv6Y-0JHE
	for fio@vger.kernel.org;
	Sat, 08 Aug 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id BAD341BC0178; Sat,  8 Aug 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat,  8 Aug 2026 06:00:01 -0600
Message-Id: <20260808120001.BAD341BC0178@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit c76c61b0fbe1b90a7886b8790805cf9903285074:

  ci: add a test for OOM issue with large iolog trims (2026-07-27 12:19:07 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1de4a3dc5d10a0107b51c496dc96a07f58bdc5c9:

  Merge branch 'add_copyright' of https://github.com/ljw8161/fio (2026-08-07 11:09:43 -0400)

----------------------------------------------------------------
Jungwon Lee (1):
      engines/io_uring: add copyright header to bsg files

Vincent Fu (1):
      Merge branch 'add_copyright' of https://github.com/ljw8161/fio

 engines/bsg.c | 6 ++++++
 engines/bsg.h | 5 +++++
 2 files changed, 11 insertions(+)

---

Diff of recent changes:

diff --git a/engines/bsg.c b/engines/bsg.c
index 372212ef..916dc242 100644
--- a/engines/bsg.c
+++ b/engines/bsg.c
@@ -1,3 +1,9 @@
+/*
+ * Copyright 2026 Samsung Electronics Co., Ltd All Rights Reserved
+ *
+ * For conditions of distribution and use, see the accompanying COPYING file.
+ *
+ */
 #include "bsg.h"
 
 int fio_bsg_uring_cmd_read_capacity(struct thread_data *td, unsigned int *bs,
diff --git a/engines/bsg.h b/engines/bsg.h
index 6a4bfd07..da64b999 100644
--- a/engines/bsg.h
+++ b/engines/bsg.h
@@ -1,6 +1,11 @@
 /*
  * bsg structure declarations and helper functions for the
  * io_uring_cmd engine.
+ *
+ * Copyright 2026 Samsung Electronics Co., Ltd All Rights Reserved
+ *
+ * For conditions of distribution and use, see the accompanying COPYING file.
+ *
  */
 
 #ifndef FIO_BSG_H
