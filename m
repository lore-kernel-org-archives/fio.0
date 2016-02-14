Return-Path: <fio-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:57254 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbcBNNAi (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 14 Feb 2016 08:00:38 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aUwHT-00059A-FD
	for fio@vger.kernel.org; Sun, 14 Feb 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160214130002.5D67B2C0145@kernel.dk>
Date: Sun, 14 Feb 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e0ee7a8ba4e6badc6cb73814315aa11c15d86ef9:

  fio.1: man page fixes (2016-02-12 15:00:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c0821a08db2fd3e37e16db73c3c4c9c7ff601e88:

  Allow for the include file specification to be relative. (2016-02-13 12:31:00 -0700)

----------------------------------------------------------------
Andrey Kuzmin (1):
      Allow for the include file specification to be relative.

 init.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 5ee4082..c7ce2cc 100644
--- a/init.c
+++ b/init.c
@@ -1773,15 +1773,48 @@ int __parse_jobs_ini(struct thread_data *td,
 			strip_blank_end(p);
 
 			if (!strncmp(p, "include", strlen("include"))) {
-				char *filename = p + strlen("include") + 1;
+				char *filename = p + strlen("include") + 1,
+					*ts, *full_fn = NULL;
 
-				if ((ret = __parse_jobs_ini(td, filename,
-						is_buf, stonewall_flag, type, 1,
-						name, &opts, &alloc_opts, &num_opts))) {
-					log_err("Error %d while parsing include file %s\n",
+				/*
+				 * Allow for the include filename
+				 * specification to be relative.
+				 */
+				if (access(filename, F_OK) &&
+				    (ts = strrchr(file, '/'))) {
+					int len = ts - file +
+						strlen(filename) + 2;
+
+					if (!(full_fn = calloc(1, len))) {
+						ret = ENOMEM;
+						break;
+					}
+
+					strncpy(full_fn,
+						file, (ts - file) + 1);
+					strncpy(full_fn + (ts - file) + 1,
+						filename, strlen(filename));
+					full_fn[len - 1] = 0;
+					filename = full_fn;
+				}
+
+				ret = __parse_jobs_ini(td, filename, is_buf,
+						       stonewall_flag, type, 1,
+						       name, &opts,
+						       &alloc_opts, &num_opts);
+
+				if (ret) {
+					log_err("Error %d while parsing "
+						"include file %s\n",
 						ret, filename);
-					break;
 				}
+
+				if (full_fn)
+					free(full_fn);
+
+				if (ret)
+					break;
+
 				continue;
 			}
 
