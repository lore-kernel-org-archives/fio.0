Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3BA4C7523
	for <fio@vger.kernel.org>; Wed, 30 Sep 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769610; cv=none; b=Xm7gl3zRLK6Tnci/My9epoBLM6IMph7plVqTkGPq2DU++FyEHHZXyUeVivIMnGeoTf9ReNZuoG7QrG2mo+YHrYSGvwn2YEHV9zNqzzMRJHRu6tTae7VStGJOOzuztmInet6LYvxfKrk/ZhNtcJC+Yo0e+Zn6H5ujeBU1yBNT8Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769610; c=relaxed/simple;
	bh=iLJQ4bB3lO86wIBaGzI3NO//mb2HxpwWHs3Q30n3hzg=;
	h=Subject:From:To:Date:Message-Id; b=nSRKeH2P9IysNUWz2owKk7P9zY5tuOzgie2lbnyfipgVcSQXTn7Y+dSlNieV9rG7Id0xC/c9mcNZG/Peli+8BMccVUrgwWQdDx/NazSDHFnlvQ/TzChB8a6xiWMm/57rC/gjs7N0r6K5QwDdD8UjL4EHDA4dK1VK+TS3QKT21dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z/nZubUV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z/nZubUV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=LDndeIq6BcMMgknWdhf1ifRUcALAx9LUfHQxIpzYE7g=; b=Z/nZubUVzgX1Dt1A+/OIegPJLc
	f7f37vZhBDH6JKh9LDvW1Pl6xLXqZomczJQ2p4PsJ5tokjA4k2cpUNCNQLE64a5bVT/UU565v6wpy
	BzV4K3H324NHb9sLAuFfSGQQLz7bkA6Ahz2SQL8bOdKoTKUT/0hyjO0QnpNYY44qh/hztWqc6/kra
	wsFGFSj9mFtgH+NNqf95BSU9v9x8ebCbvh50SvHrhTX002J1uBGN2MwwhKmPEDaV0y5K4Hwwkjzs+
	q1x61eUgzVXZyU+EePOma8n0LWp4e62f0Vwz5QjJPy45Kyi0uDAHn2YJRoAxSqPDhLW3TGkFHbXc7
	cGj9lFXw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBsyi-0000000CyEd-3O1Y
	for fio@vger.kernel.org;
	Wed, 30 Sep 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C16F41BC015A; Wed, 30 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 30 Sep 2026 06:00:01 -0600
Message-Id: <20260930120001.C16F41BC015A@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 270b6fb4e295ef1f24545b72eda33281088b46e0:

  examples: add mobile storage test (2026-09-23 13:34:06 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 86196b9b9104b87a81ca5e54c87b8acf471d8cad:

  Merge branch 'http-slist-leak' of https://github.com/niharika-khare/fio (2026-09-29 13:27:05 -0400)

----------------------------------------------------------------
Niharika Khare (1):
      engines/http: fix curl_slist leak in S3 and Swift header helpers

Vincent Fu (1):
      Merge branch 'http-slist-leak' of https://github.com/niharika-khare/fio

 engines/http.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/engines/http.c b/engines/http.c
index 83891f1f..f0bf40ce 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -445,7 +445,7 @@ static int _curl_trace(CURL *handle, curl_infotype type,
 /* https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
  * https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html#signing-request-intro
  */
-static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct http_options *o,
+static struct curl_slist* _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct http_options *o,
 		int op, const char *uri, char *buf, size_t len)
 {
 	char date_short[16];
@@ -610,9 +610,10 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 		free(sse_key_base64);
 		free(sse_key_md5_base64);
 	}
+	return slist;
 }
 
-static void _add_swift_header(CURL *curl, struct curl_slist *slist, struct http_options *o,
+static struct curl_slist* _add_swift_header(CURL *curl, struct curl_slist *slist, struct http_options *o,
 		int op, const char *uri, char *buf, size_t len)
 {
 	char *dsha = NULL;
@@ -633,6 +634,7 @@ static void _add_swift_header(CURL *curl, struct curl_slist *slist, struct http_
 	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, slist);
 
 	free(dsha);
+	return slist;
 }
 
 static struct curl_slist* _append_range_header(struct curl_slist *slist, unsigned long long offset, unsigned long long length, unsigned long long file_size)
@@ -740,10 +742,10 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 		slist = _append_range_header(slist, io_u->offset, io_u->xfer_buflen, io_u->file->real_file_size);
 
 	if (o->mode == FIO_HTTP_S3)
-		_add_aws_auth_header(http->curl, slist, o, io_u->ddir, object_path,
+		slist = _add_aws_auth_header(http->curl, slist, o, io_u->ddir, object_path,
 			io_u->xfer_buf, io_u->xfer_buflen);
 	else if (o->mode == FIO_HTTP_SWIFT)
-		_add_swift_header(http->curl, slist, o, io_u->ddir, object_path,
+		slist = _add_swift_header(http->curl, slist, o, io_u->ddir, object_path,
 			io_u->xfer_buf, io_u->xfer_buflen);
 
 	if (io_u->ddir == DDIR_WRITE) {
