Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45692 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935325AbeFMMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Jun 2018 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fT4Rk-0004wJ-HX
        for fio@vger.kernel.org; Wed, 13 Jun 2018 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180613120001.77BF02C263D@kernel.dk>
Date: Wed, 13 Jun 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 49050b56681b17968256702a7a3ec0f545c7dad8:

  Fix start delay being the same across threads (2018-06-11 20:02:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cdfb5a85d9743fb53f4a2b56a392e0897a333568:

  rand: make randX_upto() do the end value increment (2018-06-12 11:43:29 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      rand: add rand64_between()
      rand: cleanup rand_between() and helpers
      init: kill get_rand_start_delay()
      init: use o-> instead of td->o
      rand: ensure that rand_between() can reach max value
      rand: make randX_upto() do the end value increment

 engines/sync.c |  2 +-
 init.c         | 20 +++-----------------
 io_u.c         | 10 +++++-----
 lib/rand.h     | 31 ++++++++++++++++++++++++++-----
 t/gen-rand.c   |  2 +-
 5 files changed, 36 insertions(+), 29 deletions(-)

---

Diff of recent changes:

diff --git a/engines/sync.c b/engines/sync.c
index 3f36da8..b3e1c9d 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -150,7 +150,7 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 	fio_ro_check(td, io_u);
 
 	if (o->hipri &&
-	    (rand32_between(&sd->rand_state, 1, 100) <= o->hipri_percentage))
+	    (rand_between(&sd->rand_state, 1, 100) <= o->hipri_percentage))
 		flags |= RWF_HIPRI;
 
 	iov->iov_base = io_u->xfer_buf;
diff --git a/init.c b/init.c
index e25e5e4..353c99b 100644
--- a/init.c
+++ b/init.c
@@ -574,22 +574,6 @@ static int fixed_block_size(struct thread_options *o)
 		o->min_bs[DDIR_READ] == o->min_bs[DDIR_TRIM];
 }
 
-
-static unsigned long long get_rand_start_delay(struct thread_data *td)
-{
-	unsigned long long delayrange;
-	uint64_t r, frand_max;
-
-	delayrange = td->o.start_delay_high - td->o.start_delay;
-
-	frand_max = rand_max(&td->delay_state);
-	r = __rand(&td->delay_state);
-	delayrange = (unsigned long long) ((double) delayrange * (r / (frand_max + 1.0)));
-
-	delayrange += td->o.start_delay_orig;
-	return delayrange;
-}
-
 /*
  * <3 Johannes
  */
@@ -687,7 +671,9 @@ static int fixup_options(struct thread_data *td)
 	if (o->start_delay_high) {
 		if (!o->start_delay_orig)
 			o->start_delay_orig = o->start_delay;
-		o->start_delay = get_rand_start_delay(td);
+		o->start_delay = rand_between(&td->delay_state,
+						o->start_delay_orig,
+						o->start_delay_high);
 	}
 
 	if (o->norandommap && o->verify != VERIFY_NONE
diff --git a/io_u.c b/io_u.c
index 945aa19..580c414 100644
--- a/io_u.c
+++ b/io_u.c
@@ -168,7 +168,7 @@ bail:
 	/*
 	 * Generate a value, v, between 1 and 100, both inclusive
 	 */
-	v = rand32_between(&td->zone_state, 1, 100);
+	v = rand_between(&td->zone_state, 1, 100);
 
 	/*
 	 * Find our generated table. 'send' is the end block of this zone,
@@ -225,7 +225,7 @@ bail:
 	/*
 	 * Generate a value, v, between 1 and 100, both inclusive
 	 */
-	v = rand32_between(&td->zone_state, 1, 100);
+	v = rand_between(&td->zone_state, 1, 100);
 
 	zsi = &td->zone_state_index[ddir][v - 1];
 	stotal = zsi->size_perc_prev;
@@ -300,7 +300,7 @@ static bool should_do_random(struct thread_data *td, enum fio_ddir ddir)
 	if (td->o.perc_rand[ddir] == 100)
 		return true;
 
-	v = rand32_between(&td->seq_rand_state[ddir], 1, 100);
+	v = rand_between(&td->seq_rand_state[ddir], 1, 100);
 
 	return v <= td->o.perc_rand[ddir];
 }
@@ -589,7 +589,7 @@ static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 {
 	unsigned int v;
 
-	v = rand32_between(&td->rwmix_state, 1, 100);
+	v = rand_between(&td->rwmix_state, 1, 100);
 
 	if (v <= td->o.rwmix[DDIR_READ])
 		return DDIR_READ;
@@ -2069,7 +2069,7 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 		return &td->buf_state;
 	}
 
-	v = rand32_between(&td->dedupe_state, 1, 100);
+	v = rand_between(&td->dedupe_state, 1, 100);
 
 	if (v <= td->o.dedupe_percentage)
 		return &td->buf_state_prev;
diff --git a/lib/rand.h b/lib/rand.h
index 8832c73..1676cf9 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -114,17 +114,38 @@ static inline double __rand_0_1(struct frand_state *state)
 	}
 }
 
-/*
- * Generate a random value between 'start' and 'end', both inclusive
- */
-static inline int rand32_between(struct frand_state *state, int start, int end)
+static inline uint32_t rand32_upto(struct frand_state *state, uint32_t end)
 {
 	uint32_t r;
 
 	assert(!state->use64);
 
 	r = __rand32(&state->state32);
-	return start + (int) ((double)end * (r / (FRAND32_MAX + 1.0)));
+	end++;
+	return (int) ((double)end * (r / (FRAND32_MAX + 1.0)));
+}
+
+static inline uint64_t rand64_upto(struct frand_state *state, uint64_t end)
+{
+	uint64_t r;
+
+	assert(state->use64);
+
+	r = __rand64(&state->state64);
+	end++;
+	return (uint64_t) ((double)end * (r / (FRAND64_MAX + 1.0)));
+}
+
+/*
+ * Generate a random value between 'start' and 'end', both inclusive
+ */
+static inline uint64_t rand_between(struct frand_state *state, uint64_t start,
+				    uint64_t end)
+{
+	if (state->use64)
+		return start + rand64_upto(state, end - start);
+	else
+		return start + rand32_upto(state, end - start);
 }
 
 extern void init_rand(struct frand_state *, bool);
diff --git a/t/gen-rand.c b/t/gen-rand.c
index c379053..b050bd7 100644
--- a/t/gen-rand.c
+++ b/t/gen-rand.c
@@ -34,7 +34,7 @@ int main(int argc, char *argv[])
 	init_rand(&s, false);
 
 	for (i = 0; i < nvalues; i++) {
-		int v = rand32_between(&s, start, end);
+		int v = rand_between(&s, start, end);
 
 		buckets[v - start]++;
 	}
