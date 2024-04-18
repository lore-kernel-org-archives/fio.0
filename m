Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211CF15FA63
	for <fio@vger.kernel.org>; Thu, 18 Apr 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713441611; cv=none; b=KEZ1lIRCnWarl8dseWV0rPbegML/z2rivy+4bbj34JPwt+uzIJ08xlGFUZ7EX96F1KBHTCBjk01eET6lL6Bi+Y4bSHaxSTWuuc5nVJaWCNgzyAySJcjNfAsbXqQVIJbR2qz1xGh3bUJNXbNuCo6dxVu3Kws7RtljbadZTSQvMug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713441611; c=relaxed/simple;
	bh=ujZTKmeq4agXkBHyYiktP1divZFeZXAJOo0pLxzSwO8=;
	h=Subject:From:To:Message-Id:Date; b=k/0krPEi3NL1rJkyBv6IAA51lJm2WgC9VqLv2KWBsgaQGBWyxBqGwv4kfLxqRUGHo8/FPB5N9BnEflcZDZTKpl/QnisKQQ8DXG9LGkhOl9F6CYYHa98l1KaQcSzgVRHU7/rgseBXsk8aj0i1og9rRiVMWj8/jeDiveQ6EehUhpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K0pPBTpc; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K0pPBTpc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=E6XuGNog4B7Gi0aYjr0BBXmSe7WRsThnz2P066pxsxU=; b=K0pPBTpcNrKvVob7/JEljfTUk/
	cHbJ4od3Mx28bE5CnjISNGquklDgE6CAhQ4t8R7mWrGpfrg6dE2H4wQOXTBkHib/PIKh6YLXjfmMN
	woO0td45ZxOlpoIN3AggipXH9BaRuP9OMn5u+lfBQBq4hFD+wzLXelaaBI1yWUByz6A9tbRxUbinv
	T54lOIjGIJdJ1P2U9c6JZJtlC0NSRYLKWRhKPtVGWSRF6TTY/+kkmyPb2ZRaYKmLkL09MzlhqAIFQ
	MlHBFLDwhmX5z5OPcbJlmEHzvWBrTO58payqFaqJM+3Udr87d5tbfekghhlybSkDnWtxixMhMZOn1
	0uToFUwg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxQQu-00000005GSK-1Q0S
	for fio@vger.kernel.org;
	Thu, 18 Apr 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 525611BC015F; Thu, 18 Apr 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240418120001.525611BC015F@kernel.dk>
Date: Thu, 18 Apr 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5b347a1d4e5fd81b6a1b515843b834c39fb3463d:

  Merge branch 'directory-operation' of https://github.com/friendy-su/fio (2024-04-16 11:04:58 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e0bb44a5b2a67695f0b940772c70f678b323ec54:

  t/io_uring: only calculate per-file depth if we have files (2024-04-17 16:34:47 -0600)

----------------------------------------------------------------
Ankit Kumar (1):
      ioengines: bump up FIO_IOOPS_VERSION

Jens Axboe (2):
      Merge branch 'ioops_ver' of https://github.com/ankit-sam/fio
      t/io_uring: only calculate per-file depth if we have files

Vincent Fu (1):
      github: add reminders to PR template

 .github/PULL_REQUEST_TEMPLATE.md | 7 +++++++
 ioengines.h                      | 2 +-
 t/io_uring.c                     | 4 +++-
 3 files changed, 11 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/.github/PULL_REQUEST_TEMPLATE.md b/.github/PULL_REQUEST_TEMPLATE.md
index 4d98a694..6cead5b3 100644
--- a/.github/PULL_REQUEST_TEMPLATE.md
+++ b/.github/PULL_REQUEST_TEMPLATE.md
@@ -6,3 +6,10 @@ Please confirm that your commit message(s) follow these guidelines:
    aren't something like a URL at 72-74 chars.
 4. Empty line
 5. Signed-off-by: Real Name <real@email.com>
+
+Reminders:
+
+1. If you modify struct thread_options, also make corresponding changes in
+   cconv.c and bump FIO_SERVER_VER in server.h
+2. If you change the ioengine interface (hooks, flags, etc), remember to bump
+   FIO_IOOPS_VERSION in ioengines.h.
diff --git a/ioengines.h b/ioengines.h
index 2fd7f52c..e43650f7 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "fdp.h"
 
-#define FIO_IOOPS_VERSION	33
+#define FIO_IOOPS_VERSION	34
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
diff --git a/t/io_uring.c b/t/io_uring.c
index 18e8b38e..aa6e09e9 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -974,7 +974,9 @@ static int setup_ring(struct submitter *s)
 	for (i = 0; i < p.sq_entries; i++)
 		sring->array[i] = i;
 
-	s->per_file_depth = (depth + s->nr_files - 1) / s->nr_files;
+	s->per_file_depth = INT_MAX;
+	if (s->nr_files)
+		s->per_file_depth = (depth + s->nr_files - 1) / s->nr_files;
 	return 0;
 }
 
