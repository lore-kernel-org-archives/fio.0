Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] HOWTO: add offset unit info for offset= option
Date: Tue, 27 Jun 2017 13:21:03 +0300
Message-Id: <20170627102103.13288-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add "in bytes" and "A percentage can be specified by ...",
based on an email post titled "in what units is offset option?".

-- example of offset in percentage
 # ./fio --debug=parse --name=xxxxx --ioengine=sync --rw=rw --size=1m --unlink=1 --offset=-51 | grep "SET start_offset_percent"
 parse    12859 SET start_offset_percent 50

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 2007dc0..8e11052 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1090,11 +1090,13 @@ I/O type
 
 .. option:: offset=int
 
-	Start I/O at the provided offset in the file, given as either a fixed size or
-	a percentage. If a percentage is given, the next ``blockalign``-ed offset
-	will be used. Data before the given offset will not be touched. This
+	Start I/O at the provided offset in the file, given as either a fixed size in
+	bytes or a percentage. If a percentage is given, the next ``blockalign``-ed
+	offset will be used. Data before the given offset will not be touched. This
 	effectively caps the file size at `real_size - offset`. Can be combined with
 	:option:`size` to constrain the start and end range of the I/O workload.
+	A percentage can be specified by the percentage number plus 1 with preceding '-'.
+	For example, -1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
 
 .. option:: offset_increment=int
 
-- 
2.9.4


