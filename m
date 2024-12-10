Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649A11A0B0E
	for <fio@vger.kernel.org>; Tue, 10 Dec 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733835613; cv=none; b=pBHOKL3PM4+imoEl/qIs395FYRWebMgd4Y9/dvWEFTZoZ4dJAqVMYoolaamAtWxfh6F74DCOPBwUd+UIXFaBQNNc4imxVt0u28kR1tysCnDa/keYQqPN0VgLwsfpQQwC/cAeZcBba7YTOzS640vV7cxUMJ2JYCuqhcvWc1NIhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733835613; c=relaxed/simple;
	bh=T65txr3dMX4uoOowo0ROzVR08WGlDJ6YK8vWodRZDY4=;
	h=Subject:From:To:Message-Id:Date; b=gkUddFhUgqnyOeD5V3CGAlqsdjOl0KKGHAHXAdG9mVY3d0QKh00kZK5/eZH72qQ9hKWAZeSpAdRwKcMCl8OrMcItpGFlQEgmo9QeSUMEC0xMZaWyIQCIJWsecjjavnoTvEYP+GzKRMlksZHSPWexWRH20W0EbU3043lcEQ2wk2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fo8ISkEi; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fo8ISkEi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=AcCtSPbOEZ9QG+VfcnTGHupkmjFLcEYE7ebxPxW1Ht4=; b=fo8ISkEixbYqF/cBjNyubiPS+P
	BqmONptGs5L7nEVO0Ai9RgVH3FRlM42CGuvRhRVT0bTMNM8Wl+Ju38ZOBZrgu0/rqK7kZMBZKZPwd
	jnhUtkEIyqJwGUTl16guw7gmQaRAwg9j9XPDy/QQHgsxfsqEoSuQqc8H4CzOp7YPGTQQHT2tS4rGt
	068UOSmcc2+79s5kLSstEFH/9kB9ICs9YCAJkFc81TjlMUMUkDzPolqyo8qL8bK8WE1WgUKBzI+Ha
	gZitJmbH9FNDsEgI+h9o4kSFOc1+hQFQNJD1vsULpdwVfItY6Z3gTbRaxYylvHwdPzjNeH+lhP67q
	CtbbzbUg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tKzqO-00000003gVn-2bw0
	for fio@vger.kernel.org;
	Tue, 10 Dec 2024 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 33A151BC0158; Tue, 10 Dec 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241210130001.33A151BC0158@kernel.dk>
Date: Tue, 10 Dec 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6f3de5cefec65b1fd31abd79274089282ea6569e:

  stat: fix unified_rw_reporting=both BW and IOPS (2024-12-04 19:00:53 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f512744be77f2c65e17e3ddde90c2458124ac152:

  nfs: add support for new libnfs API (2024-12-09 10:44:15 -0500)

----------------------------------------------------------------
Ronnie Sahlberg (1):
      nfs: add support for new libnfs API

 engines/nfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

---

Diff of recent changes:

diff --git a/engines/nfs.c b/engines/nfs.c
index 6bc4af1f..13b55038 100644
--- a/engines/nfs.c
+++ b/engines/nfs.c
@@ -157,16 +157,28 @@ static int queue_write(struct fio_libnfs_options *o, struct io_u *io_u)
 {
 	struct nfs_data *nfs_data = io_u->engine_data;
 
+#ifdef LIBNFS_API_V2
+	return nfs_pwrite_async(o->context, nfs_data->nfsfh,
+				io_u->buf, io_u->buflen, io_u->offset,
+				nfs_callback, io_u);
+#else
 	return nfs_pwrite_async(o->context, nfs_data->nfsfh, io_u->offset,
 				io_u->buflen, io_u->buf, nfs_callback, io_u);
+#endif
 }
 
 static int queue_read(struct fio_libnfs_options *o, struct io_u *io_u)
 {
 	struct nfs_data *nfs_data = io_u->engine_data;
 
+#ifdef LIBNFS_API_V2
+	return nfs_pread_async(o->context, nfs_data->nfsfh,
+				io_u->buf, io_u->buflen, io_u->offset,
+				nfs_callback, io_u);
+#else
 	return nfs_pread_async(o->context, nfs_data->nfsfh, io_u->offset,
 				io_u->buflen, nfs_callback, io_u);
+#endif
 }
 
 static enum fio_q_status fio_libnfs_queue(struct thread_data *td,
