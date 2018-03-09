Return-Path: <prvs=599e16e30=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Remove prof_io_ops.fill_io_u_off(), .fill_io_u_size() and .get_next_file()
Date: Fri,  9 Mar 2018 09:16:23 -0800
Message-Id: <20180309171623.19487-1-bart.vanassche@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Remove the struct prof_io_ops methods for which no implementations
have been defined. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 io_u.c    | 21 ---------------------
 profile.h |  4 ----
 2 files changed, 25 deletions(-)

diff --git a/io_u.c b/io_u.c
index 61d09ba872e9..2ae05317f7c0 100644
--- a/io_u.c
+++ b/io_u.c
@@ -575,13 +575,6 @@ static int __get_next_offset(struct thread_data *td, struct io_u *io_u,
 static int get_next_offset(struct thread_data *td, struct io_u *io_u,
 			   unsigned int *is_random)
 {
-	if (td->flags & TD_F_PROFILE_OPS) {
-		struct prof_io_ops *ops = &td->prof_io_ops;
-
-		if (ops->fill_io_u_off)
-			return ops->fill_io_u_off(td, io_u, is_random);
-	}
-
 	return __get_next_offset(td, io_u, is_random);
 }
 
@@ -658,13 +651,6 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u,
 				    unsigned int is_random)
 {
-	if (td->flags & TD_F_PROFILE_OPS) {
-		struct prof_io_ops *ops = &td->prof_io_ops;
-
-		if (ops->fill_io_u_size)
-			return ops->fill_io_u_size(td, io_u, is_random);
-	}
-
 	return __get_next_buflen(td, io_u, is_random);
 }
 
@@ -1387,13 +1373,6 @@ out:
 
 static struct fio_file *get_next_file(struct thread_data *td)
 {
-	if (td->flags & TD_F_PROFILE_OPS) {
-		struct prof_io_ops *ops = &td->prof_io_ops;
-
-		if (ops->get_next_file)
-			return ops->get_next_file(td);
-	}
-
 	return __get_next_file(td);
 }
 
diff --git a/profile.h b/profile.h
index 8d1f757dd558..414151e8cb39 100644
--- a/profile.h
+++ b/profile.h
@@ -10,10 +10,6 @@ struct prof_io_ops {
 	int (*td_init)(struct thread_data *);
 	void (*td_exit)(struct thread_data *);
 
-	int (*fill_io_u_off)(struct thread_data *, struct io_u *, unsigned int *);
-	int (*fill_io_u_size)(struct thread_data *, struct io_u *, unsigned int);
-	struct fio_file *(*get_next_file)(struct thread_data *);
-
 	int (*io_u_lat)(struct thread_data *, uint64_t);
 };
 
-- 
2.16.2


