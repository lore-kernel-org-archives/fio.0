Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/7] Define struct sk_out in server.h (not server.c)
Date: Mon, 20 Mar 2017 23:28:42 +0200
Message-Id: <20170320212847.71404-2-tkusumi@tuxera.com>
In-Reply-To: <20170320212847.71404-1-tkusumi@tuxera.com>
References: <20170320212847.71404-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

struct sk_out isn't local to server.c, so it should be visible
in its header (instead of having struct sk_out; in fio.h).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.h    |  1 -
 server.c | 11 -----------
 server.h | 11 +++++++++++
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fio.h b/fio.h
index 581512f..52a9b75 100644
--- a/fio.h
+++ b/fio.h
@@ -121,7 +121,6 @@ enum {
  * Per-thread/process specific data. Only used for the network client
  * for now.
  */
-struct sk_out;
 void sk_out_assign(struct sk_out *);
 void sk_out_drop(void);
 
diff --git a/server.c b/server.c
index 6d5d4ea..1b3bc30 100644
--- a/server.c
+++ b/server.c
@@ -50,17 +50,6 @@ struct sk_entry {
 	struct flist_head next;	/* Other sk_entry's, if linked command */
 };
 
-struct sk_out {
-	unsigned int refs;	/* frees sk_out when it drops to zero.
-				 * protected by below ->lock */
-
-	int sk;			/* socket fd to talk to client */
-	struct fio_mutex lock;	/* protects ref and below list */
-	struct flist_head list;	/* list of pending transmit work */
-	struct fio_mutex wait;	/* wake backend when items added to list */
-	struct fio_mutex xmit;	/* held while sending data */
-};
-
 static char *fio_server_arg;
 static char *bind_sock;
 static struct sockaddr_in saddr_in;
diff --git a/server.h b/server.h
index 3a1d0b0..798d5a8 100644
--- a/server.h
+++ b/server.h
@@ -12,6 +12,17 @@
 
 #define FIO_NET_PORT 8765
 
+struct sk_out {
+	unsigned int refs;	/* frees sk_out when it drops to zero.
+				 * protected by below ->lock */
+
+	int sk;			/* socket fd to talk to client */
+	struct fio_mutex lock;	/* protects ref and below list */
+	struct flist_head list;	/* list of pending transmit work */
+	struct fio_mutex wait;	/* wake backend when items added to list */
+	struct fio_mutex xmit;	/* held while sending data */
+};
+
 /*
  * On-wire encoding is little endian
  */
-- 
2.9.3


