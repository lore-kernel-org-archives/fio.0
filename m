Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395FD425862
	for <fio@vger.kernel.org>; Thu,  3 Sep 2026 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788436821; cv=none; b=h8nbtoQAgnYRrNFiBdL+HFIhLPBh9DN5EpeR9b/pfNu1jchCrHopF4DOS9vaG4B/OgFxkg+9MorCZ5h/Evxf8eNEPecifR6/xbWOWnyzdcBimseMN5TcVQcDdpIiD7JQF1jeSnEkHtGT0HRo8Mn+dwmUcykCdBYwuLDXWgffJZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788436821; c=relaxed/simple;
	bh=W184DpCWLmh8icGub1NMlglZkCgE+aM7JO6xSSwWRUM=;
	h=Subject:From:To:Date:Message-Id; b=oALwLM9xpwKgg/+xC2sMXPq2nK6dcMUcrvqT+xIbb7Kugm9ecFyXFEuFMHfKlWZ9mF6++hbrMlxxesfkAphrNtnzv+lZTmlLOB7kDaZNHmgDyfSNooRkn8yuJblbIjsYPsU9MNa7hJPQ5HxsYzt2nrEREPOwompCMsSYBjnV1x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VXQEckck; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VXQEckck"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9Q2vuoeN6ha+uf2GGd0VxNWutE+q4cDzvw9tRQgYQuM=; b=VXQEckckQbHDYdPkcDSIdqVSyZ
	dU45oqgQ33uGxlWME8CDkwxHDBBweK+jgjyCyQwAKIzBPe5DsvykuZav+lUBNpTnKxQSIn55fmz1g
	tsP/33UdlNyV2kDGWjJpBtSkATRdLjcr6Qa5kl0RCpgMmxTzQY+3k9ZreelNe9FeOR92joyMIQBHF
	UvaJoUw2w7RS4rmRACV2rOBmyvcl4f6flbnl+YuJsp+Z4xGZHpovygvD3C8eI800tqQiMpIqJRlA0
	XLTJ/nhiLghnGqv8/cYAD9TBXt5gNSzS6GDwAfOwzwrFLsrQzgpOr/45rKadpA3GdVuJmRxdJfjGL
	gIidZbTA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x266v-00000009vBb-10vo
	for fio@vger.kernel.org;
	Thu, 03 Sep 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 6F4C41BC0156; Thu,  3 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu,  3 Sep 2026 06:00:01 -0600
Message-Id: <20260903120001.6F4C41BC0156@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ae35a58399b28edf857f7ebc43b3eb40d86ac29b:

  Merge branch 'verify-zero-dump' of https://github.com/sarthak-k/fio (2026-08-26 16:12:53 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 975ea1856fee9f4c0f01f6f19ba3c61ce24f9bc8:

  Merge branch 'consolidate_commit_call_path' of https://github.com/dennischerchang/fio (2026-09-01 21:48:38 +0000)

----------------------------------------------------------------
Dennis Chang (1):
      Consolidate all caller of io_ops_commit() to call td_io_commit().

Vincent Fu (1):
      Merge branch 'consolidate_commit_call_path' of https://github.com/dennischerchang/fio

 ioengines.c | 13 ++++++++-----
 ioengines.h |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index 911a286e..b0b18d34 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -304,8 +304,7 @@ int td_io_getevents(struct thread_data *td, unsigned int min, unsigned int max,
 		return 0;
 
 	if (min > 0 && td->io_ops->commit) {
-		r = td->io_ops->commit(td);
-		if (r < 0)
+		if (!td_io_commit(td))
 			goto out;
 	}
 	if (max > td->cur_depth)
@@ -502,21 +501,24 @@ int td_io_init(struct thread_data *td)
 	return ret;
 }
 
-void td_io_commit(struct thread_data *td)
+bool td_io_commit(struct thread_data *td)
 {
 	int ret;
+	bool commit_success = true;
 
 	dprint(FD_IO, "calling ->commit(), depth %d\n", td->cur_depth);
 
 	if (!td->cur_depth || !td->io_u_queued)
-		return;
+		return true;
 
 	io_u_mark_depth(td, td->io_u_queued);
 
 	if (td->io_ops->commit) {
 		ret = td->io_ops->commit(td);
-		if (ret)
+		if (ret) {
 			td_verror(td, -ret, "io commit");
+			commit_success = false;
+		}
 	}
 
 	/*
@@ -524,6 +526,7 @@ void td_io_commit(struct thread_data *td)
 	 */
 	td->io_u_in_flight += td->io_u_queued;
 	td->io_u_queued = 0;
+	return commit_success;
 }
 
 int td_io_open_file(struct thread_data *td, struct fio_file *f)
diff --git a/ioengines.h b/ioengines.h
index b0a767ba..d58b95c7 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -141,7 +141,7 @@ extern int __must_check td_io_init(struct thread_data *);
 extern int __must_check td_io_prep(struct thread_data *, struct io_u *);
 extern enum fio_q_status __must_check td_io_queue(struct thread_data *, struct io_u *);
 extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
-extern void td_io_commit(struct thread_data *);
+extern bool td_io_commit(struct thread_data *);
 extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
 extern int td_io_close_file(struct thread_data *, struct fio_file *);
 extern int td_io_unlink_file(struct thread_data *, struct fio_file *);
