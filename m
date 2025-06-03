Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A044A22D4F6
	for <fio@vger.kernel.org>; Tue,  3 Jun 2025 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748952016; cv=none; b=EfGOV64DYkz2BI+PaaPS6h9HTaCdVWEA2c6afSmhPEYnlz42xvJEXyFfjFYlecI4IPeYGzb9o/LjUJ4MCVGnRc9zkDliruOqUPMV0ZukW84tudMMry8ECrjBOJs9HJhLiX3S9zhD4p8MCbU3QJoN7cJC5tTnMCSlbr/lkKKG8g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748952016; c=relaxed/simple;
	bh=FmuVRzyEQDjV91x2MDXVnMkVUjHzGMnwm9g+ILyBmxM=;
	h=Subject:From:To:Message-Id:Date; b=ds6yNtqERStLitOJcrVlcz/azE/18i/LNfqvnU23MI0e6GVmemr+y3wDWPuXvYyjAo9l8D0Kun+Ke0tAVM42SVg17v36VLuaIJXp/QY3+AezSZkhucc5aaZ4le6Bb0goftYbXXzFBcfI8Xyf6bLXp0d0VzYb+ap2LH3tPsiEZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K7WYrNpl; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K7WYrNpl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zXjYcIAKLjt2+dAVO/gesmxmnqDc/KjZmo1TfN6rhgQ=; b=K7WYrNplFezvI63t9oo+dIM5u/
	Tdo3MskgQPgmdK/6cfpyPzCdf0XtRoFnvYFiqhfHfNebvjJ/LSJ8Kgdbb8L+7sXqT0t8FqMcb3Mll
	NQxS3Rak57iZ4iKUMWths454/ZFz4OfJUksCyJT7mfG6MB9gPe6tIg6N+GlXh9yn8zSSmuhidnJ9p
	RX8zLN+5sYU5eAY2t2kFRF6dtM/akt4WbmrIFOxG4HpBnbi5r/rBAEuzcwPRxaOK5WuvRgXmaoAJx
	1Y2V9YaCSd7GTfBjFktcjO+d6WKRvYpAii6a2xBHTSoN9krN0vRWOhuHxNQBxtDEZubFE3pF42uIq
	dKI5dymw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uMQJN-00000001zPT-3pio
	for fio@vger.kernel.org;
	Tue, 03 Jun 2025 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id BCB9E1BC017A; Tue,  3 Jun 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250603120001.BCB9E1BC017A@kernel.dk>
Date: Tue,  3 Jun 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit af8ed1ebebfa55c9b3078e450d2b514bc0bf72c9:

  Merge branch 'opt/io_uring-sq-full-check' of https://github.com/calebsander/fio (2025-05-31 14:22:37 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 02fe4fb04a141d5e72b641f7a36b3ea1e5a2b147:

  ioengines: clear in-flight bit for FIO_Q_BUSY syncs (2025-06-02 12:35:42 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      t/verify: skip crc7 when running checksum tests
      ioengines: clear in-flight bit for FIO_Q_BUSY syncs

 ioengines.c | 10 ++++++----
 t/verify.py |  8 +++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index 05d01a0f..9f75e66c 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -390,10 +390,12 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 
 	unlock_file(td, io_u->file);
 
-	if (ret == FIO_Q_BUSY && ddir_rw(ddir)) {
-		td->io_issues[ddir]--;
-		td->io_issue_bytes[ddir] -= buflen;
-		td->rate_io_issue_bytes[ddir] -= buflen;
+	if (ret == FIO_Q_BUSY) {
+	       if (ddir_rw(ddir)) {
+			td->io_issues[ddir]--;
+			td->io_issue_bytes[ddir] -= buflen;
+			td->rate_io_issue_bytes[ddir] -= buflen;
+		}
 		io_u_clear(td, io_u, IO_U_F_FLIGHT);
 	}
 
diff --git a/t/verify.py b/t/verify.py
index 58bf327d..4c3d0a3c 100755
--- a/t/verify.py
+++ b/t/verify.py
@@ -627,7 +627,13 @@ def verify_test_csum(test_env, args, mbs, csum):
     methods can reliably detect data integrity issues.
     """
     for test in TEST_LIST_CSUM:
-        test['force_skip'] = False
+        # The crc7 checksum will produce too many false positives since when we
+        # modify the data there is a 1/128 chance that the checksum will not
+        # change. So skip this set of tests.
+        if csum == 'crc7':
+            test['force_skip'] = True
+        else:
+            test['force_skip'] = False
         test['fio_opts']['verify'] = csum
 
         if csum in ('pattern', 'pattern_hdr'):
