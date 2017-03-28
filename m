Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 05/13] HOWTO: Mention niche detail of range format options
Date: Tue, 28 Mar 2017 23:02:53 +0300
Message-Id: <20170328200301.8622-5-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/HOWTO b/HOWTO
index cae95b7..80b9e75 100644
--- a/HOWTO
+++ b/HOWTO
@@ -543,6 +543,8 @@ Parameter types
 
 	If the option accepts an upper and lower range, use a colon ':' or
 	minus '-' to separate such values. See :ref:`irange <irange>`.
+	If the lower value specified happens to be larger than the upper value,
+	two values are swapped.
 
 .. _bool:
 
-- 
2.9.3


