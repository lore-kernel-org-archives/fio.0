Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbaFSMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Jun 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Wxb0e-0005I3-UQ
	for fio@vger.kernel.org; Thu, 19 Jun 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140619120003.53BD8400DB@lyth.info>
Date: Thu, 19 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6c784104cf90299aeec1d79f536a8e534c341c5f:

  Fixup run_str[] condensing with client/server (2014-06-17 09:22:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c89318761586dbd77b8f31ce0ed68ff4fc086c89:

  Add support for compiling for ESX (2014-06-18 15:30:09 -0700)

----------------------------------------------------------------
George Dowding (1):
      Fix build from cmake

Jens Axboe (1):
      Add support for compiling for ESX

 Makefile    |    2 +-
 README      |    3 +++
 backend.c   |    2 +-
 configure   |    9 +++++++++
 filesetup.c |    4 ++++
 init.c      |   22 ++++++++++++++++++++--
 options.c   |    6 ++++++
 parse.c     |    2 +-
 parse.h     |    1 +
 smalloc.c   |   11 +++++++++--
 10 files changed, 55 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 59fae9c..d49c8a4 100644
--- a/Makefile
+++ b/Makefile
@@ -221,7 +221,7 @@ FIO-VERSION-FILE: FORCE
 
 override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 
-.c.o: FORCE FIO-VERSION-FILE
+%.o : %.c
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $*.c > $*.d
 	@mv -f $*.d $*.d.tmp
diff --git a/README b/README
index f8aaef2..2be0bfd 100644
--- a/README
+++ b/README
@@ -101,6 +101,9 @@ To build FIO with a cross-compiler:
  $ make CROSS_COMPILE=/path/to/toolchain/prefix
 Configure will attempt to determine the target platform automatically.
 
+It's possible to build fio for ESX as well, use the --esx switch to
+configure.
+
 
 Windows
 -------
diff --git a/backend.c b/backend.c
index 23fa345..ee75566 100644
--- a/backend.c
+++ b/backend.c
@@ -1575,7 +1575,7 @@ static int fork_main(int shmid, int offset)
 	struct thread_data *td;
 	void *data, *ret;
 
-#ifndef __hpux
+#if !defined(__hpux) && !defined(CONFIG_NO_SHM)
 	data = shmat(shmid, NULL, 0);
 	if (data == (void *) -1) {
 		int __err = errno;
diff --git a/configure b/configure
index d37e8b4..0e861ee 100755
--- a/configure
+++ b/configure
@@ -141,6 +141,10 @@ for opt do
   case "$opt" in
   --cpu=*) cpu="$optarg"
   ;;
+  #  esx is cross compiled and cannot be detect through simple uname calls
+  --esx)
+  esx="yes"
+  ;;
   --cc=*) CC="$optarg"
   ;;
   --extra-cflags=*) CFLAGS="$CFLAGS $optarg"
@@ -167,6 +171,7 @@ if test "$show_help" = "yes" ; then
   echo "--cc=                  Specify compiler to use"
   echo "--extra-cflags=        Specify extra CFLAGS to pass to compiler"
   echo "--build-32bit-win      Enable 32-bit build on Windows"
+  echo "--esx                  Configure build options for esx"
   echo "--enable-gfio          Enable building of gtk gfio"
   echo "--disable-numa         Disable libnuma even if found"
   exit $exit_val
@@ -1340,6 +1345,10 @@ fi
 if test "$gfio" = "yes" ; then
   echo "CONFIG_GFIO=y" >> $config_host_mak
 fi
+if test "$esx" = "yes" ; then
+  output_sym "CONFIG_ESX"
+  output_sym "CONFIG_NO_SHM"
+fi
 if test "$sched_idle" = "yes" ; then
   output_sym "CONFIG_SCHED_IDLE"
 fi
diff --git a/filesetup.c b/filesetup.c
index 2049fd6..1facccd 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -390,6 +390,10 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 {
 	int ret = 0;
 
+#ifdef CONFIG_ESX
+	return 0;
+#endif
+
 	if (len == -1ULL)
 		len = f->io_size;
 	if (off == -1ULL)
diff --git a/init.c b/init.c
index 74a02e0..d44eb5b 100644
--- a/init.c
+++ b/init.c
@@ -238,15 +238,19 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 
 void free_threads_shm(void)
 {
-	struct shmid_ds sbuf;
-
 	if (threads) {
 		void *tp = threads;
+#ifndef CONFIG_NO_SHM
+		struct shmid_ds sbuf;
 
 		threads = NULL;
 		shmdt(tp);
 		shmctl(shm_id, IPC_RMID, &sbuf);
 		shm_id = -1;
+#else
+		threads = NULL;
+		free(tp);
+#endif
 	}
 }
 
@@ -287,6 +291,7 @@ static int setup_thread_area(void)
 		size += file_hash_size;
 		size += sizeof(unsigned int);
 
+#ifndef CONFIG_NO_SHM
 		shm_id = shmget(0, size, IPC_CREAT | 0600);
 		if (shm_id != -1)
 			break;
@@ -294,10 +299,16 @@ static int setup_thread_area(void)
 			perror("shmget");
 			break;
 		}
+#else
+		threads = malloc(size);
+		if (threads)
+			break;
+#endif
 
 		max_jobs >>= 1;
 	} while (max_jobs);
 
+#ifndef CONFIG_NO_SHM
 	if (shm_id == -1)
 		return 1;
 
@@ -306,6 +317,7 @@ static int setup_thread_area(void)
 		perror("shmat");
 		return 1;
 	}
+#endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
 	hash = (void *) threads + max_jobs * sizeof(struct thread_data);
@@ -1947,6 +1959,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 		case 'S':
 			did_arg = 1;
+#ifndef CONFIG_NO_SHM
 			if (nr_clients) {
 				log_err("fio: can't be both client and server\n");
 				do_exit++;
@@ -1957,6 +1970,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				fio_server_set_arg(optarg);
 			is_backend = 1;
 			backend = 1;
+#else
+			log_err("fio: client/server requires SHM support\n");
+			do_exit++;
+			exit_val = 1;
+#endif
 			break;
 		case 'D':
 			if (pid_file)
diff --git a/options.c b/options.c
index d5bf00c..74347f3 100644
--- a/options.c
+++ b/options.c
@@ -2226,6 +2226,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = MEM_MALLOC,
 			    .help = "Use malloc(3) for IO buffers",
 			  },
+#ifndef CONFIG_NO_SHM
 			  { .ival = "shm",
 			    .oval = MEM_SHM,
 			    .help = "Use shared memory segments for IO buffers",
@@ -2236,6 +2237,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Like shm, but use huge pages",
 			  },
 #endif
+#endif
 			  { .ival = "mmap",
 			    .oval = MEM_MMAP,
 			    .help = "Use mmap(2) (file or anon) for IO buffers",
@@ -3048,6 +3050,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_STR_SET,
 		.off1	= td_var_offset(use_thread),
 		.help	= "Use threads instead of processes",
+#ifdef CONFIG_NO_SHM
+		.def	= "1",
+		.no_warn_def = 1,
+#endif
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_PROCESS,
 	},
diff --git a/parse.c b/parse.c
index 188f728..e6d9406 100644
--- a/parse.c
+++ b/parse.c
@@ -1167,7 +1167,7 @@ void option_init(struct fio_option *o)
 		o->minfp = DBL_MIN;
 		o->maxfp = DBL_MAX;
 	}
-	if (o->type == FIO_OPT_STR_SET && o->def) {
+	if (o->type == FIO_OPT_STR_SET && o->def && !o->no_warn_def) {
 		log_err("Option %s: string set option with"
 				" default will always be true\n", o->name);
 	}
diff --git a/parse.h b/parse.h
index c797b92..2a1e06a 100644
--- a/parse.h
+++ b/parse.h
@@ -73,6 +73,7 @@ struct fio_option {
 	unsigned int group;		/* who to group with */
 	void *gui_data;
 	int is_seconds;			/* time value with seconds base */
+	int no_warn_def;
 };
 
 typedef int (str_cb_fn)(void *, char *);
diff --git a/smalloc.c b/smalloc.c
index c8f1642..d0f732b 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -180,6 +180,7 @@ static int find_next_zero(int word, int start)
 static int add_pool(struct pool *pool, unsigned int alloc_size)
 {
 	int bitmap_blocks;
+	int mmap_flags;
 	void *ptr;
 
 #ifdef SMALLOC_REDZONE
@@ -198,8 +199,14 @@ static int add_pool(struct pool *pool, unsigned int alloc_size)
 	pool->nr_blocks = bitmap_blocks;
 	pool->free_blocks = bitmap_blocks * SMALLOC_BPB;
 
-	ptr = mmap(NULL, alloc_size, PROT_READ|PROT_WRITE,
-			MAP_SHARED | OS_MAP_ANON, -1, 0);
+	mmap_flags = OS_MAP_ANON;
+#ifdef CONFIG_ESX
+	mmap_flags |= MAP_PRIVATE;
+#else
+	mmap_flags |= MAP_SHARED;
+#endif
+	ptr = mmap(NULL, alloc_size, PROT_READ|PROT_WRITE, mmap_flags, -1, 0);
+
 	if (ptr == MAP_FAILED)
 		goto out_fail;
 
