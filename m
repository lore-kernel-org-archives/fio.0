Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8C730100B
	for <fio@vger.kernel.org>; Wed, 27 Aug 2025 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756296009; cv=none; b=ovZJfK3EXwV8AhKpk9h3Q7aLcE0joo9ZV2KL8C09jFWw+aZn0QBAmGufqJplc6SpR5XRrjeOz7dK6ceZD9KrOmjYSVWh7kA700c8pn9ATrD8IyA3xQ2BWy/nnWGSgx29J6srR3v9VsO267AvwiF8tLAAFOGqzm4y0vWkoYN8pck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756296009; c=relaxed/simple;
	bh=EVUOJT0WMswjCvW5D/75ChRfoAwPnKYqNfB9Tn4/yqY=;
	h=Subject:From:To:Message-Id:Date; b=mAOg6PHI2607wiw89I2cuRUGKK4mPX9DZSs3PY06nQvDwsm/yFHX0UAJxtviP57599A1lAA/4qh4KdpAZFFICcdZOJODWEeUyG2MR3faWj4f+bE6cWMSVDpe2+lAVw4O8w6VDxKjQaRpyW+xpsIJj2d3Hhs7yy89nnMIdrQxaAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dLjkKVUd; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dLjkKVUd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=VxJwVcnknrB1qQnWXflq448vscPrCLozipCdRt/Dh2c=; b=dLjkKVUdDjRVa3vamRCxfpo1Vc
	5s1dgP/fCeE5+yrzHMqnMVM+G39UsS8HIlwEk77U9x9as6yu13QBp6KujSjZKxWyPt/vib0/vlAw7
	Tq6BDOj1lLsmHqAZ/tU+8N/aZ4potv9NBk0AhrBJCpFt23w+aaRqj3toYcNllDmv2GIG2/tnPC/dP
	d+Vg1evSi0AErDlzjYF1C6DLGK900ZO6nsr8g8gIeTXEUxny06P5NdDfMYczrJJL7/8upCc4ZdGHV
	tdz7RtQgLpLNwR75oOj99oV/1acip2Oh1oZCF+A7jwfJX7aQpWS3851aSg2FHzrvUL8SeKCqlRgjk
	CACdPTMA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1urEot-00000004UWM-1X0Y
	for fio@vger.kernel.org;
	Wed, 27 Aug 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 82A821BC016C; Wed, 27 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250827120001.82A821BC016C@kernel.dk>
Date: Wed, 27 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2a85ed69d8ef0525b50691aede23f1e10d264634:

  Merge branch 'fix_mandoc_warnings' of https://github.com/sitsofe/fio (2025-08-25 09:51:36 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d6acda3d2e3992dbbb51e6ce2ba5d69e5ef85570:

  Merge branch 'patch-1' of https://github.com/neheb/fio (2025-08-26 19:56:42 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/neheb/fio

Rosen Penev (1):
      fio: fix formats under MIPS64/PPC

 arch/arch-mips.h | 4 ++++
 arch/arch-ppc.h  | 4 ++++
 2 files changed, 8 insertions(+)

---

Diff of recent changes:

diff --git a/arch/arch-mips.h b/arch/arch-mips.h
index 6f157fbb..8a0e9370 100644
--- a/arch/arch-mips.h
+++ b/arch/arch-mips.h
@@ -3,6 +3,10 @@
 
 #define FIO_ARCH	(arch_mips)
 
+#ifndef __SANE_USERSPACE_TYPES__
+#define __SANE_USERSPACE_TYPES__
+#endif
+
 #define read_barrier()		__asm__ __volatile__("": : :"memory")
 #define write_barrier()		__asm__ __volatile__("": : :"memory")
 #define nop			__asm__ __volatile__("": : :"memory")
diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 804d596a..7f3503b6 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -8,6 +8,10 @@
 
 #define FIO_ARCH	(arch_ppc)
 
+#ifndef __SANE_USERSPACE_TYPES__
+#define __SANE_USERSPACE_TYPES__
+#endif
+
 #define nop	do { } while (0)
 
 #ifdef __powerpc64__
