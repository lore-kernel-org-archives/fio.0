Return-Path: <prvs=7536bec58=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH] oslib/linux-blkzoned: make sure that we always support zone
 capacity
Date: Thu, 6 May 2021 13:18:45 +0000
Message-ID: <20210506131827.68407-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Matias Bjorling <Matias.Bjorling@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

A common problem is that users upgrade their kernel to support NVMe ZNS
devices, however, they still use the kernel uapi headers provided by their
distro.

This means that even if the kernel will populate the zone capacity fields
for each zone in the zone report returned by the ioctl, fio will not know
how to interpret that data.

This leads to fio writing past the zone capacity, which will lead to
I/O errors.

It is not trivial for a user to realize that the kernel uapi headers
provided by their distro is the reason for these I/O errors.

In order to make it easier for these users, provide a copy of the current
zoned block device kernel uapi structs.

If the kernel uapi headers installed on the system are too old to support
zone capacity, use the locally defined structs instead.
If the installed headers are new enough to support zone capacity, use the
installed headers.

This way, fio will always be able to handle zone capacity (if the kernel
supports it). At the same time, we will not redefine any structs from the
installed headers if they are newer than our locally defined structs.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 oslib/linux-blkzoned.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index f37c67fc..81e4e7f0 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -23,6 +23,37 @@
=20
 #include <linux/blkzoned.h>
=20
+/*
+ * If the uapi headers installed on the system lacks zone capacity support=
,
+ * use our local versions. If the installed headers are recent enough to
+ * support zone capacity, do not redefine any structs.
+ */
+#ifndef CONFIG_HAVE_REP_CAPACITY
+#define BLK_ZONE_REP_CAPACITY	(1 << 0)
+
+struct blk_zone_v2 {
+	__u64	start;          /* Zone start sector */
+	__u64	len;            /* Zone length in number of sectors */
+	__u64	wp;             /* Zone write pointer position */
+	__u8	type;           /* Zone type */
+	__u8	cond;           /* Zone condition */
+	__u8	non_seq;        /* Non-sequential write resources active */
+	__u8	reset;          /* Reset write pointer recommended */
+	__u8	resv[4];
+	__u64	capacity;       /* Zone capacity in number of sectors */
+	__u8	reserved[24];
+};
+#define blk_zone blk_zone_v2
+
+struct blk_zone_report_v2 {
+	__u64	sector;
+	__u32	nr_zones;
+	__u32	flags;
+struct blk_zone zones[0];
+};
+#define blk_zone_report blk_zone_report_v2
+#endif /* CONFIG_HAVE_REP_CAPACITY */
+
 /*
  * Read up to 255 characters from the first line of a file. Strip the trai=
ling
  * newline.
@@ -116,10 +147,8 @@ out:
 static uint64_t zone_capacity(struct blk_zone_report *hdr,
 			      struct blk_zone *blkz)
 {
-#ifdef CONFIG_HAVE_REP_CAPACITY
 	if (hdr->flags & BLK_ZONE_REP_CAPACITY)
 		return blkz->capacity << 9;
-#endif
 	return blkz->len << 9;
 }
=20
--=20
2.25.1

