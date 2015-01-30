Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762201AbbA3NAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Jan 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YHBB6-0000uj-Hl
	for fio@vger.kernel.org; Fri, 30 Jan 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150130130003.3CEB44018D@lyth.info>
Date: Fri, 30 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 54ed125bb0deffa937286e64367ed8e4e94413f1:

  idletime: maintain cpuset over lifetime of idle thread (2015-01-28 14:47:48 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d47d7cb371fd24419ea5b4d83469ab66f31aa42e:

  gettime: remember to tear down clock cpumask on normal exit (2015-01-29 09:23:39 -0800)

----------------------------------------------------------------
Jens Axboe (2):
      gettime: fix unitialized variable on Solaris
      gettime: remember to tear down clock cpumask on normal exit

 gettime.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index 8419fe4..6863ce3 100644
--- a/gettime.c
+++ b/gettime.c
@@ -478,7 +478,7 @@ static void *clock_thread_fn(void *data)
 	int i;
 
 	if (fio_cpuset_init(&cpu_mask)) {
-		int __err;
+		int __err = errno;
 
 		log_err("clock cpuset init failed: %s\n", strerror(__err));
 		goto err_out;
@@ -528,6 +528,7 @@ static void *clock_thread_fn(void *data)
 	if (!t->entries[i - 1].tsc && !t->entries[0].tsc)
 		goto err;
 
+	fio_cpuset_exit(&cpu_mask);
 	return NULL;
 err:
 	fio_cpuset_exit(&cpu_mask);
