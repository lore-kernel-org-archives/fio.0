Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64777 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2BBBkN (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Feb 2012 20:40:13 -0500
Received: by qadc10 with SMTP id c10so3923414qad.19
        for <fio@vger.kernel.org>; Wed, 01 Feb 2012 17:40:12 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Wed, 1 Feb 2012 17:39:52 -0800
Message-ID: <CAAUT-yOCgVD61WtQB4CtY86zzYFCBfN4G=F=QCd4kvqFb4zx+Q@mail.gmail.com>
Subject: [PATCH] Optimize pattern filling by limiting small calls to memcpy.
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

In looking at profiling the speed of fill_pattern(), it calls memcpy()
for the fill pattern repeatedly for multibyte patterns.  So for a 4
byte pattern with 8k IO, it calls memcpy() 2048 times.

Since there is already 512 bytes reserved for the pattern, I figured a
simple solution was to use it.  This patch replicates short patterns
so they can be more efficiently copied.  (Single byte patterns are
left alone since they can make use of the much more efficient memset()
call.)

The result is a 10x performance improvement on pattern filling.  (With
this patch, it's still 3x slower than when it re-uses the already
filled pattern.)

---
 options.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/options.c b/options.c
index f9bd1a4..b6989d4 100644
--- a/options.c
+++ b/options.c
@@ -689,6 +689,10 @@ static int str_verify_pattern_cb(void *data,
const char *input)
 			}
 		}
 	}
+	while (i > 1 && i * 2 <= MAX_PATTERN_SIZE) {
+		memcpy(&td->o.verify_pattern[i], &td->o.verify_pattern[0], i);
+		i *= 2;
+	}
 	td->o.verify_pattern_bytes = i;
 	/*
 	 * VERIFY_META could already be set
-- 
1.7.7.3
