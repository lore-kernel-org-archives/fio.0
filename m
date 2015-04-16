Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH] Fix mtd valgrind warning
Date: Thu, 16 Apr 2015 14:50:39 -0700
Message-Id: <1429221039-31612-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

strlen seems to operate in 32-bit chunks, but libmtd sometimes allocates
strings without that much padding. This patch adds something extra to
a string allocation so that the mtd ioengine is clean with respect
to valgrind memory access checks.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 lib/libmtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libmtd.c b/lib/libmtd.c
index e1b2be1..5c9eac2 100644
--- a/lib/libmtd.c
+++ b/lib/libmtd.c
@@ -55,7 +55,7 @@ static char *mkpath(const char *path, const char *name)
 	size_t len1 = strlen(path);
 	size_t len2 = strlen(name);
 
-	n = xmalloc(len1 + len2 + 2);
+	n = xmalloc(len1 + len2 + 6);
 
 	memcpy(n, path, len1);
 	if (n[len1 - 1] != '/')
-- 
2.2.0.rc0.207.ga3a616c


