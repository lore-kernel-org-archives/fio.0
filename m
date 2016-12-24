Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39696 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbcLXNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Dec 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cKlvg-0000lE-HK
        for fio@vger.kernel.org; Sat, 24 Dec 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161224130002.7894A2C1D80@kernel.dk>
Date: Sat, 24 Dec 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3ee2a3c1ae52841ecb4926ab5748e6d856fd4b2c:

  fio: Add support for auto detect dev-dax and libpmemblk engines (2016-12-20 16:43:36 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 35448275f6577483f2a5f98db27f28bd3257ddb5:

  rbd: style fixups (2016-12-23 19:54:47 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      rbd: style fixups

Pan Liu (1):
      rbd: remove duplicate _fio_rbd_connect

 engines/rbd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index ee2ce81..62f0b2e 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -36,6 +36,7 @@ struct rbd_data {
 	struct io_u **aio_events;
 	struct io_u **sort_events;
 	int fd; /* add for poll */
+	bool connected;
 };
 
 struct rbd_options {
@@ -111,6 +112,8 @@ static int _fio_setup_rbd_data(struct thread_data *td,
 	if (!rbd)
 		goto failed;
 
+	rbd->connected = false;
+
 	/* add for poll, init fd: -1 */
 	rbd->fd = -1;
 
@@ -529,6 +532,10 @@ failed:
 static int fio_rbd_init(struct thread_data *td)
 {
 	int r;
+	struct rbd_data *rbd = td->io_ops_data;
+
+	if (rbd->connected)
+		return 0;
 
 	r = _fio_rbd_connect(td);
 	if (r) {
@@ -589,6 +596,7 @@ static int fio_rbd_setup(struct thread_data *td)
 		log_err("fio_rbd_connect failed.\n");
 		goto cleanup;
 	}
+	rbd->connected = true;
 
 	/* get size of the RADOS block device */
 	r = rbd_stat(rbd->image, &info, sizeof(info));
@@ -618,7 +626,6 @@ static int fio_rbd_setup(struct thread_data *td)
 	/* disconnect, then we were only connected to determine
 	 * the size of the RBD.
 	 */
-	_fio_rbd_disconnect(rbd);
 	return 0;
 
 disconnect:
