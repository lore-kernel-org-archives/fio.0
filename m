Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:56566 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBLPMw (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 10:12:52 -0500
From: "Daniel Gollub" <daniel.gollub@t-online.de>
Subject: [PATCH 2/2] Make parse.h C++ safe by avoiding "or" keyword
Date: Wed, 12 Feb 2014 15:51:55 +0100
Message-Id: <1392216715-9539-3-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392216715-9539-1-git-send-email-d.gollub@telekom.de>
References: <1392216715-9539-1-git-send-email-d.gollub@telekom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

Fixes for g++ (4.7.2) following compiler errors when fio.h
gets included (e.g. in an external C++ ioengine):

--8<---
[...]
parse.h:31:6: error: expected unqualified-id before ‘or’ token
[...]
--->8---

Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
---
 options.c |    6 +++---
 parse.c   |    4 ++--
 parse.h   |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/options.c b/options.c
index 57e9af5..a646546 100644
--- a/options.c
+++ b/options.c
@@ -1901,18 +1901,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  { .ival = "wait_before",
 			    .oval = SYNC_FILE_RANGE_WAIT_BEFORE,
 			    .help = "SYNC_FILE_RANGE_WAIT_BEFORE",
-			    .or	  = 1,
+			    .orval  = 1,
 			  },
 			  { .ival = "write",
 			    .oval = SYNC_FILE_RANGE_WRITE,
 			    .help = "SYNC_FILE_RANGE_WRITE",
-			    .or	  = 1,
+			    .orval  = 1,
 			  },
 			  {
 			    .ival = "wait_after",
 			    .oval = SYNC_FILE_RANGE_WAIT_AFTER,
 			    .help = "SYNC_FILE_RANGE_WAIT_AFTER",
-			    .or	  = 1,
+			    .orval  = 1,
 			  },
 		},
 		.type	= FIO_OPT_STR_MULTI,
diff --git a/parse.c b/parse.c
index 6141c91..f74f0a9 100644
--- a/parse.c
+++ b/parse.c
@@ -415,14 +415,14 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			if (!strncmp(vp->ival, ptr, str_match_len(vp, ptr))) {
 				ret = 0;
 				if (o->roff1) {
-					if (vp->or)
+					if (vp->orval)
 						*(unsigned int *) o->roff1 |= vp->oval;
 					else
 						*(unsigned int *) o->roff1 = vp->oval;
 				} else {
 					if (!o->off1)
 						continue;
-					val_store(ilp, vp->oval, o->off1, vp->or, data);
+					val_store(ilp, vp->oval, o->off1, vp->orval, data);
 				}
 				continue;
 			}
diff --git a/parse.h b/parse.h
index 34d99d4..b98b514 100644
--- a/parse.h
+++ b/parse.h
@@ -28,7 +28,7 @@ struct value_pair {
 	const char *ival;		/* string option */
 	unsigned int oval;		/* output value */
 	const char *help;		/* help text for sub option */
-	int or;				/* OR value */
+	int orval;			/* OR value */
 	void *cb;			/* sub-option callback */
 };
 
-- 
1.7.10.4

