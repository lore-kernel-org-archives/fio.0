Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58766 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Mar 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WQFAC-0007yh-8w
	for fio@vger.kernel.org; Wed, 19 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140319120002.B0CAD400DC@strynoevaenget.dk>
Date: Wed, 19 Mar 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0aae4ce7dbc93fe5770b25c76f5b6242ce398b7a:

  Update file_append documentation (2014-03-17 12:55:08 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b1bebc321e3b831d424dd49626833dd642224bd4:

  Prevent file_append=1 with IO engine that can't extend files (2014-03-18 13:30:32 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Prevent file_append=1 with IO engine that can't extend files

 init.c |    5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 73ec9eb..9b0666d 100644
--- a/init.c
+++ b/init.c
@@ -676,6 +676,11 @@ static int fixup_options(struct thread_data *td)
 	if (td->o.rand_seed)
 		td->o.rand_repeatable = 0;
 
+	if ((td->io_ops->flags & FIO_NOEXTEND) && td->o.file_append) {
+		log_err("fio: can't append/extent with IO engine %s\n", td->io_ops->name);
+		ret = 1;
+	}
+
 	return ret;
 }
 
