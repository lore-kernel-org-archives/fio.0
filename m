Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test: results from adding sse and avx tests
From: Jens Axboe <axboe@kernel.dk>
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk>
 <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
 <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk>
Message-ID: <4bcbe8f2-4460-c0ed-d15d-4d994a9fa6cb@kernel.dk>
Date: Tue, 6 Mar 2018 09:22:30 -0700
MIME-Version: 1.0
In-Reply-To: <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/5/18 10:22 PM, Jens Axboe wrote:
> On 1/18/18 1:36 PM, Rebecca Cran wrote:
>> On 01/18/2018 10:47 AM, Jens Axboe wrote:
>>>
>>> Adding the memcpy for avx/sse to the test case might be interesting
>>> though, just to be able to compare performances with builtin
>>> memcpy/memmove on a given system.
>>
>> I've attached the patch. I think it should work on all Intel systems 
>> newer than 2012. It causes a segfault on my Atom E3826 (Baytrail) 
>> because it doesn't support AVX.
>>
>> I've tested it using Clang 3.8, GCC 4.8 and 7.x on openSUSE, and Clang 
>> 4.0 on FreeBSD 11.1.
> 
> I'm worried that this will break some platforms. A few comments that
> might help rectify that:
> 
> 1) Use fio_memalign() instead of relying on a c11 function
> 2) Add a configure check for the avx and sse, separately.
>    This includes -msse for the compiler, includes for the
>     xmm/imm intrinsics, etc.
> 
> I don't care if it segfaults if avx/sse isn't there, but I don't
> want to risk failing a build on some rarely tested platform, just
> to have this as part of the memcpy test. The risk/reward just
> isn't there then.

Something like the below. It fixes up the two above points, and also
corrects some style and declaring 'int i' within the for-loop.


diff --git a/Makefile b/Makefile
index c25b4222e437..1f5cb429f2ef 100644
--- a/Makefile
+++ b/Makefile
@@ -28,6 +28,13 @@ LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/fio_jsonplus_clat2csv)
 
+ifdef CONFIG_HAVE_SSE
+CFLAGS	+= -msse
+endif
+ifdef CONFIG_HAVE_AVX
+CFLAGS	+= -mavx
+endif
+
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
diff --git a/configure b/configure
index 2e8eb180ef50..61ed3d6d1f1b 100755
--- a/configure
+++ b/configure
@@ -2131,6 +2131,48 @@ if compile_prog "" "" "mkdir(a, b)"; then
 fi
 print_config "mkdir(a, b)" "$mkdir_two"
 
+##########################################
+# sse probe
+sse="no"
+cat > $TMPC << EOF
+#include <xmmintrin.h>
+#include <immintrin.h>
+int main(int argc, char **argv)
+{
+  __m128 val;
+  float const *src = NULL;
+  float *dst = NULL;
+  val = _mm_load_ps(src);
+  _mm_store_ps(dst, val);
+  return 0;
+}
+EOF
+if compile_prog "-msse" "" "sse"; then
+  sse="yes"
+fi
+print_config "SSE (compiler)" "$sse"
+
+##########################################
+# avx probe
+avx="no"
+cat > $TMPC << EOF
+#include <xmmintrin.h>
+#include <immintrin.h>
+int main(int argc, char **argv)
+{
+  __m256 val;
+  float const *src = NULL;
+  float *dst = NULL;
+  val = _mm256_load_ps(src);
+  _mm256_store_ps(dst, val);
+  return 0;
+}
+EOF
+if compile_prog "-mavx" "" "avx"; then
+  avx="yes"
+fi
+print_config "AVX (compiler)" "$avx"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2377,6 +2419,12 @@ fi
 if test "$mkdir_two" = "yes" ; then
   output_sym "CONFIG_HAVE_MKDIR_TWO"
 fi
+if test "$sse" = "yes" ; then
+  output_sym "CONFIG_HAVE_SSE"
+fi
+if test "$avx" = "yes" ; then
+  output_sym "CONFIG_HAVE_AVX"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/lib/memcpy.c b/lib/memcpy.c
index 00e65aa7d50a..b978a1197fd2 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -2,9 +2,15 @@
 #include <stdlib.h>
 #include <string.h>
 
+#if defined(CONFIG_HAVE_SSE) || defined(CONFIG_HAVE_AVX)
+#include <xmmintrin.h>
+#include <immintrin.h>
+#endif
+
 #include "memcpy.h"
 #include "rand.h"
 #include "../fio_time.h"
+#include "../lib/memalign.h"
 #include "../gettime.h"
 #include "../fio.h"
 
@@ -80,6 +86,12 @@ enum {
 	T_MEMMOVE	= 1U << 1,
 	T_SIMPLE	= 1U << 2,
 	T_HYBRID	= 1U << 3,
+#if defined(CONFIG_HAVE_SSE)
+	T_SSE		= 1U << 4,
+#endif
+#if defined(CONFIG_HAVE_AVX)
+	T_AVX		= 1U << 5,
+#endif
 };
 
 #define do_test(test, fn)	do {					\
@@ -122,6 +134,46 @@ static void simple_memcpy(void *dst, void const *src, size_t len)
 		*d++ = *s++;
 }
 
+#if defined(CONFIG_HAVE_SSE)
+static void sse_memcpy(void *dst, void const *src, size_t len)
+{
+	__m128 val;
+	float *d = dst;
+	float const *s = src;
+	int i;
+
+	if (len < sizeof(__m128))
+		return;
+
+	for (i = 0; i < len; i += sizeof(__m128)) {
+		val = _mm_load_ps(s);
+		_mm_store_ps(d, val);
+		d += sizeof(__m128) / sizeof(float);
+		s += sizeof(__m128) / sizeof(float);
+	}
+}
+#endif
+
+#if defined(CONFIG_HAVE_AVX)
+static void avx_memcpy(void *dst, void const *src, size_t len)
+{
+	__m256 val;
+	float *d = dst;
+	float const *s = src;
+	int i;
+
+	if (len < sizeof(__m256))
+		return;
+
+	for (i = 0; i < len; i += sizeof(__m256)) {
+		val = _mm256_load_ps(s);
+		_mm256_store_ps(d, val);
+		d += sizeof(__m256) / sizeof(float);
+		s += sizeof(__m256) / sizeof(float);
+	}
+}
+#endif
+
 static void t_simple(struct memcpy_test *test)
 {
 	do_test(test, simple_memcpy);
@@ -135,6 +187,20 @@ static void t_hybrid(struct memcpy_test *test)
 		do_test(test, memcpy);
 }
 
+#if defined(CONFIG_HAVE_SSE)
+static void t_sse(struct memcpy_test *test)
+{
+	do_test(test, sse_memcpy);
+}
+#endif
+
+#if defined(CONFIG_HAVE_AVX)
+static void t_avx(struct memcpy_test *test)
+{
+	do_test(test, avx_memcpy);
+}
+#endif
+
 static struct memcpy_type t[] = {
 	{
 		.name = "memcpy",
@@ -156,6 +222,20 @@ static struct memcpy_type t[] = {
 		.mask = T_HYBRID,
 		.fn = t_hybrid,
 	},
+#if defined(CONFIG_HAVE_SSE)
+	{
+		.name = "sse",
+		.mask = T_SSE,
+		.fn = t_sse,
+	},
+#endif
+#if defined(CONFIG_HAVE_AVX)
+	{
+		.name = "avx",
+		.mask = T_AVX,
+		.fn = t_avx,
+	},
+#endif
 	{
 		.name = NULL,
 	},
@@ -200,8 +280,8 @@ static int setup_tests(void)
 	void *src, *dst;
 	int i;
 
-	src = malloc(BUF_SIZE);
-	dst = malloc(BUF_SIZE);
+	src = fio_memalign(64, BUF_SIZE);
+	dst = fio_memalign(64, BUF_SIZE);
 	if (!src || !dst) {
 		free(src);
 		free(dst);
@@ -222,8 +302,8 @@ static int setup_tests(void)
 
 static void free_tests(void)
 {
-	free(tests[0].src);
-	free(tests[0].dst);
+	fio_memfree(tests[0].src, BUF_SIZE);
+	fio_memfree(tests[0].dst, BUF_SIZE);
 }
 
 int fio_memcpy_test(const char *type)

-- 
Jens Axboe


