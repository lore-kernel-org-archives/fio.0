Return-Path: <zhu.yanhai@gmail.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: [PATCH] Fix a typo in fio.1
Date: Mon,  8 Aug 2011 14:59:04 +0800
Message-Id: <1312786744-11648-1-git-send-email-gaoyang.zyh@taobao.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>
List-ID: <fio@vger.kernel.org>

softrandommap requires an bool argument actually.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
---
 fio.1 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fio.1 b/fio.1
index 21ccda5..4fcd511 100644
--- a/fio.1
+++ b/fio.1
@@ -512,7 +512,7 @@ Normally \fBfio\fR will cover every block of the file when doing random I/O. If
 this parameter is given, a new offset will be chosen without looking at past
 I/O history.  This parameter is mutually exclusive with \fBverify\fR.
 .TP
-.B softrandommap
+.BI softrandommap \fR=\fPbool
 See \fBnorandommap\fR. If fio runs with the random block map enabled and it
 fails to allocate the map, if this option is set it will continue without a
 random block map. As coverage will not be as complete as with random maps, this
-- 
1.7.4.4


