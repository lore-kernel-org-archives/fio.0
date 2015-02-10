Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbbBJNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Feb 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YLAQ9-0007Gl-64
	for fio@vger.kernel.org; Tue, 10 Feb 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150210130003.5127D4017D@lyth.info>
Date: Tue, 10 Feb 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e28dd2cfa734e26163532d24f1e06708cad659a6:

  Fix for verify_only (do_dry_run()) broken by 74d6277f (2015-02-06 09:11:11 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 10adc4a71b10e504d904bfc1db2d705342aa3851:

  verify: Fix latency log for verify commands. (2015-02-09 08:18:03 -0700)

----------------------------------------------------------------
Gwendal Grignou (1):
      verify: Fix latency log for verify commands.

 backend.c |    2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 7ec8d2a..0f6e425 100644
--- a/backend.c
+++ b/backend.c
@@ -565,6 +565,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 			io_u->end_io = verify_io_u;
 
 		ddir = io_u->ddir;
+		if (!td->o.disable_slat)
+			fio_gettime(&io_u->start_time, NULL);
 
 		ret = td_io_queue(td, io_u);
 		switch (ret) {
