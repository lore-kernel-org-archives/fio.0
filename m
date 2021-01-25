Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Subject: [PATCH v6 3/3] Fix fio.1
Date: Mon, 25 Jan 2021 20:40:01 +0800
Message-Id: <7f25f16b87fdbdceaaaf66c1d345d981a1984dcc.1611578199.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1611578199.git.glqinhongwei@gmail.com>
References: <cover.1611578199.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1611578199.git.glqinhongwei@gmail.com>
References: <cover.1611578199.git.glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, sitsofe@gmail.com, Hongwei Qin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

Fix the manual format.

Signed-off-by: Hongwei Qin <glqinhongwei@gmail.com>
---
 fio.1 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fio.1 b/fio.1
index 5d08e81..bf5d2b5 100644
--- a/fio.1
+++ b/fio.1
@@ -2314,9 +2314,9 @@ before we have to complete it and do our \fBthinktime\fR. In other words, this
 setting effectively caps the queue depth if the latter is larger.
 .TP
 .BI thinktime_blocks_type \fR=\fPstr
-Only valid if \fBthinktime\fR is set - control how \fBthinktime_blocks triggers.
-The default is `complete`, which triggers thinktime when fio completes
-\fBthinktime_blocks blocks. If this is set to `issue`, then the trigger happens
+Only valid if \fBthinktime\fR is set - control how \fBthinktime_blocks\fR triggers.
+The default is `complete', which triggers \fBthinktime\fR when fio completes
+\fBthinktime_blocks\fR blocks. If this is set to `issue', then the trigger happens
 at the issue side.
 .TP
 .BI rate \fR=\fPint[,int][,int]
-- 
1.8.3.1


