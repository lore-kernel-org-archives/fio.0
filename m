Return-Path: <prvs=4108b2f29=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] pshared: Add mutex_init_pshared_with_type()
Date: Thu, 28 May 2020 21:56:41 +0900
Message-Id: <20200528125642.103863-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200528125642.103863-1-shinichiro.kawasaki@wdc.com>
References: <20200528125642.103863-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

To initialize mutex to be shared across processes, the helper function
mutex_init_pshared() is available. However, it does not allow to set
mutex attribute types such as POSIX_MUTEX_RECURSIVE.

To allow setting mutex attribute types, introduce another helper function
mutex_init_pshared_with_type(). It initialize mutex for sharing across
processes and set attribute types specified as its argument.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 pshared.c | 15 ++++++++++++++-
 pshared.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/pshared.c b/pshared.c
index 21192556..791faf95 100644
--- a/pshared.c
+++ b/pshared.c
@@ -39,7 +39,7 @@ int cond_init_pshared(pthread_cond_t *cond)
 	return 0;
 }
 
-int mutex_init_pshared(pthread_mutex_t *mutex)
+int mutex_init_pshared_with_type(pthread_mutex_t *mutex, int type)
 {
 	pthread_mutexattr_t mattr;
 	int ret;
@@ -60,6 +60,14 @@ int mutex_init_pshared(pthread_mutex_t *mutex)
 		return ret;
 	}
 #endif
+	if (type) {
+		ret = pthread_mutexattr_settype(&mattr, type);
+		if (ret) {
+			log_err("pthread_mutexattr_settype: %s\n",
+				strerror(ret));
+			return ret;
+		}
+	}
 	ret = pthread_mutex_init(mutex, &mattr);
 	if (ret) {
 		log_err("pthread_mutex_init: %s\n", strerror(ret));
@@ -69,6 +77,11 @@ int mutex_init_pshared(pthread_mutex_t *mutex)
 	return 0;
 }
 
+int mutex_init_pshared(pthread_mutex_t *mutex)
+{
+	return mutex_init_pshared_with_type(mutex, 0);
+}
+
 int mutex_cond_init_pshared(pthread_mutex_t *mutex, pthread_cond_t *cond)
 {
 	int ret;
diff --git a/pshared.h b/pshared.h
index a58df6fe..f33be462 100644
--- a/pshared.h
+++ b/pshared.h
@@ -3,6 +3,7 @@
 
 #include <pthread.h>
 
+extern int mutex_init_pshared_with_type(pthread_mutex_t *, int);
 extern int mutex_init_pshared(pthread_mutex_t *);
 extern int cond_init_pshared(pthread_cond_t *);
 extern int mutex_cond_init_pshared(pthread_mutex_t *, pthread_cond_t *);
-- 
2.25.4


