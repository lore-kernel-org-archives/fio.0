Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48508 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbeIDQZG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 4 Sep 2018 12:25:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fxA0E-00068E-WF
        for fio@vger.kernel.org; Tue, 04 Sep 2018 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180904120001.9E7D02C00A1@kernel.dk>
Date: Tue,  4 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7df9ac895f4af7ac4500379d5a5e204be9210fb2:

  client: fix nr_samples (2018-08-31 12:43:59 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 53ee8c17adb00e3db4f2c9441777ba777390cb9f:

  engines/sg: improve error handling (2018-09-03 09:01:14 -0600)

----------------------------------------------------------------
Vincent Fu (1):
      engines/sg: improve error handling

 engines/sg.c | 49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/engines/sg.c b/engines/sg.c
index 7741f83..3cc068f 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -675,36 +675,37 @@ static int fio_sgio_commit(struct thread_data *td)
 
 	ret = fio_sgio_rw_doio(io_u->file, io_u, 0);
 
-	if (ret < 0)
-		for (i = 0; i < st->unmap_range_count; i++)
-			st->trim_io_us[i]->error = errno;
-	else if (hdr->status)
-		for (i = 0; i < st->unmap_range_count; i++) {
-			st->trim_io_us[i]->resid = hdr->resid;
-			st->trim_io_us[i]->error = EIO;
+	if (ret < 0 || hdr->status) {
+		int error;
+
+		if (ret < 0)
+			error = errno;
+		else {
+			error = EIO;
+			ret = -EIO;
 		}
-	else {
-		if (fio_fill_issue_time(td)) {
-			fio_gettime(&now, NULL);
-			for (i = 0; i < st->unmap_range_count; i++) {
-				struct io_u *io_u = st->trim_io_us[i];
-
-				memcpy(&io_u->issue_time, &now, sizeof(now));
-				io_u_queued(td, io_u);
-			}
+
+		for (i = 0; i < st->unmap_range_count; i++) {
+			st->trim_io_us[i]->error = error;
+			clear_io_u(td, st->trim_io_us[i]);
+			if (hdr->status)
+				st->trim_io_us[i]->resid = hdr->resid;
 		}
-		io_u_mark_submit(td, st->unmap_range_count);
+
+		td_verror(td, error, "xfer");
+		return ret;
 	}
 
-	if (io_u->error) {
-		td_verror(td, io_u->error, "xfer");
-		return 0;
+	if (fio_fill_issue_time(td)) {
+		fio_gettime(&now, NULL);
+		for (i = 0; i < st->unmap_range_count; i++) {
+			memcpy(&st->trim_io_us[i]->issue_time, &now, sizeof(now));
+			io_u_queued(td, io_u);
+		}
 	}
+	io_u_mark_submit(td, st->unmap_range_count);
 
-	if (ret == FIO_Q_QUEUED)
-		return 0;
-	else
-		return ret;
+	return 0;
 }
 
 static struct io_u *fio_sgio_event(struct thread_data *td, int event)

