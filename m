Return-Path: <prvs=320bddd21=naohiro.aota@wdc.com>
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 2/2] doc: fix "thezoned" typo
Date: Fri, 28 Feb 2020 16:33:23 +0900
Message-Id: <20200228073323.4000336-2-naohiro.aota@wdc.com>
In-Reply-To: <20200228073323.4000336-1-naohiro.aota@wdc.com>
References: <20200228073323.4000336-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
List-ID: <fio@vger.kernel.org>

The man page is showing "thezoned", which lacks a space between "the" and
"zoned".  This patch trivially add the space.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index d728df8aca9e..9b8d73e0c7ff 100644
--- a/fio.1
+++ b/fio.1
@@ -1178,7 +1178,7 @@ example, the user would do:
 random_distribution=zoned:60/10:30/20:8/30:2/40
 .RE
 .P
-A \fBzoned_abs\fR distribution works exactly like the\fBzoned\fR, except that
+A \fBzoned_abs\fR distribution works exactly like the \fBzoned\fR, except that
 it takes absolute sizes. For example, let's say you wanted to define access
 according to the following criteria:
 .RS
-- 
2.25.1


