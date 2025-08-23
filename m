Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF625A62E
	for <fio@vger.kernel.org>; Sat, 23 Aug 2025 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755950415; cv=none; b=j8OiXqBYycBlaB9j0Qa69YdI2/xN3YK990VmeydFAzRuThmNZ6vYwLPeEGlhyEi4OaPgGg2UD8kSjMoMFQ+kJGo82u07wAmcFxKJPPhXXsHUgFwYvOf8zqcexsKmg1pW+CwU73JOPw6uwHFYF4KkDHxSb2G9J8obS/3QqqGpmAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755950415; c=relaxed/simple;
	bh=L1rvVoz+RM4bnqPPALW9B0f+klHe1JgQI5iIEgk51ic=;
	h=Subject:From:To:Message-Id:Date; b=r2IXCrTF54Dw1Z7EJXZUFxzAAMXQXpdHt652kghfwatkjy2ggtdgjQebz4TncWNa1jsc6tgPThGBOctrN5pnFQbRrhkcNcJ3I7GkHS3xNyvUhkdypp7HPZ+GJ5E0u4jq3sNTc9vv7hrg6B98miq9PGaRfwdiY+zyeZmElevbzUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y50zNTv8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y50zNTv8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fft73+9G7K0Orhy+K/nC0kFH2jdv5Mt97cWxG7JkMZ4=; b=Y50zNTv8z458AWB5ivuqVRGCWR
	gqfVzIU7jydluK/MFzUOVlrGPKDkBI2Ft+WaV/jKK9nlsDuXQ63ymSIAMzao/Hqgzkbw9STgIheq0
	8B/V1cHAuMNgaSxoPkWN0VoWWVxeT93KaVnzQkWoy0wQFm3NRGROwsKGu+t/aieev3NCRvSUipCRo
	K82hslgNWvz75vx1pbKCY/Sctot27dlFaLNvdZGNEYi6DAQiD63y1BJ7cIlSYEZNlMTllxamczOdd
	kz5ilUNOGqEt7w/T0Wn/JLrrb7+F7HpqeXWLo2Mbai2xraVkOyYZfbzNAVx5lCzr8OjrFt/Duem8n
	BuUTEf6Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1upmui-00000001RBa-19uc
	for fio@vger.kernel.org;
	Sat, 23 Aug 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id F1E001BC0144; Sat, 23 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250823120001.F1E001BC0144@kernel.dk>
Date: Sat, 23 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ac2aa2ca02dec925fa05cb9e9d4a1cd25e78ae84:

  Kill of IO engine cancelation support (2025-08-21 16:23:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1fb2d4acde3d7e205cf941167c7efad49baf525c:

  verify: use new buffer for threads with %o format (2025-08-22 13:57:09 -0400)

----------------------------------------------------------------
Tomas Winkler (13):
      sprandom: add command line options
      sprandom: add debug facility
      sprandom: examples: add sprandom example file
      sprandom: implement region computation and invalidation percentage
      sprandom: set up LFSR random generator and disable randommap
      num2str: add bytes2str_simple()
      unittests: add bytes2str_simple()
      sprandom: pcbuf.h add two-phase circular buffer header-only library
      unittests: add pcbuf simple unit test
      sprandom: initialize random state
      sprandom: implement sprandom_get_next_offset()
      sprandom: initialize sprandom for file
      sprandom: integrate sprandom_get_next_offset() into io_u path

Vincent Fu (3):
      Merge branch 'sprandom' of https://github.com/tomas-winkler-sndk/fio
      sprandom: abort when invalid options specified
      verify: use new buffer for threads with %o format

 HOWTO.rst               |  31 ++
 Makefile                |   4 +-
 cconv.c                 |   6 +
 debug.h                 |   1 +
 examples/sprandom.fio   |  41 +++
 file.h                  |   3 +
 filesetup.c             |  13 +
 fio.1                   |  28 ++
 fio.h                   |   2 +
 init.c                  |  35 ++
 io_u.c                  |  21 +-
 lib/num2str.c           |  32 +-
 lib/num2str.h           |   2 +
 options.c               |  37 +++
 pcbuf.h                 | 211 ++++++++++++
 server.h                |   2 +-
 sprandom.c              | 835 ++++++++++++++++++++++++++++++++++++++++++++++++
 sprandom.h              |  78 +++++
 thread_options.h        |   6 +
 unittests/lib/num2str.c |  35 ++
 unittests/lib/pcbuf.c   | 116 +++++++
 unittests/unittest.c    |   1 +
 unittests/unittest.h    |   1 +
 verify.c                |   2 +-
 24 files changed, 1538 insertions(+), 5 deletions(-)
 create mode 100644 examples/sprandom.fio
 create mode 100644 pcbuf.h
 create mode 100644 sprandom.c
 create mode 100644 sprandom.h
 create mode 100644 unittests/lib/pcbuf.c

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 3eb0d9fe..3a4e018f 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1632,6 +1632,37 @@ I/O type
 	space exceeds 2^32 blocks. If it does, then **tausworthe64** is
 	selected automatically.
 
+.. option:: sprandom=bool
+
+
+        SPRandom is a method designed to rapidly precondition SSDs for
+        steady-state random write workloads. It divides the device into
+        equally sized regions and writes the device's entire physical capacity
+        once, selecting offsets so that the regions have a distribution of
+        invalid blocks matching the distribution that occurs at steady state.
+
+        Default: false.
+
+        It uses **random_generator=lfsr**, which fio will set by default.
+        Selecting any other random generator will result in an error.
+
+
+.. option:: spr_num_regions=int
+
+	See :option:`sprandom`. Specifies the number of regions used for SPRandom.
+        For large devices it is better to use more regions, to increase precision
+        and reduce memory allocation. The allocation is proportional to the region size.
+
+        Default=100
+
+
+.. option:: spr_op=float
+
+	See :option:`sprandom`. Over-provisioning ratio in the range (0, 1),
+        as specified by the SSD manufacturer.
+
+        Default=0.15
+
 
 Block size
 ~~~~~~~~~~
diff --git a/Makefile b/Makefile
index ec6249f3..ba7ad6dc 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,8 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c zone-dist.c zbd.c dedupe.c dataplacement.c
+		steadystate.c zone-dist.c zbd.c dedupe.c dataplacement.c \
+		sprandom.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
@@ -448,6 +449,7 @@ UT_OBJS = unittests/unittest.o
 UT_OBJS += unittests/lib/memalign.o
 UT_OBJS += unittests/lib/num2str.o
 UT_OBJS += unittests/lib/strntol.o
+UT_OBJS += unittests/lib/pcbuf.o
 UT_OBJS += unittests/oslib/strlcat.o
 UT_OBJS += unittests/oslib/strndup.o
 UT_OBJS += unittests/oslib/strcasestr.o
diff --git a/cconv.c b/cconv.c
index 4e72ae16..e7bbfc53 100644
--- a/cconv.c
+++ b/cconv.c
@@ -228,6 +228,9 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->job_start_clock_id = le32_to_cpu(top->job_start_clock_id);
 	o->norandommap = le32_to_cpu(top->norandommap);
 	o->softrandommap = le32_to_cpu(top->softrandommap);
+	o->sprandom = le32_to_cpu(top->sprandom);
+	o->spr_num_regions = le32_to_cpu(top->spr_num_regions);
+	o->spr_over_provisioning.u.f = fio_uint64_to_double(le64_to_cpu(top->spr_over_provisioning.u.i));
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
 	o->fsync_on_close = le32_to_cpu(top->fsync_on_close);
 	o->bs_is_seq_rand = le32_to_cpu(top->bs_is_seq_rand);
@@ -476,6 +479,9 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->job_start_clock_id = cpu_to_le32(o->job_start_clock_id);
 	top->norandommap = cpu_to_le32(o->norandommap);
 	top->softrandommap = cpu_to_le32(o->softrandommap);
+	top->sprandom = cpu_to_le32(o->sprandom);
+	top->spr_num_regions = cpu_to_le32(o->spr_num_regions);
+	top->spr_over_provisioning.u.i = __cpu_to_le64(fio_double_to_uint64(o->spr_over_provisioning.u.f));
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
 	top->fsync_on_close = cpu_to_le32(o->fsync_on_close);
 	top->bs_is_seq_rand = cpu_to_le32(o->bs_is_seq_rand);
diff --git a/debug.h b/debug.h
index 51b18de2..49a8791d 100644
--- a/debug.h
+++ b/debug.h
@@ -23,6 +23,7 @@ enum {
 	FD_STEADYSTATE,
 	FD_HELPERTHREAD,
 	FD_ZBD,
+	FD_SPRANDOM,
 	FD_DEBUG_MAX,
 };
 
diff --git a/examples/sprandom.fio b/examples/sprandom.fio
new file mode 100644
index 00000000..b94b226e
--- /dev/null
+++ b/examples/sprandom.fio
@@ -0,0 +1,41 @@
+; (SPRandom) SanDisk Random preconditioning example
+; Requirements
+;  1. Single file
+;  2. Single job (numjobs=1)
+;  3. Assumes norandommap=1
+;  4. Assumes random_generator=lfsr
+;
+; FIO_BS should be set to driver indirection unit (IU) size.
+; IU is the smallest unit of data that can be mapped from a LBA
+; on the host to a physical location on the SSD's flash memory.
+;
+; Basic execution example, run with io_uring
+; env FIO_BS=4096 \
+; fio --filename=/dev/nvme0n1 --ioengine=io_uring examples/sprandom.fio
+;
+; Enable debug output for the 'sprandom' module
+; env FIO_BS=4096 \
+; fio --debug=sprandom --filename=/dev/nvme0n1 examples/sprandom.fio
+;
+; Set over-provisioning according to vendor recommendation (21%)
+; env FIO_BS=4096 \
+; fio --spr_op=0.21 --filename=/dev/nvme0n1 examples/sprandom.fio
+;
+; For large devices it is better to use more regions, to increase precision
+; and reduce memory allocation. The allocation is proportional to the region size.
+; env FIO_BS=4096 \
+; fio --spr_num_regions=400 --filename=/dev/nvme0n1 examples/sprandom.fio
+;
+[global]
+ioengine=libaio
+rw=randwrite
+bs=${FIO_BS}
+blockalign=${FIO_BS}
+direct=1
+norandommap=1
+iodepth=64
+[preconditioning]
+sprandom=1
+spr_op=0.15
+spr_num_regions=100
+
diff --git a/file.h b/file.h
index 8fd40cdf..f400155f 100644
--- a/file.h
+++ b/file.h
@@ -113,6 +113,9 @@ struct fio_file {
 	uint32_t min_zone;	/* inclusive */
 	uint32_t max_zone;	/* exclusive */
 
+	/* SP Random Info */
+	struct sprandom_info *spr_info;
+
 	/*
 	 * Track last end and last start of IO for a given data direction
 	 */
diff --git a/filesetup.c b/filesetup.c
index bcbd871e..597bf4c5 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -15,6 +15,7 @@
 #include "lib/axmap.h"
 #include "rwlock.h"
 #include "zbd.h"
+#include "sprandom.h"
 
 #ifdef CONFIG_LINUX_FALLOCATE
 #include <linux/falloc.h>
@@ -1401,6 +1402,16 @@ done:
 			goto err_out;
 	}
 
+	if (td->o.sprandom) {
+		if (td->o.nr_files != 1) {
+			 log_err("fio: SPRandom supports only one file");
+			 goto err_out;
+		}
+		err = sprandom_init(td, td->files[0]);
+		if (err)
+			goto err_out;
+	}
+
 	if (o->create_only)
 		td->done = 1;
 
@@ -1590,6 +1601,8 @@ void fio_file_free(struct fio_file *f)
 		axmap_free(f->io_axmap);
 	if (f->ruhs_info)
 		sfree(f->ruhs_info);
+	if (f->spr_info)
+		sprandom_free(f->spr_info);
 	if (!fio_file_smalloc(f)) {
 		free(f->file_name);
 		free(f);
diff --git a/fio.1 b/fio.1
index 6aa23f7d..d9f4fd15 100644
--- a/fio.1
+++ b/fio.1
@@ -1440,6 +1440,34 @@ multiple times. The default value is \fBtausworthe\fR, unless the required
 space exceeds 2^32 blocks. If it does, then \fBtausworthe64\fR is
 selected automatically.
 .RE
+.TP
+.B sprandom=bool
+SPRandom is a method designed to rapidly precondition SSDs for
+steady-state random write workloads. It divides the device into
+equally sized regions and writes the device's entire physical capacity
+once, selecting offsets so that the regions have a distribution of
+invalid blocks matching the distribution that occurs at steady state.
+Default: false.
+
+It uses \fBrandom_generator=lfsr\fR, which fio will set by default.
+Selecting any other random generator will result in an error.
+.TP
+.B spr_num_regions=int
+See
+.BR sprandom .
+Specifies the number of regions used for SPRandom. Default=100
+.P
+.RS
+For large devices it is better to use more regions, to increase precision
+and reduce memory allocation. The allocation is proportional to the region size.
+.RE
+.TP
+.B spr_op=float
+See
+.BR sprandom .
+Over-provisioning ratio in the range (0, 1), as specified by the SSD manufacturer.
+The default is 0.15.
+.RE
 .SS "Block size"
 .TP
 .BI blocksize \fR=\fPint[,int][,int] "\fR,\fB bs" \fR=\fPint[,int][,int]
diff --git a/fio.h b/fio.h
index e11b9261..44788899 100644
--- a/fio.h
+++ b/fio.h
@@ -157,6 +157,7 @@ enum {
 	FIO_RAND_PRIO_CMDS,
 	FIO_RAND_DEDUPE_WORKING_SET_IX,
 	FIO_RAND_FDP_OFF,
+	FIO_RAND_SPRANDOM_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -286,6 +287,7 @@ struct thread_data {
 	struct frand_state prio_state;
 	struct frand_state dedupe_working_set_index_state;
 	struct frand_state *dedupe_working_set_states;
+	struct frand_state sprandom_state;
 
 	unsigned long long num_unique_pages;
 
diff --git a/init.c b/init.c
index 20f5462d..cf66ac2c 100644
--- a/init.c
+++ b/init.c
@@ -690,6 +690,36 @@ static int fixup_options(struct thread_data *td)
 	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_range)
 		o->zone_range = o->zone_size;
 
+	/*
+	 * SPRandom Requires: random write, random_generator=lfsr, norandommap=1
+	 */
+	if (o->sprandom) {
+		if (td_write(td) && td_random(td)) {
+			if (fio_option_is_set(o, random_generator)) {
+				if (o->random_generator != FIO_RAND_GEN_LFSR) {
+					log_err("fio: sprandom requires random_generator=lfsr\n");
+					ret |= 1;
+				}
+			} else {
+				log_info("fio: sprandom sets random_generator=lfsr\n");
+				o->random_generator = FIO_RAND_GEN_LFSR;
+			}
+			if (fio_option_is_set(o, norandommap)) {
+				if (o->norandommap == 0) {
+					log_err("fio: sprandom requires norandommap=1\n");
+					ret |= 1;
+				}
+				/* if == 1, OK */
+			} else {
+				log_info("fio: sprandom sets norandommap=1\n");
+				o->norandommap = 1;
+			}
+		} else {
+			log_err("fio: sprandom requires random write, random_generator=lfsr, norandommap=1");
+			ret |= 1;
+		}
+	}
+
 	/*
 	 * Reads can do overwrites, we always need to pre-create the file
 	 */
@@ -1165,6 +1195,7 @@ void td_fill_rand_seeds(struct thread_data *td)
 	frand_copy(&td->buf_state_prev, &td->buf_state);
 
 	init_rand_seed(&td->fdp_state, td->rand_seeds[FIO_RAND_FDP_OFF], use64);
+	init_rand_seed(&td->sprandom_state, td->rand_seeds[FIO_RAND_SPRANDOM_OFF], false);
 }
 
 static int setup_random_seeds(struct thread_data *td)
@@ -2470,6 +2501,10 @@ const struct debug_level debug_levels[] = {
 	  .help = "Zoned Block Device logging",
 	  .shift = FD_ZBD,
 	},
+	{ .name = "sprandom",
+	  .help = "SPRandom logging",
+	  .shift = FD_SPRANDOM,
+	},
 	{ .name = NULL, },
 };
 
diff --git a/io_u.c b/io_u.c
index 78dbac9c..ab1bf7c9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -11,6 +11,7 @@
 #include "lib/pow2.h"
 #include "minmax.h"
 #include "zbd.h"
+#include "sprandom.h"
 
 struct io_completion_data {
 	int nr;				/* input */
@@ -84,6 +85,22 @@ static uint64_t last_block(struct thread_data *td, struct fio_file *f,
 	return max_blocks;
 }
 
+
+static int __get_next_rand_offset_sprandom(struct thread_data *td, struct fio_file *f,
+					   enum fio_ddir ddir, uint64_t *b,
+					   uint64_t lastb)
+{
+	assert(ddir == DDIR_WRITE);
+
+	/* SP RANDOM writes all addresses once */
+	if (sprandom_get_next_offset(f->spr_info, f, b)) {
+		dprint(FD_SPRANDOM, "sprandom is done\n");
+		td->done = 1;
+		return 1;
+	}
+	return 0;
+}
+
 static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 				  enum fio_ddir ddir, uint64_t *b,
 				  uint64_t lastb)
@@ -277,7 +294,9 @@ bail:
 static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 				enum fio_ddir ddir, uint64_t *b)
 {
-	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM) {
+	if (td->o.sprandom && ddir == DDIR_WRITE) {
+		return __get_next_rand_offset_sprandom(td, f, ddir, b, 0);
+	} else if (td->o.random_distribution == FIO_RAND_DIST_RANDOM) {
 		uint64_t lastb;
 
 		lastb = last_block(td, f, ddir);
diff --git a/lib/num2str.c b/lib/num2str.c
index cd89a0e5..e48a483c 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -7,6 +7,37 @@
 #include "../oslib/asprintf.h"
 #include "num2str.h"
 
+
+static const char *iecstr[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei" };
+
+/**
+ * bytes2str_simple - Converts a byte value to a human-readable string.
+ * @buf:      buffer to store the resulting string
+ * @bufsize:  size of the buffer
+ * @bytes:    number of bytes to convert
+ * @returns : pointer to the buf containing the formatted string.
+ * Converts the given byte value into a human-readable string using IEC units
+ * (e.g., KiB, MiB, GiB), and stores the result in the provided buffer.
+ * The output is formatted with two decimal places of precision.
+ */
+const char *bytes2str_simple(char *buf, size_t bufsize, uint64_t bytes)
+{
+	int unit = 0;
+	double size = (double)bytes;
+
+	buf[0] = '\0';
+
+	while (size >= 1024.0 && unit < FIO_ARRAY_SIZE(iecstr) - 1) {
+		size /= 1024.0;
+		unit++;
+	}
+
+	snprintf(buf, bufsize, "%.2f %sB", size, iecstr[unit]);
+
+	return buf;
+}
+
+
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
  * @num: quantity (e.g., number of blocks, bytes or bits)
@@ -19,7 +50,6 @@
 char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 {
 	const char *sistr[] = { "", "k", "M", "G", "T", "P", "E" };
-	const char *iecstr[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei" };
 	const char **unitprefix;
 	static const char *const unitstr[] = {
 		[N2S_NONE]	= "",
diff --git a/lib/num2str.h b/lib/num2str.h
index 797288b5..8ca2050a 100644
--- a/lib/num2str.h
+++ b/lib/num2str.h
@@ -14,4 +14,6 @@ enum n2s_unit {
 
 extern char *num2str(uint64_t, int, int, int, enum n2s_unit);
 
+extern const char *bytes2str_simple(char *buf, size_t bufsize, uint64_t bytes);
+
 #endif
diff --git a/options.c b/options.c
index 6295a616..337a3a52 100644
--- a/options.c
+++ b/options.c
@@ -2628,6 +2628,43 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
 	},
+	{
+		.name	= "sprandom",
+		.lname	= "Sandisk Pseudo Random Preconditioning",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, sprandom),
+		.help	= "Set up Sandisk Pseudo Random Preconditioning",
+		.parent	= "rw",
+		.hide	= 1,
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
+	{
+		.name	= "spr_num_regions",
+		.lname	= "SPRandom number of regions",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, spr_num_regions),
+		.help	= "Number of regions for sprandom",
+		.parent	= "sprandom",
+		.hide	= 1,
+		.def    = "100",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
+	{
+		.name	= "spr_op",
+		.lname	= "SPRandom Over provisioning",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.off1	= offsetof(struct thread_options, spr_over_provisioning),
+		.help	= "Over provisioning ratio for SPRandom",
+		.parent	= "sprandom",
+		.maxlen = 1,
+		.hide	= 1,
+		.def    = "0.15",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
 	{
 		.name	= "random_generator",
 		.lname	= "Random Generator",
diff --git a/pcbuf.h b/pcbuf.h
new file mode 100644
index 00000000..df23b233
--- /dev/null
+++ b/pcbuf.h
@@ -0,0 +1,211 @@
+/**
+ * SPDX-License-Identifier: GPL-2.0 only
+ *
+ * Copyright (c) 2025 Sandisk Corporation or its affiliates.
+ */
+/**
+ * Two-phase circular buffer implementation for producer/consumer separation.
+ *
+ * This header defines the data structures and inline functions for a two-phase
+ * circular buffer, allowing staged writes and explicit commit of data batches.
+ * Useful for double-buffered systems or scenarios requiring controlled visibility
+ * of produced data to consumers.
+ */
+#ifndef PHASE_CIRCULAR_BUFFER_H
+#define PHASE_CIRCULAR_BUFFER_H
+
+#include <stdio.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <inttypes.h>
+
+/**
+ * struct pc_buf - Two-phase circular buffer.
+ * @commit_head:  Index of the next committed element in the buffer (visible to consumer).
+ * @staging_head: Index of the next staged (but not yet committed) element (written by producer).
+ * @read_tail:    Index of the next element to be read by the consumer.
+ * @capacity:     Total capacity of the buffer (number of elements).
+ * @buffer:       Buffer data.
+ *
+ * This structure implements a two-phase circular buffer, where data is first staged
+ * by advancing @staging_head, and only becomes visible to the consumer when @commit_head
+ * is explicitly updated. This allows for controlled commit of data batches, useful in
+ * double-buffered systems or producer/consumer separation.
+ */
+struct pc_buf {
+	uint64_t commit_head;
+	uint64_t staging_head;
+	uint64_t read_tail;
+	uint64_t capacity;
+	uint64_t buffer[];
+};
+
+/**
+ * pcb_alloc - Allocate and initialize buffer.
+ * @capacity: Number of elements the buffer can hold.
+ *
+ * Returns a pointer to the allocated buffer, or NULL on failure.
+ */
+static inline struct pc_buf *pcb_alloc(uint64_t capacity)
+{
+	size_t size = sizeof(struct pc_buf) + sizeof(uint64_t) * capacity;
+	struct pc_buf *cb = (struct pc_buf *)malloc(size);
+
+	if (!cb)
+		return NULL;
+	cb->commit_head = 0;
+	cb->staging_head = 0;
+	cb->read_tail = 0;
+	cb->capacity = capacity;
+	return cb;
+}
+
+/**
+ * pcb_is_empty - Check if the buffer is empty.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * Returns true if the buffer has no committed data.
+ */
+static inline bool pcb_is_empty(const struct pc_buf *cb)
+{
+	return cb->read_tail == cb->commit_head;
+}
+
+/**
+ * pcb_is_full - Check if the buffer is full.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * Returns true if the buffer cannot accept more staged data.
+ */
+
+static inline bool pcb_is_full(const struct pc_buf *cb)
+{
+	return ((cb->staging_head + 1) % cb->capacity) == cb->read_tail;
+}
+
+/**
+ * pcb_push_staged - Push a value into the staged buffer.
+ * @cb: pointer to the pc_buf structure.
+ * @value: value to be staged.
+ *
+ * Returns true if the value was successfully staged, false if the buffer is full.
+ */
+static inline bool pcb_push_staged(struct pc_buf *cb, uint64_t value)
+{
+	if (pcb_is_full(cb))
+		return false;
+
+	cb->buffer[cb->staging_head] = value;
+	cb->staging_head = (cb->staging_head + 1) % cb->capacity;
+	return true;
+}
+
+/**
+ * pcb_commit - Commit the staged data to make it visible to consumers.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * Updates the commit head to the current staging head, making
+ * all staged data visible to consumers. It should be called after staging data.
+ */
+static inline void pcb_commit(struct pc_buf *cb)
+{
+	cb->commit_head = cb->staging_head;
+}
+
+/**
+ * pcb_pop - Pop a value from the committed buffer.
+ * @cb: pointer to the pc_buf structure.
+ * @out: pointer to the variable to store the popped value.
+ *
+ * Returns true if a value was successfully popped, false if the buffer is empty.
+ */
+static inline bool pcb_pop(struct pc_buf *cb, uint64_t *out)
+{
+	if (pcb_is_empty(cb))
+		return false;
+
+	*out = cb->buffer[cb->read_tail];
+	cb->read_tail = (cb->read_tail + 1) % cb->capacity;
+	return true;
+}
+
+/**
+ * pcb_print_committed - Print the contents of the committed buffer.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * This function prints all committed data in the buffer.
+ */
+static inline void pcb_print_committed(const struct pc_buf *cb)
+{
+	uint64_t i = cb->read_tail;
+
+	printf("Committed buffer: ");
+	while (i != cb->commit_head) {
+		printf("%" PRIu64 " ", cb->buffer[i]);
+		i = (i + 1) % cb->capacity;
+	}
+	printf("\n");
+}
+
+/**
+ * pcb_print_staged - Print the contents of the staged buffer.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * This function prints all staged data that has not yet been committed.
+ */
+static inline void pcb_print_staged(const struct pc_buf *cb)
+{
+	uint64_t i = cb->commit_head;
+
+	printf("Staged (not visible yet): ");
+	while (i != cb->staging_head) {
+		printf("%" PRIu64 " ", cb->buffer[i]);
+		i = (i + 1) % cb->capacity;
+	}
+	printf("\n");
+}
+
+/**
+ * pcb_committed_size - Get the size of committed data in the buffer.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * Returns the number of elements that have been committed and are visible to consumers.
+ */
+static inline uint64_t pcb_committed_size(const struct pc_buf *cb)
+{
+	if (cb->commit_head >= cb->read_tail)
+		return cb->commit_head - cb->read_tail;
+	else
+		return cb->capacity - cb->read_tail + cb->commit_head;
+}
+
+/**
+ * pcb_staged_size - Get the size of staged data in the buffer.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * Returns the number of elements that have been staged but not yet committed.
+ */
+static inline uint64_t pcb_staged_size(const struct pc_buf *cb)
+{
+	if (cb->staging_head >= cb->commit_head)
+		return cb->staging_head - cb->commit_head;
+	else
+		return cb->capacity - cb->commit_head + cb->staging_head;
+}
+
+/**
+ * pcb_space_available - Check if there is space available for staging.
+ * @cb: pointer to the pc_buf structure.
+ *
+ * Returns true if there is space available for staging new data, false if the buffer is full.
+ */
+static inline bool pcb_space_available(const struct pc_buf *cb)
+{
+	uint64_t used = pcb_committed_size(cb) + pcb_staged_size(cb);
+	/* keep 1 slot reserved to distinguish full from empty */
+	return used < (cb->capacity - 1);
+}
+
+#endif /* PHASE_CIRCULAR_BUFFER_H */
+
diff --git a/server.h b/server.h
index f0b15a22..5246af5c 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 112,
+	FIO_SERVER_VER			= 113,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/sprandom.c b/sprandom.c
new file mode 100644
index 00000000..93e8609d
--- /dev/null
+++ b/sprandom.c
@@ -0,0 +1,835 @@
+/**
+ * SPDX-License-Identifier: GPL-2.0 only
+ *
+ * Copyright (c) 2025 Sandisk Corporation or its affiliates.
+ */
+#include <stdlib.h>
+#include <stdint.h>
+#include <math.h>
+#include "lib/pow2.h"
+#include "fio.h"
+#include "file.h"
+#include "sprandom.h"
+
+/*
+ * Model for Estimating Steady-State Data Distribution in SSDs
+ *
+ * This model estimates the distribution of valid data across a flash drive
+ * in a steady state. It is based on the key insight from Desnoyers' research,
+ * which establishes a relationship between data validity and the physical
+ * space it occupies.
+ *
+ * P. Desnoyers, "Analytic Models of SSD Write Performance,"
+ * ACM Transactions on Storage,
+ * vol. 8, no. 2, pp. 1–18, Jun. 2012, doi: 10.1145/2133360.2133364.
+ *
+ * The Core Principle
+ * ==================
+ *
+ * The fundamental concept is that for a drive in a steady state, the product
+ * of a block's validity and the fraction of drive space occupied by such
+ * blocks is constant.
+ *
+ * Key Equation (1): i * f(i) = k
+ *
+ * Where:
+ * - i: The number of valid pages in a block.
+ * - f(i): The fraction of the drive composed of blocks with 'i' valid pages.
+ * - k: A constant for the drive.
+ *
+ * This implies that for any two validity levels i and j: i * f(i) = j * f(j).
+ * In other words, regions with lower validity (more invalid data) must
+ * occupy proportionally more physical space than regions with high validity.
+ *
+ *
+ * Modeling Steps
+ * ==============
+ * The model is built by following these steps:
+ *
+ * 1. Normalize Validity & Relate to Write Amplification (WA)
+ * We normalize 'i' into a validity fraction:
+ *
+ *      valid_frac(i) = i / num_pages_per_region
+ *
+ * A greedy garbage collection (GC) algorithm reclaims the block with the
+ * lowest validity. The validity of this GC block (`valid_frac_gc`) is
+ * determined by the drive's WA:
+ *
+ *      valid_frac_gc = 1 - (1 / WA)
+ *
+ * 2. Determine Write Amplification (WA) from Over-Provisioning (OP)
+ * The WA can be calculated from the drive's OP. A simple approximation
+ * is often sufficient for most cases:
+ *
+ *      WA ≈ 0.5 / OP + 0.7
+ *
+ * Note: The precise formula from Desnoyers uses
+ *      alpha = T/U
+ * where
+ *      OP = alpha - 1
+ *
+ * in the equation:
+ *                   alpha
+ *      WA = ----------------------------
+ *           (alpha + W(-alpha*e^-alpha)
+ *
+ * with W being the Lambert W function).
+ *
+ * 3. Define the Distribution Curve
+ *
+ * Using the steady-state principle, we can find the relative size f(i) of a
+ * region given its validity (`valid_frac_i`) by comparing it to the GC block.
+ *
+ *       valid_frac(i) * f(i) = valid_frac_gc * f_gc
+ *
+ * By defining the base size f_gc = 1, we get a simple relationship:
+ *
+ *       f(i) = valid_frac_gc / valid_frac(i)
+ *
+ * This formula defines a curve where points are spaced equally by validity.
+ *
+ * 4. Resample for Equal-Sized Regions
+ *
+ * The final step is to make the model practical. We take the curve defined
+ * above and resample it to get points that are equally spaced by region
+ * size f(i). This resampling gives the expected validity for each
+ * equal-sized region of the drive, completing the model.
+ */
+
+#define PCT_PRECISION 10000
+
+static inline double *d_alloc(size_t n)
+{
+	return calloc(n, sizeof(double));
+}
+
+struct point {
+	double x;
+	double y;
+};
+
+static inline struct point *p_alloc(size_t n)
+{
+	return calloc(n, sizeof(struct point));
+}
+
+static void print_d_array(const char *hdr, double *darray, size_t len)
+{
+	struct buf_output out;
+	int i;
+
+	buf_output_init(&out);
+
+	log_buf(&out, "[");
+	for (i = 0; i < len - 1; i++)
+		log_buf(&out, "%.2f, ", darray[i]);
+
+	log_buf(&out, "%.2f]\n", darray[len - 1]);
+	if (hdr)
+		dprint(FD_SPRANDOM, "%s: ", hdr);
+
+	dprint(FD_SPRANDOM, "%s", out.buf);
+	buf_output_free(&out);
+}
+
+static void print_d_points(struct point *parray, size_t len)
+{
+	struct buf_output out;
+	unsigned int i;
+
+	buf_output_init(&out);
+
+	log_buf(&out, "[");
+	for (i = 0; i < len - 1; i++)
+		log_buf(&out, "(%.2f %.2f), ", parray[i].x, parray[i].y);
+
+	log_buf(&out, "(%.2f %.2f)]\n", parray[len - 1].x, parray[len - 1].y);
+	dprint(FD_SPRANDOM, "%s", out.buf);
+	buf_output_free(&out);
+}
+
+/* Comparison function for qsort to sort points by x-value */
+static int compare_points(const void *a, const void *b)
+{
+	/* Cast void pointers to struct point pointers */
+	const struct point *point_a = (const struct point *)a;
+	const struct point *point_b = (const struct point *)b;
+
+	if (point_a->x < point_b->x)
+		return -1;
+
+	if (point_a->x > point_b->x)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * reverse - Reverses the elements of a double array in place.
+ * @arr: pointer to the array of doubles to be reversed.
+ * @size: number of elements in the array.
+ */
+static void reverse(double arr[], size_t size)
+{
+	size_t left = 0;
+	size_t right = size - 1;
+
+	if (size <= 1)
+		return;
+
+	while (left < right) {
+		double temp = arr[left];
+		arr[left] = arr[right];
+		arr[right] = temp;
+		left++;
+		right--;
+	}
+}
+
+/**
+ * linspace - Generates a linearly spaced array of doubles.
+ * @start: The starting value of the sequence.
+ * @end: The ending value of the sequence.
+ * @num: The number of elements to generate.
+ *
+ * Allocates and returns an array of @num doubles, linearly spaced
+ * between @start and @end (inclusive). If @num is 0, returns NULL.
+ * If @num is 1, the array contains only @start.
+ *
+ * Return: allocated array, or NULL on allocation failure or if @num is 0.
+ */
+static double *linspace(double start, double end, unsigned int num)
+{
+	double *arr;
+	unsigned int i;
+	double step;
+
+	if (num == 0)
+		return NULL;
+
+	dprint(FD_SPRANDOM, "linespace start=%0.2f end=%0.2f num=%d\n",
+	       start, end, num);
+
+	arr = d_alloc(num);
+	if (arr == NULL)
+		return NULL;
+
+	if (num == 1) {
+		arr[0] = start;
+		return arr;
+	}
+
+	/* Calculate step size */
+	step = (end - start) / ((double)num - 1.0);
+
+	for (i = 0; i < num; i++)
+		arr[i] = start + (double)i * step;
+
+	return arr;
+}
+
+/**
+ * linear_interp - Performs linear interpolation or extrapolation.
+ * @new_x: The x-value at which to interpolate.
+ * @x_arr: Array of x-values (must be sorted in strictly increasing order).
+ * @y_arr: Array of y-values corresponding to x_arr.
+ * @num: Number of points in x_arr and y_arr.
+ *
+ * Returns the interpolated y-value at new_x using linear interpolation
+ * between the points in x_arr and y_arr. If new_x is outside the range
+ * of x_arr, returns the nearest endpoint's y-value (extrapolation).
+ * Handles edge cases for zero or one point, and avoids division by zero
+ * if two x-values are nearly identical.
+ */
+static double linear_interp(double new_x, const double *x_arr,
+			    const double *y_arr, unsigned int num)
+{
+	unsigned int i;
+	double x1, y1, x2, y2;
+
+	if (num == 0)
+		return 0.0;
+
+	if (num == 1)
+		return y_arr[0]; /* If only one point, return its y-value */
+
+	/* Handle extrapolation outside the range */
+	if (new_x <= x_arr[0])
+		return y_arr[0];
+
+	if (new_x >= x_arr[num - 1])
+		return y_arr[num - 1];
+
+	/* Find the interval [x_arr[i], x_arr[i + 1]] that contains new_x */
+	for (i = 0; i < num - 1; i++) {
+		if (new_x >= x_arr[i] && new_x <= x_arr[i + 1]) {
+			x1 = x_arr[i];
+			y1 = y_arr[i];
+			x2 = x_arr[i + 1];
+			y2 = y_arr[i + 1];
+
+			/* Avoid division by zero if x values are identical
+			 * Using a small epsilon for float comparison
+			 * Return y1 if x1 and x2 are almost identical
+			 */
+			if (fabs(x2 - x1) < 1e-9)
+				return y1;
+
+			return y1 + (y2 - y1) * ((new_x - x1) / (x2 - x1));
+		}
+	}
+	/* Should not reach here if new_x is within bounds
+	 * and x_arr is strictly increasing
+	 */
+	return 0.0;
+}
+
+/**
+ * sample_curve_equally_on_x - Resamples a curve at equally spaced x-values.
+ * @points: array of input points (must have strictly increasing x-values).
+ * @num: Number of input points.
+ * @num_resampled: number of points to resample to.
+ * @resampled_points: An output array of resampled points.
+ *
+ * Sorts the input points by x-value, checks for strictly increasing x-values,
+ * and generates a new set of points with x-values equally spaced between the
+ * minimum and maximum x of the input. Uses linear interpolation to compute
+ * corresponding y-values.
+ * Note: The function allocates memory for the output array.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int sample_curve_equally_on_x(struct point *points, unsigned int num,
+				     unsigned int num_resampled,
+				     struct point **resampled_points)
+{
+	double *x_orig = (double *)0;
+	double *y_orig = (double *)0;
+	double *new_x_arr = (double *)0;
+	struct point *new_points_arr = (struct point *)0;
+	unsigned int i;
+	int ret = 0;
+
+	if (points == NULL || resampled_points == NULL)
+		return -EINVAL;
+
+	if (num == 0) {
+		log_err("fio: original points array cannot be empty.\n");
+		return -EINVAL;
+	}
+
+	if (num_resampled == 0) {
+		*resampled_points = NULL;
+		return 0;
+	}
+
+	qsort(points, num, sizeof(struct point), compare_points);
+
+	/* Check if x-values are strictly increasing and sort them */
+	for (i = 0; i < num - 1; i++) {
+		if (points[i+1].x <= points[i].x) {
+			log_err("fio: x-values must be strictly increasing.\n");
+			ret = -EINVAL;
+			goto cleanup;
+		}
+	}
+
+	/* 2. Extract x and y into separate arrays for interpolation */
+	x_orig = d_alloc(num);
+	y_orig = d_alloc(num);
+	if (x_orig == NULL || y_orig == NULL) {
+		log_err("fio: Memory allocation failed for x_orig or y_orig.\n");
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+	for (i = 0; i < num; i++) {
+		x_orig[i] = points[i].x;
+		y_orig[i] = points[i].y;
+	}
+
+	/* 4. Generate new_x values using linspace */
+	new_x_arr = linspace(x_orig[0], x_orig[num - 1], num_resampled);
+	if (new_x_arr == NULL) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	/* 5. Allocate memory for new resampled points */
+	new_points_arr = p_alloc(num_resampled);
+	if (new_points_arr == NULL) {
+		log_err("fio: Memory allocation failed for new_points_arr.\n");
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	/* 6. Perform linear interpolation for each new_x to get new_y */
+	for (i = 0; i < num_resampled; i++) {
+		new_points_arr[i].x = new_x_arr[i];
+		new_points_arr[i].y = linear_interp(new_x_arr[i], x_orig, y_orig, num);
+	}
+
+	*resampled_points = new_points_arr;
+
+cleanup:
+	free(x_orig);
+	free(y_orig);
+	free(new_x_arr);
+
+	return ret;
+}
+
+/**
+ * compute_waf - Compute the write amplification factor (WAF)
+ * @over_provisioning: The over-provisioning ratio (0 < over_provisioning < 1)
+ *
+ * write amplification approximation equation
+ *
+ *                   0.5
+ *     WAF = ------------------ + 0.7
+ *           over_provisioning
+ *
+ * Return: The computed write amplification factor as a double.
+ */
+static inline double compute_waf(double over_provisioning)
+{
+	return 0.5 / over_provisioning + 0.7;
+}
+
+/**
+ * compute_gc_validity - validity of the block selected for GC (garbage collector)
+ *
+ * @waf: The Write Amplification Factor, must be greater than 1.0.
+ *
+ * Return: The computed gavalidity;
+ */
+static inline double compute_gc_validity(double waf)
+{
+	assert(waf > 1.0); /* Ensure WAF is greater than 1.0 */
+	return 1.0 - (double)1.0 / waf;
+}
+
+/**
+ * compute_validity_dist - Computes a resampled validity distribution for regions.
+ * @n_regions: Number of regions to divide the distribution into.
+ * @over_provisioning: Over-provisioning factor used to calculate WAF and validity.
+ *
+ * Calculates the validity distribution across a specified number of regions,
+ * based on the write amplification factor (WAF) and over-provisioning.
+ * Steps:
+ * - Allocates and fills arrays for:
+ *   - validity distribution
+ *   - block ratios
+ *   - accumulated ratios
+ * - Constructs a set of points representing the curve.
+ * - Resamples the curve to ensure equal spacing along the x-axis.
+ * - Reverses the resulting validity distribution before returning.
+ *
+ * Note: The function allocates memory for the validity distribution array.
+ *
+ * Return: resampled and reversed validity distribution array or NULL on error.
+ */
+static double *compute_validity_dist(unsigned int n_regions, double over_provisioning)
+{
+	double waf = compute_waf(over_provisioning);
+	double validity = compute_gc_validity(waf);
+	double *validity_distribution = NULL;
+	double *blocks_ratio = NULL;
+	double *acc_ratio = NULL;
+	double acc;
+	unsigned int i;
+	struct point *points = NULL;
+	struct point *points_resampled = NULL;
+	int ret;
+
+	if (n_regions == 0) {
+		log_err("fio: requires at least one region");
+		goto out;
+	}
+
+	/*
+	 * Use linspace to get equally distributed validity values,
+	 * along the y-axis of the curve we want to generate.
+	 */
+	validity_distribution = linspace(1.0, validity, n_regions);
+
+	blocks_ratio = d_alloc(n_regions);
+	if (blocks_ratio == NULL) {
+		log_err("fio: memory allocation failed for linspace.\n");
+		goto out;
+	}
+
+	for (i = 0; i < n_regions; i++)
+		blocks_ratio[i] = 1.0 / validity_distribution[i];
+
+	acc_ratio = d_alloc(n_regions);
+	if (acc_ratio == NULL) {
+		log_err("fio: memory allocation failed for linspace_c.\n");
+		goto out;
+	}
+
+	acc = 0.0;
+	for (i = 0; i < n_regions; i++) {
+		acc_ratio[i] = acc + blocks_ratio[i];
+		acc = acc_ratio[i];
+	}
+
+	print_d_array("validity_distribution", validity_distribution, n_regions);
+	print_d_array("blocks ratio", blocks_ratio, n_regions);
+	print_d_array("accumulated ratio:", acc_ratio, n_regions);
+
+	points = p_alloc(n_regions);
+
+	for (i = 0; i < n_regions; i++) {
+		points[i].x = acc_ratio[i];
+		points[i].y = validity_distribution[i];
+	}
+	print_d_points(points, n_regions);
+
+	/*
+	 * Use linspace again to get uniformly distributed x-values,
+	 * and then interpolate the curve to find the validity at those
+	 * uniformly distributed x-values.
+	 */
+	ret = sample_curve_equally_on_x(points, n_regions, n_regions,
+					&points_resampled);
+
+	if (ret == 0) {
+		print_d_points(points_resampled, n_regions);
+	} else {
+		log_err("fio: failed to resample curve. Error code: %d\n", ret);
+		free(validity_distribution);
+		validity_distribution = NULL;
+		goto out;
+	}
+
+	for (i = 0; i < n_regions; i++)
+		validity_distribution[i] = points_resampled[i].y;
+
+	print_d_array("validity resampled", validity_distribution, n_regions);
+
+out:
+	free(points);
+	free(points_resampled);
+	free(blocks_ratio);
+	free(acc_ratio);
+
+	reverse(validity_distribution, n_regions);
+
+	return validity_distribution;
+}
+
+/**
+ * Calculate the physical size based on logical size and over-provisioning
+ *
+ * @over_provisioning:   over provisioning factor (e.g. 0.2 for 20%)
+ * @logical_sz:          Logical size in bytes
+ * @align_bs:            Block size for alignment in bytes
+ *
+ * return: Physical size in bytes, including over-provisioning and aligned to align_bs
+ */
+static uint64_t sprandom_physical_size(double over_provisioning, uint64_t logical_sz,
+				       uint64_t align_bs)
+{
+	uint64_t size;
+
+	size = logical_sz + ceil((double)logical_sz * over_provisioning);
+	return (size + (align_bs - 1)) & ~(align_bs - 1);
+}
+
+/**
+ * estimate_inv_capacity - Estimates the invalid capacity of a region.
+ * @region_cnt: number of offsets in the region.
+ * @validity: invalidation ration in the regions (between 0 and 1).
+ *
+ * Calculates the expected number of invalidion in regions, adding a margin
+ * of 6 standard deviations to account for statistical variation.
+ *
+ * Returns: Estimated invalid capacity
+ */
+static uint64_t estimate_inv_capacity(uint64_t region_cnt, double validity)
+{
+	double sigma = sqrt((double)region_cnt * validity * (1.0 - validity));
+	return (uint64_t)ceil(region_cnt * (1.0 - validity) + 6.0 * sigma);
+}
+
+/**
+ * sprandom_setup - Initialize and configure sprandom_info structure.
+ * @spr_info: Pointer to sprandom_info structure to be initialized.
+ * @logical_size: Logical size of the storage region.
+ * @align_bs: Alignment block size.
+ *
+ * Calculates physical size and region parameters based on logical size,
+ * alignment, and over-provisioning. Allocates and initializes validity
+ * distribution and invalid percentage arrays for regions. Precomputes
+ * invalid buffer capacity and allocates buffer. Sets up region size,
+ * write counts, and resets region/phase counters.
+ *
+ * Returns 0 on success, enagative value on failure.
+ */
+static int sprandom_setup(struct sprandom_info *spr_info, uint64_t logical_size,
+			  uint64_t align_bs)
+{
+	double over_provisioning = spr_info->over_provisioning;
+	uint64_t physical_size;
+	uint64_t region_sz;
+	uint64_t region_write_count;
+	double *validity_dist;
+	size_t invalid_capacity;
+	size_t total_alloc = 0;
+	char bytes2str_buf[40];
+	int i;
+
+	physical_size = sprandom_physical_size(over_provisioning,
+					       logical_size, align_bs);
+
+	validity_dist = compute_validity_dist(spr_info->num_regions,
+					      spr_info->over_provisioning);
+	if (!validity_dist)
+		return -ENOMEM;
+
+	/* Initialize validity_distribution */
+	print_d_array("validity resampled:", validity_dist, spr_info->num_regions);
+
+	spr_info->validity_dist = validity_dist;
+	total_alloc += spr_info->num_regions * sizeof(spr_info->validity_dist[0]);
+
+	/* Precompute invalidity percentage array */
+	spr_info->invalid_pct = calloc(spr_info->num_regions,
+				       sizeof(spr_info->invalid_pct[0]));
+	if (!spr_info->invalid_pct)
+		goto err;
+
+	total_alloc += spr_info->num_regions * sizeof(spr_info->invalid_pct[0]);
+
+	for (i = 0; i < spr_info->num_regions; i++) {
+		double inv = (1.0 - validity_dist[i]) * (double)PCT_PRECISION;
+		spr_info->invalid_pct[i] = (int)round(inv);
+	}
+
+	region_sz = physical_size / spr_info->num_regions;
+	region_write_count = region_sz / align_bs;
+
+	invalid_capacity = estimate_inv_capacity(region_write_count,
+						 validity_dist[0]);
+	spr_info->invalid_capacity = invalid_capacity;
+
+	spr_info->invalid_buf = pcb_alloc(invalid_capacity);
+
+	total_alloc += invalid_capacity * sizeof(uint64_t);
+
+	spr_info->region_sz = region_sz;
+	spr_info->invalid_count[0] = 0;
+	spr_info->invalid_count[1] = 0;
+	spr_info->curr_phase = 0;
+	spr_info->current_region = 0;
+	spr_info->region_write_count = region_write_count;
+	spr_info->writes_remaining = region_write_count;
+
+	/* Display overall allocation */
+	dprint(FD_SPRANDOM, "Summary:\n");
+	dprint(FD_SPRANDOM, "  logical_size:      %"PRIu64": %s\n",
+		logical_size,
+		bytes2str_simple(bytes2str_buf, sizeof(bytes2str_buf), logical_size));
+	dprint(FD_SPRANDOM, "  physical_size:     %"PRIu64": %s\n",
+		physical_size,
+		bytes2str_simple(bytes2str_buf, sizeof(bytes2str_buf), physical_size));
+	dprint(FD_SPRANDOM, "  op: %02f\n", spr_info->over_provisioning);
+	dprint(FD_SPRANDOM, "  region_size:        %"PRIu64"\n", region_sz);
+	dprint(FD_SPRANDOM, "  num_regions:        %u\n", spr_info->num_regions);
+	dprint(FD_SPRANDOM, "  region_write_count: %"PRIu64"\n", region_write_count);
+	dprint(FD_SPRANDOM, "  invalid_capacity:   %zu\n", invalid_capacity);
+	dprint(FD_SPRANDOM, "  dynamic memory:     %zu: %s\n",
+		total_alloc,
+		bytes2str_simple(bytes2str_buf, sizeof(bytes2str_buf), total_alloc));
+
+	return 0;
+err:
+	free(spr_info->validity_dist);
+	free(spr_info->invalid_pct);
+	return -ENOMEM;
+}
+
+/**
+ * sprandom_add_with_probability - Adds an offset to the invalid buffer with
+ * a probability.
+ *
+ * @info: sprandom_info structure containing random state and buffers.
+ * @offset: The offset value to potentially add to the invalid buffer.
+ * @phase: The current phase index for invalid count tracking.
+ *
+ * Generates a random value and, based on the current region's invalid percentage,
+ * decides whether to add the offset to the invalid buffer.
+ * If the buffer is full, ogs an error and asserts failure.
+ */
+static void sprandom_add_with_probability(struct sprandom_info *info,
+					  uint64_t offset, unsigned int phase)
+{
+
+	int v = rand_between(info->rand_state, 0, PCT_PRECISION);
+
+	if (v <= info->invalid_pct[info->current_region]) {
+		if (pcb_space_available(info->invalid_buf)) {
+			pcb_push_staged(info->invalid_buf, offset);
+			info->invalid_count[phase]++;
+		} else {
+			dprint(FD_SPRANDOM, "pcb buffer would be overriten\n");
+			assert(false);
+		}
+	}
+}
+
+static void dprint_invalidation(const struct sprandom_info *info)
+{
+	uint32_t phase = info->curr_phase;
+	double inv = 0;
+	double inv_act; /* actually invalidation percentage */
+
+	inv_act = (double)info->invalid_count[phase] / (double)info->region_write_count;
+	if (info->current_region > 0)
+		inv = (double)info->invalid_pct[info->current_region - 1] / PCT_PRECISION;
+
+	dprint(FD_SPRANDOM, "Invalidation[%d] %"PRIu64" %zu %.04f %.04f\n",
+		info->current_region,
+		info->region_write_count,
+		info->invalid_count[phase],
+		inv, inv_act);
+}
+
+/**
+ * sprandom_get_next_offset - Generate the next write offset for a region,
+ * managing invalidation, and region transitions.
+ *
+ * @info: sprandom_info structure containing state and configuration.
+ * @f: fio file associated with the ssd device.
+ * @b: block offset to store the next write offset.
+ *
+ * Generates offsets to write a region and saves a fraction of the offsets
+ * in a two phase circular buffer.
+ * When transitioning to the next region (phase is flipped),it first writes
+ * all saved offsets to achieve the desired fraction of invalid blocks in the
+ * previous region. The remainder of the current region is then filled with
+ * new offsets.
+ *
+ * Returns:
+ *   0 if a valid offset is found and stored in @b,
+ *   1 if no more offsets are available (end of regions or LFSR exhausted).
+ */
+int sprandom_get_next_offset(struct sprandom_info *info, struct fio_file *f, uint64_t *b)
+{
+	uint64_t offset = 0;
+	uint32_t phase = info->curr_phase;
+
+	/* replay invalidation */
+	if (pcb_pop(info->invalid_buf, &offset)) {
+		sprandom_add_with_probability(info, offset,  phase ^ 1);
+		dprint(FD_SPRANDOM, "Write %"PRIu64" over %d\n", *b, info->current_region);
+		goto out;
+	}
+
+	/* Move to next region */
+	if (info->writes_remaining == 0) {
+		if (info->current_region >= info->num_regions) {
+			dprint(FD_SPRANDOM, "End: Last Region %d cur%d\n",
+			       info->current_region, info->num_regions);
+			return 1;
+		}
+
+		dprint_invalidation(info);
+
+		info->invalid_count[phase] = 0;
+
+		info->current_region++;
+		phase ^= 1;
+		info->writes_remaining = info->region_write_count -
+						info->invalid_count[phase];
+		info->curr_phase = phase;
+		pcb_commit(info->invalid_buf);
+	}
+
+	/* Fetch new offset */
+	if (lfsr_next(&f->lfsr, &offset)) {
+		dprint(FD_SPRANDOM, "End: LFSR exhausted %d [%zu] [%zu]\n",
+			info->current_region,
+			info->invalid_count[phase],
+			info->invalid_count[phase ^ 1]);
+
+		dprint_invalidation(info);
+
+		return 1;
+	}
+
+	if (info->writes_remaining > 0)
+		info->writes_remaining--;
+
+	sprandom_add_with_probability(info, offset,  phase ^ 1);
+	dprint(FD_SPRANDOM, "Write %"PRIu64" lfsr %d\n", offset, info->current_region);
+out:
+	*b = offset;
+	return 0;
+}
+
+/**
+ * sprandom_init - initialize sprandom info
+ * @td: fio thread data
+ * @f: fio file associated with the ssd device.
+ *
+ * Sets up the sprandom_info structure for the given file according:
+ * region count, over-provisioning, and file/device size.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int sprandom_init(struct thread_data *td, struct fio_file *f)
+{
+	struct sprandom_info *info = NULL;
+	double over_provisioning;
+	uint64_t logical_size;
+	uint64_t align_bs = td->o.bs[DDIR_WRITE];
+	int ret;
+
+	if (!td->o.sprandom)
+		return 0;
+
+	if (!is_power_of_2(align_bs)) {
+		log_err("fio: sprandom: bs [%"PRIu64"] should be power of 2",
+			align_bs);
+		return -EINVAL;
+	}
+
+	info = calloc(1, sizeof(*info));
+	if (!info)
+		return -ENOMEM;
+
+	logical_size = min(f->real_file_size, f->io_size);
+	over_provisioning = td->o.spr_over_provisioning.u.f;
+	info->num_regions = td->o.spr_num_regions;
+	info->over_provisioning = over_provisioning;
+	td->o.io_size = sprandom_physical_size(over_provisioning,
+					       logical_size, align_bs);
+	info->rand_state = &td->sprandom_state;
+	ret = sprandom_setup(info, logical_size, align_bs);
+	if (ret)
+		goto err;
+
+	f->spr_info = info;
+	return 0;
+err:
+	free(info);
+	return ret;
+}
+
+/**
+ * sprandom_free - Frees resources associated with a sprandom_info structure.
+ * @info: Pointer to the sprandom_info structure to be freed.
+ *
+ * Releases memory allocated for validity_dist, invalid_buf, and the spr_info
+ * structure itself. Does nothing if @spr_info is NULL.
+ */
+void sprandom_free(struct sprandom_info *info)
+{
+	if (!info)
+		return;
+
+	free(info->validity_dist);
+	free(info->invalid_buf);
+	free(info);
+}
diff --git a/sprandom.h b/sprandom.h
new file mode 100644
index 00000000..ea8b829d
--- /dev/null
+++ b/sprandom.h
@@ -0,0 +1,78 @@
+/**
+ * SPDX-License-Identifier: GPL-2.0 only
+ *
+ * Copyright (c) 2025 Sandisk Corporation or its affiliates.
+ */
+
+#ifndef FIO_SPRANDOM_H
+#define FIO_SPRANDOM_H
+
+#include <stdint.h>
+#include "lib/rand.h"
+#include "pcbuf.h"
+
+/**
+ * struct sprandom_info - information for sprandom operations.
+ *
+ * @over_provisioning:  Over-provisioning ratio for the flash device.
+ * @region_sz:          Size of each region in bytes.
+ * @num_regions:        Number of SPRandom regions.
+ * @validity_dist:      validity for each region.
+ * @invalid_pct:        invalidation percentages per region.
+ * @invalid_buf:        invalidation offsets two pahse buffer.
+ * @invalid_capacity:   maximal size of invalidation buffer for a region.
+ * @invalid_count:      number of invalid offsets in each phase.
+ * @current_region:     index of the current region being processed.
+ * @curr_phase:         current phase of the invalidation process (0 or 1).
+ * @region_write_count: number of writes performed in the current region.
+ * @writes_remaining:   umber of writes left to perform.
+ * @rand_state:         state for the random number generator.
+ */
+struct sprandom_info {
+	double    over_provisioning;
+	uint64_t  region_sz;
+	uint32_t  num_regions;
+
+	double    *validity_dist;
+	uint32_t  *invalid_pct;
+
+	/* Invalidation list*/
+	struct pc_buf *invalid_buf;
+	uint64_t  invalid_capacity;
+	size_t   invalid_count[2];
+	uint32_t current_region;
+	uint32_t curr_phase;
+
+	/* Region and write tracking */
+	uint64_t region_write_count;
+	uint64_t writes_remaining;
+
+	struct frand_state *rand_state;
+};
+
+/**
+ * sprandom_init - Initialize the sprandom for a given file and thread.
+ * @td: FIO thread data
+ * @f: FIO file
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int sprandom_init(struct thread_data *td, struct fio_file *f);
+
+/**
+ * sprandom_free - Frees resources associated with a sprandom_info structure.
+ * @info: sprandom_info structure to be freed.
+ */
+void sprandom_free(struct sprandom_info *info);
+
+/**
+ * sprandom_get_next_offset - Get the next random offset for a file.
+ * @info: sprandom_info structure containing the state
+ * @f: FIO file
+ * @b: Output pointer to store the next offset.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int sprandom_get_next_offset(struct sprandom_info *info, struct fio_file *f, uint64_t *b);
+
+#endif /* FIO_SPRANDOM_H */
diff --git a/thread_options.h b/thread_options.h
index 1b26ab58..3abce731 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -178,6 +178,9 @@ struct thread_options {
 	unsigned int log_alternate_epoch_clock_id;
 	unsigned int norandommap;
 	unsigned int softrandommap;
+	unsigned int sprandom;
+	unsigned int spr_num_regions;
+	fio_fp64_t spr_over_provisioning;
 	unsigned int bs_unaligned;
 	unsigned int fsync_on_close;
 	unsigned int bs_is_seq_rand;
@@ -510,6 +513,9 @@ struct thread_options_pack {
 	uint32_t log_alternate_epoch_clock_id;
 	uint32_t norandommap;
 	uint32_t softrandommap;
+	uint32_t sprandom;
+	uint32_t spr_num_regions;
+	fio_fp64_t spr_over_provisioning;
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
 	uint32_t bs_is_seq_rand;
diff --git a/unittests/lib/num2str.c b/unittests/lib/num2str.c
index 8f12cf83..49e80346 100644
--- a/unittests/lib/num2str.c
+++ b/unittests/lib/num2str.c
@@ -37,11 +37,46 @@ static void test_num2str(void)
 	}
 }
 
+struct bytes2str_testcase {
+        uint64_t bytes;
+        const char *expected;
+};
+
+static const struct bytes2str_testcase bytes2str_testcases[] = {
+        { 0, "0.00 B" },
+        { 512, "512.00 B" },
+        { 1024, "1.00 KiB" },
+        { 1536, "1.50 KiB" },
+        { 1048576, "1.00 MiB" },
+        { 1073741824ULL, "1.00 GiB" },
+        { 1099511627776ULL, "1.00 TiB" },
+        { 1125899906842624ULL, "1.00 PiB" },
+        { 1152921504606846976ULL, "1.00 EiB" },
+};
+
+static void test_bytes2str_simple(void)
+{
+        char buf[64];
+        int i;
+
+        for (i = 0; i < FIO_ARRAY_SIZE(bytes2str_testcases); ++i) {
+                const struct bytes2str_testcase *tc = &bytes2str_testcases[i];
+                const char *result = bytes2str_simple(buf, sizeof(buf), tc->bytes);
+
+                CU_ASSERT_PTR_EQUAL(result, buf);
+                CU_ASSERT_STRING_EQUAL(result, tc->expected);
+        }
+}
+
 static struct fio_unittest_entry tests[] = {
 	{
 		.name	= "num2str/1",
 		.fn	= test_num2str,
 	},
+	{
+                .name   = "bytes2str_simple/1",
+                .fn     = test_bytes2str_simple,
+        },
 	{
 		.name	= NULL,
 	},
diff --git a/unittests/lib/pcbuf.c b/unittests/lib/pcbuf.c
new file mode 100644
index 00000000..f6167423
--- /dev/null
+++ b/unittests/lib/pcbuf.c
@@ -0,0 +1,116 @@
+/**
+ * SPDX-License-Identifier: GPL-2.0 only
+ *
+ * Copyright (c) 2025 Sandisk Corporation or its affiliates.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <string.h>
+
+#include "../unittest.h"
+#include "pcbuf.h"
+
+#define TEST_CAPACITY 8  /* Small capacity for wrap-around testing */
+
+static void test_pcbuf_basic_ops(void)
+{
+	struct pc_buf *cb = pcb_alloc(TEST_CAPACITY);
+	uint64_t i;
+
+	CU_ASSERT_PTR_NOT_NULL(cb);
+
+	CU_ASSERT_TRUE(pcb_is_empty(cb));
+	CU_ASSERT_FALSE(pcb_is_full(cb));
+	CU_ASSERT_EQUAL(pcb_committed_size(cb), 0);
+	CU_ASSERT_EQUAL(pcb_staged_size(cb), 0);
+	CU_ASSERT_TRUE(pcb_space_available(cb));
+
+	/* Stage data up to capacity-1 (since 1 slot is reserved) */
+	for (i = 0; i < TEST_CAPACITY - 1; ++i) {
+		CU_ASSERT_TRUE(pcb_push_staged(cb, i + 100));
+	}
+
+	/* Next push should fail (buffer full) */
+	CU_ASSERT_FALSE(pcb_push_staged(cb, 999));
+
+	CU_ASSERT_EQUAL(pcb_staged_size(cb), TEST_CAPACITY - 1);
+	CU_ASSERT_EQUAL(pcb_committed_size(cb), 0);
+	CU_ASSERT_TRUE(pcb_is_empty(cb));
+	CU_ASSERT_TRUE(pcb_is_full(cb));
+
+	/* Commit staged data */
+	pcb_commit(cb);
+
+	CU_ASSERT_EQUAL(pcb_committed_size(cb), TEST_CAPACITY - 1);
+	CU_ASSERT_EQUAL(pcb_staged_size(cb), 0);
+	CU_ASSERT_FALSE(pcb_is_empty(cb));
+
+	/* Pop all committed data */
+	for (i = 0; i < TEST_CAPACITY - 1; ++i) {
+		uint64_t val;
+		CU_ASSERT_TRUE(pcb_pop(cb, &val));
+		CU_ASSERT_EQUAL(val, i + 100);
+	}
+
+	/* Buffer should now be empty again */
+	CU_ASSERT_TRUE(pcb_is_empty(cb));
+	CU_ASSERT_FALSE(pcb_is_full(cb));
+	CU_ASSERT_TRUE(pcb_space_available(cb));
+
+	free(cb);
+}
+
+static void test_pcbuf_wraparound(void)
+{
+	struct pc_buf *cb = pcb_alloc(TEST_CAPACITY);
+	uint64_t expected[] = {201, 202, 203, 204, 205, 999};
+	size_t num_expected = sizeof(expected)/sizeof(expected[0]);
+	uint64_t val;
+	uint64_t i;
+
+	CU_ASSERT_PTR_NOT_NULL(cb);
+
+	/* Stage up to near capacity and commit */
+	for (i = 0; i < TEST_CAPACITY - 2; ++i)
+		CU_ASSERT_TRUE(pcb_push_staged(cb, i + 200));
+
+	pcb_commit(cb);
+
+	/* Pop one item to move read_tail forward */
+	CU_ASSERT_TRUE(pcb_pop(cb, &val));
+	CU_ASSERT_EQUAL(val, 200);
+
+	/* Now stage one more item to cause wraparound */
+	CU_ASSERT_TRUE(pcb_push_staged(cb, 999));
+	pcb_commit(cb);
+
+	/* Pop remaining items, ensure correctness */
+	for (i = 0; i < num_expected; ++i) {
+		CU_ASSERT_TRUE(pcb_pop(cb, &val));
+		CU_ASSERT_EQUAL(val, expected[i]);
+	}
+
+	CU_ASSERT_TRUE(pcb_is_empty(cb));
+	free(cb);
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name   = "pcbuf/basic_ops",
+		.fn     = test_pcbuf_basic_ops,
+	},
+	{
+		.name   = "pcbuf/wraparound",
+		.fn     = test_pcbuf_wraparound,
+	},
+	{
+		.name   = NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_lib_pcbuf(void)
+{
+	return fio_unittest_add_suite("pcbuf.h", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index f490b485..4a034b40 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -50,6 +50,7 @@ int main(void)
 	fio_unittest_register(fio_unittest_lib_memalign);
 	fio_unittest_register(fio_unittest_lib_num2str);
 	fio_unittest_register(fio_unittest_lib_strntol);
+	fio_unittest_register(fio_unittest_lib_pcbuf);
 	fio_unittest_register(fio_unittest_oslib_strlcat);
 	fio_unittest_register(fio_unittest_oslib_strndup);
 	fio_unittest_register(fio_unittest_oslib_strcasestr);
diff --git a/unittests/unittest.h b/unittests/unittest.h
index ecb7d124..0f45bfbd 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -17,6 +17,7 @@ CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
 CU_ErrorCode fio_unittest_lib_memalign(void);
 CU_ErrorCode fio_unittest_lib_num2str(void);
 CU_ErrorCode fio_unittest_lib_strntol(void);
+CU_ErrorCode fio_unittest_lib_pcbuf(void);
 CU_ErrorCode fio_unittest_oslib_strlcat(void);
 CU_ErrorCode fio_unittest_oslib_strndup(void);
 CU_ErrorCode fio_unittest_oslib_strcasestr(void);
diff --git a/verify.c b/verify.c
index c7f43c06..20c49a94 100644
--- a/verify.c
+++ b/verify.c
@@ -431,7 +431,7 @@ done:
  */
 static inline bool pattern_need_buffer(struct thread_data *td)
 {
-	return td->o.verify_async &&
+	return (td->o.verify_async || td->o.use_thread) &&
 		td->o.verify_fmt_sz &&
 		td->o.verify_fmt[0].desc->paste == paste_blockoff;
 }
