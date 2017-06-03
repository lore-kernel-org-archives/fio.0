Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48976 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbdFCMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 3 Jun 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dH7it-0000cq-VG
        for fio@vger.kernel.org; Sat, 03 Jun 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170603120002.673832C0083@kernel.dk>
Date: Sat,  3 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e5123c4ad9b0626e25d9b243f1111fa89082308b:

  manpage: update URL links to HOWTO/README (2017-05-26 13:29:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9af5a2450a555a725dd18e6845967cd7cf3aad64:

  use correct syscall name in log_err() (2017-06-02 13:38:43 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (2):
      use true/false for bool type
      use correct syscall name in log_err()

 init.c   | 8 ++++----
 server.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index d224bd6..2b7768a 100644
--- a/init.c
+++ b/init.c
@@ -909,9 +909,9 @@ void td_fill_verify_state_seed(struct thread_data *td)
 	bool use64;
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
-		use64 = 1;
+		use64 = true;
 	else
-		use64 = 0;
+		use64 = false;
 
 	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF],
 		use64);
@@ -967,9 +967,9 @@ void td_fill_rand_seeds(struct thread_data *td)
 	}
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
-		use64 = 1;
+		use64 = true;
 	else
-		use64 = 0;
+		use64 = false;
 
 	td_fill_rand_seeds_internal(td, use64);
 
diff --git a/server.c b/server.c
index 1e269c2..8a5e75d 100644
--- a/server.c
+++ b/server.c
@@ -1279,7 +1279,7 @@ static int get_my_addr_str(int sk)
 
 	ret = getsockname(sk, sockaddr_p, &len);
 	if (ret) {
-		log_err("fio: getsockaddr: %s\n", strerror(errno));
+		log_err("fio: getsockname: %s\n", strerror(errno));
 		return -1;
 	}
 
