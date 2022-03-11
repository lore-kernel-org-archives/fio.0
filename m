Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E36C433F5
	for <fio@archiver.kernel.org>; Fri, 11 Mar 2022 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348644AbiCKNBK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Mar 2022 08:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243439AbiCKNBK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Mar 2022 08:01:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2F01BFDFD
        for <fio@vger.kernel.org>; Fri, 11 Mar 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=01m5cGCCoDcdJM+f+56GkAzRxHWtke8omFb84Ls8CrQ=; b=Vk62JPrbJRG6ZxQPmUjnVnSIR8
        pfhqtGoYl1Bja1iIfXbBuQPCkhXfcXY2ZaNWoxErjSVfjueTn7/35QCszmg1zBqthv+EsnIWK9NOs
        EQ7cob2NQeZyReUyhm2NsNFOKhlxmaksiAzKBKJrd9O1DgxphJenEncckeSRXr0xDCVwBnnDV4T75
        nh4HToFYCxeh84uvQ8lul/HCeWLIxYW4tXGTsbxEUvk4Bk1tJ9fj0pTU+uHskbQ54XH9yDvrSmLMV
        fRlllU6fm5Q1zJC6GbjebBd7IcWqt/2bDLlBNxZxZ3cnvqsyZYLWYE2pzeVx8lKd5y75Y1AV3kruI
        r+RS8nKA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSesG-001ZNi-Ag
        for fio@vger.kernel.org; Fri, 11 Mar 2022 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D82081BC0136; Fri, 11 Mar 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220311130001.D82081BC0136@kernel.dk>
Date:   Fri, 11 Mar 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit df0ab55ff9e28f4b85c199e207aec904f8a76440:

  Merge branch 'master' of https://github.com/dpronin/fio (2022-03-09 06:20:31 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 16b1e24562347d371d6d62e0bb9a03ad4e2a8a96:

  t/dedupe: handle errors more gracefully (2022-03-11 05:09:20 -0700)

----------------------------------------------------------------
Denis Pronin (4):
      configure script refactoring
      improvements in dup_files function
      fixed memory leak detected by ASAN
      ASAN enabling when configuring

Jens Axboe (7):
      Merge branch 'master' of https://github.com/dpronin/fio
      Merge branch 'refactoring/configure' of https://github.com/dpronin/fio
      Merge branch 'improvement/prevent-sigsegv-when-dup-files' of https://github.com/dpronin/fio
      Merge branch 'improvement/enable-asan' of https://github.com/dpronin/fio
      t/io_uring: only enable sync if we have preadv2
      Merge branch 'fuzz-cleanup' of https://github.com/vincentkfu/fio
      t/dedupe: handle errors more gracefully

Vincent Fu (1):
      fuzz: avoid building t/fuzz/parse_ini by default

 Makefile     |  8 +++++++-
 backend.c    |  6 ++++++
 configure    | 14 ++++++++++----
 filesetup.c  |  3 ++-
 t/dedupe.c   | 57 +++++++++++++++++++++++++++++++++++----------------------
 t/io_uring.c | 13 +++++++++++++
 6 files changed, 73 insertions(+), 28 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 6ffd3d13..e670c1f2 100644
--- a/Makefile
+++ b/Makefile
@@ -385,14 +385,16 @@ T_MEMLOCK_PROGS = t/memlock
 T_TT_OBJS = t/time-test.o
 T_TT_PROGS = t/time-test
 
+ifneq (,$(findstring -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION,$(CFLAGS)))
 T_FUZZ_OBJS = t/fuzz/fuzz_parseini.o
 T_FUZZ_OBJS += $(OBJS)
 ifdef CONFIG_ARITHMETIC
 T_FUZZ_OBJS += lex.yy.o y.tab.o
 endif
+# For proper fio code teardown CFLAGS needs to include -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
 # in case there is no fuzz driver defined by environment variable LIB_FUZZING_ENGINE, use a simple one
 # For instance, with compiler clang, address sanitizer and libFuzzer as a fuzzing engine, you should define
-# export CFLAGS="-fsanitize=address,fuzzer-no-link"
+# export CFLAGS="-fsanitize=address,fuzzer-no-link -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION"
 # export LIB_FUZZING_ENGINE="-fsanitize=address"
 # export CC=clang
 # before running configure && make
@@ -401,6 +403,10 @@ ifndef LIB_FUZZING_ENGINE
 T_FUZZ_OBJS += t/fuzz/onefile.o
 endif
 T_FUZZ_PROGS = t/fuzz/fuzz_parseini
+else	# CFLAGS includes -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
+T_FUZZ_OBJS =
+T_FUZZ_PROGS =
+endif
 
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
diff --git a/backend.c b/backend.c
index cd7f4e5f..001b2b96 100644
--- a/backend.c
+++ b/backend.c
@@ -2432,7 +2432,10 @@ reap:
 							strerror(ret));
 			} else {
 				pid_t pid;
+				struct fio_file **files;
 				dprint(FD_PROCESS, "will fork\n");
+				files = td->files;
+				read_barrier();
 				pid = fork();
 				if (!pid) {
 					int ret;
@@ -2441,6 +2444,9 @@ reap:
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
+				// freeing previously allocated memory for files
+				// this memory freed MUST NOT be shared between processes, only the pointer itself may be shared within TD
+				free(files);
 				free(fd);
 				fd = NULL;
 			}
diff --git a/configure b/configure
index 67e5d535..d327d2ca 100755
--- a/configure
+++ b/configure
@@ -248,6 +248,8 @@ for opt do
   ;;
   --disable-dfs) dfs="no"
   ;;
+  --enable-asan) asan="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -290,9 +292,10 @@ if test "$show_help" = "yes" ; then
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-libzbc        Disable libzbc even if found"
-  echo "--disable-tcmalloc	Disable tcmalloc support"
-  echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
-  echo "--disable-dfs		Disable DAOS File System support even if found"
+  echo "--disable-tcmalloc      Disable tcmalloc support"
+  echo "--dynamic-libengines    Lib-based ioengines as dynamic libraries"
+  echo "--disable-dfs           Disable DAOS File System support even if found"
+  echo "--enable-asan           Enable address sanitizer"
   exit $exit_val
 fi
 
@@ -3196,7 +3199,10 @@ fi
 if test "$fcntl_sync" = "yes" ; then
   output_sym "CONFIG_FCNTL_SYNC"
 fi
-
+if test "$asan" = "yes"; then
+  CFLAGS="$CFLAGS -fsanitize=address"
+  LDFLAGS="$LDFLAGS -fsanitize=address"
+fi
 print_config "Lib-based ioengines dynamic" "$dynamic_engines"
 cat > $TMPC << EOF
 int main(int argc, char **argv)
diff --git a/filesetup.c b/filesetup.c
index 7c32d0af..ab6c488b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -2031,11 +2031,12 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 	if (!org->files)
 		return;
 
-	td->files = malloc(org->files_index * sizeof(f));
+	td->files = calloc(org->files_index, sizeof(f));
 
 	if (td->o.file_lock_mode != FILE_LOCK_NONE)
 		td->file_locks = malloc(org->files_index);
 
+	assert(org->files_index >= org->o.nr_files);
 	for_each_file(org, f, i) {
 		struct fio_file *__f;
 
diff --git a/t/dedupe.c b/t/dedupe.c
index 109ea1af..561aa08d 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -143,15 +143,15 @@ static int read_block(int fd, void *buf, off_t offset)
 	return __read_block(fd, buf, offset, blocksize);
 }
 
-static void account_unique_capacity(uint64_t offset, uint64_t *unique_capacity,
-				    struct zlib_ctrl *zc)
+static int account_unique_capacity(uint64_t offset, uint64_t *unique_capacity,
+				   struct zlib_ctrl *zc)
 {
 	z_stream *stream = &zc->stream;
 	unsigned int compressed_len;
 	int ret;
 
 	if (read_block(file.fd, zc->buf_in, offset))
-		return;
+		return 1;
 
 	stream->next_in = zc->buf_in;
 	stream->avail_in = blocksize;
@@ -159,7 +159,8 @@ static void account_unique_capacity(uint64_t offset, uint64_t *unique_capacity,
 	stream->next_out = zc->buf_out;
 
 	ret = deflate(stream, Z_FINISH);
-	assert(ret != Z_STREAM_ERROR);
+	if (ret == Z_STREAM_ERROR)
+		return 1;
 	compressed_len = blocksize - stream->avail_out;
 
 	if (dump_output)
@@ -169,6 +170,7 @@ static void account_unique_capacity(uint64_t offset, uint64_t *unique_capacity,
 
 	*unique_capacity += compressed_len;
 	deflateReset(stream);
+	return 0;
 }
 
 static void add_item(struct chunk *c, struct item *i)
@@ -225,12 +227,12 @@ static struct chunk *alloc_chunk(void)
 	return c;
 }
 
-static void insert_chunk(struct item *i, uint64_t *unique_capacity,
-			 struct zlib_ctrl *zc)
+static int insert_chunk(struct item *i, uint64_t *unique_capacity,
+			struct zlib_ctrl *zc)
 {
 	struct fio_rb_node **p, *parent;
 	struct chunk *c;
-	int diff;
+	int ret, diff;
 
 	p = &rb_root.rb_node;
 	parent = NULL;
@@ -244,8 +246,6 @@ static void insert_chunk(struct item *i, uint64_t *unique_capacity,
 		} else if (diff > 0) {
 			p = &(*p)->rb_right;
 		} else {
-			int ret;
-
 			if (!collision_check)
 				goto add;
 
@@ -266,17 +266,21 @@ static void insert_chunk(struct item *i, uint64_t *unique_capacity,
 	memcpy(c->hash, i->hash, sizeof(i->hash));
 	rb_link_node(&c->rb_node, parent, p);
 	rb_insert_color(&c->rb_node, &rb_root);
-	if (compression)
-		account_unique_capacity(i->offset, unique_capacity, zc);
+	if (compression) {
+		ret = account_unique_capacity(i->offset, unique_capacity, zc);
+		if (ret)
+			return ret;
+	}
 add:
 	add_item(c, i);
+	return 0;
 }
 
-static void insert_chunks(struct item *items, unsigned int nitems,
-			  uint64_t *ndupes, uint64_t *unique_capacity,
-			  struct zlib_ctrl *zc)
+static int insert_chunks(struct item *items, unsigned int nitems,
+			 uint64_t *ndupes, uint64_t *unique_capacity,
+			 struct zlib_ctrl *zc)
 {
-	int i;
+	int i, ret;
 
 	fio_sem_down(rb_lock);
 
@@ -288,11 +292,15 @@ static void insert_chunks(struct item *items, unsigned int nitems,
 			s = sizeof(items[i].hash) / sizeof(uint32_t);
 			r = bloom_set(bloom, items[i].hash, s);
 			*ndupes += r;
-		} else
-			insert_chunk(&items[i], unique_capacity, zc);
+		} else {
+			ret = insert_chunk(&items[i], unique_capacity, zc);
+			if (ret)
+				break;
+		}
 	}
 
 	fio_sem_up(rb_lock);
+	return ret;
 }
 
 static void crc_buf(void *buf, uint32_t *hash)
@@ -320,6 +328,7 @@ static int do_work(struct worker_thread *thread, void *buf)
 	uint64_t ndupes = 0;
 	uint64_t unique_capacity = 0;
 	struct item *items;
+	int ret;
 
 	offset = thread->cur_offset;
 
@@ -339,13 +348,17 @@ static int do_work(struct worker_thread *thread, void *buf)
 		nitems++;
 	}
 
-	insert_chunks(items, nitems, &ndupes, &unique_capacity, &thread->zc);
+	ret = insert_chunks(items, nitems, &ndupes, &unique_capacity, &thread->zc);
 
 	free(items);
-	thread->items += nitems;
-	thread->dupes += ndupes;
-	thread->unique_capacity += unique_capacity;
-	return 0;
+	if (!ret) {
+		thread->items += nitems;
+		thread->dupes += ndupes;
+		thread->unique_capacity += unique_capacity;
+		return 0;
+	}
+
+	return ret;
 }
 
 static void thread_init_zlib_control(struct worker_thread *thread)
diff --git a/t/io_uring.c b/t/io_uring.c
index 157eea9e..10035912 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -939,6 +939,7 @@ submit:
 	return NULL;
 }
 
+#ifdef CONFIG_PWRITEV2
 static void *submitter_sync_fn(void *data)
 {
 	struct submitter *s = data;
@@ -1004,6 +1005,13 @@ static void *submitter_sync_fn(void *data)
 	finish = 1;
 	return NULL;
 }
+#else
+static void *submitter_sync_fn(void *data)
+{
+	finish = 1;
+	return NULL;
+}
+#endif
 
 static struct submitter *get_submitter(int offset)
 {
@@ -1346,7 +1354,12 @@ int main(int argc, char *argv[])
 			register_ring = !!atoi(optarg);
 			break;
 		case 'S':
+#ifdef CONFIG_PWRITEV2
 			use_sync = !!atoi(optarg);
+#else
+			fprintf(stderr, "preadv2 not supported\n");
+			exit(1);
+#endif
 			break;
 		case 'h':
 		case '?':
