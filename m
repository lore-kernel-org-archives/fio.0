Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbJTMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 20 Oct 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZoVaE-0003VT-Tj
	for fio@vger.kernel.org; Tue, 20 Oct 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151020120002.05F532C0A2E@kernel.dk>
Date: Tue, 20 Oct 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 20cf5aab85ddfa8f58a1638925ccdfe4d57f3f69:

  engines/rbd: potential re-use of active fio_rbd_iou (2015-10-13 15:40:47 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4d400e92d60d2c8e02f30c5eba41238567e6e603:

  strlcat: fix header guard typo (2015-10-19 22:37:39 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      verify: add faster 'memory is all zeroes' helper
      strlcat: fix header guard typo

 lib/strlcat.h |  2 +-
 verify.c      | 67 ++++++++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 47 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/lib/strlcat.h b/lib/strlcat.h
index 34b668e..baeace4 100644
--- a/lib/strlcat.h
+++ b/lib/strlcat.h
@@ -1,5 +1,5 @@
 #ifndef FIO_STRLCAT_H
-#define FIO_STRLCAT_h
+#define FIO_STRLCAT_H
 
 size_t strlcat(char *dst, const char *src, size_t size);
 
diff --git a/verify.c b/verify.c
index ee9160c..19bec75 100644
--- a/verify.c
+++ b/verify.c
@@ -661,38 +661,63 @@ int verify_io_u_async(struct thread_data *td, struct io_u **io_u_ptr)
 	return 0;
 }
 
+/*
+ * Thanks Rusty, for spending the time so I don't have to.
+ *
+ * http://rusty.ozlabs.org/?p=560
+ */
+static int mem_is_zero(const void *data, size_t length)
+{
+	const unsigned char *p = data;
+	size_t len;
+
+	/* Check first 16 bytes manually */
+	for (len = 0; len < 16; len++) {
+		if (!length)
+			return 1;
+		if (*p)
+			return 0;
+		p++;
+		length--;
+	}
+
+	/* Now we know that's zero, memcmp with self. */
+	return memcmp(data, p, length) == 0;
+}
+
+static int mem_is_zero_slow(const void *data, size_t length, size_t *offset)
+{
+	const unsigned char *p = data;
+
+	*offset = 0;
+	while (length) {
+		if (*p)
+			break;
+		(*offset)++;
+		length--;
+		p++;
+	}
+
+	return !length;
+}
+
 static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
 {
-	static char zero_buf[1024];
-	unsigned int this_len, len;
-	int ret = 0;
-	void *p;
+	size_t offset;
 
 	if (!td->o.trim_zero)
 		return 0;
 
-	len = io_u->buflen;
-	p = io_u->buf;
-	do {
-		this_len = sizeof(zero_buf);
-		if (this_len > len)
-			this_len = len;
-		if (memcmp(p, zero_buf, this_len)) {
-			ret = EILSEQ;
-			break;
-		}
-		len -= this_len;
-		p += this_len;
-	} while (len);
-
-	if (!ret)
+	if (mem_is_zero(io_u->buf, io_u->buflen))
 		return 0;
 
+	mem_is_zero_slow(io_u->buf, io_u->buflen, &offset);
+
 	log_err("trim: verify failed at file %s offset %llu, length %lu"
 		", block offset %lu\n",
 			io_u->file->file_name, io_u->offset, io_u->buflen,
-			(unsigned long) (p - io_u->buf));
-	return ret;
+			(unsigned long) offset);
+	return EILSEQ;
 }
 
 static int verify_header(struct io_u *io_u, struct thread_data *td,
