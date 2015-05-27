Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbbE0MAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 27 May 2015 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yxa0C-0006Wq-A3
	for fio@vger.kernel.org; Wed, 27 May 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150527120002.5D0902C00F3@kernel.dk>
Date: Wed, 27 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8e093781f7995bb77ba0dca2835567a8a88972ec:

  cconv: add allow_mounted_write (2015-05-22 09:09:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 68d96e515825185b232bbc8d2e5b5136b90514be:

  treat error in addr conversion to string as non-fatal (2015-05-26 15:12:46 -0400)

----------------------------------------------------------------
Ben England (2):
      embed server address, not other end's address
      treat error in addr conversion to string as non-fatal

 server.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index 7a9b0a4..519a7ee 100644
--- a/server.c
+++ b/server.c
@@ -21,6 +21,7 @@
 #endif
 
 #include "fio.h"
+#include "options.h"
 #include "server.h"
 #include "crc/crc16.h"
 #include "lib/ieee754.h"
@@ -936,6 +937,39 @@ static int handle_connection(int sk)
 	_exit(ret);
 }
 
+/* get the address on this host bound by the input socket, 
+ * whether it is ipv6 or ipv4 */
+
+int get_my_addr_str( int sk )
+{
+	int ret; 
+	struct sockaddr * sockaddr_p;
+	struct sockaddr_in myaddr4 = {0};
+	struct sockaddr_in6 myaddr6 = {0};
+	char * net_addr;
+	socklen_t len = use_ipv6 ? sizeof(myaddr6) : sizeof(myaddr4);
+
+	if (use_ipv6)
+		sockaddr_p = (struct sockaddr * )&myaddr6;
+	else
+		sockaddr_p = (struct sockaddr * )&myaddr4;
+	ret = getsockname(sk, sockaddr_p, &len);
+	if (ret) {
+		log_err("fio: getsockaddr: %s\n", strerror(errno));
+		return -1;
+	}
+	if (use_ipv6)
+		net_addr = (char * )&myaddr6.sin6_addr;
+	else
+		net_addr = (char * )&myaddr4.sin_addr;
+	if (NULL == inet_ntop(use_ipv6?AF_INET6:AF_INET, net_addr, client_sockaddr_str, INET6_ADDRSTRLEN-1)) {
+		log_err("inet_ntop: failed to convert addr to string\n");
+		return -1;
+	}
+	dprint(FD_NET, "fio server bound to addr %s\n", client_sockaddr_str);
+	return 0;
+}
+
 static int accept_loop(int listen_sk)
 {
 	struct sockaddr_in addr;
@@ -1007,7 +1041,7 @@ static int accept_loop(int listen_sk)
 		}
 
 		/* exits */
-		strncpy(client_sockaddr_str, from, INET6_ADDRSTRLEN);
+		get_my_addr_str(sk); /* if error, it's already logged, non-fatal */
 		handle_connection(sk);
 	}
 
