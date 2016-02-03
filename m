Return-Path: <enwlinux@gmail.com>
Return-Path: <enwlinux@gmail.com>
Date: Wed, 3 Feb 2016 18:23:02 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] fio: fix ignore_error regression
Message-ID: <20160203232302.GA4500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: fio@vger.kernel.org
Cc: axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

Commit e9d512d8e7d2 introduced a regression affecting handling for
the ignore_error parameter.  The common code for io_u event handling
pulled from do_io() and do_verify() into io_queue_event() does not
check for and process errors that are to be ignored in the main I/O
path as I/Os are completed.  Prior to that commit, do_io() called
break_on_this_error() to handle that case.

The change causes fio to return a non-zero exit status after
encountering an error it should ignore while performing I/O, even
though the job does run to completion. This regression causes
failures for some fstests that use fio, including ext4/302, ext4/303,
and generic/300.

This patch restores the original error handling behavior.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 backend.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/backend.c b/backend.c
index 2078409..bf501fe 100644
--- a/backend.c
+++ b/backend.c
@@ -520,6 +520,14 @@ sync_done:
 			if (*ret < 0)
 				break;
 		}
+
+		/* 
+		 * when doing I/O (not when verifying),
+		 * check for any errors that are to be ignored
+		 */
+		if (!from_verify)
+			break;
+		
 		return 0;
 	case FIO_Q_QUEUED:
 		/*
-- 
2.1.4


