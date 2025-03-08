Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A24AD4B
	for <fio@vger.kernel.org>; Sat,  8 Mar 2025 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741438818; cv=none; b=XcjAsFJvpvMMTYqSxlsjfqdFbSqfmn0YI0Pt/biPiUJnWoaKLv0yoN3lmJdT/+wumJwZeLiiZ+dCZYYbgLGbZhLn20SKJdiwA9y+CiI03lvfqJ1tIGSI1msER7rZntesVHtWry+LWUXsv96OEsD4r1x1Agtb3/jV+Jf+32pyuoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741438818; c=relaxed/simple;
	bh=kVqUUUAhyYjek/o1PClSb6XisaoR0wn5/4sdlBTLZUs=;
	h=Subject:From:To:Message-Id:Date; b=DUJZHTVN6p0HMy4hCrDxxYkDPwkXGDRZYvq81NHkkExaZmTAYNYRSP8xgp2EA0Ign//jRjYk5yiMEMw54faFzqcS+F1IYrHDjVwJUts7WPV5UTT0URZRTTFNeYyLRgYQbpoU3uHP8w2zw8q/Iiba4mKltcKlEizGPwUd8ZUPlhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HcpJExrn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HcpJExrn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=XUyI053L3bSahj6ibzexxVCp4KKOxymfi80aiumeA/E=; b=HcpJExrnXwqcnvNOHIRCA+J6QA
	3Oh7XzeRArFmDmv4/U1BmsEPvwwZ3hBS8V2qWbs5Hxtt1QV7ZpzqRvyalMvVzZwwxuPnG2uLArz+Q
	CX6TglKDaJCoYWkbNnMEfMkb4pEkXJ23i8RU0qiZdJXORYauJsnFhkmE57iTeukX9V+7OOf/G/rYG
	V9bIuMbh8LUHEusJOzSDwWt2d7hFAbcyXD/E9UEei0dzqhqYznnB2J66ApRin9c6u06VLlsATz1Wx
	7KPZ82WhpyDxNgQ/NcgN8d9e3mlW4mYZ8htLDPwNvommnt59ybmW2ePXbpm0JL76Czbe2lI24xcBj
	Res21AfA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tqtmg-00000001X1P-1Axl
	for fio@vger.kernel.org;
	Sat, 08 Mar 2025 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 062E31BC0147; Sat,  8 Mar 2025 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250308130002.062E31BC0147@kernel.dk>
Date: Sat,  8 Mar 2025 06:00:02 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a72fed7a4900e43035cf4e7e653fd11b6671c726:

  ci: add nightly test for verify (2025-03-06 13:58:43 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d2a4910bbefcb3ddecf2868a955ef27ec71286fc:

  Merge branch 'dfs' of https://github.com/henglgh/fio (2025-03-07 11:39:42 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'dfs' of https://github.com/henglgh/fio

fugen (1):
      dfs: fix fail to load dfs engine

 engines/dfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/engines/dfs.c b/engines/dfs.c
index 664e8b13..e4da85f8 100644
--- a/engines/dfs.c
+++ b/engines/dfs.c
@@ -16,7 +16,7 @@ static pthread_mutex_t	daos_mutex = PTHREAD_MUTEX_INITIALIZER;
 daos_handle_t		poh;  /* pool handle */
 daos_handle_t		coh;  /* container handle */
 daos_oclass_id_t	cid = OC_UNKNOWN;  /* object class */
-dfs_t			*dfs; /* dfs mount reference */
+dfs_t			*daosfs; /* dfs mount reference */
 
 struct daos_iou {
 	struct io_u	*io_u;
@@ -184,7 +184,7 @@ static int daos_fio_global_init(struct thread_data *td)
 	}
 
 	/* Mount encapsulated filesystem */
-	rc = dfs_mount(poh, coh, O_RDWR, &dfs);
+	rc = dfs_mount(poh, coh, O_RDWR, &daosfs);
 	if (rc) {
 		log_err("Failed to mount DFS namespace: %d\n", rc);
 		td_verror(td, rc, "dfs_mount");
@@ -205,7 +205,7 @@ static int daos_fio_global_cleanup()
 	int rc;
 	int ret = 0;
 
-	rc = dfs_umount(dfs);
+	rc = dfs_umount(daosfs);
 	if (rc) {
 		log_err("failed to umount dfs: %d\n", rc);
 		ret = rc;
@@ -336,7 +336,7 @@ static int daos_fio_get_file_size(struct thread_data *td, struct fio_file *f)
 	if (!daos_initialized)
 		return 0;
 
-	rc = dfs_stat(dfs, NULL, file_name, &stbuf);
+	rc = dfs_stat(daosfs, NULL, file_name, &stbuf);
 	if (rc) {
 		log_err("Failed to stat %s: %d\n", f->file_name, rc);
 		td_verror(td, rc, "dfs_stat");
@@ -387,7 +387,7 @@ static int daos_fio_open(struct thread_data *td, struct fio_file *f)
 		flags |= O_RDONLY;
 	}
 
-	rc = dfs_open(dfs, NULL, f->file_name,
+	rc = dfs_open(daosfs, NULL, f->file_name,
 		      S_IFREG | S_IRUSR | S_IWUSR,
 		      flags, cid, eo->chsz, NULL, &dd->obj);
 	if (rc) {
@@ -405,7 +405,7 @@ static int daos_fio_unlink(struct thread_data *td, struct fio_file *f)
 
 	dprint(FD_FILE, "dfs remove %s\n", f->file_name);
 
-	rc = dfs_remove(dfs, NULL, f->file_name, false, NULL);
+	rc = dfs_remove(daosfs, NULL, f->file_name, false, NULL);
 	if (rc) {
 		log_err("Failed to remove %s: %d\n", f->file_name, rc);
 		td_verror(td, rc, "dfs_remove");
@@ -523,7 +523,7 @@ static enum fio_q_status daos_fio_queue(struct thread_data *td,
 
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
-		rc = dfs_write(dfs, dd->obj, &io->sgl, offset, &io->ev);
+		rc = dfs_write(daosfs, dd->obj, &io->sgl, offset, &io->ev);
 		if (rc) {
 			log_err("dfs_write failed: %d\n", rc);
 			io_u->error = rc;
@@ -531,7 +531,7 @@ static enum fio_q_status daos_fio_queue(struct thread_data *td,
 		}
 		break;
 	case DDIR_READ:
-		rc = dfs_read(dfs, dd->obj, &io->sgl, offset, &io->size,
+		rc = dfs_read(daosfs, dd->obj, &io->sgl, offset, &io->size,
 			      &io->ev);
 		if (rc) {
 			log_err("dfs_read failed: %d\n", rc);
