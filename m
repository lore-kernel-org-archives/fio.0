Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C43322C97
	for <fio@vger.kernel.org>; Tue, 25 Nov 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764075614; cv=none; b=K8RgNdk1SYKhhAXlQgshR+/zJSG6xAGK853kiFxcKtyftOYqvezX2MzqFig5gyjM11JCRPgDNtWTNyMPOi/hlmXQgf499dc0LxJElJHJBJUPi5Dhk2XFXoloc50fM/jG32CYhNgAY3qWoAIZnNdQeXtOcdxoJcNVmDRfsdxpxyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764075614; c=relaxed/simple;
	bh=ZACKitwjfF6THQ94H8wSUgkLbyaerJ0LSKIsgdhCrf4=;
	h=Subject:From:To:Date:Message-Id; b=MQPRny2Q69W1DpXGUqGcR8PXvzzK030s5anPdNEXIN8Q5oTClTFVCKu1n9mx6wae9DNSZ+QwN654yZ7eg81PILax5mCZWmy3fTSDSzIJXV3Mk+wShbZB8/JHHllbxNZeJOuaL8WKJfVI8VG7f/KtWu/XFgbESgFhdN4SCieELOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZjAKJEaZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZjAKJEaZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Aielcuwp9riD1WzQlOdBh/bx83vYmla/AYXTSI8QDms=; b=ZjAKJEaZBWXE4tGBvKHDdYIG8p
	aFKN9znWPpDtAwZ6x6Hr94yjSwV5A0orPiwVA2M4bRTnGXUDFxJQB6Ts5rKfymeIUw9s8SyRzvfGF
	qx4Enn9leAkaVNK1hyn+zlj6rHjOf56lOPs2veFoG8MdaL94Y9LyAHRdtCk1T7sth17d6wOt4lYQq
	//TdWRd+N+50UYRwmi3GnNiddjX77oiVImTNyAeDbpD8T+ljf1f4XArCBAQuR6sGwD2RVvl5VQb/7
	vvVj3NZ943CoEHLy/kyERWjjS7TaCrJakJioYS2lda9xVxiKOzKWZhTiYu7Qsz7gmNMjb0zlODcmw
	7x81T3Pw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNrml-00000005oOk-0yNQ
	for fio@vger.kernel.org;
	Tue, 25 Nov 2025 12:04:43 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4F6401BC0177; Tue, 25 Nov 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 25 Nov 2025 06:00:01 -0700
Message-Id: <20251125130001.4F6401BC0177@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7c8dbca4aa7ff0172d70846e04f8e9909ab81094:

  ci: work around macOS pip restrictions (2025-11-18 20:15:42 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to de3d5e68dd017a6d6099913b7831bb94f46e49cc:

  Merge branch 'mmap-fixes' of https://github.com/geertj/fio (2025-11-24 06:50:27 -0700)

----------------------------------------------------------------
Geert Jansen (3):
      engines/mmap: support fadvise_hint
      engines/mmap: fix logic when "offset" > 0
      engines/mmap: fix full/limited prep logic

Jens Axboe (1):
      Merge branch 'mmap-fixes' of https://github.com/geertj/fio

 engines/mmap.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/engines/mmap.c b/engines/mmap.c
index 55ba1ab3..1585d723 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -15,7 +15,7 @@
 #include "../verify.h"
 
 /*
- * Limits us to 1GiB of mapped files in total
+ * Limits us to 1GiB of mapped files in total on 32-bit architectures
  */
 #define MMAP_TOTAL_SZ	(1 * 1024 * 1024 * 1024UL)
 
@@ -53,6 +53,7 @@ static bool fio_madvise_file(struct thread_data *td, struct fio_file *f,
 			     size_t length)
 
 {
+	int flags;
 	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 #ifdef CONFIG_HAVE_THP
 	struct mmap_options *o = td->eo;
@@ -65,16 +66,20 @@ static bool fio_madvise_file(struct thread_data *td, struct fio_file *f,
 	if (!td->o.fadvise_hint)
 		return true;
 
-	if (!td_random(td)) {
-		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_SEQUENTIAL) < 0) {
-			td_verror(td, errno, "madvise");
-			return false;
-		}
-	} else {
-		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_RANDOM) < 0) {
-			td_verror(td, errno, "madvise");
-			return false;
-		}
+	if (td->o.fadvise_hint == F_ADV_TYPE)
+		flags = td_random(td) ? POSIX_MADV_RANDOM : POSIX_MADV_SEQUENTIAL;
+	else if (td->o.fadvise_hint == F_ADV_RANDOM)
+		flags = POSIX_MADV_RANDOM;
+	else if (td->o.fadvise_hint == F_ADV_SEQUENTIAL)
+		flags = POSIX_MADV_SEQUENTIAL;
+	else {
+		log_err("fio: unknown madvise type %d\n", td->o.fadvise_hint);
+		return false;
+	}
+
+	if (posix_madvise(fmd->mmap_ptr, length, flags) < 0) {
+		td_verror(td, errno, "madvise");
+		return false;
 	}
 
 	return true;
@@ -152,11 +157,8 @@ static int fio_mmapio_prep_limited(struct thread_data *td, struct io_u *io_u)
 		return EIO;
 	}
 
-	fmd->mmap_sz = mmap_map_size;
-	if (fmd->mmap_sz  > f->io_size)
-		fmd->mmap_sz = f->io_size;
-
 	fmd->mmap_off = io_u->offset;
+	fmd->mmap_sz = io_u->buflen;
 
 	return fio_mmap_file(td, f, fmd->mmap_sz, fmd->mmap_off);
 }
@@ -172,14 +174,14 @@ static int fio_mmapio_prep_full(struct thread_data *td, struct io_u *io_u)
 
 	if (fio_file_partial_mmap(f))
 		return EINVAL;
-	if (io_u->offset != (size_t) io_u->offset ||
-	    f->io_size != (size_t) f->io_size) {
+
+	if (sizeof(size_t) < 8 && f->io_size > mmap_map_size) {
 		fio_file_set_partial_mmap(f);
 		return EINVAL;
 	}
 
 	fmd->mmap_sz = f->io_size;
-	fmd->mmap_off = 0;
+	fmd->mmap_off = f->file_offset;
 
 	ret = fio_mmap_file(td, f, fmd->mmap_sz, fmd->mmap_off);
 	if (ret)
@@ -218,8 +220,7 @@ static int fio_mmapio_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 done:
-	io_u->mmap_data = fmd->mmap_ptr + io_u->offset - fmd->mmap_off -
-				f->file_offset;
+	io_u->mmap_data = fmd->mmap_ptr + io_u->offset - fmd->mmap_off;
 	return 0;
 }
 
