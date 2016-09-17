Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41074 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753234AbcIQMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Sep 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1blEHr-0008Tr-0F
        for fio@vger.kernel.org; Sat, 17 Sep 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160917120001.989162C009A@kernel.dk>
Date: Sat, 17 Sep 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7903bf87725b18495a06f7199342f167147712eb:

  Merge branch 'master' of https://github.com/jan--f/fio (2016-09-15 07:57:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d22042d2117b78e16b06bab0880422c417007d37:

  workqueue: kill SW_F_EXITED (2016-09-16 12:48:32 -0600)

----------------------------------------------------------------
Ben England (3):
      generate unique pathname for each fio --client log file
      adhere to fio coding standards
      safety first!

Jens Axboe (9):
      io_u: fix overflow in 64-bit bssplit calculation
      Merge branch 'client-unique-log-names' of https://github.com/bengland2/fio into log-unique
      client: coding style fixups
      mac: fix for 10.12 having clockid_t
      configure: harden clockid_t test
      Fio 2.14
      Fixup two compile warnings
      iolog: dprint() casts for 32-bit warnings
      workqueue: kill SW_F_EXITED

 FIO-VERSION-GEN        |  2 +-
 client.c               | 22 +++++++++++++++++-----
 configure              | 22 ++++++++++++++++++++++
 init.c                 | 13 +++++++------
 io_u.c                 |  9 +++++----
 iolog.c                | 10 ++++++----
 os/os-mac.h            |  2 ++
 os/windows/install.wxs |  2 +-
 workqueue.c            | 10 +++-------
 9 files changed, 64 insertions(+), 28 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index d19dcca..8d4f1ef 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.13
+DEF_VER=fio-2.14
 
 LF='
 '
diff --git a/client.c b/client.c
index c8069a0..9698122 100644
--- a/client.c
+++ b/client.c
@@ -1295,6 +1295,7 @@ static int fio_client_handle_iolog(struct fio_client *client,
 {
 	struct cmd_iolog_pdu *pdu;
 	bool store_direct;
+	char *log_pathname;
 
 	pdu = convert_iolog(cmd, &store_direct);
 	if (!pdu) {
@@ -1302,15 +1303,26 @@ static int fio_client_handle_iolog(struct fio_client *client,
 		return 1;
 	}
 
+        /* allocate buffer big enough for next sprintf() call */
+	log_pathname = malloc(10 + strlen((char *)pdu->name) +
+			strlen(client->hostname));
+	if (!log_pathname) {
+		log_err("fio: memory allocation of unique pathname failed");
+		return -1;
+	}
+	/* generate a unique pathname for the log file using hostname */
+	sprintf(log_pathname, "%s.%s", pdu->name, client->hostname);
+
 	if (store_direct) {
 		ssize_t ret;
 		size_t sz;
 		int fd;
 
-		fd = open((const char *) pdu->name,
+		fd = open((const char *) log_pathname,
 				O_WRONLY | O_CREAT | O_TRUNC, 0644);
 		if (fd < 0) {
-			log_err("fio: open log: %s\n", strerror(errno));
+			log_err("fio: open log %s: %s\n",
+				log_pathname, strerror(errno));
 			return 1;
 		}
 
@@ -1326,10 +1338,10 @@ static int fio_client_handle_iolog(struct fio_client *client,
 		return 0;
 	} else {
 		FILE *f;
-
-		f = fopen((const char *) pdu->name, "w");
+		f = fopen((const char *) log_pathname, "w");
 		if (!f) {
-			log_err("fio: fopen log: %s\n", strerror(errno));
+			log_err("fio: fopen log %s : %s\n",
+				log_pathname, strerror(errno));
 			return 1;
 		}
 
diff --git a/configure b/configure
index 2851f54..a24e3ef 100755
--- a/configure
+++ b/configure
@@ -794,6 +794,25 @@ fi
 echo "CLOCK_MONOTONIC_PRECISE       $clock_monotonic_precise"
 
 ##########################################
+# clockid_t probe
+clockid_t="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+int main(int argc, char **argv)
+{
+  clockid_t cid;
+  memset(&cid, 0, sizeof(cid));
+  return clock_gettime(cid, NULL);
+}
+EOF
+if compile_prog "" "$LIBS" "clockid_t"; then
+  clockid_t="yes"
+fi
+echo "clockid_t                     $clockid_t"
+
+##########################################
 # gettimeofday() probe
 gettimeofday="no"
 cat > $TMPC << EOF
@@ -1722,6 +1741,9 @@ fi
 if test "$clock_monotonic_precise" = "yes" ; then
   output_sym "CONFIG_CLOCK_MONOTONIC_PRECISE"
 fi
+if test "$clockid_t" = "yes"; then
+  output_sym "CONFIG_CLOCKID_T"
+fi
 if test "$gettimeofday" = "yes" ; then
   output_sym "CONFIG_GETTIMEOFDAY"
 fi
diff --git a/init.c b/init.c
index bc17b40..6b6e386 100644
--- a/init.c
+++ b/init.c
@@ -1426,12 +1426,6 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	}
 
 	if (o->hist_log_file) {
-#ifndef CONFIG_ZLIB
-		if (td->client_type) {
-			log_err("fio: --write_hist_log requires zlib in client/server mode\n");
-			goto err;
-		}
-#endif
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1444,6 +1438,13 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		};
 		const char *suf;
 
+#ifndef CONFIG_ZLIB
+		if (td->client_type) {
+			log_err("fio: --write_hist_log requires zlib in client/server mode\n");
+			goto err;
+		}
+#endif
+
 		if (p.log_gz_store)
 			suf = "log.fz";
 		else
diff --git a/io_u.c b/io_u.c
index b6d530f..7b51dd2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -531,8 +531,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	int ddir = io_u->ddir;
 	unsigned int buflen = 0;
 	unsigned int minbs, maxbs;
-	uint64_t frand_max;
-	unsigned long r;
+	uint64_t frand_max, r;
 
 	assert(ddir_rw(ddir));
 
@@ -561,7 +560,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 			if (buflen < minbs)
 				buflen = minbs;
 		} else {
-			long perc = 0;
+			long long perc = 0;
 			unsigned int i;
 
 			for (i = 0; i < td->o.bssplit_nr[ddir]; i++) {
@@ -569,7 +568,9 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 
 				buflen = bsp->bs;
 				perc += bsp->perc;
-				if ((r * 100UL <= frand_max * perc) &&
+				if (!perc)
+					break;
+				if ((r / perc <= frand_max / 100ULL) &&
 				    io_u_fits(td, io_u, buflen))
 					break;
 			}
diff --git a/iolog.c b/iolog.c
index baa4b85..6576ca5 100644
--- a/iolog.c
+++ b/iolog.c
@@ -714,7 +714,7 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
 
-		entry = (struct io_u_plat_entry *) s->val;
+		entry = (struct io_u_plat_entry *) (uintptr_t) s->val;
 		io_u_plat = entry->io_u_plat;
 
 		entry_before = flist_first_entry(&entry->list, struct io_u_plat_entry, list);
@@ -1153,7 +1153,8 @@ static int gz_work(struct iolog_flush_data *data)
 				data->log->filename);
 	do {
 		if (c)
-			dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq, c->len);
+			dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq,
+				(unsigned long) c->len);
 		c = get_new_chunk(seq);
 		stream.avail_out = GZ_CHUNK;
 		stream.next_out = c->buf;
@@ -1190,7 +1191,7 @@ static int gz_work(struct iolog_flush_data *data)
 	total -= c->len;
 	c->len = GZ_CHUNK - stream.avail_out;
 	total += c->len;
-	dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq, c->len);
+	dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq, (unsigned long) c->len);
 
 	if (ret != Z_STREAM_END) {
 		do {
@@ -1201,7 +1202,8 @@ static int gz_work(struct iolog_flush_data *data)
 			c->len = GZ_CHUNK - stream.avail_out;
 			total += c->len;
 			flist_add_tail(&c->list, &list);
-			dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq, c->len);
+			dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq,
+				(unsigned long) c->len);
 		} while (ret != Z_STREAM_END);
 	}
 
diff --git a/os/os-mac.h b/os/os-mac.h
index 76d388e..0903a6f 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -35,7 +35,9 @@
 
 typedef off_t off64_t;
 
+#ifndef CONFIG_CLOCKID_T
 typedef unsigned int clockid_t;
+#endif
 
 #define FIO_OS_DIRECTIO
 static inline int fio_set_odirect(int fd)
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index f8d3773..da09b9f 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.13">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.14">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/workqueue.c b/workqueue.c
index 2e01b58..013087e 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -15,9 +15,8 @@ enum {
 	SW_F_IDLE	= 1 << 0,
 	SW_F_RUNNING	= 1 << 1,
 	SW_F_EXIT	= 1 << 2,
-	SW_F_EXITED	= 1 << 3,
-	SW_F_ACCOUNTED	= 1 << 4,
-	SW_F_ERROR	= 1 << 5,
+	SW_F_ACCOUNTED	= 1 << 3,
+	SW_F_ERROR	= 1 << 4,
 };
 
 static struct submit_worker *__get_submit_worker(struct workqueue *wq,
@@ -131,7 +130,7 @@ static void *worker_thread(void *data)
 {
 	struct submit_worker *sw = data;
 	struct workqueue *wq = sw->wq;
-	unsigned int eflags = 0, ret = 0;
+	unsigned int ret = 0;
 	FLIST_HEAD(local_list);
 
 	sk_out_assign(sw->sk_out);
@@ -206,9 +205,6 @@ handle_work:
 		wq->ops.update_acct_fn(sw);
 
 done:
-	pthread_mutex_lock(&sw->lock);
-	sw->flags |= (SW_F_EXITED | eflags);
-	pthread_mutex_unlock(&sw->lock);
 	sk_out_drop();
 	return NULL;
 }
