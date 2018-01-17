Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60250 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbeAQNAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Jan 2018 08:00:14 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1ebnK9-0008W3-Q4
        for fio@vger.kernel.org; Wed, 17 Jan 2018 13:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180117130002.C74F32C00C4@kernel.dk>
Date: Wed, 17 Jan 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 53bb5d9c037e842970b32bc828dbe809b42c144d:

  Merge branch 'diskless_invalidate' of https://github.com/sitsofe/fio (2018-01-12 10:59:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ca65714c48bcd4fc601e3c04163e2422352be9ca:

  null: drop unneeded casts from void* to non-void* (2018-01-16 08:32:39 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (3):
      null: fix compile time warning on OpenBSD
      null: make *impl_ private
      null: drop unneeded casts from void* to non-void*

 engines/null.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/engines/null.c b/engines/null.c
index 8a4d106..0cfc22a 100644
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
 
@@ -99,47 +99,48 @@ static int null_init(struct thread_data *td, struct null_data **nd_ptr)
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
 
-	*nd_ptr = nd;
-	return 0;
+	return nd;
 }
 
 #ifndef __cplusplus
 
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
@@ -211,6 +213,7 @@ struct NullData {
 		return null_open(impl_, f);
 	}
 
+private:
 	struct null_data *impl_;
 };
 
