Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C888C334707
	for <fio@vger.kernel.org>; Tue, 19 Aug 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755604811; cv=none; b=dwQiKyuvNHMZO6av4bmXP5SptECh0KCvxTGm6nNNQFpBFtP8CnhkA8yztz2+Y4AHcmLN/8O3L1cfAvps1XhErkFoPtyBMMQZoyZhcUfWI4X+0mo0rCVRfMOIZPYpsziucDG4nix6tD5wYupSnjisJQvnSK886GS1u8k9Rn0ht2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755604811; c=relaxed/simple;
	bh=V4MzsHqXVQZTPN0YrZV8O2j7nPekac1wIR0c+fvkLzY=;
	h=Subject:From:To:Message-Id:Date; b=LaeHPzq9rMboZmVTtAyp+QHATz3rKiVtap/nkW54iERbzfReija9bvg+KBKMCv7DEEMmfxgncl2wJu/sSDpRr5fH/+amJPIL4MuWvKpbHMvqaKkM25iXTk1lSLX0nnJuWcuadyt0n8FqnWflN1ghENwf7ry5TSj3RvOpO2+AAvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J32SI6t/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J32SI6t/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Bek+pDcMBz+pCcljqqMShbLMBc4f1nIGvdcvOlkcwUI=; b=J32SI6t/E/3sqbDBIbNy/2nYVG
	gFRZ4OP/vRNmaOb3SlOf5REi9F814lO4UwA7SQsP4zdGUq3OT/qD9uQuYofeEh9Y3PmGVPcU3xRBy
	0AZQK9hAQDkRO1U84q1DyidV9ftyL5VnoDT2DAWilSPQFG1UFPSsI//6v26KKOnMz1BqxhkMhyOVz
	+QtE33mF8Sf+twksEGyI75GQbT2jtrCs12l4TmfJEmDY63Ovg3Sc2guLi0fn/o+BE9vY1UN+VYxOE
	ZyN2hJKNoD7If/zzImP1O9Ojc/pJrodzQaw0A87LFNjDAfPUOpJfWxAs0DvD/eIKBjy7k4wLTlWPb
	pRR32u2g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoL0V-00000004god-3Zcx
	for fio@vger.kernel.org;
	Tue, 19 Aug 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id CEA4F1BC0156; Tue, 19 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250819120001.CEA4F1BC0156@kernel.dk>
Date: Tue, 19 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit fef641096d925d737d81683626eca52b6e358e52:

  configure: skip isal64 check when isal check fails (2025-08-11 12:42:06 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7664dccc0b2e3de04a0fd6f0be63402716c5f6b7:

  Merge branch 'http-range-header' of https://github.com/sfc-gh-rnarubin/fio (2025-08-18 13:53:46 -0400)

----------------------------------------------------------------
Renar Narubin (1):
      engines/http: Add support for range reads

Vincent Fu (1):
      Merge branch 'http-range-header' of https://github.com/sfc-gh-rnarubin/fio

 HOWTO.rst      | 18 +++++++++++++
 engines/http.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++----------
 fio.1          | 20 ++++++++++++++
 3 files changed, 107 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 55ebc388..3eb0d9fe 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3058,6 +3058,24 @@ with the caveat that when used on the command line, they must come after the
 	turns on verbose logging from libcurl, 2 additionally enables
 	HTTP IO tracing. Default is **0**
 
+.. option:: http_object_mode=str : [http]
+
+        How to structure objects for HTTP IO: *block* or *range*.
+        Default is **block**.
+
+        In *block* mode, one object is created for every block. The HTTP engine
+        treats :option:`blocksize` as the size of the object to read or write,
+        and appends the block start/end offsets to the :option:`filename` to
+        create the target object path. Reads and writes operate on whole
+        objects at a time.
+
+        In *range* mode, one object is created for every file. The object path
+        is the filename directly for both read and write I/O. For read
+        requests, the :option:`blocksize` and :option:`offset` will be used to
+        set the "Range" header on read requests to issue partial reads of the
+        object. For write requests, blocksize is used to set the size of the
+        object, the same as in *block* mode.
+
 .. option:: uri=str : [nbd]
 
 	Specify the NBD URI of the server to test.  The string
diff --git a/engines/http.c b/engines/http.c
index b893ec7a..1a1787bf 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -35,13 +35,16 @@
 #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
 
 enum {
-	FIO_HTTP_WEBDAV	    = 0,
-	FIO_HTTP_S3	    = 1,
-	FIO_HTTP_SWIFT	    = 2,
+	FIO_HTTP_WEBDAV		= 0,
+	FIO_HTTP_S3		= 1,
+	FIO_HTTP_SWIFT		= 2,
 
-	FIO_HTTPS_OFF	    = 0,
-	FIO_HTTPS_ON	    = 1,
-	FIO_HTTPS_INSECURE  = 2,
+	FIO_HTTPS_OFF		= 0,
+	FIO_HTTPS_ON		= 1,
+	FIO_HTTPS_INSECURE	= 2,
+
+	FIO_HTTP_OBJECT_BLOCK	= 0,
+	FIO_HTTP_OBJECT_RANGE	= 1,
 };
 
 struct http_data {
@@ -64,6 +67,7 @@ struct http_options {
 	char *swift_auth_token;
 	int verbose;
 	unsigned int mode;
+	unsigned int object_mode;
 };
 
 struct http_curl_stream {
@@ -239,6 +243,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group    = FIO_OPT_G_HTTP,
 	},
+	{
+		.name     = "http_object_mode",
+		.lname    = "Object mode to use",
+		.type     = FIO_OPT_STR,
+		.help     = "How to structure objects when issuing HTTP requests",
+		.off1     = offsetof(struct http_options, object_mode),
+		.def	  = "block",
+		.posval = {
+			  { .ival = "block",
+			    .oval = FIO_HTTP_OBJECT_BLOCK,
+			    .help = "One object per block",
+			  },
+			  { .ival = "range",
+			    .oval = FIO_HTTP_OBJECT_RANGE,
+			    .help = "One object per file, range reads per block",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
 	{
 		.name     = NULL,
 	},
@@ -611,6 +635,26 @@ static void _add_swift_header(CURL *curl, struct curl_slist *slist, struct http_
 	free(dsha);
 }
 
+static struct curl_slist* _append_range_header(struct curl_slist *slist, unsigned long long offset, unsigned long long length, unsigned long long file_size)
+{
+	char s[256];
+	unsigned long long end_byte;
+
+	/* Don't request beyond end of file */
+	if (offset >= file_size) {
+		return slist;
+	}
+
+	/* Calculate end byte, but cap it at file size - 1 because end range is inclusive */
+	end_byte = offset + length - 1;
+	if (end_byte >= file_size) {
+		end_byte = file_size - 1;
+	}
+
+	snprintf(s, sizeof(s), "Range: bytes=%llu-%llu", offset, end_byte);
+	return curl_slist_append(slist, s);
+}
+
 static void fio_http_cleanup(struct thread_data *td)
 {
 	struct http_data *http = td->io_ops_data;
@@ -667,30 +711,39 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 	struct http_options *o = td->eo;
 	struct http_curl_stream _curl_stream;
 	struct curl_slist *slist = NULL;
-	char object[512];
+	char object_path_buf[512];
+	char *object_path;
 	char url[1024];
 	long status;
 	CURLcode res;
 
 	fio_ro_check(td, io_u);
 	memset(&_curl_stream, 0, sizeof(_curl_stream));
-	snprintf(object, sizeof(object), "%s_%llu_%llu", io_u->file->file_name,
-		io_u->offset, io_u->xfer_buflen);
+	if (o->object_mode == FIO_HTTP_OBJECT_BLOCK) {
+		snprintf(object_path_buf, sizeof(object_path_buf), "%s_%llu_%llu", io_u->file->file_name,
+			io_u->offset, io_u->xfer_buflen);
+		object_path = object_path_buf;
+	} else
+		object_path = io_u->file->file_name;
 	if (o->https == FIO_HTTPS_OFF)
-		snprintf(url, sizeof(url), "http://%s%s", o->host, object);
+		snprintf(url, sizeof(url), "http://%s%s", o->host, object_path);
 	else
-		snprintf(url, sizeof(url), "https://%s%s", o->host, object);
+		snprintf(url, sizeof(url), "https://%s%s", o->host, object_path);
+
 	curl_easy_setopt(http->curl, CURLOPT_URL, url);
 	_curl_stream.buf = io_u->xfer_buf;
 	_curl_stream.max = io_u->xfer_buflen;
 	curl_easy_setopt(http->curl, CURLOPT_SEEKDATA, &_curl_stream);
 	curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, (curl_off_t)io_u->xfer_buflen);
 
+	if (io_u->ddir == DDIR_READ && o->object_mode == FIO_HTTP_OBJECT_RANGE)
+		slist = _append_range_header(slist, io_u->offset, io_u->xfer_buflen, io_u->file->real_file_size);
+
 	if (o->mode == FIO_HTTP_S3)
-		_add_aws_auth_header(http->curl, slist, o, io_u->ddir, object,
+		_add_aws_auth_header(http->curl, slist, o, io_u->ddir, object_path,
 			io_u->xfer_buf, io_u->xfer_buflen);
 	else if (o->mode == FIO_HTTP_SWIFT)
-		_add_swift_header(http->curl, slist, o, io_u->ddir, object,
+		_add_swift_header(http->curl, slist, o, io_u->ddir, object_path,
 			io_u->xfer_buf, io_u->xfer_buflen);
 
 	if (io_u->ddir == DDIR_WRITE) {
@@ -712,7 +765,9 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 		res = curl_easy_perform(http->curl);
 		if (res == CURLE_OK) {
 			curl_easy_getinfo(http->curl, CURLINFO_RESPONSE_CODE, &status);
-			if (status == 200)
+			/* 206 "Partial Content" means success when using the
+			 * Range header */
+			if (status == 200 || (o->object_mode == FIO_HTTP_OBJECT_RANGE && status == 206))
 				goto out;
 			else if (status == 404) {
 				/* Object doesn't exist. Pretend we read
diff --git a/fio.1 b/fio.1
index 5bcb1d46..6aa23f7d 100644
--- a/fio.1
+++ b/fio.1
@@ -2648,6 +2648,26 @@ Enable verbose requests from libcurl. Useful for debugging. 1 turns on
 verbose logging from libcurl, 2 additionally enables HTTP IO tracing.
 Default is \fB0\fR
 .TP
+.BI (http)http_object_mode \fR=\fPstr
+How to structure objects for HTTP IO: block or range. Default is \fBblock\fR.
+.RS
+.RS
+.TP
+.B block
+One object is created for every block. The HTTP engine treats \fBblocksize\fR
+as the size of the object to read or write, and appends the block start/end
+offsets to the \fBfilename\fR to create the target object path. Reads and
+writes operate on whole objects at a time.
+.TP
+.B range
+One object is created for every file. The object path is the filename directly
+for both read and write I/O. For read requests, the \fBblocksize\fR and
+\fBoffset\fR will be used to set the "Range" header on read requests to issue
+partial reads of the object. For write requests, blocksize is used to set the
+size of the object, the same as in \fBblock\fR mode.
+.RE
+.RE
+.TP
 .BI (mtd)skip_bad \fR=\fPbool
 Skip operations against known bad blocks.
 .TP
