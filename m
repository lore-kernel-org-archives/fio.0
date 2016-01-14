Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60216 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbcANNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jan 2016 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aJhVT-0006Mz-TS
	for fio@vger.kernel.org; Thu, 14 Jan 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160114130001.A196A2C00E7@kernel.dk>
Date: Thu, 14 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a7cd478dffddb6d3d3109bce9f603139384c673e:

  options: fix bs_cmp() (2016-01-12 10:18:50 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 65f41ccb386850671c0651f976cd33fdfbe0644d:

  t/verify-state: one more printf type fix (2016-01-13 13:17:39 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Always create server sk_out key
      Destroy sk_out server key when we are done
      t/verify-state: fix type for printf
      t/verify-state: one more printf type fix

 fio.c            |  9 +++++++--
 server.c         | 15 ++++++++++++---
 server.h         |  3 +++
 t/verify-state.c | 10 +++++-----
 4 files changed, 27 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/fio.c b/fio.c
index bd3e260..69014dd 100644
--- a/fio.c
+++ b/fio.c
@@ -39,9 +39,12 @@ int main(int argc, char *argv[], char *envp[])
 #error "No available clock source!"
 #endif
 
-	if (parse_options(argc, argv))
+	if (fio_server_create_sk_key())
 		goto done;
 
+	if (parse_options(argc, argv))
+		goto done_key;
+
 	/*
 	 * line buffer stdout to avoid output lines from multiple
 	 * threads getting mixed
@@ -54,11 +57,13 @@ int main(int argc, char *argv[], char *envp[])
 		set_genesis_time();
 
 		if (fio_start_all_clients())
-			goto done;
+			goto done_key;
 		ret = fio_handle_clients(&fio_client_ops);
 	} else
 		ret = fio_backend(NULL);
 
+done_key:
+	fio_server_destroy_sk_key();
 done:
 	deinitialize_fio();
 	return ret;
diff --git a/server.c b/server.c
index eccd9d3..a593a73 100644
--- a/server.c
+++ b/server.c
@@ -2186,16 +2186,25 @@ static void set_sig_handlers(void)
 	sigaction(SIGINT, &act, NULL);
 }
 
-static int fio_server(void)
+void fio_server_destroy_sk_key(void)
 {
-	int sk, ret;
+	pthread_key_delete(sk_out_key);
+}
 
+int fio_server_create_sk_key(void)
+{
 	if (pthread_key_create(&sk_out_key, NULL)) {
 		log_err("fio: can't create sk_out backend key\n");
-		return -1;
+		return 1;
 	}
 
 	pthread_setspecific(sk_out_key, NULL);
+	return 0;
+}
+
+static int fio_server(void)
+{
+	int sk, ret;
 
 	dprint(FD_NET, "starting server\n");
 
diff --git a/server.h b/server.h
index 9205ae6..12c7275 100644
--- a/server.h
+++ b/server.h
@@ -220,6 +220,9 @@ extern void fio_server_send_add_job(struct thread_data *);
 extern void fio_server_send_start(struct thread_data *);
 extern int fio_net_send_quit(int sk);
 
+extern int fio_server_create_sk_key(void);
+extern void fio_server_destroy_sk_key(void);
+
 extern int exit_backend;
 extern int fio_net_port;
 
diff --git a/t/verify-state.c b/t/verify-state.c
index cb5ef31..6e8cd35 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -20,14 +20,14 @@ static void show_s(struct thread_io_list *s, unsigned int no_s)
 	int i;
 
 	printf("Thread %u, %s\n", no_s, s->name);
-	printf("Completions: %lu\n", s->no_comps);
-	printf("Depth: %lu\n", s->depth);
-	printf("Number IOs: %lu\n", s->numberio);
-	printf("Index: %lu\n", s->index);
+	printf("Completions: %llu\n", (unsigned long long) s->no_comps);
+	printf("Depth: %llu\n", (unsigned long long) s->depth);
+	printf("Number IOs: %llu\n", (unsigned long long) s->numberio);
+	printf("Index: %llu\n", (unsigned long long) s->index);
 
 	printf("Completions:\n");
 	for (i = 0; i < s->no_comps; i++)
-		printf("\t%lu\n", s->offsets[i]);
+		printf("\t%llu\n", (unsigned long long) s->offsets[i]);
 }
 
 static void show_verify_state(void *buf, size_t size)
