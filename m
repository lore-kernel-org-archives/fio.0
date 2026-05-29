Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6CA3DC873
	for <fio@vger.kernel.org>; Fri, 29 May 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780056010; cv=none; b=PyihhBZ27BAz9GsfXMElFFCiun2iHRMcinJVtM3PrmgJgfRY+W8xT2uVF4InxJ7LqWpc7HYSXgixYF9AVCvt8vmNj0kvjcTGdS05G3S2LhC8ALNOs+8MaGogdAhkANTHIMLL+l0RT6UPLgkuO9bFn++zKOqeEq5wS0ZII/pj/Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780056010; c=relaxed/simple;
	bh=lYR7O5qkuKkrBhyBl5Ow6266NmOg35wNyQLscrnISe0=;
	h=Subject:From:To:Date:Message-Id; b=iGjDCgVwFkLlGfyNjkVE4HTwLOtczThyOLO78WtA0OL89IJWEOpQhj5LwpP1KODgCbRUnFkZK4lvJ0YbLD5dvXD24OOrXUEU1/9DyQAnQCjNGLQq1GFqE+o+nKI7SWZqcxmQG+B7RiDcO4a5li/fqFpQS9CqbfAgx6+149RSnH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AzhLIzxE; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AzhLIzxE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hTUV8rkt4IAS9J8MVpkZzNDvgxwRIX1VSYJNFwiqhqk=; b=AzhLIzxEBhxUN/tkLz0K23PUsp
	MTtCugxt7+PXW9ecXwIdLUakY4s3+g9s9u+GLw4+QC6exqRu16umaQkwOCcqhQikgv3yDDE/aasYQ
	CbGwAfYJ3jfes4MJ3f2Il1DMLyIDDxkqBU38XUuybMdZ3kpqko38kEzxj9riC4o1TgPrhIJDeCSNF
	GGbfITZIe1VRGQS9WdKIwtMZ3KHOP327Zy6PnEJimmRcNKELA1zVGWLXykkEvSOqS4S/e2lopUezi
	JFtMWZZHvN5Bq2zvBRSYqr96QudnYdKidsqjuE6nndITQZhUoPLzaHe2h6HZGkh78jB6JZEnp/F2p
	qHCU+Dug==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSvsi-00000001E0B-194x
	for fio@vger.kernel.org;
	Fri, 29 May 2026 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3B07E1BC00FD; Fri, 29 May 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 29 May 2026 06:00:01 -0600
Message-Id: <20260529120001.3B07E1BC00FD@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d569883e281076e0dec5f5768b828ef44392a11a:

  Merge branch 'skip-errored-offset' of https://github.com/minwooim/fio (2026-05-20 09:17:25 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a66cccb6cb2b321e107b97733faac4db4d95ebc:

  Merge branch 'fix-musl-prctl-conflict' of https://github.com/lucashecht/fio (2026-05-28 10:30:47 -0400)

----------------------------------------------------------------
Lucas Hecht (1):
      backend: remove linux/prctl.h include to fix musl conflict

Vincent Fu (1):
      Merge branch 'fix-musl-prctl-conflict' of https://github.com/lucashecht/fio

 backend.c | 1 -
 1 file changed, 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index f6023d0e..e2b33b14 100644
--- a/backend.c
+++ b/backend.c
@@ -32,7 +32,6 @@
 #include <pthread.h>
 
 #ifdef CONFIG_LINUX
-#include <linux/prctl.h>
 #include <sys/prctl.h>
 #endif
 
