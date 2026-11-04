Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793797214;
	b=zpPdTQw7DLVPpOroRGia4oHVrxolxxRmAjYCXDttEvxp7ckst3HS7VG1o/7zbjmso21K
	 IvM/cA6M1i7j5zNuOT8iEz6TXU3ljpsTM8A+u7JQePCLcUBe6MJmp33r7enr1uWhLu4ir
	 QgyuVBuzMEe/FWdlJqvky0lajLEZGOvPrJzMtTdYUXIJmYbWj4Z5iQLnU37fKaQLiKSw7
	 Ctff38xyGCQu58bPzl+vd17pGl0MZUGkD84EHzrzkoL41/5Lq5ROdqu+6+0aU073rDpxv
	 dvW6rxWx7822pJnuyD/foRgZC/6Zz+ioyJgFuyE9qE/2+YrvrX8aUAyF5UmWEgKhvew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797214;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=fRtswvRgZgxCaPIbpsNrdCs8Fy5mnlqL+46SaJZxbI8=;
	b=WTAGk7FYCK9UgJE6k4cpBOgcKga4mPIWaEWLDGuOUakJ4Je6NjJ7pC6DSaE2HbxkfZAh
	 4GEwfYF7qrEnISSBItj42eQD5koM1R0EDsjSXs7yiTrgSXztL8+AGF3g70HozBjBtV0EE
	 j1eY6sOxET4lbuXhj/bMfl7P+qqjjFMymUGLIdfGbGnAd8axXGyPiFdZUL3DcSzEoZUJC
	 /+6DIf7yIga9S2ew5JXWTJ4QCVfihJMLmVMKbwOy3vAhxrAJpoi/nwsgYlYNNCVrx3vwO
	 9r58Z5avRQZVODlxvtOBl57tTCE+mk82DJjUjrxtD/T8faWLZczvmtQ2NZ8v3+d1SBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=YrLQ3cWY;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B61A606A329
	for <fio@vger.kernel.org>; Wed,  4 Nov 2026 13:00:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B61A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=YrLQ3cWY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fRtswvRgZgxCaPIbpsNrdCs8Fy5mnlqL+46SaJZxbI8=; b=YrLQ3cWYghBUr1B24kRQJT1Oyw
	NYTri/zdt80qgwu0GsQueV+meKzI01zLj3L2vUMSy1gwDsbywY/Mwhv+S4PR/Xzxtq9M6/gILqig+
	b30XLhThTva9L8nGoVpxos7Uwdt8WPo9VtoqMgG0WaBE6kbJwDFM+Tz8iDIq3Ps8AivFuvcTHrDmT
	/im/BOPWaj+mUetTP4n6P8MBRfYK6kA5AcviQtRABO4z+QItp4uXvV/uygohd6lxccWr2l7NG9mfm
	jIxn1YZo4WutpFhfVEhVPJc8sognS1HsajMyhHKYIL7a+vpRQCF4saAdJ0+ltsgshF+PD1XzVjeib
	T6OVJXYA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOaay-00000005PCu-0fFc
	for fio@vger.kernel.org;
	Wed, 04 Nov 2026 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 75CD11BC01B9; Wed,  4 Nov 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed,  4 Nov 2026 06:00:01 -0700
Message-Id: <20261104130001.75CD11BC01B9@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 4b1bb1e0028b452a5bda33a1e934734be15c2bf4:

  ci: wait for guest SSH readiness (2026-10-29 15:07:49 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d645e90502dd740f8c7b6df8b17d35151df8bf3e:

  Merge branch 'fix/io_u-offset-stuck-fill-device' of https://github.com/hmi-jeon/fio (2026-11-03 20:02:51 -0500)

----------------------------------------------------------------
Minsik Jeon (1):
      io_u: fix offset stuck with fill_device + offset + time_based

Vincent Fu (1):
      Merge branch 'fix/io_u-offset-stuck-fill-device' of https://github.com/hmi-jeon/fio

 io_u.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 7be78d18..c39c9c09 100644
--- a/io_u.c
+++ b/io_u.c
@@ -406,6 +406,22 @@ static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 	return 1;
 }
 
+/*
+ * f->io_size can be -1ULL (fill_device). Guard against unsigned
+ * overflow when adding the start offset in that case, or whenever
+ * the sum would otherwise wrap past f->io_size.
+ */
+static uint64_t get_io_end(struct thread_data *td, struct fio_file *f)
+{
+	uint64_t start_off = get_start_offset(td, f);
+	uint64_t io_end = f->io_size + start_off;
+
+	if (f->io_size == -1ULL || io_end < f->io_size)
+		return f->real_file_size;
+
+	return io_end;
+}
+
 static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 			       enum fio_ddir ddir, uint64_t *offset)
 {
@@ -417,7 +433,7 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	 * If we reach the end for a time based run, reset us back to 0
 	 * and invalidate the cache, if we need to.
 	 */
-	if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f) &&
+	if (f->last_pos[ddir] >= get_io_end(td, f) &&
 	    o->time_based && o->nr_files == 1) {
 		f->last_pos[ddir] = f->file_offset;
 		loop_cache_invalidate(td, f);
@@ -431,7 +447,7 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	 * should get back to 0 offset to verify overlapped offsets.
 	 */
 	if (td_write(td) && o->io_size > o->size) {
-		if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f)) {
+		if (f->last_pos[ddir] >= get_io_end(td, f)) {
 			f->last_pos[ddir] = f->file_offset;
 			loop_cache_invalidate(td, f);
 		}
@@ -617,7 +633,7 @@ static inline bool io_u_fits(struct thread_data *td, struct io_u *io_u,
 {
 	struct fio_file *f = io_u->file;
 
-	return io_u->offset + buflen <= f->io_size + get_start_offset(td, f);
+	return io_u->offset + buflen <= get_io_end(td, f);
 }
 
 static unsigned long long get_next_buflen(struct thread_data *td, struct io_u *io_u,
