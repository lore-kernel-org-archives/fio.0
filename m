Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33590 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbbGXTtm (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Jul 2015 15:49:42 -0400
Received: by wicmv11 with SMTP id mv11so76711229wic.0
        for <fio@vger.kernel.org>; Fri, 24 Jul 2015 12:49:40 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [PATCH 1/1] verify: move meta header to generic verify_header
Date: Fri, 24 Jul 2015 21:49:33 +0200
Message-Id: <1437767373-26631-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

fio does not provide any possibility to verify checksum of a block with meta
information inside. You can create configuration for verifincation checksum
of random data either you can verify meta information with some pattern or
random data, but not both.

Why checksumming and meta together can be useful? Meta helps to figure out internally
on filesystem or storage what block was written in case of corruption, i.e. offset
of the block and block number explicitly tell us the virtual address of the block.
On the other hand checksum of random data helps to detect corruption. Using meta
and pattern together do not help a lot, since 'verify_interval' can be big enough
and same sequence of pattern bytes will be undistinguishable internally on filesystem
or storage.

Also, it seems to me that keeping meta header separately from generic verify header
does not make a lot of sense, since generic verify header can include all members
of meta header without any performance or other impact.

In this patch I move all members from vhdr_meta structure to generic verify_header,
always verifying meta with the possiblity to checksum the following data: random
or pattern.

You are allowed to specify verify_pattern=str with any of the possible verification
methods and have also meta verification, i.e.

   verify=md5
   verify_pattern=0xfe

 or

   verify=sha1
   verify_pattern=0xff

 etc.

To keep everything compatible with old configurations it is still possible to specify

   verify=meta

but this option marked and depricated and kept only for compatibility reasons.

Before that patch the verification layout according to the specified options looks
as the following, e.g.:

 #1
    --
    verify=meta
    verify_pattern=0xff
    --

    result layout of each block: [hdr|meta|pattern]

 #2
    --
    verify_pattern=0xff
    --

    result layout of each block: [hdr|pattern]

 #3
    --
    verify=pattern
    verify_pattern=0xff
    --

    result layout of each block: [pattern]

After applying of the patch 'vhdr_meta' is always embedded into 'verify_header' and layout
looks as the following, e.g.:

 #1
    --
    verify=meta
    verify_pattern=0xff
    --

    result layout of each block: [hdr+meta|pattern]
 #2
    --
    verify=md5|sha1|etc
    verify_pattern=0xff
    --

    result layout of each block: [hdr+meta|cksum|pattern]

 #3
    --
    verify_pattern=0xff
    --

    result layout of each block: [hdr+meta|pattern]

 #4
    --
    verify=pattern
    verify_pattern=0xff
    --

    result layout of each block: [pattern]

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: fio@vger.kernel.org
---
 HOWTO     |  19 +++++----
 options.c |  10 +++--
 verify.c  | 140 +++++++++++++++++++++++++++-----------------------------------
 verify.h  |  16 +++----
 4 files changed, 87 insertions(+), 98 deletions(-)

diff --git a/HOWTO b/HOWTO
index b61a638..59589b2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1239,7 +1239,12 @@ do_verify=bool	Run the verify phase after a write phase. Only makes sense if
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
@@ -1275,11 +1280,11 @@ verify=str	If writing to a file, fio can verify the file contents
 
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
@@ -1324,7 +1329,7 @@ verify_pattern=str	If set, fio will fill the io buffers with this
 		buffer at the time(it can be either a decimal or a hex number).
 		The verify_pattern if larger than a 32-bit quantity has to
 		be a hex number that starts with either "0x" or "0X". Use
-		with verify=meta.
+		with verify=str.
 
 verify_fatal=bool	Normally fio will keep checking the entire contents
 		before quitting on a block verification failure. If this
diff --git a/options.c b/options.c
index ed5d37e..6e63a61 100644
--- a/options.c
+++ b/options.c
@@ -1062,7 +1062,7 @@ static int str_verify_pattern_cb(void *data, const char *input)
 				&td->o.verify_pattern_bytes);
 
 	/*
-	 * VERIFY_META could already be set
+	 * VERIFY_* could already be set
 	 */
 	if (!ret && !fio_option_is_set(&td->o, verify))
 		td->o.verify = VERIFY_PATTERN;
@@ -2398,9 +2398,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
index f833e85..8676389 100644
--- a/verify.c
+++ b/verify.c
@@ -28,10 +28,12 @@
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
@@ -136,6 +138,7 @@ static inline unsigned int __hdr_size(int verify_type)
 
 	switch (verify_type) {
 	case VERIFY_NONE:
+	case VERIFY_HDR_ONLY:
 	case VERIFY_NULL:
 	case VERIFY_PATTERN:
 		len = 0;
@@ -166,9 +169,6 @@ static inline unsigned int __hdr_size(int verify_type)
 	case VERIFY_XXHASH:
 		len = sizeof(struct vhdr_xxhash);
 		break;
-	case VERIFY_META:
-		len = sizeof(struct vhdr_meta);
-		break;
 	case VERIFY_SHA1:
 		len = sizeof(struct vhdr_sha1);
 		break;
@@ -315,7 +315,7 @@ static void dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
 	struct verify_header shdr;
 
 	if (td->o.verify == VERIFY_PATTERN_NO_HDR) {
-		__fill_hdr(&shdr, td->o.verify, vc->io_u->buflen, 0);
+		__fill_hdr(td, vc->io_u, &shdr, 0, vc->io_u->buflen, 0);
 		hdr = &shdr;
 	}
 
@@ -394,43 +394,6 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	return 0;
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
@@ -721,8 +684,9 @@ static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
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
@@ -743,6 +707,30 @@ static int verify_header(struct io_u *io_u, struct verify_header *hdr,
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
@@ -809,7 +797,7 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			io_u->rand_seed = hdr->rand_seed;
 
 		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
-			ret = verify_header(io_u, hdr, hdr_num, hdr_inc);
+			ret = verify_header(io_u, td, hdr, hdr_num, hdr_inc);
 			if (ret)
 				return ret;
 		}
@@ -820,6 +808,12 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
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
@@ -848,9 +842,6 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		case VERIFY_XXHASH:
 			ret = verify_io_u_xxhash(hdr, &vc);
 			break;
-		case VERIFY_META:
-			ret = verify_io_u_meta(hdr, &vc);
-			break;
 		case VERIFY_SHA1:
 			ret = verify_io_u_sha1(hdr, &vc);
 			break;
@@ -875,21 +866,6 @@ done:
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
@@ -982,24 +958,32 @@ static void fill_md5(struct verify_header *hdr, void *p, unsigned int len)
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
@@ -1011,7 +995,7 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 
 	p = (void *) hdr;
 
-	fill_hdr(hdr, td->o.verify, header_len, io_u->rand_seed);
+	fill_hdr(td, io_u, hdr, header_num, header_len, io_u->rand_seed);
 
 	data_len = header_len - hdr_size(td, hdr);
 
@@ -1063,16 +1047,12 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
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
index c37b1d5..725d7a3 100644
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
-- 
2.4.2

