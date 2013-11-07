Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45194 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3KGE55 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 Nov 2013 23:57:57 -0500
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1VeHfJ-00044E-7w
	for fio@vger.kernel.org; Thu, 07 Nov 2013 04:57:57 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20131107050003.5546221169@kernel.dk>
Date: Thu,  7 Nov 2013 06:00:03 +0100 (CET)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 30e472c9a11dcdd02e2b38b510c27cc3deb95931:

  Fix a couple of typos in fio2gnuplot. (2013-11-04 08:08:39 -0700)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (2):
      server: get rid of compile warning on platforms where pid_t isn't int
      posixaio: fix thread problem with using errno

 engines/posixaio.c |    8 +++++---
 server.c           |    8 ++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/engines/posixaio.c b/engines/posixaio.c
index a2b5387..2df26af 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -196,18 +196,20 @@ static int fio_posixaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 #endif
 	}
-		
+
 	if (ret) {
+		int aio_err = aio_error(aiocb);
+
 		/*
 		 * At least OSX has a very low limit on the number of pending
 		 * IOs, so if it returns EAGAIN, we are out of resources
 		 * to queue more. Just return FIO_Q_BUSY to naturally
 		 * drop off at this depth.
 		 */
-		if (errno == EAGAIN)
+		if (aio_err == EAGAIN)
 			return FIO_Q_BUSY;
 
-		io_u->error = errno;
+		io_u->error = aio_err;
 		td_verror(td, io_u->error, "xfer");
 		return FIO_Q_COMPLETED;
 	}
diff --git a/server.c b/server.c
index 3d31cbf..ac4bf33 100644
--- a/server.c
+++ b/server.c
@@ -473,13 +473,13 @@ static void fio_server_add_fork_item(pid_t pid, struct flist_head *list)
 
 static void fio_server_add_conn_pid(pid_t pid)
 {
-	dprint(FD_NET, "server: forked off connection job (pid=%u)\n", pid);
+	dprint(FD_NET, "server: forked off connection job (pid=%u)\n", (int) pid);
 	fio_server_add_fork_item(pid, &conn_list);
 }
 
 static void fio_server_add_job_pid(pid_t pid)
 {
-	dprint(FD_NET, "server: forked off job job (pid=%u)\n", pid);
+	dprint(FD_NET, "server: forked off job job (pid=%u)\n", (int) pid);
 	fio_server_add_fork_item(pid, &job_list);
 }
 
@@ -490,7 +490,7 @@ static void fio_server_check_fork_item(struct fio_fork_item *ffi)
 	ret = waitpid(ffi->pid, &status, WNOHANG);
 	if (ret < 0) {
 		if (errno == ECHILD) {
-			log_err("fio: connection pid %u disappeared\n", ffi->pid);
+			log_err("fio: connection pid %u disappeared\n", (int) ffi->pid);
 			ffi->exited = 1;
 		} else
 			log_err("fio: waitpid: %s\n", strerror(errno));
@@ -509,7 +509,7 @@ static void fio_server_check_fork_item(struct fio_fork_item *ffi)
 
 static void fio_server_fork_item_done(struct fio_fork_item *ffi)
 {
-	dprint(FD_NET, "pid %u exited, sig=%u, exitval=%d\n", ffi->pid, ffi->signal, ffi->exitval);
+	dprint(FD_NET, "pid %u exited, sig=%u, exitval=%d\n", (int) ffi->pid, ffi->signal, ffi->exitval);
 
 	/*
 	 * Fold STOP and QUIT...
