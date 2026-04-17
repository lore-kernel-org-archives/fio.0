Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFF439A054
	for <fio@vger.kernel.org>; Fri, 17 Apr 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776427211; cv=none; b=SElEMkJV3DOITKVI56HIXiKki0mDMGN1aqlE/Uy1alAghCbTmi72Kc6z7nFYERBFYXwd0JTuQOWGCfGs2TGoPgy19bF/ql32/uFE5etK1+ZGP3EsqVNNUTZL3EbxboLZWIe2APmUgUyXljMLtwtIu8gXQXd0FPOTsPlY5NNnqf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776427211; c=relaxed/simple;
	bh=eGdBPnR9H4sTFwmZTQCy+FN0b5mTQTfcokiPe9jzDIU=;
	h=Subject:From:To:Date:Message-Id; b=P9m3WkoT4A6LqkexqzQ5GHvUIbFDZTJCDrdqQZKsde4Jmm8z8OscGRr/WvOS1jI5x4hViBHsugy/0D6VL1DFiOmEZvzZi3qdx7sXylR4QnhTwU/+3pc7QPpYVcEu2Gg42jd9l8dy5WkWP1ByWfoO1Rfnigv2klyKq95sqSAY9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HRoqvHPS; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HRoqvHPS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=/bjhipO0z/sn6PYso7KqXmJQXzYZg5XHmSYkxch7n9Q=; b=HRoqvHPS4ajObzWcYcoaXbXt5C
	nNL0GT3NLCefBp9nf55XoRNCKPYhqP7OZQhuCXztVK2dkWvVUqLpG1SXxfzp4j1HQ+UPyz1J3J0Tf
	jwSPb6Aek+3VrTLhqozDdb2FQxi0CHKxBvRe6tbAH0iKjfjZ8CdNuLwnma7MHt1CNSKDZGuq86NOD
	Cwa+nZC9I/dbuUdJhk+ZXgl9vPrnCu3/o364UuICK8ZSioRpLv3M9nf9ogUlRvwbxVGtclcD2HmEP
	Xrqo/5Fa+NKk80IqyQcxAT6cJKtrwySrG/PAR3fHkSrYIOk//Eg4u4rkw2xCS2DGT70Ip15Zu356O
	uSZo/iGA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDhrh-00000005JSN-1kz8
	for fio@vger.kernel.org;
	Fri, 17 Apr 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 508141BC00FD; Fri, 17 Apr 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 17 Apr 2026 06:00:01 -0600
Message-Id: <20260417120001.508141BC00FD@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f4e93793cbe3e4703520a9d4e1d6596bb1b43c73:

  Merge branch 'anon-fault' (2026-04-07 20:00:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 219f1c3503c1961f41173456d399f41b72d08ef3:

  Merge branch 'arm-select-eintr' of https://github.com/alex310110/fio (2026-04-16 10:56:35 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'arm-select-eintr' of https://github.com/alex310110/fio

alex310110 (1):
      helper_thread: Handle EINTR errno from select()

 helper_thread.c | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/helper_thread.c b/helper_thread.c
index 88614e58..71ad0f60 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -26,6 +26,7 @@ static int sleep_accuracy_ms;
 static int timerfd = -1;
 
 enum action {
+	A_NOOP		= 0,
 	A_EXIT		= 1,
 	A_RESET		= 2,
 	A_DO_STAT	= 3,
@@ -222,6 +223,8 @@ static uint8_t wait_for_action(int fd, unsigned int timeout_ms)
 #endif
 	res = select(max(fd, timerfd) + 1, &rfds, NULL, &efds,
 		     timerfd >= 0 ? NULL : &timeout);
+	if (res == -1 && errno == EINTR)
+		return A_NOOP;
 	if (res < 0) {
 		log_err("fio: select() call in helper thread failed: %s",
 			strerror(errno));
