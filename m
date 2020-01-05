Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgAENAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 5 Jan 2020 08:00:07 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1io5Vn-0004f4-5b
        for fio@vger.kernel.org; Sun, 05 Jan 2020 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200105130002.26C451BC0CA9@kernel.dk>
Date: Sun,  5 Jan 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 235b09b68d9bbc5150891faca47f5397d7e806bb:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-03 21:00:17 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fa6e7f4fb827adb124dbb97a7f72d64e76b2fe6a:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-04 20:22:16 -0700)

----------------------------------------------------------------
Bart Van Assche (6):
      Handle helper_thread_create() failures properly
      Fix a potential deadlock in helper_do_stat()
      Block signals for the helper thread
      helper_thread: Complain if select() fails
      t/memlock: Free allocated memory
      t/read-to-pipe-async: Complain if option -f is specified multiple times

Jens Axboe (2):
      Merge branch 'master' of https://github.com/bvanassche/fio
      Merge branch 'master' of https://github.com/bvanassche/fio

 backend.c              |   3 +-
 configure              |  66 ++++++++++++++++
 helper_thread.c        | 211 ++++++++++++++++++++++++++++++++++++++++---------
 t/memlock.c            |   1 +
 t/read-to-pipe-async.c |   2 +
 5 files changed, 244 insertions(+), 39 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d0d691b3..0d1f4734 100644
--- a/backend.c
+++ b/backend.c
@@ -2495,7 +2495,8 @@ int fio_backend(struct sk_out *sk_out)
 
 	set_genesis_time();
 	stat_init();
-	helper_thread_create(startup_sem, sk_out);
+	if (helper_thread_create(startup_sem, sk_out))
+		log_err("fio: failed to create helper thread\n");
 
 	cgroup_list = smalloc(sizeof(*cgroup_list));
 	if (cgroup_list)
diff --git a/configure b/configure
index 3a675a46..fa6df532 100755
--- a/configure
+++ b/configure
@@ -726,6 +726,27 @@ elif compile_prog "" "$LIBS -lpthread" "pthread_condattr_setclock" ; then
 fi
 print_config "pthread_condattr_setclock()" "$pthread_condattr_setclock"
 
+##########################################
+# pthread_sigmask() probe
+if test "$pthread_sigmask" != "yes" ; then
+  pthread_sigmask="no"
+fi
+cat > $TMPC <<EOF
+#include <stddef.h> /* NULL */
+#include <signal.h> /* pthread_sigmask() */
+int main(void)
+{
+  return pthread_sigmask(0, NULL, NULL);
+}
+EOF
+if compile_prog "" "$LIBS" "pthread_sigmask" ; then
+  pthread_sigmask=yes
+elif compile_prog "" "$LIBS -lpthread" "pthread_sigmask" ; then
+  pthread_sigmask=yes
+  LIBS="$LIBS -lpthread"
+fi
+print_config "pthread_sigmask()" "$pthread_sigmask"
+
 ##########################################
 # solaris aio probe
 if test "$solaris_aio" != "yes" ; then
@@ -1113,6 +1134,42 @@ if compile_prog "" "" "fdatasync"; then
 fi
 print_config "fdatasync" "$fdatasync"
 
+##########################################
+# pipe() probe
+if test "$pipe" != "yes" ; then
+  pipe="no"
+fi
+cat > $TMPC << EOF
+#include <unistd.h>
+int main(int argc, char **argv)
+{
+  int fd[2];
+  return pipe(fd);
+}
+EOF
+if compile_prog "" "" "pipe"; then
+  pipe="yes"
+fi
+print_config "pipe()" "$pipe"
+
+##########################################
+# pipe2() probe
+if test "$pipe2" != "yes" ; then
+  pipe2="no"
+fi
+cat > $TMPC << EOF
+#include <unistd.h>
+int main(int argc, char **argv)
+{
+  int fd[2];
+  return pipe2(fd, 0);
+}
+EOF
+if compile_prog "" "" "pipe2"; then
+  pipe2="yes"
+fi
+print_config "pipe2()" "$pipe2"
+
 ##########################################
 # pread() probe
 if test "$pread" != "yes" ; then
@@ -2498,6 +2555,9 @@ fi
 if test "$pthread_condattr_setclock" = "yes" ; then
   output_sym "CONFIG_PTHREAD_CONDATTR_SETCLOCK"
 fi
+if test "$pthread_sigmask" = "yes" ; then
+  output_sym "CONFIG_PTHREAD_SIGMASK"
+fi
 if test "$have_asprintf" = "yes" ; then
     output_sym "CONFIG_HAVE_ASPRINTF"
 fi
@@ -2513,6 +2573,12 @@ fi
 if test "$fdatasync" = "yes" ; then
   output_sym "CONFIG_FDATASYNC"
 fi
+if test "$pipe" = "yes" ; then
+  output_sym "CONFIG_PIPE"
+fi
+if test "$pipe2" = "yes" ; then
+  output_sym "CONFIG_PIPE2"
+fi
 if test "$pread" = "yes" ; then
   output_sym "CONFIG_PREAD"
 fi
diff --git a/helper_thread.c b/helper_thread.c
index eba2898a..78749855 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -1,3 +1,4 @@
+#include <signal.h>
 #ifdef CONFIG_VALGRIND_DEV
 #include <valgrind/drd.h>
 #else
@@ -10,48 +11,103 @@
 #include "steadystate.h"
 #include "pshared.h"
 
+enum action {
+	A_EXIT		= 1,
+	A_RESET		= 2,
+	A_DO_STAT	= 3,
+};
+
 static struct helper_data {
 	volatile int exit;
-	volatile int reset;
-	volatile int do_stat;
+	int pipe[2]; /* 0: read end; 1: write end. */
 	struct sk_out *sk_out;
 	pthread_t thread;
-	pthread_mutex_t lock;
-	pthread_cond_t cond;
 	struct fio_sem *startup_sem;
 } *helper_data;
 
 void helper_thread_destroy(void)
 {
-	pthread_cond_destroy(&helper_data->cond);
-	pthread_mutex_destroy(&helper_data->lock);
+	if (!helper_data)
+		return;
+
+	close(helper_data->pipe[0]);
+	close(helper_data->pipe[1]);
 	sfree(helper_data);
 }
 
-void helper_reset(void)
+#ifdef _WIN32
+static void sock_init(void)
 {
-	if (!helper_data)
-		return;
+	WSADATA wsaData;
+	int res;
 
-	pthread_mutex_lock(&helper_data->lock);
+	/* It is allowed to call WSAStartup() more than once. */
+	res = WSAStartup(MAKEWORD(2, 2), &wsaData);
+	assert(res == 0);
+}
 
-	if (!helper_data->reset) {
-		helper_data->reset = 1;
-		pthread_cond_signal(&helper_data->cond);
-	}
+static int make_nonblocking(int fd)
+{
+	unsigned long arg = 1;
 
-	pthread_mutex_unlock(&helper_data->lock);
+	return ioctlsocket(fd, FIONBIO, &arg);
 }
 
-void helper_do_stat(void)
+static int write_to_pipe(int fd, const void *buf, size_t len)
+{
+	return send(fd, buf, len, 0);
+}
+
+static int read_from_pipe(int fd, void *buf, size_t len)
+{
+	return recv(fd, buf, len, 0);
+}
+#else
+static void sock_init(void)
+{
+}
+
+static int make_nonblocking(int fd)
+{
+	return fcntl(fd, F_SETFL, O_NONBLOCK);
+}
+
+static int write_to_pipe(int fd, const void *buf, size_t len)
+{
+	return write(fd, buf, len);
+}
+
+static int read_from_pipe(int fd, void *buf, size_t len)
+{
+	return read(fd, buf, len);
+}
+#endif
+
+static void submit_action(enum action a)
 {
+	const char data = a;
+	int ret;
+
 	if (!helper_data)
 		return;
 
-	pthread_mutex_lock(&helper_data->lock);
-	helper_data->do_stat = 1;
-	pthread_cond_signal(&helper_data->cond);
-	pthread_mutex_unlock(&helper_data->lock);
+	ret = write_to_pipe(helper_data->pipe[1], &data, sizeof(data));
+	assert(ret == 1);
+}
+
+void helper_reset(void)
+{
+	submit_action(A_RESET);
+}
+
+/*
+ * May be invoked in signal handler context and hence must only call functions
+ * that are async-signal-safe. See also
+ * https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_04_03.
+ */
+void helper_do_stat(void)
+{
+	submit_action(A_DO_STAT);
 }
 
 bool helper_should_exit(void)
@@ -64,14 +120,12 @@ bool helper_should_exit(void)
 
 void helper_thread_exit(void)
 {
-	void *ret;
+	if (!helper_data)
+		return;
 
-	pthread_mutex_lock(&helper_data->lock);
 	helper_data->exit = 1;
-	pthread_cond_signal(&helper_data->cond);
-	pthread_mutex_unlock(&helper_data->lock);
-
-	pthread_join(helper_data->thread, &ret);
+	submit_action(A_EXIT);
+	pthread_join(helper_data->thread, NULL);
 }
 
 static void *helper_thread_main(void *data)
@@ -79,10 +133,23 @@ static void *helper_thread_main(void *data)
 	struct helper_data *hd = data;
 	unsigned int msec_to_next_event, next_log, next_ss = STEADYSTATE_MSEC;
 	struct timespec ts, last_du, last_ss;
+	char action;
 	int ret = 0;
 
 	sk_out_assign(hd->sk_out);
 
+#ifdef HAVE_PTHREAD_SIGMASK
+	{
+	sigset_t sigmask;
+
+	/* Let another thread handle signals. */
+	ret = pthread_sigmask(SIG_UNBLOCK, NULL, &sigmask);
+	assert(ret == 0);
+	ret = pthread_sigmask(SIG_BLOCK, &sigmask, NULL);
+	assert(ret == 0);
+	}
+#endif
+
 #ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
 	clock_gettime(CLOCK_MONOTONIC, &ts);
 #else
@@ -96,11 +163,27 @@ static void *helper_thread_main(void *data)
 	msec_to_next_event = DISK_UTIL_MSEC;
 	while (!ret && !hd->exit) {
 		uint64_t since_du, since_ss = 0;
+		struct timeval timeout = {
+			.tv_sec  = DISK_UTIL_MSEC / 1000,
+			.tv_usec = (DISK_UTIL_MSEC % 1000) * 1000,
+		};
+		fd_set rfds, efds;
 
 		timespec_add_msec(&ts, msec_to_next_event);
 
-		pthread_mutex_lock(&hd->lock);
-		pthread_cond_timedwait(&hd->cond, &hd->lock, &ts);
+		if (read_from_pipe(hd->pipe[0], &action, sizeof(action)) < 0) {
+			FD_ZERO(&rfds);
+			FD_SET(hd->pipe[0], &rfds);
+			FD_ZERO(&efds);
+			FD_SET(hd->pipe[0], &efds);
+			ret = select(1, &rfds, NULL, &efds, &timeout);
+			if (ret < 0)
+				log_err("fio: select() call in helper thread failed: %s",
+					strerror(errno));
+			if (read_from_pipe(hd->pipe[0], &action, sizeof(action)) <
+			    0)
+				action = 0;
+		}
 
 #ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
 		clock_gettime(CLOCK_MONOTONIC, &ts);
@@ -108,14 +191,11 @@ static void *helper_thread_main(void *data)
 		clock_gettime(CLOCK_REALTIME, &ts);
 #endif
 
-		if (hd->reset) {
-			memcpy(&last_du, &ts, sizeof(ts));
-			memcpy(&last_ss, &ts, sizeof(ts));
-			hd->reset = 0;
+		if (action == A_RESET) {
+			last_du = ts;
+			last_ss = ts;
 		}
 
-		pthread_mutex_unlock(&hd->lock);
-
 		since_du = mtime_since(&last_du, &ts);
 		if (since_du >= DISK_UTIL_MSEC || DISK_UTIL_MSEC - since_du < 10) {
 			ret = update_io_ticks();
@@ -126,10 +206,8 @@ static void *helper_thread_main(void *data)
 		} else
 			msec_to_next_event = DISK_UTIL_MSEC - since_du;
 
-		if (hd->do_stat) {
-			hd->do_stat = 0;
+		if (action == A_DO_STAT)
 			__show_running_run_stats();
-		}
 
 		next_log = calc_log_samples();
 		if (!next_log)
@@ -161,6 +239,54 @@ static void *helper_thread_main(void *data)
 	return NULL;
 }
 
+/*
+ * Connect two sockets to each other to emulate the pipe() system call on Windows.
+ */
+int pipe_over_loopback(int fd[2])
+{
+	struct sockaddr_in addr = { .sin_family = AF_INET };
+	socklen_t len = sizeof(addr);
+	int res;
+
+	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+	sock_init();
+
+	fd[0] = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd[0] < 0)
+		goto err;
+	fd[1] = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd[1] < 0)
+		goto close_fd_0;
+	res = bind(fd[0], (struct sockaddr *)&addr, len);
+	if (res < 0)
+		goto close_fd_1;
+	res = getsockname(fd[0], (struct sockaddr *)&addr, &len);
+	if (res < 0)
+		goto close_fd_1;
+	res = listen(fd[0], 1);
+	if (res < 0)
+		goto close_fd_1;
+	res = connect(fd[1], (struct sockaddr *)&addr, len);
+	if (res < 0)
+		goto close_fd_1;
+	res = accept(fd[0], NULL, NULL);
+	if (res < 0)
+		goto close_fd_1;
+	close(fd[0]);
+	fd[0] = res;
+	return 0;
+
+close_fd_1:
+	close(fd[1]);
+
+close_fd_0:
+	close(fd[0]);
+
+err:
+	return -1;
+}
+
 int helper_thread_create(struct fio_sem *startup_sem, struct sk_out *sk_out)
 {
 	struct helper_data *hd;
@@ -173,10 +299,19 @@ int helper_thread_create(struct fio_sem *startup_sem, struct sk_out *sk_out)
 
 	hd->sk_out = sk_out;
 
-	ret = mutex_cond_init_pshared(&hd->lock, &hd->cond);
+#if defined(CONFIG_PIPE2)
+	ret = pipe2(hd->pipe, O_CLOEXEC);
+#elif defined(CONFIG_PIPE)
+	ret = pipe(hd->pipe);
+#else
+	ret = pipe_over_loopback(hd->pipe);
+#endif
 	if (ret)
 		return 1;
 
+	ret = make_nonblocking(hd->pipe[0]);
+	assert(ret >= 0);
+
 	hd->startup_sem = startup_sem;
 
 	DRD_IGNORE_VAR(helper_data);
diff --git a/t/memlock.c b/t/memlock.c
index 3d3579ad..ebedb91d 100644
--- a/t/memlock.c
+++ b/t/memlock.c
@@ -26,6 +26,7 @@ static void *worker(void *data)
 			first = 0;
 		}
 	}
+	free(buf);
 	return NULL;
 }
 
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index 69799336..bc7986f7 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -520,6 +520,8 @@ static int parse_options(int argc, char *argv[])
 	while ((c = getopt(argc, argv, "f:b:t:w:")) != -1) {
 		switch (c) {
 		case 'f':
+			if (file)
+				return usage(argv);
 			file = strdup(optarg);
 			break;
 		case 'b':

