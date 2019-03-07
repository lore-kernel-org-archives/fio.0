Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51674 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfCGNAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Mar 2019 08:00:22 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h1sdJ-0005o4-BO
        for fio@vger.kernel.org; Thu, 07 Mar 2019 13:00:21 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190307130001.CBF962C0049@kernel.dk>
Date: Thu,  7 Mar 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7508b3948a216106196cec33a3a707d6f32d84a8:

  engines/sg: ensure we flag EIO on the right io_u (2019-02-28 10:08:08 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to be26a9823261c15c6e737e2e6c8762423cf325b8:

  t/io_uring: stop when max number of files is reached (2019-03-06 08:24:38 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: stop when max number of files is reached

 t/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 7c75c887..c7139f87 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -501,13 +501,19 @@ int main(int argc, char *argv[])
 
 	i = 1;
 	while (!do_nop && i < argc) {
-		struct file *f = &s->files[s->nr_files];
+		struct file *f;
 
+		if (s->nr_files == MAX_FDS) {
+			printf("Max number of files (%d) reached\n", MAX_FDS);
+			break;
+		}
 		fd = open(argv[i], flags);
 		if (fd < 0) {
 			perror("open");
 			return 1;
 		}
+
+		f = &s->files[s->nr_files];
 		f->real_fd = fd;
 		if (get_file_size(f)) {
 			printf("failed getting size of device/file\n");

