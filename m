Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbbFIMAC (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Jun 2015 08:00:02 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z2ICI-0004y3-I9
	for fio@vger.kernel.org; Tue, 09 Jun 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150609120001.722BB2C0102@kernel.dk>
Date: Tue,  9 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c44ff5115df69f0040aef9677bf48966d72adb81:

  configure: add some missing help options (2015-06-05 08:33:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5924538164650c6c0dc0e866d6ed15eb199ed020:

  verify: add raw pattern verify (2015-06-08 20:43:43 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      backend: don't add to runtime for fake writes
      verify: add raw pattern verify

Tomohiro Kusumi (1):
      Clear sysfs path before reading current ioscheduler from sysfs

 HOWTO     |  6 ++++++
 backend.c |  9 ++++++++-
 fio.1     |  7 ++++++-
 options.c |  6 ++++++
 verify.c  | 13 ++++++++++---
 verify.h  |  1 +
 6 files changed, 37 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 291327d..61ebe5e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1281,6 +1281,12 @@ verify=str	If writing to a file, fio can verify the file contents
 				verified for workloads that write data.
 				See also verify_pattern.
 
+			pattern	Verify a strict pattern. Normally fio includes
+				a header with some basic information and
+				checksumming, but if this option is set, only
+				the specific pattern set with 'verify_pattern'
+				is verified.
+
 			null	Only pretend to verify. Useful for testing
 				internals with ioengine=null, not for much
 				else.
diff --git a/backend.c b/backend.c
index 2aa8840..975317f 100644
--- a/backend.c
+++ b/backend.c
@@ -373,6 +373,9 @@ static inline void update_runtime(struct thread_data *td,
 				  unsigned long long *elapsed_us,
 				  const enum fio_ddir ddir)
 {
+	if (ddir == DDIR_WRITE && td_write(td) && td->o.verify_only)
+		return;
+
 	td->ts.runtime[ddir] -= (elapsed_us[ddir] + 999) / 1000;
 	elapsed_us[ddir] += utime_since_now(&td->start);
 	td->ts.runtime[ddir] += (elapsed_us[ddir] + 999) / 1000;
@@ -1172,13 +1175,17 @@ static int switch_ioscheduler(struct thread_data *td)
 	/*
 	 * Read back and check that the selected scheduler is now the default.
 	 */
+	memset(tmp, 0, sizeof(tmp));
 	ret = fread(tmp, sizeof(tmp), 1, f);
 	if (ferror(f) || ret < 0) {
 		td_verror(td, errno, "fread");
 		fclose(f);
 		return 1;
 	}
-	tmp[sizeof(tmp) - 1] = '\0';
+	/*
+	 * either a list of io schedulers or "none\n" is expected.
+	 */
+	tmp[strlen(tmp) - 1] = '\0';
 
 
 	sprintf(tmp2, "[%s]", td->o.ioscheduler);
diff --git a/fio.1 b/fio.1
index 1657082..5f8e948 100644
--- a/fio.1
+++ b/fio.1
@@ -1129,6 +1129,11 @@ not supported by the system.
 Write extra information about each I/O (timestamp, block number, etc.). The
 block number is verified. See \fBverify_pattern\fR as well.
 .TP
+.B pattern
+Verify a strict pattern. Normally fio includes a header with some basic
+information and checksumming, but if this option is set, only the
+specific pattern set with \fBverify_pattern\fR is verified.
+.TP
 .B null
 Pretend to verify.  Used for testing internals.
 .RE
@@ -1162,7 +1167,7 @@ pattern for io verification purposes. Depending on the width of the pattern,
 fio will fill 1/2/3/4 bytes of the buffer at the time(it can be either a
 decimal or a hex number). The verify_pattern if larger than a 32-bit quantity
 has to be a hex number that starts with either "0x" or "0X". Use with
-\fBverify\fP=meta.
+\fBverify\fP=meta or \fBverify\fP=pattern.
 .TP
 .BI verify_fatal \fR=\fPbool
 If true, exit the job on the first observed verification failure.  Default:
diff --git a/options.c b/options.c
index 96b8b68..cd37141 100644
--- a/options.c
+++ b/options.c
@@ -983,6 +983,8 @@ static int pattern_cb(char *pattern, unsigned int max_size,
 	 */
 fill:
 	pattern_length = i;
+	if (!i && !off)
+		i = 1;
 	while (i > 1 && i * 2 <= max_size) {
 		memcpy(&pattern[i], &pattern[0], i);
 		i *= 2;
@@ -2400,6 +2402,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = VERIFY_META,
 			    .help = "Use io information",
 			  },
+			  { .ival = "pattern",
+			    .oval = VERIFY_PATTERN_NO_HDR,
+			    .help = "Verify strict pattern",
+			  },
 			  {
 			    .ival = "null",
 			    .oval = VERIFY_NULL,
diff --git a/verify.c b/verify.c
index fcdf748..806f41e 100644
--- a/verify.c
+++ b/verify.c
@@ -168,6 +168,7 @@ static inline unsigned int __hdr_size(int verify_type)
 		len = sizeof(struct vhdr_sha1);
 		break;
 	case VERIFY_PATTERN:
+	case VERIFY_PATTERN_NO_HDR:
 		len = 0;
 		break;
 	default:
@@ -787,9 +788,11 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		if (td->o.verifysort || (td->flags & TD_F_VER_BACKLOG))
 			io_u->rand_seed = hdr->rand_seed;
 
-		ret = verify_header(io_u, hdr, hdr_num, hdr_inc);
-		if (ret)
-			return ret;
+		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
+			ret = verify_header(io_u, hdr, hdr_num, hdr_inc);
+			if (ret)
+				return ret;
+		}
 
 		if (td->o.verify != VERIFY_NONE)
 			verify_type = td->o.verify;
@@ -832,6 +835,7 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			ret = verify_io_u_sha1(hdr, &vc);
 			break;
 		case VERIFY_PATTERN:
+		case VERIFY_PATTERN_NO_HDR:
 			ret = verify_io_u_pattern(hdr, &vc);
 			break;
 		default:
@@ -965,6 +969,9 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 	unsigned int data_len;
 	void *data, *p;
 
+	if (td->o.verify == VERIFY_PATTERN_NO_HDR)
+		return;
+
 	p = (void *) hdr;
 
 	hdr->magic = FIO_HDR_MAGIC;
diff --git a/verify.h b/verify.h
index d4d6012..c37b1d5 100644
--- a/verify.h
+++ b/verify.h
@@ -20,6 +20,7 @@ enum {
 	VERIFY_META,			/* block_num, timestamp etc. */
 	VERIFY_SHA1,			/* sha1 sum data blocks */
 	VERIFY_PATTERN,			/* verify specific patterns */
+	VERIFY_PATTERN_NO_HDR,		/* verify specific patterns, no hdr */
 	VERIFY_NULL,			/* pretend to verify */
 };
 
