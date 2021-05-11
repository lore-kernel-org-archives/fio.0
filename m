Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhEKMBO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 May 2021 08:01:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE49AC061574
        for <fio@vger.kernel.org>; Tue, 11 May 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgR3V-00HGPf-6y
        for fio@vger.kernel.org; Tue, 11 May 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210511120002.3C4831BC0115@kernel.dk>
Date: Tue, 11 May 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 79f488cbd95ca6989031a7ace5ec382313d31b3c:

  don't access dlclose'd dynamic ioengine object after close (2021-05-08 22:13:16 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to afa2cfb29b6c28b55d19f71f59287e43ecba80dd:

  Merge branch 'z_unit_docs' of https://github.com/ahribeng/fio (2021-05-10 21:16:58 -0600)

----------------------------------------------------------------
Gonzalez (1):
      Add Documentation for z unit

Jens Axboe (1):
      Merge branch 'z_unit_docs' of https://github.com/ahribeng/fio

Niklas Cassel (1):
      oslib/linux-blkzoned: make sure that we always support zone capacity

 HOWTO                  | 14 ++++++++++----
 fio.1                  | 26 +++++++++++++++++++-------
 oslib/linux-blkzoned.c | 33 +++++++++++++++++++++++++++++++--
 3 files changed, 60 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 889526d9..177310f6 100644
--- a/HOWTO
+++ b/HOWTO
@@ -544,6 +544,9 @@ Parameter types
 		* *Ti* -- means tebi (Ti) or 1024**4
 		* *Pi* -- means pebi (Pi) or 1024**5
 
+	For Zone Block Device Mode:
+	        * *z*  -- means Zone
+
 	With :option:`kb_base`\=1024 (the default), the unit prefixes are opposite
 	from those specified in the SI and IEC 80000-13 standards to provide
 	compatibility with old scripts.  For example, 4k means 4096.
@@ -1277,13 +1280,14 @@ I/O type
 .. option:: offset=int
 
 	Start I/O at the provided offset in the file, given as either a fixed size in
-	bytes or a percentage. If a percentage is given, the generated offset will be
+	bytes, zones or a percentage. If a percentage is given, the generated offset will be
 	aligned to the minimum ``blocksize`` or to the value of ``offset_align`` if
 	provided. Data before the given offset will not be touched. This
 	effectively caps the file size at `real_size - offset`. Can be combined with
 	:option:`size` to constrain the start and end range of the I/O workload.
 	A percentage can be specified by a number between 1 and 100 followed by '%',
-	for example, ``offset=20%`` to specify 20%.
+	for example, ``offset=20%`` to specify 20%. In ZBD mode, value can be set as 
+        number of zones using 'z'.
 
 .. option:: offset_align=int
 
@@ -1300,7 +1304,8 @@ I/O type
 	intended to operate on a file in parallel disjoint segments, with even
 	spacing between the starting points. Percentages can be used for this option.
 	If a percentage is given, the generated offset will be aligned to the minimum
-	``blocksize`` or to the value of ``offset_align`` if provided.
+	``blocksize`` or to the value of ``offset_align`` if provided. In ZBD mode, value can
+        also be set as number of zones using 'z'.
 
 .. option:: number_ios=int
 
@@ -1818,7 +1823,8 @@ I/O size
 	If this option is not specified, fio will use the full size of the given
 	files or devices.  If the files do not exist, size must be given. It is also
 	possible to give size as a percentage between 1 and 100. If ``size=20%`` is
-	given, fio will use 20% of the full size of the given files or devices.
+	given, fio will use 20% of the full size of the given files or devices. 
+	In ZBD mode, value can also be set as number of zones using 'z'.
 	Can be combined with :option:`offset` to constrain the start and end range
 	that I/O will be done within.
 
diff --git a/fio.1 b/fio.1
index c3916168..e7da5c68 100644
--- a/fio.1
+++ b/fio.1
@@ -288,6 +288,15 @@ Pi means pebi (Pi) or 1024**5
 .PD
 .RE
 .P
+For Zone Block Device Mode:
+.RS
+.P
+.PD 0
+z means Zone 
+.P
+.PD
+.RE
+.P
 With `kb_base=1024' (the default), the unit prefixes are opposite
 from those specified in the SI and IEC 80000-13 standards to provide
 compatibility with old scripts. For example, 4k means 4096.
@@ -1061,13 +1070,14 @@ should be associated with them.
 .TP
 .BI offset \fR=\fPint[%|z]
 Start I/O at the provided offset in the file, given as either a fixed size in
-bytes or a percentage. If a percentage is given, the generated offset will be
+bytes, zones or a percentage. If a percentage is given, the generated offset will be
 aligned to the minimum \fBblocksize\fR or to the value of \fBoffset_align\fR if
 provided. Data before the given offset will not be touched. This
 effectively caps the file size at `real_size \- offset'. Can be combined with
 \fBsize\fR to constrain the start and end range of the I/O workload.
 A percentage can be specified by a number between 1 and 100 followed by '%',
-for example, `offset=20%' to specify 20%.
+for example, `offset=20%' to specify 20%. In ZBD mode, value can be set as 
+number of zones using 'z'.
 .TP
 .BI offset_align \fR=\fPint
 If set to non-zero value, the byte offset generated by a percentage \fBoffset\fR
@@ -1082,7 +1092,8 @@ specified). This option is useful if there are several jobs which are
 intended to operate on a file in parallel disjoint segments, with even
 spacing between the starting points. Percentages can be used for this option.
 If a percentage is given, the generated offset will be aligned to the minimum
-\fBblocksize\fR or to the value of \fBoffset_align\fR if provided.
+\fBblocksize\fR or to the value of \fBoffset_align\fR if provided.In ZBD mode, value 
+can be set as number of zones using 'z'.
 .TP
 .BI number_ios \fR=\fPint
 Fio will normally perform I/Os until it has exhausted the size of the region
@@ -1607,9 +1618,9 @@ set to the physical size of the given files or devices if they exist.
 If this option is not specified, fio will use the full size of the given
 files or devices. If the files do not exist, size must be given. It is also
 possible to give size as a percentage between 1 and 100. If `size=20%' is
-given, fio will use 20% of the full size of the given files or devices.
-Can be combined with \fBoffset\fR to constrain the start and end range
-that I/O will be done within.
+given, fio will use 20% of the full size of the given files or devices. In ZBD mode,
+size can be given in units of number of zones using 'z'. Can be combined with \fBoffset\fR to 
+constrain the start and end range that I/O will be done within.
 .TP
 .BI io_size \fR=\fPint[%|z] "\fR,\fB io_limit" \fR=\fPint[%|z]
 Normally fio operates within the region set by \fBsize\fR, which means
@@ -1621,7 +1632,8 @@ will perform I/O within the first 20GiB but exit when 5GiB have been
 done. The opposite is also possible \-\- if \fBsize\fR is set to 20GiB,
 and \fBio_size\fR is set to 40GiB, then fio will do 40GiB of I/O within
 the 0..20GiB region. Value can be set as percentage: \fBio_size\fR=N%.
-In this case \fBio_size\fR multiplies \fBsize\fR= value.
+In this case \fBio_size\fR multiplies \fBsize\fR= value. In ZBD mode, value can
+also be set as number of zones using 'z'.
 .TP
 .BI filesize \fR=\fPirange(int)
 Individual file sizes. May be a range, in which case fio will select sizes
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index f37c67fc..81e4e7f0 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -23,6 +23,37 @@
 
 #include <linux/blkzoned.h>
 
+/*
+ * If the uapi headers installed on the system lacks zone capacity support,
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
  * Read up to 255 characters from the first line of a file. Strip the trailing
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
 

