Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60788 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdGUMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dYWbL-0005uw-Oa
        for fio@vger.kernel.org; Fri, 21 Jul 2017 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170721120001.CBAB62C009A@kernel.dk>
Date: Fri, 21 Jul 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 785e49c659023df1735bff195ad4ba133ebd23a7:

  build: Sort file list (2017-07-16 14:02:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 800334db17a22029553488b41a5ede8af909c66d:

  Correctly detect whether ioengine_load can exit early (2017-07-19 12:27:57 -0700)

----------------------------------------------------------------
Ben Walker (1):
      Correctly detect whether ioengine_load can exit early

 init.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 9b2b63d..90cc0bc 100644
--- a/init.c
+++ b/init.c
@@ -1000,16 +1000,24 @@ int ioengine_load(struct thread_data *td)
 {
 	const char *engine;
 
-	/*
-	 * Engine has already been loaded.
-	 */
-	if (td->io_ops)
-		return 0;
 	if (!td->o.ioengine) {
 		log_err("fio: internal fault, no IO engine specified\n");
 		return 1;
 	}
 
+	if (td->io_ops) {
+		/* An engine is loaded, but the requested ioengine
+		 * may have changed.
+		 */
+		if (!strcmp(td->io_ops->name, td->o.ioengine)) {
+			/* The right engine is already loaded */
+			return 0;
+		}
+
+		/* Unload the old engine. */
+		free_ioengine(td);
+	}
+
 	engine = get_engine_name(td->o.ioengine);
 	td->io_ops = load_ioengine(td, engine);
 	if (!td->io_ops) {
@@ -2530,7 +2538,6 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 
 			if (!ret && !strcmp(opt, "ioengine")) {
-				free_ioengine(td);
 				if (ioengine_load(td)) {
 					put_job(td);
 					td = NULL;
