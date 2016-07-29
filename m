Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39792 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcG2MAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 29 Jul 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bT6SR-0007hU-7H
	for fio@vger.kernel.org; Fri, 29 Jul 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160729120001.D31672C00A2@kernel.dk>
Date: Fri, 29 Jul 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c915aa3b56b72c3c9eac3b92f89f22a18ccf0047:

  examples/backwards-read.fio: add size (2016-07-27 08:33:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to be6bb2b72608d7efbec13d06c67446e229136afa:

  Fix overflow caused by signed long division by unsigned long. The over flow seems to occurr when the value of 'log_avg_msec' option is relatively large. (2016-07-29 09:25:17 +0900)

----------------------------------------------------------------
Jevon Qiao (2):
      Fix segmentation fault while specifying clustername with rbd engine
      Fix memory leak in _fio_rbd_connect()

YukiKita (1):
      Fix overflow caused by signed long division by unsigned long.     The over flow seems to occurr when the value of 'log_avg_msec' option is relatively large.

 engines/rbd.c | 22 +++++++++++++++-------
 gettime.c     |  4 ++--
 2 files changed, 17 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index 7a109ee..c85645a 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -131,18 +131,26 @@ static int _fio_rbd_connect(struct thread_data *td)
 		char *client_name = NULL; 
 
 		/*
-		 * If we specify cluser name, the rados_creat2
+		 * If we specify cluser name, the rados_create2
 		 * will not assume 'client.'. name is considered
 		 * as a full type.id namestr
 		 */
-		if (!index(o->client_name, '.')) {
-			client_name = calloc(1, strlen("client.") +
-						strlen(o->client_name) + 1);
-			strcat(client_name, "client.");
-			o->client_name = strcat(client_name, o->client_name);
+		if (o->client_name) {
+			if (!index(o->client_name, '.')) {
+				client_name = calloc(1, strlen("client.") +
+						    strlen(o->client_name) + 1);
+				strcat(client_name, "client.");
+				strcat(client_name, o->client_name);
+			} else {
+				client_name = o->client_name;
+			}
 		}
+
 		r = rados_create2(&rbd->cluster, o->cluster_name,
-					o->client_name, 0);
+				 client_name, 0);
+
+		if (client_name && !index(o->client_name, '.'))
+			free(client_name);
 	} else
 		r = rados_create(&rbd->cluster, o->client_name);
 	
diff --git a/gettime.c b/gettime.c
index b896b5b..964a52f 100644
--- a/gettime.c
+++ b/gettime.c
@@ -424,8 +424,8 @@ uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
 	if (sec < 0 || (sec == 0 && usec < 0))
 		return 0;
 
-	sec *= 1000UL;
-	usec /= 1000UL;
+	sec *= 1000;
+	usec /= 1000;
 	ret = sec + usec;
 
 	return ret;
