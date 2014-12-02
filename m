Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36481 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaLBNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Dec 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xvn3k-0007DB-7d
	for fio@vger.kernel.org; Tue, 02 Dec 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141202130002.E882B402AC@lyth.info>
Date: Tue,  2 Dec 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 867198458145fc405d1925e339719f779fb671c2:

  Make gfio build with --build-static (2014-11-25 16:02:52 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f5041ed9d2890116ecba4bd3fe2121b272e01776:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-12-01 09:44:02 -0700)

----------------------------------------------------------------

Jens Axboe (2):
      Bump disk util stats from 32 to 64-bit values
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio

 client.c   |   20 ++++++-------
 diskutil.c |   92 ++++++++++++++++++++++++++++++++++--------------------------
 diskutil.h |   21 +++++++-------
 server.c   |   20 ++++++-------
 server.h   |    2 +-
 5 files changed, 85 insertions(+), 70 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 2c10c03..3cb7c1c 100644
--- a/client.c
+++ b/client.c
@@ -974,14 +974,14 @@ static void convert_agg(struct disk_util_agg *agg)
 	int i;
 
 	for (i = 0; i < 2; i++) {
-		agg->ios[i]	= le32_to_cpu(agg->ios[i]);
-		agg->merges[i]	= le32_to_cpu(agg->merges[i]);
+		agg->ios[i]	= le64_to_cpu(agg->ios[i]);
+		agg->merges[i]	= le64_to_cpu(agg->merges[i]);
 		agg->sectors[i]	= le64_to_cpu(agg->sectors[i]);
-		agg->ticks[i]	= le32_to_cpu(agg->ticks[i]);
+		agg->ticks[i]	= le64_to_cpu(agg->ticks[i]);
 	}
 
-	agg->io_ticks		= le32_to_cpu(agg->io_ticks);
-	agg->time_in_queue	= le32_to_cpu(agg->time_in_queue);
+	agg->io_ticks		= le64_to_cpu(agg->io_ticks);
+	agg->time_in_queue	= le64_to_cpu(agg->time_in_queue);
 	agg->slavecount		= le32_to_cpu(agg->slavecount);
 	agg->max_util.u.f	= fio_uint64_to_double(le64_to_cpu(agg->max_util.u.i));
 }
@@ -991,14 +991,14 @@ static void convert_dus(struct disk_util_stat *dus)
 	int i;
 
 	for (i = 0; i < 2; i++) {
-		dus->s.ios[i]		= le32_to_cpu(dus->s.ios[i]);
-		dus->s.merges[i]	= le32_to_cpu(dus->s.merges[i]);
+		dus->s.ios[i]		= le64_to_cpu(dus->s.ios[i]);
+		dus->s.merges[i]	= le64_to_cpu(dus->s.merges[i]);
 		dus->s.sectors[i]	= le64_to_cpu(dus->s.sectors[i]);
-		dus->s.ticks[i]		= le32_to_cpu(dus->s.ticks[i]);
+		dus->s.ticks[i]		= le64_to_cpu(dus->s.ticks[i]);
 	}
 
-	dus->s.io_ticks		= le32_to_cpu(dus->s.io_ticks);
-	dus->s.time_in_queue	= le32_to_cpu(dus->s.time_in_queue);
+	dus->s.io_ticks		= le64_to_cpu(dus->s.io_ticks);
+	dus->s.time_in_queue	= le64_to_cpu(dus->s.time_in_queue);
 	dus->s.msec		= le64_to_cpu(dus->s.msec);
 }
 
diff --git a/diskutil.c b/diskutil.c
index 51da8a0..98ae2fe 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -62,14 +62,18 @@ static int get_io_ticks(struct disk_util *du, struct disk_util_stat *dus)
 
 	dprint(FD_DISKUTIL, "%s: %s", du->path, p);
 
-	ret = sscanf(p, "%u %u %llu %u %u %u %llu %u %u %u %u\n",
-					&dus->s.ios[0],
-					&dus->s.merges[0], &sectors[0],
-					&dus->s.ticks[0], &dus->s.ios[1],
-					&dus->s.merges[1], &sectors[1],
-					&dus->s.ticks[1], &in_flight,
-					&dus->s.io_ticks,
-					&dus->s.time_in_queue);
+	ret = sscanf(p, "%llu %llu %llu %llu %llu %llu %llu %llu %u %llu %llu\n",
+				(unsigned long long *) &dus->s.ios[0],
+				(unsigned long long *) &dus->s.merges[0],
+				&sectors[0],
+				(unsigned long long *) &dus->s.ticks[0],
+				(unsigned long long *) &dus->s.ios[1],
+				(unsigned long long *) &dus->s.merges[1],
+				&sectors[1],
+				(unsigned long long *) &dus->s.ticks[1],
+				&in_flight,
+				(unsigned long long *) &dus->s.io_ticks,
+				(unsigned long long *) &dus->s.time_in_queue);
 	fclose(f);
 	dprint(FD_DISKUTIL, "%s: stat read ok? %d\n", du->path, ret == 1);
 	dus->s.sectors[0] = sectors[0];
@@ -497,26 +501,27 @@ static void show_agg_stats(struct disk_util_agg *agg, int terse)
 		return;
 
 	if (!terse) {
-		log_info(", aggrios=%u/%u, aggrmerge=%u/%u, aggrticks=%u/%u,"
-				" aggrin_queue=%u, aggrutil=%3.2f%%",
-				agg->ios[0] / agg->slavecount,
-				agg->ios[1] / agg->slavecount,
-				agg->merges[0] / agg->slavecount,
-				agg->merges[1] / agg->slavecount,
-				agg->ticks[0] / agg->slavecount,
-				agg->ticks[1] / agg->slavecount,
-				agg->time_in_queue / agg->slavecount,
-				agg->max_util.u.f);
+		log_info(", aggrios=%llu/%llu, aggrmerge=%llu/%llu, "
+			 "aggrticks=%llu/%llu, aggrin_queue=%llu, "
+			 "aggrutil=%3.2f%%",
+			(unsigned long long) agg->ios[0] / agg->slavecount,
+			(unsigned long long) agg->ios[1] / agg->slavecount,
+			(unsigned long long) agg->merges[0] / agg->slavecount,
+			(unsigned long long) agg->merges[1] / agg->slavecount,
+			(unsigned long long) agg->ticks[0] / agg->slavecount,
+			(unsigned long long) agg->ticks[1] / agg->slavecount,
+			(unsigned long long) agg->time_in_queue / agg->slavecount,
+			agg->max_util.u.f);
 	} else {
-		log_info(";slaves;%u;%u;%u;%u;%u;%u;%u;%3.2f%%",
-				agg->ios[0] / agg->slavecount,
-				agg->ios[1] / agg->slavecount,
-				agg->merges[0] / agg->slavecount,
-				agg->merges[1] / agg->slavecount,
-				agg->ticks[0] / agg->slavecount,
-				agg->ticks[1] / agg->slavecount,
-				agg->time_in_queue / agg->slavecount,
-				agg->max_util.u.f);
+		log_info(";slaves;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
+			(unsigned long long) agg->ios[0] / agg->slavecount,
+			(unsigned long long) agg->ios[1] / agg->slavecount,
+			(unsigned long long) agg->merges[0] / agg->slavecount,
+			(unsigned long long) agg->merges[1] / agg->slavecount,
+			(unsigned long long) agg->ticks[0] / agg->slavecount,
+			(unsigned long long) agg->ticks[1] / agg->slavecount,
+			(unsigned long long) agg->time_in_queue / agg->slavecount,
+			agg->max_util.u.f);
 	}
 }
 
@@ -586,19 +591,28 @@ void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
 		if (agg->slavecount)
 			log_info("  ");
 
-		log_info("  %s: ios=%u/%u, merge=%u/%u, ticks=%u/%u, "
-			 "in_queue=%u, util=%3.2f%%", dus->name,
-					dus->s.ios[0], dus->s.ios[1],
-					dus->s.merges[0], dus->s.merges[1],
-					dus->s.ticks[0], dus->s.ticks[1],
-					dus->s.time_in_queue, util);
+		log_info("  %s: ios=%llu/%llu, merge=%llu/%llu, "
+			 "ticks=%llu/%llu, in_queue=%llu, util=%3.2f%%",
+				dus->name,
+				(unsigned long long) dus->s.ios[0],
+				(unsigned long long) dus->s.ios[1],
+				(unsigned long long) dus->s.merges[0],
+				(unsigned long long) dus->s.merges[1],
+				(unsigned long long) dus->s.ticks[0],
+				(unsigned long long) dus->s.ticks[1],
+				(unsigned long long) dus->s.time_in_queue,
+				util);
 	} else {
-		log_info(";%s;%u;%u;%u;%u;%u;%u;%u;%3.2f%%",
-					dus->name, dus->s.ios[0],
-					dus->s.ios[1], dus->s.merges[0],
-					dus->s.merges[1], dus->s.ticks[0],
-					dus->s.ticks[1],
-					dus->s.time_in_queue, util);
+		log_info(";%s;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
+				dus->name,
+				(unsigned long long) dus->s.ios[0],
+				(unsigned long long) dus->s.ios[1],
+				(unsigned long long) dus->s.merges[0],
+				(unsigned long long) dus->s.merges[1],
+				(unsigned long long) dus->s.ticks[0],
+				(unsigned long long) dus->s.ticks[1],
+				(unsigned long long) dus->s.time_in_queue,
+				util);
 	}
 
 	/*
diff --git a/diskutil.h b/diskutil.h
index 8623fd7..c0ae0ed 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -6,12 +6,12 @@
 extern volatile int helper_exit;
 
 struct disk_util_stats {
-	uint32_t ios[2];
-	uint32_t merges[2];
+	uint64_t ios[2];
+	uint64_t merges[2];
 	uint64_t sectors[2];
-	uint32_t ticks[2];
-	uint32_t io_ticks;
-	uint32_t time_in_queue;
+	uint64_t ticks[2];
+	uint64_t io_ticks;
+	uint64_t time_in_queue;
 	uint64_t msec;
 };
 
@@ -24,13 +24,14 @@ struct disk_util_stat {
 };
 
 struct disk_util_agg {
-	uint32_t ios[2];
-	uint32_t merges[2];
+	uint64_t ios[2];
+	uint64_t merges[2];
 	uint64_t sectors[2];
-	uint32_t ticks[2];
-	uint32_t io_ticks;
-	uint32_t time_in_queue;
+	uint64_t ticks[2];
+	uint64_t io_ticks;
+	uint64_t time_in_queue;
 	uint32_t slavecount;
+	uint32_t pad;
 	fio_fp64_t max_util;
 };
 
diff --git a/server.c b/server.c
index c4ab906..ede291f 100644
--- a/server.c
+++ b/server.c
@@ -1178,14 +1178,14 @@ static void convert_agg(struct disk_util_agg *dst, struct disk_util_agg *src)
 	int i;
 
 	for (i = 0; i < 2; i++) {
-		dst->ios[i]	= cpu_to_le32(src->ios[i]);
-		dst->merges[i]	= cpu_to_le32(src->merges[i]);
+		dst->ios[i]	= cpu_to_le64(src->ios[i]);
+		dst->merges[i]	= cpu_to_le64(src->merges[i]);
 		dst->sectors[i]	= cpu_to_le64(src->sectors[i]);
-		dst->ticks[i]	= cpu_to_le32(src->ticks[i]);
+		dst->ticks[i]	= cpu_to_le64(src->ticks[i]);
 	}
 
-	dst->io_ticks		= cpu_to_le32(src->io_ticks);
-	dst->time_in_queue	= cpu_to_le32(src->time_in_queue);
+	dst->io_ticks		= cpu_to_le64(src->io_ticks);
+	dst->time_in_queue	= cpu_to_le64(src->time_in_queue);
 	dst->slavecount		= cpu_to_le32(src->slavecount);
 	dst->max_util.u.i	= cpu_to_le64(fio_double_to_uint64(src->max_util.u.f));
 }
@@ -1198,14 +1198,14 @@ static void convert_dus(struct disk_util_stat *dst, struct disk_util_stat *src)
 	strncpy((char *) dst->name, (char *) src->name, FIO_DU_NAME_SZ - 1);
 
 	for (i = 0; i < 2; i++) {
-		dst->s.ios[i]		= cpu_to_le32(src->s.ios[i]);
-		dst->s.merges[i]	= cpu_to_le32(src->s.merges[i]);
+		dst->s.ios[i]		= cpu_to_le64(src->s.ios[i]);
+		dst->s.merges[i]	= cpu_to_le64(src->s.merges[i]);
 		dst->s.sectors[i]	= cpu_to_le64(src->s.sectors[i]);
-		dst->s.ticks[i]		= cpu_to_le32(src->s.ticks[i]);
+		dst->s.ticks[i]		= cpu_to_le64(src->s.ticks[i]);
 	}
 
-	dst->s.io_ticks		= cpu_to_le32(src->s.io_ticks);
-	dst->s.time_in_queue	= cpu_to_le32(src->s.time_in_queue);
+	dst->s.io_ticks		= cpu_to_le64(src->s.io_ticks);
+	dst->s.time_in_queue	= cpu_to_le64(src->s.time_in_queue);
 	dst->s.msec		= cpu_to_le64(src->s.msec);
 }
 
diff --git a/server.h b/server.h
index 84a06a1..0a98bf5 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 39,
+	FIO_SERVER_VER			= 40,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
