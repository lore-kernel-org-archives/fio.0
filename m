Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA05F237713
	for <fio@vger.kernel.org>; Thu, 10 Jul 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752148810; cv=none; b=DLMn36UoPrXZAV3dsEUua0B2DdAveH/q6AcsmwgJ4yCItq3uyLUKLWj3kqwr/RX0xIcltFzIQJrfPhcuP326ePqV2rm963XXLtssxvJ5rWBNEUx55NEsnKJo2K7NTVZza93JUt3TnDNW8UZQ9WAKoZMg4SL4uNmvB68Q/NxTFrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752148810; c=relaxed/simple;
	bh=wuDHz9LgcHZa50eA2WiR2JquZkQD6NBKbUhinVODKz8=;
	h=Subject:From:To:Message-Id:Date; b=swUfZE6ZGwacnRoakMPlJglCtEdGROQphzs7OA0rswmkhR1ZX/qnTSG0PoTELgo4zXGF7Njz0gkCyCGnlFbeQ9V/48lJ1MxjYon9OBw2qYwhjNIUh6OXJm7/84zPVsSTV6WlliIDScuHEu8duGQ32+8MaBUJ/30fVJV0ahs/o48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mH3SgK0j; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mH3SgK0j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aUQn2kISomadLeQMMfPYLh7khJq+IguFy2quCDPpm5U=; b=mH3SgK0j3rQu2TwkbmoYRJ1uxg
	B3W3SgTHn2oPybPh0cApMuueoftp9MSpyAoPYNpY/ri9vAqOLFQDczwx6NvxfiXDOXY+RH/DzdcQ9
	kXVW9i2eKRmvpMwta3fIMOKGpz0lt59+/dND6VNoryTOwhNKtjg3cJcPHcSlAQBeNADNbscK2R9sv
	i6U887q/lzak6/jmTBGdo12OImkN0WYFshUQpGXDWhYGF7vbH+29bWaNf2vSWZJS2Dh6kddZPZfLe
	w18MxKyAi707p6RcZ/If9iYIRXRIijSyL86f8J3Iv/jibqdawybCmLxEOjNB9+slsy2ejykGFnnuD
	0tqqHnAQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uZpwa-000000090XX-3opE
	for fio@vger.kernel.org;
	Thu, 10 Jul 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B10601BC016B; Thu, 10 Jul 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250710120001.B10601BC016B@kernel.dk>
Date: Thu, 10 Jul 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 010b8ba409a18ec1edbf3b776fb7652f26a99b81:

  Merge branch 'http-filename-fix' of https://github.com/sfc-gh-rnarubin/fio (2025-07-08 11:54:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to eb0312ccc1058334e0a115b6534056bcdba7c533:

  Merge branch 'security-token' of https://github.com/sfc-gh-rnarubin/fio (2025-07-09 16:52:06 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'security-token' of https://github.com/sfc-gh-rnarubin/fio

Renar Narubin (1):
      engines/http: Add S3 security token support

 HOWTO.rst      |  4 ++++
 engines/http.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 fio.1          |  3 +++
 3 files changed, 45 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index f082158a..e5ddc89d 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3013,6 +3013,10 @@ with the caveat that when used on the command line, they must come after the
 
 	The S3 key/access id.
 
+.. option:: http_s3_security_token=str : [http]
+
+	The S3 security token.
+
 .. option:: http_s3_sse_customer_key=str : [http]
 
         The encryption customer key in SSE server side.
diff --git a/engines/http.c b/engines/http.c
index 217aa575..b893ec7a 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -56,6 +56,7 @@ struct http_options {
 	char *pass;
 	char *s3_key;
 	char *s3_keyid;
+	char *s3_security_token;
 	char *s3_region;
 	char *s3_sse_customer_key;
 	char *s3_sse_customer_algorithm;
@@ -144,6 +145,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group    = FIO_OPT_G_HTTP,
 	},
+	{
+		.name     = "http_s3_security_token",
+		.lname    = "S3 security token",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "S3 security token",
+		.off1     = offsetof(struct http_options, s3_security_token),
+		.def	  = "",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
 	{
 		.name     = "http_swift_auth_token",
 		.lname    = "Swift auth token",
@@ -419,7 +430,7 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	char dkey[128];
 	char creq[4096];
 	char sts[512];
-	char s[512];
+	char s[2048];
 	char *uri_encoded = NULL;
 	char *dsha = NULL;
 	char *csha = NULL;
@@ -430,6 +441,8 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	unsigned char sse_key[33] = {0};
 	char *sse_key_base64 = NULL;
 	char *sse_key_md5_base64 = NULL;
+	char security_token_header[2048] = {0};
+	char security_token_list_item[24] = {0};
 
 	time_t t = time(NULL);
 	struct tm *gtm = gmtime(&t);
@@ -438,6 +451,12 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	strftime (date_iso, sizeof(date_iso), "%Y%m%dT%H%M%SZ", gtm);
 	uri_encoded = _aws_uriencode(uri);
 
+	if (o->s3_security_token != NULL) {
+		snprintf(security_token_header, sizeof(security_token_header),
+				"x-amz-security-token:%s\n", o->s3_security_token);
+		sprintf(security_token_list_item, "x-amz-security-token;");
+	}
+
 	if (o->s3_sse_customer_key != NULL)
 		strncpy((char*)sse_key, o->s3_sse_customer_key, sizeof(sse_key) - 1);
 
@@ -467,18 +486,21 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 			"x-amz-server-side-encryption-customer-algorithm:%s\n"
 			"x-amz-server-side-encryption-customer-key:%s\n"
 			"x-amz-server-side-encryption-customer-key-md5:%s\n"
+			"%s" /* security token if provided */
 			"x-amz-storage-class:%s\n"
 			"\n"
 			"host;x-amz-content-sha256;x-amz-date;"
 			"x-amz-server-side-encryption-customer-algorithm;"
 			"x-amz-server-side-encryption-customer-key;"
 			"x-amz-server-side-encryption-customer-key-md5;"
+			"%s"
 			"x-amz-storage-class\n"
 			"%s"
 			, method
 			, uri_encoded, o->host, dsha, date_iso
 			, o->s3_sse_customer_algorithm, sse_key_base64
-			, sse_key_md5_base64, o->s3_storage_class, dsha);
+			, sse_key_md5_base64, security_token_header
+			, o->s3_storage_class, security_token_list_item, dsha);
 	} else {
 		snprintf(creq, sizeof(creq),
 			"%s\n"
@@ -487,12 +509,15 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 			"host:%s\n"
 			"x-amz-content-sha256:%s\n"
 			"x-amz-date:%s\n"
+			"%s" /* security token if provided */
 			"x-amz-storage-class:%s\n"
 			"\n"
-			"host;x-amz-content-sha256;x-amz-date;x-amz-storage-class\n"
+			"host;x-amz-content-sha256;x-amz-date;%sx-amz-storage-class\n"
 			"%s"
 			, method
-			, uri_encoded, o->host, dsha, date_iso, o->s3_storage_class, dsha);
+			, uri_encoded, o->host, dsha, date_iso
+			, security_token_header, o->s3_storage_class
+			, security_token_list_item, dsha);
 	}
 
 	csha = _gen_hex_sha256(creq, strlen(creq));
@@ -526,6 +551,11 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 		slist = curl_slist_append(slist, s);
 	}
 
+	if (o->s3_security_token != NULL) {
+		snprintf(s, sizeof(s), "x-amz-security-token: %s", o->s3_security_token);
+		slist = curl_slist_append(slist, s);
+	}
+
 	snprintf(s, sizeof(s), "x-amz-storage-class: %s", o->s3_storage_class);
 	slist = curl_slist_append(slist, s);
 
@@ -535,13 +565,14 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 			"x-amz-date;x-amz-server-side-encryption-customer-algorithm;"
 			"x-amz-server-side-encryption-customer-key;"
 			"x-amz-server-side-encryption-customer-key-md5;"
+			"%s"
 			"x-amz-storage-class,"
 			"Signature=%s",
-		o->s3_keyid, date_short, o->s3_region, signature);
+		o->s3_keyid, date_short, o->s3_region, security_token_list_item, signature);
 	} else {
 		snprintf(s, sizeof(s), "Authorization: AWS4-HMAC-SHA256 Credential=%s/%s/%s/s3/aws4_request,"
-			"SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-storage-class,Signature=%s",
-			o->s3_keyid, date_short, o->s3_region, signature);
+			"SignedHeaders=host;x-amz-content-sha256;x-amz-date;%sx-amz-storage-class,Signature=%s",
+			o->s3_keyid, date_short, o->s3_region, security_token_list_item, signature);
 	}
 	slist = curl_slist_append(slist, s);
 
diff --git a/fio.1 b/fio.1
index 0071c364..cba1273b 100644
--- a/fio.1
+++ b/fio.1
@@ -2605,6 +2605,9 @@ The S3 secret key.
 .BI (http)http_s3_keyid \fR=\fPstr
 The S3 key/access id.
 .TP
+.BI (http)http_s3_security_token \fR=\fPstr
+The S3 security token.
+.TP
 .BI (http)http_s3_sse_customer_key \fR=\fPstr
 The encryption customer key in SSE server side.
 .TP
