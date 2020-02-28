Return-Path: <prvs=320bddd21=naohiro.aota@wdc.com>
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 1/2] doc: fix zoned_abs example
Date: Fri, 28 Feb 2020 16:33:22 +0900
Message-Id: <20200228073323.4000336-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
List-ID: <fio@vger.kernel.org>

It seems the example shown in "zoned_abs" desciption is copied from "zoned"
example by mistake. Fix the example according to the desciption.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index 1db12c2ff41e..d728df8aca9e 100644
--- a/fio.1
+++ b/fio.1
@@ -1195,7 +1195,7 @@ according to the following criteria:
 we can define an absolute zoning distribution with:
 .RS
 .P
-random_distribution=zoned:60/10:30/20:8/30:2/40
+random_distribution=zoned_abs:60/20G:30/100G:10/500G
 .RE
 .P
 For both \fBzoned\fR and \fBzoned_abs\fR, fio supports defining up to 256
-- 
2.25.1


