Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48520 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388614AbfIXMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Sep 2019 08:00:06 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iCjUC-0008I5-2T
        for fio@vger.kernel.org; Tue, 24 Sep 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190924120001.543E62C02C4@kernel.dk>
Date: Tue, 24 Sep 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 92f75708b530989fdb13b50be6604f44b80d038d:

  Fio 3.16 (2019-09-19 19:01:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3982ec03ab0c125d01b62876f5139b2c07082c7a:

  verify: check that the block size is big enough (2019-09-24 02:43:39 -0600)

----------------------------------------------------------------
Anatol Pomozov (1):
      Fix compilation error with gfio

Jens Axboe (2):
      Merge branch 'master' of https://github.com/anatol/fio
      verify: check that the block size is big enough

 gclient.c | 2 +-
 verify.c  | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/gclient.c b/gclient.c
index 64324177..d8dc62d2 100644
--- a/gclient.c
+++ b/gclient.c
@@ -330,7 +330,7 @@ static void gfio_update_thread_status_all(struct gui *ui, char *status_message,
 	static char message[100];
 	const char *m = message;
 
-	strncpy(message, sizeof(message), "%s", status_message);
+	snprintf(message, sizeof(message), "%s", status_message);
 	gtk_progress_bar_set_text(GTK_PROGRESS_BAR(ui->thread_status_pb), m);
 	gtk_progress_bar_set_fraction(GTK_PROGRESS_BAR(ui->thread_status_pb), perc / 100.0);
 	gtk_widget_queue_draw(ui->window);
diff --git a/verify.c b/verify.c
index 48ba051d..37d2be8d 100644
--- a/verify.c
+++ b/verify.c
@@ -1191,6 +1191,10 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 
 	fill_hdr(td, io_u, hdr, header_num, header_len, io_u->rand_seed);
 
+	if (header_len <= hdr_size(td, hdr)) {
+		td_verror(td, EINVAL, "Blocksize too small");
+		return;
+	}
 	data_len = header_len - hdr_size(td, hdr);
 
 	data = p + hdr_size(td, hdr);

