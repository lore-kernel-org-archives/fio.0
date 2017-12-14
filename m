Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55330 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdLNNAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 14 Dec 2017 08:00:12 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ePT7T-0001Pm-Jj
        for fio@vger.kernel.org; Thu, 14 Dec 2017 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171214130001.A270A2C00C4@kernel.dk>
Date: Thu, 14 Dec 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e80d780108fd33350f7c4a3032a8d2d06d7b102f:

  fio: kill td->nr_normal_files (2017-12-08 12:50:28 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c20c361255683ee138f0c239e48b315e25725f7e:

  server: initialize first iolog header properly (2017-12-13 08:44:34 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      server: initialize first iolog header properly

 server.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index 76d662d..6225614 100644
--- a/server.c
+++ b/server.c
@@ -1933,6 +1933,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	struct flist_head *entry;
 	int ret = 0;
 
+	memset(&pdu, 0, sizeof(pdu));
 	pdu.nr_samples = cpu_to_le64(iolog_nr_samples(log));
 	pdu.thread_number = cpu_to_le32(td->thread_number);
 	pdu.log_type = cpu_to_le32(log->log_type);
