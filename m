Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38804 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389228AbeKWDJP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Nov 2018 22:09:15 -0500
Received: by mail-pg1-f193.google.com with SMTP id g189so1937974pgc.5
        for <fio@vger.kernel.org>; Thu, 22 Nov 2018 08:29:10 -0800 (PST)
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/2] init: Fix -Wstringop-truncation warning on gcc 8.1
Date: Thu, 22 Nov 2018 08:48:26 -0800
Message-Id: <1542905306-12193-3-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1542905306-12193-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1542905306-12193-1-git-send-email-kusumi.tomohiro@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

gcc 8.1 on DragonFlyBSD is warning below.

The code looks correct, but gcc 8.1 seems to be complaining
on length argument "strlen(filename)".

Replacing the length with "len - ((ts - file) + 1) - 1",
(i.e. buffer_size - leading_directory_size_with_slash - 1)
can silence the warning, but this equals "strlen(filename)".
Neither allows copying beyond limit of "full_fn" whose size
is "len".

--
init.c:2042:6: warning: 'strncpy' output truncated before terminating nul copying as many bytes from a string as its length [-Wstringop-truncation]
      strncpy(full_fn + (ts - file) + 1,
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       filename, strlen(filename));
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init.c b/init.c
index a2b70c4..682a0c2 100644
--- a/init.c
+++ b/init.c
@@ -2040,7 +2040,8 @@ static int __parse_jobs_ini(struct thread_data *td,
 					strncpy(full_fn,
 						file, (ts - file) + 1);
 					strncpy(full_fn + (ts - file) + 1,
-						filename, strlen(filename));
+						filename,
+						len - ((ts - file) + 1) - 1);
 					full_fn[len - 1] = 0;
 					filename = full_fn;
 				}
-- 
1.7.1


