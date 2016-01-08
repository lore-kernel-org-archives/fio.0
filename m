Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbcAHNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Jan 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aHWeI-0001EK-S4
	for fio@vger.kernel.org; Fri, 08 Jan 2016 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160108130001.9E24B2C00E7@kernel.dk>
Date: Fri,  8 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5f3bd0fd67254e3750681f0700a0cc162faee500:

  options: move pattern_fmt_desc where we need it (2015-12-30 09:27:05 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 98996ef93ff37e0f51d90ca87ff0f75d4d1c153f:

  t/verify-state: add helper to inspect verify dump state files (2016-01-07 15:06:22 -0700)

----------------------------------------------------------------
Jens Axboe (7):
      server: include name of verify file requested for error message
      configure: lex force off
      server: sk_out exit error handling
      verify: split out state header code
      verify-state: forward declare io_u
      Merge branch 'master' of git://github.com/ezrapedersen/fio
      t/verify-state: add helper to inspect verify dump state files

root (1):
      Disable libaio for ESXi build - bug#80

 Makefile         |   8 ++++
 configure        |  24 +++++++----
 server.c         |  26 ++++++++----
 t/verify-state.c | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 verify-state.h   |  95 +++++++++++++++++++++++++++++++++++++++++
 verify.h         |  88 +-------------------------------------
 6 files changed, 265 insertions(+), 103 deletions(-)
 create mode 100644 t/verify-state.c
 create mode 100644 verify-state.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index bd5f1bb..b6ebf2f 100644
--- a/Makefile
+++ b/Makefile
@@ -223,6 +223,9 @@ T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
 		crc/murmur3.o crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
 T_DEDUPE_PROGS = t/fio-dedupe
 
+T_VS_OBJS = t/verify-state.o t/log.o crc/crc32c.o crc/crc32c-intel.o t/debug.o
+T_VS_PROGS = t/fio-verify-state
+
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
 T_OBJS += $(T_ZIPF_OBJS)
@@ -230,6 +233,7 @@ T_OBJS += $(T_AXMAP_OBJS)
 T_OBJS += $(T_LFSR_TEST_OBJS)
 T_OBJS += $(T_BTRACE_FIO_OBJS)
 T_OBJS += $(T_DEDUPE_OBJS)
+T_OBJS += $(T_VS_OBJS)
 
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
     T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
@@ -245,6 +249,7 @@ T_TEST_PROGS += $(T_AXMAP_PROGS)
 T_TEST_PROGS += $(T_LFSR_TEST_PROGS)
 T_PROGS += $(T_BTRACE_FIO_PROGS)
 T_PROGS += $(T_DEDUPE_PROGS)
+T_PROGS += $(T_VS_PROGS)
 
 PROGS += $(T_PROGS)
 
@@ -390,6 +395,9 @@ endif
 t/fio-dedupe: $(T_DEDUPE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
 
+t/fio-verify-state: $(T_VS_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_VS_OBJS) $(LIBS)
+
 clean: FORCE
 	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d oslib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 
diff --git a/configure b/configure
index e92e96b..cbd4d30 100755
--- a/configure
+++ b/configure
@@ -247,6 +247,8 @@ AIX)
   # Unless explicitly enabled, turn off lex.
   if test -z "$disable_lex" ; then
     disable_lex="yes"
+  else
+    force_no_lex_o="yes"
   fi
   ;;
 Darwin)
@@ -487,7 +489,8 @@ echo "zlib                          $zlib"
 ##########################################
 # linux-aio probe
 libaio="no"
-cat > $TMPC <<EOF
+if test "$esx" != "yes" ; then
+  cat > $TMPC <<EOF
 #include <libaio.h>
 #include <stddef.h>
 int main(void)
@@ -496,14 +499,15 @@ int main(void)
   return 0;
 }
 EOF
-if compile_prog "" "-laio" "libaio" ; then
-  libaio=yes
-  LIBS="-laio $LIBS"
-else
-  if test "$libaio" = "yes" ; then
-    feature_not_found "linux AIO" "libaio-dev or libaio-devel"
+  if compile_prog "" "-laio" "libaio" ; then
+    libaio=yes
+    LIBS="-laio $LIBS"
+  else
+    if test "$libaio" = "yes" ; then
+      feature_not_found "linux AIO" "libaio-dev or libaio-devel"
+    fi
+    libaio=no
   fi
-  libaio=no
 fi
 echo "Linux AIO support             $libaio"
 
@@ -1505,6 +1509,9 @@ fi
 
 # Check if lex fails using -o
 if test "$arith" = "yes" ; then
+if test "$force_no_lex_o" = "yes" ; then
+  lex_use_o="no"
+else
 $LEX -o lex.yy.c exp/expression-parser.l 2> /dev/null
 if test "$?" = "0" ; then
   lex_use_o="yes"
@@ -1512,6 +1519,7 @@ else
   lex_use_o="no"
 fi
 fi
+fi
 
 echo "lex/yacc for arithmetic       $arith"
 
diff --git a/server.c b/server.c
index a71562b..eccd9d3 100644
--- a/server.c
+++ b/server.c
@@ -151,11 +151,13 @@ static int __sk_out_drop(struct sk_out *sk_out)
 		int refs;
 
 		sk_lock(sk_out);
+		assert(sk_out->refs != 0);
 		refs = --sk_out->refs;
 		sk_unlock(sk_out);
 
 		if (!refs) {
 			sk_out_free(sk_out);
+			pthread_setspecific(sk_out_key, NULL);
 			return 0;
 		}
 	}
@@ -168,8 +170,7 @@ void sk_out_drop(void)
 	struct sk_out *sk_out;
 
 	sk_out = pthread_getspecific(sk_out_key);
-	if (!__sk_out_drop(sk_out))
-		pthread_setspecific(sk_out_key, NULL);
+	__sk_out_drop(sk_out);
 }
 
 static void __fio_init_net_cmd(struct fio_net_cmd *cmd, uint16_t opcode,
@@ -757,6 +758,8 @@ static int handle_run_cmd(struct sk_out *sk_out, struct flist_head *job_list,
 	pid_t pid;
 	int ret;
 
+	sk_out_assign(sk_out);
+
 	fio_time_init();
 	set_genesis_time();
 
@@ -768,6 +771,7 @@ static int handle_run_cmd(struct sk_out *sk_out, struct flist_head *job_list,
 
 	ret = fio_backend(sk_out);
 	free_threads_shm();
+	sk_out_drop();
 	_exit(ret);
 }
 
@@ -1795,13 +1799,14 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	struct cmd_reply *rep;
 	uint64_t tag;
 	void *data;
+	int ret;
 
 	dprint(FD_NET, "server: request verify state\n");
 
 	rep = smalloc(sizeof(*rep));
 	if (!rep) {
 		log_err("fio: smalloc pool too small\n");
-		return 1;
+		return ENOMEM;
 	}
 
 	__fio_mutex_init(&rep->lock, FIO_MUTEX_LOCKED);
@@ -1819,17 +1824,19 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	 */
 	if (fio_mutex_down_timeout(&rep->lock, 10000)) {
 		log_err("fio: timed out waiting for reply\n");
+		ret = ETIMEDOUT;
 		goto fail;
 	}
 
 	if (rep->error) {
-		log_err("fio: failure on receiving state file: %s\n",
-				strerror(rep->error));
+		log_err("fio: failure on receiving state file %s: %s\n",
+				out.path, strerror(rep->error));
+		ret = rep->error;
 fail:
 		*datap = NULL;
 		sfree(rep);
 		fio_net_queue_quit();
-		return 1;
+		return ret;
 	}
 
 	/*
@@ -1837,12 +1844,15 @@ fail:
 	 * the header, and the thread_io_list checksum
 	 */
 	s = rep->data + sizeof(struct verify_state_hdr);
-	if (verify_state_hdr(rep->data, s, version))
+	if (verify_state_hdr(rep->data, s, version)) {
+		ret = EILSEQ;
 		goto fail;
+	}
 
 	/*
 	 * Don't need the header from now, copy just the thread_io_list
 	 */
+	ret = 0;
 	rep->size -= sizeof(struct verify_state_hdr);
 	data = malloc(rep->size);
 	memcpy(data, s, rep->size);
@@ -1851,7 +1861,7 @@ fail:
 	sfree(rep->data);
 	__fio_mutex_remove(&rep->lock);
 	sfree(rep);
-	return 0;
+	return ret;
 }
 
 static int fio_init_server_ip(void)
diff --git a/t/verify-state.c b/t/verify-state.c
new file mode 100644
index 0000000..cb5ef31
--- /dev/null
+++ b/t/verify-state.c
@@ -0,0 +1,127 @@
+/*
+ * Dump the contents of a verify state file in plain text
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include "../log.h"
+#include "../os/os.h"
+#include "../verify-state.h"
+#include "../crc/crc32c.h"
+#include "debug.h"
+
+static void show_s(struct thread_io_list *s, unsigned int no_s)
+{
+	int i;
+
+	printf("Thread %u, %s\n", no_s, s->name);
+	printf("Completions: %lu\n", s->no_comps);
+	printf("Depth: %lu\n", s->depth);
+	printf("Number IOs: %lu\n", s->numberio);
+	printf("Index: %lu\n", s->index);
+
+	printf("Completions:\n");
+	for (i = 0; i < s->no_comps; i++)
+		printf("\t%lu\n", s->offsets[i]);
+}
+
+static void show_verify_state(void *buf, size_t size)
+{
+	struct verify_state_hdr *hdr = buf;
+	struct thread_io_list *s;
+	uint32_t crc;
+	int no_s;
+
+	hdr->version = le64_to_cpu(hdr->version);
+	hdr->size = le64_to_cpu(hdr->size);
+	hdr->crc = le64_to_cpu(hdr->crc);
+
+	printf("Version: %x, Size %u, crc %x\n", (unsigned int) hdr->version,
+						(unsigned int) hdr->size,
+						(unsigned int) hdr->crc);
+
+	size -= sizeof(*hdr);
+	if (hdr->size != size) {
+		log_err("Size mismatch\n");
+		return;
+	}
+
+	s = buf + sizeof(*hdr);
+	crc = fio_crc32c((unsigned char *) s, hdr->size);
+	if (crc != hdr->crc) {
+		log_err("crc mismatch %x != %x\n", crc, (unsigned int) hdr->crc);
+		return;
+	}
+
+	if (hdr->version != 0x02) {
+		log_err("Can only handle version 2 headers\n");
+		return;
+	}
+
+	no_s = 0;
+	do {
+		int i;
+
+		s->no_comps = le64_to_cpu(s->no_comps);
+		s->depth = le64_to_cpu(s->depth);
+		s->numberio = le64_to_cpu(s->numberio);
+		s->index = le64_to_cpu(s->index);
+
+		for (i = 0; i < s->no_comps; i++)
+			s->offsets[i] = le64_to_cpu(s->offsets[i]);
+
+		show_s(s, no_s);
+		no_s++;
+		size -= __thread_io_list_sz(s->depth);
+		s = (void *) s + __thread_io_list_sz(s->depth);
+	} while (size != 0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct stat sb;
+	void *buf;
+	int ret, fd;
+
+	debug_init();
+
+	if (argc < 2) {
+		log_err("Usage: %s <state file>\n", argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		log_err("open %s: %s\n", argv[1], strerror(errno));
+		return 1;
+	}
+
+	if (fstat(fd, &sb) < 0) {
+		log_err("stat: %s\n", strerror(errno));
+		close(fd);
+		return 1;
+	}
+
+	buf = malloc(sb.st_size);
+	ret = read(fd, buf, sb.st_size);
+	if (ret < 0) {
+		log_err("read: %s\n", strerror(errno));
+		close(fd);
+		return 1;
+	} else if (ret != sb.st_size) {
+		log_err("Short read\n");
+		close(fd);
+		return 1;
+	}
+
+	close(fd);
+	show_verify_state(buf, sb.st_size);
+
+	free(buf);
+	return 0;
+}
diff --git a/verify-state.h b/verify-state.h
new file mode 100644
index 0000000..0d004b0
--- /dev/null
+++ b/verify-state.h
@@ -0,0 +1,95 @@
+#ifndef FIO_VERIFY_STATE_H
+#define FIO_VERIFY_STATE_H
+
+#include <stdint.h>
+
+struct thread_rand32_state {
+	uint32_t s[4];
+};
+
+struct thread_rand64_state {
+	uint64_t s[6];
+};
+
+struct thread_rand_state {
+	uint64_t use64;
+	union {
+		struct thread_rand32_state state32;
+		struct thread_rand64_state state64;
+	};
+};
+
+/*
+ * For dumping current write state
+ */
+struct thread_io_list {
+	uint64_t no_comps;
+	uint64_t depth;
+	uint64_t numberio;
+	uint64_t index;
+	struct thread_rand_state rand;
+	uint8_t name[64];
+	uint64_t offsets[0];
+};
+
+struct thread_io_list_v1 {
+	uint64_t no_comps;
+	uint64_t depth;
+	uint64_t numberio;
+	uint64_t index;
+	struct thread_rand32_state rand;
+	uint8_t name[64];
+	uint64_t offsets[0];
+};
+
+struct all_io_list {
+	uint64_t threads;
+	struct thread_io_list state[0];
+};
+
+#define VSTATE_HDR_VERSION_V1	0x01
+#define VSTATE_HDR_VERSION	0x02
+
+struct verify_state_hdr {
+	uint64_t version;
+	uint64_t size;
+	uint64_t crc;
+};
+
+#define IO_LIST_ALL		0xffffffff
+
+struct io_u;
+extern struct all_io_list *get_all_io_list(int, size_t *);
+extern void __verify_save_state(struct all_io_list *, const char *);
+extern void verify_save_state(int mask);
+extern int verify_load_state(struct thread_data *, const char *);
+extern void verify_free_state(struct thread_data *);
+extern int verify_state_should_stop(struct thread_data *, struct io_u *);
+extern void verify_convert_assign_state(struct thread_data *, void *, int);
+extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *,
+				int *);
+
+static inline size_t __thread_io_list_sz(uint64_t depth)
+{
+	return sizeof(struct thread_io_list) + depth * sizeof(uint64_t);
+}
+
+static inline size_t thread_io_list_sz(struct thread_io_list *s)
+{
+	return __thread_io_list_sz(le64_to_cpu(s->depth));
+}
+
+static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
+{
+	return (void *) s + thread_io_list_sz(s);
+}
+
+static inline void verify_state_gen_name(char *out, size_t size,
+					 const char *name, const char *prefix,
+					 int num)
+{
+	snprintf(out, size, "%s-%s-%d-verify.state", prefix, name, num);
+	out[size - 1] = '\0';
+}
+
+#endif
diff --git a/verify.h b/verify.h
index 87675af..deb161e 100644
--- a/verify.h
+++ b/verify.h
@@ -2,6 +2,7 @@
 #define FIO_VERIFY_H
 
 #include <stdint.h>
+#include "verify-state.h"
 
 #define FIO_HDR_MAGIC	0xacca
 
@@ -94,91 +95,4 @@ extern void verify_async_exit(struct thread_data *);
  */
 extern int paste_blockoff(char *buf, unsigned int len, void *priv);
 
-struct thread_rand32_state {
-	uint32_t s[4];
-};
-
-struct thread_rand64_state {
-	uint64_t s[6];
-};
-
-struct thread_rand_state {
-	uint64_t use64;
-	union {
-		struct thread_rand32_state state32;
-		struct thread_rand64_state state64;
-	};
-};
-
-/*
- * For dumping current write state
- */
-struct thread_io_list {
-	uint64_t no_comps;
-	uint64_t depth;
-	uint64_t numberio;
-	uint64_t index;
-	struct thread_rand_state rand;
-	uint8_t name[64];
-	uint64_t offsets[0];
-};
-
-struct thread_io_list_v1 {
-	uint64_t no_comps;
-	uint64_t depth;
-	uint64_t numberio;
-	uint64_t index;
-	struct thread_rand32_state rand;
-	uint8_t name[64];
-	uint64_t offsets[0];
-};
-
-struct all_io_list {
-	uint64_t threads;
-	struct thread_io_list state[0];
-};
-
-#define VSTATE_HDR_VERSION_V1	0x01
-#define VSTATE_HDR_VERSION	0x02
-
-struct verify_state_hdr {
-	uint64_t version;
-	uint64_t size;
-	uint64_t crc;
-};
-
-#define IO_LIST_ALL		0xffffffff
-extern struct all_io_list *get_all_io_list(int, size_t *);
-extern void __verify_save_state(struct all_io_list *, const char *);
-extern void verify_save_state(int mask);
-extern int verify_load_state(struct thread_data *, const char *);
-extern void verify_free_state(struct thread_data *);
-extern int verify_state_should_stop(struct thread_data *, struct io_u *);
-extern void verify_convert_assign_state(struct thread_data *, void *, int);
-extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *,
-				int *);
-
-static inline size_t __thread_io_list_sz(uint64_t depth)
-{
-	return sizeof(struct thread_io_list) + depth * sizeof(uint64_t);
-}
-
-static inline size_t thread_io_list_sz(struct thread_io_list *s)
-{
-	return __thread_io_list_sz(le64_to_cpu(s->depth));
-}
-
-static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
-{
-	return (void *) s + thread_io_list_sz(s);
-}
-
-static inline void verify_state_gen_name(char *out, size_t size,
-					 const char *name, const char *prefix,
-					 int num)
-{
-	snprintf(out, size, "%s-%s-%d-verify.state", prefix, name, num);
-	out[size - 1] = '\0';
-}
-
 #endif
