Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbHOMAf (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 15 Aug 2015 08:00:35 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZQa8X-0005QL-A1
	for fio@vger.kernel.org; Sat, 15 Aug 2015 12:00:33 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150815120002.61A112C00BE@kernel.dk>
Date: Sat, 15 Aug 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 92060d6c59f1848e86cd9ddd7550907c79bda3d5:

  arch-ppc.h: Add ilog2 implementation for ppc64 (2015-08-13 12:45:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 75f90d5f9859e985feee8b6aca7b913d15fd2296:

  filesetup: make random generator block auto-switch on huge files (2015-08-14 12:25:20 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      eta: ensure we include terminating 0 space in je->run_str[]
      client: make it explicit that we don't reuse 'eta' after freeing it
      filesetup: make random generator block auto-switch on huge files

 client.c    | 25 +++++++++++++++----------
 client.h    |  1 -
 eta.c       |  2 +-
 filesetup.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 54 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index af3407c..110a01b 100644
--- a/client.c
+++ b/client.c
@@ -184,6 +184,17 @@ void fio_put_client(struct fio_client *client)
 	free(client);
 }
 
+static int fio_client_dec_jobs_eta(struct client_eta *eta, client_eta_op eta_fn)
+{
+	if (!--eta->pending) {
+		eta_fn(&eta->eta);
+		free(eta);
+		return 0;
+	}
+
+	return 1;
+}
+
 static void remove_client(struct fio_client *client)
 {
 	assert(client->refs);
@@ -1091,14 +1102,6 @@ void fio_client_sum_jobs_eta(struct jobs_eta *dst, struct jobs_eta *je)
 	strcpy((char *) dst->run_str, (char *) je->run_str);
 }
 
-void fio_client_dec_jobs_eta(struct client_eta *eta, client_eta_op eta_fn)
-{
-	if (!--eta->pending) {
-		eta_fn(&eta->eta);
-		free(eta);
-	}
-}
-
 static void remove_reply_cmd(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct fio_net_cmd_reply *reply = NULL;
@@ -1573,8 +1576,10 @@ static void request_client_etas(struct client_ops *ops)
 					(uintptr_t) eta, &client->cmd_list);
 	}
 
-	while (skipped--)
-		fio_client_dec_jobs_eta(eta, ops->eta);
+	while (skipped--) {
+		if (!fio_client_dec_jobs_eta(eta, ops->eta))
+			break;
+	}
 
 	dprint(FD_NET, "client: requested eta tag %p\n", eta);
 }
diff --git a/client.h b/client.h
index 8818de2..cfb0b4d 100644
--- a/client.h
+++ b/client.h
@@ -111,7 +111,6 @@ struct client_eta {
 };
 
 extern int fio_handle_client(struct fio_client *);
-extern void fio_client_dec_jobs_eta(struct client_eta *eta, client_eta_op fn);
 extern void fio_client_sum_jobs_eta(struct jobs_eta *dst, struct jobs_eta *je);
 
 enum {
diff --git a/eta.c b/eta.c
index db045cb..3e8eb0b 100644
--- a/eta.c
+++ b/eta.c
@@ -590,7 +590,7 @@ struct jobs_eta *get_jobs_eta(int force, size_t *size)
 	if (!thread_number)
 		return NULL;
 
-	*size = sizeof(*je) + THREAD_RUNSTR_SZ;
+	*size = sizeof(*je) + THREAD_RUNSTR_SZ + 1;
 	je = malloc(*size);
 	if (!je)
 		return NULL;
diff --git a/filesetup.c b/filesetup.c
index 212a126..881aeee 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1051,6 +1051,43 @@ static int init_rand_distribution(struct thread_data *td)
 	return 1;
 }
 
+/*
+ * Check if the number of blocks exceeds the randomness capability of
+ * the selected generator. Tausworthe is 32-bit, the others are fullly
+ * 64-bit capable.
+ */
+static int check_rand_gen_limits(struct thread_data *td, struct fio_file *f,
+				 uint64_t blocks)
+{
+	if (blocks <= FRAND32_MAX)
+		return 0;
+	if (td->o.random_generator != FIO_RAND_GEN_TAUSWORTHE)
+		return 0;
+
+	/*
+	 * If the user hasn't specified a random generator, switch
+	 * to tausworthe64 with informational warning. If the user did
+	 * specify one, just warn.
+	 */
+	log_info("fio: file %s exceeds 32-bit tausworthe random generator.\n",
+			f->file_name);
+
+	if (!fio_option_is_set(&td->o, random_generator)) {
+		log_info("fio: Switching to tausworthe64. Use the "
+			 "random_generator= option to get rid of this "
+			 " warning.\n");
+		td->o.random_generator = FIO_RAND_GEN_TAUSWORTHE64;
+		return 0;
+	}
+
+	/*
+	 * Just make this information to avoid breaking scripts.
+	 */
+	log_info("fio: Use the random_generator= option to switch to lfsr or "
+			 "tausworthe64.\n");
+	return 0;
+}
+
 int init_random_map(struct thread_data *td)
 {
 	unsigned long long blocks;
@@ -1067,15 +1104,8 @@ int init_random_map(struct thread_data *td)
 
 		blocks = fsize / (unsigned long long) td->o.rw_min_bs;
 
-		if (blocks > FRAND32_MAX &&
-		    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE &&
-		    !fio_option_is_set(&td->o, random_generator)) {
-			log_err("fio: file %s exceeds 32-bit tausworthe "
-				 "random generator. Use lfsr or "
-				 "tausworthe64.\n", f->file_name);
-			td_verror(td, EINVAL, "init file random");
+		if (check_rand_gen_limits(td, f, blocks))
 			return 1;
-		}
 
 		if (td->o.random_generator == FIO_RAND_GEN_LFSR) {
 			unsigned long seed;
