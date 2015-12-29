Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44374 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbL2NAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 29 Dec 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aDtsp-00041v-90
	for fio@vger.kernel.org; Tue, 29 Dec 2015 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151229130001.8EEAF2C00B6@kernel.dk>
Date: Tue, 29 Dec 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f1480f98ae77ccb23888028563c5ae117d939e55:

  Fio 2.3 (2015-12-23 09:39:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2c2c93d8bd89c0cb15fc2430f9838744153a3946:

  t/genzipf: fix for strcasestr missing (2015-12-28 17:39:22 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      client: rename send_file() to fio_send_file()
      lib/pattern: include oslib/strcasestr.h
      Fix included getopt locations
      t/genzipf: fix for strcasestr missing

 Makefile                | 2 +-
 client.c                | 6 +++---
 fio.h                   | 2 +-
 init.c                  | 2 +-
 lib/pattern.c           | 1 +
 {lib => oslib}/getopt.h | 0
 oslib/strcasestr.c      | 4 ++++
 7 files changed, 11 insertions(+), 6 deletions(-)
 rename {lib => oslib}/getopt.h (100%)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 2ff88a1..510e257 100644
--- a/Makefile
+++ b/Makefile
@@ -200,7 +200,7 @@ T_IEEE_PROGS = t/ieee754
 
 T_ZIPF_OBS = t/genzipf.o
 T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/pattern.o lib/zipf.o \
-		lib/strntol.o lib/gauss.o t/genzipf.o
+		lib/strntol.o lib/gauss.o t/genzipf.o oslib/strcasestr.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
diff --git a/client.c b/client.c
index df13254..6c2a1ef 100644
--- a/client.c
+++ b/client.c
@@ -1485,8 +1485,8 @@ static void sendfile_reply(int fd, struct cmd_sendfile_reply *rep,
 	fio_net_send_cmd(fd, FIO_NET_CMD_SENDFILE, rep, size, &tag, NULL);
 }
 
-static int send_file(struct fio_client *client, struct cmd_sendfile *pdu,
-		     uint64_t tag)
+static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
+			 uint64_t tag)
 {
 	struct cmd_sendfile_reply *rep;
 	struct stat sb;
@@ -1636,7 +1636,7 @@ int fio_handle_client(struct fio_client *client)
 		}
 	case FIO_NET_CMD_SENDFILE: {
 		struct cmd_sendfile *pdu = (struct cmd_sendfile *) cmd->payload;
-		send_file(client, pdu, cmd->tag);
+		fio_send_file(client, pdu, cmd->tag);
 		break;
 		}
 	case FIO_NET_CMD_JOB_OPT: {
diff --git a/fio.h b/fio.h
index 66211e9..b71a486 100644
--- a/fio.h
+++ b/fio.h
@@ -32,7 +32,7 @@
 #include "profile.h"
 #include "fio_time.h"
 #include "gettime.h"
-#include "lib/getopt.h"
+#include "oslib/getopt.h"
 #include "lib/rand.h"
 #include "lib/rbtree.h"
 #include "client.h"
diff --git a/init.c b/init.c
index 991fa1c..77cf9f2 100644
--- a/init.c
+++ b/init.c
@@ -26,7 +26,7 @@
 #include "idletime.h"
 #include "filelock.h"
 
-#include "lib/getopt.h"
+#include "oslib/getopt.h"
 #include "oslib/strcasestr.h"
 
 #include "crc/test.h"
diff --git a/lib/getopt.h b/lib/getopt.h
deleted file mode 100644
index bc8a268..0000000
--- a/lib/getopt.h
+++ /dev/null
@@ -1,26 +0,0 @@
-#ifdef CONFIG_GETOPT_LONG_ONLY
-
-#include <getopt.h>
-
-#else
-
-#ifndef _GETOPT_H
-#define _GETOPT_H
-
-struct option {
-	const char *name;
-	int has_arg;
-	int *flag;
-	int val;
-};
-
-enum {
-	no_argument	  = 0,
-	required_argument = 1,
-	optional_argument = 2,
-};
-
-int getopt_long_only(int, char *const *, const char *, const struct option *, int *);
-
-#endif
-#endif
diff --git a/lib/pattern.c b/lib/pattern.c
index 6cb5995..b8ae809 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -1,6 +1,7 @@
 #include "fio.h"
 #include "strntol.h"
 #include "pattern.h"
+#include "../oslib/strcasestr.h"
 
 /**
  * parse_string() - parses string in double quotes, like "abc"
diff --git a/oslib/getopt.h b/oslib/getopt.h
new file mode 100644
index 0000000..bc8a268
--- /dev/null
+++ b/oslib/getopt.h
@@ -0,0 +1,26 @@
+#ifdef CONFIG_GETOPT_LONG_ONLY
+
+#include <getopt.h>
+
+#else
+
+#ifndef _GETOPT_H
+#define _GETOPT_H
+
+struct option {
+	const char *name;
+	int has_arg;
+	int *flag;
+	int val;
+};
+
+enum {
+	no_argument	  = 0,
+	required_argument = 1,
+	optional_argument = 2,
+};
+
+int getopt_long_only(int, char *const *, const char *, const struct option *, int *);
+
+#endif
+#endif
diff --git a/oslib/strcasestr.c b/oslib/strcasestr.c
index 92cf24c..2626609 100644
--- a/oslib/strcasestr.c
+++ b/oslib/strcasestr.c
@@ -1,6 +1,8 @@
 #include <ctype.h>
 #include <stddef.h>
 
+#ifndef CONFIG_STRCASESTR
+
 char *strcasestr(const char *s1, const char *s2)
 {
 	const char *s = s1;
@@ -23,3 +25,5 @@ char *strcasestr(const char *s1, const char *s2)
 
 	return *p ? NULL : (char *) s1;
 }
+
+#endif
