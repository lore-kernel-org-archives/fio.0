Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbIFMAK (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 6 Sep 2015 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZYYcD-0005kr-2m
	for fio@vger.kernel.org; Sun, 06 Sep 2015 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150906120001.838DA2C005B@kernel.dk>
Date: Sun,  6 Sep 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 61b9861d45dcd6be23c527861b32aa36bcd1b682:

  use 'lib/pattern' to parse patterns and paste formats into buffers (2015-09-04 13:33:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b638d82f882bd8c15cc933ee0b8fa684308e7855:

  verify: move meta header to generic verify_header (2015-09-05 16:24:03 -0600)

----------------------------------------------------------------
Roman Pen (2):
      fio.1: update description for 'buffer_pattern' and 'verify_pattern'
      verify: move meta header to generic verify_header

 HOWTO     |  19 +++++----
 fio.1     |  48 ++++++++++++++++++---
 options.c |  10 +++--
 verify.c  | 140 +++++++++++++++++++++++++++-----------------------------------
 verify.h  |  16 +++----
 5 files changed, 129 insertions(+), 104 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cee505f..d3ead19 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1248,7 +1248,12 @@ do_verify=bool	Run the verify phase after a write phase. Only makes sense if
 		verify is set. Defaults to 1.
 
 verify=str	If writing to a file, fio can verify the file contents
-		after each iteration of the job. The allowed values are:
+		after each iteration of the job. Each verification method also implies
+		verification of special header, which is written to the beginning of
+		each block. This header also includes meta information, like offset
+		of the block, block number, timestamp when block was written, etc.
+		verify=str can be combined with verify_pattern=str option.
+		The allowed values are:
 
 			md5	Use an md5 sum of the data area and store
 				it in the header of each block.
@@ -1284,11 +1289,11 @@ verify=str	If writing to a file, fio can verify the file contents
 
 			sha1	Use optimized sha1 as the checksum function.
 
-			meta	Write extra information about each io
-				(timestamp, block number etc.). The block
-				number is verified. The io sequence number is
-				verified for workloads that write data.
-				See also verify_pattern.
+			meta	This option is deprecated, since now meta information is
+				included in generic verification header and meta verification
+				happens by default. For detailed information see the description
+				of the verify=str setting. This option is kept because of
+				compatibility's sake with old configurations. Do not use it.
 
 			pattern	Verify a strict pattern. Normally fio includes
 				a header with some basic information and
@@ -1333,7 +1338,7 @@ verify_pattern=str	If set, fio will fill the io buffers with this
 		buffer at the time(it can be either a decimal or a hex number).
 		The verify_pattern if larger than a 32-bit quantity has to
 		be a hex number that starts with either "0x" or "0X". Use
-		with verify=meta. Also, verify_pattern supports %o format,
+		with verify=str. Also, verify_pattern supports %o format,
 		which means that for each block offset will be written and
 		then verifyied back, e.g.:
 
diff --git a/fio.1 b/fio.1
index 5f8e948..c1cb2a5 100644
--- a/fio.1
+++ b/fio.1
@@ -507,7 +507,26 @@ If set, fio will fill the IO buffers with this pattern. If not set, the contents
 of IO buffers is defined by the other options related to buffer contents. The
 setting can be any pattern of bytes, and can be prefixed with 0x for hex
 values. It may also be a string, where the string must then be wrapped with
-"".
+"", e.g.:
+.RS
+.RS
+\fBbuffer_pattern\fR="abcd"
+.RS
+or
+.RE
+\fBbuffer_pattern\fR=-12
+.RS
+or
+.RE
+\fBbuffer_pattern\fR=0xdeadface
+.RE
+.LP
+Also you can combine everything together in any order:
+.LP
+.RS
+\fBbuffer_pattern\fR=0xdeadface"abcd"-12
+.RE
+.RE
 .TP
 .BI dedupe_percentage \fR=\fPint
 If set, fio will generate this percentage of identical buffers when writing.
@@ -1115,8 +1134,12 @@ Run the verify phase after a write phase.  Only valid if \fBverify\fR is set.
 Default: true.
 .TP
 .BI verify \fR=\fPstr
-Method of verifying file contents after each iteration of the job.  Allowed
-values are:
+Method of verifying file contents after each iteration of the job. Each
+verification method also implies verification of special header, which is
+written to the beginning of each block. This header also includes meta
+information, like offset of the block, block number, timestamp when block
+was written, etc.  \fBverify\fR=str can be combined with \fBverify_pattern\fR=str
+option.  The allowed values are:
 .RS
 .RS
 .TP
@@ -1126,8 +1149,10 @@ hardware accelerated SSE4.2 driven, falls back to regular crc32c if
 not supported by the system.
 .TP
 .B meta
-Write extra information about each I/O (timestamp, block number, etc.). The
-block number is verified. See \fBverify_pattern\fR as well.
+This option is deprecated, since now meta information is included in generic
+verification header and meta verification happens by default.  For detailed
+information see the description of the \fBverify\fR=str setting. This option
+is kept because of compatibility's sake with old configurations. Do not use it.
 .TP
 .B pattern
 Verify a strict pattern. Normally fio includes a header with some basic
@@ -1167,7 +1192,18 @@ pattern for io verification purposes. Depending on the width of the pattern,
 fio will fill 1/2/3/4 bytes of the buffer at the time(it can be either a
 decimal or a hex number). The verify_pattern if larger than a 32-bit quantity
 has to be a hex number that starts with either "0x" or "0X". Use with
-\fBverify\fP=meta or \fBverify\fP=pattern.
+\fBverify\fP=str. Also, verify_pattern supports %o format, which means that for
+each block offset will be written and then verifyied back, e.g.:
+.RS
+.RS
+\fBverify_pattern\fR=%o
+.RE
+Or use combination of everything:
+.LP
+.RS
+\fBverify_pattern\fR=0xff%o"abcd"-21
+.RE
+.RE
 .TP
 .BI verify_fatal \fR=\fPbool
 If true, exit the job on the first observed verification failure.  Default:
diff --git a/options.c b/options.c
index fab4675..4798fbf 100644
--- a/options.c
+++ b/options.c
@@ -958,7 +958,7 @@ static int str_verify_pattern_cb(void *data, const char *input)
 	assert(ret != 0);
 	td->o.verify_pattern_bytes = ret;
 	/*
-	 * VERIFY_META could already be set
+	 * VERIFY_* could already be set
 	 */
 	if (!fio_option_is_set(&td->o, verify))
 		td->o.verify = VERIFY_PATTERN;
@@ -2294,9 +2294,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = VERIFY_XXHASH,
 			    .help = "Use xxhash checksums for verification",
 			  },
+			  /* Meta information was included into verify_header,
+			   * 'meta' verification is implied by default. */
 			  { .ival = "meta",
-			    .oval = VERIFY_META,
-			    .help = "Use io information",
+			    .oval = VERIFY_HDR_ONLY,
+			    .help = "Use io information for verification. "
+				    "Now is implied by default, thus option is obsolete, "
+				    "don't use it",
 			  },
 			  { .ival = "pattern",
 			    .oval = VERIFY_PATTERN_NO_HDR,
diff --git a/verify.c b/verify.c
index 227d220..ee9160c 100644
--- a/verify.c
+++ b/verify.c
@@ -29,10 +29,12 @@
 static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 struct verify_header *hdr, unsigned int header_num,
 			 unsigned int header_len);
-static void fill_hdr(struct verify_header *hdr, int verify_type, uint32_t len,
-		     uint64_t rand_seed);
-static void __fill_hdr(struct verify_header *hdr, int verify_type, uint32_t len,
-		       uint64_t rand_seed);
+static void fill_hdr(struct thread_data *td, struct io_u *io_u,
+		     struct verify_header *hdr, unsigned int header_num,
+		     unsigned int header_len, uint64_t rand_seed);
+static void __fill_hdr(struct thread_data *td, struct io_u *io_u,
+		       struct verify_header *hdr, unsigned int header_num,
+		       unsigned int header_len, uint64_t rand_seed);
 
 void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len)
 {
@@ -141,6 +143,7 @@ static inline unsigned int __hdr_size(int verify_type)
 
 	switch (verify_type) {
 	case VERIFY_NONE:
+	case VERIFY_HDR_ONLY:
 	case VERIFY_NULL:
 	case VERIFY_PATTERN:
 		len = 0;
@@ -171,9 +174,6 @@ static inline unsigned int __hdr_size(int verify_type)
 	case VERIFY_XXHASH:
 		len = sizeof(struct vhdr_xxhash);
 		break;
-	case VERIFY_META:
-		len = sizeof(struct vhdr_meta);
-		break;
 	case VERIFY_SHA1:
 		len = sizeof(struct vhdr_sha1);
 		break;
@@ -323,7 +323,7 @@ static void dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
 	struct verify_header shdr;
 
 	if (td->o.verify == VERIFY_PATTERN_NO_HDR) {
-		__fill_hdr(&shdr, td->o.verify, vc->io_u->buflen, 0);
+		__fill_hdr(td, vc->io_u, &shdr, 0, vc->io_u->buflen, 0);
 		hdr = &shdr;
 	}
 
@@ -405,43 +405,6 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	return EILSEQ;
 }
 
-static int verify_io_u_meta(struct verify_header *hdr, struct vcont *vc)
-{
-	struct thread_data *td = vc->td;
-	struct vhdr_meta *vh = hdr_priv(hdr);
-	struct io_u *io_u = vc->io_u;
-	int ret = EILSEQ;
-
-	dprint(FD_VERIFY, "meta verify io_u %p, len %u\n", io_u, hdr->len);
-
-	if (vh->offset == io_u->offset + vc->hdr_num * td->o.verify_interval)
-		ret = 0;
-
-	if (td->o.verify_pattern_bytes)
-		ret |= verify_io_u_pattern(hdr, vc);
-
-	/*
-	 * For read-only workloads, the program cannot be certain of the
-	 * last numberio written to a block. Checking of numberio will be
-	 * done only for workloads that write data.  For verify_only,
-	 * numberio will be checked in the last iteration when the correct
-	 * state of numberio, that would have been written to each block
-	 * in a previous run of fio, has been reached.
-	 */
-	if ((td_write(td) || td_rw(td)) && (td_min_bs(td) == td_max_bs(td)) &&
-	    !td->o.time_based)
-		if (!td->o.verify_only || td->o.loops == 0)
-			if (vh->numberio != io_u->numberio)
-				ret = EILSEQ;
-
-	if (!ret)
-		return 0;
-
-	vc->name = "meta";
-	log_verify_failure(hdr, vc);
-	return ret;
-}
-
 static int verify_io_u_xxhash(struct verify_header *hdr, struct vcont *vc)
 {
 	void *p = io_u_verify_off(hdr, vc);
@@ -732,8 +695,9 @@ static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
 	return ret;
 }
 
-static int verify_header(struct io_u *io_u, struct verify_header *hdr,
-			 unsigned int hdr_num, unsigned int hdr_len)
+static int verify_header(struct io_u *io_u, struct thread_data *td,
+			 struct verify_header *hdr, unsigned int hdr_num,
+			 unsigned int hdr_len)
 {
 	void *p = hdr;
 	uint32_t crc;
@@ -754,6 +718,30 @@ static int verify_header(struct io_u *io_u, struct verify_header *hdr,
 			hdr->rand_seed, io_u->rand_seed);
 		goto err;
 	}
+	if (hdr->offset != io_u->offset + hdr_num * td->o.verify_interval) {
+		log_err("verify: bad header offset %"PRIu64
+			", wanted %llu",
+			hdr->offset, io_u->offset);
+		goto err;
+	}
+
+	/*
+	 * For read-only workloads, the program cannot be certain of the
+	 * last numberio written to a block. Checking of numberio will be
+	 * done only for workloads that write data.  For verify_only,
+	 * numberio will be checked in the last iteration when the correct
+	 * state of numberio, that would have been written to each block
+	 * in a previous run of fio, has been reached.
+	 */
+	if ((td_write(td) || td_rw(td)) && (td_min_bs(td) == td_max_bs(td)) &&
+	    !td->o.time_based)
+		if (!td->o.verify_only || td->o.loops == 0)
+			if (hdr->numberio != io_u->numberio) {
+				log_err("verify: bad header numberio %"PRIu16
+					", wanted %"PRIu16,
+					hdr->numberio, io_u->numberio);
+				goto err;
+			}
 
 	crc = fio_crc32c(p, offsetof(struct verify_header, crc32));
 	if (crc != hdr->crc32) {
@@ -820,7 +808,7 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			io_u->rand_seed = hdr->rand_seed;
 
 		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
-			ret = verify_header(io_u, hdr, hdr_num, hdr_inc);
+			ret = verify_header(io_u, td, hdr, hdr_num, hdr_inc);
 			if (ret)
 				return ret;
 		}
@@ -831,6 +819,12 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			verify_type = hdr->verify_type;
 
 		switch (verify_type) {
+		case VERIFY_HDR_ONLY:
+			/* Header is always verified, check if pattern is left
+			 * for verification. */
+			if (td->o.verify_pattern_bytes)
+				ret = verify_io_u_pattern(hdr, &vc);
+			break;
 		case VERIFY_MD5:
 			ret = verify_io_u_md5(hdr, &vc);
 			break;
@@ -859,9 +853,6 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		case VERIFY_XXHASH:
 			ret = verify_io_u_xxhash(hdr, &vc);
 			break;
-		case VERIFY_META:
-			ret = verify_io_u_meta(hdr, &vc);
-			break;
 		case VERIFY_SHA1:
 			ret = verify_io_u_sha1(hdr, &vc);
 			break;
@@ -886,21 +877,6 @@ done:
 	return ret;
 }
 
-static void fill_meta(struct verify_header *hdr, struct thread_data *td,
-		      struct io_u *io_u, unsigned int header_num)
-{
-	struct vhdr_meta *vh = hdr_priv(hdr);
-
-	vh->thread = td->thread_number;
-
-	vh->time_sec = io_u->start_time.tv_sec;
-	vh->time_usec = io_u->start_time.tv_usec;
-
-	vh->numberio = io_u->numberio;
-
-	vh->offset = io_u->offset + header_num * td->o.verify_interval;
-}
-
 static void fill_xxhash(struct verify_header *hdr, void *p, unsigned int len)
 {
 	struct vhdr_xxhash *vh = hdr_priv(hdr);
@@ -993,24 +969,32 @@ static void fill_md5(struct verify_header *hdr, void *p, unsigned int len)
 	fio_md5_final(&md5_ctx);
 }
 
-static void __fill_hdr(struct verify_header *hdr, int verify_type,
-		       uint32_t len, uint64_t rand_seed)
+static void __fill_hdr(struct thread_data *td, struct io_u *io_u,
+		       struct verify_header *hdr, unsigned int header_num,
+		       unsigned int header_len, uint64_t rand_seed)
 {
 	void *p = hdr;
 
 	hdr->magic = FIO_HDR_MAGIC;
-	hdr->verify_type = verify_type;
-	hdr->len = len;
+	hdr->verify_type = td->o.verify;
+	hdr->len = header_len;
 	hdr->rand_seed = rand_seed;
+	hdr->offset = io_u->offset + header_num * td->o.verify_interval;
+	hdr->time_sec = io_u->start_time.tv_sec;
+	hdr->time_usec = io_u->start_time.tv_usec;
+	hdr->thread = td->thread_number;
+	hdr->numberio = io_u->numberio;
 	hdr->crc32 = fio_crc32c(p, offsetof(struct verify_header, crc32));
 }
 
 
-static void fill_hdr(struct verify_header *hdr, int verify_type, uint32_t len,
-		     uint64_t rand_seed)
+static void fill_hdr(struct thread_data *td, struct io_u *io_u,
+		     struct verify_header *hdr, unsigned int header_num,
+		     unsigned int header_len, uint64_t rand_seed)
 {
-	if (verify_type != VERIFY_PATTERN_NO_HDR)
-		__fill_hdr(hdr, verify_type, len, rand_seed);
+
+	if (td->o.verify != VERIFY_PATTERN_NO_HDR)
+		__fill_hdr(td, io_u, hdr, header_num, header_len, rand_seed);
 }
 
 static void populate_hdr(struct thread_data *td, struct io_u *io_u,
@@ -1022,7 +1006,7 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 
 	p = (void *) hdr;
 
-	fill_hdr(hdr, td->o.verify, header_len, io_u->rand_seed);
+	fill_hdr(td, io_u, hdr, header_num, header_len, io_u->rand_seed);
 
 	data_len = header_len - hdr_size(td, hdr);
 
@@ -1074,16 +1058,12 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 						io_u, hdr->len);
 		fill_xxhash(hdr, data, data_len);
 		break;
-	case VERIFY_META:
-		dprint(FD_VERIFY, "fill meta io_u %p, len %u\n",
-						io_u, hdr->len);
-		fill_meta(hdr, td, io_u, header_num);
-		break;
 	case VERIFY_SHA1:
 		dprint(FD_VERIFY, "fill sha1 io_u %p, len %u\n",
 						io_u, hdr->len);
 		fill_sha1(hdr, data, data_len);
 		break;
+	case VERIFY_HDR_ONLY:
 	case VERIFY_PATTERN:
 	case VERIFY_PATTERN_NO_HDR:
 		/* nothing to do here */
diff --git a/verify.h b/verify.h
index 74cad85..87675af 100644
--- a/verify.h
+++ b/verify.h
@@ -7,6 +7,9 @@
 
 enum {
 	VERIFY_NONE = 0,		/* no verification */
+	VERIFY_HDR_ONLY,		/* verify header only, kept for sake of
+					 * compatibility with old configurations
+					 * which use 'verify=meta' */
 	VERIFY_MD5,			/* md5 sum data blocks */
 	VERIFY_CRC64,			/* crc64 sum data blocks */
 	VERIFY_CRC32,			/* crc32 sum data blocks */
@@ -17,7 +20,6 @@ enum {
 	VERIFY_SHA256,			/* sha256 sum data blocks */
 	VERIFY_SHA512,			/* sha512 sum data blocks */
 	VERIFY_XXHASH,			/* xxhash sum data blocks */
-	VERIFY_META,			/* block_num, timestamp etc. */
 	VERIFY_SHA1,			/* sha1 sum data blocks */
 	VERIFY_PATTERN,			/* verify specific patterns */
 	VERIFY_PATTERN_NO_HDR,		/* verify specific patterns, no hdr */
@@ -34,6 +36,11 @@ struct verify_header {
 	uint16_t verify_type;
 	uint32_t len;
 	uint64_t rand_seed;
+	uint64_t offset;
+	uint32_t time_sec;
+	uint32_t time_usec;
+	uint16_t thread;
+	uint16_t numberio;
 	uint32_t crc32;
 };
 
@@ -61,13 +68,6 @@ struct vhdr_crc16 {
 struct vhdr_crc7 {
 	uint8_t crc7;
 };
-struct vhdr_meta {
-	uint64_t offset;
-	unsigned char thread;
-	unsigned short numberio;
-	unsigned long time_sec;
-	unsigned long time_usec;
-};
 struct vhdr_xxhash {
 	uint32_t hash;
 };
