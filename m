Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/3] null: make *impl_ private
Date: Mon, 15 Jan 2018 21:52:11 +0200
Message-Id: <20180115195212.1349-3-tkusumi@tuxera.com>
In-Reply-To: <20180115195212.1349-1-tkusumi@tuxera.com>
References: <20180115195212.1349-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This can/should be private, given struct is default public in C++.
The null ioengine only needs access to new'd NullData which
encapsulates malloc'd null_data *impl_.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/null.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/engines/null.c b/engines/null.c
index 47f29054..cf1ee1f2 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -213,6 +213,7 @@ struct NullData {
 		return null_open(impl_, f);
 	}
 
+private:
 	struct null_data *impl_;
 };
 
-- 
2.13.6


