Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaIYMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Sep 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XX7iO-0008Lz-Ri
	for fio@vger.kernel.org; Thu, 25 Sep 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140925120003.76E36400C0@lyth.info>
Date: Thu, 25 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4877c1ab380b199ba6d9207b689bb1df127b0b4b:

  t/dedupe: Linux only for now (2014-09-23 18:36:52 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b5b571a3f01c17ddb39fd0306cb425a11e216f3d:

  Fix compile for FIO_INC_DEBUG not set (2014-09-24 09:54:24 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      dedupe: don't add extent items unless we use them
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      dedupe: cleanups and rate estimation
      dedupe: remove rb_lock when done
      dedupe: print threads used up front
      Fix compile for FIO_INC_DEBUG not set

 gettime.c  |    4 +++
 t/dedupe.c |  111 ++++++++++++++++++++++++++++++++++++++++++------------------
 2 files changed, 82 insertions(+), 33 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index fa750ec..8a13923 100644
--- a/gettime.c
+++ b/gettime.c
@@ -541,9 +541,13 @@ int fio_monotonic_clocktest(void)
 
 	log_info("cs: reliable_tsc: %s\n", tsc_reliable ? "yes" : "no");
 
+#ifdef FIO_INC_DEBUG
 	fio_debug |= 1U << FD_TIME;
+#endif
 	calibrate_cpu_clock();
+#ifdef FIO_INC_DEBUG
 	fio_debug &= ~(1U << FD_TIME);
+#endif
 
 	threads = malloc(nr_cpus * sizeof(struct clock_thread));
 	tentries = CLOCK_ENTRIES * nr_cpus;
diff --git a/t/dedupe.c b/t/dedupe.c
index e51e444..b81e98a 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -24,6 +24,8 @@
 #include "../crc/md5.h"
 #include "../memalign.h"
 #include "../os/os.h"
+#include "../gettime.h"
+#include "../fio_time.h"
 
 FILE *f_err;
 struct timeval *fio_tv = NULL;
@@ -53,9 +55,9 @@ struct extent {
 
 struct chunk {
 	struct rb_node rb_node;
-	struct flist_head extent_list;
 	uint64_t count;
 	uint32_t hash[MD5_HASH_WORDS];
+	struct flist_head extent_list[0];
 };
 
 struct item {
@@ -134,11 +136,18 @@ static int read_block(int fd, void *buf, off_t offset)
 
 static void add_item(struct chunk *c, struct item *i)
 {
-	struct extent *e;
+	/*	
+	 * Save some memory and don't add extent items, if we don't
+	 * use them.
+	 */
+	if (dump_output || collision_check) {
+		struct extent *e;
+
+		e = malloc(sizeof(*e));
+		e->offset = i->offset;
+		flist_add_tail(&e->list, &c->extent_list[0]);
+	}
 
-	e = malloc(sizeof(*e));
-	e->offset = i->offset;
-	flist_add_tail(&e->list, &c->extent_list);
 	c->count++;
 }
 
@@ -151,7 +160,7 @@ static int col_check(struct chunk *c, struct item *i)
 	cbuf = fio_memalign(blocksize, blocksize);
 	ibuf = fio_memalign(blocksize, blocksize);
 
-	e = flist_entry(c->extent_list.next, struct extent, list);
+	e = flist_entry(c->extent_list[0].next, struct extent, list);
 	if (read_block(dev_fd, cbuf, e->offset))
 		goto out;
 
@@ -165,6 +174,19 @@ out:
 	return ret;
 }
 
+static struct chunk *alloc_chunk(void)
+{
+	struct chunk *c;
+
+	if (collision_check || dump_output) {
+		c = malloc(sizeof(struct chunk) + sizeof(struct flist_head));
+		INIT_FLIST_HEAD(&c->extent_list[0]);
+	} else
+		c = malloc(sizeof(struct chunk));
+
+	return c;
+}
+
 static void insert_chunk(struct item *i)
 {
 	struct rb_node **p, *parent;
@@ -199,9 +221,8 @@ static void insert_chunk(struct item *i)
 		}
 	}
 
-	c = malloc(sizeof(*c));
+	c = alloc_chunk();
 	RB_CLEAR_NODE(&c->rb_node);
-	INIT_FLIST_HEAD(&c->extent_list);
 	c->count = 0;
 	memcpy(c->hash, i->hash, sizeof(i->hash));
 	rb_link_node(&c->rb_node, parent, p);
@@ -280,7 +301,49 @@ static void *thread_fn(void *data)
 	return NULL;
 }
 
-static int __dedupe_check(int fd, uint64_t dev_size)
+static void show_progress(struct worker_thread *threads, unsigned long total)
+{
+	unsigned long last_nitems = 0;
+	struct timeval last_tv;
+
+	fio_gettime(&last_tv, NULL);
+
+	while (print_progress) {
+		unsigned long this_items;
+		unsigned long nitems = 0;
+		uint64_t tdiff;
+		float perc;
+		int some_done;
+		int i;
+
+		for (i = 0; i < num_threads; i++) {
+			nitems += threads[i].items;
+			some_done = threads[i].done;
+			if (some_done)
+				break;
+		}
+
+		if (some_done)
+			break;
+
+		perc = (float) nitems / (float) total;
+		perc *= 100.0;
+		this_items = nitems - last_nitems;
+		this_items *= blocksize;
+		tdiff = mtime_since_now(&last_tv);
+		if (tdiff) {
+			this_items /= tdiff;
+			printf("%3.2f%% done (%luKB/sec)\r", perc, this_items);
+			last_nitems = nitems;
+			fio_gettime(&last_tv, NULL);
+		} else
+			printf("%3.2f%% done\r", perc);
+		fflush(stdout);
+		usleep(250000);
+	};
+}
+
+static int run_dedupe_threads(int fd, uint64_t dev_size)
 {
 	struct worker_thread *threads;
 	unsigned long nitems, total_items;
@@ -305,27 +368,7 @@ static int __dedupe_check(int fd, uint64_t dev_size)
 		}
 	}
 
-	while (print_progress) {
-		float perc;
-		int some_done;
-
-		nitems = 0;
-		for (i = 0; i < num_threads; i++) {
-			nitems += threads[i].items;
-			some_done = threads[i].done;
-			if (some_done)
-				break;
-		}
-
-		if (some_done)
-			break;
-
-		perc = (float) nitems / (float) total_items;
-		perc *= 100.0;
-		printf("%3.2f%% done\r", perc);
-		fflush(stdout);
-		usleep(200000);
-	};
+	show_progress(threads, total_items);
 
 	nitems = 0;
 	for (i = 0; i < num_threads; i++) {
@@ -337,6 +380,7 @@ static int __dedupe_check(int fd, uint64_t dev_size)
 	printf("Threads(%u): %lu items processed\n", num_threads, nitems);
 
 	fio_mutex_remove(size_lock);
+	free(threads);
 	return err;
 }
 
@@ -368,9 +412,9 @@ static int dedupe_check(const char *filename)
 		return 1;
 	}
 
-	printf("Will check <%s>, size <%llu>\n", filename, (unsigned long long) dev_size);
+	printf("Will check <%s>, size <%llu>, using %u threads\n", filename, (unsigned long long) dev_size, num_threads);
 
-	return __dedupe_check(dev_fd, dev_size);
+	return run_dedupe_threads(dev_fd, dev_size);
 }
 
 static void show_chunk(struct chunk *c)
@@ -379,7 +423,7 @@ static void show_chunk(struct chunk *c)
 	struct extent *e;
 
 	printf("c hash %8x %8x %8x %8x, count %lu\n", c->hash[0], c->hash[1], c->hash[2], c->hash[3], (unsigned long) c->count);
-	flist_for_each(n, &c->extent_list) {
+	flist_for_each(n, &c->extent_list[0]) {
 		e = flist_entry(n, struct extent, list);
 		printf("\toffset %llu\n", (unsigned long long) e->offset);
 	}
@@ -476,6 +520,7 @@ int main(int argc, char *argv[])
 
 	iter_rb_tree();
 
+	fio_mutex_remove(rb_lock);
 	scleanup();
 	return ret;
 }
