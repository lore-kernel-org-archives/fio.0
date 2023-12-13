Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ILiHR6Yg"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4398D0
	for <fio@vger.kernel.org>; Wed, 13 Dec 2023 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=tmEmHw1dFXHrdssC1d63R3CRsxMFNA/bhVFawKjvz9U=; b=ILiHR6YgNyNyKL29r5F6wGEGVe
	0weox9sYKZTLxl42NAGFrWezUK7BnPqTG4aTWZtWyLtnW0ZSOoPpOs2+Zlfiw/Cfp/gMm8NM+Sw5p
	4YPlGl34b3NAVr08jeKnf3AFUl0GN1UgThXJnoot5dcuTwwGOiJkPNW3eUFS+Xg71oF/w/44EZuZj
	bQn/LSg9wnQrUvLGtJg2gNOJNVhV++7+xW3c0YuqwRXuWgXL7/CQgIEMahYD2X6WQvk0Y/zD5/USP
	Pjo2AFRaCm47aMH64WIFVAppa7/KJIV1RkxJkTPEpnLBjWskWGYdBdoQGkoRYaQ/HHfoAkmXt3NDX
	sFKTDH+w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rDOqJ-001pY2-Or
	for fio@vger.kernel.org; Wed, 13 Dec 2023 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E87411BC0175; Wed, 13 Dec 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231213130001.E87411BC0175@kernel.dk>
Date: Wed, 13 Dec 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 63e6f55a9147cf9f76376c2e7e38a623c8832f23:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-12-11 16:27:21 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f53eaac02ec46bdf7f87058f30667be80975caf6:

  engines/io_uring_cmd: skip pi verify checks for error cases (2023-12-12 09:39:06 -0500)

----------------------------------------------------------------
Ankit Kumar (1):
      engines/io_uring_cmd: skip pi verify checks for error cases

 engines/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5ae3135b..c0cb5a78 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -468,10 +468,12 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	cqe = &ld->cq_ring.cqes[index];
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
-	if (cqe->res != 0)
+	if (cqe->res != 0) {
 		io_u->error = -cqe->res;
-	else
+		return io_u;
+	} else {
 		io_u->error = 0;
+	}
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		data = FILE_ENG_DATA(io_u->file);
