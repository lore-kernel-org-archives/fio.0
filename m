Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC93E2C0279
	for <fio@vger.kernel.org>; Thu,  9 Oct 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011213; cv=none; b=ZlT8ndZDE9QMAL3nnoXclXFBsLpkkmApPGxrIlfjxqO/hqbasEIQi4z0ja049aI5M154xk2G9lS6fsoGZeDlz864Lh+lG+ewNhgZrhNf11a6CM2K15hj727wWqC4mYymP2yxIuc1Whvhec3s7hpxA+kuRaMFDkv6sZxNYMdwUlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011213; c=relaxed/simple;
	bh=Uf5ySB0jcs+b/6I4DQMonL+Anwt0jOzIeGvXKPfO7XQ=;
	h=Subject:From:To:Date:Message-Id; b=t4jfuQHj8m5PS2idIdmHGrTc3Xsc0Mzh0Rou9HHJANRCvT5QAviDSTDeu0TSv2QQdsXWYnniWpgqvRXhjQSrh3/FYMkgj2tqcP9tw3izyg/oepbEBKHSu/JRfFs7Jx271wcg3bP/+Tby7nx80l5YMmsiTq2NolrFteuJfpxl4J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fdjs1YQc; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fdjs1YQc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aOcq9tW94l9ui5IFErf/rVzEH52yB0uujO0NFW9SR08=; b=Fdjs1YQcO/KVlH7oVAFMpFRlDR
	sl+lbUzGp1j+wUa66AjqvoORW+W9PFlZ5Xgsg0CrHHnTh+UGip7yGVFHy3Jzy4IzZND1dWCvy/8Kb
	/UTu5f9kowHBRf2aKQI1PPQUmWSHvCj8U1OSWsGVQmsKMY3hGQzVvmo02DeslIw+UHbXV1iY5met/
	5mZqTrx25byagx+De1rSABuiK/bu5KV19yqnyCC2Pq4SUoQ512HIFH3MGy6oCYtO0bGoBAViBdpsY
	0a+XQxSrblDiNv+krYj+LVdS0VNOGa5sVcmxhX61TcsioGxJLnlWnW3OF2ZxQFBH04Ylo/Q66sXr0
	CVlruVGw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v6pJV-00000001QgV-00Gj
	for fio@vger.kernel.org;
	Thu, 09 Oct 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 327DF1BC0144; Thu,  9 Oct 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu,  9 Oct 2025 06:00:02 -0600
Message-Id: <20251009120002.327DF1BC0144@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 925a31571d2d28c319a20b70d37513463b7fad30:

  Merge branch 'uncached_doc' of https://github.com/Panky-codes/fio (2025-10-05 14:25:54 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ed31254c1bb4e88d1b3812c06212b50dcba795bc:

  Merge branch 'fix-includes' of https://github.com/betonmischer86/fio (2025-10-08 08:15:36 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-includes' of https://github.com/betonmischer86/fio

Valeriy Kosikhin (1):
      test, memcpy: reorder #includes

 crc/test.c   | 2 +-
 lib/memcpy.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/crc/test.c b/crc/test.c
index b57f07a4..8102297e 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -3,10 +3,10 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include "../os/os.h"
 #include "../gettime.h"
 #include "../fio_time.h"
 #include "../lib/rand.h"
-#include "../os/os.h"
 
 #include "../crc/md5.h"
 #include "../crc/crc64.h"
diff --git a/lib/memcpy.c b/lib/memcpy.c
index a5521343..61eb63b5 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -5,9 +5,9 @@
 
 #include "memcpy.h"
 #include "rand.h"
+#include "../os/os.h"
 #include "../fio_time.h"
 #include "../gettime.h"
-#include "../os/os.h"
 
 #define BUF_SIZE	32 * 1024 * 1024ULL
 
