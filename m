Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbeHUW3x (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Aug 2018 18:29:53 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 2/2] init: add semantics for all types of backends running
Date: Tue, 21 Aug 2018 12:08:24 -0700
Message-Id: <20180821190824.29928-3-mcgrof@kernel.org>
In-Reply-To: <20180821190824.29928-1-mcgrof@kernel.org>
References: <20180821190824.29928-1-mcgrof@kernel.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: andrey.o.kudryavtsev@intel.com, Luis Chamberlain <mcgrof@kernel.org>

Commit 67a176fc7 ("Fix segfault with client/server and minimal output")
addressed a segfault but it wasn't very clear *why* the fix was needed.
The reason it was needed is that the disk util and its respective
semaphore are only initialized when setup_disk_util() is called, this
happens upon fio_backend() calls. That is, either we have a dedicated
backend or have initiated a backend for the localhost due to some local
work. And show_thread_status() is currently called from a complete
client setup -- handle_ts() calls show_thread_status(), and a client
does not collect any local disk data, it receives this from the backend.
As such, the semaphore won't be setup in a client setup and this is why
we segfault here.

We can enable show_thread_status() then only if any type of backend is
running, however there is are no semantics currently which enable us to
query for this. Add such semantics and replace the previous check with
a check for if fio_backend() was ever called. This will make it clearer.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 backend.c  | 2 ++
 diskutil.c | 2 +-
 fio.h      | 8 ++++++++
 init.c     | 1 +
 stat.c     | 2 +-
 5 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/backend.c b/backend.c
index 36bde6a5..8fec1ce3 100644
--- a/backend.c
+++ b/backend.c
@@ -2481,6 +2481,8 @@ int fio_backend(struct sk_out *sk_out)
 	}
 
 	startup_sem = fio_sem_init(FIO_SEM_LOCKED);
+	if (!sk_out)
+		is_local_backend = true;
 	if (startup_sem == NULL)
 		return 1;
 
diff --git a/diskutil.c b/diskutil.c
index 5b4eb46d..7be4c022 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -701,7 +701,7 @@ void show_disk_util(int terse, struct json_object *parent,
 	struct disk_util *du;
 	bool do_json;
 
-	if (!disk_util_sem)
+	if (!is_running_backend())
 		return;
 
 	fio_sem_down(disk_util_sem);
diff --git a/fio.h b/fio.h
index b58057f7..ce3583cb 100644
--- a/fio.h
+++ b/fio.h
@@ -522,6 +522,7 @@ extern int fio_clock_source_set;
 extern int warnings_fatal;
 extern int terse_version;
 extern int is_backend;
+extern int is_local_backend;
 extern int nr_clients;
 extern int log_syslog;
 extern int status_interval;
@@ -534,6 +535,13 @@ extern char *aux_path;
 
 extern struct thread_data *threads;
 
+static inline bool is_running_backend(void)
+{
+	if (is_backend || is_local_backend)
+		return true;
+	return false;
+}
+
 extern bool eta_time_within_slack(unsigned int time);
 
 static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
diff --git a/init.c b/init.c
index 06f69719..3ed57570 100644
--- a/init.c
+++ b/init.c
@@ -63,6 +63,7 @@ char *exec_profile = NULL;
 int warnings_fatal = 0;
 int terse_version = 3;
 int is_backend = 0;
+int is_local_backend = 0;
 int nr_clients = 0;
 int log_syslog = 0;
 
diff --git a/stat.c b/stat.c
index edf9ecf6..6cb704eb 100644
--- a/stat.c
+++ b/stat.c
@@ -1205,7 +1205,7 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
 
 	/* disk util stats, if any */
-	if (ver >= 3)
+	if (ver >= 3 && is_running_backend())
 		show_disk_util(1, NULL, out);
 
 	/* Additional output if continue_on_error set - default off*/
-- 
2.18.0


