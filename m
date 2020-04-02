Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Thu, 2 Apr 2020 22:21:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v3] fio: fix interaction between offset/size limited threads
 and "max_open_zones"
Message-ID: <20200402192102.GA4335@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

If thread bumps into "max_open_zones" limit, it tries to close/reopen some
other zone before issuing IO. This scan is done over full list of block device's
opened zones. It means that a zone which doesn't belong to thread's working
area can be altered or IO can be retargeted at such zone.

If IO is retargeted then it will be dropped by "is_valid_offset()" check.

What happens with null block device testing is that one thread monopolises
IO and others threads do basically nothing.

This config will reliably succeed now:

	[global]
	zonemode=zbd
	zonesize=1M
	rw=randwrite
		...
	thread
	numjobs=2
	offset_increment=128M

	[j]
	max_open_zones=2
	size=2M

Starting 2 threads
zbd      7991  /dev/nullb0: zbd model string: host-managed
zbd      7991  Device /dev/nullb0 has 1024 zones of size 1024 KB
zbd      8009  /dev/nullb0: examining zones 0 .. 2
zbd      8010  /dev/nullb0: examining zones 128 .. 130
zbd      8009  /dev/nullb0: opening zone 0
zbd      8010  /dev/nullb0: opening zone 128
zbd      8009  /dev/nullb0: queued I/O (0, 4096) for zone 0
zbd      8009  zbd_convert_to_open_zone(/dev/nullb0): starting from zone 128 (offset 1552384, buflen 4096)

	retargeted for other thread's zone	(zone 0 => zone 128)

zbd      8010  /dev/nullb0: queued I/O (134217728, 4096) for zone 128
zbd      8009  zbd_convert_to_open_zone(/dev/nullb0): returning zone 128
zbd      8009  Dropped request with offset 134221824

	and dropped

Note: quasi-randomness is kind of necessary to spread I/O. Imagine index 0
is picked all the time, zone living there will be reopened constantly and
get relatively little I/O.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@wdc.com>
---

 zbd.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

--- a/zbd.c
+++ b/zbd.c
@@ -945,6 +945,13 @@ static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
 	}
 }
 
+/* Anything goes as long as it is not a constant. */
+static uint32_t pick_random_zone_idx(const struct fio_file *f,
+				     const struct io_u *io_u)
+{
+	return io_u->offset * f->zbd_info->num_open_zones / f->real_file_size;
+}
+
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
@@ -969,9 +976,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		 * This statement accesses f->zbd_info->open_zones[] on purpose
 		 * without locking.
 		 */
-		zone_idx = f->zbd_info->open_zones[(io_u->offset -
-						    f->file_offset) *
-				f->zbd_info->num_open_zones / f->io_size];
+		zone_idx = f->zbd_info->open_zones[pick_random_zone_idx(f, io_u)];
 	} else {
 		zone_idx = zbd_zone_idx(f, io_u->offset);
 	}
@@ -985,6 +990,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	 * has been obtained. Hence the loop.
 	 */
 	for (;;) {
+		uint32_t tmp_idx;
+
 		z = &f->zbd_info->zone_info[zone_idx];
 
 		zone_lock(td, z);
@@ -998,9 +1005,35 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 			       __func__, f->file_name);
 			return NULL;
 		}
-		open_zone_idx = (io_u->offset - f->file_offset) *
-			f->zbd_info->num_open_zones / f->io_size;
+
+		/*
+		 * List of opened zones is per-device, shared across all threads.
+		 * Start with quasi-random candidate zone.
+		 * Ignore zones which don't belong to thread's offset/size area.
+		 */
+		open_zone_idx = pick_random_zone_idx(f, io_u);
 		assert(open_zone_idx < f->zbd_info->num_open_zones);
+		tmp_idx = open_zone_idx;
+		for (i = 0; i < f->zbd_info->num_open_zones; i++) {
+			uint32_t tmpz;
+
+			if (tmp_idx >= f->zbd_info->num_open_zones)
+				tmp_idx = 0;
+			tmpz = f->zbd_info->open_zones[tmp_idx];
+
+			if (is_valid_offset(f, f->zbd_info->zone_info[tmpz].start)) {
+				open_zone_idx = tmp_idx;
+				goto found_candidate_zone;
+			}
+
+			tmp_idx++;
+		}
+
+		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
+			__func__, f->file_name);
+		return NULL;
+
+found_candidate_zone:
 		new_zone_idx = f->zbd_info->open_zones[open_zone_idx];
 		if (new_zone_idx == zone_idx)
 			break;

