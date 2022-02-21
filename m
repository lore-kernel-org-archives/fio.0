Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A340BC433EF
	for <fio@archiver.kernel.org>; Mon, 21 Feb 2022 13:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358452AbiBUNAg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Feb 2022 08:00:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348732AbiBUNAf (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Feb 2022 08:00:35 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E0F1EADA
        for <fio@vger.kernel.org>; Mon, 21 Feb 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=iyZUOQ7lJzZPoEGQzfGNG1GibqwkxZQjRc5NDHLtmnk=; b=VN0hZ6xy1+I+Iwm7YsBIBra9j8
        RTM+pZWtGBcLcTy9F1v1HwEal/uqv77wZ5feEoovVmK6ZCf8M0tAh2dIqXThZMHx9xuUYgucTKXok
        y+2KVarsq1hh8bSnmMtks8O22tRJjBhz3JLrZ6H2xPK7DWIsB1vlDiO8rLw3a7VuAwnsXYbgHQprL
        D8D6IcxgaVIv8XtslmJGQpoiRP+U2c0PgUMeaSafPo1OKEfrzgAzb3gyk6I/TOJoUU8n4ODUXN6Wi
        4eRIiox5wk6Zqzm6gQ9lgzTKqzpH/RzKaseEoMNr8q9Mi4ta+uyjftaq+zwMdQVzM1WPXpGLeEQU2
        W/CXRhrA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nM8IP-00BdjM-1d
        for fio@vger.kernel.org; Mon, 21 Feb 2022 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 40B8E1BC0182; Mon, 21 Feb 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220221130001.40B8E1BC0182@kernel.dk>
Date:   Mon, 21 Feb 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 933651ec130ce4d27a5c249d649d20afeb2bdf38:

  Merge branch 'rpma-update-RPMA-engines-with-new-librpma-completions-API' of https://github.com/ldorau/fio (2022-02-18 09:02:03 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3f43022d4021850905886e391ec68c02c99aec5a:

  Merge branch 'genfio-tempfile' of https://github.com/scop/fio (2022-02-20 12:39:11 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'which-command-v-type-P' of https://github.com/scop/fio
      Merge branch 'spelling' of https://github.com/scop/fio
      Merge branch 'genfio-tempfile' of https://github.com/scop/fio

Ville Skyttä (3):
      genfio: fix temporary file handling
      ci, t, tools: use `command` and `type` instead of `which`
      Spelling and grammar fixes

 HOWTO.rst                           | 4 ++--
 ci/travis-install-pmdk.sh           | 2 +-
 crc/xxhash.c                        | 4 ++--
 engines/exec.c                      | 4 ++--
 engines/http.c                      | 4 ++--
 engines/ime.c                       | 2 +-
 engines/libhdfs.c                   | 2 +-
 engines/librpma_fio.c               | 2 +-
 engines/librpma_gpspm.c             | 2 +-
 engines/nbd.c                       | 2 +-
 engines/rados.c                     | 2 +-
 engines/rbd.c                       | 4 ++--
 engines/rdma.c                      | 2 +-
 examples/enospc-pressure.fio        | 4 ++--
 examples/falloc.fio                 | 2 +-
 examples/librpma_apm-server.fio     | 2 +-
 examples/librpma_gpspm-server.fio   | 2 +-
 examples/rand-zones.fio             | 2 +-
 filesetup.c                         | 2 +-
 fio.1                               | 4 ++--
 graph.c                             | 2 +-
 lib/pattern.c                       | 6 +++---
 options.c                           | 4 ++--
 os/os-android.h                     | 2 +-
 os/os-netbsd.h                      | 2 +-
 os/windows/posix.c                  | 2 +-
 oslib/libmtd.h                      | 6 +++---
 stat.c                              | 2 +-
 stat.h                              | 2 +-
 t/latency_percentiles.py            | 2 +-
 t/one-core-peak.sh                  | 6 +++---
 t/readonly.py                       | 2 +-
 t/sgunmap-test.py                   | 2 +-
 t/steadystate_tests.py              | 2 +-
 t/time-test.c                       | 2 +-
 tools/fio_generate_plots            | 2 +-
 tools/fio_jsonplus_clat2csv         | 4 ++--
 tools/fiograph/fiograph.py          | 2 +-
 tools/genfio                        | 5 +++--
 tools/hist/fio-histo-log-pctiles.py | 2 +-
 tools/plot/fio2gnuplot              | 4 ++--
 tools/plot/fio2gnuplot.1            | 2 +-
 tools/plot/fio2gnuplot.manpage      | 2 +-
 43 files changed, 61 insertions(+), 60 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index ac1f3478..0978879c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1443,7 +1443,7 @@ I/O type
 	range of possible random values.
 	Defaults are: random for **pareto** and **zipf**, and 0.5 for **normal**.
 	If you wanted to use **zipf** with a `theta` of 1.2 centered on 1/4 of allowed value range,
-	you would use ``random_distibution=zipf:1.2:0.25``.
+	you would use ``random_distribution=zipf:1.2:0.25``.
 
 	For a **zoned** distribution, fio supports specifying percentages of I/O
 	access that should fall within what range of the file or device. For
@@ -3370,7 +3370,7 @@ Verification
 	To avoid false verification errors, do not use the norandommap option when
 	verifying data with async I/O engines and I/O depths > 1.  Or use the
 	norandommap and the lfsr random generator together to avoid writing to the
-	same offset with muliple outstanding I/Os.
+	same offset with multiple outstanding I/Os.
 
 .. option:: verify_offset=int
 
diff --git a/ci/travis-install-pmdk.sh b/ci/travis-install-pmdk.sh
index 803438f8..3b0b5bbc 100755
--- a/ci/travis-install-pmdk.sh
+++ b/ci/travis-install-pmdk.sh
@@ -12,7 +12,7 @@ WORKDIR=$(pwd)
 #    /bin/sh: 1: clang: not found
 # if CC is not set to the full path of clang.
 #
-export CC=$(which $CC)
+export CC=$(type -P $CC)
 
 # Install PMDK libraries, because PMDK's libpmem
 # is a dependency of the librpma fio engine.
diff --git a/crc/xxhash.c b/crc/xxhash.c
index 4736c528..0119564b 100644
--- a/crc/xxhash.c
+++ b/crc/xxhash.c
@@ -50,10 +50,10 @@ You can contact the author at :
 //#define XXH_ACCEPT_NULL_INPUT_POINTER 1
 
 // XXH_FORCE_NATIVE_FORMAT :
-// By default, xxHash library provides endian-independant Hash values, based on little-endian convention.
+// By default, xxHash library provides endian-independent Hash values, based on little-endian convention.
 // Results are therefore identical for little-endian and big-endian CPU.
 // This comes at a performance cost for big-endian CPU, since some swapping is required to emulate little-endian format.
-// Should endian-independance be of no importance for your application, you may set the #define below to 1.
+// Should endian-independence be of no importance for your application, you may set the #define below to 1.
 // It will improve speed for Big-endian CPU.
 // This option has no impact on Little_Endian CPU.
 #define XXH_FORCE_NATIVE_FORMAT 0
diff --git a/engines/exec.c b/engines/exec.c
index ab3639c5..20e50e00 100644
--- a/engines/exec.c
+++ b/engines/exec.c
@@ -67,8 +67,8 @@ char *str_replace(char *orig, const char *rep, const char *with)
 	/*
 	 * Replace a substring by another.
 	 *
-	 * Returns the new string if occurences were found
-	 * Returns orig if no occurence is found
+	 * Returns the new string if occurrences were found
+	 * Returns orig if no occurrence is found
 	 */
 	char *result, *insert, *tmp;
 	int len_rep, len_with, len_front, count;
diff --git a/engines/http.c b/engines/http.c
index 35c44871..57d4967d 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -388,7 +388,7 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 
 	signature = _conv_hex(md, SHA256_DIGEST_LENGTH);
 
-	/* Surpress automatic Accept: header */
+	/* Suppress automatic Accept: header */
 	slist = curl_slist_append(slist, "Accept:");
 
 	snprintf(s, sizeof(s), "x-amz-content-sha256: %s", dsha);
@@ -419,7 +419,7 @@ static void _add_swift_header(CURL *curl, struct curl_slist *slist, struct http_
 	if (op == DDIR_WRITE) {
 		dsha = _gen_hex_md5(buf, len);
 	}
-	/* Surpress automatic Accept: header */
+	/* Suppress automatic Accept: header */
 	slist = curl_slist_append(slist, "Accept:");
 
 	snprintf(s, sizeof(s), "etag: %s", dsha);
diff --git a/engines/ime.c b/engines/ime.c
index 440cc29e..f6690cc1 100644
--- a/engines/ime.c
+++ b/engines/ime.c
@@ -83,7 +83,7 @@ struct ime_data {
 	};
 	struct iovec 	*iovecs;		/* array of queued iovecs */
 	struct io_u 	**io_us;		/* array of queued io_u pointers */
-	struct io_u 	**event_io_us;	/* array of the events retieved afer get_events*/
+	struct io_u 	**event_io_us;	/* array of the events retrieved after get_events*/
 	unsigned int 	queued;			/* iovecs/io_us in the queue */
 	unsigned int 	events;			/* number of committed iovecs/io_us */
 
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index eb55c3c5..f20e45ca 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -27,7 +27,7 @@ struct hdfsio_data {
 };
 
 struct hdfsio_options {
-	void *pad;			/* needed because offset can't be 0 for a option defined used offsetof */
+	void *pad;			/* needed because offset can't be 0 for an option defined used offsetof */
 	char *host;
 	char *directory;
 	unsigned int port;
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index dfd82180..34818904 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -426,7 +426,7 @@ int librpma_fio_client_post_init(struct thread_data *td)
 
 	/*
 	 * td->orig_buffer is not aligned. The engine requires aligned io_us
-	 * so FIO alignes up the address using the formula below.
+	 * so FIO aligns up the address using the formula below.
 	 */
 	ccd->orig_buffer_aligned = PTR_ALIGN(td->orig_buffer, page_mask) +
 			td->o.mem_align;
diff --git a/engines/librpma_gpspm.c b/engines/librpma_gpspm.c
index 14626e7f..5cf97472 100644
--- a/engines/librpma_gpspm.c
+++ b/engines/librpma_gpspm.c
@@ -431,7 +431,7 @@ static int server_post_init(struct thread_data *td)
 
 	/*
 	 * td->orig_buffer is not aligned. The engine requires aligned io_us
-	 * so FIO alignes up the address using the formula below.
+	 * so FIO aligns up the address using the formula below.
 	 */
 	sd->orig_buffer_aligned = PTR_ALIGN(td->orig_buffer, page_mask) +
 			td->o.mem_align;
diff --git a/engines/nbd.c b/engines/nbd.c
index b0ba75e6..7c2d5f4b 100644
--- a/engines/nbd.c
+++ b/engines/nbd.c
@@ -52,7 +52,7 @@ static struct fio_option options[] = {
 	},
 };
 
-/* Alocates nbd_data. */
+/* Allocates nbd_data. */
 static int nbd_setup(struct thread_data *td)
 {
 	struct nbd_data *nbd_data;
diff --git a/engines/rados.c b/engines/rados.c
index 23e62c4c..976f9229 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -151,7 +151,7 @@ static int _fio_rados_connect(struct thread_data *td)
 		char *client_name = NULL;
 
 		/*
-		* If we specify cluser name, the rados_create2
+		* If we specify cluster name, the rados_create2
 		* will not assume 'client.'. name is considered
 		* as a full type.id namestr
 		*/
diff --git a/engines/rbd.c b/engines/rbd.c
index c6203d4c..2f25889a 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -173,7 +173,7 @@ static int _fio_rbd_connect(struct thread_data *td)
 		char *client_name = NULL; 
 
 		/*
-		 * If we specify cluser name, the rados_create2
+		 * If we specify cluster name, the rados_create2
 		 * will not assume 'client.'. name is considered
 		 * as a full type.id namestr
 		 */
@@ -633,7 +633,7 @@ static int fio_rbd_setup(struct thread_data *td)
 
 	/* taken from "net" engine. Pretend we deal with files,
 	 * even if we do not have any ideas about files.
-	 * The size of the RBD is set instead of a artificial file.
+	 * The size of the RBD is set instead of an artificial file.
 	 */
 	if (!td->files_index) {
 		add_file(td, td->o.filename ? : "rbd", 0, 0);
diff --git a/engines/rdma.c b/engines/rdma.c
index f4471869..4eb86652 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -1194,7 +1194,7 @@ static int check_set_rlimits(struct thread_data *td)
 
 static int compat_options(struct thread_data *td)
 {
-	// The original RDMA engine had an ugly / seperator
+	// The original RDMA engine had an ugly / separator
 	// on the filename for it's options. This function
 	// retains backwards compatibility with it. Note we do not
 	// support setting the bindname option is this legacy mode.
diff --git a/examples/enospc-pressure.fio b/examples/enospc-pressure.fio
index ca9d8f7a..fa404fd5 100644
--- a/examples/enospc-pressure.fio
+++ b/examples/enospc-pressure.fio
@@ -35,8 +35,8 @@ bs=4k
 rw=randtrim
 filename=raicer
 
-# Verifier thread continiously write to newly allcated blocks
-# and veryfy written content
+# Verifier thread continuously writes to newly allcated blocks
+# and verifies written content
 [aio-dio-verifier]
 create_on_open=1
 verify=crc32c-intel
diff --git a/examples/falloc.fio b/examples/falloc.fio
index fadf1321..5a3e88b8 100644
--- a/examples/falloc.fio
+++ b/examples/falloc.fio
@@ -29,7 +29,7 @@ rw=randtrim
 numjobs=2
 filename=fragmented_file
 
-## Mesure IO performance on fragmented file
+## Measure IO performance on fragmented file
 [sequential aio-dio write]
 stonewall
 ioengine=libaio
diff --git a/examples/librpma_apm-server.fio b/examples/librpma_apm-server.fio
index 062b5215..dc1ddba2 100644
--- a/examples/librpma_apm-server.fio
+++ b/examples/librpma_apm-server.fio
@@ -20,7 +20,7 @@ thread
 # (https://pmem.io/rpma/documentation/basic-direct-write-to-pmem.html)
 direct_write_to_pmem=0
 
-numjobs=1 # number of expected incomming connections
+numjobs=1 # number of expected incoming connections
 size=100MiB # size of workspace for a single connection
 filename=malloc # device dax or an existing fsdax file or "malloc" for allocation from DRAM
 # filename=/dev/dax1.0
diff --git a/examples/librpma_gpspm-server.fio b/examples/librpma_gpspm-server.fio
index 67e92a28..4555314f 100644
--- a/examples/librpma_gpspm-server.fio
+++ b/examples/librpma_gpspm-server.fio
@@ -22,7 +22,7 @@ thread
 direct_write_to_pmem=0
 # set to 0 (false) to wait for completion instead of busy-wait polling completion.
 busy_wait_polling=1
-numjobs=1 # number of expected incomming connections
+numjobs=1 # number of expected incoming connections
 iodepth=2 # number of parallel GPSPM requests
 size=100MiB # size of workspace for a single connection
 filename=malloc # device dax or an existing fsdax file or "malloc" for allocation from DRAM
diff --git a/examples/rand-zones.fio b/examples/rand-zones.fio
index 169137d4..10e71727 100644
--- a/examples/rand-zones.fio
+++ b/examples/rand-zones.fio
@@ -21,6 +21,6 @@ random_distribution=zoned:50/5:30/15:20/
 # The above applies to all of reads/writes/trims. If we wanted to do
 # something differently for writes, let's say 50% for the first 10%
 # and 50% for the remaining 90%, we could do it by adding a new section
-# after a a comma.
+# after a comma.
 
 # random_distribution=zoned:50/5:30/15:20/,50/10:50/90
diff --git a/filesetup.c b/filesetup.c
index fb556d84..7c32d0af 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1486,7 +1486,7 @@ static bool init_rand_distribution(struct thread_data *td)
 
 /*
  * Check if the number of blocks exceeds the randomness capability of
- * the selected generator. Tausworthe is 32-bit, the others are fullly
+ * the selected generator. Tausworthe is 32-bit, the others are fully
  * 64-bit capable.
  */
 static int check_rand_gen_limits(struct thread_data *td, struct fio_file *f,
diff --git a/fio.1 b/fio.1
index e23d4092..98410655 100644
--- a/fio.1
+++ b/fio.1
@@ -1221,7 +1221,7 @@ more control over most probable outcome. This value is in range [0-1] which maps
 range of possible random values.
 Defaults are: random for \fBpareto\fR and \fBzipf\fR, and 0.5 for \fBnormal\fR.
 If you wanted to use \fBzipf\fR with a `theta` of 1.2 centered on 1/4 of allowed value range,
-you would use `random_distibution=zipf:1.2:0.25`.
+you would use `random_distribution=zipf:1.2:0.25`.
 .P
 For a \fBzoned\fR distribution, fio supports specifying percentages of I/O
 access that should fall within what range of the file or device. For
@@ -3082,7 +3082,7 @@ the verify will be of the newly written data.
 To avoid false verification errors, do not use the norandommap option when
 verifying data with async I/O engines and I/O depths > 1.  Or use the
 norandommap and the lfsr random generator together to avoid writing to the
-same offset with muliple outstanding I/Os.
+same offset with multiple outstanding I/Os.
 .RE
 .TP
 .BI verify_offset \fR=\fPint
diff --git a/graph.c b/graph.c
index 7a174170..c49cdae1 100644
--- a/graph.c
+++ b/graph.c
@@ -999,7 +999,7 @@ const char *graph_find_tooltip(struct graph *g, int ix, int iy)
 				ydiff = fabs(yval - y);
 
 				/*
-				 * zero delta, or within or match critera, break
+				 * zero delta, or within or match criteria, break
 				 */
 				if (ydiff < best_delta) {
 					best_delta = ydiff;
diff --git a/lib/pattern.c b/lib/pattern.c
index 680a12be..d8203630 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -211,7 +211,7 @@ static const char *parse_number(const char *beg, char *out,
  * This function tries to find formats, e.g.:
  *   %o - offset of the block
  *
- * In case of successfull parsing it fills the format param
+ * In case of successful parsing it fills the format param
  * with proper offset and the size of the expected value, which
  * should be pasted into buffer using the format 'func' callback.
  *
@@ -267,7 +267,7 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
  * @fmt_desc - array of pattern format descriptors [input]
  * @fmt - array of pattern formats [output]
  * @fmt_sz - pointer where the size of pattern formats array stored [input],
- *           after successfull parsing this pointer will contain the number
+ *           after successful parsing this pointer will contain the number
  *           of parsed formats if any [output].
  *
  * strings:
@@ -275,7 +275,7 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
  *   NOTE: there is no way to escape quote, so "123\"abc" does not work.
  *
  * numbers:
- *   hexidecimal - sequence of hex bytes starting from 0x or 0X prefix,
+ *   hexadecimal - sequence of hex bytes starting from 0x or 0X prefix,
  *                 e.g. 0xff12ceff1100ff
  *   decimal     - decimal number in range [INT_MIN, INT_MAX]
  *
diff --git a/options.c b/options.c
index 6cdbd268..e06d9b66 100644
--- a/options.c
+++ b/options.c
@@ -1366,7 +1366,7 @@ int get_max_str_idx(char *input)
 }
 
 /*
- * Returns the directory at the index, indexes > entires will be
+ * Returns the directory at the index, indexes > entries will be
  * assigned via modulo division of the index
  */
 int set_name_idx(char *target, size_t tlen, char *input, int index,
@@ -1560,7 +1560,7 @@ static int str_gtod_reduce_cb(void *data, int *il)
 	int val = *il;
 
 	/*
-	 * Only modfiy options if gtod_reduce==1
+	 * Only modify options if gtod_reduce==1
 	 * Otherwise leave settings alone.
 	 */
 	if (val) {
diff --git a/os/os-android.h b/os/os-android.h
index 10c51b83..2f73d249 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -66,7 +66,7 @@
 
 #ifndef CONFIG_NO_SHM
 /*
- * Bionic doesn't support SysV shared memeory, so implement it using ashmem
+ * Bionic doesn't support SysV shared memory, so implement it using ashmem
  */
 #include <stdio.h>
 #include <linux/ashmem.h>
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 624c7fa5..b553a430 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -13,7 +13,7 @@
 #include <sys/endian.h>
 #include <sys/sysctl.h>
 
-/* XXX hack to avoid confilcts between rbtree.h and <sys/rbtree.h> */
+/* XXX hack to avoid conflicts between rbtree.h and <sys/rbtree.h> */
 #undef rb_node
 #undef rb_left
 #undef rb_right
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 0d415e1e..a3a6c89f 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -1165,7 +1165,7 @@ HANDLE windows_handle_connection(HANDLE hjob, int sk)
 		ret = pi.hProcess;
 
 	/* duplicate socket and write the protocol_info to pipe so child can
-	 * duplicate the communciation socket */
+	 * duplicate the communication socket */
 	if (WSADuplicateSocket(sk, GetProcessId(pi.hProcess), &protocol_info)) {
 		log_err("WSADuplicateSocket failed (%lu).\n", GetLastError());
 		ret = INVALID_HANDLE_VALUE;
diff --git a/oslib/libmtd.h b/oslib/libmtd.h
index a0c90dcb..668e7798 100644
--- a/oslib/libmtd.h
+++ b/oslib/libmtd.h
@@ -256,7 +256,7 @@ int mtd_mark_bad(const struct mtd_dev_info *mtd, int fd, int eb);
  * @mtd: MTD device description object
  * @fd: MTD device node file descriptor
  * @eb: eraseblock to read from
- * @offs: offset withing the eraseblock to read from
+ * @offs: offset within the eraseblock to read from
  * @buf: buffer to read data to
  * @len: how many bytes to read
  *
@@ -273,7 +273,7 @@ int mtd_read(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
  * @mtd: MTD device description object
  * @fd: MTD device node file descriptor
  * @eb: eraseblock to write to
- * @offs: offset withing the eraseblock to write to
+ * @offs: offset within the eraseblock to write to
  * @data: data buffer to write
  * @len: how many data bytes to write
  * @oob: OOB buffer to write
@@ -329,7 +329,7 @@ int mtd_write_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
  * @mtd: MTD device description object
  * @fd: MTD device node file descriptor
  * @eb: eraseblock to write to
- * @offs: offset withing the eraseblock to write to
+ * @offs: offset within the eraseblock to write to
  * @img_name: the file to write
  *
  * This function writes an image @img_name the MTD device defined by @mtd. @eb
diff --git a/stat.c b/stat.c
index 1764eebc..7947edb4 100644
--- a/stat.c
+++ b/stat.c
@@ -377,7 +377,7 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		free(maxalt);
 	}
 
-	/* Need to aggregate statisitics to show mixed values */
+	/* Need to aggregate statistics to show mixed values */
 	if (rs->unified_rw_rep == UNIFIED_BOTH)
 		show_mixed_group_stats(rs, out);
 }
diff --git a/stat.h b/stat.h
index dce0bb0d..eb7845af 100644
--- a/stat.h
+++ b/stat.h
@@ -68,7 +68,7 @@ struct group_run_stats {
  * than one. This method has low accuracy when the value is small. For
  * example, let the buckets be {[0,99],[100,199],...,[900,999]}, and
  * the represented value of each bucket be the mean of the range. Then
- * a value 0 has an round-off error of 49.5. To improve on this, we
+ * a value 0 has a round-off error of 49.5. To improve on this, we
  * use buckets with non-uniform ranges, while bounding the error of
  * each bucket within a ratio of the sample value. A simple example
  * would be when error_bound = 0.005, buckets are {
diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index 9e37d9fe..81704700 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -270,7 +270,7 @@ class FioLatTest():
             #
             # Check only for the presence/absence of json+
             # latency bins. Future work can check the
-            # accurracy of the bin values and counts.
+            # accuracy of the bin values and counts.
             #
             # Because the latency percentiles are based on
             # the bins, we can be confident that the bin
diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index 9da8304e..3ac119f6 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -33,8 +33,8 @@ check_binary() {
   # Ensure the binaries are present and executable
   for bin in "$@"; do
     if [ ! -x ${bin} ]; then
-      which ${bin} >/dev/null
-      [ $? -eq 0 ] || fatal "${bin} doesn't exists or is not executable"
+      command -v ${bin} >/dev/null
+      [ $? -eq 0 ] || fatal "${bin} doesn't exist or is not executable"
     fi
   done
 }
@@ -197,7 +197,7 @@ show_nvme() {
   fw=$(cat ${device_dir}/firmware_rev | xargs) #xargs for trimming spaces
   serial=$(cat ${device_dir}/serial | xargs) #xargs for trimming spaces
   info ${device_name} "MODEL=${model} FW=${fw} serial=${serial} PCI=${pci_addr}@${link_speed} IRQ=${irq} NUMA=${numa} CPUS=${cpus} "
-  which nvme &> /dev/null
+  command -v nvme > /dev/null
   if [ $? -eq 0 ]; then
     status=""
     NCQA=$(nvme get-feature -H -f 0x7 ${device} 2>&1 |grep NCQA |cut -d ':' -f 2 | xargs)
diff --git a/t/readonly.py b/t/readonly.py
index 464847c6..80fac639 100755
--- a/t/readonly.py
+++ b/t/readonly.py
@@ -6,7 +6,7 @@
 #
 # readonly.py
 #
-# Do some basic tests of the --readonly paramter
+# Do some basic tests of the --readonly parameter
 #
 # USAGE
 # python readonly.py [-f fio-executable]
diff --git a/t/sgunmap-test.py b/t/sgunmap-test.py
index 4960a040..6687494f 100755
--- a/t/sgunmap-test.py
+++ b/t/sgunmap-test.py
@@ -3,7 +3,7 @@
 #
 # sgunmap-test.py
 #
-# Limited functonality test for trim workloads using fio's sg ioengine
+# Limited functionality test for trim workloads using fio's sg ioengine
 # This checks only the three sets of reported iodepths
 #
 # !!!WARNING!!!
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index e8bd768c..d6ffd177 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -2,7 +2,7 @@
 #
 # steadystate_tests.py
 #
-# Test option parsing and functonality for fio's steady state detection feature.
+# Test option parsing and functionality for fio's steady state detection feature.
 #
 # steadystate_tests.py --read file-for-read-testing --write file-for-write-testing ./fio
 #
diff --git a/t/time-test.c b/t/time-test.c
index a74d9206..3c87d4d4 100644
--- a/t/time-test.c
+++ b/t/time-test.c
@@ -67,7 +67,7 @@
  *	accuracy because the (ticks * clock_mult) product used for final
  *	fractional chunk
  *
- *  iv) 64-bit arithmetic with the clock ticks to nsec conversion occuring in
+ *  iv) 64-bit arithmetic with the clock ticks to nsec conversion occurring in
  *	two stages. This is carried out using locks to update the number of
  *	large time chunks (MAX_CLOCK_SEC_2STAGE) that have elapsed.
  *
diff --git a/tools/fio_generate_plots b/tools/fio_generate_plots
index e4558788..468cf27a 100755
--- a/tools/fio_generate_plots
+++ b/tools/fio_generate_plots
@@ -21,7 +21,7 @@ if [ -z "$1" ]; then
 	exit 1
 fi
 
-GNUPLOT=$(which gnuplot)
+GNUPLOT=$(command -v gnuplot)
 if [ ! -x "$GNUPLOT" ]
 then
 	echo You need gnuplot installed to generate graphs
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index 7f310fcc..8fdd014d 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -135,7 +135,7 @@ def more_bins(indices, bins):
 
     Returns:
         True if the indices do not yet point to the end of each bin in bins.
-        False if the indices point beyond their repsective bins.
+        False if the indices point beyond their respective bins.
     """
 
     for key, value in six.iteritems(indices):
@@ -160,7 +160,7 @@ def debug_print(debug, *args):
 def get_csvfile(dest, jobnum):
     """Generate CSV filename from command-line arguments and job numbers.
 
-    Paramaters:
+    Parameters:
         dest        file specification for CSV filename.
         jobnum      job number.
 
diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
index b5669a2d..384decda 100755
--- a/tools/fiograph/fiograph.py
+++ b/tools/fiograph/fiograph.py
@@ -218,7 +218,7 @@ def fio_to_graphviz(filename, format):
     # The first job will be a new execution group
     new_execution_group = True
 
-    # Let's interate on all sections to create links between them
+    # Let's iterate on all sections to create links between them
     for section_name in fio_file.sections():
         # The current section
         section = fio_file[section_name]
diff --git a/tools/genfio b/tools/genfio
index 8518bbcc..c9bc2f76 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -22,7 +22,8 @@
 BLK_SIZE=
 BLOCK_SIZE=4k
 SEQ=-1
-TEMPLATE=/tmp/template.fio
+TEMPLATE=$(mktemp "${TMPDIR:-${TEMP:-/tmp}}/template.fio.XXXXXX") || exit $?
+trap 'rm -f "$TEMPLATE"' EXIT
 OUTFILE=
 DISKS=
 PRINTABLE_DISKS=
@@ -48,7 +49,7 @@ show_help() {
 					one test after another then one disk after another
 					Disabled by default
 -p				: Run parallel test
-					one test after anoter but all disks at the same time
+					one test after another but all disks at the same time
 					Enabled by default
 -D iodepth			: Run with the specified iodepth
 					Default is $IODEPTH
diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index 08e7722d..b5d167de 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -748,7 +748,7 @@ if unittest2_imported:
     def test_e2_get_pctiles_highest_pct(self):
         fio_v3_bucket_count = 29 * 64
         with open(self.fn, 'w') as f:
-            # make a empty fio v3 histogram
+            # make an empty fio v3 histogram
             buckets = [ 0 for j in range(0, fio_v3_bucket_count) ]
             # add one I/O request to last bucket
             buckets[-1] = 1
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index d2dc81df..ce3ca2cc 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -492,8 +492,8 @@ def main(argv):
     #We need to adjust the output filename regarding the pattern required by the user
     if (pattern_set_by_user == True):
         gnuplot_output_filename=pattern
-        # As we do have some glob in the pattern, let's make this simpliest
-        # We do remove the simpliest parts of the expression to get a clear file name
+        # As we do have some glob in the pattern, let's make this simplest
+        # We do remove the simplest parts of the expression to get a clear file name
         gnuplot_output_filename=gnuplot_output_filename.replace('-*-','-')
         gnuplot_output_filename=gnuplot_output_filename.replace('*','-')
         gnuplot_output_filename=gnuplot_output_filename.replace('--','-')
diff --git a/tools/plot/fio2gnuplot.1 b/tools/plot/fio2gnuplot.1
index 6fb1283f..bfa10d26 100644
--- a/tools/plot/fio2gnuplot.1
+++ b/tools/plot/fio2gnuplot.1
@@ -35,7 +35,7 @@ The resulting graph helps at understanding trends.
 .TP
 .B
 Grouped 2D graph
-All files are plotted in a single image to ease the comparaison. The same rendering options as per the individual 2D graph are used :
+All files are plotted in a single image to ease the comparison. The same rendering options as per the individual 2D graph are used :
 .RS
 .IP \(bu 3
 raw
diff --git a/tools/plot/fio2gnuplot.manpage b/tools/plot/fio2gnuplot.manpage
index 6a12cf81..be3f13c2 100644
--- a/tools/plot/fio2gnuplot.manpage
+++ b/tools/plot/fio2gnuplot.manpage
@@ -20,7 +20,7 @@ DESCRIPTION
                     	The resulting graph helps at understanding trends.
 
  Grouped 2D graph   
-	All files are plotted in a single image to ease the comparaison. The same rendering options as per the individual 2D graph are used :
+	All files are plotted in a single image to ease the comparison. The same rendering options as per the individual 2D graph are used :
          - raw
          - smooth
          - trend
