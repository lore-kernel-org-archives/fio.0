Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Subject: [PATCH] Add a new file to gitignore
Date: Sun, 21 Feb 2021 17:39:44 +0800
Message-Id: <20210221093944.1071-1-glqinhongwei@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, sitsofe@gmail.com, Hongwei Qin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

Add a new file to gitignore
Signed-off-by: Hongwei Qin <glqinhongwei@gmail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 0aa4a361..6651f96e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -30,3 +30,4 @@ doc/output
 /tags
 /TAGS
 /t/zbd/test-zbd-support.log.*
+/t/fuzz/fuzz_parseini
-- 
2.28.0


