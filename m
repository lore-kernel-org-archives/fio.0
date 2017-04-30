Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/6] Fix "cast from pointer to integer of different size" warning on OpenBSD
Date: Sun, 30 Apr 2017 20:35:06 +0300
Message-Id: <20170430173511.44593-2-tkusumi@tuxera.com>
In-Reply-To: <20170430173511.44593-1-tkusumi@tuxera.com>
References: <20170430173511.44593-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

OpenBSD has below compiler warning due to pthread_t being typedef'd
to struct pthread*.

 os/os-openbsd.h: In function 'gettid':
 os/os-openbsd.h:71: warning: cast from pointer to integer of different size

--
 # uname
 OpenBSD
 # grep pthread_t /usr/include -rI | grep typedef | head -1
 /usr/include/pthread.h:typedef struct   pthread                 *pthread_t;
 # cat ./p1.c
 #include <stdio.h>
 #include <pthread.h>
 int main(void) {
         pthread_t id = 1234;
         printf("%d\n", (int)id);
         return 0;
 }
 # gcc -Wall -g ./p1.c
 ./p1.c: In function 'main':
 ./p1.c:4: warning: initialization makes pointer from integer without a cast
 ./p1.c:5: warning: cast from pointer to integer of different size
 # ./a.out
 1234

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-openbsd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 7def432..9c7092c 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -68,7 +68,7 @@ static inline unsigned long long os_phys_mem(void)
 
 static inline int gettid(void)
 {
-	return (int) pthread_self();
+	return (int)(intptr_t) pthread_self();
 }
 
 static inline unsigned long long get_fs_free_size(const char *path)
-- 
2.9.3


