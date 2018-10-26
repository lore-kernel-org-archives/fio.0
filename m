Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40894 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbeJ0AyT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Oct 2018 20:54:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id o14-v6so759900pgv.7
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 09:16:40 -0700 (PDT)
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 6/7] lib: fix strntol's end pointer when str has leading spaces
Date: Fri, 26 Oct 2018 09:35:45 -0700
Message-Id: <1540571746-12885-7-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

Fix unittests/lib/strntol.c test case failure.

Given behavior of strtol(3), "end" pointer should be calculated
based on "beg" pointer instead of "str" on success.

Otherwise if "str" has leading spaces (which are explicitly ignored
by strntol()), "end" won't point to "the first invalid character"
for not counting those spaces.

Glibc's strtol(3) says as follows.
--
 If endptr is not NULL, strtol() stores the address of the first
 invalid character in *endptr.  If there were no digits at all,
 strtol() stores the original value of nptr in *endptr (and returns 0).
 In particular, if *nptr is not '\0' but **endptr is '\0' on return,
 the entire string is valid.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 lib/strntol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/strntol.c b/lib/strntol.c
index f622c8d..c3a55a1 100644
--- a/lib/strntol.c
+++ b/lib/strntol.c
@@ -28,6 +28,6 @@ long strntol(const char *str, size_t sz, char **end, int base)
 	if (ret == LONG_MIN || ret == LONG_MAX)
 		return ret;
 	if (end)
-		*end = (char *)str + (*end - buf);
+		*end = (char *)beg + (*end - buf);
 	return ret;
 }
-- 
1.7.1


