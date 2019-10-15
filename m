Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/3] io_u: skip to the next zone when zoneskip is set to zero
Date: Tue, 15 Oct 2019 10:29:56 -0400
Message-Id: <20191015142958.14559-2-vincentfu@gmail.com>
In-Reply-To: <20191015142958.14559-1-vincentfu@gmail.com>
References: <20191015142958.14559-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

If zoneskip is not set or set to 0 in zonemode=strided mode, all IO
occurs in a single zone. If zoneskip is non-zero, the next zone begins
zoneskip bytes beyond the end of the current zone. Thus, it's not
possible to access contiguous zones since zoneskip bytes will separate
the end of one zone and the beginning of the next zone.

This patch allows fio to move to the next zone when zoneskip is
explicitly set to 0, making it possible to issue IO to contiguous zones.
---
 io_u.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index 94899552..5cbbe85a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -850,7 +850,8 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * See if it's time to switch to a new zone
 	 */
-	if (td->zone_bytes >= td->o.zone_size && td->o.zone_skip) {
+	if (td->zone_bytes >= td->o.zone_size &&
+			fio_option_is_set(&td->o, zone_skip)) {
 		td->zone_bytes = 0;
 		f->file_offset += td->o.zone_range + td->o.zone_skip;
 
-- 
2.17.1


