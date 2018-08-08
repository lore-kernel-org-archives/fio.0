Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33748 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbeHHOTj (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Aug 2018 10:19:39 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fnN8S-0008NX-RA
        for fio@vger.kernel.org; Wed, 08 Aug 2018 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180808120001.5A33F2C0311@kernel.dk>
Date: Wed,  8 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b87ed299820c26e8c4271294b0c5037e8d0a3d4a:

  client: support --status-interval option in client/server mode (2018-08-05 15:12:12 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ce58465415fc4d900c4dd89b86acbcaa51d9dfb:

  libpmem: fix type print (2018-08-07 08:09:47 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      libpmem: fix type print

 engines/libpmem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libpmem.c b/engines/libpmem.c
index 4ef3094..99c7b50 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -424,10 +424,10 @@ static int fio_libpmem_prep(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * It fits within existing mapping, use it
 	 */
-	dprint(FD_IO," io_u->offset %lld : fdd->libpmem_off %ld : "
-			"io_u->buflen %ld : fdd->libpmem_sz %ld\n",
-			io_u->offset, fdd->libpmem_off,
-			io_u->buflen, fdd->libpmem_sz);
+	dprint(FD_IO," io_u->offset %llu : fdd->libpmem_off %llu : "
+			"io_u->buflen %llu : fdd->libpmem_sz %llu\n",
+			io_u->offset, (unsigned long long) fdd->libpmem_off,
+			io_u->buflen, (unsigned long long) fdd->libpmem_sz);
 
 	if (io_u->offset >= fdd->libpmem_off &&
 	    (io_u->offset + io_u->buflen <=
