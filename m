Return-Path: <prvs=76726b587=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 03/11] Add the zonemode job option
Date: Fri, 24 Aug 2018 09:30:38 -0700
Message-Id: <20180824163046.12304-4-bart.vanassche@wdc.com>
In-Reply-To: <20180824163046.12304-1-bart.vanassche@wdc.com>
References: <20180824163046.12304-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Fio's zone support makes fio perform I/O inside a zone before it skips
to the next zone. That behavior is the opposite of the behavior needed
for zoned block devices, namely to consider all zones when performing
random I/O. Hence introduce a new job option that allows users to
choose between fio's traditional zone mode and the behavior needed for
zoned block devices. This patch makes fio behave identically with
--zonemode=none and --zonemode=zbd. A later patch will implement new
behavior for --zonemode=zbd.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 HOWTO            | 46 ++++++++++++++++++++++++++++++++++++----------
 cconv.c          |  2 ++
 filesetup.c      |  3 ---
 fio.1            | 40 +++++++++++++++++++++++++++++++---------
 init.c           | 20 ++++++++++++++++----
 io_u.c           | 15 ++++++++-------
 options.c        | 24 ++++++++++++++++++++++++
 thread_options.h | 11 +++++++++++
 8 files changed, 128 insertions(+), 33 deletions(-)

diff --git a/HOWTO b/HOWTO
index 383946145794..a0fadcbbd523 100644
--- a/HOWTO
+++ b/HOWTO
@@ -952,24 +952,50 @@ Target file/device
 
 	Unlink job files after each iteration or loop.  Default: false.
 
+.. option:: zonemode=str
+
+	Accepted values are:
+
+		**none**
+				The :option:`zonerange`, :option:`zonesize` and
+				:option:`zoneskip` parameters are ignored.
+		**strided**
+				I/O happens in a single zone until
+				:option:`zonesize` bytes have been transferred.
+				After that number of bytes has been
+				transferred processing of the next zone
+				starts.
+		**zbd**
+				Zoned block device mode. I/O happens
+				sequentially in each zone, even if random I/O
+				has been selected. Random I/O happens across
+				all zones instead of being restricted to a
+				single zone. The :option:`zoneskip` parameter
+				is ignored. :option:`zonerange` and
+				:option:`zonesize` must be identical.
+
 .. option:: zonerange=int
 
-	Size of a single zone in which I/O occurs. See also :option:`zonesize`
-	and :option:`zoneskip`.
+	Size of a single zone. See also :option:`zonesize` and
+	:option:`zoneskip`.
 
 .. option:: zonesize=int
 
-	Number of bytes to transfer before skipping :option:`zoneskip`
-	bytes. If this parameter is smaller than :option:`zonerange` then only
-	a fraction of each zone with :option:`zonerange` bytes will be
-	accessed.  If this parameter is larger than :option:`zonerange` then
-	each zone will be accessed multiple times before skipping
+	For :option:`zonemode` =strided, this is the number of bytes to
+	transfer before skipping :option:`zoneskip` bytes. If this parameter
+	is smaller than :option:`zonerange` then only a fraction of each zone
+	with :option:`zonerange` bytes will be accessed.  If this parameter is
+	larger than :option:`zonerange` then each zone will be accessed
+	multiple times before skipping to the next zone.
+
+	For :option:`zonemode` =zbd, this is the size of a single zone. The
+	:option:`zonerange` parameter is ignored in this mode.
 
 .. option:: zoneskip=int
 
-	Skip the specified number of bytes when :option:`zonesize` data have
-	been transferred. The three zone options can be used to do strided I/O
-	on a file.
+	For :option:`zonemode` =strided, the number of bytes to skip after
+	:option:`zonesize` bytes of data have been transferred. This parameter
+	must be zero for :option:`zonemode` =zbd.
 
 
 I/O type
diff --git a/cconv.c b/cconv.c
index 534bfb072140..1d7f6f223503 100644
--- a/cconv.c
+++ b/cconv.c
@@ -223,6 +223,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zone_range = le64_to_cpu(top->zone_range);
 	o->zone_size = le64_to_cpu(top->zone_size);
 	o->zone_skip = le64_to_cpu(top->zone_skip);
+	o->zone_mode = le32_to_cpu(top->zone_mode);
 	o->lockmem = le64_to_cpu(top->lockmem);
 	o->offset_increment = le64_to_cpu(top->offset_increment);
 	o->number_ios = le64_to_cpu(top->number_ios);
@@ -548,6 +549,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->zone_range = __cpu_to_le64(o->zone_range);
 	top->zone_size = __cpu_to_le64(o->zone_size);
 	top->zone_skip = __cpu_to_le64(o->zone_skip);
+	top->zone_mode = __cpu_to_le32(o->zone_mode);
 	top->lockmem = __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add = __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low = __cpu_to_le64(o->file_size_low);
diff --git a/filesetup.c b/filesetup.c
index 94a025e6c106..2ab251531ae8 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1142,9 +1142,6 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
 
-	if (!o->zone_size)
-		o->zone_size = o->size;
-
 	/*
 	 * iolog already set the total io size, if we read back
 	 * stored entries.
diff --git a/fio.1 b/fio.1
index 4071947f24f3..3b961193e9ed 100644
--- a/fio.1
+++ b/fio.1
@@ -724,21 +724,43 @@ false.
 .BI unlink_each_loop \fR=\fPbool
 Unlink job files after each iteration or loop. Default: false.
 .TP
-Fio supports strided data access. After having read \fBzonesize\fR bytes from an area that is \fBzonerange\fR bytes big, \fBzoneskip\fR bytes are skipped.
+.BI zonemode \fR=\fPstr
+Accepted values are:
+.RS
+.RS
+.TP
+.B none
+The \fBzonerange\fR, \fBzonesize\fR and \fBzoneskip\fR parameters are ignored.
+.TP
+.B strided
+I/O happens in a single zone until \fBzonesize\fR bytes have been transferred.
+After that number of bytes has been transferred processing of the next zone
+starts.
+.TP
+.B zbd
+Zoned block device mode. I/O happens sequentially in each zone, even if random
+I/O has been selected. Random I/O happens across all zones instead of being
+restricted to a single zone.
+.RE
+.RE
 .TP
 .BI zonerange \fR=\fPint
-Size of a single zone in which I/O occurs.
+Size of a single zone. See also \fBzonesize\fR and \fBzoneskip\fR.
 .TP
 .BI zonesize \fR=\fPint
-Number of bytes to transfer before skipping \fBzoneskip\fR bytes. If this
-parameter is smaller than \fBzonerange\fR then only a fraction of each zone
-with \fBzonerange\fR bytes will be accessed.  If this parameter is larger than
-\fBzonerange\fR then each zone will be accessed multiple times before skipping
-to the next zone.
+For \fBzonemode\fR=strided, this is the number of bytes to transfer before
+skipping \fBzoneskip\fR bytes. If this parameter is smaller than
+\fBzonerange\fR then only a fraction of each zone with \fBzonerange\fR bytes
+will be accessed.  If this parameter is larger than \fBzonerange\fR then each
+zone will be accessed multiple times before skipping to the next zone.
+
+For \fBzonemode\fR=zbd, this is the size of a single zone. The \fBzonerange\fR
+parameter is ignored in this mode.
 .TP
 .BI zoneskip \fR=\fPint
-Skip the specified number of bytes after \fBzonesize\fR bytes of data have been
-transferred.
+For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
+bytes of data have been transferred. This parameter must be zero for
+\fBzonemode\fR=zbd.
 
 .SS "I/O type"
 .TP
diff --git a/init.c b/init.c
index 7514d1ab0af5..38f51288c638 100644
--- a/init.c
+++ b/init.c
@@ -618,17 +618,29 @@ static int fixup_options(struct thread_data *td)
 		ret |= warnings_fatal;
 	}
 
+	if (o->zone_mode == ZONE_MODE_NONE && o->zone_size) {
+		log_err("fio: --zonemode=none and --zonesize are not compatible.\n");
+		ret |= 1;
+	}
+
+	if (o->zone_mode == ZONE_MODE_NOT_SPECIFIED) {
+		if (o->zone_size)
+			o->zone_mode = ZONE_MODE_STRIDED;
+		else
+			o->zone_mode = ZONE_MODE_NONE;
+	}
+
 	/*
-	 * only really works with 1 file
+	 * Strided zone mode only really works with 1 file.
 	 */
-	if (o->zone_size && o->open_files > 1)
-		o->zone_size = 0;
+	if (o->zone_mode == ZONE_MODE_STRIDED && o->open_files > 1)
+		o->zone_mode = ZONE_MODE_NONE;
 
 	/*
 	 * If zone_range isn't specified, backward compatibility dictates it
 	 * should be made equal to zone_size.
 	 */
-	if (o->zone_size && !o->zone_range)
+	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_range)
 		o->zone_range = o->zone_size;
 
 	/*
diff --git a/io_u.c b/io_u.c
index c58dcf0493bb..e050d9f7c775 100644
--- a/io_u.c
+++ b/io_u.c
@@ -64,7 +64,7 @@ static uint64_t last_block(struct thread_data *td, struct fio_file *f,
 	if (max_size > f->real_file_size)
 		max_size = f->real_file_size;
 
-	if (td->o.zone_range)
+	if (td->o.zone_mode == ZONE_MODE_STRIDED && td->o.zone_range)
 		max_size = td->o.zone_range;
 
 	if (td->o.min_bs[ddir] > td->o.ba[ddir])
@@ -815,10 +815,14 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 	*io_u = NULL;
 }
 
-static void __fill_io_u_zone(struct thread_data *td, struct io_u *io_u)
+static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 
+	assert(td->o.zone_mode == ZONE_MODE_STRIDED);
+	assert(td->o.zone_size);
+	assert(td->o.zone_range);
+
 	/*
 	 * See if it's time to switch to a new zone
 	 */
@@ -869,11 +873,8 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	if (!ddir_rw(io_u->ddir))
 		goto out;
 
-	/*
-	 * When file is zoned zone_range is always positive
-	 */
-	if (td->o.zone_range)
-		__fill_io_u_zone(td, io_u);
+	if (td->o.zone_mode == ZONE_MODE_STRIDED)
+		setup_strided_zone_mode(td, io_u);
 
 	/*
 	 * No log, let the seq/rand engine retrieve the next buflen and
diff --git a/options.c b/options.c
index 86ab5d6d230c..2bac64a343b1 100644
--- a/options.c
+++ b/options.c
@@ -3239,6 +3239,30 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.help	= "Your platform does not support IO scheduler switching",
 	},
 #endif
+	{
+		.name	= "zonemode",
+		.lname	= "Zone mode",
+		.help	= "Mode for the zonesize, zonerange and zoneskip parameters",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, zone_mode),
+		.def	= "none",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+		.posval	= {
+			   { .ival = "none",
+			     .oval = ZONE_MODE_NONE,
+			     .help = "no zoning",
+			   },
+			   { .ival = "strided",
+			     .oval = ZONE_MODE_STRIDED,
+			     .help = "strided mode - random I/O is restricted to a single zone",
+			   },
+			   { .ival = "zbd",
+			     .oval = ZONE_MODE_ZBD,
+			     .help = "zoned block device mode - random I/O selects one of multiple zones randomly",
+			   },
+		},
+	},
 	{
 		.name	= "zonesize",
 		.lname	= "Zone size",
diff --git a/thread_options.h b/thread_options.h
index 8bbf54bfbafa..9ef3d6b155ed 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -10,6 +10,14 @@
 #include "lib/pattern.h"
 #include "td_error.h"
 
+enum fio_zone_mode {
+	ZONE_MODE_NOT_SPECIFIED	= 0,
+	ZONE_MODE_NONE		= 1,
+	ZONE_MODE_STRIDED	= 2, /* perform I/O in one zone at a time */
+	/* perform I/O across multiple zones simultaneously */
+	ZONE_MODE_ZBD		= 3,
+};
+
 /*
  * What type of allocation to use for io buffers
  */
@@ -188,6 +196,7 @@ struct thread_options {
 	unsigned long long zone_range;
 	unsigned long long zone_size;
 	unsigned long long zone_skip;
+	enum fio_zone_mode zone_mode;
 	unsigned long long lockmem;
 	enum fio_memtype mem_type;
 	unsigned int mem_align;
@@ -601,6 +610,8 @@ struct thread_options_pack {
 
 	uint32_t allow_create;
 	uint32_t allow_mounted_write;
+
+	uint32_t zone_mode;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
-- 
2.18.0


