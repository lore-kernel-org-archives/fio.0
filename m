Return-Path: <plabat@micron.com>
From: <plabat@micron.com>
Subject: [PATCH] Allow sequential read to start anywhere in a zone (option offset), and have a span smaller than a zone (option size).
Date: Fri, 15 May 2020 11:22:13 -0500
Message-ID: <20200515162213.1035-1-plabat@micron.com>
MIME-Version: 1.0
Content-Type: text/plain
Return-Path: plabat@micron.com
To: damien.lemoal@wdc.com
Cc: axboe@kernel.dk, fio@vger.kernel.org, Pierre Labat <plabat@micron.com>
List-ID: <fio@vger.kernel.org>

From: Pierre Labat <plabat@micron.com>

Allow sequential read to start anywhere in a zone (option
offset), and have a span smaller than a zone (option size).

A use case is a Key Value Store reading a set of keys or values
starting somewhere in a zone.

Signed-off-by: Pierre Labat <plabat@micron.com>
---
 zbd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 8dc3c39..f1f7c5c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -262,7 +262,8 @@ static bool zbd_verify_sizes(void)
 
 			zone_idx = zbd_zone_idx(f, f->file_offset);
 			z = &f->zbd_info->zone_info[zone_idx];
-			if (f->file_offset != z->start) {
+			if ((f->file_offset != z->start) &&
+			    (td->o.td_ddir != TD_DDIR_READ)) {
 				new_offset = (z+1)->start;
 				if (new_offset >= f->file_offset + f->io_size) {
 					log_info("%s: io_size must be at least one zone\n",
@@ -278,7 +279,8 @@ static bool zbd_verify_sizes(void)
 			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
 			z = &f->zbd_info->zone_info[zone_idx];
 			new_end = z->start;
-			if (f->file_offset + f->io_size != new_end) {
+			if ((td->o.td_ddir != TD_DDIR_READ) &&
+			    (f->file_offset + f->io_size != new_end)) {
 				if (new_end <= f->file_offset) {
 					log_info("%s: io_size must be at least one zone\n",
 						 f->file_name);
-- 
2.9.5


