Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A62B537F5
	for <fio@vger.kernel.org>; Sat, 27 Jul 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722081612; cv=none; b=SjzHnXfAKy6v8unQjhkcMI0d6TL/EhQqNNgpLydqdRthBV2ZSuVxPj6/H6ZSvSLqDAqAPigGXrhw4giDMqC17lZ8dyLUUFcm4aNwMW4M6LQ+ktCvluqYcU8vHJ4EqvmSSur2t4RHCH1T402YVPFTuGHrqiqOCb7JwiKp/nimRg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722081612; c=relaxed/simple;
	bh=EQe7f5d3p0ntElqMQsho4SYmcdYbI2YNS7rgyZxYsg8=;
	h=Subject:From:To:Message-Id:Date; b=qPrtWTIZZ+foUNn2rQvClh4kPt94rrLTftFbMxfZGeH30/hIGFg5K4bERzX1nCq1vUhNrpxlyJxzCpKzPtEC0vd6xdZIuBzgO8qiwxetxVhcSE7FEY0Yq0No4p938w3tcC0z3glBMgxWywHyqQJA7x2e7TDh60SI3OJCVD4KF24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k8wMs5Er; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k8wMs5Er"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fNw+5oQEKDKCOnbMzi6nkkh0yNxwJvCQmgfraBL+MW8=; b=k8wMs5Ert9SfA0E5+fBlOq4BhN
	ir2UJMJOZATZ3zJsXR/zbf31wVgR64WtYVJuzY+gAeqEXsoZ/9IQhRRQZAtCsPsB7Pp/YeeFDZJtM
	frMllq/zVTttZeZr2ZCdQpwHQujPki5WdAcuBkirF8VG2/oUPp1Rq2fQa1+nFnOaWvqfGqUkV6we3
	f1mPpPs6IzCSTHAqOLDIyrrmvzNBkfV4ORrsBdUFZM5ywC5DDxKSJEiBGYKQ7FCm+q+uxa9xOPx7s
	0dffqBF0TPwzFn697aLK/CuGMOGc1c2RXFwhie9AxRs9Fiw/3hfamfSdtxhHhAbo9SzCrizkMnGoy
	JTh+/J0w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sXg5l-0000000BItF-3i3Z
	for fio@vger.kernel.org;
	Sat, 27 Jul 2024 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 8DAD71BC0139; Sat, 27 Jul 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240727120001.8DAD71BC0139@kernel.dk>
Date: Sat, 27 Jul 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit c63e8658bb776f2d50cde992ad07232a61e6d031:

  Merge branch 'fdp/pid_limit_fix' of https://github.com/ankit-sam/fio (2024-07-17 17:30:14 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 40176e3206288e36f01baea86b15d7ff450c3e00:

  Merge branch 'qnx-phys-mem' of https://github.com/mvf/fio (2024-07-26 07:56:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'qnx-phys-mem' of https://github.com/mvf/fio

Matthias von Faber (1):
      QNX: Fix physical memory detection

 os/os-qnx.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/os/os-qnx.h b/os/os-qnx.h
index 447c9957..8ae9695e 100755
--- a/os/os-qnx.h
+++ b/os/os-qnx.h
@@ -9,7 +9,7 @@
 #include <sys/statvfs.h>
 #include <sys/ioctl.h>
 #include <sys/utsname.h>
-#include <sys/sysctl.h>
+#include <sys/syspage.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/dcmd_cam.h>
@@ -71,11 +71,17 @@ static inline int blockdev_invalidate_cache(struct fio_file *f)
 
 static inline unsigned long long os_phys_mem(void)
 {
-	int mib[2] = { CTL_HW, HW_PHYSMEM64 };
-	uint64_t mem;
-	size_t len = sizeof(mem);
+	uint64_t mem = 0;
+	const char *const strings = SYSPAGE_ENTRY(strings)->data;
+	const struct asinfo_entry *const begin = SYSPAGE_ENTRY(asinfo);
+	const struct asinfo_entry *const end = begin + SYSPAGE_ENTRY_SIZE(asinfo) / SYSPAGE_ELEMENT_SIZE(asinfo);
 
-	sysctl(mib, 2, &mem, &len, NULL, 0);
+	assert(SYSPAGE_ELEMENT_SIZE(asinfo) == sizeof(struct asinfo_entry));
+
+	for (const struct asinfo_entry *e = begin; e < end; ++e) {
+		if (!strcmp(strings + e->name, "ram"))
+			mem += e->end - e->start + 1;
+	}
 	return mem;
 }
 
