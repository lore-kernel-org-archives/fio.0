Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test: results from adding sse and avx tests
From: Jens Axboe <axboe@kernel.dk>
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk>
 <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
 <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk>
 <4bcbe8f2-4460-c0ed-d15d-4d994a9fa6cb@kernel.dk>
 <CALjAwxiiuKXqd-YVWhdBoSuMvpVCFQt5BwjRdf-9RKGBxkV6fQ@mail.gmail.com>
 <5181032d-5f85-5b65-66c6-5621b1582323@kernel.dk>
Message-ID: <9e47c711-7101-85ad-3208-eb21dd0d12a9@kernel.dk>
Date: Tue, 6 Mar 2018 10:02:54 -0700
MIME-Version: 1.0
In-Reply-To: <5181032d-5f85-5b65-66c6-5621b1582323@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/6/18 9:45 AM, Jens Axboe wrote:
> On 3/6/18 9:43 AM, Sitsofe Wheeler wrote:
>> On 6 March 2018 at 16:22, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> +##########################################
>>> +# sse probe
>>> +sse="no"
>>> +cat > $TMPC << EOF
>>> +#include <xmmintrin.h>
>>> +#include <immintrin.h>
>>> +int main(int argc, char **argv)
>>> +{
>>> +  __m128 val;
>>> +  float const *src = NULL;
>>> +  float *dst = NULL;
>>> +  val = _mm_load_ps(src);
>>> +  _mm_store_ps(dst, val);
>>> +  return 0;
>>> +}
>>> +EOF
>>> +if compile_prog "-msse" "" "sse"; then
>>> +  sse="yes"
>>> +fi
>>> +print_config "SSE (compiler)" "$sse"
>>
>> According to https://stackoverflow.com/questions/28939652/how-to-detect-sse-sse2-avx-avx2-avx-512-avx-128-fma-kcvi-availability-at-compile/28939692#28939692
>> in gcc and clang you can just check for the appropriate define (e.g.
>> __SSE2__ ) if you're only interested in what's available at compile
>> time...
> 
> I never really trust that, since there are always cases where that
> isn't true. A configure test with the meat of the code and types
> is always going to be 100% reliable.

BTW, another (and probably more problematic) issue is that the
compiler may well have support for sse/avx/avx512, while the
machine it's run on does not. If we enable the instruction set
based on that, we could be seeing illegal instructions outside
just the memcpy test. And that would be a concern, since it would
prevent fio from running at all.

I think we have to make it something like the below because of that.

diff --git a/Makefile b/Makefile
index c25b4222e437..26301e2dbf71 100644
--- a/Makefile
+++ b/Makefile
@@ -28,6 +28,16 @@ LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/fio_jsonplus_clat2csv)
 
+ifdef CONFIG_HAVE_SSE
+CFLAGS	+= -msse
+endif
+ifdef CONFIG_HAVE_AVX
+CFLAGS	+= -mavx
+endif
+ifdef CONFIG_HAVE_AVX512
+CFLAGS	+= -mavx512f
+endif
+
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
diff --git a/configure b/configure
index 2e8eb180ef50..c82331a8160b 100755
--- a/configure
+++ b/configure
@@ -145,6 +145,8 @@ devdax="no"
 pmem="no"
 disable_lex=""
 disable_pmem="no"
+enable_sse="no"
+enable_avx="no"
 prefix=/usr/local
 
 # parse options
@@ -195,6 +197,12 @@ for opt do
   ;;
   --enable-cuda) enable_cuda="yes"
   ;;
+  --enable-sse) enable_sse="yes"
+  ;;
+  --enable-avx) enable_avx="yes"
+  ;;
+  --enable-avx512) enable_avx512="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -224,6 +232,9 @@ if test "$show_help" = "yes" ; then
   echo "--disable-shm           Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
   echo "--enable-cuda           Enable GPUDirect RDMA support"
+  echo "--enable-sse            Enable SSE"
+  echo "--enable-avx            Enable AVX"
+  echo "--enable-avx512         Enable AVX512"
   exit $exit_val
 fi
 
@@ -2131,6 +2142,69 @@ if compile_prog "" "" "mkdir(a, b)"; then
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
+if test "$enable_sse" = "yes" && compile_prog "-msse" "" "sse"; then
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
+if test "$enable_avx" = "yes" && compile_prog "-mavx" "" "avx"; then
+  avx="yes"
+fi
+print_config "AVX (compiler)" "$avx"
+
+##########################################
+# avx512 probe
+avx512="no"
+cat > $TMPC << EOF
+#include <xmmintrin.h>
+#include <immintrin.h>
+int main(int argc, char **argv)
+{
+  __m512 val;
+  float const *src = NULL;
+  float *dst = NULL;
+  val = _mm512_load_ps(src);
+  _mm512_store_ps(dst, val);
+  return 0;
+}
+EOF
+if test "$enable_avx512" = "yes" && compile_prog "-mavx512f" "" "avx512"; then
+  avx512="yes"
+fi
+print_config "AVX512 (compiler)" "$avx512"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2377,6 +2451,15 @@ fi
 if test "$mkdir_two" = "yes" ; then
   output_sym "CONFIG_HAVE_MKDIR_TWO"
 fi
+if test "$sse" = "yes" ; then
+  output_sym "CONFIG_HAVE_SSE"
+fi
+if test "$avx" = "yes" ; then
+  output_sym "CONFIG_HAVE_AVX"
+fi
+if test "$avx512" = "yes" ; then
+  output_sym "CONFIG_HAVE_AVX512"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/lib/memcpy.c b/lib/memcpy.c
index 00e65aa7d50a..bb3e579baf9d 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -2,9 +2,15 @@
 #include <stdlib.h>
 #include <string.h>
 
+#if defined(CONFIG_HAVE_SSE) || defined(CONFIG_HAVE_AVX) || defined(CONFIG_HAVE_AVX512)
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
 
@@ -80,6 +86,15 @@ enum {
 	T_MEMMOVE	= 1U << 1,
 	T_SIMPLE	= 1U << 2,
 	T_HYBRID	= 1U << 3,
+#if defined(CONFIG_HAVE_SSE)
+	T_SSE		= 1U << 4,
+#endif
+#if defined(CONFIG_HAVE_AVX)
+	T_AVX		= 1U << 5,
+#endif
+#if defined(CONFIG_HAVE_AVX512)
+	T_AVX512	= 1U << 6,
+#endif
 };
 
 #define do_test(test, fn)	do {					\
@@ -122,6 +137,66 @@ static void simple_memcpy(void *dst, void const *src, size_t len)
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
+#if defined(CONFIG_HAVE_AVX512)
+static void avx512_memcpy(void *dst, void const *src, size_t len)
+{
+	__m512 val;
+	float *d = dst;
+	float const *s = src;
+	int i;
+
+	if (len < sizeof(__m512))
+		return;
+
+	for (i = 0; i < len; i += sizeof(__m512)) {
+		val = _mm512_load_ps(s);
+		_mm512_store_ps(d, val);
+		d += sizeof(__m512) / sizeof(float);
+		s += sizeof(__m512) / sizeof(float);
+	}
+}
+#endif
+
 static void t_simple(struct memcpy_test *test)
 {
 	do_test(test, simple_memcpy);
@@ -135,6 +210,27 @@ static void t_hybrid(struct memcpy_test *test)
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
+#if defined(CONFIG_HAVE_AVX512)
+static void t_avx512(struct memcpy_test *test)
+{
+	do_test(test, avx512_memcpy);
+}
+#endif
+
 static struct memcpy_type t[] = {
 	{
 		.name = "memcpy",
@@ -156,6 +252,27 @@ static struct memcpy_type t[] = {
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
+#if defined(CONFIG_HAVE_AVX512)
+	{
+		.name = "avx512",
+		.mask = T_AVX512,
+		.fn = t_avx512,
+	},
+#endif
 	{
 		.name = NULL,
 	},
@@ -200,8 +317,8 @@ static int setup_tests(void)
 	void *src, *dst;
 	int i;
 
-	src = malloc(BUF_SIZE);
-	dst = malloc(BUF_SIZE);
+	src = fio_memalign(64, BUF_SIZE);
+	dst = fio_memalign(64, BUF_SIZE);
 	if (!src || !dst) {
 		free(src);
 		free(dst);
@@ -222,8 +339,8 @@ static int setup_tests(void)
 
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


