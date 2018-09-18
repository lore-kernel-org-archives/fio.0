Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52472 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeIRRcU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Sep 2018 13:32:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g2Efj-0002RA-2W
        for fio@vger.kernel.org; Tue, 18 Sep 2018 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180918120001.817C32C0311@kernel.dk>
Date: Tue, 18 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0f9f1921197d79fe5069473b9d85ca4559ef8c42:

  axmap: isset_fn() should use 1ULL, not 1UL (2018-09-16 21:58:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ed06087e5f4f5dcb6660d1095005c777bcd661cb:

  filesetup: use 64-bit type for file size generation (2018-09-17 13:46:51 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      zbd: fix various 32-bit compilation warnings
      Random distribution 32-bit fixes
      filesetup: use 64-bit type for file size generation

 filesetup.c |  6 +++---
 lib/zipf.c  | 12 +++++------
 lib/zipf.h  |  8 ++++----
 zbd.c       | 66 ++++++++++++++++++++++++++++++++++---------------------------
 4 files changed, 50 insertions(+), 42 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 580403d..c0fa3cd 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -331,7 +331,7 @@ unsigned long long get_rand_file_size(struct thread_data *td)
 {
 	unsigned long long ret, sized;
 	uint64_t frand_max;
-	unsigned long r;
+	uint64_t r;
 
 	frand_max = rand_max(&td->file_size_state);
 	r = __rand(&td->file_size_state);
@@ -1192,13 +1192,13 @@ bool pre_read_files(struct thread_data *td)
 static void __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 {
 	unsigned int range_size, seed;
-	unsigned long nranges;
+	uint64_t nranges;
 	uint64_t fsize;
 
 	range_size = min(td->o.min_bs[DDIR_READ], td->o.min_bs[DDIR_WRITE]);
 	fsize = min(f->real_file_size, f->io_size);
 
-	nranges = (fsize + range_size - 1) / range_size;
+	nranges = (fsize + range_size - 1ULL) / range_size;
 
 	seed = jhash(f->file_name, strlen(f->file_name), 0) * td->thread_number;
 	if (!td->o.rand_repeatable)
diff --git a/lib/zipf.c b/lib/zipf.c
index 1ff8568..321a4fb 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -8,7 +8,7 @@
 
 static void zipf_update(struct zipf_state *zs)
 {
-	unsigned long to_gen;
+	uint64_t to_gen;
 	unsigned int i;
 
 	/*
@@ -22,7 +22,7 @@ static void zipf_update(struct zipf_state *zs)
 		zs->zetan += pow(1.0 / (double) (i + 1), zs->theta);
 }
 
-static void shared_rand_init(struct zipf_state *zs, unsigned long nranges,
+static void shared_rand_init(struct zipf_state *zs, uint64_t nranges,
 			     unsigned int seed)
 {
 	memset(zs, 0, sizeof(*zs));
@@ -32,7 +32,7 @@ static void shared_rand_init(struct zipf_state *zs, unsigned long nranges,
 	zs->rand_off = __rand(&zs->rand);
 }
 
-void zipf_init(struct zipf_state *zs, unsigned long nranges, double theta,
+void zipf_init(struct zipf_state *zs, uint64_t nranges, double theta,
 	       unsigned int seed)
 {
 	shared_rand_init(zs, nranges, seed);
@@ -43,7 +43,7 @@ void zipf_init(struct zipf_state *zs, unsigned long nranges, double theta,
 	zipf_update(zs);
 }
 
-unsigned long long zipf_next(struct zipf_state *zs)
+uint64_t zipf_next(struct zipf_state *zs)
 {
 	double alpha, eta, rand_uni, rand_z;
 	unsigned long long n = zs->nranges;
@@ -70,14 +70,14 @@ unsigned long long zipf_next(struct zipf_state *zs)
 	return (val + zs->rand_off) % zs->nranges;
 }
 
-void pareto_init(struct zipf_state *zs, unsigned long nranges, double h,
+void pareto_init(struct zipf_state *zs, uint64_t nranges, double h,
 		 unsigned int seed)
 {
 	shared_rand_init(zs, nranges, seed);
 	zs->pareto_pow = log(h) / log(1.0 - h);
 }
 
-unsigned long long pareto_next(struct zipf_state *zs)
+uint64_t pareto_next(struct zipf_state *zs)
 {
 	double rand = (double) __rand(&zs->rand) / (double) FRAND32_MAX;
 	unsigned long long n;
diff --git a/lib/zipf.h b/lib/zipf.h
index a4aa163..16b65f5 100644
--- a/lib/zipf.h
+++ b/lib/zipf.h
@@ -16,11 +16,11 @@ struct zipf_state {
 	bool disable_hash;
 };
 
-void zipf_init(struct zipf_state *zs, unsigned long nranges, double theta, unsigned int seed);
-unsigned long long zipf_next(struct zipf_state *zs);
+void zipf_init(struct zipf_state *zs, uint64_t nranges, double theta, unsigned int seed);
+uint64_t zipf_next(struct zipf_state *zs);
 
-void pareto_init(struct zipf_state *zs, unsigned long nranges, double h, unsigned int seed);
-unsigned long long pareto_next(struct zipf_state *zs);
+void pareto_init(struct zipf_state *zs, uint64_t nranges, double h, unsigned int seed);
+uint64_t pareto_next(struct zipf_state *zs);
 void zipf_disable_hash(struct zipf_state *zs);
 
 #endif
diff --git a/zbd.c b/zbd.c
index 0f3636a..9c3092a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -128,9 +128,9 @@ static bool zbd_verify_sizes(void)
 						 f->file_name);
 					return false;
 				}
-				log_info("%s: rounded up offset from %lu to %lu\n",
-					 f->file_name, f->file_offset,
-					 new_offset);
+				log_info("%s: rounded up offset from %llu to %llu\n",
+					 f->file_name, (unsigned long long) f->file_offset,
+					 (unsigned long long) new_offset);
 				f->io_size -= (new_offset - f->file_offset);
 				f->file_offset = new_offset;
 			}
@@ -143,9 +143,9 @@ static bool zbd_verify_sizes(void)
 						 f->file_name);
 					return false;
 				}
-				log_info("%s: rounded down io_size from %lu to %lu\n",
-					 f->file_name, f->io_size,
-					 new_end - f->file_offset);
+				log_info("%s: rounded down io_size from %llu to %llu\n",
+					 f->file_name, (unsigned long long) f->io_size,
+					 (unsigned long long) new_end - f->file_offset);
 				f->io_size = new_end - f->file_offset;
 			}
 		}
@@ -357,14 +357,15 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	if (td->o.zone_size == 0) {
 		td->o.zone_size = zone_size;
 	} else if (td->o.zone_size != zone_size) {
-		log_info("fio: %s job parameter zonesize %lld does not match disk zone size %ld.\n",
-			 f->file_name, td->o.zone_size, zone_size);
+		log_info("fio: %s job parameter zonesize %llu does not match disk zone size %llu.\n",
+			 f->file_name, (unsigned long long) td->o.zone_size,
+			(unsigned long long) zone_size);
 		ret = -EINVAL;
 		goto close;
 	}
 
-	dprint(FD_ZBD, "Device %s has %d zones of size %lu KB\n", f->file_name,
-	       nr_zones, zone_size / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %llu KB\n", f->file_name,
+	       nr_zones, (unsigned long long) zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -407,8 +408,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			break;
 		ret = read_zone_info(fd, start_sector, buf, bufsz);
 		if (ret < 0) {
-			log_info("fio: BLKREPORTZONE(%lu) failed for %s (%d).\n",
-				 start_sector, f->file_name, -ret);
+			log_info("fio: BLKREPORTZONE(%llu) failed for %s (%d).\n",
+				 (unsigned long long) start_sector, f->file_name, -ret);
 			goto close;
 		}
 	}
@@ -602,6 +603,12 @@ static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
 	return ret;
 }
 
+static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
+				struct fio_zone_info *zone)
+{
+	return (uintptr_t) zone - (uintptr_t) zbd_info->zone_info;
+}
+
 /**
  * zbd_reset_zone - reset the write pointer of a single zone
  * @td: FIO thread data.
@@ -615,8 +622,8 @@ static int zbd_reset_zone(struct thread_data *td, const struct fio_file *f,
 {
 	int ret;
 
-	dprint(FD_ZBD, "%s: resetting wp of zone %lu.\n", f->file_name,
-	       z - f->zbd_info->zone_info);
+	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
+		zbd_zone_nr(f->zbd_info, z));
 	ret = zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
 	return ret;
 }
@@ -639,8 +646,8 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	bool reset_wp;
 	int res = 0;
 
-	dprint(FD_ZBD, "%s: examining zones %lu .. %lu\n", f->file_name,
-	       zb - f->zbd_info->zone_info, ze - f->zbd_info->zone_info);
+	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
+		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
@@ -653,10 +660,10 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 				start_z = z;
 			} else if (start_z < ze && !reset_wp) {
 				dprint(FD_ZBD,
-				       "%s: resetting zones %lu .. %lu\n",
+				       "%s: resetting zones %u .. %u\n",
 				       f->file_name,
-				       start_z - f->zbd_info->zone_info,
-				       z - f->zbd_info->zone_info);
+					zbd_zone_nr(f->zbd_info, start_z),
+					zbd_zone_nr(f->zbd_info, z));
 				if (zbd_reset_range(td, f, start_z->start,
 						z->start - start_z->start) < 0)
 					res = 1;
@@ -666,9 +673,9 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		default:
 			if (start_z == ze)
 				break;
-			dprint(FD_ZBD, "%s: resetting zones %lu .. %lu\n",
-			       f->file_name, start_z - f->zbd_info->zone_info,
-			       z - f->zbd_info->zone_info);
+			dprint(FD_ZBD, "%s: resetting zones %u .. %u\n",
+			       f->file_name, zbd_zone_nr(f->zbd_info, start_z),
+			       zbd_zone_nr(f->zbd_info, z));
 			if (zbd_reset_range(td, f, start_z->start,
 					    z->start - start_z->start) < 0)
 				res = 1;
@@ -677,9 +684,9 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		}
 	}
 	if (start_z < ze) {
-		dprint(FD_ZBD, "%s: resetting zones %lu .. %lu\n", f->file_name,
-		       start_z - f->zbd_info->zone_info,
-		       z - f->zbd_info->zone_info);
+		dprint(FD_ZBD, "%s: resetting zones %u .. %u\n", f->file_name,
+			zbd_zone_nr(f->zbd_info, start_z),
+			zbd_zone_nr(f->zbd_info, z));
 		if (zbd_reset_range(td, f, start_z->start,
 				    z->start - start_z->start) < 0)
 			res = 1;
@@ -765,7 +772,8 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	for (z = zb ; z < ze; z++)
 		pthread_mutex_unlock(&z->mutex);
-	dprint(FD_ZBD, "%s(%s): swd = %ld\n", __func__, f->file_name, swd);
+	dprint(FD_ZBD, "%s(%s): swd = %llu\n", __func__, f->file_name,
+		(unsigned long long) swd);
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
@@ -995,8 +1003,8 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	}
 
 	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
-		log_err("%s: %d * %d >= %ld\n", f->file_name, z->verify_block,
-			min_bs, f->zbd_info->zone_size);
+		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
+			min_bs, (unsigned long long) f->zbd_info->zone_size);
 	io_u->offset = z->start + z->verify_block++ * min_bs;
 	return z;
 }
@@ -1301,7 +1309,7 @@ char *zbd_write_status(const struct thread_stat *ts)
 {
 	char *res;
 
-	if (asprintf(&res, "; %ld zone resets", ts->nr_zone_resets) < 0)
+	if (asprintf(&res, "; %llu zone resets", (unsigned long long) ts->nr_zone_resets) < 0)
 		return NULL;
 	return res;
 }

