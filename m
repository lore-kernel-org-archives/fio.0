Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/8] Make lib/num2str.c a stand-alone library by adding lib/num2str.h
Date: Tue,  4 Apr 2017 23:22:16 +0300
Message-Id: <20170404202218.52260-6-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

lib/num2str.c not having dependency on fio.h by adding a new header
lib/num2str.h enables it to be a stand-alone library function, which
is useful for debugging purpose. In fact, most of the files under
lib/ directory do things this way.

--
 # cat ./test1.c
 #include <stdio.h>
 #include "lib/num2str.h"
 int main(void) {
         printf("%s\n", num2str(1024, 4, 1, 1, N2S_BYTE));
         return 0;
 }
 # gcc -Wall -g -DCONFIG_STATIC_ASSERT ./test1.c ./lib/num2str.c
 # ./a.out
 1024B

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.h         |  9 +--------
 lib/num2str.c |  7 +++++--
 lib/num2str.h | 15 +++++++++++++++
 3 files changed, 21 insertions(+), 10 deletions(-)
 create mode 100644 lib/num2str.h

diff --git a/fio.h b/fio.h
index 3955a81..2975076 100644
--- a/fio.h
+++ b/fio.h
@@ -35,6 +35,7 @@
 #include "oslib/getopt.h"
 #include "lib/rand.h"
 #include "lib/rbtree.h"
+#include "lib/num2str.h"
 #include "client.h"
 #include "server.h"
 #include "stat.h"
@@ -520,7 +521,6 @@ extern void fio_options_mem_dupe(struct thread_data *);
 extern void td_fill_rand_seeds(struct thread_data *);
 extern void td_fill_verify_state_seed(struct thread_data *);
 extern void add_job_opts(const char **, int);
-extern char *num2str(uint64_t, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
 extern bool parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
@@ -533,13 +533,6 @@ extern uintptr_t page_size;
 extern int initialize_fio(char *envp[]);
 extern void deinitialize_fio(void);
 
-#define N2S_NONE	0
-#define N2S_BITPERSEC 	1	/* match unit_base for bit rates */
-#define N2S_PERSEC	2
-#define N2S_BIT		3
-#define N2S_BYTE	4
-#define N2S_BYTEPERSEC 	8	/* match unit_base for byte rates */
-
 #define FIO_GETOPT_JOB		0x89000000
 #define FIO_GETOPT_IOENGINE	0x98000000
 #define FIO_NR_OPTIONS		(FIO_MAX_OPTS + 128)
diff --git a/lib/num2str.c b/lib/num2str.c
index ed3545d..2f714cc 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -2,7 +2,10 @@
 #include <stdio.h>
 #include <string.h>
 
-#include "../fio.h"
+#include "../compiler/compiler.h"
+#include "num2str.h"
+
+#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
 
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
@@ -10,7 +13,7 @@
  * @maxlen: max number of digits in the output string (not counting prefix and units)
  * @base: multiplier for num (e.g., if num represents Ki, use 1024)
  * @pow2: select unit prefix - 0=power-of-10 decimal SI, nonzero=power-of-2 binary IEC
- * @units: select units - N2S_* macros defined in fio.h
+ * @units: select units - N2S_* macros defined in num2str.h
  * @returns a malloc'd buffer containing "number[<unit prefix>][<units>]"
  */
 char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
diff --git a/lib/num2str.h b/lib/num2str.h
new file mode 100644
index 0000000..81358a1
--- /dev/null
+++ b/lib/num2str.h
@@ -0,0 +1,15 @@
+#ifndef FIO_NUM2STR_H
+#define FIO_NUM2STR_H
+
+#include <inttypes.h>
+
+#define N2S_NONE	0
+#define N2S_BITPERSEC	1	/* match unit_base for bit rates */
+#define N2S_PERSEC	2
+#define N2S_BIT		3
+#define N2S_BYTE	4
+#define N2S_BYTEPERSEC	8	/* match unit_base for byte rates */
+
+extern char *num2str(uint64_t, int, int, int, int);
+
+#endif
-- 
2.9.3


