Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8ECC433F5
	for <fio@archiver.kernel.org>; Sat, 12 Feb 2022 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiBLNAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 12 Feb 2022 08:00:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiBLNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 12 Feb 2022 08:00:13 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A90D26543
        for <fio@vger.kernel.org>; Sat, 12 Feb 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=8q54Lshu9ffSPPtshThJD+Gw8hfAdiKIqg+Ma7ISjqU=; b=W24aA/Wz6C1no0wBi6S4vI/OZh
        bxNgYpAgsuFEyO4DhfEH7QmmleRDnkImXpeNs+uoDhXRJG8WUQqXb0s/JF7uslpD8heYNETt10oZZ
        9+3Vv+0eiR7rSxJeapP0cQbYVGZEItQArl8A1s3VXmw38zQFTGgkM2hVFDCXp4Wz8hUDYTDjsKjim
        b1fF9QHgxPsU3KV/ZLBjwWO9gERGDJrYpcRiF5cyrxYnW0sYdWfkkkfjIEhtVZ+ts4WJ5Vx4PjamH
        M6yLu5EUJS6z7ugbQyT7iHfO8He8hp8a/qQd5P4rNKVZetQ4trxlw67ETq2wn2AfLXBnfQu22mDBd
        sXFG+f0w==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIs0U-009JK0-0Z
        for fio@vger.kernel.org; Sat, 12 Feb 2022 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3050E1BC0165; Sat, 12 Feb 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220212130002.3050E1BC0165@kernel.dk>
Date:   Sat, 12 Feb 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit df597be63e26ef59c1538b3ce2026c83684ff7fb:

  fio: really use LDFLAGS when linking dynamic engines (2022-02-08 09:28:30 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a1db4528a59a99c5e2aa66091c505fb60e3a70ca:

  Merge branch 'fio-docs-ci' of https://github.com/vincentkfu/fio (2022-02-11 16:29:44 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      t/io_uring: avoid unused `nr_batch` warning
      Add aarch64 cpu clock support
      Merge branch 'fio_offload_fixes' of https://github.com/PCPartPicker/fio
      Merge branch 'fio-docs-ci' of https://github.com/vincentkfu/fio

Vincent Fu (8):
      docs: document cpumode option for the cpuio ioengine
      docs: update Makefile in order to detect build failures
      docs: rename HOWTO to HOWTO.rst
      HOWTO: combine multiple pool option listings
      HOWTO: combine separate hipri listings into a single one
      HOWTO: combine two chunk_size listings into a single one
      ci: install sphinx packages and add doc building to GitHub Actions
      windows: update the installer build for renamed files

aggieNick02 (1):
      Fix issues (assert or uninit var, hang) with check_min_rate and offloading

 HOWTO => HOWTO.rst      | 126 ++++++++++++++++++++++++++++--------------------
 arch/arch-aarch64.h     |  17 +++++++
 backend.c               |   9 +++-
 ci/actions-full-test.sh |   1 +
 ci/actions-install.sh   |   3 +-
 doc/Makefile            |   2 +-
 doc/fio_doc.rst         |   2 +-
 doc/fio_man.rst         |   2 +-
 fio.1                   |  13 +++++
 os/windows/install.wxs  |   4 +-
 t/io_uring.c            |   9 ++--
 11 files changed, 124 insertions(+), 64 deletions(-)
 rename HOWTO => HOWTO.rst (99%)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO.rst
similarity index 99%
rename from HOWTO
rename to HOWTO.rst
index 74ba7216..ac1f3478 100644
--- a/HOWTO
+++ b/HOWTO.rst
@@ -2137,8 +2137,10 @@ I/O engine
 			Asynchronous read and write using DDN's Infinite Memory Engine (IME).
 			This engine will try to stack as much IOs as possible by creating
 			requests for IME. FIO will then decide when to commit these requests.
+
 		**libiscsi**
 			Read and write iscsi lun with libiscsi.
+
 		**nbd**
 			Read and write a Network Block Device (NBD).
 
@@ -2149,6 +2151,7 @@ I/O engine
 			unless :option:`verify` is set or :option:`cuda_io` is `posix`.
 			:option:`iomem` must not be `cudamalloc`. This ioengine defines
 			engine specific options.
+
 		**dfs**
 			I/O engine supporting asynchronous read and write operations to the
 			DAOS File System (DFS) via libdfs.
@@ -2175,8 +2178,8 @@ with the caveat that when used on the command line, they must come after the
     Set the percentage of I/O that will be issued with the highest priority.
     Default: 0. A single value applies to reads and writes. Comma-separated
     values may be specified for reads and writes. For this option to be
-    effective, NCQ priority must be supported and enabled, and `direct=1'
-    option must be used. fio must also be run as the root user. Unlike
+    effective, NCQ priority must be supported and enabled, and the :option:`direct`
+    option must be set. fio must also be run as the root user. Unlike
     slat/clat/lat stats, which can be tracked and reported independently, per
     priority stats only track and report a single type of latency. By default,
     completion latency (clat) will be reported, if :option:`lat_percentiles` is
@@ -2207,6 +2210,7 @@ with the caveat that when used on the command line, they must come after the
 	meaning of priority may differ. See also the :option:`prio` option.
 
 .. option:: cmdprio_bssplit=str[,str] : [io_uring] [libaio]
+
 	To get a finer control over I/O priority, this option allows
 	specifying the percentage of IOs that must have a priority set
 	depending on the block size of the IO. This option is useful only
@@ -2243,14 +2247,6 @@ with the caveat that when used on the command line, they must come after the
     map and release for each IO. This is more efficient, and reduces the
     IO latency as well.
 
-.. option:: hipri : [io_uring]
-
-    If this option is set, fio will attempt to use polled IO completions.
-    Normal IO completions generate interrupts to signal the completion of
-    IO, polled completions do not. Hence they are require active reaping
-    by the application. The benefits are more efficient IO for high IOPS
-    scenarios, and lower latencies for low queue depth IO.
-
 .. option:: registerfiles : [io_uring]
 
 	With this option, fio registers the set of files being used with the
@@ -2271,6 +2267,33 @@ with the caveat that when used on the command line, they must come after the
 	When :option:`sqthread_poll` is set, this option provides a way to
 	define which CPU should be used for the polling thread.
 
+.. option:: hipri
+
+   [io_uring]
+
+        If this option is set, fio will attempt to use polled IO completions.
+        Normal IO completions generate interrupts to signal the completion of
+        IO, polled completions do not. Hence they are require active reaping
+        by the application. The benefits are more efficient IO for high IOPS
+        scenarios, and lower latencies for low queue depth IO.
+
+   [pvsync2]
+
+	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
+	than normal.
+
+   [sg]
+
+	If this option is set, fio will attempt to use polled IO completions.
+	This will have a similar effect as (io_uring)hipri. Only SCSI READ and
+	WRITE commands will have the SGV4_FLAG_HIPRI set (not UNMAP (trim) nor
+	VERIFY). Older versions of the Linux sg driver that do not support
+	hipri will simply ignore this flag and do normal IO. The Linux SCSI
+	Low Level Driver (LLD) that "owns" the device also needs to support
+	hipri (also known as iopoll and mq_poll). The MegaRAID driver is an
+	example of a SCSI LLD. Default: clear (0) which does normal
+	(interrupted based) IO.
+
 .. option:: userspace_reap : [libaio]
 
 	Normally, with the libaio engine in use, fio will use the
@@ -2279,11 +2302,6 @@ with the caveat that when used on the command line, they must come after the
 	reap events. The reaping mode is only enabled when polling for a minimum of
 	0 events (e.g. when :option:`iodepth_batch_complete` `=0`).
 
-.. option:: hipri : [pvsync2]
-
-	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
-	than normal.
-
 .. option:: hipri_percentage : [pvsync2]
 
 	When hipri is set this determines the probability of a pvsync2 I/O being high
@@ -2318,6 +2336,16 @@ with the caveat that when used on the command line, they must come after the
 
 	Split the load into cycles of the given time. In microseconds.
 
+.. option:: cpumode=str : [cpuio]
+
+	Specify how to stress the CPU. It can take these two values:
+
+	**noop**
+		This is the default where the CPU executes noop instructions.
+	**qsort**
+		Replace the default noop instructions loop with a qsort algorithm to
+		consume more energy.
+
 .. option:: exit_on_io_done=bool : [cpuio]
 
 	Detect when I/O threads are done, then exit.
@@ -2444,10 +2472,6 @@ with the caveat that when used on the command line, they must come after the
 
 	Specifies the name of the RBD.
 
-.. option:: pool=str : [rbd,rados]
-
-	Specifies the name of the Ceph pool containing RBD or RADOS data.
-
 .. option:: clientname=str : [rbd,rados]
 
 	Specifies the username (without the 'client.' prefix) used to access the
@@ -2466,6 +2490,36 @@ with the caveat that when used on the command line, they must come after the
         Touching all objects affects ceph caches and likely impacts test results.
         Enabled by default.
 
+.. option:: pool=str :
+
+   [rbd,rados]
+
+	Specifies the name of the Ceph pool containing RBD or RADOS data.
+
+   [dfs]
+
+	Specify the label or UUID of the DAOS pool to connect to.
+
+.. option:: cont=str : [dfs]
+
+	Specify the label or UUID of the DAOS container to open.
+
+.. option:: chunk_size=int
+
+   [dfs]
+
+	Specificy a different chunk size (in bytes) for the dfs file.
+	Use DAOS container's chunk size by default.
+
+   [libhdfs]
+
+	The size of the chunk to use for each file.
+
+.. option:: object_class=str : [dfs]
+
+	Specificy a different object class for the dfs file.
+	Use DAOS container's object class by default.
+
 .. option:: skip_bad=bool : [mtd]
 
 	Skip operations against known bad blocks.
@@ -2474,10 +2528,6 @@ with the caveat that when used on the command line, they must come after the
 
 	libhdfs will create chunk in this HDFS directory.
 
-.. option:: chunk_size : [libhdfs]
-
-	The size of the chunk to use for each file.
-
 .. option:: verb=str : [rdma]
 
 	The RDMA verb to use on this side of the RDMA ioengine connection. Valid
@@ -2563,18 +2613,6 @@ with the caveat that when used on the command line, they must come after the
 	a valid stream identifier) fio will open a stream and then close it when done. Default
 	is 0.
 
-.. option:: hipri : [sg]
-
-	If this option is set, fio will attempt to use polled IO completions.
-	This will have a similar effect as (io_uring)hipri. Only SCSI READ and
-	WRITE commands will have the SGV4_FLAG_HIPRI set (not UNMAP (trim) nor
-	VERIFY). Older versions of the Linux sg driver that do not support
-	hipri will simply ignore this flag and do normal IO. The Linux SCSI
-	Low Level Driver (LLD) that "owns" the device also needs to support
-	hipri (also known as iopoll and mq_poll). The MegaRAID driver is an
-	example of a SCSI LLD. Default: clear (0) which does normal
-	(interrupted based) IO.
-
 .. option:: http_host=str : [http]
 
 	Hostname to connect to. For S3, this could be the bucket hostname.
@@ -2654,24 +2692,6 @@ with the caveat that when used on the command line, they must come after the
 		GPU to RAM before a write and copied from RAM to GPU after a
 		read. :option:`verify` does not affect use of cudaMemcpy.
 
-.. option:: pool=str : [dfs]
-
-	Specify the label or UUID of the DAOS pool to connect to.
-
-.. option:: cont=str : [dfs]
-
-	Specify the label or UUID of the DAOS container to open.
-
-.. option:: chunk_size=int : [dfs]
-
-	Specificy a different chunk size (in bytes) for the dfs file.
-	Use DAOS container's chunk size by default.
-
-.. option:: object_class=str : [dfs]
-
-	Specificy a different object class for the dfs file.
-	Use DAOS container's object class by default.
-
 .. option:: nfs_url=str : [nfs]
 
 	URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]
diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 2a86cc5a..94571709 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -27,4 +27,21 @@ static inline int arch_ffz(unsigned long bitmask)
 
 #define ARCH_HAVE_FFZ
 
+static inline unsigned long long get_cpu_clock(void)
+{
+	unsigned long val;
+
+	asm volatile("mrs %0, cntvct_el0" : "=r" (val));
+	return val;
+}
+#define ARCH_HAVE_CPU_CLOCK
+
+#define ARCH_HAVE_INIT
+extern bool tsc_reliable;
+static inline int arch_init(char *envp[])
+{
+	tsc_reliable = true;
+	return 0;
+}
+
 #endif
diff --git a/backend.c b/backend.c
index 061e3b32..c035baed 100644
--- a/backend.c
+++ b/backend.c
@@ -1091,8 +1091,10 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 				td->rate_io_issue_bytes[__ddir] += blen;
 			}
 
-			if (should_check_rate(td))
+			if (should_check_rate(td)) {
 				td->rate_next_io_time[__ddir] = usec_for_io(td, __ddir);
+				fio_gettime(&comp_time, NULL);
+			}
 
 		} else {
 			ret = io_u_submit(td, io_u);
@@ -1172,8 +1174,11 @@ reap:
 								f->file_name);
 			}
 		}
-	} else
+	} else {
+		if (td->o.io_submit_mode == IO_MODE_OFFLOAD)
+			workqueue_flush(&td->io_wq);
 		cleanup_pending_aio(td);
+	}
 
 	/*
 	 * stop job if we failed doing any IO
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 4ae1dba1..91790664 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -10,6 +10,7 @@ main() {
     else
         sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
     fi
+    make -C doc html
 }
 
 main
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index b3486a47..0e472717 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -60,6 +60,7 @@ DPKGCFG
     # care about the architecture.
     pkgs+=(
         python3-scipy
+	python3-sphinx
     )
 
     echo "Updating APT..."
@@ -78,7 +79,7 @@ install_macos() {
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
     HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit
-    pip3 install scipy six
+    pip3 install scipy six sphinx
 }
 
 main() {
diff --git a/doc/Makefile b/doc/Makefile
index 3b979f9a..a444d83a 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -2,7 +2,7 @@
 #
 
 # You can set these variables from the command line.
-SPHINXOPTS    =
+SPHINXOPTS    = -W --keep-going
 SPHINXBUILD   = sphinx-build
 PAPER         =
 BUILDDIR      = output
diff --git a/doc/fio_doc.rst b/doc/fio_doc.rst
index 8e1216f0..34e7fde9 100644
--- a/doc/fio_doc.rst
+++ b/doc/fio_doc.rst
@@ -5,7 +5,7 @@ fio - Flexible I/O tester rev. |version|
 .. include:: ../README.rst
 
 
-.. include:: ../HOWTO
+.. include:: ../HOWTO.rst
 
 
 
diff --git a/doc/fio_man.rst b/doc/fio_man.rst
index 44312f16..dc1d1c0d 100644
--- a/doc/fio_man.rst
+++ b/doc/fio_man.rst
@@ -9,4 +9,4 @@ Fio Manpage
 .. include:: ../README.rst
 
 
-.. include:: ../HOWTO
+.. include:: ../HOWTO.rst
diff --git a/fio.1 b/fio.1
index f32d7915..e23d4092 100644
--- a/fio.1
+++ b/fio.1
@@ -2091,6 +2091,19 @@ option when using cpuio I/O engine.
 .BI (cpuio)cpuchunks \fR=\fPint
 Split the load into cycles of the given time. In microseconds.
 .TP
+.BI (cpuio)cpumode \fR=\fPstr
+Specify how to stress the CPU. It can take these two values:
+.RS
+.RS
+.TP
+.B noop
+This is the default and directs the CPU to execute noop instructions.
+.TP
+.B qsort
+Replace the default noop instructions with a qsort algorithm to consume more energy.
+.RE
+.RE
+.TP
 .BI (cpuio)exit_on_io_done \fR=\fPbool
 Detect when I/O threads are done, then exit.
 .TP
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 7773bb3b..f2753289 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -33,13 +33,13 @@
 						</Component>
 						<?endif?>
 						<Component>
-							<File Id="README" Name="README.txt" Source="..\..\README"/>
+							<File Id="README" Name="README.txt" Source="..\..\README.rst"/>
 						</Component>
 						<Component>
 							<File Id="REPORTING_BUGS" Name="REPORTING-BUGS.txt" Source="..\..\REPORTING-BUGS"/>
 						</Component>
 						<Component>
-							<File Id="HOWTO" Name="HOWTO.txt" Source="..\..\HOWTO"/>
+							<File Id="HOWTO" Name="HOWTO.txt" Source="..\..\HOWTO.rst"/>
 						</Component>
 						<Component>
 							<File Id="COPYING" Name="COPYING.txt" Source="..\..\COPYING"/>
diff --git a/t/io_uring.c b/t/io_uring.c
index faf5978c..4520de43 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -714,12 +714,15 @@ static int reap_events_aio(struct submitter *s, struct io_event *events, int evs
 static void *submitter_aio_fn(void *data)
 {
 	struct submitter *s = data;
-	int i, ret, prepped, nr_batch;
+	int i, ret, prepped;
 	struct iocb **iocbsptr;
 	struct iocb *iocbs;
 	struct io_event *events;
-
-	nr_batch = submitter_init(s);
+#ifdef ARCH_HAVE_CPU_CLOCK
+	int nr_batch = submitter_init(s);
+#else
+	submitter_init(s);
+#endif
 
 	iocbsptr = calloc(depth, sizeof(struct iocb *));
 	iocbs = calloc(depth, sizeof(struct iocb));
