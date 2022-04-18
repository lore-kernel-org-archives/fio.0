Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BD6C433F5
	for <fio@archiver.kernel.org>; Mon, 18 Apr 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiDRMCs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 18 Apr 2022 08:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiDRMCr (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Apr 2022 08:02:47 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0F910FC8
        for <fio@vger.kernel.org>; Mon, 18 Apr 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GQdWQPFV8XaCQBipw9p6mQFP+iQioFaVq3s4L8SZeIM=; b=efVNJ9gNGSUECJXlUEiPpv8K/8
        QfxfHpsxsZo5/hjDMFB6SfE8MoSEcvfTjsKG8eB1OvA5KTZOWRAl1DIz0evaVFpsNbUTuR2CJpoNK
        JNvw7XglvepCEOraXwCcDHiMdrE82qOKtDd3ro4YTM36h7gxu95oRFM49UrziSwBx15O2eKSRjMk9
        GX+IXiqt0z09iHFJMcOqRQnHbgRXTLJnI6XjoNjcfi0kcH1O6yBAZTU/4rcF8kdOTwJBvvKeM9VuA
        XWzUyKyvLW/16XuMWHSYcw/QQIlUf2elWbo1MQirkjpP8aMK9H+2tZxxVb/42jRxAkDnENEfwSi5W
        1jY6X4hw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ngQ33-006Uwr-7M
        for fio@vger.kernel.org; Mon, 18 Apr 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 664FA1BC0129; Mon, 18 Apr 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220418120002.664FA1BC0129@kernel.dk>
Date:   Mon, 18 Apr 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d684bb2839d1fa010fba1e64f9b0c16240d8bdae:

  Merge branch 'fix/remove-sudo-in-test-script' of https://github.com/dpronin/fio (2022-04-10 15:18:42 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5f2d43188c2d65674aaba6280e2a87107e5d7099:

  Merge branch 'fix/json/strdup_memory_leak' of https://github.com/dpronin/fio (2022-04-17 16:47:22 -0600)

----------------------------------------------------------------
Denis Pronin (5):
      fixed possible and actual memory leaks
      fixed memory leak of not freed jobs_eta in several cases
      use flist_first_entry instead of flist_entry applied to 'next' list item
      fixed bunch of memory leaks in json constructor
      updated logging of iops1, iops2, ratio in FioJobTest_iops_rate

Jens Axboe (3):
      Merge branch 'fix/memory-leak' of https://github.com/dpronin/fio
      Merge branch 'fix/jobs_eta_memory_leak' of https://github.com/dpronin/fio
      Merge branch 'fix/json/strdup_memory_leak' of https://github.com/dpronin/fio

 backend.c          | 3 +++
 eta.c              | 7 ++++---
 ioengines.c        | 2 ++
 json.h             | 7 ++++++-
 server.c           | 2 +-
 stat.c             | 2 ++
 t/run-fio-tests.py | 3 ++-
 7 files changed, 20 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 001b2b96..317e4f6c 100644
--- a/backend.c
+++ b/backend.c
@@ -2433,8 +2433,10 @@ reap:
 			} else {
 				pid_t pid;
 				struct fio_file **files;
+				void *eo;
 				dprint(FD_PROCESS, "will fork\n");
 				files = td->files;
+				eo = td->eo;
 				read_barrier();
 				pid = fork();
 				if (!pid) {
@@ -2447,6 +2449,7 @@ reap:
 				// freeing previously allocated memory for files
 				// this memory freed MUST NOT be shared between processes, only the pointer itself may be shared within TD
 				free(files);
+				free(eo);
 				free(fd);
 				fd = NULL;
 			}
diff --git a/eta.c b/eta.c
index 17970c78..6017ca31 100644
--- a/eta.c
+++ b/eta.c
@@ -3,6 +3,7 @@
  */
 #include <unistd.h>
 #include <string.h>
+#include <stdlib.h>
 #ifdef CONFIG_VALGRIND_DEV
 #include <valgrind/drd.h>
 #else
@@ -707,10 +708,10 @@ void print_thread_status(void)
 	size_t size;
 
 	je = get_jobs_eta(false, &size);
-	if (je)
+	if (je) {
 		display_thread_status(je);
-
-	free(je);
+		free(je);
+	}
 }
 
 void print_status_init(int thr_number)
diff --git a/ioengines.c b/ioengines.c
index d08a511a..68f307e5 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -223,6 +223,8 @@ struct ioengine_ops *load_ioengine(struct thread_data *td)
  */
 void free_ioengine(struct thread_data *td)
 {
+	assert(td != NULL && td->io_ops != NULL);
+
 	dprint(FD_IO, "free ioengine %s\n", td->io_ops->name);
 
 	if (td->eo && td->io_ops->options) {
diff --git a/json.h b/json.h
index d9824263..66bb06b1 100644
--- a/json.h
+++ b/json.h
@@ -81,8 +81,13 @@ static inline int json_object_add_value_string(struct json_object *obj,
 	struct json_value arg = {
 		.type = JSON_TYPE_STRING,
 	};
+	union {
+		const char *a;
+		char *b;
+	} string;
 
-	arg.string = strdup(val ? : "");
+	string.a = val ? val : "";
+	arg.string = string.b;
 	return json_object_add_value_type(obj, name, &arg);
 }
 
diff --git a/server.c b/server.c
index 914a8c74..4c71bd44 100644
--- a/server.c
+++ b/server.c
@@ -1323,7 +1323,7 @@ static int handle_xmits(struct sk_out *sk_out)
 	sk_unlock(sk_out);
 
 	while (!flist_empty(&list)) {
-		entry = flist_entry(list.next, struct sk_entry, list);
+		entry = flist_first_entry(&list, struct sk_entry, list);
 		flist_del(&entry->list);
 		ret += handle_sk_entry(sk_out, entry);
 	}
diff --git a/stat.c b/stat.c
index 356083e2..949af5ed 100644
--- a/stat.c
+++ b/stat.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <string.h>
+#include <stdlib.h>
 #include <sys/time.h>
 #include <sys/stat.h>
 #include <math.h>
@@ -1698,6 +1699,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	if (je) {
 		json_object_add_value_int(root, "eta", je->eta_sec);
 		json_object_add_value_int(root, "elapsed", je->elapsed_sec);
+		free(je);
 	}
 
 	if (opt_list)
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 612e50ca..ecceb67e 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -546,9 +546,10 @@ class FioJobTest_iops_rate(FioJobTest):
             return
 
         iops1 = self.json_data['jobs'][0]['read']['iops']
+        logging.debug("Test %d: iops1: %f", self.testnum, iops1)
         iops2 = self.json_data['jobs'][1]['read']['iops']
+        logging.debug("Test %d: iops2: %f", self.testnum, iops2)
         ratio = iops2 / iops1
-        logging.debug("Test %d: iops1: %f", self.testnum, iops1)
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
         if iops1 < 950 or iops1 > 1050:
