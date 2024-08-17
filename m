Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7A514A635
	for <fio@vger.kernel.org>; Sat, 17 Aug 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723896011; cv=none; b=AnSCSinOfa4ONEO/N8mATegJbnsOR4WsgR7lOrBmiLr5DEqmQCfJ/FBeXrE54pyEkhMuFz+zFYf23rhmR5dgEfPyYXE15ko1wmD78GOLXUYIMvk3o9ud/SzJelxBXKgNrayZ3whobK9pZgk7/RgTW9knBB55qlVJBGKWalGvxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723896011; c=relaxed/simple;
	bh=Iohp7eGNGACCo+M/LY5oQH3J0rt7JHijoDdSojcrYT0=;
	h=Subject:From:To:Message-Id:Date; b=Mr2V23YcP1+OhECjSOfPaN+9sJyUAW5gsJsCHSCmR1lXU+JHgKn3TAxiGdIzzorgn3BWoNpdlYe3c/kB9IUe5Ff7bO9NpXZ778FfsXFDhL9tsJu45lr+58wnnrSW8ko+YSI37tW2q1fbS6glWyN8ABAEpDHoowPzbF0QqQm/ruU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gB+jrakC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gB+jrakC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=MR9pNZNjebi0b70yy7dLs1ggN5t9tXjtOHl48M0/1U0=; b=gB+jrakCg2kEFtwzxbCehUPKdd
	EYfAoaBxQc/cBiuPnDO6bPw1pSeMS+EcvfiWpjT7rMVy5+cgi1GTuAVfUK1Z5oHu6BiQrOLgNbTqt
	euoF/LZQNFv1hxyARXWVxjX3hlsQh4HerCSC5Cifd3S3+9jSwnWRvcFs9+kpCuZemVXGqgTBo/zGK
	DTVR8ADfWZ4twZFG1FgWU5Iw6JqXy/eJ+Bh1QyBtWJ+Lt0e38t3aJktn4Eiq8440K00+A7Z2wllYU
	B+f3ehzxcxJBrvf//kb4TUuFmYZJNaItOkux9LSjhLODreq363LotlfDS2/qMkdrWQ45QlgBLLp7U
	gqV/tvfw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sfI6G-00000004k7j-1kKj
	for fio@vger.kernel.org;
	Sat, 17 Aug 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D7E5A1BC0139; Sat, 17 Aug 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240817120001.D7E5A1BC0139@kernel.dk>
Date: Sat, 17 Aug 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 55b10ccca6a2ba623360a38c3fdf7332461646bb:

  Merge branch 'master' of https://github.com/scaleoutsean/fio (2024-08-06 09:17:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7bc12310ac39f8bf694a6785d027e4cee96dbbdf:

  Merge branch 'errdetails' of https://github.com/minwooim/fio (2024-08-16 08:21:20 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'errdetails' of https://github.com/minwooim/fio

Minwoo Im (2):
      ioengines: Add thread_data to .errdetails
      io_uring: Add .errdetails to parse CQ status

 engines/io_uring.c    | 34 ++++++++++++++++++++++++++++++++++
 engines/librpma_fio.c |  2 +-
 engines/librpma_fio.h |  2 +-
 engines/sg.c          |  2 +-
 io_u.c                |  2 +-
 ioengines.h           |  4 ++--
 6 files changed, 40 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 334c77b9..bfbdc3b4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -554,6 +554,39 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	return io_u;
 }
 
+static char *fio_ioring_cmd_errdetails(struct thread_data *td,
+				       struct io_u *io_u)
+{
+	struct ioring_options *o = td->eo;
+	unsigned int sct = (io_u->error >> 8) & 0x7;
+	unsigned int sc = io_u->error & 0xff;
+#define MAXERRDETAIL 1024
+#define MAXMSGCHUNK 128
+	char *msg, msgchunk[MAXMSGCHUNK];
+
+	msg = calloc(1, MAXERRDETAIL);
+	strcpy(msg, "io_uring_cmd: ");
+
+	snprintf(msgchunk, MAXMSGCHUNK, "%s: ", io_u->file->file_name);
+	strlcat(msg, msgchunk, MAXERRDETAIL);
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		strlcat(msg, "cq entry status (", MAXERRDETAIL);
+
+		snprintf(msgchunk, MAXMSGCHUNK, "sct=0x%02x; ", sct);
+		strlcat(msg, msgchunk, MAXERRDETAIL);
+
+		snprintf(msgchunk, MAXMSGCHUNK, "sc=0x%02x)", sc);
+		strlcat(msg, msgchunk, MAXERRDETAIL);
+	} else {
+		/* Print status code in generic */
+		snprintf(msgchunk, MAXMSGCHUNK, "status=0x%x", io_u->error);
+		strlcat(msg, msgchunk, MAXERRDETAIL);
+	}
+
+	return msg;
+}
+
 static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 				   unsigned int max)
 {
@@ -1590,6 +1623,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.commit			= fio_ioring_commit,
 	.getevents		= fio_ioring_getevents,
 	.event			= fio_ioring_cmd_event,
+	.errdetails		= fio_ioring_cmd_errdetails,
 	.cleanup		= fio_ioring_cleanup,
 	.open_file		= fio_ioring_cmd_open_file,
 	.close_file		= fio_ioring_cmd_close_file,
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index 42d6163e..4ccc6d0b 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -790,7 +790,7 @@ struct io_u *librpma_fio_client_event(struct thread_data *td, int event)
 	return io_u;
 }
 
-char *librpma_fio_client_errdetails(struct io_u *io_u)
+char *librpma_fio_client_errdetails(struct thread_data *td, struct io_u *io_u)
 {
 	/* get the string representation of an error */
 	enum ibv_wc_status status = io_u->error;
diff --git a/engines/librpma_fio.h b/engines/librpma_fio.h
index 480ded1b..2bcbb378 100644
--- a/engines/librpma_fio.h
+++ b/engines/librpma_fio.h
@@ -162,7 +162,7 @@ int librpma_fio_client_getevents(struct thread_data *td, unsigned int min,
 
 struct io_u *librpma_fio_client_event(struct thread_data *td, int event);
 
-char *librpma_fio_client_errdetails(struct io_u *io_u);
+char *librpma_fio_client_errdetails(struct thread_data *td, struct io_u *io_u);
 
 static inline int librpma_fio_client_io_read(struct thread_data *td,
 		struct io_u *io_u, int flags)
diff --git a/engines/sg.c b/engines/sg.c
index 0bb5be4a..9df70bd2 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -1154,7 +1154,7 @@ int fio_sgio_close(struct thread_data *td, struct fio_file *f)
  * Build an error string with details about the driver, host or scsi
  * error contained in the sg header Caller will use as necessary.
  */
-static char *fio_sgio_errdetails(struct io_u *io_u)
+static char *fio_sgio_errdetails(struct thread_data *td, struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
 #define MAXERRDETAIL 1024
diff --git a/io_u.c b/io_u.c
index f81086b6..40b09082 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1963,7 +1963,7 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 	zbd_log_err(td, io_u);
 
 	if (td->io_ops->errdetails) {
-		char *err = td->io_ops->errdetails(io_u);
+		char *err = td->io_ops->errdetails(td, io_u);
 
 		log_err("fio: %s\n", err);
 		free(err);
diff --git a/ioengines.h b/ioengines.h
index 6039d41e..b9834fec 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "dataplacement.h"
 
-#define FIO_IOOPS_VERSION	35
+#define FIO_IOOPS_VERSION	36
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -40,7 +40,7 @@ struct ioengine_ops {
 	int (*commit)(struct thread_data *);
 	int (*getevents)(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
 	struct io_u *(*event)(struct thread_data *, int);
-	char *(*errdetails)(struct io_u *);
+	char *(*errdetails)(struct thread_data *, struct io_u *);
 	int (*cancel)(struct thread_data *, struct io_u *);
 	void (*cleanup)(struct thread_data *);
 	int (*open_file)(struct thread_data *, struct fio_file *);
