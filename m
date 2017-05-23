Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/5] Drop struct thread_data dependency from os headers
Date: Tue, 23 May 2017 21:44:46 +0300
Message-Id: <20170523184449.48134-3-tkusumi@tuxera.com>
In-Reply-To: <20170523184449.48134-1-tkusumi@tuxera.com>
References: <20170523184449.48134-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Since os/os.h is included by fio.h before other functions/structures
are even defined, it's better for os/os*.h not to have dependency on
those (in this case it's struct thread_data and duplicated td_fill_
rand_seeds() prototypes) unless really needed. os/os*.h are basically
collections of small wrappers over syscalls/etc whose idea is similar
but with difference interface among supported platforms, thus they
normally don't need to have dependency on fio functions/structures,
and in fact they're normally designed that way.

This commit gets rid of struct thread_data argument from an inlined
function init_random_state(), which was needed only to call another
function td_fill_rand_seeds(td). This can simply be called from
setup_random_seeds() after init_random_state() without making any
functional difference. Also rename init_random_state() to
init_random_seeds() as it only initializes random seeds now.

With this commit, struct thread_data is completely gone from os/.
struct fio_file is still there, but this is needed by Windows where
the idea of fd differs from unix like in general.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c          | 10 +++++++---
 os/os-windows.h |  4 +---
 os/os.h         |  8 +-------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/init.c b/init.c
index 52a5f03..d224bd6 100644
--- a/init.c
+++ b/init.c
@@ -1080,8 +1080,12 @@ static int setup_random_seeds(struct thread_data *td)
 	unsigned long seed;
 	unsigned int i;
 
-	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed))
-		return init_random_state(td, td->rand_seeds, sizeof(td->rand_seeds));
+	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed)) {
+		int ret = init_random_seeds(td->rand_seeds, sizeof(td->rand_seeds));
+		if (!ret)
+			td_fill_rand_seeds(td);
+		return ret;
+	}
 
 	seed = td->o.rand_seed;
 	for (i = 0; i < 4; i++)
@@ -1376,7 +1380,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	prev_group_jobs++;
 
 	if (setup_random_seeds(td)) {
-		td_verror(td, errno, "init_random_state");
+		td_verror(td, errno, "setup_random_seeds");
 		goto err;
 	}
 
diff --git a/os/os-windows.h b/os/os-windows.h
index 0c8c42d..36b421e 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -116,7 +116,6 @@ int nanosleep(const struct timespec *rqtp, struct timespec *rmtp);
 ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset);
 ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
 		off_t offset);
-extern void td_fill_rand_seeds(struct thread_data *);
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
@@ -239,7 +238,7 @@ static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
 	return 0;
 }
 
-static inline int init_random_state(struct thread_data *td, unsigned long *rand_seeds, int size)
+static inline int init_random_seeds(unsigned long *rand_seeds, int size)
 {
 	HCRYPTPROV hCryptProv;
 
@@ -258,7 +257,6 @@ static inline int init_random_state(struct thread_data *td, unsigned long *rand_
 	}
 
 	CryptReleaseContext(hCryptProv, 0);
-	td_fill_rand_seeds(td);
 	return 0;
 }
 
diff --git a/os/os.h b/os/os.h
index c25cc36..21b7a9d 100644
--- a/os/os.h
+++ b/os/os.h
@@ -303,12 +303,7 @@ static inline long os_random_long(os_random_state_t *rs)
 #endif
 
 #ifdef FIO_USE_GENERIC_INIT_RANDOM_STATE
-extern void td_fill_rand_seeds(struct thread_data *td);
-/*
- * Initialize the various random states we need (random io, block size ranges,
- * read/write mix, etc).
- */
-static inline int init_random_state(struct thread_data *td, unsigned long *rand_seeds, int size)
+static inline int init_random_seeds(unsigned long *rand_seeds, int size)
 {
 	int fd;
 
@@ -323,7 +318,6 @@ static inline int init_random_state(struct thread_data *td, unsigned long *rand_
 	}
 
 	close(fd);
-	td_fill_rand_seeds(td);
 	return 0;
 }
 #endif
-- 
2.9.4


