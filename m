Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6094F49365C
	for <fio@vger.kernel.org>; Thu,  1 Oct 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856015; cv=none; b=nCfw5iAkTLq84te2SGy6j2Bu1euoImnE2qvAKbYC1NRbwFHuFI7DQA0D+2/im96eD2hO2GSQqyvUHz70ZHDNKT+V5+zfez2+GmPlAgWcddOu8fLnAPCt+FL7No0yR+v4qvfB9TSVMa2pjdKtookriPF4ta+3wWo0wpKRHMxFvm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856015; c=relaxed/simple;
	bh=UafXZ51QEGdAm5miFfAEu3H1AoorH+WqPcbVb96QUIs=;
	h=Subject:From:To:Date:Message-Id; b=E1jHM+uI5cO+ubYZW5Y9gH1JXnxAkqSb1nylQ+/f5vGbqH9UetJ3K+CMb/aOkrhXARnxUlyqUiUk57Bx/3vwSSI6hHrYYrwKlAvZjI3WjVyYEmL/ptCqO1BBPuMsIe9zNel4qgyKPT45TmQeDPtQ3vb5Dv2sNzBDO3MNGp4kRQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OJL7Safb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OJL7Safb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=oPnBiUNJv782k0KB1vK67xSHk2ZhdSsudn06XuFf9Ac=; b=OJL7Safbl9hX9NZ+sc/9ZBbVyh
	yGRrwr3NHJ9ootHNfe0fvXKD6J5kMnbsDZCRw3jYQbZ1rY00GYK+y1h/BRfcIRaShaJIwfCFwminn
	HnEtaMZxipSJkPhN7NYzYZ1b5mNTw+0E5gZBcVx3swrve8kX5lTWdW4JkerP6sfUYaJhdX334Ts47
	qiABCITJMOs5DTHZW1guFN4WxHlpIuH5PWxOk4xlKeuWaYUBg/bQcoYJoaXn4vYJzjHZl2oJuN0KC
	78aoPJX+b+pL7pVuy3ZYKdY+s6lvaI03D9SonqdZK9F/Zar0ewpOYX1I42pexyvW0D9djWdhYp2q7
	z50YKicg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCFSH-000000076VP-3XQ6
	for fio@vger.kernel.org;
	Thu, 01 Oct 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 505B31BC01B9; Thu,  1 Oct 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu,  1 Oct 2026 06:00:01 -0600
Message-Id: <20261001120001.505B31BC01B9@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 86196b9b9104b87a81ca5e54c87b8acf471d8cad:

  Merge branch 'http-slist-leak' of https://github.com/niharika-khare/fio (2026-09-29 13:27:05 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e27aa8b47c371491044ce9d7b3ee2f8488ba91b4:

  Merge branch 'fix/no-rdwr-when-job-never-writes' of https://github.com/hmi-jeon/fio (2026-09-30 13:24:00 -0400)

----------------------------------------------------------------
Minsik Jeon (1):
      filesetup: don't open files O_RDWR for 100% read jobs

Vincent Fu (1):
      Merge branch 'fix/no-rdwr-when-job-never-writes' of https://github.com/hmi-jeon/fio

 filesetup.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 740a2f47..72be2591 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -747,7 +747,11 @@ int generic_open_file(struct thread_data *td, struct fio_file *f)
 
 open_again:
 	if (td_write(td)) {
-		if (!read_only)
+		/*
+		 * For rw jobs, use O_RDWR only if the job has a non-zero
+		 * write percentage.
+		 */
+		if (!read_only && !(td_rw(td) && td->o.rwmix[DDIR_READ] == 100))
 			flags |= O_RDWR;
 
 		if (td->o.verify_only) {
