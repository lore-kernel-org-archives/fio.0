Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 6/6] gettime: make utime_since_now and mtime_since_now consistent in how they record the caller and put this all behind FIO_DEBUG_TIME
Date: Sun, 16 Apr 2017 15:04:28 -0400
Message-Id: <1492369468-29448-6-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
References: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@sandisk.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <Vincent.Fu@sandisk.com>

---
 gettime.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/gettime.c b/gettime.c
index 85ba7cb..628aad6 100644
--- a/gettime.c
+++ b/gettime.c
@@ -402,8 +402,14 @@ uint64_t utime_since(const struct timeval *s, const struct timeval *e)
 uint64_t utime_since_now(const struct timeval *s)
 {
 	struct timeval t;
+#ifdef FIO_DEBUG_TIME
+	void *p = __builtin_return_address(0);
 
+	fio_gettime(&t, p);
+#else
 	fio_gettime(&t, NULL);
+#endif
+
 	return utime_since(s, &t);
 }
 
@@ -429,9 +435,14 @@ uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
 uint64_t mtime_since_now(const struct timeval *s)
 {
 	struct timeval t;
+#ifdef FIO_DEBUG_TIME
 	void *p = __builtin_return_address(0);
 
 	fio_gettime(&t, p);
+#else
+	fio_gettime(&t, NULL);
+#endif
+
 	return mtime_since(s, &t);
 }
 
-- 
2.7.4


