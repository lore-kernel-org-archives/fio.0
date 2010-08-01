Return-Path: <fio-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:37950 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab0HAPbV (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 1 Aug 2010 11:31:21 -0400
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Reduce thread stack size
Date: Sun, 1 Aug 2010 17:01:06 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011701.06711.bvanassche@acm.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>

This patch reduces the stack size required by fio threads and hence allows
to run fio with 200 or more threads on systems with a moderate amount of
virtual memory.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>

diff --git a/fio.c b/fio.c
index 896f797..6ab0f4a 100644
--- a/fio.c
+++ b/fio.c
@@ -1380,9 +1380,13 @@ static void *gtod_thread_main(void *data)
 
 static int fio_start_gtod_thread(void)
 {
+	pthread_attr_t attr;
 	int ret;
 
-	ret = pthread_create(&gtod_thread, NULL, gtod_thread_main, NULL);
+	pthread_attr_init(&attr);
+	pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN);
+	ret = pthread_create(&gtod_thread, &attr, gtod_thread_main, NULL);
+	pthread_attr_destroy(&attr);
 	if (ret) {
 		log_err("Can't create gtod thread: %s\n", strerror(ret));
 		return 1;
diff --git a/verify.c b/verify.c
index 42ea462..7957bd4 100644
--- a/verify.c
+++ b/verify.c
@@ -886,12 +886,16 @@ done:
 int verify_async_init(struct thread_data *td)
 {
 	int i, ret;
+	pthread_attr_t attr;
+
+	pthread_attr_init(&attr);
+	pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN);
 
 	td->verify_thread_exit = 0;
 
 	td->verify_threads = malloc(sizeof(pthread_t) * td->o.verify_async);
 	for (i = 0; i < td->o.verify_async; i++) {
-		ret = pthread_create(&td->verify_threads[i], NULL,
+		ret = pthread_create(&td->verify_threads[i], &attr,
 					verify_async_thread, td);
 		if (ret) {
 			log_err("fio: async verify creation failed: %s\n",
@@ -907,6 +911,8 @@ int verify_async_init(struct thread_data *td)
 		td->nr_verify_threads++;
 	}
 
+	pthread_attr_destroy(&attr);
+
 	if (i != td->o.verify_async) {
 		log_err("fio: only %d verify threads started, exiting\n", i);
 		td->verify_thread_exit = 1;
