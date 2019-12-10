Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/9] .gitignore: ignore zbd test output files
Date: Tue, 10 Dec 2019 12:54:34 -0500
Message-Id: <20191210175442.2975-2-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index f86bec64..b228938d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,3 +25,4 @@ lex.yy.c
 doc/output
 /tags
 /TAGS
+/t/zbd/test-zbd-support.log.*
-- 
2.17.1


