Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44704 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdHOMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Aug 2017 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dhaW2-0001ep-Mv
        for fio@vger.kernel.org; Tue, 15 Aug 2017 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170815120001.E2C0A2C2BEC@kernel.dk>
Date: Tue, 15 Aug 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a94a977497636bdcbef7106ce3617c96c8ad66bd:

  HOWTO: fix unit type suffix in "Parameter types" section to upper case (2017-08-09 08:14:18 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 29092211c1f926541db0e2863badc03d7378b31a:

  HOWTO: update and clarify description of latencies in normal output (2017-08-14 13:02:49 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'serialize_overlap' of https://github.com/sitsofe/fio
      backend: cleanup overlap submission logic
      Merge branch 'ci' of https://github.com/sitsofe/fio

Sitsofe Wheeler (6):
      Makefile: modify make test to use a filesystem file
      ci: make CI builds fail on compilation warnings
      fio: add serialize_overlap option
      iolog: fix double free when verified I/O overlaps
      iolog: remove random layout verification optimisation
      iolog: tidy up log_io_piece() conditional

Vincent Fu (2):
      stat: change indentation of the lat (nsec/usec/msec) section in the normal output
      HOWTO: update and clarify description of latencies in normal output

 .travis.yml      |  2 ++
 HOWTO            | 44 ++++++++++++++++++++++++++++++++++----------
 Makefile         |  2 +-
 appveyor.yml     |  2 +-
 backend.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 cconv.c          |  2 ++
 fio.1            | 14 ++++++++++++++
 init.c           | 17 +++++++++++++++++
 iolog.c          | 24 ++++++++++--------------
 options.c        | 11 +++++++++++
 stat.c           |  2 +-
 thread_options.h |  3 +++
 12 files changed, 142 insertions(+), 29 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index e84e61f..4cdda12 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -26,3 +26,5 @@ matrix:
 before_install:
   - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then sudo apt-get -qq update; fi
   - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then sudo apt-get install -qq -y libaio-dev libnuma-dev libz-dev; fi
+script:
+  - ./configure --extra-cflags="-Werror" && make && make test
diff --git a/HOWTO b/HOWTO
index fc173f0..71d9fa5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2030,6 +2030,21 @@ I/O depth
 	16 requests, it will let the depth drain down to 4 before starting to fill
 	it again.
 
+.. option:: serialize_overlap=bool
+
+	Serialize in-flight I/Os that might otherwise cause or suffer from data races.
+	When two or more I/Os are submitted simultaneously, there is no guarantee that
+	the I/Os will be processed or completed in the submitted order. Further, if
+	two or more of those I/Os are writes, any overlapping region between them can
+	become indeterminate/undefined on certain storage. These issues can cause
+	verification to fail erratically when at least one of the racing I/Os is
+	changing data and the overlapping region has a non-zero size. Setting
+	``serialize_overlap`` tells fio to avoid provoking this behavior by explicitly
+	serializing in-flight I/Os that have a non-zero overlap. Note that setting
+	this option can reduce both performance and the `:option:iodepth` achieved.
+	Additionally this option does not work when :option:`io_submit_mode` is set to
+	offload. Default: false.
+
 .. option:: io_submit_mode=str
 
 	This option controls how fio submits the I/O to the I/O engine. The default
@@ -2605,7 +2620,6 @@ Verification
 
 	Enable experimental verification.
 
-
 Steady state
 ~~~~~~~~~~~~
 
@@ -3122,9 +3136,9 @@ group) the output looks like::
 	     | 99.99th=[78119]
 	   bw (  KiB/s): min=  532, max=  686, per=0.10%, avg=622.87, stdev=24.82, samples=  100
 	   iops        : min=   76, max=   98, avg=88.98, stdev= 3.54, samples=  100
-	    lat (usec) : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
-	    lat (msec) : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
-	    lat (msec) : 100=0.65%
+	  lat (usec)   : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
+	  lat (msec)   : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
+	  lat (msec)   : 100=0.65%
 	  cpu          : usr=0.27%, sys=0.18%, ctx=12072, majf=0, minf=21
 	  IO depths    : 1=85.0%, 2=13.1%, 4=1.8%, 8=0.1%, 16=0.0%, 32=0.0%, >=64=0.0%
 	     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
@@ -3163,6 +3177,10 @@ writes in the example above).  In the order listed, they denote:
 		complete is basically just CPU time (I/O has already been done, see slat
 		explanation).
 
+**lat**
+		Total latency. Same names as slat and clat, this denotes the time from
+		when fio created the I/O unit to completion of the I/O operation.
+
 **bw**
 		Bandwidth statistics based on samples. Same names as the xlat stats,
 		but also includes the number of samples taken (**samples**) and an
@@ -3174,6 +3192,14 @@ writes in the example above).  In the order listed, they denote:
 **iops**
 		IOPS statistics based on samples. Same names as bw.
 
+**lat (nsec/usec/msec)**
+		The distribution of I/O completion latencies. This is the time from when
+		I/O leaves fio and when it gets completed. Unlike the separate
+		read/write/trim sections above, the data here and in the remaining
+		sections apply to all I/Os for the reporting group. 250=0.04% means that
+		0.04% of the I/Os completed in under 250us. 500=64.11% means that 64.11%
+		of the I/Os required 250 to 499us for completion.
+
 **cpu**
 		CPU usage. User and system time, along with the number of context
 		switches this thread went through, usage of system and user time, and
@@ -3204,12 +3230,10 @@ writes in the example above).  In the order listed, they denote:
 		The number of read/write/trim requests issued, and how many of them were
 		short or dropped.
 
-**IO latencies**
-		The distribution of I/O completion latencies. This is the time from when
-		I/O leaves fio and when it gets completed.  The numbers follow the same
-		pattern as the I/O depths, meaning that 2=1.6% means that 1.6% of the
-		I/O completed within 2 msecs, 20=12.8% means that 12.8% of the I/O took
-		more than 10 msecs, but less than (or equal to) 20 msecs.
+**IO latency**
+		These values are for `--latency-target` and related options. When
+		these options are engaged, this section describes the I/O depth required
+		to meet the specified latency target.
 
 ..
 	Example output was based on the following:
diff --git a/Makefile b/Makefile
index 540ffb2..3764da5 100644
--- a/Makefile
+++ b/Makefile
@@ -471,7 +471,7 @@ doc: tools/plot/fio2gnuplot.1
 	@man -t tools/hist/fiologparser_hist.py.1 | ps2pdf - fiologparser_hist.pdf
 
 test: fio
-	./fio --minimal --thread --ioengine=null --runtime=1s --name=nulltest --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifynulltest --rw=write --verify=crc32c --verify_state_save=0 --size=100M
+	./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
 
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
diff --git a/appveyor.yml b/appveyor.yml
index 7543393..39f50a8 100644
--- a/appveyor.yml
+++ b/appveyor.yml
@@ -13,7 +13,7 @@ environment:
 
 build_script:
   - SET PATH=%CYG_ROOT%\bin;%PATH%
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure ${CONFIGURE_OPTIONS} && make.exe'
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
 
 after_build:
   - cd os\windows && dobuild.cmd %BUILD_ARCH%
diff --git a/backend.c b/backend.c
index fe15997..d2675b4 100644
--- a/backend.c
+++ b/backend.c
@@ -587,6 +587,50 @@ static int unlink_all_files(struct thread_data *td)
 }
 
 /*
+ * Check if io_u will overlap an in-flight IO in the queue
+ */
+static bool in_flight_overlap(struct io_u_queue *q, struct io_u *io_u)
+{
+	bool overlap;
+	struct io_u *check_io_u;
+	unsigned long long x1, x2, y1, y2;
+	int i;
+
+	x1 = io_u->offset;
+	x2 = io_u->offset + io_u->buflen;
+	overlap = false;
+	io_u_qiter(q, check_io_u, i) {
+		if (check_io_u->flags & IO_U_F_FLIGHT) {
+			y1 = check_io_u->offset;
+			y2 = check_io_u->offset + check_io_u->buflen;
+
+			if (x1 < y2 && y1 < x2) {
+				overlap = true;
+				dprint(FD_IO, "in-flight overlap: %llu/%lu, %llu/%lu\n",
+						x1, io_u->buflen,
+						y1, check_io_u->buflen);
+				break;
+			}
+		}
+	}
+
+	return overlap;
+}
+
+static int io_u_submit(struct thread_data *td, struct io_u *io_u)
+{
+	/*
+	 * Check for overlap if the user asked us to, and we have
+	 * at least one IO in flight besides this one.
+	 */
+	if (td->o.serialize_overlap && td->cur_depth > 1 &&
+	    in_flight_overlap(&td->io_u_all, io_u))
+		return FIO_Q_BUSY;
+
+	return td_io_queue(td, io_u);
+}
+
+/*
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
  */
@@ -716,7 +760,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 		if (!td->o.disable_slat)
 			fio_gettime(&io_u->start_time, NULL);
 
-		ret = td_io_queue(td, io_u);
+		ret = io_u_submit(td, io_u);
 
 		if (io_queue_event(td, io_u, &ret, ddir, NULL, 1, NULL))
 			break;
@@ -983,7 +1027,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 				td->rate_next_io_time[ddir] = usec_for_io(td, ddir);
 
 		} else {
-			ret = td_io_queue(td, io_u);
+			ret = io_u_submit(td, io_u);
 
 			if (should_check_rate(td))
 				td->rate_next_io_time[ddir] = usec_for_io(td, ddir);
diff --git a/cconv.c b/cconv.c
index f9f2b30..ac58705 100644
--- a/cconv.c
+++ b/cconv.c
@@ -96,6 +96,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->iodepth_batch = le32_to_cpu(top->iodepth_batch);
 	o->iodepth_batch_complete_min = le32_to_cpu(top->iodepth_batch_complete_min);
 	o->iodepth_batch_complete_max = le32_to_cpu(top->iodepth_batch_complete_max);
+	o->serialize_overlap = le32_to_cpu(top->serialize_overlap);
 	o->size = le64_to_cpu(top->size);
 	o->io_size = le64_to_cpu(top->io_size);
 	o->size_percent = le32_to_cpu(top->size_percent);
@@ -346,6 +347,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->iodepth_batch = cpu_to_le32(o->iodepth_batch);
 	top->iodepth_batch_complete_min = cpu_to_le32(o->iodepth_batch_complete_min);
 	top->iodepth_batch_complete_max = cpu_to_le32(o->iodepth_batch_complete_max);
+	top->serialize_overlap = cpu_to_le32(o->serialize_overlap);
 	top->size_percent = cpu_to_le32(o->size_percent);
 	top->fill_device = cpu_to_le32(o->fill_device);
 	top->file_append = cpu_to_le32(o->file_append);
diff --git a/fio.1 b/fio.1
index a3fba65..14359e6 100644
--- a/fio.1
+++ b/fio.1
@@ -1044,6 +1044,20 @@ we simply do polling.
 Low watermark indicating when to start filling the queue again.  Default:
 \fBiodepth\fR.
 .TP
+.BI serialize_overlap \fR=\fPbool
+Serialize in-flight I/Os that might otherwise cause or suffer from data races.
+When two or more I/Os are submitted simultaneously, there is no guarantee that
+the I/Os will be processed or completed in the submitted order. Further, if
+two or more of those I/Os are writes, any overlapping region between them can
+become indeterminate/undefined on certain storage. These issues can cause
+verification to fail erratically when at least one of the racing I/Os is
+changing data and the overlapping region has a non-zero size. Setting
+\fBserialize_overlap\fR tells fio to avoid provoking this behavior by explicitly
+serializing in-flight I/Os that have a non-zero overlap. Note that setting
+this option can reduce both performance and the \fBiodepth\fR achieved.
+Additionally this option does not work when \fBio_submit_mode\fR is set to
+offload. Default: false.
+.TP
 .BI io_submit_mode \fR=\fPstr
 This option controls how fio submits the IO to the IO engine. The default is
 \fBinline\fR, which means that the fio job threads submit and reap IO directly.
diff --git a/init.c b/init.c
index 42e7107..164e411 100644
--- a/init.c
+++ b/init.c
@@ -698,6 +698,23 @@ static int fixup_options(struct thread_data *td)
 	if (o->iodepth_batch_complete_min > o->iodepth_batch_complete_max)
 		o->iodepth_batch_complete_max = o->iodepth_batch_complete_min;
 
+	/*
+	 * There's no need to check for in-flight overlapping IOs if the job
+	 * isn't changing data or the maximum iodepth is guaranteed to be 1
+	 */
+	if (o->serialize_overlap && !(td->flags & TD_F_READ_IOLOG) &&
+	    (!(td_write(td) || td_trim(td)) || o->iodepth == 1))
+		o->serialize_overlap = 0;
+	/*
+	 * Currently can't check for overlaps in offload mode
+	 */
+	if (o->serialize_overlap && o->io_submit_mode == IO_MODE_OFFLOAD) {
+		log_err("fio: checking for in-flight overlaps when the "
+			"io_submit_mode is offload is not supported\n");
+		o->serialize_overlap = 0;
+		ret = warnings_fatal;
+	}
+
 	if (o->nr_files > td->files_index)
 		o->nr_files = td->files_index;
 
diff --git a/iolog.c b/iolog.c
index 27c14eb..760d7b0 100644
--- a/iolog.c
+++ b/iolog.c
@@ -227,21 +227,16 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	}
 
 	/*
-	 * We don't need to sort the entries, if:
+	 * We don't need to sort the entries if we only performed sequential
+	 * writes. In this case, just reading back data in the order we wrote
+	 * it out is the faster but still safe.
 	 *
-	 *	Sequential writes, or
-	 *	Random writes that lay out the file as it goes along
-	 *
-	 * For both these cases, just reading back data in the order we
-	 * wrote it out is the fastest.
-	 *
-	 * One exception is if we don't have a random map AND we are doing
-	 * verifies, in that case we need to check for duplicate blocks and
-	 * drop the old one, which we rely on the rb insert/lookup for
-	 * handling.
+	 * One exception is if we don't have a random map in which case we need
+	 * to check for duplicate blocks and drop the old one, which we rely on
+	 * the rb insert/lookup for handling.
 	 */
-	if (((!td->o.verifysort) || !td_random(td) || !td->o.overwrite) &&
-	      (file_randommap(td, ipo->file) || td->o.verify == VERIFY_NONE)) {
+	if (((!td->o.verifysort) || !td_random(td)) &&
+	      file_randommap(td, ipo->file)) {
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
 		ipo->flags |= IP_F_ONLIST;
@@ -284,7 +279,8 @@ restart:
 			td->io_hist_len--;
 			rb_erase(parent, &td->io_hist_tree);
 			remove_trim_entry(td, __ipo);
-			free(__ipo);
+			if (!(__ipo->flags & IP_F_IN_FLIGHT))
+				free(__ipo);
 			goto restart;
 		}
 	}
diff --git a/options.c b/options.c
index f2b2bb9..443791a 100644
--- a/options.c
+++ b/options.c
@@ -1882,6 +1882,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_BASIC,
 	},
 	{
+		.name	= "serialize_overlap",
+		.lname	= "Serialize overlap",
+		.off1	= offsetof(struct thread_options, serialize_overlap),
+		.type	= FIO_OPT_BOOL,
+		.help	= "Wait for in-flight IOs that collide to complete",
+		.parent	= "iodepth",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BASIC,
+	},
+	{
 		.name	= "io_submit_mode",
 		.lname	= "IO submit mode",
 		.type	= FIO_OPT_STR,
diff --git a/stat.c b/stat.c
index aebd107..4aa9cb8 100644
--- a/stat.c
+++ b/stat.c
@@ -520,7 +520,7 @@ static int show_lat(double *io_u_lat, int nr, const char **ranges,
 		if (new_line) {
 			if (line)
 				log_buf(out, "\n");
-			log_buf(out, "    lat (%s) : ", msg);
+			log_buf(out, "  lat (%s)   : ", msg);
 			new_line = 0;
 			line = 0;
 		}
diff --git a/thread_options.h b/thread_options.h
index f3dfd42..26a3e0e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -65,6 +65,7 @@ struct thread_options {
 	unsigned int iodepth_batch;
 	unsigned int iodepth_batch_complete_min;
 	unsigned int iodepth_batch_complete_max;
+	unsigned int serialize_overlap;
 
 	unsigned int unique_filename;
 
@@ -340,6 +341,8 @@ struct thread_options_pack {
 	uint32_t iodepth_batch;
 	uint32_t iodepth_batch_complete_min;
 	uint32_t iodepth_batch_complete_max;
+	uint32_t serialize_overlap;
+	uint32_t pad3;
 
 	uint64_t size;
 	uint64_t io_size;
