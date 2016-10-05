Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34288 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936254AbcJEWPh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Oct 2016 18:15:37 -0400
Received: by mail-pa0-f50.google.com with SMTP id rz1so667490pab.1
        for <fio@vger.kernel.org>; Wed, 05 Oct 2016 15:15:37 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 1/4] init: fix --bandwidth-log without argument
Date: Wed,  5 Oct 2016 15:15:26 -0700
Message-Id: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

--bandwidth-log doesn't do anything with the argument that it requires,
and the documentation doesn't indicate that it takes an argument.

Fixes: b46928282e0a ("[PATCH] Add full command line parameter support")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init.c b/init.c
index c556fa2..eb6f4a6 100644
--- a/init.c
+++ b/init.c
@@ -103,7 +103,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	},
 	{
 		.name		= (char *) "bandwidth-log",
-		.has_arg	= required_argument,
+		.has_arg	= no_argument,
 		.val		= 'b' | FIO_CLIENT_FLAG,
 	},
 	{
-- 
2.10.0

