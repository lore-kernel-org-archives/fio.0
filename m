Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C362D208C5
	for <fio@vger.kernel.org>; Wed, 28 Feb 2024 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709125222; cv=none; b=dYaDnFkxMqEJlwfJT3TPVR5Mfvi+cTGActG5f69C8nd9nS3WAyjRljoYZzeyC8R9Um6Rf+SCKZbngzslgLucRAc05u2idCb4weQwrBWGw/5dGW1z5fAmJL1QF8Dp6IUOfYGev3IUNC7s8iAsqT+Vz+aAS0+QnrMPTuklwCvCRqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709125222; c=relaxed/simple;
	bh=ibYnyfdXFFmNdjl0TyqJYfz9ttPuGSkz7JKRpqsxUs0=;
	h=Subject:From:To:Message-Id:Date; b=fLkvDvBJXeGHU0Lo5k7X6WbUppA+MZ3CPlZ0TFUBSzT3XY8UgkUWUObn0lo9DHvsiA8+Z+QNYzW5/lkTB/BK8o74s0gLDEXNnMMQXoxNkqLjAK0qJxzFXPDPgKbZL8SP7pBw4X4jLf8iRzPwOi4ZC4u+wFMDgdx9GCOqxmG8Tdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TUpaymV7; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TUpaymV7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=FFtMOfTEPYDbnbeeksajPD9PBe5oD32hX4FeLwxAfsQ=; b=TUpaymV7Bj6al9Y05OKJA8uy3M
	sZ5N8gPzcXF911afLQRQGSzftQL7EtaJSKlipcYXaMNtjvST2XJzMPCbPwlzPIwfF67VCl7j+eUT4
	acg/gk0zO9l7wofyZb47q0fBMDYgD2lrXVe7zuxSyiHwwATlGNdj2HbHa6J1v/Oq27aUFGDSzxOZQ
	jc5MoYW1fb4bKHcz1w/F70sL7UpKHWpHNdgUhFrBOrRYqk+OyahJrU2MZ4/h0NNTc+RUpxiD5z2K6
	/15WZWp1lxlkF+Krwb/XmnYE51e0v/inWYvwxS7dYQ8uQUB7zs+dLaXEbG/juEjLUhmLS/c7tIq6u
	SYQKXr8g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfJXg-00000005F32-2DCd
	for fio@vger.kernel.org;
	Wed, 28 Feb 2024 13:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 1DC6F1BC0190; Wed, 28 Feb 2024 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240228130002.1DC6F1BC0190@kernel.dk>
Date: Wed, 28 Feb 2024 06:00:02 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9af4af7ab40c4e505033d0e077cc42ac84996b09:

  ci: fix macOS sphinx install issues (2024-02-22 20:01:27 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5ae4f4220a48dddddc84c8b839ef9d8a1ed4edb1:

  gettime: fix cpuclock-test on AMD platforms (2024-02-27 12:36:45 -0500)

----------------------------------------------------------------
Vincent Fu (2):
      howto: fix job_start_clock_id formatting
      gettime: fix cpuclock-test on AMD platforms

 HOWTO.rst          | 5 +++--
 arch/arch-x86_64.h | 5 +++++
 arch/arch.h        | 7 +++++++
 gettime.c          | 2 +-
 4 files changed, 16 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 4b02100c..169cdc2a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -756,8 +756,9 @@ Time related parameters
 	CPU mask of other jobs.
 
 .. option:: job_start_clock_id=int
-   The clock_id passed to the call to `clock_gettime` used to record job_start
-   in the `json` output format. Default is 0, or CLOCK_REALTIME.
+
+        The clock_id passed to the call to `clock_gettime` used to record
+        job_start in the `json` output format. Default is 0, or CLOCK_REALTIME.
 
 
 Target file/device
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 86ce1b7e..b402dc6d 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -26,6 +26,11 @@ static inline unsigned long arch_ffz(unsigned long bitmask)
 	return bitmask;
 }
 
+static inline void tsc_barrier(void)
+{
+	__asm__ __volatile__("mfence":::"memory");
+}
+
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned int lo, hi;
diff --git a/arch/arch.h b/arch/arch.h
index 3ee9b053..7e294ddf 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -108,6 +108,13 @@ extern unsigned long arch_flags;
 #include "arch-generic.h"
 #endif
 
+#if !defined(__x86_64__) && defined(CONFIG_SYNC_SYNC)
+static inline void tsc_barrier(void)
+{
+	__sync_synchronize();
+}
+#endif
+
 #include "../lib/ffz.h"
 /* IWYU pragma: end_exports */
 
diff --git a/gettime.c b/gettime.c
index bc66a3ac..5ca31206 100644
--- a/gettime.c
+++ b/gettime.c
@@ -623,7 +623,7 @@ static void *clock_thread_fn(void *data)
 			seq = *t->seq;
 			if (seq == UINT_MAX)
 				break;
-			__sync_synchronize();
+			tsc_barrier();
 			tsc = get_cpu_clock();
 		} while (seq != atomic32_compare_and_swap(t->seq, seq, seq + 1));
 
