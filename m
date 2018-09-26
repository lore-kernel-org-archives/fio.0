Return-Path: <prvs=800592d6e=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] eta: Avoid adjustements to a negative value
Date: Wed, 26 Sep 2018 15:42:10 +0900
Message-Id: <20180926064210.2537-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

In the case of zonemode=strided job with both zone_size and zone_skip
specified, thread_eta() calculates the upper bound of the number of
zones that will be processed, including skipped bytes between zones
(zone_skip). Adjusting bytes_total (i.e. total_io_size) by substracting
this number of zones times the amount of skipped bytes can result in
a negative value for bytes_total (a large number of bytes) when for
example the job operates on an entire disk with a capacity that is not
divisible exactly by zone_size+zone_skip or if the options --size is
used to limit the I/O range. In such case, use the lower bound of the
number of zones to obtain a better approximation of the job eta.

Additionnally, if --io_size was specified, bytes_total will indicate
this exact value, so adjusting that value for zonemode != none is not
necessary.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 eta.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/eta.c b/eta.c
index 970a67df..b69dd194 100644
--- a/eta.c
+++ b/eta.c
@@ -177,12 +177,27 @@ static unsigned long thread_eta(struct thread_data *td)
 		bytes_total = td->fill_device_size;
 	}
 
-	if (td->o.zone_size && td->o.zone_skip && bytes_total) {
+	/*
+	 * If io_size is set, bytes_total is an exact value that does not need
+	 * adjustment.
+	 */
+	if (td->o.zone_size && td->o.zone_skip && bytes_total &&
+	    !fio_option_is_set(&td->o, io_size)) {
 		unsigned int nr_zones;
 		uint64_t zone_bytes;
 
-		zone_bytes = bytes_total + td->o.zone_size + td->o.zone_skip;
-		nr_zones = (zone_bytes - 1) / (td->o.zone_size + td->o.zone_skip);
+		/*
+		 * Calculate the upper bound of the number of zones that will
+		 * be processed, including skipped bytes between zones. If this
+		 * is larger than total_io_size (e.g. when --io_size or --size
+		 * specify a small value), use the lower bound to avoid
+		 * adjustments to a negative value that would result in a very
+		 * large bytes_total and an incorrect eta.
+		 */
+		zone_bytes = td->o.zone_size + td->o.zone_skip;
+		nr_zones = (bytes_total + zone_bytes - 1) / zone_bytes;
+		if (bytes_total < nr_zones * td->o.zone_skip)
+			nr_zones = bytes_total / zone_bytes;
 		bytes_total -= nr_zones * td->o.zone_skip;
 	}
 
-- 
2.17.1


