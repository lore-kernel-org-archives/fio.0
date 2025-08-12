Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87672FA0DB
	for <fio@vger.kernel.org>; Tue, 12 Aug 2025 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021482; cv=none; b=rB6D/xRNfbEqilolEVeV8YUItcRV7wKpcePytaluSsajKK4CX/aJ7Hoyq5+V+XT5X55Otj6RDI59qjFP9RBdUDZLcghyKU0Fp/c9aF/4OCexgtUbv6DArQ1gXX0ewiEmOswghenKUxXS0cl5Ml+dHqbTmfRpysL7fR8W/JcV4wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021482; c=relaxed/simple;
	bh=0CuW7RhnvD1Xg9J2ULniSBsHdRabaChUhND+spVXDqg=;
	h=Subject:From:To:Message-Id:Date; b=dk31KgpH+mfCWS15vycmmDl5XQ+oJyHpUjzTkSQUldLOWPglOuA4tOLggwniIe62/6WcQVhkHfHeuMr3F5p0wKXCYqTQWnX4rQqp2Z8wGH9BbNUC0QC4+S1dTh6SyVQ3TjlfxssIvXwW+VK7OuMg2rqn19zz07ay05e6QTW0Hko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pxaYmbTS; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pxaYmbTS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=NZzHM4M7Dc6kzj8JR4500/gECOe53vUR3DzqBA2G5Ok=; b=pxaYmbTSsKMcqkXek06nWnj/PK
	mPl26aIRL9u1sCe96QeOY5GiwszCXSkGdWwzGFiGNo1smg71YaXTvUQzrcPJc3ItVQzdgIhoZFten
	xLWEtwaQ3Ofwi6Ac451qOmI4r5142atVGetmD0ViZHZplpUqYx2JeA5CBlbYURPq36m+O+IwWN8Km
	Plu/G8nxhx448/9xE/8rFdAQ1JyNWpWxaZi9RHWWoaXfHybRUtb9+DgrsghgAyz5K58Wyan3ZrdUH
	zdRXDCfCfquoOTgJ1HNAFKhVN0J2m4rxXhEtQDbSuYiTB/yZGu40Ukv8EZBvq9T6tzVhPXkBpzBim
	e16JnLhg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ultFz-0000000Ft2g-2AAo
	for fio@vger.kernel.org;
	Tue, 12 Aug 2025 17:57:55 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 86EF01BC016F; Tue, 12 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250812120001.86EF01BC016F@kernel.dk>
Date: Tue, 12 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a52833b3295f0fae160eb3d4937a371756d6d929:

  verify: bump up verify state file version (2025-08-09 08:27:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fef641096d925d737d81683626eca52b6e358e52:

  configure: skip isal64 check when isal check fails (2025-08-11 12:42:06 -0400)

----------------------------------------------------------------
Vincent Fu (3):
      engines/io_uring: fix error value
      engines/io_uring: fix memory leaks during init
      configure: skip isal64 check when isal check fails

 configure          | 1 +
 engines/io_uring.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 7a295eab..3209e225 100755
--- a/configure
+++ b/configure
@@ -2692,6 +2692,7 @@ if test "$isal" != "no" ; then
     LIBS="-lisal $LIBS"
   else
     isal="no"
+    isal64="no"
   fi
 fi
 print_config "isal" "$isal"
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5d05f5c0..02f80bda 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -663,7 +663,7 @@ static void fio_ioring_validate_md(struct thread_data *td, struct io_u *io_u)
 	if (data->pi_type && (io_u->ddir == DDIR_READ) && !o->pi_act) {
 		ret = fio_nvme_pi_verify(data, io_u);
 		if (ret)
-			io_u->error = ret;
+			io_u->error = -ret;
 	}
 
 	return;
@@ -1499,6 +1499,7 @@ static int fio_ioring_init(struct thread_data *td)
 	if (!ld->is_uring_cmd_eng && o->md_per_io_size) {
 		if (o->apptag_mask != 0xffff) {
 			log_err("fio: io_uring with metadata requires an apptag_mask of 0xffff\n");
+			free(ld->io_u_index);
 			free(ld);
 			return 1;
 		}
@@ -1517,6 +1518,7 @@ static int fio_ioring_init(struct thread_data *td)
 			md_size += td->o.mem_align - page_size;
 		ld->md_buf = malloc(md_size);
 		if (!ld->md_buf) {
+			free(ld->io_u_index);
 			free(ld);
 			return 1;
 		}
@@ -1524,6 +1526,7 @@ static int fio_ioring_init(struct thread_data *td)
 		if (!ld->is_uring_cmd_eng) {
 			ld->pi_attr = calloc(ld->iodepth, sizeof(struct io_uring_attr_pi));
 			if (!ld->pi_attr) {
+				free(ld->io_u_index);
 				free(ld->md_buf);
 				free(ld);
 				return 1;
