Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 1/3] Add Zone Append command support
Date: Tue, 28 Jul 2020 18:06:53 +0530
Message-Id: <20200728123655.30780-2-krish.reddy@samsung.com>
In-Reply-To: <20200728123655.30780-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20200728123655.30780-1-krish.reddy@samsung.com>
	<CGME20200728124022epcas5p1787dd4ab5af2ac0793858afe600d67a2@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Added a new FIO option zone_append. In ZBD zone mode,
when zone_append option is enabled, the existing write path will
send Zone Append command with offset as start of the Zone.
Added a new io engine flag FIO_ZONE_APPEND that can be used
in engine declaration to indicate that it supports zone append.

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 HOWTO            |  7 +++++++
 fio.1            |  7 +++++++
 ioengines.c      |  6 ++++++
 ioengines.h      |  3 ++-
 options.c        | 10 ++++++++++
 thread_options.h |  2 ++
 6 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 35ead0cb..a46b9da0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1022,6 +1022,13 @@ Target file/device
 	:option:`zonesize` bytes of data have been transferred. This parameter
 	must be zero for :option:`zonemode` =zbd.
 
+.. option:: zone_append=bool
+
+	For :option:`rw` =write or :option: `rw` =randwrite and
+	:option:`zonemode` =zbd, if zone_append is enabled the offset to write
+	will be the starting offset of a zone. On successful completion the device
+	returns the offset where the data has been placed.
+
 .. option:: read_beyond_wp=bool
 
 	This parameter applies to :option:`zonemode` =zbd only.
diff --git a/fio.1 b/fio.1
index a3d348b2..00122808 100644
--- a/fio.1
+++ b/fio.1
@@ -790,6 +790,13 @@ zone have been read (read workloads). This parameter is valid only for
 sequential workloads and ignored for random workloads. For read workloads,
 see also \fBread_beyond_wp\fR.
 
+.TP
+.BI zone_append
+For :option:`rw` =write or :option: `rw` =randwrite and for
+:option:`zonemode` =zbd, if zone_append is enabled the offset to write will be
+the starting offset of a zone. On successful completion the device returns the
+offset where the data has been placed.
+
 .TP
 .BI read_beyond_wp \fR=\fPbool
 This parameter applies to \fBzonemode=zbd\fR only.
diff --git a/ioengines.c b/ioengines.c
index 1c5970a4..288306a2 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -448,6 +448,12 @@ int td_io_init(struct thread_data *td)
 			td->error = ret;
 	}
 
+	if (td->o.zone_append && !td_ioengine_flagged(td, FIO_ZONE_APPEND)) {
+		log_err("fio: io engine %s doesn't support zone append\n",
+			td->io_ops->name);
+		return 1;
+	}
+
 	return ret;
 }
 
diff --git a/ioengines.h b/ioengines.h
index 54dadba2..5ba6b7f2 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -77,7 +77,8 @@ enum fio_ioengine_flags {
 	FIO_NOSTATS	= 1 << 12,	/* don't do IO stats */
 	FIO_NOFILEHASH	= 1 << 13,	/* doesn't hash the files for lookup later. */
 	FIO_ASYNCIO_SYNC_TRIM
-			= 1 << 14	/* io engine has async ->queue except for trim */
+			= 1 << 14,	/* io engine has async ->queue except for trim */
+	FIO_ZONE_APPEND = 1 << 15	/* engine supports zone append */
 };
 
 /*
diff --git a/options.c b/options.c
index 251ad2c1..0c9cd910 100644
--- a/options.c
+++ b/options.c
@@ -3316,6 +3316,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			   },
 		},
 	},
+	{
+		.name	= "zone_append",
+		.lname	= "zone_append",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, zone_append),
+		.help	= "Use zone append for writing zones of a zoned block device",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
 	{
 		.name	= "zonesize",
 		.lname	= "Zone size",
diff --git a/thread_options.h b/thread_options.h
index 3fe48ecc..b03b35a7 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -196,6 +196,7 @@ struct thread_options {
 	unsigned long long zone_capacity;
 	unsigned long long zone_skip;
 	enum fio_zone_mode zone_mode;
+	unsigned int zone_append;
 	unsigned long long lockmem;
 	enum fio_memtype mem_type;
 	unsigned int mem_align;
@@ -633,6 +634,7 @@ struct thread_options_pack {
 	uint32_t allow_mounted_write;
 
 	uint32_t zone_mode;
+	uint32_t zone_append;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
-- 
2.17.1


