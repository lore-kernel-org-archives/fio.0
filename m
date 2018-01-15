Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/3] null: drop unneeded casts from void* to non-void*
Date: Mon, 15 Jan 2018 21:52:12 +0200
Message-Id: <20180115195212.1349-4-tkusumi@tuxera.com>
In-Reply-To: <20180115195212.1349-1-tkusumi@tuxera.com>
References: <20180115195212.1349-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Some functions in null ioengine are used by C/C++ (e.g. null_init()
which calls malloc(3)), but C specific ones (not __cplusplus) don't
need explicit cast from void* to non-void*, and one usually doesn't.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/null.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/engines/null.c b/engines/null.c
index cf1ee1f2..0cfc22ad 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -106,34 +106,34 @@ static struct null_data *null_init(struct thread_data *td)
 
 static struct io_u *fio_null_event(struct thread_data *td, int event)
 {
-	return null_event((struct null_data *)td->io_ops_data, event);
+	return null_event(td->io_ops_data, event);
 }
 
 static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 			      unsigned int max, const struct timespec *t)
 {
-	struct null_data *nd = (struct null_data *)td->io_ops_data;
+	struct null_data *nd = td->io_ops_data;
 	return null_getevents(nd, min_events, max, t);
 }
 
 static int fio_null_commit(struct thread_data *td)
 {
-	return null_commit(td, (struct null_data *)td->io_ops_data);
+	return null_commit(td, td->io_ops_data);
 }
 
 static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
 {
-	return null_queue(td, (struct null_data *)td->io_ops_data, io_u);
+	return null_queue(td, td->io_ops_data, io_u);
 }
 
 static int fio_null_open(struct thread_data *td, struct fio_file *f)
 {
-	return null_open((struct null_data *)td->io_ops_data, f);
+	return null_open(td->io_ops_data, f);
 }
 
 static void fio_null_cleanup(struct thread_data *td)
 {
-	null_cleanup((struct null_data *)td->io_ops_data);
+	null_cleanup(td->io_ops_data);
 }
 
 static int fio_null_init(struct thread_data *td)
-- 
2.13.6


