Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63553 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2CMU6G (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 13 Mar 2012 16:58:06 -0400
Received: by vcqp1 with SMTP id p1so1065430vcq.19
        for <fio@vger.kernel.org>; Tue, 13 Mar 2012 13:58:05 -0700 (PDT)
MIME-Version: 1.0
From: Yufei Ren <renyufei83@gmail.com>
Date: Tue, 13 Mar 2012 16:57:45 -0400
Message-ID: <CAG5pYQf466pFdb8dGwpQxqx64Tre+JgV-qh-emY+BT0dh3m8uA@mail.gmail.com>
Subject: [PATCH] rdma engine graceful teardown
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

For rdma ioengine's one side operation, RDMA_WRITE or RDMA_READ,
server side gets a message from client side that the task is finished.
In previous version, the server simply exit() in td_io_commit() which
causes segmentation fault in thread mode or process hanging in process
mode. This patch achieves graceful tear down by setting up `td->done`
as UDP engine did.

---
diff --git a/engines/rdma.c b/engines/rdma.c
index 54fd194..79d72d2 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -674,7 +674,8 @@ static int fio_rdmaio_recv(struct thread_data *td, struct io
_u **io_us,
 		rdma_poll_wait(td, IBV_WC_RECV);

 		dprint(FD_IO, "fio: recv FINISH message\n");
-		exit(0);
+		td->done = 1;
+		return 0;
 	}

 	return i;
diff --git a/ioengines.c b/ioengines.c
index 4c609f2..e1605c4 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -208,6 +208,16 @@ int td_io_getevents(struct thread_data *td, unsigned int mi
n, unsigned int max,
 {
 	int r = 0;

+	/*
+	 * For ioengine=rdma one side operation RDMA_WRITE or RDMA_READ,
+	 * server side gets a message from the client
+	 * side that the task is finished, and
+	 * td->done is set to 1 after td_io_commit(). In this case,
+	 * there is no need to reap complete event in server side.
+	 */
+	if (td->done)
+		return 0;
+
 	if (min > 0 && td->io_ops->commit) {
 		r = td->io_ops->commit(td);
 		if (r < 0)

--
1.7.1
