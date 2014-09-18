Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaIRMAP (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 18 Sep 2014 08:00:15 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XUaNY-0000Xc-Jx
	for fio@vger.kernel.org; Thu, 18 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140918120003.6DBDB4017D@lyth.info>
Date: Thu, 18 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 65ff9cd5fd5859b1547a9f7e1b2c97c6b9352f4d:

  btrace2fio: move file tracking to btrace_pid (2014-09-16 20:17:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cea475cd767b7e3d5c4fb2383247cbc78877cf56:

  btrace2fio: add rate output (2014-09-17 17:58:31 +0200)

----------------------------------------------------------------
Jens Axboe (1):
      btrace2fio: add rate output

 t/btrace2fio.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index bda3c0b..4dff3ec 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -46,6 +46,7 @@ struct btrace_out {
 	unsigned int depth;
 	uint64_t first_ttime;
 	uint64_t last_ttime;
+	uint64_t kb;
 
 	uint64_t start_delay;
 };
@@ -365,8 +366,10 @@ static void handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 		struct inflight *i;
 
 		i = inflight_find(t->sector + (t->bytes >> 9));
-		if (i)
+		if (i) {
+			i->p->o.kb += (t->bytes >> 10);
 			inflight_remove(i);
+		}
 	}
 }
 
@@ -509,7 +512,7 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 {
 	const char *msg[] = { "reads", "writes", "trims" };
 	struct btrace_out *o = &p->o;
-	unsigned long total;
+	unsigned long total, usec;
 	int i, j;
 
 	printf("[pid:\t%u]\n", p->pid);
@@ -539,7 +542,9 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 	}
 
 	printf("depth:\t%u\n", o->depth);
-	printf("usec:\t%llu (delay=%llu)\n", (o->last_ttime - o->first_ttime) / 1000ULL, (unsigned long long) o->start_delay);
+	usec = (o->last_ttime - o->first_ttime) / 1000ULL;
+	printf("usec:\t%lu (delay=%llu)\n", usec, (unsigned long long) o->start_delay);
+	printf("rate:\t%.2fKB/sec\n", ((float) o->kb * 1000.0) / ((float) usec / 1000.0));
 
 	printf("files:\t");
 	for (i = 0; i < p->nr_files; i++)
