Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/3] null: fix compile time warning on OpenBSD
Date: Mon, 15 Jan 2018 21:06:41 +0200
Message-Id: <20180115190643.12105-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Fix the following warning on OpenBSD 6.2 (gcc 4.2.1).
This can probably be silenced with void** argument and memcpy() too,
but returning a non-void pointer is clearer IMO when the code also
targets C++.

Compiles with regular make/gmake as well as
 # g++ -O2 -g -shared -rdynamic -fPIC -o cpp_null null.c -DFIO_EXTERNAL_ENGINE

--
    CC engines/null.o
engines/null.c: In function 'fio_null_init':
engines/null.c:142: warning: dereferencing type-punned pointer will break strict-aliasing rules
---
 engines/null.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/engines/null.c b/engines/null.c
index 8a4d106b..47f29054 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -87,9 +87,9 @@ static void null_cleanup(struct null_data *nd)
 	}
 }
 
-static int null_init(struct thread_data *td, struct null_data **nd_ptr)
+static struct null_data *null_init(struct thread_data *td)
 {
-	struct null_data *nd = (struct null_data *) malloc(sizeof(**nd_ptr));
+	struct null_data *nd = (struct null_data *) malloc(sizeof(*nd));
 
 	memset(nd, 0, sizeof(*nd));
 
@@ -99,8 +99,7 @@ static int null_init(struct thread_data *td, struct null_data **nd_ptr)
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
 
-	*nd_ptr = nd;
-	return 0;
+	return nd;
 }
 
 #ifndef __cplusplus
@@ -139,7 +138,9 @@ static void fio_null_cleanup(struct thread_data *td)
 
 static int fio_null_init(struct thread_data *td)
 {
-	return null_init(td, (struct null_data **)&td->io_ops_data);
+	td->io_ops_data = null_init(td);
+	assert(td->io_ops_data);
+	return 0;
 }
 
 static struct ioengine_ops ioengine = {
@@ -172,7 +173,8 @@ static void fio_exit fio_null_unregister(void)
 struct NullData {
 	NullData(struct thread_data *td)
 	{
-		null_init(td, &impl_);
+		impl_ = null_init(td);
+		assert(impl_);
 	}
 
 	~NullData()
-- 
2.13.6


