Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaF1MAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 28 Jun 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X0rIa-000549-MU
	for fio@vger.kernel.org; Sat, 28 Jun 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140628120003.987F540076@lyth.info>
Date: Sat, 28 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4445856ab659ffa41bdb8f5b81aa00704c50a5c6:

  Verify: Tighten header length check in verify_header() (2014-06-26 19:30:16 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 372d89627cc04b5f30193ad8df762f86a580596d:

  Fix typo in io_u.c::get_next_file() (2014-06-27 20:21:22 -0600)

----------------------------------------------------------------
Andrey Kuzmin (1):
      Fix typo in io_u.c::get_next_file()

Jens Axboe (3):
      Fix struct jobs_eta packing on 32 vs 64-bit archs
      eta: only pass real size of jobs_eta
      client: fix ETA run_str

 client.c |   10 +++++++---
 eta.c    |    1 +
 io_u.c   |    2 +-
 stat.h   |    5 +++++
 4 files changed, 14 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index af6621d..828dd97 100644
--- a/client.c
+++ b/client.c
@@ -987,7 +987,12 @@ void fio_client_sum_jobs_eta(struct jobs_eta *dst, struct jobs_eta *je)
 		dst->eta_sec = je->eta_sec;
 
 	dst->nr_threads		+= je->nr_threads;
-	/* we need to handle je->run_str too ... */
+
+	/*
+	 * This wont be correct for multiple strings, but at least it
+	 * works for the basic cases.
+	 */
+	strcpy((char *) dst->run_str, (char *) je->run_str);
 }
 
 void fio_client_dec_jobs_eta(struct client_eta *eta, client_eta_op eta_fn)
@@ -1374,8 +1379,7 @@ static void request_client_etas(struct client_ops *ops)
 
 	dprint(FD_NET, "client: request eta (%d)\n", nr_clients);
 
-	eta = malloc(sizeof(*eta));
-	memset(&eta->eta, 0, sizeof(eta->eta));
+	eta = calloc(1, sizeof(*eta) + __THREAD_RUNSTR_SZ(REAL_MAX_JOBS));
 	eta->pending = nr_clients;
 
 	flist_for_each(entry, &client_list) {
diff --git a/eta.c b/eta.c
index 850a784..0105cda 100644
--- a/eta.c
+++ b/eta.c
@@ -581,6 +581,7 @@ struct jobs_eta *get_jobs_eta(int force, size_t *size)
 		return NULL;
 	}
 
+	*size = sizeof(*je) + strlen((char *) je->run_str) + 1;
 	return je;
 }
 
diff --git a/io_u.c b/io_u.c
index e132fd9..997e113 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1100,7 +1100,7 @@ out:
 
 static struct fio_file *get_next_file(struct thread_data *td)
 {
-	if (!(td->flags & TD_F_PROFILE_OPS)) {
+	if (td->flags & TD_F_PROFILE_OPS) {
 		struct prof_io_ops *ops = &td->prof_io_ops;
 
 		if (ops->get_next_file)
diff --git a/stat.h b/stat.h
index 6f9d82a..fb1485d 100644
--- a/stat.h
+++ b/stat.h
@@ -186,9 +186,13 @@ struct thread_stat {
 struct jobs_eta {
 	uint32_t nr_running;
 	uint32_t nr_ramp;
+
 	uint32_t nr_pending;
 	uint32_t nr_setting_up;
+
 	uint32_t files_open;
+	uint32_t pad1;
+
 	uint32_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
 	uint32_t m_iops[DDIR_RWDIR_CNT], t_iops[DDIR_RWDIR_CNT];
 	uint32_t rate[DDIR_RWDIR_CNT];
@@ -202,6 +206,7 @@ struct jobs_eta {
 	 * Network 'copy' of run_str[]
 	 */
 	uint32_t nr_threads;
+	uint32_t pad2;
 	uint8_t run_str[];
 };
 
