Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36060 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbeGKMEI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Jul 2018 08:04:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fdDmx-0007fd-PN
        for fio@vger.kernel.org; Wed, 11 Jul 2018 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180711120002.242EC2C00AA@kernel.dk>
Date: Wed, 11 Jul 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 19a8064ef4a2a826ee06ed061af970d1737cf840:

  blktrace: just ignore zero byte traces (2018-07-04 14:59:18 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dc54a01f9a2966133f6d1a52f3718d267117b4f3:

  t/axmap: clean up overlap tests (2018-07-10 21:51:16 -0600)

----------------------------------------------------------------
Jens Axboe (7):
      io_u: fix negative offset due to wrap
      io_u: ensure we generate the full length of block sizes
      t/axmap: add overlap test cases
      axmap: ensure that overlaps are handled strictly sequential
      t/axmap: add a few more overlap test cases
      Makefile: lib/axmap no longer needs hweight
      t/axmap: clean up overlap tests

 io_u.c      |  19 +++++------
 lib/axmap.c |  13 ++++----
 t/axmap.c   | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 580c414..5221a78 100644
--- a/io_u.c
+++ b/io_u.c
@@ -541,10 +541,8 @@ static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u,
 		r = __rand(&td->bsrange_state[ddir]);
 
 		if (!td->o.bssplit_nr[ddir]) {
-			buflen = 1 + (unsigned int) ((double) maxbs *
+			buflen = minbs + (unsigned int) ((double) maxbs *
 					(r / (frand_max + 1.0)));
-			if (buflen < minbs)
-				buflen = minbs;
 		} else {
 			long long perc = 0;
 			unsigned int i;
@@ -832,15 +830,16 @@ static void __fill_io_u_zone(struct thread_data *td, struct io_u *io_u)
 		 * Wrap from the beginning, if we exceed the file size
 		 */
 		if (f->file_offset >= f->real_file_size)
-			f->file_offset = f->real_file_size - f->file_offset;
+			f->file_offset = get_start_offset(td, f);
+
 		f->last_pos[io_u->ddir] = f->file_offset;
 		td->io_skip_bytes += td->o.zone_skip;
 	}
 
 	/*
- 	 * If zone_size > zone_range, then maintain the same zone until
- 	 * zone_bytes >= zone_size.
- 	 */
+	 * If zone_size > zone_range, then maintain the same zone until
+	 * zone_bytes >= zone_size.
+	 */
 	if (f->last_pos[io_u->ddir] >= (f->file_offset + td->o.zone_range)) {
 		dprint(FD_IO, "io_u maintain zone offset=%" PRIu64 "/last_pos=%" PRIu64 "\n",
 				f->file_offset, f->last_pos[io_u->ddir]);
@@ -851,9 +850,8 @@ static void __fill_io_u_zone(struct thread_data *td, struct io_u *io_u)
 	 * For random: if 'norandommap' is not set and zone_size > zone_range,
 	 * map needs to be reset as it's done with zone_range everytime.
 	 */
-	if ((td->zone_bytes % td->o.zone_range) == 0) {
+	if ((td->zone_bytes % td->o.zone_range) == 0)
 		fio_file_reset(td, f);
-	}
 }
 
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
@@ -874,9 +872,8 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * When file is zoned zone_range is always positive
 	 */
-	if (td->o.zone_range) {
+	if (td->o.zone_range)
 		__fill_io_u_zone(td, io_u);
-	}
 
 	/*
 	 * No log, let the seq/rand engine retrieve the next buflen and
diff --git a/lib/axmap.c b/lib/axmap.c
index 3c65308..c29597f 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -234,17 +234,18 @@ static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
 	if (overlap == mask)
 		return true;
 
-	while (overlap) {
-		unsigned long clear_mask = ~(1UL << ffz(~overlap));
+	if (overlap) {
+		const int __bit = ffz(~overlap);
 
-		mask &= clear_mask;
-		overlap &= clear_mask;
-		nr_bits--;
+		if (__bit == bit)
+			return true;
+
+		nr_bits = __bit - bit;
+		mask = bit_masks[nr_bits] << bit;
 	}
 
 	assert(mask);
 	assert(!(al->map[offset] & mask));
-		
 	al->map[offset] |= mask;
 
 	if (!al->level)
diff --git a/t/axmap.c b/t/axmap.c
index eef464f..3f6b8f1 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -107,6 +107,108 @@ static int test_multi(size_t size, unsigned int bit_off)
 	return err;
 }
 
+struct overlap_test {
+	unsigned int start;
+	unsigned int nr;
+	unsigned int ret;
+};
+
+static int test_overlap(void)
+{
+	struct overlap_test tests[] = {
+		{
+			.start	= 16,
+			.nr	= 16,
+			.ret	= 16,
+		},
+		{
+			.start	= 0,
+			.nr	= 32,
+			.ret	= 16,
+		},
+		{
+			.start	= 48,
+			.nr	= 32,
+			.ret	= 32,
+		},
+		{
+			.start	= 32,
+			.nr	= 32,
+			.ret	= 16,
+		},
+		{
+			.start	= 102,
+			.nr	= 1,
+			.ret	= 1,
+		},
+		{
+			.start	= 101,
+			.nr	= 3,
+			.ret	= 1,
+		},
+		{
+			.start	= 106,
+			.nr	= 4,
+			.ret	= 4,
+		},
+		{
+			.start	= 105,
+			.nr	= 3,
+			.ret	= 1,
+		},
+		{
+			.start	= 120,
+			.nr	= 4,
+			.ret	= 4,
+		},
+		{
+			.start	= 118,
+			.nr	= 2,
+			.ret	= 2,
+		},
+		{
+			.start	= 118,
+			.nr	= 2,
+			.ret	= 0,
+		},
+		{
+			.start	= -1U,
+		},
+	};
+	struct axmap *map;
+	int entries, i, ret, err = 0;
+
+	entries = 0;
+	for (i = 0; tests[i].start != 1U; i++) {
+		unsigned int this = tests[i].start + tests[i].nr;
+
+		if (this > entries)
+			entries = this;
+	}
+
+	printf("Test overlaps...");
+	fflush(stdout);
+
+	map = axmap_new(entries);
+
+	for (i = 0; tests[i].start != -1U; i++) {
+		struct overlap_test *t = &tests[i];
+
+		ret = axmap_set_nr(map, t->start, t->nr);
+		if (ret != t->ret) {
+			printf("fail\n");
+			printf("start=%u, nr=%d, ret=%d: %d\n", t->start, t->nr,
+								t->ret, ret);
+			err = 1;
+			break;
+		}
+	}
+
+	printf("pass!\n");
+	axmap_free(map);
+	return err;
+}
+
 int main(int argc, char *argv[])
 {
 	size_t size = (1UL << 23) - 200;
@@ -124,6 +226,8 @@ int main(int argc, char *argv[])
 		return 2;
 	if (test_multi(size, 17))
 		return 3;
+	if (test_overlap())
+		return 4;
 
 	return 0;
 }
