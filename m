Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53630 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbeEOMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 May 2018 08:00:13 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fIYcm-0004jh-IJ
        for fio@vger.kernel.org; Tue, 15 May 2018 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180515120001.BFE752C0069@kernel.dk>
Date: Tue, 15 May 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 43864deb3b4e24d5570ee4cb16cb626e94ec0465:

  iolog: default to good return (2018-04-26 22:45:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 540e235dcd276e63c57ca4bd35f70a0651e2d00e:

  Merge branch 'master' of https://github.com/majianpeng/fio (2018-05-14 19:40:32 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/majianpeng/fio

Jianpeng Ma (1):
      This partly revert 97bb54c9606c(add __load_ioengine() to separate ioengine loading from td context)

 ioengines.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index 6ffd27f..d579682 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -574,6 +574,7 @@ int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 int fio_show_ioengine_help(const char *engine)
 {
 	struct flist_head *entry;
+	struct thread_data td;
 	struct ioengine_ops *io_ops;
 	char *sep;
 	int ret = 1;
@@ -592,7 +593,10 @@ int fio_show_ioengine_help(const char *engine)
 		sep++;
 	}
 
-	io_ops = __load_ioengine(engine);
+	memset(&td, 0, sizeof(struct thread_data));
+	td.o.ioengine = (char *)engine;
+	io_ops = load_ioengine(&td);
+
 	if (!io_ops) {
 		log_info("IO engine %s not found\n", engine);
 		return 1;
@@ -603,5 +607,6 @@ int fio_show_ioengine_help(const char *engine)
 	else
 		log_info("IO engine %s has no options\n", io_ops->name);
 
+	free_ioengine(&td);
 	return ret;
 }
