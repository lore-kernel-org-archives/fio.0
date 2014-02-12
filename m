Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:52667 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaBLTOU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 14:14:20 -0500
From: "Daniel Gollub" <daniel.gollub@t-online.de>
Subject: [PATCH 2/2] engines/null: allow build as external C++ ioengine
Date: Wed, 12 Feb 2014 20:13:46 +0100
Message-Id: <1392232426-16152-2-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392232426-16152-1-git-send-email-d.gollub@telekom.de>
References: <1392232426-16152-1-git-send-email-d.gollub@telekom.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

In first place to have a simple test candidate for external
ioengines using get_ioengine() method for retriving the
io_engine struct.

Can be compiled with:

g++ -O2 -g -shared -rdynamic -fPIC -o null.so null.c -DFIO_EXTERNAL_ENGINE

Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
---
 engines/null.c |   46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/engines/null.c b/engines/null.c
index bf7885e..9f9d850 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -4,6 +4,10 @@
  * IO engine that doesn't do any real IO transfers, it just pretends to.
  * The main purpose is to test fio itself.
  *
+ * It also can act as external C++ engine - compiled with:
+ *
+ * g++ -O2 -g -shared -rdynamic -fPIC -o null.so null.c -DFIO_EXTERNAL_ENGINE
+ *
  */
 #include <stdio.h>
 #include <stdlib.h>
@@ -21,7 +25,7 @@ struct null_data {
 
 static struct io_u *fio_null_event(struct thread_data *td, int event)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	return nd->io_us[event];
 }
@@ -30,7 +34,7 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 			      unsigned int fio_unused max,
 			      struct timespec fio_unused *t)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 	int ret = 0;
 	
 	if (min_events) {
@@ -43,10 +47,12 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 
 static int fio_null_commit(struct thread_data *td)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	if (!nd->events) {
+#ifndef FIO_EXTERNAL_ENGINE
 		io_u_mark_submit(td, nd->queued);
+#endif
 		nd->events = nd->queued;
 		nd->queued = 0;
 	}
@@ -56,7 +62,7 @@ static int fio_null_commit(struct thread_data *td)
 
 static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	fio_ro_check(td, io_u);
 
@@ -77,7 +83,7 @@ static int fio_null_open(struct thread_data fio_unused *td,
 
 static void fio_null_cleanup(struct thread_data *td)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	if (nd) {
 		if (nd->io_us)
@@ -88,12 +94,12 @@ static void fio_null_cleanup(struct thread_data *td)
 
 static int fio_null_init(struct thread_data *td)
 {
-	struct null_data *nd = malloc(sizeof(*nd));
+	struct null_data *nd = (struct null_data *) malloc(sizeof(*nd));
 
 	memset(nd, 0, sizeof(*nd));
 
 	if (td->o.iodepth != 1) {
-		nd->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
+		nd->io_us = (struct io_u **) malloc(td->o.iodepth * sizeof(struct io_u *));
 		memset(nd->io_us, 0, td->o.iodepth * sizeof(struct io_u *));
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
@@ -102,6 +108,7 @@ static int fio_null_init(struct thread_data *td)
 	return 0;
 }
 
+#ifndef __cplusplus
 static struct ioengine_ops ioengine = {
 	.name		= "null",
 	.version	= FIO_IOOPS_VERSION,
@@ -124,3 +131,28 @@ static void fio_exit fio_null_unregister(void)
 {
 	unregister_ioengine(&ioengine);
 }
+
+#else
+
+#ifdef FIO_EXTERNAL_ENGINE
+extern "C" {
+void get_ioengine(struct ioengine_ops **ioengine_ptr) {
+	struct ioengine_ops *ioengine;
+	*ioengine_ptr = (struct ioengine_ops *) malloc(sizeof(struct ioengine_ops));
+	ioengine = *ioengine_ptr;
+
+	strcpy(ioengine->name, "cpp_null");
+	ioengine->version        = FIO_IOOPS_VERSION;
+	ioengine->queue          = fio_null_queue;
+	ioengine->commit         = fio_null_commit;
+	ioengine->getevents      = fio_null_getevents;
+	ioengine->event          = fio_null_event;
+	ioengine->init           = fio_null_init;
+	ioengine->cleanup        = fio_null_cleanup;
+	ioengine->open_file      = fio_null_open;
+	ioengine->flags	         = FIO_DISKLESSIO;
+}
+}
+#endif /* FIO_EXTERNAL_ENGINE */
+
+#endif /* __cplusplus */
-- 
1.7.10.4

