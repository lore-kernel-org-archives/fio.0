Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E48E187355
	for <fio@vger.kernel.org>; Sat, 23 Nov 2024 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732366822; cv=none; b=XcVSNbdX641RlPswDJ8btJOXuKKgaHczu70UZvRomDU7De/lI/mjxzVJ2uB8XfzpfJQDry0I354qQ5EBZRrl2vh9NQgg9c9/egtDQOzKD2Fb3JK9628YbU7yUTfpxZSkHKIvg8u0c3Uh2EQZMGNxzb6aCIhwQmULtRJXEM4f4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732366822; c=relaxed/simple;
	bh=gJAMiSE21eyeH1BJ+6AglnB7TybfHubBeiwfVIyZKHs=;
	h=Subject:From:To:Message-Id:Date; b=LdIgya+ttK6OJzCszgtC3D1wmzKRLM1AbGZe4nruGxeAmNrpQDr7Sn72Kmb7aGLdRfuD72+Ct/cxqbgqG8oPn8SDKDGIG52mn3ZWH7Em/5gPYsqvCDZvJybmLRx04rYCQPOGB0z0AqTXo3aUJLgNtNo+3gezWtsmkoWeKtKZUYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mWRViGrl; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mWRViGrl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=HWj/8k829K4BGkyT/mJYF+uYQL9rZfCxRt4odqaOgAk=; b=mWRViGrlBZm/BaAw4q4s2kWlvq
	1wkJfDWeVM3VHThQLpjyZC6SOUo2DLY0YrNJy9vqmlabgt6aIN43JwACRroZd85nWZKk/P9SHnOOa
	MB60LeFclyR0+VhWzw9Vttoy2t273YZIjc6KcX4wjbFcQYrJG7KmNwJetys72ZSMs8nSxVOKsLMDZ
	MvOqGjGwhGdnk1XpP+0nUGRmUefl4wy+Adkxy/ZGFRr4kz216nqfKsOsUQslcKRUfX4I7GT220WRf
	GlwETc7Kz/nNGr41QAqQY7oaEAfkYMtwA0N5CZ2JqOriqryleGN8oxUuQ6X95P93t6YWVwqbw3SaJ
	4dMCF27g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tEpk5-00000000qzl-3ZgI
	for fio@vger.kernel.org;
	Sat, 23 Nov 2024 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 265F91BC0141; Sat, 23 Nov 2024 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241123130002.265F91BC0141@kernel.dk>
Date: Sat, 23 Nov 2024 06:00:02 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f2415d711a11fec6d5e4081a7bdc060b98c76043:

  t/io_uring: fix size confusion in allocate_mem() (2024-11-05 07:57:41 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dc03e3788e2b47281b67e9354a7ff02a3053264a:

  docs: explain type of memory allocated by md_per_io_size (2024-11-22 19:50:06 +0000)

----------------------------------------------------------------
Vincent Fu (2):
      engines/io_uring_cmd: disable iomem=malloc check for metadata
      docs: explain type of memory allocated by md_per_io_size

 HOWTO.rst          |  4 +++-
 engines/io_uring.c | 10 ++--------
 fio.1              |  4 +++-
 3 files changed, 8 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 2a57f60a..504a64b8 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2591,7 +2591,9 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: md_per_io_size=int : [io_uring_cmd] [xnvme]
 
-	Size in bytes for separate metadata buffer per IO. Default: 0.
+        Size in bytes for separate metadata buffer per IO. For io_uring_cmd
+        these buffers are allocated using malloc regardless of what is set for
+        :option:`iomem`. Default: 0.
 
 .. option:: pi_act=int : [io_uring_cmd] [xnvme]
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 79eacbc4..facc967f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1353,14 +1353,8 @@ static int fio_ioring_init(struct thread_data *td)
 		md_size += page_mask + td->o.mem_align;
 		if (td->o.mem_align && td->o.mem_align > page_size)
 			md_size += td->o.mem_align - page_size;
-		if (td->o.mem_type == MEM_MALLOC) {
-			ld->md_buf = malloc(md_size);
-			if (!ld->md_buf) {
-				free(ld);
-				return 1;
-			}
-		} else {
-			log_err("fio: Only iomem=malloc or mem=malloc is supported\n");
+		ld->md_buf = malloc(md_size);
+		if (!ld->md_buf) {
 			free(ld);
 			return 1;
 		}
diff --git a/fio.1 b/fio.1
index 53fb7849..3c5f02b3 100644
--- a/fio.1
+++ b/fio.1
@@ -2361,7 +2361,9 @@ this option is specified, the option \fBplids\fP or \fBfdp_pli\fP will be ignore
 .RE
 .TP
 .BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
-Size in bytes for separate metadata buffer per IO. Default: 0.
+Size in bytes for separate metadata buffer per IO. For io_uring_cmd these
+buffers are allocated using malloc regardless of what is set for \fBiomem\fR.
+Default: 0.
 .TP
 .BI (io_uring_cmd,xnvme)pi_act \fR=\fPint
 Action to take when nvme namespace is formatted with protection information.
