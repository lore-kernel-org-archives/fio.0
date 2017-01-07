Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935166AbdAGNAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Jan 2017 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cPqbK-0005Fu-Tt
        for fio@vger.kernel.org; Sat, 07 Jan 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170107130001.A2D962C00B7@kernel.dk>
Date: Sat,  7 Jan 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8c4e634a44ca35a21387b79ae6e701f951e2cb0c:

  init: cleaner gcd() (2017-01-05 10:38:41 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 28c43a89ae13b648dd37269d288fbbea2550faa8:

  Fix comment on SCSI commands (2017-01-06 11:26:04 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (2):
      Remove doubled ; in .c
      Fix comment on SCSI commands

 engines/net.c | 2 +-
 engines/sg.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/net.c b/engines/net.c
index 3bdd5cd..37d44fd 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1371,7 +1371,7 @@ static int fio_netio_setup(struct thread_data *td)
 	}
 
 	if (!td->io_ops_data) {
-		nd = malloc(sizeof(*nd));;
+		nd = malloc(sizeof(*nd));
 
 		memset(nd, 0, sizeof(*nd));
 		nd->listenfd = -1;
diff --git a/engines/sg.c b/engines/sg.c
index 001193d..2ad3394 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -425,8 +425,8 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 	 */
 	if (*max_lba == MAX_10B_LBA) {
 		hdr.cmd_len = 16;
-		hdr.cmdp[0] = 0x9e; // Read Capacity(16)
-		hdr.cmdp[1] = 0x10; // service action
+		hdr.cmdp[0] = 0x9e; // service action
+		hdr.cmdp[1] = 0x10; // Read Capacity(16)
 		hdr.cmdp[10] = (unsigned char) ((sizeof(buf) >> 24) & 0xff);
 		hdr.cmdp[11] = (unsigned char) ((sizeof(buf) >> 16) & 0xff);
 		hdr.cmdp[12] = (unsigned char) ((sizeof(buf) >> 8) & 0xff);
