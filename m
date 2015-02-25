Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbbBYNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 Feb 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YQbZN-0004gM-4o
	for fio@vger.kernel.org; Wed, 25 Feb 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150225130003.503E640188@lyth.info>
Date: Wed, 25 Feb 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bb1116fe9a53154447bb4305ed9d9fd42d2a6aa1:

  Fixup whitespace damage in the two previous commits (2015-02-19 08:47:34 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cf8a46a75f38afe07ebf823210f95543999e3116:

  Make 'loops' honor full write+verify loops (2015-02-24 14:50:57 -0800)

----------------------------------------------------------------
Jens Axboe (1):
      Make 'loops' honor full write+verify loops

 backend.c |    6 ++++--
 fio.h     |    1 +
 init.c    |    4 ++++
 3 files changed, 9 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 3430e66..fdb7413 100644
--- a/backend.c
+++ b/backend.c
@@ -658,10 +658,10 @@ static unsigned int exceeds_number_ios(struct thread_data *td)
 	if (!td->o.number_ios)
 		return 0;
 
-	number_ios = ddir_rw_sum(td->this_io_blocks);
+	number_ios = ddir_rw_sum(td->io_blocks);
 	number_ios += td->io_u_queued + td->io_u_in_flight;
 
-	return number_ios >= td->o.number_ios;
+	return number_ios >= (td->o.number_ios * td->loops);
 }
 
 static int io_issue_bytes_exceeded(struct thread_data *td)
@@ -682,6 +682,7 @@ static int io_issue_bytes_exceeded(struct thread_data *td)
 	else
 		limit = td->o.size;
 
+	limit *= td->loops;
 	return bytes >= limit || exceeds_number_ios(td);
 }
 
@@ -703,6 +704,7 @@ static int io_complete_bytes_exceeded(struct thread_data *td)
 	else
 		limit = td->o.size;
 
+	limit *= td->loops;
 	return bytes >= limit || exceeds_number_ios(td);
 }
 
diff --git a/fio.h b/fio.h
index d28f8ce..f688084 100644
--- a/fio.h
+++ b/fio.h
@@ -240,6 +240,7 @@ struct thread_data {
 	 */
 	uint64_t io_issues[DDIR_RWDIR_CNT];
 	uint64_t io_issue_bytes[DDIR_RWDIR_CNT];
+	uint64_t loops;
 
 	/*
 	 * Completions
diff --git a/init.c b/init.c
index c210ad2..7aedf2b 100644
--- a/init.c
+++ b/init.c
@@ -763,6 +763,10 @@ static int fixup_options(struct thread_data *td)
 		fio_gtod_offload = 1;
 	}
 
+	td->loops = o->loops;
+	if (!td->loops)
+		td->loops = 1;
+
 	return ret;
 }
 
