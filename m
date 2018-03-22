Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754476AbeCVMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Mar 2018 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1eyyt4-0002ye-EA
        for fio@vger.kernel.org; Thu, 22 Mar 2018 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180322120002.B70A62C0119@kernel.dk>
Date: Thu, 22 Mar 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 69c594d81d4067fadd70fa4909e19d615efa5f1c:

  optgroup: move debug code into function (2018-03-20 11:19:19 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7ad2ddffe2bdc5e47fb86cab276db1db9e350f1b:

  sg: fix sign extension (2018-03-21 20:09:36 -0600)

----------------------------------------------------------------
Bart Van Assche (3):
      Add an asprintf() implementation
      log: Modify the implementation such that it uses asprintf()
      verify: Simplify dump_buf()

Jens Axboe (7):
      debug: remove extra parens
      Merge branch 'asprintf' of https://github.com/bvanassche/fio
      server: process STOP/QUIT commands out-of-line
      server: handle shared mem pool allocation failures
      Merge branch 'include_refactor' of https://github.com/sitsofe/fio
      server: fix error handling for shared memory handling
      sg: fix sign extension

Sitsofe Wheeler (4):
      Refactor #includes and headers
      Use POSIX path for poll.h and fcntl.h headers
      oslib: make str* compat functions more uniform
      Add include-what-you-use pragmas

 Makefile                            |  1 +
 arch/arch-x86.h                     |  2 +-
 arch/arch-x86_64.h                  |  2 +-
 arch/arch.h                         |  2 +
 backend.c                           | 12 -----
 blktrace.c                          |  2 -
 cconv.c                             |  1 +
 cgroup.c                            |  1 -
 client.c                            |  6 +--
 client.h                            |  6 +--
 compiler/compiler.h                 |  3 +-
 configure                           | 40 +++++++++++++++
 crc/crc32.c                         |  1 -
 crc/crc32.h                         |  2 +
 crc/crc32c-intel.c                  |  7 ---
 crc/crc32c.c                        |  2 -
 crc/crc32c.h                        |  2 +
 crc/md5.c                           |  1 -
 crc/sha1.h                          |  2 +
 crc/sha256.c                        |  1 -
 crc/sha256.h                        |  2 +
 crc/sha3.c                          |  1 -
 crc/sha512.c                        |  1 -
 crc/sha512.h                        |  2 +
 crc/test.c                          |  5 +-
 debug.c                             |  5 +-
 debug.h                             |  4 +-
 diskutil.c                          |  3 --
 diskutil.h                          |  1 -
 engines/binject.c                   |  2 +-
 engines/e4defrag.c                  |  4 --
 engines/falloc.c                    |  4 --
 engines/filecreate.c                |  2 -
 engines/ftruncate.c                 |  8 +--
 engines/libaio.c                    |  2 -
 engines/mmap.c                      |  1 -
 engines/mtd.c                       |  3 --
 engines/net.c                       |  4 +-
 engines/null.c                      |  3 --
 engines/rdma.c                      |  2 +-
 engines/sg.c                        |  9 ++--
 engines/splice.c                    |  3 +-
 engines/sync.c                      |  1 -
 eta.c                               |  1 -
 fifo.c                              |  1 +
 fifo.h                              |  1 -
 filesetup.c                         |  2 -
 fio.c                               |  5 --
 fio.h                               |  1 +
 fio_sem.c                           |  2 +-
 fio_time.h                          |  3 ++
 gettime-thread.c                    |  2 -
 gettime.c                           |  7 ---
 gettime.h                           |  2 +
 helpers.c                           |  9 +---
 helpers.h                           |  5 +-
 idletime.c                          |  1 +
 idletime.h                          |  5 +-
 init.c                              |  2 -
 io_u.c                              |  4 --
 io_u.h                              |  1 -
 io_u_queue.h                        |  2 +
 ioengines.c                         |  1 -
 ioengines.h                         |  5 +-
 iolog.c                             |  2 -
 iolog.h                             |  2 +
 json.c                              |  1 -
 json.h                              |  4 --
 lib/bloom.c                         |  2 -
 lib/gauss.c                         |  1 -
 lib/ieee754.c                       |  1 -
 lib/lfsr.c                          |  1 -
 lib/memalign.c                      |  3 +-
 lib/memalign.h                      |  2 +
 lib/memcpy.c                        |  3 +-
 lib/num2str.c                       |  1 +
 lib/output_buffer.c                 |  1 -
 lib/output_buffer.h                 |  2 +-
 lib/pattern.c                       |  2 -
 lib/pattern.h                       |  2 -
 lib/prio_tree.c                     |  1 +
 lib/prio_tree.h                     |  1 -
 lib/rand.c                          |  1 -
 lib/rand.h                          |  1 -
 lib/strntol.h                       |  2 +
 lib/types.h                         |  2 +-
 lib/zipf.c                          |  6 ---
 lib/zipf.h                          |  1 +
 libfio.c                            |  1 -
 log.c                               | 97 ++++++++++---------------------------
 memory.c                            |  3 +-
 options.c                           |  4 --
 options.h                           |  1 -
 os/os-hpux.h                        |  2 +-
 os/os-solaris.h                     |  2 +-
 os/os.h                             |  4 +-
 os/windows/posix.c                  |  2 +-
 os/windows/posix/include/poll.h     | 11 +++++
 os/windows/posix/include/sys/poll.h | 15 ------
 oslib/asprintf.c                    | 43 ++++++++++++++++
 oslib/asprintf.h                    | 11 +++++
 oslib/strcasestr.c                  |  5 +-
 oslib/strcasestr.h                  |  7 +--
 oslib/strlcat.c                     |  4 ++
 oslib/strlcat.h                     |  6 +++
 oslib/strndup.c                     |  5 +-
 oslib/strndup.h                     |  9 +++-
 oslib/strsep.c                      |  7 ++-
 oslib/strsep.h                      |  4 ++
 parse.c                             |  4 +-
 server.c                            | 55 +++++++++++++++------
 server.h                            |  3 --
 smalloc.c                           |  8 ---
 smalloc.h                           |  2 +
 stat.c                              |  3 --
 steadystate.c                       |  1 -
 steadystate.h                       |  2 -
 t/axmap.c                           |  3 --
 t/btrace2fio.c                      |  2 +-
 t/dedupe.c                          | 10 ++--
 t/gen-rand.c                        | 12 ++---
 t/genzipf.c                         |  1 -
 t/lfsr-test.c                       |  4 --
 td_error.h                          |  2 +
 trim.c                              |  3 --
 trim.h                              |  8 ++-
 verify.c                            | 29 +++++------
 verify.h                            |  1 +
 workqueue.h                         |  7 +++
 129 files changed, 324 insertions(+), 354 deletions(-)
 delete mode 100644 os/windows/posix/include/sys/poll.h
 create mode 100644 oslib/asprintf.c
 create mode 100644 oslib/asprintf.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index eb3bddd..d45ba6b 100644
--- a/Makefile
+++ b/Makefile
@@ -104,6 +104,7 @@ endif
 ifdef CONFIG_RBD
   SOURCE += engines/rbd.c
 endif
+SOURCE += oslib/asprintf.c
 ifndef CONFIG_STRSEP
   SOURCE += oslib/strsep.c
 endif
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index 457b44c..c6bcb54 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -10,7 +10,7 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 		: "memory");
 }
 
-#include "arch-x86-common.h"
+#include "arch-x86-common.h" /* IWYU pragma: export */
 
 #define FIO_ARCH	(arch_x86)
 
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index e686d10..484ea0c 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -10,7 +10,7 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 		: "memory");
 }
 
-#include "arch-x86-common.h"
+#include "arch-x86-common.h" /* IWYU pragma: export */
 
 #define FIO_ARCH	(arch_x86_64)
 
diff --git a/arch/arch.h b/arch/arch.h
index 4fb9b51..0ec3f10 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -34,6 +34,7 @@ extern unsigned long arch_flags;
 
 #define ARCH_CPU_CLOCK_WRAPS
 
+/* IWYU pragma: begin_exports */
 #if defined(__i386__)
 #include "arch-x86.h"
 #elif defined(__x86_64__)
@@ -66,6 +67,7 @@ extern unsigned long arch_flags;
 #endif
 
 #include "../lib/ffz.h"
+/* IWYU pragma: end_exports */
 
 #ifndef ARCH_HAVE_INIT
 static inline int arch_init(char *envp[])
diff --git a/backend.c b/backend.c
index d82d494..a92b1e3 100644
--- a/backend.c
+++ b/backend.c
@@ -22,29 +22,17 @@
  *
  */
 #include <unistd.h>
-#include <fcntl.h>
 #include <string.h>
-#include <limits.h>
 #include <signal.h>
-#include <time.h>
-#include <locale.h>
 #include <assert.h>
-#include <time.h>
 #include <inttypes.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
-#include <sys/ipc.h>
-#include <sys/mman.h>
 #include <math.h>
 
 #include "fio.h"
-#ifndef FIO_NO_HAVE_SHM_H
-#include <sys/shm.h>
-#endif
-#include "hash.h"
 #include "smalloc.h"
 #include "verify.h"
-#include "trim.h"
 #include "diskutil.h"
 #include "cgroup.h"
 #include "profile.h"
diff --git a/blktrace.c b/blktrace.c
index 4b791d7..6e4d0a4 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -3,10 +3,8 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <linux/fs.h>
-#include <dirent.h>
 
 #include "flist.h"
 #include "fio.h"
diff --git a/cconv.c b/cconv.c
index 92996b1..dbe0071 100644
--- a/cconv.c
+++ b/cconv.c
@@ -1,5 +1,6 @@
 #include <string.h>
 
+#include "log.h"
 #include "thread_options.h"
 
 static void string_to_cpu(char **dst, const uint8_t *src)
diff --git a/cgroup.c b/cgroup.c
index 4fab977..380e37e 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -5,7 +5,6 @@
 #include <stdlib.h>
 #include <mntent.h>
 #include <sys/stat.h>
-#include <sys/types.h>
 #include "fio.h"
 #include "flist.h"
 #include "cgroup.h"
diff --git a/client.c b/client.c
index bff0adc..970974a 100644
--- a/client.c
+++ b/client.c
@@ -1,13 +1,11 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <limits.h>
 #include <errno.h>
 #include <fcntl.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/wait.h>
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <netinet/in.h>
@@ -23,7 +21,7 @@
 #include "server.h"
 #include "flist.h"
 #include "hash.h"
-#include "verify.h"
+#include "verify-state.h"
 
 static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd);
 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd);
diff --git a/client.h b/client.h
index 90082a3..29e84d0 100644
--- a/client.h
+++ b/client.h
@@ -1,7 +1,6 @@
 #ifndef CLIENT_H
 #define CLIENT_H
 
-#include <sys/socket.h>
 #include <sys/un.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
@@ -10,7 +9,6 @@
 #include "stat.h"
 
 struct fio_net_cmd;
-struct client_ops;
 
 enum {
 	Client_created		= 0,
@@ -83,6 +81,8 @@ typedef void (client_eta_op)(struct jobs_eta *je);
 typedef void (client_timed_out_op)(struct fio_client *);
 typedef void (client_jobs_eta_op)(struct fio_client *client, struct jobs_eta *je);
 
+extern struct client_ops fio_client_ops;
+
 struct client_ops {
 	client_cmd_op		*text;
 	client_cmd_op		*disk_util;
@@ -105,8 +105,6 @@ struct client_ops {
 	uint32_t client_type;
 };
 
-extern struct client_ops fio_client_ops;
-
 struct client_eta {
 	unsigned int pending;
 	struct jobs_eta eta;
diff --git a/compiler/compiler.h b/compiler/compiler.h
index 91a9883..4d92ac4 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -1,7 +1,7 @@
 #ifndef FIO_COMPILER_H
 #define FIO_COMPILER_H
-#include <assert.h>
 
+/* IWYU pragma: begin_exports */
 #if __GNUC__ >= 4
 #include "compiler-gcc4.h"
 #elif __GNUC__ == 3
@@ -9,6 +9,7 @@
 #else
 #error Compiler too old, need gcc at least gcc 3.x
 #endif
+/* IWYU pragma: end_exports */
 
 #ifndef __must_check
 #define __must_check
diff --git a/configure b/configure
index ddf03a6..f635863 100755
--- a/configure
+++ b/configure
@@ -784,6 +784,40 @@ fi
 print_config "rdmacm" "$rdmacm"
 
 ##########################################
+# asprintf() and vasprintf() probes
+if test "$have_asprintf" != "yes" ; then
+  have_asprintf="no"
+fi
+cat > $TMPC << EOF
+#include <stdio.h>
+
+int main(int argc, char **argv)
+{
+  return asprintf(NULL, "%s", "str") == 0;
+}
+EOF
+if compile_prog "" "" "have_asprintf"; then
+    have_asprintf="yes"
+fi
+print_config "asprintf()" "$have_asprintf"
+
+if test "$have_vasprintf" != "yes" ; then
+  have_vasprintf="no"
+fi
+cat > $TMPC << EOF
+#include <stdio.h>
+
+int main(int argc, char **argv)
+{
+  return vasprintf(NULL, "%s", NULL) == 0;
+}
+EOF
+if compile_prog "" "" "have_vasprintf"; then
+    have_vasprintf="yes"
+fi
+print_config "vasprintf()" "$have_vasprintf"
+
+##########################################
 # Linux fallocate probe
 if test "$linux_fallocate" != "yes" ; then
   linux_fallocate="no"
@@ -2169,6 +2203,12 @@ fi
 if test "$posix_pshared" = "yes" ; then
   output_sym "CONFIG_PSHARED"
 fi
+if test "$have_asprintf" = "yes" ; then
+    output_sym "HAVE_ASPRINTF"
+fi
+if test "$have_vasprintf" = "yes" ; then
+    output_sym "HAVE_VASPRINTF"
+fi
 if test "$linux_fallocate" = "yes" ; then
   output_sym "CONFIG_LINUX_FALLOCATE"
 fi
diff --git a/crc/crc32.c b/crc/crc32.c
index 4140a8d..e35f5d9 100644
--- a/crc/crc32.c
+++ b/crc/crc32.c
@@ -15,7 +15,6 @@
    along with this program; if not, write to the Free Software Foundation,
    Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */
 
-#include <inttypes.h>
 #include "crc32.h"
 
 static const uint32_t crctab[256] = {
diff --git a/crc/crc32.h b/crc/crc32.h
index a37d7ad..6378e81 100644
--- a/crc/crc32.h
+++ b/crc/crc32.h
@@ -18,6 +18,8 @@
 #ifndef CRC32_H
 #define CRC32_H
 
+#include <inttypes.h>
+
 extern uint32_t fio_crc32(const void * const, unsigned long);
 
 #endif
diff --git a/crc/crc32c-intel.c b/crc/crc32c-intel.c
index 05a087d..9a2cefd 100644
--- a/crc/crc32c-intel.c
+++ b/crc/crc32c-intel.c
@@ -1,10 +1,3 @@
-#include <inttypes.h>
-#include <string.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <signal.h>
-#include <sys/types.h>
-#include <sys/wait.h>
 #include "crc32c.h"
 
 /*
diff --git a/crc/crc32c.c b/crc/crc32c.c
index f6fc688..34944ae 100644
--- a/crc/crc32c.c
+++ b/crc/crc32c.c
@@ -30,8 +30,6 @@
  * any later version.
  *
  */
-#include <inttypes.h>
-
 #include "crc32c.h"
 
 /*
diff --git a/crc/crc32c.h b/crc/crc32c.h
index be03c1a..60f6014 100644
--- a/crc/crc32c.h
+++ b/crc/crc32c.h
@@ -18,6 +18,8 @@
 #ifndef CRC32C_H
 #define CRC32C_H
 
+#include <inttypes.h>
+
 #include "../arch/arch.h"
 #include "../lib/types.h"
 
diff --git a/crc/md5.c b/crc/md5.c
index 64fe48a..ade4f69 100644
--- a/crc/md5.c
+++ b/crc/md5.c
@@ -2,7 +2,6 @@
  * Shamelessly lifted from the 2.6 kernel (crypto/md5.c)
  */
 #include <string.h>
-#include <stdint.h>
 #include "md5.h"
 
 static void md5_transform(uint32_t *hash, uint32_t const *in)
diff --git a/crc/sha1.h b/crc/sha1.h
index 75317f7..416199b 100644
--- a/crc/sha1.h
+++ b/crc/sha1.h
@@ -1,6 +1,8 @@
 #ifndef FIO_SHA1
 #define FIO_SHA1
 
+#include <inttypes.h>
+
 /*
  * Based on the Mozilla SHA1 (see mozilla-sha1/sha1.h),
  * optimized to do word accesses rather than byte accesses,
diff --git a/crc/sha256.c b/crc/sha256.c
index 2fd17a3..2b39c42 100644
--- a/crc/sha256.c
+++ b/crc/sha256.c
@@ -17,7 +17,6 @@
  *
  */
 #include <string.h>
-#include <inttypes.h>
 
 #include "../lib/bswap.h"
 #include "sha256.h"
diff --git a/crc/sha256.h b/crc/sha256.h
index b636033..b904c7d 100644
--- a/crc/sha256.h
+++ b/crc/sha256.h
@@ -1,6 +1,8 @@
 #ifndef FIO_SHA256_H
 #define FIO_SHA256_H
 
+#include <inttypes.h>
+
 #define SHA256_DIGEST_SIZE	32
 #define SHA256_BLOCK_SIZE	64
 
diff --git a/crc/sha3.c b/crc/sha3.c
index 2685dce..c136550 100644
--- a/crc/sha3.c
+++ b/crc/sha3.c
@@ -13,7 +13,6 @@
  *
  */
 #include <string.h>
-#include <inttypes.h>
 
 #include "../os/os.h"
 
diff --git a/crc/sha512.c b/crc/sha512.c
index e069a44..f599cdc 100644
--- a/crc/sha512.c
+++ b/crc/sha512.c
@@ -12,7 +12,6 @@
  */
 
 #include <string.h>
-#include <inttypes.h>
 
 #include "../lib/bswap.h"
 #include "sha512.h"
diff --git a/crc/sha512.h b/crc/sha512.h
index f8b2112..5adf627 100644
--- a/crc/sha512.h
+++ b/crc/sha512.h
@@ -1,6 +1,8 @@
 #ifndef FIO_SHA512_H
 #define FIO_SHA512_H
 
+#include <inttypes.h>
+
 struct fio_sha512_ctx {
 	uint64_t state[8];
 	uint32_t count[4];
diff --git a/crc/test.c b/crc/test.c
index b119872..b57f07a 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -1,11 +1,12 @@
+#include <inttypes.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 
-#include "../fio.h"
 #include "../gettime.h"
 #include "../fio_time.h"
-#include "../verify.h"
+#include "../lib/rand.h"
+#include "../os/os.h"
 
 #include "../crc/md5.h"
 #include "../crc/crc64.h"
diff --git a/debug.c b/debug.c
index 2bee507..d1e2987 100644
--- a/debug.c
+++ b/debug.c
@@ -1,7 +1,8 @@
+#include <assert.h>
 #include <stdarg.h>
-#include <sys/types.h>
-#include <unistd.h>
+
 #include "debug.h"
+#include "log.h"
 
 #ifdef FIO_INC_DEBUG
 void __dprint(int type, const char *str, ...)
diff --git a/debug.h b/debug.h
index b8718dd..8a8cf87 100644
--- a/debug.h
+++ b/debug.h
@@ -1,9 +1,7 @@
 #ifndef FIO_DEBUG_H
 #define FIO_DEBUG_H
 
-#include <assert.h>
 #include "lib/types.h"
-#include "log.h"
 
 enum {
 	FD_PROCESS	= 0,
@@ -61,7 +59,7 @@ void __dprint(int type, const char *str, ...) __attribute__((format (printf, 2,
 
 #define dprint(type, str, args...)			\
 	do {						\
-		if ((((1 << type)) & fio_debug) == 0)	\
+		if (((1 << type) & fio_debug) == 0)	\
 			break;				\
 		__dprint((type), (str), ##args);	\
 	} while (0)					\
diff --git a/diskutil.c b/diskutil.c
index dd8fc6a..b973120 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -1,13 +1,10 @@
 #include <stdio.h>
 #include <string.h>
-#include <sys/time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
 #include <dirent.h>
 #include <libgen.h>
-#include <math.h>
-#include <assert.h>
 #ifdef CONFIG_VALGRIND_DEV
 #include <valgrind/drd.h>
 #else
diff --git a/diskutil.h b/diskutil.h
index c103578..15ec681 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -3,7 +3,6 @@
 #include "json.h"
 #define FIO_DU_NAME_SZ		64
 
-#include "lib/output_buffer.h"
 #include "helper_thread.h"
 #include "fio_sem.h"
 
diff --git a/engines/binject.c b/engines/binject.c
index 792dbbd..49042a3 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -11,7 +11,7 @@
 #include <errno.h>
 #include <assert.h>
 #include <string.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 4b44488..3619450 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -9,11 +9,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <sys/uio.h>
 #include <errno.h>
-#include <assert.h>
 #include <fcntl.h>
 
 #include "../fio.h"
diff --git a/engines/falloc.c b/engines/falloc.c
index 2b00d52..bb3ac85 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -9,11 +9,7 @@
  *
  */
 #include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <sys/uio.h>
 #include <errno.h>
-#include <assert.h>
 #include <fcntl.h>
 
 #include "../fio.h"
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 0c3bcdd..6fa041c 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -5,12 +5,10 @@
  * of the file creation.
  */
 #include <stdio.h>
-#include <unistd.h>
 #include <fcntl.h>
 #include <errno.h>
 
 #include "../fio.h"
-#include "../filehash.h"
 
 struct fc_data {
 	enum fio_ddir stat_ddir;
diff --git a/engines/ftruncate.c b/engines/ftruncate.c
index e86dbac..14e115f 100644
--- a/engines/ftruncate.c
+++ b/engines/ftruncate.c
@@ -6,16 +6,10 @@
  * DDIR_WRITE does ftruncate
  *
  */
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <sys/uio.h>
 #include <errno.h>
-#include <assert.h>
-#include <fcntl.h>
+#include <unistd.h>
 
 #include "../fio.h"
-#include "../filehash.h"
 
 static int fio_ftruncate_queue(struct thread_data *td, struct io_u *io_u)
 {
diff --git a/engines/libaio.c b/engines/libaio.c
index e0d7cbb..7d59df3 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -4,11 +4,9 @@
  * IO engine using the Linux native aio interface.
  *
  */
-#include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
-#include <assert.h>
 #include <libaio.h>
 
 #include "../fio.h"
diff --git a/engines/mmap.c b/engines/mmap.c
index ea7179d..9dbefc8 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -7,7 +7,6 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
 #include <errno.h>
 #include <sys/mman.h>
 
diff --git a/engines/mtd.c b/engines/mtd.c
index b4a6600..5f822fc 100644
--- a/engines/mtd.c
+++ b/engines/mtd.c
@@ -4,17 +4,14 @@
  * IO engine that reads/writes from MTD character devices.
  *
  */
-#include <assert.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
 #include <errno.h>
 #include <sys/ioctl.h>
 #include <mtd/mtd-user.h>
 
 #include "../fio.h"
 #include "../optgroup.h"
-#include "../verify.h"
 #include "../oslib/libmtd.h"
 
 static libmtd_t desc;
diff --git a/engines/net.c b/engines/net.c
index 37d44fd..4540e0e 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -9,13 +9,11 @@
 #include <unistd.h>
 #include <signal.h>
 #include <errno.h>
-#include <assert.h>
 #include <netinet/in.h>
 #include <netinet/tcp.h>
 #include <arpa/inet.h>
 #include <netdb.h>
-#include <sys/poll.h>
-#include <sys/types.h>
+#include <poll.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
 #include <sys/un.h>
diff --git a/engines/null.c b/engines/null.c
index 0cfc22a..8c26ad7 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -13,10 +13,7 @@
  * LD_LIBRARY_PATH=./engines ./fio examples/cpp_null.fio
  *
  */
-#include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <errno.h>
 #include <assert.h>
 
 #include "../fio.h"
diff --git a/engines/rdma.c b/engines/rdma.c
index 6b173a8..8def6eb 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -30,7 +30,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <netdb.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/time.h>
diff --git a/engines/sg.c b/engines/sg.c
index f240755..72eed8b 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -8,8 +8,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
-#include <assert.h>
-#include <sys/poll.h>
+#include <poll.h>
 
 #include "../fio.h"
 #include "../optgroup.h"
@@ -456,8 +455,10 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		return ret;
 	}
 
-	*bs	 = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
-	*max_lba = ((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) & MAX_10B_LBA;  // for some reason max_lba is being sign extended even though unsigned.
+	*bs	 = ((unsigned long) buf[4] << 24) | ((unsigned long) buf[5] << 16) |
+		   ((unsigned long) buf[6] << 8) | (unsigned long) buf[7];
+	*max_lba = ((unsigned long) buf[0] << 24) | ((unsigned long) buf[1] << 16) |
+		   ((unsigned long) buf[2] << 8) | (unsigned long) buf[3];
 
 	/*
 	 * If max lba masked by MAX_10B_LBA equals MAX_10B_LBA,
diff --git a/engines/splice.c b/engines/splice.c
index d5d8ab0..08fc857 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -9,8 +9,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
-#include <assert.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/mman.h>
 
 #include "../fio.h"
diff --git a/engines/sync.c b/engines/sync.c
index 26b98b6..d5b4012 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -10,7 +10,6 @@
 #include <unistd.h>
 #include <sys/uio.h>
 #include <errno.h>
-#include <assert.h>
 
 #include "../fio.h"
 #include "../optgroup.h"
diff --git a/eta.c b/eta.c
index 3126f21..2d549ee 100644
--- a/eta.c
+++ b/eta.c
@@ -2,7 +2,6 @@
  * Status and ETA code
  */
 #include <unistd.h>
-#include <fcntl.h>
 #include <string.h>
 #ifdef CONFIG_VALGRIND_DEV
 #include <valgrind/drd.h>
diff --git a/fifo.c b/fifo.c
index 98737e9..ac0d215 100644
--- a/fifo.c
+++ b/fifo.c
@@ -24,6 +24,7 @@
 #include <string.h>
 
 #include "fifo.h"
+#include "minmax.h"
 
 struct fifo *fifo_alloc(unsigned int size)
 {
diff --git a/fifo.h b/fifo.h
index 5e3d339..61cc5a8 100644
--- a/fifo.h
+++ b/fifo.h
@@ -20,7 +20,6 @@
  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
-#include "minmax.h"
 
 struct fifo {
 	unsigned char *buffer;	/* the buffer holding the data */
diff --git a/filesetup.c b/filesetup.c
index 7cbce13..c115f7b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -5,8 +5,6 @@
 #include <dirent.h>
 #include <libgen.h>
 #include <sys/stat.h>
-#include <sys/mman.h>
-#include <sys/types.h>
 
 #include "fio.h"
 #include "smalloc.h"
diff --git a/fio.c b/fio.c
index 7b61ffc..f19db1b 100644
--- a/fio.c
+++ b/fio.c
@@ -21,12 +21,7 @@
  *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
-#include <unistd.h>
-#include <locale.h>
-#include <time.h>
-
 #include "fio.h"
-#include "smalloc.h"
 
 int main(int argc, char *argv[], char *envp[])
 {
diff --git a/fio.h b/fio.h
index 9551048..488fa9a 100644
--- a/fio.h
+++ b/fio.h
@@ -27,6 +27,7 @@
 #include "ioengines.h"
 #include "iolog.h"
 #include "helpers.h"
+#include "minmax.h"
 #include "options.h"
 #include "profile.h"
 #include "fio_time.h"
diff --git a/fio_sem.c b/fio_sem.c
index 20fcfcc..3b48061 100644
--- a/fio_sem.c
+++ b/fio_sem.c
@@ -1,3 +1,4 @@
+#include <stdio.h>
 #include <string.h>
 #include <sys/mman.h>
 #include <assert.h>
@@ -7,7 +8,6 @@
 #define RUNNING_ON_VALGRIND 0
 #endif
 
-#include "log.h"
 #include "fio_sem.h"
 #include "pshared.h"
 #include "os/os.h"
diff --git a/fio_time.h b/fio_time.h
index 8b4bb25..c00f8e7 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -1,8 +1,11 @@
 #ifndef FIO_TIME_H
 #define FIO_TIME_H
 
+#include <stdint.h>
+/* IWYU pragma: begin_exports */
 #include <time.h>
 #include <sys/time.h>
+/* IWYU pragma: end_exports */
 #include "lib/types.h"
 
 struct thread_data;
diff --git a/gettime-thread.c b/gettime-thread.c
index 87f5060..eb535a0 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -1,5 +1,3 @@
-#include <unistd.h>
-#include <math.h>
 #include <sys/time.h>
 #include <time.h>
 
diff --git a/gettime.c b/gettime.c
index 57c66f7..87fc29b 100644
--- a/gettime.c
+++ b/gettime.c
@@ -2,16 +2,9 @@
  * Clock functions
  */
 
-#include <unistd.h>
 #include <math.h>
-#include <sys/time.h>
-#include <time.h>
 
 #include "fio.h"
-#include "fio_sem.h"
-#include "smalloc.h"
-
-#include "hash.h"
 #include "os/os.h"
 
 #if defined(ARCH_HAVE_CPU_CLOCK)
diff --git a/gettime.h b/gettime.h
index 11e2a7b..1c4a25c 100644
--- a/gettime.h
+++ b/gettime.h
@@ -1,6 +1,8 @@
 #ifndef FIO_GETTIME_H
 #define FIO_GETTIME_H
 
+#include <sys/time.h>
+
 #include "arch/arch.h"
 
 /*
diff --git a/helpers.c b/helpers.c
index 4342b2d..a0ee370 100644
--- a/helpers.c
+++ b/helpers.c
@@ -1,13 +1,6 @@
-#include <stdlib.h>
 #include <errno.h>
-#include <sys/socket.h>
-#include <sys/time.h>
-#include <netinet/in.h>
-#include <unistd.h>
 
-#include "compiler/compiler.h"
-#include "arch/arch.h"
-#include "os/os.h"
+#include "helpers.h"
 
 #ifndef CONFIG_LINUX_FALLOCATE
 int fallocate(int fd, int mode, off_t offset, off_t len)
diff --git a/helpers.h b/helpers.h
index 5f1865b..a0b3285 100644
--- a/helpers.h
+++ b/helpers.h
@@ -1,10 +1,9 @@
 #ifndef FIO_HELPERS_H
 #define FIO_HELPERS_H
 
-#include "compiler/compiler.h"
-
 #include <sys/types.h>
-#include <time.h>
+
+#include "os/os.h"
 
 extern int fallocate(int fd, int mode, off_t offset, off_t len);
 extern int posix_fallocate(int fd, off_t offset, off_t len);
diff --git a/idletime.c b/idletime.c
index 90bc1d9..8762c85 100644
--- a/idletime.c
+++ b/idletime.c
@@ -1,4 +1,5 @@
 #include <math.h>
+#include "fio.h"
 #include "json.h"
 #include "idletime.h"
 
diff --git a/idletime.h b/idletime.h
index b8376c2..6c1161a 100644
--- a/idletime.h
+++ b/idletime.h
@@ -1,8 +1,9 @@
 #ifndef FIO_IDLETIME_H
 #define FIO_IDLETIME_H
 
-#include "fio.h"
-#include "lib/output_buffer.h"
+#include <sys/time.h>
+#include <sys/types.h>
+#include "os/os.h"
 
 #define CALIBRATE_RUNS  10
 #define CALIBRATE_SCALE 1000
diff --git a/init.c b/init.c
index e47e538..ab7e399 100644
--- a/init.c
+++ b/init.c
@@ -4,13 +4,11 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <fcntl.h>
 #include <ctype.h>
 #include <string.h>
 #include <errno.h>
 #include <sys/ipc.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <dlfcn.h>
 #ifdef CONFIG_VALGRIND_DEV
 #include <valgrind/drd.h>
diff --git a/io_u.c b/io_u.c
index f3b5932..98a7dc5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1,12 +1,8 @@
 #include <unistd.h>
-#include <fcntl.h>
 #include <string.h>
-#include <signal.h>
-#include <time.h>
 #include <assert.h>
 
 #include "fio.h"
-#include "hash.h"
 #include "verify.h"
 #include "trim.h"
 #include "lib/rand.h"
diff --git a/io_u.h b/io_u.h
index da25efb..aaa7d97 100644
--- a/io_u.h
+++ b/io_u.h
@@ -3,7 +3,6 @@
 
 #include "compiler/compiler.h"
 #include "os/os.h"
-#include "log.h"
 #include "io_ddir.h"
 #include "debug.h"
 #include "file.h"
diff --git a/io_u_queue.h b/io_u_queue.h
index b5b8d2f..545e2c4 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -2,6 +2,8 @@
 #define FIO_IO_U_QUEUE
 
 #include <assert.h>
+#include <stddef.h>
+
 #include "lib/types.h"
 
 struct io_u;
diff --git a/ioengines.c b/ioengines.c
index 965581a..a8ec79d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -9,7 +9,6 @@
  * generic io engine that could be used for other projects.
  *
  */
-#include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
diff --git a/ioengines.h b/ioengines.h
index 32b18ed..a0674ae 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -1,9 +1,10 @@
 #ifndef FIO_IOENGINE_H
 #define FIO_IOENGINE_H
 
+#include <stddef.h>
+
 #include "compiler/compiler.h"
-#include "os/os.h"
-#include "file.h"
+#include "flist.h"
 #include "io_u.h"
 
 #define FIO_IOOPS_VERSION	23
diff --git a/iolog.c b/iolog.c
index 460d7a2..2b5eaf0 100644
--- a/iolog.c
+++ b/iolog.c
@@ -4,7 +4,6 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <libgen.h>
 #include <assert.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -15,7 +14,6 @@
 
 #include "flist.h"
 #include "fio.h"
-#include "verify.h"
 #include "trim.h"
 #include "filelock.h"
 #include "smalloc.h"
diff --git a/iolog.h b/iolog.h
index 70981f9..f70eb61 100644
--- a/iolog.h
+++ b/iolog.h
@@ -1,6 +1,8 @@
 #ifndef FIO_IOLOG_H
 #define FIO_IOLOG_H
 
+#include <stdio.h>
+
 #include "lib/rbtree.h"
 #include "lib/ieee754.h"
 #include "flist.h"
diff --git a/json.c b/json.c
index e0227ec..75212c8 100644
--- a/json.c
+++ b/json.c
@@ -1,6 +1,5 @@
 #include <stdlib.h>
 #include <string.h>
-#include <stdio.h>
 #include <errno.h>
 #include <stdarg.h>
 #include "json.h"
diff --git a/json.h b/json.h
index d7017e0..bcc712c 100644
--- a/json.h
+++ b/json.h
@@ -3,10 +3,6 @@
 
 #include "lib/output_buffer.h"
 
-struct json_object;
-struct json_array;
-struct json_pair;
-
 #define JSON_TYPE_STRING 0
 #define JSON_TYPE_INTEGER 1
 #define JSON_TYPE_FLOAT 2
diff --git a/lib/bloom.c b/lib/bloom.c
index bb81dbb..f4f9b6b 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -1,9 +1,7 @@
 #include <stdlib.h>
-#include <inttypes.h>
 
 #include "bloom.h"
 #include "../hash.h"
-#include "../minmax.h"
 #include "../crc/xxhash.h"
 #include "../crc/murmur3.h"
 #include "../crc/crc32c.h"
diff --git a/lib/gauss.c b/lib/gauss.c
index f974490..1d24e18 100644
--- a/lib/gauss.c
+++ b/lib/gauss.c
@@ -1,6 +1,5 @@
 #include <math.h>
 #include <string.h>
-#include <stdio.h>
 #include "../hash.h"
 #include "gauss.h"
 
diff --git a/lib/ieee754.c b/lib/ieee754.c
index c7742a2..2154065 100644
--- a/lib/ieee754.c
+++ b/lib/ieee754.c
@@ -5,7 +5,6 @@
  *
  * Below code was granted to the public domain.
  */
-#include <inttypes.h>
 #include "ieee754.h"
 
 uint64_t pack754(long double f, unsigned bits, unsigned expbits)
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 0c0072c..a4f1fb1 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -1,5 +1,4 @@
 #include <stdio.h>
-#include <math.h>
 
 #include "lfsr.h"
 #include "../compiler/compiler.h"
diff --git a/lib/memalign.c b/lib/memalign.c
index bfbd1e8..e774c19 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -1,6 +1,5 @@
-#include <stdlib.h>
 #include <assert.h>
-#include <inttypes.h>
+#include <stdlib.h>
 
 #include "memalign.h"
 
diff --git a/lib/memalign.h b/lib/memalign.h
index df412e2..c2eb170 100644
--- a/lib/memalign.h
+++ b/lib/memalign.h
@@ -1,6 +1,8 @@
 #ifndef FIO_MEMALIGN_H
 #define FIO_MEMALIGN_H
 
+#include <inttypes.h>
+
 extern void *fio_memalign(size_t alignment, size_t size);
 extern void fio_memfree(void *ptr, size_t size);
 
diff --git a/lib/memcpy.c b/lib/memcpy.c
index 00e65aa..cf8572e 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -1,3 +1,4 @@
+#include <inttypes.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -6,7 +7,7 @@
 #include "rand.h"
 #include "../fio_time.h"
 #include "../gettime.h"
-#include "../fio.h"
+#include "../os/os.h"
 
 #define BUF_SIZE	32 * 1024 * 1024ULL
 
diff --git a/lib/num2str.c b/lib/num2str.c
index 8d08841..387c5d7 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -1,3 +1,4 @@
+#include <assert.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
diff --git a/lib/output_buffer.c b/lib/output_buffer.c
index f6c304b..beb8a14 100644
--- a/lib/output_buffer.c
+++ b/lib/output_buffer.c
@@ -1,4 +1,3 @@
-#include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
 
diff --git a/lib/output_buffer.h b/lib/output_buffer.h
index a235af2..389ed5b 100644
--- a/lib/output_buffer.h
+++ b/lib/output_buffer.h
@@ -1,7 +1,7 @@
 #ifndef FIO_OUTPUT_BUFFER_H
 #define FIO_OUTPUT_BUFFER_H
 
-#include <unistd.h>
+#include <stddef.h>
 
 struct buf_output {
 	char *buf;
diff --git a/lib/pattern.c b/lib/pattern.c
index 31ee4ea..2024f2e 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -4,8 +4,6 @@
 #include <limits.h>
 #include <errno.h>
 #include <assert.h>
-#include <sys/types.h>
-#include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
 
diff --git a/lib/pattern.h b/lib/pattern.h
index 9f937f0..2d655ad 100644
--- a/lib/pattern.h
+++ b/lib/pattern.h
@@ -1,8 +1,6 @@
 #ifndef FIO_PARSE_PATTERN_H
 #define FIO_PARSE_PATTERN_H
 
-struct pattern_fmt;
-
 /**
  * Pattern format description. The input for 'parse_pattern'.
  * Describes format with its name and callback, which should
diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index de3fe1c..d8e1b89 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -11,6 +11,7 @@
  * 02Feb2004	Initial version
  */
 
+#include <assert.h>
 #include <stdlib.h>
 #include <limits.h>
 
diff --git a/lib/prio_tree.h b/lib/prio_tree.h
index e1491db..9bd458f 100644
--- a/lib/prio_tree.h
+++ b/lib/prio_tree.h
@@ -2,7 +2,6 @@
 #define _LINUX_PRIO_TREE_H
 
 #include <inttypes.h>
-#include "../hash.h"
 
 struct prio_tree_node {
 	struct prio_tree_node	*left;
diff --git a/lib/rand.c b/lib/rand.c
index 3f60a67..46ffe4f 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -34,7 +34,6 @@
 */
 
 #include <string.h>
-#include <assert.h>
 #include "rand.h"
 #include "pattern.h"
 #include "../hash.h"
diff --git a/lib/rand.h b/lib/rand.h
index bff4a35..8832c73 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -4,7 +4,6 @@
 #include <inttypes.h>
 #include <assert.h>
 #include "types.h"
-#include "../arch/arch.h"
 
 #define FRAND32_MAX	(-1U)
 #define FRAND64_MAX	(-1ULL)
diff --git a/lib/strntol.h b/lib/strntol.h
index 68f5d1b..59c090d 100644
--- a/lib/strntol.h
+++ b/lib/strntol.h
@@ -1,6 +1,8 @@
 #ifndef FIO_STRNTOL_H
 #define FIO_STRNTOL_H
 
+#include <stdint.h>
+
 long strntol(const char *str, size_t sz, char **end, int base);
 
 #endif
diff --git a/lib/types.h b/lib/types.h
index bb24506..236bf8a 100644
--- a/lib/types.h
+++ b/lib/types.h
@@ -10,7 +10,7 @@ typedef int bool;
 #define true	1
 #endif
 #else
-#include <stdbool.h>
+#include <stdbool.h> /* IWYU pragma: export */
 #endif
 
 #endif
diff --git a/lib/zipf.c b/lib/zipf.c
index 3d535c7..1ff8568 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -1,11 +1,5 @@
 #include <math.h>
 #include <string.h>
-#include <inttypes.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <fcntl.h>
-#include "ieee754.h"
 #include "zipf.h"
 #include "../minmax.h"
 #include "../hash.h"
diff --git a/lib/zipf.h b/lib/zipf.h
index af2d0e6..a4aa163 100644
--- a/lib/zipf.h
+++ b/lib/zipf.h
@@ -3,6 +3,7 @@
 
 #include <inttypes.h>
 #include "rand.h"
+#include "types.h"
 
 struct zipf_state {
 	uint64_t nranges;
diff --git a/libfio.c b/libfio.c
index 80159b4..6faf32a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -23,7 +23,6 @@
  */
 
 #include <string.h>
-#include <sys/types.h>
 #include <signal.h>
 #include <stdint.h>
 #include <locale.h>
diff --git a/log.c b/log.c
index a327f6a..46e5034 100644
--- a/log.c
+++ b/log.c
@@ -1,12 +1,10 @@
 #include <unistd.h>
-#include <fcntl.h>
 #include <string.h>
 #include <stdarg.h>
 #include <syslog.h>
 
 #include "fio.h"
-
-#define LOG_START_SZ		512
+#include "oslib/asprintf.h"
 
 size_t log_info_buf(const char *buf, size_t len)
 {
@@ -29,63 +27,14 @@ size_t log_info_buf(const char *buf, size_t len)
 		return fwrite(buf, len, 1, f_out);
 }
 
-static size_t valist_to_buf(char **buffer, const char *fmt, va_list src_args)
-{
-	size_t len, cur = LOG_START_SZ;
-	va_list args;
-
-	do {
-		*buffer = calloc(1, cur);
-		if (!*buffer)
-			return 0;
-
-		va_copy(args, src_args);
-		len = vsnprintf(*buffer, cur, fmt, args);
-		va_end(args);
-
-		if (len < cur)
-			break;
-
-		cur = len + 1;
-		free(*buffer);
-	} while (1);
-
-	return len;
-}
-
-/* allocate buffer, fill with prefix string followed by vararg string */
-static size_t prevalist_to_buf(char **buffer, const char *pre, int prelen,
-		const char *fmt, va_list src_args)
-{
-	size_t len, cur = LOG_START_SZ;
-	va_list args;
-
-	do {
-		*buffer = calloc(1, cur);
-		if (!*buffer)
-			return 0;
-
-		va_copy(args, src_args);
-		memcpy(*buffer, pre, prelen);
-		len = prelen + vsnprintf(*buffer + prelen, cur - prelen, fmt, args);
-		va_end(args);
-
-		if (len < cur)
-			break;
-
-		cur = len + 1;
-		free(*buffer);
-	} while (1);
-
-	return len;
-}
-
 size_t log_valist(const char *fmt, va_list args)
 {
 	char *buffer;
-	size_t len;
+	int len;
 
-	len = valist_to_buf(&buffer, fmt, args);
+	len = vasprintf(&buffer, fmt, args);
+	if (len < 0)
+		return 0;
 	len = log_info_buf(buffer, len);
 	free(buffer);
 
@@ -95,10 +44,8 @@ size_t log_valist(const char *fmt, va_list args)
 /* add prefix for the specified type in front of the valist */
 void log_prevalist(int type, const char *fmt, va_list args)
 {
-	char pre[32];
-	char *buffer;
-	size_t len;
-	int prelen;
+	char *buf1, *buf2;
+	int len;
 	pid_t pid;
 
 	pid = gettid();
@@ -106,12 +53,16 @@ void log_prevalist(int type, const char *fmt, va_list args)
 	    && pid != *fio_debug_jobp)
 		return;
 
-	prelen = snprintf(pre, sizeof pre, "%-8s %-5u ", debug_levels[type].name, (int) pid);
-	if (prelen > 0) {
-		len = prevalist_to_buf(&buffer, pre, prelen, fmt, args);
-		len = log_info_buf(buffer, len);
-		free(buffer);
-	}
+	len = vasprintf(&buf1, fmt, args);
+	if (len < 0)
+		return;
+	len = asprintf(&buf2, "%-8s %-5u %s", debug_levels[type].name,
+		       (int) pid, buf1);
+	free(buf1);
+	if (len < 0)
+		return;
+	len = log_info_buf(buf2, len);
+	free(buf2);
 }
 
 size_t log_info(const char *format, ...)
@@ -130,12 +81,13 @@ size_t __log_buf(struct buf_output *buf, const char *format, ...)
 {
 	char *buffer;
 	va_list args;
-	size_t len;
+	int len;
 
 	va_start(args, format);
-	len = valist_to_buf(&buffer, format, args);
+	len = vasprintf(&buffer, format, args);
 	va_end(args);
-
+	if (len < 0)
+		return 0;
 	len = buf_output_add(buf, buffer, len);
 	free(buffer);
 
@@ -152,13 +104,16 @@ int log_info_flush(void)
 
 size_t log_err(const char *format, ...)
 {
-	size_t ret, len;
+	size_t ret;
+	int len;
 	char *buffer;
 	va_list args;
 
 	va_start(args, format);
-	len = valist_to_buf(&buffer, format, args);
+	len = vasprintf(&buffer, format, args);
 	va_end(args);
+	if (len < 0)
+		return len;
 
 	if (is_backend) {
 		ret = fio_server_text_output(FIO_LOG_ERR, buffer, len);
diff --git a/memory.c b/memory.c
index 04dc3be..5f0225f 100644
--- a/memory.c
+++ b/memory.c
@@ -1,11 +1,10 @@
 /*
  * Memory helpers
  */
-#include <sys/types.h>
-#include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <sys/stat.h>
 
 #include "fio.h"
 #ifndef FIO_NO_HAVE_SHM_H
diff --git a/options.c b/options.c
index 6810521..45a5b82 100644
--- a/options.c
+++ b/options.c
@@ -4,16 +4,12 @@
 #include <ctype.h>
 #include <string.h>
 #include <assert.h>
-#include <libgen.h>
-#include <fcntl.h>
-#include <sys/types.h>
 #include <sys/stat.h>
 #include <netinet/in.h>
 
 #include "fio.h"
 #include "verify.h"
 #include "parse.h"
-#include "lib/fls.h"
 #include "lib/pattern.h"
 #include "options.h"
 #include "optgroup.h"
diff --git a/options.h b/options.h
index 83a58e2..59024ef 100644
--- a/options.h
+++ b/options.h
@@ -6,7 +6,6 @@
 #include <string.h>
 #include <inttypes.h>
 #include "parse.h"
-#include "flist.h"
 #include "lib/types.h"
 
 int add_option(struct fio_option *);
diff --git a/os/os-hpux.h b/os/os-hpux.h
index 6a240b0..515a525 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -6,7 +6,7 @@
 #include <errno.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include <sys/fadvise.h>
 #include <sys/mman.h>
 #include <sys/mpctl.h>
diff --git a/os/os-solaris.h b/os/os-solaris.h
index db03546..2425ab9 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -7,7 +7,7 @@
 #include <malloc.h>
 #include <unistd.h>
 #include <sys/types.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include <sys/pset.h>
 #include <sys/mman.h>
 #include <sys/dkio.h>
diff --git a/os/os.h b/os/os.h
index 1a4437c..95ed7cf 100644
--- a/os/os.h
+++ b/os/os.h
@@ -8,7 +8,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 
-#include "../arch/arch.h"
+#include "../arch/arch.h" /* IWYU pragma: export */
 #include "../lib/types.h"
 
 enum {
@@ -27,6 +27,7 @@ enum {
 	os_nr,
 };
 
+/* IWYU pragma: begin_exports */
 #if defined(__ANDROID__)
 #include "os-android.h"
 #elif defined(__linux__)
@@ -67,6 +68,7 @@ typedef struct aiocb os_aiocb_t;
 #ifndef CONFIG_STRLCAT
 #include "../oslib/strlcat.h"
 #endif
+/* IWYU pragma: end_exports */
 
 #ifdef MSG_DONTWAIT
 #define OS_MSG_DONTWAIT	MSG_DONTWAIT
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 17e18a1..ecc8c40 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -18,7 +18,7 @@
 #include <sys/mman.h>
 #include <sys/uio.h>
 #include <sys/resource.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/wait.h>
 #include <setjmp.h>
 
diff --git a/os/windows/posix/include/poll.h b/os/windows/posix/include/poll.h
index 058e23a..f064e2b 100644
--- a/os/windows/posix/include/poll.h
+++ b/os/windows/posix/include/poll.h
@@ -1,4 +1,15 @@
 #ifndef POLL_H
 #define POLL_H
 
+typedef int nfds_t;
+
+struct pollfd
+{
+	int fd;
+	short events;
+	short revents;
+};
+
+int poll(struct pollfd fds[], nfds_t nfds, int timeout);
+
 #endif /* POLL_H */
diff --git a/os/windows/posix/include/sys/poll.h b/os/windows/posix/include/sys/poll.h
deleted file mode 100644
index f009d6e..0000000
--- a/os/windows/posix/include/sys/poll.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef SYS_POLL_H
-#define SYS_POLL_H
-
-typedef int nfds_t;
-
-struct pollfd
-{
-	int fd;
-	short events;
-	short revents;
-};
-
-int poll(struct pollfd fds[], nfds_t nfds, int timeout);
-
-#endif /* SYS_POLL_H */
diff --git a/oslib/asprintf.c b/oslib/asprintf.c
new file mode 100644
index 0000000..f1e7fd2
--- /dev/null
+++ b/oslib/asprintf.c
@@ -0,0 +1,43 @@
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include "oslib/asprintf.h"
+
+#ifndef HAVE_VASPRINTF
+int vasprintf(char **strp, const char *fmt, va_list ap)
+{
+    va_list ap_copy;
+    char *str;
+    int len;
+
+#ifdef va_copy
+    va_copy(ap_copy, ap);
+#else
+    __va_copy(ap_copy, ap);
+#endif
+    len = vsnprintf(NULL, 0, fmt, ap_copy);
+    va_end(ap_copy);
+
+    if (len < 0)
+        return len;
+
+    len++;
+    str = malloc(len);
+    *strp = str;
+    return str ? vsnprintf(str, len, fmt, ap) : -1;
+}
+#endif
+
+#ifndef HAVE_ASPRINTF
+int asprintf(char **strp, const char *fmt, ...)
+{
+    va_list arg;
+    int done;
+
+    va_start(arg, fmt);
+    done = vasprintf(strp, fmt, arg);
+    va_end(arg);
+
+    return done;
+}
+#endif
diff --git a/oslib/asprintf.h b/oslib/asprintf.h
new file mode 100644
index 0000000..1aa076b
--- /dev/null
+++ b/oslib/asprintf.h
@@ -0,0 +1,11 @@
+#ifndef FIO_ASPRINTF_H
+#define FIO_ASPRINTF_H
+
+#ifndef HAVE_VASPRINTF
+int vasprintf(char **strp, const char *fmt, va_list ap);
+#endif
+#ifndef HAVE_ASPRINTF
+int asprintf(char **strp, const char *fmt, ...);
+#endif
+
+#endif /* FIO_ASPRINTF_H */
diff --git a/oslib/strcasestr.c b/oslib/strcasestr.c
index 2626609..5fa05fa 100644
--- a/oslib/strcasestr.c
+++ b/oslib/strcasestr.c
@@ -1,7 +1,8 @@
+#ifndef CONFIG_STRCASESTR
+
 #include <ctype.h>
 #include <stddef.h>
-
-#ifndef CONFIG_STRCASESTR
+#include "strcasestr.h"
 
 char *strcasestr(const char *s1, const char *s2)
 {
diff --git a/oslib/strcasestr.h b/oslib/strcasestr.h
index 43d61df..f13e929 100644
--- a/oslib/strcasestr.h
+++ b/oslib/strcasestr.h
@@ -1,8 +1,4 @@
-#ifdef CONFIG_STRCASESTR
-
-#include <string.h>
-
-#else
+#ifndef CONFIG_STRCASESTR
 
 #ifndef FIO_STRCASESTR_H
 #define FIO_STRCASESTR_H
@@ -10,4 +6,5 @@
 char *strcasestr(const char *haystack, const char *needle);
 
 #endif
+
 #endif
diff --git a/oslib/strlcat.c b/oslib/strlcat.c
index 3b33d0e..6c4c678 100644
--- a/oslib/strlcat.c
+++ b/oslib/strlcat.c
@@ -1,3 +1,5 @@
+#ifndef CONFIG_STRLCAT
+
 #include <string.h>
 #include "strlcat.h"
 
@@ -22,3 +24,5 @@ size_t strlcat(char *dst, const char *src, size_t size)
 
 	return dstlen + srclen;
 }
+
+#endif
diff --git a/oslib/strlcat.h b/oslib/strlcat.h
index baeace4..f766392 100644
--- a/oslib/strlcat.h
+++ b/oslib/strlcat.h
@@ -1,6 +1,12 @@
+#ifndef CONFIG_STRLCAT
+
 #ifndef FIO_STRLCAT_H
 #define FIO_STRLCAT_H
 
+#include <stddef.h>
+
 size_t strlcat(char *dst, const char *src, size_t size);
 
 #endif
+
+#endif
diff --git a/oslib/strndup.c b/oslib/strndup.c
index 7b0fcb5..657904a 100644
--- a/oslib/strndup.c
+++ b/oslib/strndup.c
@@ -1,8 +1,9 @@
+#ifndef CONFIG_HAVE_STRNDUP
+
 #include <stdlib.h>
+#include <string.h>
 #include "strndup.h"
 
-#ifndef CONFIG_HAVE_STRNDUP
-
 char *strndup(const char *s, size_t n)
 {
 	char *str = malloc(n + 1);
diff --git a/oslib/strndup.h b/oslib/strndup.h
index 2cb904d..2f41848 100644
--- a/oslib/strndup.h
+++ b/oslib/strndup.h
@@ -1,7 +1,12 @@
-#include <string.h>
-
 #ifndef CONFIG_HAVE_STRNDUP
 
+#ifndef FIO_STRNDUP_LIB_H
+#define FIO_STRNDUP_LIB_H
+
+#include <stddef.h>
+
 char *strndup(const char *s, size_t n);
 
 #endif
+
+#endif
diff --git a/oslib/strsep.c b/oslib/strsep.c
index b71e9f7..2d42ca0 100644
--- a/oslib/strsep.c
+++ b/oslib/strsep.c
@@ -1,4 +1,7 @@
-#include <stdio.h>
+#ifndef CONFIG_STRSEP
+
+#include <stddef.h>
+#include "strsep.h"
 
 char *strsep(char **stringp, const char *delim)
 {
@@ -27,3 +30,5 @@ char *strsep(char **stringp, const char *delim)
 		} while (sc != 0);
 	} while (1);
 }
+
+#endif
diff --git a/oslib/strsep.h b/oslib/strsep.h
index 5fea5d1..8cd9ada 100644
--- a/oslib/strsep.h
+++ b/oslib/strsep.h
@@ -1,6 +1,10 @@
+#ifndef CONFIG_STRSEP
+
 #ifndef FIO_STRSEP_LIB_H
 #define FIO_STRSEP_LIB_H
 
 char *strsep(char **, const char *);
 
 #endif
+
+#endif
diff --git a/parse.c b/parse.c
index fdb6611..33fcf46 100644
--- a/parse.c
+++ b/parse.c
@@ -3,18 +3,16 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
 #include <ctype.h>
 #include <string.h>
 #include <errno.h>
 #include <limits.h>
-#include <stdlib.h>
-#include <math.h>
 #include <float.h>
 
 #include "compiler/compiler.h"
 #include "parse.h"
 #include "debug.h"
+#include "log.h"
 #include "options.h"
 #include "optgroup.h"
 #include "minmax.h"
diff --git a/server.c b/server.c
index 65d4484..15dc2c4 100644
--- a/server.c
+++ b/server.c
@@ -1,10 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
-#include <stdarg.h>
 #include <unistd.h>
-#include <limits.h>
 #include <errno.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <sys/socket.h>
@@ -25,7 +23,7 @@
 #include "server.h"
 #include "crc/crc16.h"
 #include "lib/ieee754.h"
-#include "verify.h"
+#include "verify-state.h"
 #include "smalloc.h"
 
 int fio_net_port = FIO_NET_PORT;
@@ -528,6 +526,9 @@ static struct sk_entry *fio_net_prep_cmd(uint16_t opcode, void *buf,
 	struct sk_entry *entry;
 
 	entry = smalloc(sizeof(*entry));
+	if (!entry)
+		return NULL;
+
 	INIT_FLIST_HEAD(&entry->next);
 	entry->opcode = opcode;
 	if (flags & SK_F_COPY) {
@@ -616,7 +617,7 @@ static int fio_net_queue_quit(void)
 {
 	dprint(FD_NET, "server: sending quit\n");
 
-	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, NULL, SK_F_SIMPLE | SK_F_INLINE);
+	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, NULL, SK_F_SIMPLE);
 }
 
 int fio_net_send_quit(int sk)
@@ -636,7 +637,7 @@ static int fio_net_send_ack(struct fio_net_cmd *cmd, int error, int signal)
 
 	epdu.error = __cpu_to_le32(error);
 	epdu.signal = __cpu_to_le32(signal);
-	return fio_net_queue_cmd(FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag, SK_F_COPY | SK_F_INLINE);
+	return fio_net_queue_cmd(FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag, SK_F_COPY);
 }
 
 static int fio_net_queue_stop(int error, int signal)
@@ -1359,6 +1360,11 @@ static int accept_loop(int listen_sk)
 		dprint(FD_NET, "server: connect from %s\n", from);
 
 		sk_out = smalloc(sizeof(*sk_out));
+		if (!sk_out) {
+			close(sk);
+			return -1;
+		}
+
 		sk_out->sk = sk;
 		INIT_FLIST_HEAD(&sk_out->list);
 		__fio_sem_init(&sk_out->lock, FIO_SEM_UNLOCKED);
@@ -1695,8 +1701,8 @@ static inline void __fio_net_prep_tail(z_stream *stream, void *out_pdu,
 
 	*last_entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
 				 NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
-	flist_add_tail(&(*last_entry)->list, &first->next);
-
+	if (*last_entry)
+		flist_add_tail(&(*last_entry)->list, &first->next);
 }
 
 /*
@@ -1712,9 +1718,10 @@ static int __deflate_pdu_buffer(void *next_in, unsigned int next_sz, void **out_
 	stream->next_in = next_in;
 	stream->avail_in = next_sz;
 	do {
-		if (! stream->avail_out) {
-
+		if (!stream->avail_out) {
 			__fio_net_prep_tail(stream, *out_pdu, last_entry, first);
+			if (*last_entry == NULL)
+				return 1;
 
 			*out_pdu = malloc(FIO_SERVER_MAX_FRAGMENT_PDU);
 
@@ -1778,8 +1785,7 @@ static int __fio_append_iolog_gz_hist(struct sk_entry *first, struct io_log *log
 	}
 
 	__fio_net_prep_tail(stream, out_pdu, &entry, first);
-
-	return 0;
+	return entry == NULL;
 }
 
 static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
@@ -1818,6 +1824,10 @@ static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
 
 		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
 					 NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
+		if (!entry) {
+			free(out_pdu);
+			return 1;
+		}
 		flist_add_tail(&entry->list, &first->next);
 	} while (stream->avail_in);
 
@@ -1869,6 +1879,10 @@ static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
 
 		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
 					 NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
+		if (!entry) {
+			free(out_pdu);
+			break;
+		}
 		flist_add_tail(&entry->list, &first->next);
 	} while (ret != Z_STREAM_END);
 
@@ -1889,6 +1903,7 @@ static int fio_append_gz_chunks(struct sk_entry *first, struct io_log *log)
 {
 	struct sk_entry *entry;
 	struct flist_head *node;
+	int ret = 0;
 
 	pthread_mutex_lock(&log->chunk_lock);
 	flist_for_each(node, &log->chunk_list) {
@@ -1897,16 +1912,20 @@ static int fio_append_gz_chunks(struct sk_entry *first, struct io_log *log)
 		c = flist_entry(node, struct iolog_compress, list);
 		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, c->buf, c->len,
 						NULL, SK_F_VEC | SK_F_INLINE);
+		if (!entry) {
+			ret = 1;
+			break;
+		}
 		flist_add_tail(&entry->list, &first->next);
 	}
 	pthread_mutex_unlock(&log->chunk_lock);
-
-	return 0;
+	return ret;
 }
 
 static int fio_append_text_log(struct sk_entry *first, struct io_log *log)
 {
 	struct sk_entry *entry;
+	int ret = 0;
 
 	while (!flist_empty(&log->io_logs)) {
 		struct io_logs *cur_log;
@@ -1919,10 +1938,14 @@ static int fio_append_text_log(struct sk_entry *first, struct io_log *log)
 
 		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, cur_log->log, size,
 						NULL, SK_F_VEC | SK_F_INLINE);
+		if (!entry) {
+			ret = 1;
+			break;
+		}
 		flist_add_tail(&entry->list, &first->next);
 	}
 
-	return 0;
+	return ret;
 }
 
 int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
@@ -1977,6 +2000,8 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	 * Assemble header entry first
 	 */
 	first = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, &pdu, sizeof(pdu), NULL, SK_F_VEC | SK_F_INLINE | SK_F_COPY);
+	if (!first)
+		return 1;
 
 	/*
 	 * Now append actual log entries. If log compression was enabled on
diff --git a/server.h b/server.h
index d652d31..1eee7dc 100644
--- a/server.h
+++ b/server.h
@@ -7,7 +7,6 @@
 #include <netinet/in.h>
 
 #include "stat.h"
-#include "os/os.h"
 #include "diskutil.h"
 
 #define FIO_NET_PORT 8765
@@ -217,8 +216,6 @@ extern int fio_server_parse_host(const char *, int, struct in_addr *, struct in6
 extern const char *fio_server_op(unsigned int);
 extern void fio_server_got_signal(int);
 
-struct thread_stat;
-struct group_run_stats;
 extern void fio_server_send_ts(struct thread_stat *, struct group_run_stats *);
 extern void fio_server_send_gs(struct group_run_stats *);
 extern void fio_server_send_du(void);
diff --git a/smalloc.c b/smalloc.c
index 13995ac..7b1690a 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -3,15 +3,8 @@
  * that can be shared across processes and threads
  */
 #include <sys/mman.h>
-#include <stdio.h>
-#include <stdlib.h>
 #include <assert.h>
 #include <string.h>
-#include <unistd.h>
-#include <inttypes.h>
-#include <sys/types.h>
-#include <limits.h>
-#include <fcntl.h>
 #ifdef CONFIG_VALGRIND_DEV
 #include <valgrind/valgrind.h>
 #else
@@ -22,7 +15,6 @@
 
 #include "fio.h"
 #include "fio_sem.h"
-#include "arch/arch.h"
 #include "os/os.h"
 #include "smalloc.h"
 #include "log.h"
diff --git a/smalloc.h b/smalloc.h
index 4b551e3..8df10e6 100644
--- a/smalloc.h
+++ b/smalloc.h
@@ -1,6 +1,8 @@
 #ifndef FIO_SMALLOC_H
 #define FIO_SMALLOC_H
 
+#include <stddef.h>
+
 extern void *smalloc(size_t);
 extern void *scalloc(size_t, size_t);
 extern void sfree(void *);
diff --git a/stat.c b/stat.c
index 98ab638..a837ed9 100644
--- a/stat.c
+++ b/stat.c
@@ -1,10 +1,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <sys/time.h>
-#include <sys/types.h>
 #include <sys/stat.h>
-#include <dirent.h>
-#include <libgen.h>
 #include <math.h>
 
 #include "fio.h"
diff --git a/steadystate.c b/steadystate.c
index 2017ca6..1e3a546 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -2,7 +2,6 @@
 
 #include "fio.h"
 #include "steadystate.h"
-#include "helper_thread.h"
 
 bool steadystate_enabled = false;
 
diff --git a/steadystate.h b/steadystate.h
index 9fd88ee..51472c4 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -1,9 +1,7 @@
 #ifndef FIO_STEADYSTATE_H
 #define FIO_STEADYSTATE_H
 
-#include "stat.h"
 #include "thread_options.h"
-#include "lib/ieee754.h"
 
 extern void steadystate_free(struct thread_data *);
 extern void steadystate_check(void);
diff --git a/t/axmap.c b/t/axmap.c
index a803ce4..eef464f 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -1,8 +1,5 @@
 #include <stdio.h>
 #include <stdlib.h>
-#include <fcntl.h>
-#include <string.h>
-#include <unistd.h>
 #include <inttypes.h>
 
 #include "../lib/lfsr.h"
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index 4cdb38d..a8a9d62 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -1,5 +1,4 @@
 #include <stdio.h>
-#include <stdio.h>
 #include <unistd.h>
 #include <inttypes.h>
 #include <math.h>
@@ -12,6 +11,7 @@
 #include "../blktrace_api.h"
 #include "../os/os.h"
 #include "../log.h"
+#include "../minmax.h"
 #include "../oslib/linux-dev-lookup.h"
 
 #define TRACE_FIFO_SIZE	8192
diff --git a/t/dedupe.c b/t/dedupe.c
index 1b4277c..37120e1 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -3,16 +3,12 @@
  * just scans the filename for extents of the given size, checksums them,
  * and orders them up.
  */
+#include <fcntl.h>
+#include <inttypes.h>
 #include <stdio.h>
-#include <stdio.h>
+#include <string.h>
 #include <unistd.h>
-#include <inttypes.h>
-#include <assert.h>
-#include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/ioctl.h>
-#include <fcntl.h>
-#include <string.h>
 
 #include "../flist.h"
 #include "../log.h"
diff --git a/t/gen-rand.c b/t/gen-rand.c
index 4e9d39c..c379053 100644
--- a/t/gen-rand.c
+++ b/t/gen-rand.c
@@ -1,17 +1,11 @@
+#include <math.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <inttypes.h>
-#include <assert.h>
-#include <math.h>
-#include <string.h>
 
 #include "../lib/types.h"
-#include "../log.h"
-#include "../lib/lfsr.h"
-#include "../lib/axmap.h"
-#include "../smalloc.h"
-#include "../minmax.h"
 #include "../lib/rand.h"
+#include "../log.h"
 
 int main(int argc, char *argv[])
 {
diff --git a/t/genzipf.c b/t/genzipf.c
index 9faec38..4fc10ae 100644
--- a/t/genzipf.c
+++ b/t/genzipf.c
@@ -14,7 +14,6 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <fcntl.h>
 #include <string.h>
 #include <unistd.h>
 
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 4009b62..abdbafb 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -1,11 +1,7 @@
 #include <stdio.h>
 #include <stdlib.h>
-#include <time.h>
 #include <math.h>
 #include <string.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/stat.h>
 
 #include "../lib/lfsr.h"
 #include "../gettime.h"
diff --git a/td_error.h b/td_error.h
index 1b38a53..1cc3a75 100644
--- a/td_error.h
+++ b/td_error.h
@@ -1,6 +1,8 @@
 #ifndef FIO_TD_ERROR_H
 #define FIO_TD_ERROR_H
 
+#include "io_ddir.h"
+
 /*
  * What type of errors to continue on when continue_on_error is used,
  * and what type of errors to ignore when ignore_error is used.
diff --git a/trim.c b/trim.c
index 78cf672..bf825db 100644
--- a/trim.c
+++ b/trim.c
@@ -1,11 +1,8 @@
 /*
  * TRIM/DISCARD support
  */
-#include <unistd.h>
-#include <fcntl.h>
 #include <string.h>
 #include <assert.h>
-#include <pthread.h>
 
 #include "fio.h"
 #include "trim.h"
diff --git a/trim.h b/trim.h
index 37f5d7c..fe8f9fe 100644
--- a/trim.h
+++ b/trim.h
@@ -1,9 +1,13 @@
 #ifndef FIO_TRIM_H
 #define FIO_TRIM_H
 
-#include "fio.h"
-
 #ifdef FIO_HAVE_TRIM
+#include "flist.h"
+#include "iolog.h"
+#include "compiler/compiler.h"
+#include "lib/types.h"
+#include "os/os.h"
+
 extern bool __must_check get_next_trim(struct thread_data *td, struct io_u *io_u);
 extern bool io_u_should_trim(struct thread_data *td, struct io_u *io_u);
 
diff --git a/verify.c b/verify.c
index d10670b..c5fa241 100644
--- a/verify.c
+++ b/verify.c
@@ -245,33 +245,23 @@ struct vcont {
 static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 		     const char *type, struct fio_file *f)
 {
-	char *ptr, fname[DUMP_BUF_SZ];
-	size_t buf_left = DUMP_BUF_SZ;
+	char *ptr, *fname;
+	char sep[2] = { FIO_OS_PATH_SEPARATOR, 0 };
 	int ret, fd;
 
 	ptr = strdup(f->file_name);
 
-	memset(fname, 0, sizeof(fname));
-	if (aux_path)
-		sprintf(fname, "%s%c", aux_path, FIO_OS_PATH_SEPARATOR);
-
-	strncpy(fname + strlen(fname), basename(ptr), buf_left - 1);
-
-	buf_left -= strlen(fname);
-	if (buf_left <= 0) {
+	if (asprintf(&fname, "%s%s%s.%llu.%s", aux_path ? : "",
+		     aux_path ? sep : "", basename(ptr), offset, type) < 0) {
 		if (!fio_did_warn(FIO_WARN_VERIFY_BUF))
-			log_err("fio: verify failure dump buffer too small\n");
-		free(ptr);
-		return;
+			log_err("fio: not enough memory for dump buffer filename\n");
+		goto free_ptr;
 	}
 
-	snprintf(fname + strlen(fname), buf_left, ".%llu.%s", offset, type);
-
 	fd = open(fname, O_CREAT | O_TRUNC | O_WRONLY, 0644);
 	if (fd < 0) {
 		perror("open verify buf file");
-		free(ptr);
-		return;
+		goto free_fname;
 	}
 
 	while (len) {
@@ -288,6 +278,11 @@ static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 
 	close(fd);
 	log_err("       %s data dumped as %s\n", type, fname);
+
+free_fname:
+	free(fname);
+
+free_ptr:
 	free(ptr);
 }
 
diff --git a/verify.h b/verify.h
index 321e648..64121a5 100644
--- a/verify.h
+++ b/verify.h
@@ -2,6 +2,7 @@
 #define FIO_VERIFY_H
 
 #include <stdint.h>
+#include "compiler/compiler.h"
 #include "verify-state.h"
 
 #define FIO_HDR_MAGIC	0xacca
diff --git a/workqueue.h b/workqueue.h
index e35c181..0a62b5f 100644
--- a/workqueue.h
+++ b/workqueue.h
@@ -1,7 +1,14 @@
 #ifndef FIO_RATE_H
 #define FIO_RATE_H
 
+#include <inttypes.h>
+#include <pthread.h>
+
 #include "flist.h"
+#include "lib/types.h"
+
+struct sk_out;
+struct thread_data;
 
 struct workqueue_work {
 	struct flist_head list;
