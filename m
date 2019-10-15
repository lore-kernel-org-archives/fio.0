Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/3] filesetup: use zonerange for map and LFSR with zonemode=strided
Date: Tue, 15 Oct 2019 10:29:57 -0400
Message-Id: <20191015142958.14559-3-vincentfu@gmail.com>
In-Reply-To: <20191015142958.14559-1-vincentfu@gmail.com>
References: <20191015142958.14559-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

When a random map is enabled, cover only the current zone when run with
zonemode=strided. This ensures that when we reach the end of the zone we
wrap around back into the current zone instead of accessing blocks
outside of the zone.

In addition, when an LFSR is used, constrain the blocks generated to the
current zone. Previously, the LFSR random_generator would ignore the
strided zonemode setting.

Fixes: https://github.com/axboe/fio/issues/809
---
 filesetup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/filesetup.c b/filesetup.c
index a439b6d6..1d3094c1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1338,6 +1338,9 @@ bool init_random_map(struct thread_data *td)
 	for_each_file(td, f, i) {
 		uint64_t fsize = min(f->real_file_size, f->io_size);
 
+		if (td->o.zone_mode == ZONE_MODE_STRIDED)
+			fsize = td->o.zone_range;
+
 		blocks = fsize / (unsigned long long) td->o.rw_min_bs;
 
 		if (check_rand_gen_limits(td, f, blocks))
-- 
2.17.1


