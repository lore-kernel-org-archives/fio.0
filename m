Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44988 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059AbcHBMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Aug 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bUYMd-0006ih-FM
	for fio@vger.kernel.org; Tue, 02 Aug 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160802120001.DAD942C00A2@kernel.dk>
Date: Tue,  2 Aug 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 99955d3d3e290ccb06583a821a8112210e4b332d:

  backend: do_dry_run(): get_io_u() can return an error pointer (2016-07-29 09:59:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 059b61f219b15db434eddc2207b876c6a0bad6c0:

  backend: do_verify() cleanup (2016-08-01 13:46:17 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      backend: do_verify() cleanup

 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 8a71490..c3ad831 100644
--- a/backend.c
+++ b/backend.c
@@ -652,7 +652,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 
 			while ((io_u = get_io_u(td)) != NULL) {
-				if (IS_ERR(io_u)) {
+				if (IS_ERR_OR_NULL(io_u)) {
 					io_u = NULL;
 					ret = FIO_Q_BUSY;
 					goto reap;
