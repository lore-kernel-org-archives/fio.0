Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:29327 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759867Ab3CHS3v (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 8 Mar 2013 13:29:51 -0500
Received: from localhost.admin.grnet.gr (conf-205.admin.grnet.gr [195.251.28.205])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id 9296A18059
	for <fio@vger.kernel.org>; Fri,  8 Mar 2013 20:29:48 +0200 (EET)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH 1/2] Improve LFSR implementation
Date: Fri,  8 Mar 2013 20:30:02 +0200
Message-Id: <1362767403-2001-2-git-send-email-apyrgio@grnet.gr>
In-Reply-To: <1362767403-2001-1-git-send-email-apyrgio@grnet.gr>
References: <1362767403-2001-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Changes:

1. Use Galois LFSR instead of Fibonacci LFSR.
2. Use XNOR gates instead of XOR gates.
3. Add tap sizes for LFSRs ranging from 3-bits to 15-bits.
4. Add spin parameter.

Rationale:

1. Fibonacci LFSRs have the following drawbacks:

   a. Their next state can not be computed in one cycle, since the input
      bit must be propagated serially through the XOR gates. Galois
	  LFSRs however, can be computed instantly with XOR-masks.

   b. Their state changes cannot be considered "irregular", even by I/O
      standards. Actually, if the current state of an n-bit LFSR is x,
	  then the next will either be (x >> 1) or (2^n + (x >> 1)). Galois
	  LFSRs have instead their XOR gates interleaved with their bits,
	  which means that the inner bits are changed as well, besides of
	  the shifting. If the number of taps is z, this means that the
	  different outcomes are 2^(z + 1).

2. An LFSR with XOR gates has the all-zeroes state as illegal. Since
   zero is valid for most I/O operations, it would be more intuitive to
   use XNOR gates, that have as the all-ones state as illegal.

3. Allow smaller I/O benchmarks to use LFSRs.

4. The spin parameter follows the same rationale as in 1b. To make the
   LFSR outcome "appear" less predictable, we can spin internally the
   LFSR state and produce the i-th number. To understand the spin
   parameter, consider the following state sequence of a 3-bit LFSR:

                             0, 2, 3, 5, 6, 1, 4
   Same LFSR, spin value 2:  0, 3, 6, 4, 2, 5, 1
   But what is the benefit from using spin? Well, the benefits are
   two-fold:

   a. For the same I/O size, we can create a different I/O sequences.

   b. Following the rationale of 1b, we can have more variable outcomes.
      If the spin value is "i" and the taps are "z", the number of
	  different outcomes become i * 2^(z + 1).

Signed-off-by: Alex Pyrgiotis <apyrgio@grnet.gr>

diff --git a/filesetup.c b/filesetup.c
index 220ceb9..57553c9 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -966,7 +966,7 @@ int init_random_map(struct thread_data *td)
 
 			seed = td->rand_seeds[FIO_RAND_BLOCK_OFF];
 			
-			if (!lfsr_init(&f->lfsr, blocks, seed))
+			if (!lfsr_init(&f->lfsr, blocks, seed, seed & 0xF))
 				continue;
 		} else if (!td->o.norandommap) {
 			f->io_axmap = axmap_new(blocks);
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 61a3aaf..758dc8b 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -1,278 +1,233 @@
 #include <stdio.h>
+#include <math.h>
 
 #include "lfsr.h"
 
 /*
- * From table 3 of
+ * LFSR taps retrieved from:
+ * http://home1.gte.net/res0658s/electronics/LFSRtaps.html
  *
- * http://www.xilinx.com/support/documentation/application_notes/xapp052.pdf
+ * The memory overhead of the following tap table should be relatively small,
+ * no more than 400 bytes.
  */
-static struct lfsr_taps lfsr_taps[] = {
-	{
-		.length	= 16,
-		.taps	= { 16, 15, 13, 4, },
-	},
-	{
-		.length = 17,
-		.taps	= { 17, 14, },
-	},
-	{
-		.length = 18,
-		.taps	= { 18, 11, },
-	},
-	{
-		.length	= 19,
-		.taps	= { 19, 6, 2, 1, },
-	},
-	{
-		.length	= 20,
-		.taps	= { 20, 17, },
-	},
-	{
-		.length	= 21,
-		.taps	= { 21, 19, },
-	},
-	{
-		.length	= 22,
-		.taps	= { 22, 21, },
-	},
-	{
-		.length	= 23,
-		.taps	= { 23, 18, },
-	},
-	{
-		.length = 24,
-		.taps	= { 24, 23, 22, 17, },
-	},
-	{
-		.length	= 25,
-		.taps	= { 25, 22, },
-	},
-	{
-		.length	= 26,
-		.taps	= {26, 6, 2, 1, },
-	},
-	{
-		.length	= 27,
-		.taps	= { 27, 5, 2, 1, },
-	},
-	{
-		.length	= 28,
-		.taps	= { 28, 25, },
-	},
-	{
-		.length	= 29,
-		.taps	= {29, 27, },
-	},
-	{
-		.length	= 30,
-		.taps	= { 30, 6, 4, 1, },
-	},
-	{
-		.length	= 31,
-		.taps	= { 31, 28, },
-	},
-	{
-		.length	= 32,
-		.taps	= { 32, 22, 2, 1, },
-	},
-	{
-		.length	= 33,
-		.taps	= { 33, 20, },
-	},
-	{
-		.length	= 34,
-		.taps	= { 34, 27, 2, 1, },
-	},
-	{
-		.length	= 35,
-		.taps	= { 35, 33, },
-	},
-	{
-		.length	= 36,
-		.taps	= { 36, 25, },
-	},
-	{
-		.length	= 37,
-		.taps	= { 37, 5, 4, 3, 2, 1, },
-	},
-	{
-		.length	= 38,
-		.taps	= { 38, 6, 5, 1, },
-	},
-	{
-		.length	= 39,
-		.taps	= { 39, 35, },
-	},
-	{
-		.length	= 40,
-		.taps	= { 40, 38, 21, 19, },
-	},
-	{
-		.length	= 41,
-		.taps	= { 41, 38, },
-	},
-	{
-		.length	= 42,
-		.taps	= { 42, 41, 20, 19, },
-	},
-	{
-		.length	= 43,
-		.taps	= { 43, 42, 38, 37, },
-	},
-	{
-		.length	= 44,
-		.taps	= { 44, 43, 38, 37, },
-	},
-	{
-		.length	= 45,
-		.taps	= { 45, 44, 42, 41, },
-	},
-	{
-		.length	= 46,
-		.taps	= { 46, 45, 26, 25, },
-	},
-	{
-		.length	= 47,
-		.taps	= { 47, 42, },
-	},
-	{
-		.length	= 48,
-		.taps	= { 48, 47, 21, 20, },
-	},
-	{
-		.length	= 49,
-		.taps	= { 49, 40, },
-	},
-	{
-		.length	= 50,
-		.taps	= { 50, 49, 36, 35, },
-	},
-	{
-		.length	= 51,
-		.taps	= { 51, 50, 36, 35, },
-	},
-	{
-		.length	= 52,
-		.taps	= { 52, 49, },
-	},
-	{
-		.length	= 53,
-		.taps	= { 53, 52, 38, 37 },
-	},
-	{
-		.length	= 54,
-		.taps	= { 54, 53, 18, 17 },
-	},
-	{
-		.length	= 55,
-		.taps	= { 55, 31, },
-	},
-	{
-		.length	= 56,
-		.taps	= { 56, 55, 35, 34, },
-	},
-	{
-		.length	= 57,
-		.taps	= { 57, 50, },
-	},
-	{
-		.length = 58,
-		.taps	= { 58, 39, },
-	},
-	{
-		.length	= 59,
-		.taps	= { 59, 58, 38, 37, },
-	},
-	{
-		.length	= 60,
-		.taps	= { 60, 59, },
-	},
-	{
-		.length	= 61,
-		.taps	= { 61, 60, 46, 45, },
-	},
-	{
-		.length	= 62,
-		.taps	= { 62, 61, 6, 5, },
-	},
-	{
-		.length	= 63,
-		.taps	= { 63, 62, },
-	},
+static uint8_t taps[64][FIO_MAX_TAPS] =
+{
+		{0}, {0}, {0},		//LFSRs with less that 3-bits cannot exist
+		{3, 2},				//Tap position for 3-bit LFSR
+		{4, 3},				//Tap position for 4-bit LFSR
+		{5, 3},				//Tap position for 5-bit LFSR
+		{6, 5},				//Tap position for 6-bit LFSR
+		{7, 6},				//Tap position for 7-bit LFSR
+		{8, 6, 5 ,4},		//Tap position for 8-bit LFSR
+		{9, 5},				//Tap position for 9-bit LFSR
+		{10, 7},			//Tap position for 10-bit LFSR
+		{11, 9},			//Tap position for 11-bit LFSR
+		{12, 6, 4, 1},		//Tap position for 12-bit LFSR
+		{13, 4, 3, 1},		//Tap position for 13-bit LFSR
+		{14, 5, 3, 1},		//Tap position for 14-bit LFSR
+		{15, 14},			//Tap position for 15-bit LFSR
+		{16, 15, 13, 4},	//Tap position for 16-bit LFSR
+		{17, 14},			//Tap position for 17-bit LFSR
+		{18, 11},			//Tap position for 18-bit LFSR
+		{19, 6, 2, 1},		//Tap position for 19-bit LFSR
+		{20, 17},			//Tap position for 20-bit LFSR
+		{21, 19},			//Tap position for 21-bit LFSR
+		{22, 21},			//Tap position for 22-bit LFSR
+		{23, 18},			//Tap position for 23-bit LFSR
+		{24, 23, 22, 17},	//Tap position for 24-bit LFSR
+		{25, 22},			//Tap position for 25-bit LFSR
+		{26, 6, 2, 1},		//Tap position for 26-bit LFSR
+		{27, 5, 2, 1},		//Tap position for 27-bit LFSR
+		{28, 25},			//Tap position for 28-bit LFSR
+		{29, 27},			//Tap position for 29-bit LFSR
+		{30, 6, 4, 1},		//Tap position for 30-bit LFSR
+		{31, 28},			//Tap position for 31-bit LFSR
+		{32, 31, 29, 1},	//Tap position for 32-bit LFSR
+		{33, 20},			//Tap position for 33-bit LFSR
+		{34, 27, 2, 1},		//Tap position for 34-bit LFSR
+		{35, 33},			//Tap position for 35-bit LFSR
+		{36, 25},			//Tap position for 36-bit LFSR
+		{37, 5, 4, 3, 2, 1},//Tap position for 37-bit LFSR
+		{38, 6, 5, 1},		//Tap position for 38-bit LFSR
+		{39, 35},			//Tap position for 39-bit LFSR
+		{40, 38, 21, 19},	//Tap position for 40-bit LFSR
+		{41, 38},			//Tap position for 41-bit LFSR
+		{42, 41, 20, 19},	//Tap position for 42-bit LFSR
+		{43, 42, 38, 37},	//Tap position for 43-bit LFSR
+		{44, 43, 18, 17},	//Tap position for 44-bit LFSR
+		{45, 44, 42, 41},	//Tap position for 45-bit LFSR
+		{46, 45, 26, 25},	//Tap position for 46-bit LFSR
+		{47, 42},			//Tap position for 47-bit LFSR
+		{48, 47, 21, 20},	//Tap position for 48-bit LFSR
+		{49, 40},			//Tap position for 49-bit LFSR
+		{50, 49, 24, 23},	//Tap position for 50-bit LFSR
+		{51, 50, 36, 35},	//Tap position for 51-bit LFSR
+		{52, 49},			//Tap position for 52-bit LFSR
+		{53, 52, 38, 37},	//Tap position for 53-bit LFSR
+		{54, 53, 18, 17},	//Tap position for 54-bit LFSR
+		{55, 31},			//Tap position for 55-bit LFSR
+		{56, 55, 35, 34},	//Tap position for 56-bit LFSR
+		{57, 50},			//Tap position for 57-bit LFSR
+		{58, 39},			//Tap position for 58-bit LFSR
+		{59, 58, 38, 37},	//Tap position for 59-bit LFSR
+		{60, 59},			//Tap position for 60-bit LFSR
+		{61, 60, 46, 45},	//Tap position for 61-bit LFSR
+		{62, 61, 6, 5},		//Tap position for 62-bit LFSR
+		{63, 62},			//Tap position for 63-bit LFSR
 };
 
-#define FIO_LFSR_CRANKS		128
+#define __LFSR_NEXT(__fl, __v)						\
+	__v = ((__v >> 1) | __fl->cached_bit) ^			\
+			(((__v & 1UL) - 1UL) & __fl->xormask);
 
-static uint64_t __lfsr_next(uint64_t v, struct lfsr_taps *lt)
+static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
 {
-	uint64_t xor_mask = 0;
-	int i;
-
-	for (i = 0; lt->taps[i]; i++)
-		xor_mask ^= (v << (lt->taps[i] - 1));
-
-	xor_mask &= ~(~0UL << 1) << (lt->length - 1);
-	return xor_mask | (v >> 1);
+	/*
+	 * This should be O(1) since most compilers will create a jump table for
+	 * this switch.
+	 */
+	switch (spin) {
+		case 16: __LFSR_NEXT(fl, fl->last_val);
+		case 15: __LFSR_NEXT(fl, fl->last_val);
+		case 14: __LFSR_NEXT(fl, fl->last_val);
+		case 13: __LFSR_NEXT(fl, fl->last_val);
+		case 12: __LFSR_NEXT(fl, fl->last_val);
+		case 11: __LFSR_NEXT(fl, fl->last_val);
+		case 10: __LFSR_NEXT(fl, fl->last_val);
+		case  9: __LFSR_NEXT(fl, fl->last_val);
+		case  8: __LFSR_NEXT(fl, fl->last_val);
+		case  7: __LFSR_NEXT(fl, fl->last_val);
+		case  6: __LFSR_NEXT(fl, fl->last_val);
+		case  5: __LFSR_NEXT(fl, fl->last_val);
+		case  4: __LFSR_NEXT(fl, fl->last_val);
+		case  3: __LFSR_NEXT(fl, fl->last_val);
+		case  2: __LFSR_NEXT(fl, fl->last_val);
+		case  1: __LFSR_NEXT(fl, fl->last_val);
+		case  0: __LFSR_NEXT(fl, fl->last_val);
+		default: break;
+	}
 }
 
 int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t last)
 {
+	int repeat;
+	unsigned int spin;
+
+	repeat = fl->num_vals % fl->cycle_length;
+	if (repeat == 0)
+		spin = fl->spin + 1;
+	else
+		spin = fl->spin;
+
 	if (fl->num_vals > fl->max_val)
 		return 1;
 
+	fl->num_vals++;
+
 	do {
-		fl->last_val = __lfsr_next(fl->last_val, &fl->taps);
-		if (fl->last_val - 1 <= fl->max_val &&
-		    fl->last_val <= last)
-			break;
-	} while (1);
+		__lfsr_next(fl, spin);
+	} while (fl->last_val > fl->max_val);
 
-	*off = fl->last_val - 1;
-	fl->num_vals++;
+	*off = fl->last_val;
 	return 0;
 }
 
-static struct lfsr_taps *find_lfsr(uint64_t size)
+static uint64_t lfsr_create_xormask(uint8_t *taps)
 {
 	int i;
+	uint64_t xormask = 0;
 
-	for (i = 0; lfsr_taps[i].length; i++)
-		if (((1UL << lfsr_taps[i].length) + FIO_LFSR_CRANKS) >= size)
-			return &lfsr_taps[i];
+	for(i = 0; i < FIO_MAX_TAPS && taps[i] != 0; i++)
+		xormask |= 1UL << (taps[i] - 1);
 
-	return NULL;
+	return xormask;
 }
 
-void lfsr_reset(struct fio_lfsr *fl, unsigned long seed)
+static uint8_t *find_lfsr(uint64_t size)
 {
-	unsigned int i;
+	int i;
 
-	fl->last_val = seed;
-	fl->num_vals = 0;
+	for (i = 3; i < 64; i++)
+		if ((1UL << i) > size) /* TODO: Explain why. */
+			return taps[i];
 
-	for (i = 0; i < FIO_LFSR_CRANKS; i++)
-		fl->last_val = __lfsr_next(fl->last_val, &fl->taps);
+	return NULL;
 }
 
-int lfsr_init(struct fio_lfsr *fl, uint64_t size, unsigned long seed)
+/*
+ * It is well-known that all maximal n-bit LFSRs will start repeating
+ * themselves after their 2^n iteration. The introduction of spins however, is
+ * possible to create a repetition of a sub-sequence before we hit that mark.
+ * This happens if:
+ *
+ * [1]: ((2^n - 1) * i) % (spin + 1) == 0,
+ * where "n" is LFSR's bits and "i" any number within the range [1,spin]
+ *
+ * It is important to know beforehand if a spin can cause a repetition of a
+ * sub-sequence (cycle) and its length. However, calculating (2^n - 1) * i may
+ * produce a buffer overflow for "n" close to 64, so we expand the above to:
+ *
+ * [2]: (2^n - 1) -> (x * (spin + 1) + y), where x >= 0 and 0 <= y <= spin
+ *
+ * Thus, [1] is equivalent to (y * i) % (spin + 1) == 0;
+ * Also, the cycle's length will be (x * i) + (y * i) / (spin + 1)
+ */
+int prepare_spin(struct fio_lfsr *fl, unsigned int spin)
 {
-	struct lfsr_taps *tap;
+	uint64_t max = (fl->cached_bit << 1) - 1;
+	uint64_t x, y;
 	int i;
 
-	tap = find_lfsr(size);
-	if (!tap)
+	if (spin > 15)
 		return 1;
 
-	fl->max_val = size - 1;
-	fl->taps.length = tap->length;
+	x = max / (spin + 1);
+	y = max % (spin + 1);
+	fl->cycle_length = max;	/* This is the expected cycle */
+	fl->spin = spin;
 
-	for (i = 0; i < FIO_MAX_TAPS; i++) {
-		fl->taps.taps[i] = tap->taps[i];
-		if (!fl->taps.taps[i])
+	for (i = 1; i <= spin; i++) {
+		if ((y * i) % (spin + 1) == 0) {
+			fl->cycle_length = (x * i) + (y * i) / (spin + 1);
 			break;
+		}
 	}
 
-	lfsr_reset(fl, seed);
+	return 0;
+}
+
+int lfsr_reset(struct fio_lfsr *fl, unsigned long seed)
+{
+	uint64_t bitmask = (fl->cached_bit << 1) - 1;
+
+	fl->num_vals = 0;
+	fl->last_val = seed & bitmask;
+
+	/* All-ones state is illegal for XNOR LFSRs */
+	if (fl->last_val == bitmask)
+		return 1;
+
+	return 0;
+}
+
+int lfsr_init(struct fio_lfsr *fl, uint64_t nums, unsigned long seed,
+		unsigned int spin)
+{
+	uint8_t *lfsr_taps;
+
+	lfsr_taps = find_lfsr(nums);
+	if (!lfsr_taps)
+		return 1;
+
+	fl->max_val = nums - 1;
+	fl->xormask = lfsr_create_xormask(lfsr_taps);
+	fl->cached_bit = 1UL << (lfsr_taps[0] - 1);
+
+	if (prepare_spin(fl, spin))
+		return 1;
+
+	if (lfsr_reset(fl, seed))
+		return 1;
+
 	return 0;
 }
diff --git a/lib/lfsr.h b/lib/lfsr.h
index 45d7028..bc16af9 100644
--- a/lib/lfsr.h
+++ b/lib/lfsr.h
@@ -3,7 +3,7 @@
 
 #include <inttypes.h>
 
-#define FIO_MAX_TAPS	8
+#define FIO_MAX_TAPS	6
 
 struct lfsr_taps {
 	unsigned int length;
@@ -12,14 +12,18 @@ struct lfsr_taps {
 
 
 struct fio_lfsr {
+	uint64_t xormask;
 	uint64_t last_val;
+	uint64_t cached_bit;
 	uint64_t max_val;
 	uint64_t num_vals;
-	struct lfsr_taps taps;
+	uint64_t cycle_length;
+	unsigned int spin;
 };
 
 int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t);
-int lfsr_init(struct fio_lfsr *fl, uint64_t size, unsigned long seed);
-void lfsr_reset(struct fio_lfsr *fl, unsigned long seed);
+int lfsr_init(struct fio_lfsr *fl, uint64_t size,
+		unsigned long seed, unsigned int spin);
+int lfsr_reset(struct fio_lfsr *fl, unsigned long seed);
 
 #endif
diff --git a/t/axmap.c b/t/axmap.c
index 61e3220..7ab500f 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -34,7 +34,7 @@ int main(int argc, char *argv[])
 
 	printf("Using %llu entries\n", (unsigned long long) size);
 
-	lfsr_init(&lfsr, size, seed);
+	lfsr_init(&lfsr, size, seed, seed & 0xF);
 	map = axmap_new(size);
 	osize = size;
 
-- 
1.8.1.4

