Return-Path: <rebecca@bluestop.org>
Subject: Re: memcpy test: results from adding sse and avx tests
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
Date: Thu, 18 Jan 2018 13:36:36 -0700
MIME-Version: 1.0
In-Reply-To: <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------9C75A3BC47705DEC8EECD540"
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------9C75A3BC47705DEC8EECD540
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/18/2018 10:47 AM, Jens Axboe wrote:
>
> Adding the memcpy for avx/sse to the test case might be interesting
> though, just to be able to compare performances with builtin
> memcpy/memmove on a given system.

I've attached the patch. I think it should work on all Intel systems 
newer than 2012. It causes a segfault on my Atom E3826 (Baytrail) 
because it doesn't support AVX.

I've tested it using Clang 3.8, GCC 4.8 and 7.x on openSUSE, and Clang 
4.0 on FreeBSD 11.1.


-- 
Rebecca


--------------9C75A3BC47705DEC8EECD540
Content-Type: text/x-patch;
 name="0001-Add-SSE-and-AVX-tests-to-lib-memcpy.c-and-add-msse-a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Add-SSE-and-AVX-tests-to-lib-memcpy.c-and-add-msse-a.pa";
 filename*1="tch"

From f9fa5d6fc83d5d924ac2cf9532d51a3b1d81c9ff Mon Sep 17 00:00:00 2001
From: Rebecca Cran <rebecca@bluestop.org>
Date: Thu, 18 Jan 2018 12:07:11 -0700
Subject: [PATCH] Add SSE and AVX tests to lib/memcpy.c and add -msse and -mavx
 to compiler flags

---
 Makefile     |  2 +-
 lib/memcpy.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 3ce60646..4e32f269 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@ endif
 DEBUGFLAGS = -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
-CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
+CFLAGS	= -msse -mavx -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/fio_jsonplus_clat2csv)
diff --git a/lib/memcpy.c b/lib/memcpy.c
index 00e65aa7..1fb22dad 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <xmmintrin.h>
+#include <immintrin.h>
 
 #include "memcpy.h"
 #include "rand.h"
@@ -80,6 +82,8 @@ enum {
 	T_MEMMOVE	= 1U << 1,
 	T_SIMPLE	= 1U << 2,
 	T_HYBRID	= 1U << 3,
+	T_SSE		= 1U << 4,
+	T_AVX		= 1U << 5,
 };
 
 #define do_test(test, fn)	do {					\
@@ -122,6 +126,43 @@ static void simple_memcpy(void *dst, void const *src, size_t len)
 		*d++ = *s++;
 }
 
+static void sse_memcpy(void *dst, void const *src, size_t len)
+{
+	__m128 val;
+	float *d = dst;
+	float const *s = src;
+
+	if (len < sizeof(__m128))
+		return;
+
+
+	for (int i = 0; i < len; i += sizeof(__m128))
+	{
+		val = _mm_load_ps(s);
+		_mm_store_ps(d, val);
+		d += sizeof(__m128) / sizeof(float);
+		s += sizeof(__m128) / sizeof(float);
+	}
+}
+
+static void avx_memcpy(void *dst, void const *src, size_t len)
+{
+	__m256 val;
+	float *d = dst;
+	float const *s = src;
+
+	if (len < sizeof(__m256))
+		return;
+
+	for (int i = 0; i < len; i += sizeof(__m256))
+	{
+		val = _mm256_load_ps(s);
+		_mm256_store_ps(d, val);
+		d += sizeof(__m256) / sizeof(float);
+		s += sizeof(__m256) / sizeof(float);
+	}
+}
+
 static void t_simple(struct memcpy_test *test)
 {
 	do_test(test, simple_memcpy);
@@ -135,6 +176,16 @@ static void t_hybrid(struct memcpy_test *test)
 		do_test(test, memcpy);
 }
 
+static void t_sse(struct memcpy_test *test)
+{
+	do_test(test, sse_memcpy);
+}
+
+static void t_avx(struct memcpy_test *test)
+{
+	do_test(test, avx_memcpy);
+}
+
 static struct memcpy_type t[] = {
 	{
 		.name = "memcpy",
@@ -157,6 +208,16 @@ static struct memcpy_type t[] = {
 		.fn = t_hybrid,
 	},
 	{
+		.name = "sse",
+		.mask = T_SSE,
+		.fn = t_sse,
+	},
+	{
+		.name = "avx",
+		.mask = T_AVX,
+		.fn = t_avx,
+	},
+	{
 		.name = NULL,
 	},
 };
@@ -200,8 +261,8 @@ static int setup_tests(void)
 	void *src, *dst;
 	int i;
 
-	src = malloc(BUF_SIZE);
-	dst = malloc(BUF_SIZE);
+	src = aligned_alloc(64, BUF_SIZE);
+	dst = aligned_alloc(64, BUF_SIZE);
 	if (!src || !dst) {
 		free(src);
 		free(dst);
-- 
2.13.6


--------------9C75A3BC47705DEC8EECD540--

