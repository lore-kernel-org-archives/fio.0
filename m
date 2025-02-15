Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638915A843
	for <fio@vger.kernel.org>; Sat, 15 Feb 2025 08:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739608910; cv=none; b=a7J1rb9n5ugsjwbLMfWXaog1sJZBWJgRI395PFPVEVL6Yz7CFzKssraTenrjWzzatJPxIMdKHgRHH/qBGv3KXf0DNQHtPwQVtt94mmnanXzwwpvrZUbncLKcAIlTcp+HOfFwzKs0iIGexdXEnnLKm53cJkZbwKXqXfw2JgGps8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739608910; c=relaxed/simple;
	bh=Dl9t6uY2EUAafUyiF5rwNMQZZPUGd1ot3wcHwkKnz1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YQal7NcZ3p9NUYnsan6GV18NkROwgox5uT21NYf/BzB27CoJ103gvUrk6RUNlt7OXLGi2ejuXQ2xy0591Kd3BupYa0STNmHqrgedFWTIMV0jk0AdULVNcOXq0f8GoO/vyOD4sq2SOCLy97kiUJAhqtP/3HXzA/wWxzBFD9L1Kgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aC3q3WKA; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aC3q3WKA"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21f44e7eae4so54327685ad.2
        for <fio@vger.kernel.org>; Sat, 15 Feb 2025 00:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739608908; x=1740213708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t6Jhl2SQTqdHopom6X5nrtCn8tGFW6RoVj4qgS2m0uU=;
        b=aC3q3WKAwmSmKY+oa0MiUjFdzuF3keO844B6TMIgKrwWxLzbiEXaCM7rZ2ObW22G4y
         aqc4Uyib6IrxxQU4bxHZBZ2PC5uTrIi4gJxZE7FWMy4mWd53Wf8Oo1FJF7aC4eiNbkjR
         2SNWP3SyZrx9E24KOBoEZIIwiujKKy+drMzAtMhlSR9QWWlQb9jPA0BExuNxehFRKzu8
         o7tggx4+VMyp91Qzyre8Y9tl1vS2BPFJuAG6uPYCRSn1sy+yLrpWLPcL/gmw/Ekt4Si1
         DLXS9HtPTOGuigEX9vGH6btIlBXjZz3nUJLQH4mLZljNsaevkk87Fm2Bu0z4pMEtwEch
         yUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739608908; x=1740213708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6Jhl2SQTqdHopom6X5nrtCn8tGFW6RoVj4qgS2m0uU=;
        b=X6PKkvHOftmXEVWrIurrYflKGia5lvqPyZHo+XY4V3JzusxWFszB3eqjS2x2bcfdu4
         1hsW0ORj4utdjvBWHGBkhDfCPHiESTjDFfOdNQeffTlXHM39h3CiUEI2Vk5zOIvGr+mX
         VN6HbXcLsP33dxpboXPyGAzI3an3pie5/f0+6LGjTZ1PZBagPq7uM3joj/vGjvfx+F7c
         cfeloz3jAQI8uG2MzlRDACo2a01DLY15LpDr4WtY9d4oO9gm/omwV3ywyc4JfqMPDTV/
         HLwv979SJFRyQOTX+SLbsSYf06w7g8+hzM+U4me4C7M9XfyFVDEr0ci/YNVLT+fLa1IL
         VDVQ==
X-Gm-Message-State: AOJu0YzZJ4wCScJZEBEJDdk7LxLrlDTEvkgCEdZ+96jP4J4PKgGseZLO
	7BE83c7aK+C7fKZQT+TexUwQM3HD93wl48F4Gz1Pbtyl/52k4qRevYoCUw==
X-Gm-Gg: ASbGncuU/ELMD3TZ0tC2s6Jej8Yz5ShP0E6lofJsQ++HZp0PEwWNAoFhTbFeKVwCP50
	VlpUlq0u9xs5NZzDqxdLHZMrcSvqtDBVWqNDnB/ZGufgk0HrJ83u/MJDl/26QBrx+yWoLUxVXT/
	5iGkqEXGdjV5R09eSXmo8lZb02nywOKR14MbfN8+zDCpmn9OcybD1WbBkGBL/uPpc3JwMDKLF1c
	GNR6zWi9EjOMlPIjPOofUOcZkSmNWNz8Ax2mR4JlQlP1tDUgpAt+Ogz1OkGoJ+D/+Zjd3Z6yoC6
	v1tHWvND6vEpBgJUD2aVTw==
X-Google-Smtp-Source: AGHT+IGV1+JRx2RqRd+1ntwvkqRmpy01bjMrp+xIeLfTvbJ4dMIRTmmchl03wAWPUvS+IgxDaTwwWg==
X-Received: by 2002:a05:6a21:998d:b0:1e0:cbd1:8046 with SMTP id adf61e73a8af0-1ee8c99080dmr4662699637.0.1739608907656;
        Sat, 15 Feb 2025 00:41:47 -0800 (PST)
Received: from dw-tp.ibmuc.com ([171.76.86.175])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-adb5813a4c2sm4031320a12.24.2025.02.15.00.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2025 00:41:47 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH] libaio: Add vectored io support
Date: Sat, 15 Feb 2025 14:11:30 +0530
Message-ID: <f0d66512e3df3d2142910e996c42389c21232d12.1739608655.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds support for doing vectored I/O to libaio.
Instead of using pread/pwrite calls, this allows libaio to use
preadv/pwritev calls which uses iovecs.
option: libaio_vectored=1

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 HOWTO.rst        |  4 ++++
 engines/libaio.c | 37 +++++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 504a64b8..3f2bde18 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2515,6 +2515,10 @@ with the caveat that when used on the command line, they must come after the
 	not support torn-write protection. To learn a file's torn-write limits, issue
 	statx with STATX_WRITE_ATOMIC.

+.. option:: libaio_vectored=bool : [libaio]
+
+    Submit vectored read and write requests.
+
 .. option:: fdp=bool : [io_uring_cmd] [xnvme]

 	Enable Flexible Data Placement mode for write commands.
diff --git a/engines/libaio.c b/engines/libaio.c
index c2d43793..aff4025e 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -37,6 +37,7 @@ struct libaio_data {
 	struct io_u **io_us;

 	struct io_u **io_u_index;
+	struct iovec *iovecs;		/* for vectored requests */

 	/*
 	 * Basic ring buffer. 'head' is incremented in _queue(), and
@@ -60,6 +61,7 @@ struct libaio_options {
 	unsigned int userspace_reap;
 	struct cmdprio_options cmdprio_options;
 	unsigned int nowait;
+	unsigned int vectored;
 };

 static struct fio_option options[] = {
@@ -81,6 +83,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	= "libaio_vectored",
+		.lname	= "Use libaio preadv,pwritev",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct libaio_options, vectored),
+		.help	= "Use libaio {preadv,pwritev} instead of libaio {pread,pwrite}",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+
 	CMDPRIO_OPTIONS(struct libaio_options, FIO_OPT_G_LIBAIO),
 	{
 		.name	= NULL,
@@ -101,13 +113,32 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 	struct libaio_options *o = td->eo;
 	struct fio_file *f = io_u->file;
 	struct iocb *iocb = &io_u->iocb;
+	struct libaio_data *ld = td->io_ops_data;

 	if (io_u->ddir == DDIR_READ) {
-		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->vectored) {
+			struct iovec *iov = &ld->iovecs[io_u->index];
+
+			iov->iov_base = io_u->xfer_buf;
+			iov->iov_len = (size_t)io_u->xfer_buflen;
+			io_prep_preadv(iocb, f->fd, iov, 1, io_u->offset);
+		} else {
+			io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen,
+						  io_u->offset);
+		}
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (io_u->ddir == DDIR_WRITE) {
-		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->vectored) {
+			struct iovec *iov = &ld->iovecs[io_u->index];
+
+			iov->iov_base = io_u->xfer_buf;
+			iov->iov_len = (size_t)io_u->xfer_buflen;
+			io_prep_pwritev(iocb, f->fd, iov, 1, io_u->offset);
+		} else {
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen,
+						   io_u->offset);
+		}
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 #ifdef FIO_HAVE_RWF_ATOMIC
@@ -394,6 +425,7 @@ static void fio_libaio_cleanup(struct thread_data *td)
 			io_destroy(ld->aio_ctx);

 		fio_cmdprio_cleanup(&ld->cmdprio);
+		free(ld->iovecs);
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
@@ -428,6 +460,7 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->aio_events = calloc(ld->entries, sizeof(struct io_event));
 	ld->iocbs = calloc(ld->entries, sizeof(struct iocb *));
 	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
+	ld->iovecs = calloc(ld->entries, sizeof(ld->iovecs[0]));

 	td->io_ops_data = ld;

--
2.39.5

