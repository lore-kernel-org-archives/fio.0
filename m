Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78710C433F5
	for <fio@archiver.kernel.org>; Thu,  9 Sep 2021 14:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C2C610FF
	for <fio@archiver.kernel.org>; Thu,  9 Sep 2021 14:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbhIIODJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Sep 2021 10:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244883AbhIIOCZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Sep 2021 10:02:25 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A551C057FBB
        for <fio@vger.kernel.org>; Thu,  9 Sep 2021 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KwRp5Vp189fslN2Qe9Ivmeyg/nNXl1tdw9WWwdjlszY=; b=G8zB+jcfK5mqirfqJGzBF66+WL
        IHAMYSXteJcLMk+3q4RkEcz/Dk3SPGZAgSo1gQJzqG+3nFdxG87tk0sSfN2CDLNnEB+7nHL+Cc6Si
        rrwLXAwAp0He2+Ng5A0Nb9oAvC9yckxgIqTrPJzg5m93//J5fXdODXm+Ewvk08SbXyOKcVV8ILCMt
        Lmlg9Q5vK07NpRJwTe1hh7AxN0KfpVXkOb+mIEGFr88YISmWkD8eKkcOhBOOffkFvwSfsZQzMF3QP
        0OhT/r0bo+/FJvnl9izrsPPkPZLf4rXvuilUBh/Zq+fTeQxN9ZXuY6GPeXSH6WGSBxkD+/pqvweGp
        XieCh2VQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOIir-001ri4-B7
        for fio@vger.kernel.org; Thu, 09 Sep 2021 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2DF411BC0154; Thu,  9 Sep 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210909120002.2DF411BC0154@kernel.dk>
Date:   Thu,  9 Sep 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit f7942acdc23a4ee837ef30834e1d2cb1fc6d0afe:

  options: Add thinktime_iotime option (2021-09-05 21:11:25 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 25425cb4a5531b1b3f26eba4e49866d944e0f1fb:

  Merge branch 'ft' of https://github.com/ErwanAliasr1/fio (2021-09-08 15:40:47 -0600)

----------------------------------------------------------------
Andrzej Jakowski (2):
      t/io_uring: fixes in output
      t/io_uring: allow flexible IO threads assignment

Erwan Velu (7):
      engines/sg: Return error if generic_close_file fails
      filesetup: Removing unused variable usage
      stat: Avoid freeing null pointer
      engines/sg: Removing useless variable assignment
      lib/fls.h: Remove unused variable assignment
      zbd: Removing useless variable assignment
      log: Removing useless assignment

Jens Axboe (5):
      t/io_uring: don't make setrlimit() failing fatal
      Fio 3.28
      t/io_uring: ensure that nthreads is > 0
      README: add link to new lore archive
      Merge branch 'ft' of https://github.com/ErwanAliasr1/fio

 FIO-VERSION-GEN |  2 +-
 README          |  4 +++
 engines/sg.c    |  7 ++---
 filesetup.c     |  1 -
 lib/fls.h       |  1 -
 log.c           |  2 +-
 stat.c          |  3 +-
 t/io_uring.c    | 96 +++++++++++++++++++++++++++++++++++----------------------
 zbd.c           |  2 +-
 9 files changed, 71 insertions(+), 47 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 47af94e9..e9d563c1 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.27
+DEF_VER=fio-3.28
 
 LF='
 '
diff --git a/README b/README
index 2fecf0e0..52eca5c3 100644
--- a/README
+++ b/README
@@ -72,6 +72,10 @@ in the body of the email. Archives can be found here:
 
 	http://www.spinics.net/lists/fio/
 
+or here:
+
+	https://lore.kernel.org/fio/
+
 and archives for the old list can be found here:
 
 	http://maillist.kernel.dk/fio-devel/
diff --git a/engines/sg.c b/engines/sg.c
index 0c2d2c8b..1c019384 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -471,10 +471,9 @@ static enum fio_q_status fio_sgio_rw_doio(struct thread_data *td,
 			if (__io_u == io_u)
 				break;
 
-			if (io_u_sync_complete(td, __io_u)) {
-				ret = -1;
+			if (io_u_sync_complete(td, __io_u))
 				break;
-			}
+
 		} while (1);
 
 		return FIO_Q_COMPLETED;
@@ -982,7 +981,7 @@ static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 
 	if (sd && !sd->type_checked && fio_sgio_type_check(td, f)) {
 		ret = generic_close_file(td, f);
-		return 1;
+		return ret;
 	}
 
 	return 0;
diff --git a/filesetup.c b/filesetup.c
index 296de5a1..228e4fff 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1024,7 +1024,6 @@ int longest_existing_path(char *path) {
 	while (!done) {
 		buf_pos = strrchr(buf, FIO_OS_PATH_SEPARATOR);
 		if (!buf_pos) {
-			done = true;
 			offset = 0;
 			break;
 		}
diff --git a/lib/fls.h b/lib/fls.h
index dc7ecd0d..99e1862a 100644
--- a/lib/fls.h
+++ b/lib/fls.h
@@ -32,7 +32,6 @@ static inline int __fls(int x)
 		r -= 2;
 	}
 	if (!(x & 0x80000000u)) {
-		x <<= 1;
 		r -= 1;
 	}
 	return r;
diff --git a/log.c b/log.c
index 562a29aa..237bac28 100644
--- a/log.c
+++ b/log.c
@@ -62,7 +62,7 @@ void log_prevalist(int type, const char *fmt, va_list args)
 	free(buf1);
 	if (len < 0)
 		return;
-	len = log_info_buf(buf2, len);
+	log_info_buf(buf2, len);
 	free(buf2);
 }
 #endif
diff --git a/stat.c b/stat.c
index 99275620..ac53463d 100644
--- a/stat.c
+++ b/stat.c
@@ -211,7 +211,7 @@ static void show_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 
 	len = calc_clat_percentiles(io_u_plat, nr, plist, &ovals, &maxv, &minv);
 	if (!len || !ovals)
-		goto out;
+		return;
 
 	/*
 	 * We default to nsecs, but if the value range is such that we
@@ -258,7 +258,6 @@ static void show_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 			log_buf(out, "\n");
 	}
 
-out:
 	free(ovals);
 }
 
diff --git a/t/io_uring.c b/t/io_uring.c
index 3130e469..c9ca3e9d 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -468,6 +468,13 @@ static int setup_ring(struct submitter *s)
 	io_uring_probe(fd);
 
 	if (fixedbufs) {
+		struct rlimit rlim;
+
+		rlim.rlim_cur = RLIM_INFINITY;
+		rlim.rlim_max = RLIM_INFINITY;
+		/* ignore potential error, not needed on newer kernels */
+		setrlimit(RLIMIT_MEMLOCK, &rlim);
+
 		ret = io_uring_register_buffers(s);
 		if (ret < 0) {
 			perror("io_uring_register_buffers");
@@ -536,23 +543,28 @@ static void file_depths(char *buf)
 	}
 }
 
-static void usage(char *argv)
+static void usage(char *argv, int status)
 {
 	printf("%s [options] -- [filenames]\n"
-		" -d <int> : IO Depth, default %d\n"
-		" -s <int> : Batch submit, default %d\n"
-		" -c <int> : Batch complete, default %d\n"
-		" -b <int> : Block size, default %d\n"
-		" -p <bool> : Polled IO, default %d\n",
-		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled);
-	exit(0);
+		" -d <int>  : IO Depth, default %d\n"
+		" -s <int>  : Batch submit, default %d\n"
+		" -c <int>  : Batch complete, default %d\n"
+		" -b <int>  : Block size, default %d\n"
+		" -p <bool> : Polled IO, default %d\n"
+		" -B <bool> : Fixed buffers, default %d\n"
+		" -F <bool> : Register files, default %d\n"
+		" -n <int>  : Number of threads, default %d\n",
+		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
+		fixedbufs, register_files, nthreads);
+	exit(status);
 }
 
 int main(int argc, char *argv[])
 {
 	struct submitter *s;
 	unsigned long done, calls, reap;
-	int err, i, j, flags, fd, opt;
+	int err, i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
+	struct file f;
 	char *fdepths;
 	void *ret;
 
@@ -586,11 +598,15 @@ int main(int argc, char *argv[])
 			break;
 		case 'n':
 			nthreads = atoi(optarg);
+			if (!nthreads) {
+				printf("Threads must be non-zero\n");
+				usage(argv[0], 1);
+			}
 			break;
 		case 'h':
 		case '?':
 		default:
-			usage(argv[0]);
+			usage(argv[0], 0);
 			break;
 		}
 	}
@@ -609,49 +625,57 @@ int main(int argc, char *argv[])
 
 	j = 0;
 	i = optind;
-	printf("i %d, argc %d\n", i, argc);
+	nfiles = argc - i;
+	if (!nfiles) {
+		printf("No files specified\n");
+		usage(argv[0], 1);
+	}
+	threads_per_f = nthreads / nfiles;
+	/* make sure each thread gets assigned files */
+	if (threads_per_f == 0) {
+		threads_per_f = 1;
+	} else {
+		threads_rem = nthreads - threads_per_f * nfiles;
+	}
 	while (!do_nop && i < argc) {
-		struct file *f;
+		int k, limit;
+
+		memset(&f, 0, sizeof(f));
 
-		s = get_submitter(j);
-		if (s->nr_files == MAX_FDS) {
-			printf("Max number of files (%d) reached\n", MAX_FDS);
-			break;
-		}
 		fd = open(argv[i], flags);
 		if (fd < 0) {
 			perror("open");
 			return 1;
 		}
-
-		f = &s->files[s->nr_files];
-		f->real_fd = fd;
-		if (get_file_size(f)) {
+		f.real_fd = fd;
+		if (get_file_size(&f)) {
 			printf("failed getting size of device/file\n");
 			return 1;
 		}
-		if (f->max_blocks <= 1) {
+		if (f.max_blocks <= 1) {
 			printf("Zero file/device size?\n");
 			return 1;
 		}
-		f->max_blocks--;
+		f.max_blocks--;
 
-		printf("Added file %s (submitter %d)\n", argv[i], s->index);
-		s->nr_files++;
-		i++;
-		if (++j >= nthreads)
-			j = 0;
-	}
+		limit = threads_per_f;
+		limit += threads_rem > 0 ? 1 : 0;
+		for (k = 0; k < limit; k++) {
+			s = get_submitter((j + k) % nthreads);
 
-	if (fixedbufs) {
-		struct rlimit rlim;
+			if (s->nr_files == MAX_FDS) {
+				printf("Max number of files (%d) reached\n", MAX_FDS);
+				break;
+			}
 
-		rlim.rlim_cur = RLIM_INFINITY;
-		rlim.rlim_max = RLIM_INFINITY;
-		if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0) {
-			perror("setrlimit");
-			return 1;
+			memcpy(&s->files[s->nr_files], &f, sizeof(f));
+
+			printf("Added file %s (submitter %d)\n", argv[i], s->index);
+			s->nr_files++;
 		}
+		threads_rem--;
+		i++;
+		j += limit;
 	}
 
 	arm_sig_int();
diff --git a/zbd.c b/zbd.c
index 1b933ce4..dd1abc58 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1857,7 +1857,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				       f->file_name);
 				goto eof;
 			}
-			zone_idx_b = zbd_zone_nr(f, zb);
+			zbd_zone_nr(f, zb);
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
