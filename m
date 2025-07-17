Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D8B29C35A
	for <fio@vger.kernel.org>; Thu, 17 Jul 2025 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753616; cv=none; b=udAqA797ONSKFXNzpC9IA84WKNuwd4lnF/piIVqrQcJOd1hw1Z+cCG9gGdKL0FePjyepZJqTqNv0asWqPXegu967oDZox2n8xC7/03cfXVOo9sOr7593UUIsqpCppHm30XZv63WkFz5buc7JgCqsthuPa9VkyE02IOnLbgqUIqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753616; c=relaxed/simple;
	bh=kxblYB9DKBwL62YliA8nAgiJ+5naQVF0V2HFH8wkiuw=;
	h=Subject:From:To:Message-Id:Date; b=hEqUwxrxwnAwyKvawy8F+dru0m3JdkGVmDe2KCBFj2XscnxU3iTOOVpQHivhDjyr23nWYYF+J38qwn9EedjuOT57DeWPovRSCY6D0m7cHAAOG669LuMw/xSBLPoddtE7gjW+dFgNfl208lUIz1sOt04HcbDrUwyEamPqtKenhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jS+0cXHF; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jS+0cXHF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=DAuGpEKnYBDfD01H3HG9SJzfksjXLDOATkpwcDIF2o8=; b=jS+0cXHFDpSLunW2U6VkG7cx5Y
	5M/bsFx6IpLlYBQVqbJc7l5MA8T1DS8kYUINsBjidAlngJ1W6Gfaf1UY20cwuemguxiO/eUn1b4Ga
	DmxvvZZ5kchw37j9+v0MMHFb9lV1jS78Ro6moQGwLBty3JegbH71u/+yJpkypaKFd4gcwVMoj+JU2
	B+xOL4X2G0//6kNtyujXjaVqk0skRFSZKuu7/eN/mp2PW0MjJ/i4Ii6Mn2b9xIYUGEAGkn6wbf9ye
	G8PPf8yWvj7qGc6Vpoj7dUGF4ePvFjbetxlG0a6FKunIduX1zDVgceWfC9AyDOd8s4vbkpE+/sWjE
	Nv4yILXA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ucNHR-00000002mty-0ua3
	for fio@vger.kernel.org;
	Thu, 17 Jul 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 294B41BC0164; Thu, 17 Jul 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250717120002.294B41BC0164@kernel.dk>
Date: Thu, 17 Jul 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit eb0312ccc1058334e0a115b6534056bcdba7c533:

  Merge branch 'security-token' of https://github.com/sfc-gh-rnarubin/fio (2025-07-09 16:52:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 34fa726e0ae0236c36fb1409bddeab2bab7839d2:

  Merge branch 'fsync-get-io-u-from-freelist' of https://github.com/jeongjonghwi/fio (2025-07-16 11:59:46 -0400)

----------------------------------------------------------------
Jonghwi Jeong (1):
      io_u: get io_u from io_u_freelist when TD_FSYNCING

Vincent Fu (1):
      Merge branch 'fsync-get-io-u-from-freelist' of https://github.com/jeongjonghwi/fio

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 360bd774..ca97f388 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1701,7 +1701,7 @@ struct io_u *__get_io_u(struct thread_data *td)
 		__td_io_u_lock(td);
 
 again:
-	if (!io_u_rempty(&td->io_u_requeues)) {
+	if (td->runstate != TD_FSYNCING && !io_u_rempty(&td->io_u_requeues)) {
 		io_u = io_u_rpop(&td->io_u_requeues);
 		io_u->resid = 0;
 	} else if (!queue_full(td)) {
