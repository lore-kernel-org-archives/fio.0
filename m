Return-Path: <prvs=60033e2b9=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] smalloc: Disable if running on Valgrind
Date: Fri,  9 Mar 2018 16:45:06 -0800
Message-Id: <20180310004506.5642-1-bart.vanassche@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

The Valgrind memory checker can only detect uninitialized reads and
out-of-bounds writes if it knows about the dynamic memory allocation
calls performed by an application. There are two ways to inform
Valgrind about the sfree(), smalloc() and scalloc() calls:
* Call the glibc equivalents if running on Valgrind.
* By using the Valgrind memory pool client requests. See also
  http://valgrind.org/docs/manual/mc-manual.html#mc-manual.mempools.

Since the former approach is the easiest to implement, follow that
approach.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 configure | 19 +++++++++++++++++++
 smalloc.c | 20 ++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/configure b/configure
index aefd5bb08c05..c8de3cd26759 100755
--- a/configure
+++ b/configure
@@ -2048,6 +2048,25 @@ fi
 print_config "strndup" "$strndup"
 
 ##########################################
+# <valgrind/valgrind.h> probe
+if test "$valgrind/valgrind_h" != "yes" ; then
+  valgrind_valgrind_h="no"
+fi
+cat > $TMPC << EOF
+#include <valgrind/valgrind.h>
+int main(int argc, char **argv)
+{
+  return 0;
+}
+EOF
+if compile_prog "" "" "valgrind_valgrind_h"; then
+  valgrind_valgrind_h="yes"
+fi
+print_config "<valgrind/valgrind.h>" "$valgrind_valgrind_h"
+if test "$valgrind_valgrind_h" = "yes" ; then
+  output_sym "HAVE_VALGRIND_VALGRIND_H"
+fi
+
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
   march_armv8_a_crc_crypto="no"
diff --git a/smalloc.c b/smalloc.c
index cab7132511b1..128443666ea3 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -12,6 +12,12 @@
 #include <sys/types.h>
 #include <limits.h>
 #include <fcntl.h>
+#include "config-host.h"
+#ifdef HAVE_VALGRIND_VALGRIND_H
+#include <valgrind/valgrind.h>
+#else
+#define RUNNING_ON_VALGRIND 0
+#endif
 
 #include "fio.h"
 #include "mutex.h"
@@ -325,6 +331,11 @@ void sfree(void *ptr)
 	if (!ptr)
 		return;
 
+	if (RUNNING_ON_VALGRIND) {
+		free(ptr);
+		return;
+	}
+
 	for (i = 0; i < nr_pools; i++) {
 		if (ptr_valid(&mp[i], ptr)) {
 			pool = &mp[i];
@@ -427,6 +438,9 @@ void *smalloc(size_t size)
 {
 	unsigned int i, end_pool;
 
+	if (RUNNING_ON_VALGRIND)
+		return malloc(size);
+
 	if (size != (unsigned int) size)
 		return NULL;
 
@@ -458,6 +472,9 @@ void *smalloc(size_t size)
 
 void *scalloc(size_t nmemb, size_t size)
 {
+	if (RUNNING_ON_VALGRIND)
+		return calloc(nmemb, size);
+
 	return smalloc(nmemb * size);
 }
 
@@ -465,6 +482,9 @@ char *smalloc_strdup(const char *str)
 {
 	char *ptr = NULL;
 
+	if (RUNNING_ON_VALGRIND)
+		return strdup(str);
+
 	ptr = smalloc(strlen(str) + 1);
 	if (ptr)
 		strcpy(ptr, str);
-- 
2.16.2


