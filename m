Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/6] change fio_set_odirect() prototype not to use int fd
Date: Wed, 30 Aug 2017 00:12:15 +0300
Message-Id: <20170829211216.42347-6-tkusumi@tuxera.com>
In-Reply-To: <20170829211216.42347-1-tkusumi@tuxera.com>
References: <20170829211216.42347-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This function should take struct fio_file*, since the idea of integer
fd in unix likes isn't necessarily usable on other platforms (Windows).

In fact, other fd related functions under os/ don't take int fd for
portability even if some of them work fine with int fd at the moment.

(OS headers basically (should)have no dependencies on fio functions
and structures, but struct fio_file is the only exception.)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c     | 2 +-
 os/os-mac.h     | 4 ++--
 os/os-solaris.h | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 4ceaef6..c4240d2 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1862,7 +1862,7 @@ void filesetup_mem_free(void)
 int fio_set_directio(struct thread_data *td, struct fio_file *f)
 {
 #ifdef FIO_OS_DIRECTIO
-	int ret = fio_set_odirect(f->fd);
+	int ret = fio_set_odirect(f);
 
 	if (ret) {
 		td_verror(td, ret, "fio_set_directio");
diff --git a/os/os-mac.h b/os/os-mac.h
index a1536c7..92a60ee 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -41,9 +41,9 @@ typedef unsigned int clockid_t;
 #endif
 
 #define FIO_OS_DIRECTIO
-static inline int fio_set_odirect(int fd)
+static inline int fio_set_odirect(struct fio_file *f)
 {
-	if (fcntl(fd, F_NOCACHE, 1) == -1)
+	if (fcntl(f->fd, F_NOCACHE, 1) == -1)
 		return errno;
 	return 0;
 }
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 8f8f53b..6af25d2 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -85,9 +85,9 @@ static inline long os_random_long(os_random_state_t *rs)
 
 #define FIO_OS_DIRECTIO
 extern int directio(int, int);
-static inline int fio_set_odirect(int fd)
+static inline int fio_set_odirect(struct fio_file *f)
 {
-	if (directio(fd, DIRECTIO_ON) < 0)
+	if (directio(f->fd, DIRECTIO_ON) < 0)
 		return errno;
 
 	return 0;
-- 
2.9.5


