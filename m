Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97465EB64DC
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 12:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjGUMAU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjGUMAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 08:00:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A80171B
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ExGmnFHdLctQfqtjbR7hX4M03vlTJfNTtqHxvkdBb+c=; b=gO7kql97QcwhFu0yQ56QQRwRbk
        fEwfSA27C0uWmxe4iQLlWYtljtOLS8Tm2gmkl6HMiCpTK+MJvS9l/Yv5dFY01gVPu4kkOBqe0pyj3
        gyCRJxU3zBDRr08NCVpMKFZqFtYoM5YSXcX2oKYl8lIq4CP5rp+moyUKd02KZ8WsHHc0vnvF4mm1o
        mZ36pXxcD2i7SxRr15EeVtJMj6IwnUz4RepvzpTiSpZMjf4An00PK0CrsY7f4/I/kXjEkZQerNDvS
        KFxT7RN7mmKIPmmiQOC2sl/DcarycPeZZeDlUt2+/1wViACTrag9FaokqWOfi6flVrkKN0bU6XdOP
        YJPEctIQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qMonp-0002p9-21
        for fio@vger.kernel.org;
        Fri, 21 Jul 2023 12:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9BE0D1BC0158; Fri, 21 Jul 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230721120001.9BE0D1BC0158@kernel.dk>
Date:   Fri, 21 Jul 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 04361e9a23d6e0448fd6fbbd4e14ecdfff60e314:

  Merge branch 'patch-3' of https://github.com/yangjueji/fio (2023-07-15 09:57:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to caf7ac7ef000097765b1c56404adb5e68b227977:

  t/zbd: add max_active configs to run-tests-against-nullb (2023-07-20 09:52:37 -0400)

----------------------------------------------------------------
Dmitry Fomichev (2):
      t/zbd: fix null_blk configuration in run-tests-against-nullb
      t/zbd: add max_active configs to run-tests-against-nullb

Shin'ichiro Kawasaki (11):
      zbd: get max_active_zones limit value from zoned devices
      zbd: write to closed zones on the devices with max_active_zones limit
      zbd: print max_active_zones limit error message
      docs: modify max_open_zones option description
      t/zbd: add close_zone helper function
      t/zbd: add max_active_zone variable
      t/zbd: add test case to check zones in closed condition
      t/zbd: add test case to check max_active_zones limit error message
      t/zbd: get max_open_zones from sysfs
      t/zbd: fix fio failure check and SG node failure in test case 31
      t/zbd: add missing prep_write for test cases with write workloads

 HOWTO.rst                     |  44 +++++----
 fio.1                         |  36 +++++---
 io_u.c                        |   2 +
 ioengines.h                   |   4 +-
 oslib/blkzoned.h              |   9 ++
 oslib/linux-blkzoned.c        |  23 +++++
 t/zbd/functions               |  33 ++++++-
 t/zbd/run-tests-against-nullb | 203 ++++++++++++++++++++++++++++++++++++++++--
 t/zbd/test-zbd-support        |  91 ++++++++++++++++++-
 zbd.c                         |  47 +++++++++-
 zbd.h                         |   5 ++
 11 files changed, 457 insertions(+), 40 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 7ae8ea7b..7fe70fbd 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1056,22 +1056,34 @@ Target file/device
 
 .. option:: max_open_zones=int
 
-	A zone of a zoned block device is in the open state when it is partially
-	written (i.e. not all sectors of the zone have been written). Zoned
-	block devices may have a limit on the total number of zones that can
-	be simultaneously in the open state, that is, the number of zones that
-	can be written to simultaneously. The :option:`max_open_zones` parameter
-	limits the number of zones to which write commands are issued by all fio
-	jobs, that is, limits the number of zones that will be in the open
-	state. This parameter is relevant only if the :option:`zonemode` =zbd is
-	used. The default value is always equal to maximum number of open zones
-	of the target zoned block device and a value higher than this limit
-	cannot be specified by users unless the option
-	:option:`ignore_zone_limits` is specified. When
-	:option:`ignore_zone_limits` is specified or the target device has no
-	limit on the number of zones that can be in an open state,
-	:option:`max_open_zones` can specify 0 to disable any limit on the
-	number of zones that can be simultaneously written to by all jobs.
+	When a zone of a zoned block device is partially written (i.e. not all
+	sectors of the zone have been written), the zone is in one of three
+	conditions: 'implicit open', 'explicit open' or 'closed'. Zoned block
+	devices may have a limit called 'max_open_zones' (same name as the
+	parameter) on the total number of zones that can simultaneously be in
+	the 'implicit open' or 'explicit open' conditions. Zoned block devices
+	may have another limit called 'max_active_zones', on the total number of
+	zones that can simultaneously be in the three conditions. The
+	:option:`max_open_zones` parameter limits the number of zones to which
+	write commands are issued by all fio jobs, that is, limits the number of
+	zones that will be in the conditions. When the device has the
+	max_open_zones limit and does not have the max_active_zones limit, the
+	:option:`max_open_zones` parameter limits the number of zones in the two
+	open conditions up to the limit. In this case, fio includes zones in the
+	two open conditions to the write target zones at fio start. When the
+	device has both the max_open_zones and the max_active_zones limits, the
+	:option:`max_open_zones` parameter limits the number of zones in the
+	three conditions up to the limit. In this case, fio includes zones in
+	the three conditions to the write target zones at fio start.
+
+	This parameter is relevant only if the :option:`zonemode` =zbd is used.
+	The default value is always equal to the max_open_zones limit of the
+	target zoned block device and a value higher than this limit cannot be
+	specified by users unless the option :option:`ignore_zone_limits` is
+	specified. When :option:`ignore_zone_limits` is specified or the target
+	device does not have the max_open_zones limit, :option:`max_open_zones`
+	can specify 0 to disable any limit on the number of zones that can be
+	simultaneously written to by all jobs.
 
 .. option:: job_max_open_zones=int
 
diff --git a/fio.1 b/fio.1
index da875276..20acd081 100644
--- a/fio.1
+++ b/fio.1
@@ -832,18 +832,30 @@ numbers fio only reads beyond the write pointer if explicitly told to do
 so. Default: false.
 .TP
 .BI max_open_zones \fR=\fPint
-A zone of a zoned block device is in the open state when it is partially written
-(i.e. not all sectors of the zone have been written). Zoned block devices may
-have limit a on the total number of zones that can be simultaneously in the
-open state, that is, the number of zones that can be written to simultaneously.
-The \fBmax_open_zones\fR parameter limits the number of zones to which write
-commands are issued by all fio jobs, that is, limits the number of zones that
-will be in the open state. This parameter is relevant only if the
-\fBzonemode=zbd\fR is used. The default value is always equal to maximum number
-of open zones of the target zoned block device and a value higher than this
-limit cannot be specified by users unless the option \fBignore_zone_limits\fR is
-specified. When \fBignore_zone_limits\fR is specified or the target device has
-no limit on the number of zones that can be in an open state,
+When a zone of a zoned block device is partially written (i.e. not all sectors
+of the zone have been written), the zone is in one of three
+conditions: 'implicit open', 'explicit open' or 'closed'. Zoned block devices
+may have a limit called 'max_open_zones' (same name as the parameter) on the
+total number of zones that can simultaneously be in the 'implicit open'
+or 'explicit open' conditions. Zoned block devices may have another limit
+called 'max_active_zones', on the total number of zones that can simultaneously
+be in the three conditions. The \fBmax_open_zones\fR parameter limits
+the number of zones to which write commands are issued by all fio jobs, that is,
+limits the number of zones that will be in the conditions. When the device has
+the max_open_zones limit and does not have the max_active_zones limit, the
+\fBmax_open_zones\fR parameter limits the number of zones in the two open
+conditions up to the limit. In this case, fio includes zones in the two open
+conditions to the write target zones at fio start. When the device has both the
+max_open_zones and the max_active_zones limits, the \fBmax_open_zones\fR
+parameter limits the number of zones in the three conditions up to the limit.
+In this case, fio includes zones in the three conditions to the write target
+zones at fio start.
+
+This parameter is relevant only if the \fBzonemode=zbd\fR is used. The default
+value is always equal to the max_open_zones limit of the target zoned block
+device and a value higher than this limit cannot be specified by users unless
+the option \fBignore_zone_limits\fR is specified. When \fBignore_zone_limits\fR
+is specified or the target device does not have the max_open_zones limit,
 \fBmax_open_zones\fR can specify 0 to disable any limit on the number of zones
 that can be simultaneously written to by all jobs.
 .TP
diff --git a/io_u.c b/io_u.c
index 27b6c92a..07e5bac5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1879,6 +1879,8 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 		io_ddir_name(io_u->ddir),
 		io_u->offset, io_u->xfer_buflen);
 
+	zbd_log_err(td, io_u);
+
 	if (td->io_ops->errdetails) {
 		char *err = td->io_ops->errdetails(io_u);
 
diff --git a/ioengines.h b/ioengines.h
index 9484265e..4391b31e 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "fdp.h"
 
-#define FIO_IOOPS_VERSION	32
+#define FIO_IOOPS_VERSION	33
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -62,6 +62,8 @@ struct ioengine_ops {
 			uint64_t, uint64_t);
 	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
 				  unsigned int *);
+	int (*get_max_active_zones)(struct thread_data *, struct fio_file *,
+				    unsigned int *);
 	int (*finish_zone)(struct thread_data *, struct fio_file *,
 			   uint64_t, uint64_t);
 	int (*fdp_fetch_ruhs)(struct thread_data *, struct fio_file *,
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 29fb034f..e598bd4f 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -18,6 +18,9 @@ extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				       unsigned int *max_open_zones);
+extern int blkzoned_get_max_active_zones(struct thread_data *td,
+					 struct fio_file *f,
+					 unsigned int *max_active_zones);
 extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 #else
@@ -53,6 +56,12 @@ static inline int blkzoned_get_max_open_zones(struct thread_data *td, struct fio
 {
 	return -EIO;
 }
+static inline int blkzoned_get_max_active_zones(struct thread_data *td,
+						struct fio_file *f,
+						unsigned int *max_open_zones)
+{
+	return -EIO;
+}
 static inline int blkzoned_finish_zone(struct thread_data *td,
 				       struct fio_file *f,
 				       uint64_t offset, uint64_t length)
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 722e0992..2c3ecf33 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -186,6 +186,29 @@ int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 	return 0;
 }
 
+int blkzoned_get_max_active_zones(struct thread_data *td, struct fio_file *f,
+				  unsigned int *max_active_zones)
+{
+	char *max_active_str;
+
+	if (f->filetype != FIO_TYPE_BLOCK)
+		return -EIO;
+
+	max_active_str = blkzoned_get_sysfs_attr(f->file_name, "queue/max_active_zones");
+	if (!max_active_str) {
+		*max_active_zones = 0;
+		return 0;
+	}
+
+	dprint(FD_ZBD, "%s: max active zones supported by device: %s\n",
+	       f->file_name, max_active_str);
+	*max_active_zones = atoll(max_active_str);
+
+	free(max_active_str);
+
+	return 0;
+}
+
 static uint64_t zone_capacity(struct blk_zone_report *hdr,
 			      struct blk_zone *blkz)
 {
diff --git a/t/zbd/functions b/t/zbd/functions
index 9a6d6999..4faa45a9 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -4,6 +4,7 @@ blkzone=$(type -p blkzone 2>/dev/null)
 sg_inq=$(type -p sg_inq 2>/dev/null)
 zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
 zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
+zbc_close_zone=$(type -p zbc_close_zone 2>/dev/null)
 zbc_info=$(type -p zbc_info 2>/dev/null)
 if [ -z "${blkzone}" ] &&
        { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ]; }; then
@@ -211,8 +212,14 @@ last_online_zone() {
 # max_open_zones in sysfs, or which lacks zoned block device support completely.
 max_open_zones() {
     local dev=$1
+    local realdev syspath
 
-    if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
+    realdev=$(readlink -f "$dev")
+    syspath=/sys/block/${realdev##*/}/queue/max_open_zones
+
+    if [ -b "${realdev}" ] && [ -r "${syspath}" ]; then
+	cat ${syspath}
+    elif [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
 	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" \
 		 > /dev/null 2>&1; then
 	    # When sg_inq can not get max open zones, specify 0 which indicates
@@ -238,6 +245,18 @@ max_open_zones() {
     fi
 }
 
+# If sysfs provides, get max_active_zones limit of the zoned block device.
+max_active_zones() {
+	local dev=$1
+	local sys_queue="/sys/block/${dev##*/}/queue/"
+
+	if [[ -e "$sys_queue/max_active_zones" ]]; then
+		cat "$sys_queue/max_active_zones"
+		return
+	fi
+	echo 0
+}
+
 # Get minimum block size to write to seq zones. Refer the sysfs attribute
 # zone_write_granularity which shows the valid minimum size regardless of zoned
 # block device type. If the sysfs attribute is not available, refer physical
@@ -304,6 +323,18 @@ reset_zone() {
     fi
 }
 
+# Close the zone on device $1 at offset $2. The offset must be specified in
+# units of 512 byte sectors.
+close_zone() {
+	local dev=$1 offset=$2
+
+	if [ -n "${blkzone}" ] && [ -z "${use_libzbc}" ]; then
+		${blkzone} close -o "${offset}" -c 1 "$dev"
+	else
+		${zbc_close_zone} -sector "$dev" "${offset}" >/dev/null
+	fi
+}
+
 # Extract the number of bytes that have been transferred from a line like
 # READ: bw=6847KiB/s (7011kB/s), 6847KiB/s-6847KiB/s (7011kB/s-7011kB/s), io=257MiB (269MB), run=38406-38406msec
 fio_io() {
diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 7d2c7fa8..97d29966 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -67,13 +67,27 @@ configure_nullb()
 			fi
 			echo "${zone_capacity}" > zone_capacity
 		fi
+
 		if ((conv_pcnt)); then
 			if ((!conv_supported)); then
 				echo "null_blk does not support conventional zones"
 				return 2
 			fi
 			nr_conv=$((dev_size/zone_size*conv_pcnt/100))
-			echo "${nr_conv}" > zone_nr_conv
+		else
+			nr_conv=0
+		fi
+		echo "${nr_conv}" > zone_nr_conv
+
+		if ((max_open)); then
+			echo "${max_open}" > zone_max_open
+			if ((max_active)); then
+				if ((!max_act_supported)); then
+					echo "null_blk does not support active zone counts"
+					return 2
+				fi
+				echo "${max_active}" > zone_max_active
+			fi
 		fi
 	fi
 
@@ -90,6 +104,11 @@ show_nullb_config()
 		echo "    $(printf "Zone Capacity: %d MB" ${zone_capacity})"
 		if ((max_open)); then
 			echo "    $(printf "Max Open: %d Zones" ${max_open})"
+			if ((max_active)); then
+				echo "    $(printf "Max Active: %d Zones" ${max_active})"
+			else
+				echo "    Max Active: Unlimited Zones"
+			fi
 		else
 			echo "    Max Open: Unlimited Zones"
 		fi
@@ -124,6 +143,7 @@ section3()
 	zone_size=4
 	zone_capacity=3
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly sequential zones, ZCAP == ZSIZE, unlimited MaxOpen.
@@ -133,6 +153,7 @@ section4()
 	zone_size=1
 	zone_capacity=1
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly sequential zones, ZCAP < ZSIZE, unlimited MaxOpen.
@@ -142,6 +163,7 @@ section5()
 	zone_size=4
 	zone_capacity=3
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly conventional zones, ZCAP == ZSIZE, unlimited MaxOpen.
@@ -151,6 +173,7 @@ section6()
 	zone_size=1
 	zone_capacity=1
 	max_open=0
+	max_active=0
 }
 
 # Zoned device with mostly conventional zones, ZCAP < ZSIZE, unlimited MaxOpen.
@@ -161,9 +184,11 @@ section7()
 	zone_size=4
 	zone_capacity=3
 	max_open=0
+	max_active=0
 }
 
-# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen.
+# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section8()
 {
 	dev_size=1024
@@ -172,9 +197,11 @@ section8()
 	zone_capacity=1
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen.
+# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section9()
 {
 	conv_pcnt=0
@@ -182,9 +209,11 @@ section9()
 	zone_capacity=3
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen.
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section10()
 {
 	conv_pcnt=10
@@ -192,9 +221,11 @@ section10()
 	zone_capacity=1
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen.
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section11()
 {
 	conv_pcnt=10
@@ -202,9 +233,11 @@ section11()
 	zone_capacity=3
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen.
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section12()
 {
 	conv_pcnt=66
@@ -212,9 +245,11 @@ section12()
 	zone_capacity=1
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
 }
 
-# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen.
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# unlimited MaxActive.
 section13()
 {
 	dev_size=2048
@@ -223,6 +258,155 @@ section13()
 	zone_capacity=3
 	max_open=${set_max_open}
 	zbd_test_opts+=("-o ${max_open}")
+	max_active=0
+}
+
+# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section14()
+{
+	dev_size=1024
+	conv_pcnt=0
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section15()
+{
+	conv_pcnt=0
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section16()
+{
+	conv_pcnt=10
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section17()
+{
+	conv_pcnt=10
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section18()
+{
+	conv_pcnt=66
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive == MaxOpen.
+section19()
+{
+	dev_size=2048
+	conv_pcnt=66
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=${set_max_open}
+}
+
+# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section20()
+{
+	dev_size=1024
+	conv_pcnt=0
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section21()
+{
+	conv_pcnt=0
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section22()
+{
+	conv_pcnt=10
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section23()
+{
+	conv_pcnt=10
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section24()
+{
+	conv_pcnt=66
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
+}
+
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen,
+# MaxActive > MaxOpen.
+section25()
+{
+	dev_size=2048
+	conv_pcnt=66
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+	max_active=$((set_max_open+set_extra_max_active))
 }
 
 #
@@ -233,10 +417,12 @@ scriptdir="$(cd "$(dirname "$0")" && pwd)"
 sections=()
 zcap_supported=1
 conv_supported=1
+max_act_supported=1
 list_only=0
 dev_size=1024
 dev_blocksize=4096
 set_max_open=8
+set_extra_max_active=2
 zbd_test_opts=()
 num_of_runs=1
 test_case=0
@@ -276,6 +462,9 @@ fi
 if ! cat /sys/kernel/config/nullb/features | grep -q zone_nr_conv; then
 	conv_supported=0
 fi
+if ! cat /sys/kernel/config/nullb/features | grep -q zone_max_active; then
+	max_act_supported=0
+fi
 
 rc=0
 test_rc=0
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index a3d37a7d..c8f3eb61 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -272,6 +272,20 @@ require_max_open_zones() {
 	return 0
 }
 
+require_max_active_zones() {
+	local min=${1}
+
+	if ((max_active_zones == 0)); then
+		SKIP_REASON="$dev does not have max_active_zones limit"
+		return 1
+	fi
+	if ((max_active_zones < min)); then
+		SKIP_REASON="max_active_zones of $dev is smaller than $min"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -780,9 +794,10 @@ test31() {
     opts=("--name=$dev" "--filename=$dev" "--rw=write" "--bs=${bs}")
     opts+=("--offset=$off" "--size=$((inc * nz))" "--io_size=$((bs * nz))")
     opts+=("--zonemode=strided" "--zonesize=${bs}" "--zonerange=${inc}")
-    opts+=("--direct=1")
+    opts+=("--direct=1" "$(ioengine "psync")")
     echo "fio ${opts[@]}" >> "${logfile}.${test_number}"
-    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
+    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" \
+				2>&1 || return $?
 
     # Next, run the test.
     opts=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
@@ -1182,6 +1197,7 @@ test54() {
 	require_zbd || return $SKIP_TESTCASE
 	require_seq_zones 8 || return $SKIP_TESTCASE
 
+	prep_write
 	run_fio --name=job --filename=${dev} "$(ioengine "libaio")" \
 		--time_based=1 --runtime=30s --continue_on_error=0 \
 		--offset=$((first_sequential_zone_sector * 512)) \
@@ -1203,6 +1219,7 @@ test55() {
 	# offset=1z + offset_increment=10z + size=2z
 	require_seq_zones 13 || return $SKIP_TESTCASE
 
+	prep_write
 	run_fio	--name=j		\
 		--filename=${dev}	\
 		--direct=1		\
@@ -1228,6 +1245,7 @@ test56() {
 	require_regular_block_dev || return $SKIP_TESTCASE
 	require_seq_zones 10 || return $SKIP_TESTCASE
 
+	prep_write
 	run_fio	--name=j		\
 		--filename=${dev}	\
 		--direct=1		\
@@ -1249,6 +1267,7 @@ test57() {
 
 	require_zbd || return $SKIP_TESTCASE
 
+	prep_write
 	bs=$((4096 * 7))
 	off=$((first_sequential_zone_sector * 512))
 
@@ -1413,6 +1432,71 @@ test65() {
 	check_written $((zone_size + capacity))
 }
 
+# Test closed zones are handled as open zones. This test case requires zoned
+# block devices which has same max_open_zones and max_active_zones.
+test66() {
+	local i off
+
+	require_zbd || return $SKIP_TESTCASE
+	require_max_active_zones 2 || return $SKIP_TESTCASE
+	require_max_open_zones "${max_active_zones}" || return $SKIP_TESTCASE
+	require_seq_zones $((max_active_zones * 16)) || return $SKIP_TESTCASE
+
+	reset_zone "$dev" -1
+
+	# Prepare max_active_zones in closed condition.
+	off=$((first_sequential_zone_sector * 512))
+	run_fio --name=w --filename="$dev" --zonemod=zbd --direct=1 \
+		--offset=$((off)) --zonesize="${zone_size}" --rw=randwrite \
+		--bs=4096 --size="$((zone_size * max_active_zones))" \
+		--io_size="${zone_size}" "$(ioengine "psync")" \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+	for ((i = 0; i < max_active_zones; i++)); do
+		close_zone "$dev" $((off / 512)) || return $?
+		off=$((off + zone_size))
+	done
+
+	# Run random write to the closed zones and empty zones. This confirms
+	# that fio handles closed zones as write target open zones. Otherwise,
+	# fio writes to the empty zones and hit the max_active_zones limit.
+	off=$((first_sequential_zone_sector * 512))
+	run_one_fio_job --zonemod=zbd --direct=1 \
+		       "$(ioengine "psync")" --rw=randwrite --bs=4096 \
+		       --max_open_zones="$max_active_zones" --offset=$((off)) \
+		       --size=$((max_active_zones * 16 * zone_size)) \
+		       --io_size=$((zone_size)) --zonesize="${zone_size}" \
+		       --time_based --runtime=5s \
+		       >> "${logfile}.${test_number}" 2>&1
+}
+
+# Test max_active_zones limit failure is reported with good error message.
+test67() {
+	local i off
+
+	require_zbd || return $SKIP_TESTCASE
+	require_max_active_zones 2 || return $SKIP_TESTCASE
+	require_max_open_zones "${max_active_zones}" || return $SKIP_TESTCASE
+	require_seq_zones $((max_active_zones + 1)) || return $SKIP_TESTCASE
+
+	reset_zone "$dev" -1
+
+	# Prepare max_active_zones in open condition.
+	off=$((first_sequential_zone_sector * 512))
+	run_fio --name=w --filename="$dev" --zonemod=zbd --direct=1 \
+		--offset=$((off)) --zonesize="${zone_size}" --rw=randwrite \
+		--bs=4096 --size="$((zone_size * max_active_zones))" \
+		--io_size="${zone_size}" "$(ioengine "psync")" \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+
+	# Write to antoher zone and trigger max_active_zones limit error.
+	off=$((off + zone_size * max_active_zones))
+	run_one_fio_job --zonemod=zbd --direct=1 "$(ioengine "psync")" \
+			--rw=write --bs=$min_seq_write_size --offset=$((off)) \
+			--size=$((zone_size)) --zonesize="${zone_size}" \
+			>> "${logfile}.${test_number}" 2>&1 && return $?
+	grep -q 'Exceeded max_active_zones limit' "${logfile}.${test_number}"
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
@@ -1497,6 +1581,7 @@ if [[ -b "$realdev" ]]; then
 			echo "Failed to determine maximum number of open zones"
 			exit 1
 		fi
+		max_active_zones=$(max_active_zones "$dev")
 		set_io_scheduler "$basename" deadline || exit $?
 		if [ -n "$reset_all_zones" ]; then
 			reset_zone "$dev" -1
@@ -1508,6 +1593,7 @@ if [[ -b "$realdev" ]]; then
 		zone_size=$(max 65536 "$min_seq_write_size")
 		sectors_per_zone=$((zone_size / 512))
 		max_open_zones=128
+		max_active_zones=0
 		set_io_scheduler "$basename" none || exit $?
 		;;
 	esac
@@ -1543,6 +1629,7 @@ elif [[ -c "$realdev" ]]; then
 		echo "Failed to determine maximum number of open zones"
 		exit 1
 	fi
+	max_active_zones=0
 	if [ -n "$reset_all_zones" ]; then
 		reset_zone "$dev" -1
 	fi
diff --git a/zbd.c b/zbd.c
index d4565215..caac68bb 100644
--- a/zbd.c
+++ b/zbd.c
@@ -471,6 +471,34 @@ static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 	return ret;
 }
 
+/**
+ * zbd_get_max_active_zones - Get the maximum number of active zones
+ * @td: FIO thread data
+ * @f: FIO file for which to get max active zones
+ *
+ * Returns max_active_zones limit value of the target file if it is available.
+ * Otherwise return zero, which means no limit.
+ */
+static unsigned int zbd_get_max_active_zones(struct thread_data *td,
+					     struct fio_file *f)
+{
+	unsigned int max_active_zones;
+	int ret;
+
+	if (td->io_ops && td->io_ops->get_max_active_zones)
+		ret = td->io_ops->get_max_active_zones(td, f,
+						       &max_active_zones);
+	else
+		ret = blkzoned_get_max_active_zones(td, f, &max_active_zones);
+	if (ret < 0) {
+		dprint(FD_ZBD, "%s: max_active_zones is not available\n",
+		       f->file_name);
+		return 0;
+	}
+
+	return max_active_zones;
+}
+
 /**
  * __zbd_write_zone_get - Add a zone to the array of write zones.
  * @td: fio thread data.
@@ -927,6 +955,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
 		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
+	f->zbd_info->max_active_zones = zbd_get_max_active_zones(td, f);
 
 	if (same_zone_cap)
 		dprint(FD_ZBD, "Zone capacity = %"PRIu64" KB\n",
@@ -1247,7 +1276,11 @@ int zbd_setup_files(struct thread_data *td)
 		for (zi = f->min_zone; zi < f->max_zone; zi++) {
 			z = &zbd->zone_info[zi];
 			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
-			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
+			    z->cond != ZBD_ZONE_COND_EXP_OPEN &&
+			    z->cond != ZBD_ZONE_COND_CLOSED)
+				continue;
+			if (!zbd->max_active_zones &&
+			    z->cond == ZBD_ZONE_COND_CLOSED)
 				continue;
 			if (__zbd_write_zone_get(td, f, z))
 				continue;
@@ -2210,3 +2243,15 @@ int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u)
 
 	return io_u_completed;
 }
+
+void zbd_log_err(const struct thread_data *td, const struct io_u *io_u)
+{
+	const struct fio_file *f = io_u->file;
+
+	if (td->o.zone_mode != ZONE_MODE_ZBD)
+		return;
+
+	if (io_u->error == EOVERFLOW)
+		log_err("%s: Exceeded max_active_zones limit. Check conditions of zones out of I/O ranges.\n",
+			f->file_name);
+}
diff --git a/zbd.h b/zbd.h
index f0ac9876..5750a0b8 100644
--- a/zbd.h
+++ b/zbd.h
@@ -52,6 +52,9 @@ struct fio_zone_info {
  *      are simultaneously written. A zero value means unlimited zones of
  *      simultaneous writes and that write target zones will not be tracked in
  *      the write_zones array.
+ * @max_active_zones: device side limit on the number of sequential write zones
+ *	in open or closed conditions. A zero value means unlimited number of
+ *	zones in the conditions.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
@@ -75,6 +78,7 @@ struct fio_zone_info {
 struct zoned_block_device_info {
 	enum zbd_zoned_model	model;
 	uint32_t		max_write_zones;
+	uint32_t		max_active_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		wp_valid_data_bytes;
@@ -101,6 +105,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
+void zbd_log_err(const struct thread_data *td, const struct io_u *io_u);
 
 static inline void zbd_close_file(struct fio_file *f)
 {
