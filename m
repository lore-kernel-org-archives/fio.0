Return-Path: <prvs=845b5b8a0=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 4/5] HOWTO/man: Describe trim support by zone reset for zoned devices
Date: Fri,  6 Aug 2021 10:07:10 +0900
Message-Id: <20210806010711.1128153-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210806010711.1128153-1-shinichiro.kawasaki@wdc.com>
References: <20210806010711.1128153-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Previous commits added trim support for zoned devices. Update HOWTO and
man page to describe it. Also add missing description about libzbc I/O
engine to HOWTO.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 HOWTO | 8 ++++++++
 fio.1 | 9 +++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/HOWTO b/HOWTO
index d4e620de..04ea284b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -992,6 +992,9 @@ Target file/device
 				single zone. The :option:`zoneskip` parameter
 				is ignored. :option:`zonerange` and
 				:option:`zonesize` must be identical.
+				Trim is handled using a zone reset operation.
+				Trim only considers non-empty sequential write
+				required and sequential write preferred zones.
 
 .. option:: zonerange=int
 
@@ -1965,6 +1968,11 @@ I/O engine
 			character devices. This engine supports trim operations.
 			The sg engine includes engine specific options.
 
+		**libzbc**
+			Read, write, trim and ZBC/ZAC operations to a zoned
+			block device using libzbc library. The target can be
+			either an SG character device or a block device file.
+
 		**null**
 			Doesn't transfer any data, just pretends to.  This is mainly used to
 			exercise fio itself and for debugging/testing purposes.
diff --git a/fio.1 b/fio.1
index 9c12ad13..ff100a1c 100644
--- a/fio.1
+++ b/fio.1
@@ -766,6 +766,8 @@ starts. The \fBzonecapacity\fR parameter is ignored.
 Zoned block device mode. I/O happens sequentially in each zone, even if random
 I/O has been selected. Random I/O happens across all zones instead of being
 restricted to a single zone.
+Trim is handled using a zone reset operation. Trim only considers non-empty
+sequential write required and sequential write preferred zones.
 .RE
 .RE
 .TP
@@ -1761,10 +1763,9 @@ character devices. This engine supports trim operations. The
 sg engine includes engine specific options.
 .TP
 .B libzbc
-Synchronous I/O engine for SMR hard-disks using the \fBlibzbc\fR
-library. The target can be either an sg character device or
-a block device file. This engine supports the zonemode=zbd zone
-operations.
+Read, write, trim and ZBC/ZAC operations to a zoned block device using
+\fBlibzbc\fR library. The target can be either an SG character device or
+a block device file.
 .TP
 .B null
 Doesn't transfer any data, just pretends to. This is mainly used to
-- 
2.31.1


