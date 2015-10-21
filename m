Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbbJUMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 21 Oct 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zos3m-0007WY-TC
	for fio@vger.kernel.org; Wed, 21 Oct 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151021120002.0D0402C0A2E@kernel.dk>
Date: Wed, 21 Oct 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4d400e92d60d2c8e02f30c5eba41238567e6e603:

  strlcat: fix header guard typo (2015-10-19 22:37:39 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d2235e56057f54fc63ccbf789d4c54f9e99978af:

  client: remove duplicated code (2015-10-20 09:07:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      client: remove duplicated code

 backend.c | 2 +-
 client.c  | 5 -----
 fio.h     | 1 +
 3 files changed, 2 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index b1477df..8fd5535 100644
--- a/backend.c
+++ b/backend.c
@@ -100,7 +100,7 @@ static void sig_int(int sig)
 	}
 }
 
-static void sig_show_status(int sig)
+void sig_show_status(int sig)
 {
 	show_running_run_stats();
 }
diff --git a/client.c b/client.c
index 147ee38..005ddf4 100644
--- a/client.c
+++ b/client.c
@@ -534,11 +534,6 @@ static void sig_int(int sig)
 	fio_clients_terminate();
 }
 
-static void sig_show_status(int sig)
-{
-	show_running_run_stats();
-}
-
 static void client_signal_handler(void)
 {
 	struct sigaction act;
diff --git a/fio.h b/fio.h
index a00e8f2..adf879f 100644
--- a/fio.h
+++ b/fio.h
@@ -483,6 +483,7 @@ extern int ioengine_load(struct thread_data *);
 extern int parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
 extern int fio_set_fd_nonblocking(int, const char *);
+extern void sig_show_status(int sig);
 
 extern uintptr_t page_mask;
 extern uintptr_t page_size;
