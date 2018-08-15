Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57148 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbeHOOwR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Aug 2018 10:52:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fpuTO-0001mH-1P
        for fio@vger.kernel.org; Wed, 15 Aug 2018 12:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180815120002.31FA62C0311@kernel.dk>
Date: Wed, 15 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dcf6ad384149ee0b3f91c5a8127160cc291f7157:

  Merge branch 'fio-man-page' of https://github.com/bvanassche/fio (2018-08-13 21:05:33 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 875e8d6fa4d443068eb1c48a29f5367e454d2a37:

  Merge branch 'wip-http-engine' of https://github.com/l-mb/fio (2018-08-14 10:09:47 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'wip-http-engine' of https://github.com/l-mb/fio

Lars Marowsky-Bree (1):
      engines/http: Add support for WebDAV and S3

 HOWTO                    |  50 +++++
 Makefile                 |   3 +
 configure                |  34 +++
 engines/http.c           | 558 +++++++++++++++++++++++++++++++++++++++++++++++
 examples/http-s3.fio     |  34 +++
 examples/http-webdav.fio |  26 +++
 fio.1                    |  40 ++++
 optgroup.h               |   2 +
 options.c                |   5 +
 9 files changed, 752 insertions(+)
 create mode 100644 engines/http.c
 create mode 100644 examples/http-s3.fio
 create mode 100644 examples/http-webdav.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 1bec806..c77dad1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1835,6 +1835,15 @@ I/O engine
 			(RBD) via librbd without the need to use the kernel rbd driver. This
 			ioengine defines engine specific options.
 
+		**http**
+			I/O engine supporting GET/PUT requests over HTTP(S) with libcurl to
+			a WebDAV or S3 endpoint.  This ioengine defines engine specific options.
+
+			This engine only supports direct IO of iodepth=1; you need to scale this
+			via numjobs. blocksize defines the size of the objects to be created.
+
+			TRIM is translated to object deletion.
+
 		**gfapi**
 			Using GlusterFS libgfapi sync interface to direct access to
 			GlusterFS volumes without having to go through FUSE.  This ioengine
@@ -2115,6 +2124,47 @@ with the caveat that when used on the command line, they must come after the
 		transferred to the device. The writefua option is ignored with this
 		selection.
 
+.. option:: http_host=str : [http]
+
+	Hostname to connect to. For S3, this could be the bucket hostname.
+	Default is **localhost**
+
+.. option:: http_user=str : [http]
+
+	Username for HTTP authentication.
+
+.. option:: http_pass=str : [http]
+
+	Password for HTTP authentication.
+
+.. option:: https=bool : [http]
+
+	Enable HTTPS instead of http. Default is **0**
+
+.. option:: http_s3=bool : [http]
+
+	Enable S3 specific HTTP headers such as authenticating requests
+	with AWS Signature Version 4. Default is **0**
+
+.. option:: http_s3_region=str : [http]
+
+	The S3 region/zone string.
+	Default is **us-east-1**
+
+.. option:: http_s3_key=str : [http]
+
+	The S3 secret key.
+
+.. option:: http_s3_keyid=str : [http]
+
+	The S3 key/access id.
+
+.. option:: http_verbose=int : [http]
+
+	Enable verbose requests from libcurl. Useful for debugging. 1
+	turns on verbose logging from libcurl, 2 additionally enables
+	HTTP IO tracing. Default is **0**
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index f9bd787..b981b45 100644
--- a/Makefile
+++ b/Makefile
@@ -101,6 +101,9 @@ endif
 ifdef CONFIG_RBD
   SOURCE += engines/rbd.c
 endif
+ifdef CONFIG_HTTP
+  SOURCE += engines/http.c
+endif
 SOURCE += oslib/asprintf.c
 ifndef CONFIG_STRSEP
   SOURCE += oslib/strsep.c
diff --git a/configure b/configure
index 9bdc7a1..103ea94 100755
--- a/configure
+++ b/configure
@@ -181,6 +181,8 @@ for opt do
   ;;
   --disable-rbd) disable_rbd="yes"
   ;;
+  --disable-http) disable_http="yes"
+  ;;
   --disable-gfapi) disable_gfapi="yes"
   ;;
   --enable-libhdfs) libhdfs="yes"
@@ -1567,6 +1569,35 @@ fi
 print_config "IPv6 helpers" "$ipv6"
 
 ##########################################
+# check for http
+if test "$http" != "yes" ; then
+  http="no"
+fi
+cat > $TMPC << EOF
+#include <curl/curl.h>
+#include <openssl/hmac.h>
+
+int main(int argc, char **argv)
+{
+  CURL *curl;
+  HMAC_CTX *ctx;
+
+  curl = curl_easy_init();
+  curl_easy_cleanup(curl);
+
+  ctx = HMAC_CTX_new();
+  HMAC_CTX_reset(ctx);
+  HMAC_CTX_free(ctx);
+  return 0;
+}
+EOF
+if test "$disable_http" != "yes"  && compile_prog "" "-lcurl -lssl -lcrypto" "curl"; then
+  LIBS="-lcurl -lssl -lcrypto $LIBS"
+  http="yes"
+fi
+print_config "http engine" "$http"
+
+##########################################
 # check for rados
 if test "$rados" != "yes" ; then
   rados="no"
@@ -2346,6 +2377,9 @@ fi
 if test "$ipv6" = "yes" ; then
   output_sym "CONFIG_IPV6"
 fi
+if test "$http" = "yes" ; then
+  output_sym "CONFIG_HTTP"
+fi
 if test "$rados" = "yes" ; then
   output_sym "CONFIG_RADOS"
 fi
diff --git a/engines/http.c b/engines/http.c
new file mode 100644
index 0000000..d3fdba8
--- /dev/null
+++ b/engines/http.c
@@ -0,0 +1,558 @@
+/*
+ * HTTP GET/PUT IO engine
+ *
+ * IO engine to perform HTTP(S) GET/PUT requests via libcurl-easy.
+ *
+ * Copyright (C) 2018 SUSE LLC
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the Free
+ * Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
+ */
+
+#include <pthread.h>
+#include <time.h>
+#include <curl/curl.h>
+#include <openssl/hmac.h>
+#include <openssl/sha.h>
+#include "fio.h"
+#include "../optgroup.h"
+
+
+struct http_data {
+	CURL *curl;
+};
+
+struct http_options {
+	void *pad;
+	int  https;
+	char *host;
+	char *user;
+	char *pass;
+	char *s3_key;
+	char *s3_keyid;
+	char *s3_region;
+	int verbose;
+	int s3;
+};
+
+struct http_curl_stream {
+	char *buf;
+	size_t pos;
+	size_t max;
+};
+
+static struct fio_option options[] = {
+	{
+		.name     = "https",
+		.lname    = "https",
+		.type     = FIO_OPT_BOOL,
+		.help     = "Enable https",
+		.off1     = offsetof(struct http_options, https),
+		.def      = "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_host",
+		.lname    = "http_host",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "Hostname (S3 bucket)",
+		.off1     = offsetof(struct http_options, host),
+		.def	  = "localhost",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_user",
+		.lname    = "http_user",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "HTTP user name",
+		.off1     = offsetof(struct http_options, user),
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_pass",
+		.lname    = "http_pass",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "HTTP password",
+		.off1     = offsetof(struct http_options, pass),
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_s3_key",
+		.lname    = "S3 secret key",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "S3 secret key",
+		.off1     = offsetof(struct http_options, s3_key),
+		.def	  = "",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_s3_keyid",
+		.lname    = "S3 key id",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "S3 key id",
+		.off1     = offsetof(struct http_options, s3_keyid),
+		.def	  = "",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_s3_region",
+		.lname    = "S3 region",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "S3 region",
+		.off1     = offsetof(struct http_options, s3_region),
+		.def	  = "us-east-1",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_s3",
+		.lname    = "S3 extensions",
+		.type     = FIO_OPT_BOOL,
+		.help     = "Whether to enable S3 specific headers",
+		.off1     = offsetof(struct http_options, s3),
+		.def	  = "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_verbose",
+		.lname    = "CURL verbosity",
+		.type     = FIO_OPT_INT,
+		.help     = "increase http engine verbosity",
+		.off1     = offsetof(struct http_options, verbose),
+		.def	  = "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = NULL,
+	},
+};
+
+static char *_aws_uriencode(const char *uri)
+{
+	size_t bufsize = 1024;
+	char *r = malloc(bufsize);
+	char c;
+	int i, n;
+	const char *hex = "0123456789ABCDEF";
+
+	if (!r) {
+		log_err("malloc failed\n");
+		return NULL;
+	}
+
+	n = 0;
+	for (i = 0; (c = uri[i]); i++) {
+		if (n > bufsize-5) {
+			log_err("encoding the URL failed\n");
+			return NULL;
+		}
+
+		if ( (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
+		|| (c >= '0' && c <= '9') || c == '_' || c == '-'
+		|| c == '~' || c == '.' || c == '/')
+			r[n++] = c;
+		else {
+			r[n++] = '%';
+			r[n++] = hex[(c >> 4 ) & 0xF];
+			r[n++] = hex[c & 0xF];
+		}
+	}
+	r[n++] = 0;
+	return r;
+}
+
+static char *_conv_hex(const unsigned char *p, size_t len)
+{
+	char *r;
+	int i,n;
+	const char *hex = "0123456789abcdef";
+	r = malloc(len * 2 + 1);
+	n = 0;
+	for (i = 0; i < len; i++) {
+		r[n++] = hex[(p[i] >> 4 ) & 0xF];
+		r[n++] = hex[p[i] & 0xF];
+	}
+	r[n] = 0;
+
+	return r;
+}
+
+static char *_gen_hex_sha256(const char *p, size_t len)
+{
+	unsigned char hash[SHA256_DIGEST_LENGTH];
+
+	SHA256((unsigned char*)p, len, hash);
+	return _conv_hex(hash, SHA256_DIGEST_LENGTH);
+}
+
+static void _hmac(unsigned char *md, void *key, int key_len, char *data) {
+	HMAC_CTX *ctx;
+	unsigned int hmac_len;
+
+	ctx = HMAC_CTX_new();
+	HMAC_Init_ex(ctx, key, key_len, EVP_sha256(), NULL);
+	HMAC_Update(ctx, (unsigned char*)data, strlen(data));
+	HMAC_Final(ctx, md, &hmac_len);
+	HMAC_CTX_free(ctx);
+}
+
+static int _curl_trace(CURL *handle, curl_infotype type,
+	     char *data, size_t size,
+	     void *userp)
+{
+	const char *text;
+	(void)handle; /* prevent compiler warning */
+	(void)userp;
+
+	switch (type) {
+	case CURLINFO_TEXT:
+	fprintf(stderr, "== Info: %s", data);
+	default:
+	case CURLINFO_SSL_DATA_OUT:
+	case CURLINFO_SSL_DATA_IN:
+		return 0;
+
+	case CURLINFO_HEADER_OUT:
+		text = "=> Send header";
+		break;
+	case CURLINFO_DATA_OUT:
+		text = "=> Send data";
+		break;
+	case CURLINFO_HEADER_IN:
+		text = "<= Recv header";
+		break;
+	case CURLINFO_DATA_IN:
+		text = "<= Recv data";
+		break;
+	}
+
+	log_info("%s: %s", text, data);
+	return 0;
+}
+
+/* https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
+ * https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html#signing-request-intro
+ */
+static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct http_options *o,
+		int op, const char *uri, char *buf, size_t len)
+{
+	char date_short[16];
+	char date_iso[32];
+	char method[8];
+	char dkey[128];
+	char creq[512];
+	char sts[256];
+	char s[512];
+	char *uri_encoded = NULL;
+	char *dsha = NULL;
+	char *csha = NULL;
+	char *signature = NULL;
+	const char *service = "s3";
+	const char *aws = "aws4_request";
+	unsigned char md[SHA256_DIGEST_LENGTH];
+
+	time_t t = time(NULL);
+	struct tm *gtm = gmtime(&t);
+
+	strftime (date_short, sizeof(date_short), "%Y%m%d", gtm);
+	strftime (date_iso, sizeof(date_iso), "%Y%m%dT%H%M%SZ", gtm);
+	uri_encoded = _aws_uriencode(uri);
+
+	if (op == DDIR_WRITE) {
+		dsha = _gen_hex_sha256(buf, len);
+		sprintf(method, "PUT");
+	} else {
+		/* DDIR_READ && DDIR_TRIM supply an empty body */
+		if (op == DDIR_READ)
+			sprintf(method, "GET");
+		else
+			sprintf(method, "DELETE");
+		dsha = _gen_hex_sha256("", 0);
+	}
+
+	/* Create the canonical request first */
+	snprintf(creq, sizeof(creq),
+	"%s\n"
+	"%s\n"
+	"\n"
+	"host:%s\n"
+	"x-amz-content-sha256:%s\n"
+	"x-amz-date:%s\n"
+	"\n"
+	"host;x-amz-content-sha256;x-amz-date\n"
+	"%s"
+	, method
+	, uri_encoded, o->host, dsha, date_iso, dsha);
+
+	csha = _gen_hex_sha256(creq, strlen(creq));
+	snprintf(sts, sizeof(sts), "AWS4-HMAC-SHA256\n%s\n%s/%s/%s/%s\n%s",
+		date_iso, date_short, o->s3_region, service, aws, csha);
+
+	snprintf((char *)dkey, sizeof(dkey), "AWS4%s", o->s3_key);
+	_hmac(md, dkey, strlen(dkey), date_short);
+	_hmac(md, md, SHA256_DIGEST_LENGTH, o->s3_region);
+	_hmac(md, md, SHA256_DIGEST_LENGTH, (char*) service);
+	_hmac(md, md, SHA256_DIGEST_LENGTH, (char*) aws);
+	_hmac(md, md, SHA256_DIGEST_LENGTH, sts);
+
+	signature = _conv_hex(md, SHA256_DIGEST_LENGTH);
+
+	/* Surpress automatic Accept: header */
+	slist = curl_slist_append(slist, "Accept:");
+
+	snprintf(s, sizeof(s), "x-amz-content-sha256: %s", dsha);
+	slist = curl_slist_append(slist, s);
+
+	snprintf(s, sizeof(s), "x-amz-date: %s", date_iso);
+	slist = curl_slist_append(slist, s);
+
+	snprintf(s, sizeof(s), "Authorization: AWS4-HMAC-SHA256 Credential=%s/%s/%s/s3/aws4_request,"
+	"SignedHeaders=host;x-amz-content-sha256;x-amz-date,Signature=%s",
+	o->s3_keyid, date_short, o->s3_region, signature);
+	slist = curl_slist_append(slist, s);
+
+	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, slist);
+
+	free(uri_encoded);
+	free(csha);
+	free(dsha);
+	free(signature);
+}
+
+static void fio_http_cleanup(struct thread_data *td)
+{
+	struct http_data *http = td->io_ops_data;
+
+	if (http) {
+		curl_easy_cleanup(http->curl);
+		free(http);
+	}
+}
+
+static size_t _http_read(void *ptr, size_t size, size_t nmemb, void *stream)
+{
+	struct http_curl_stream *state = stream;
+	size_t len = size * nmemb;
+	/* We're retrieving; nothing is supposed to be read locally */
+	if (!stream)
+		return 0;
+	if (len+state->pos > state->max)
+		len = state->max - state->pos;
+	memcpy(ptr, &state->buf[state->pos], len);
+	state->pos += len;
+	return len;
+}
+
+static size_t _http_write(void *ptr, size_t size, size_t nmemb, void *stream)
+{
+	struct http_curl_stream *state = stream;
+	/* We're just discarding the returned body after a PUT */
+	if (!stream)
+		return nmemb;
+	if (size != 1)
+		return CURLE_WRITE_ERROR;
+	if (nmemb + state->pos > state->max)
+		return CURLE_WRITE_ERROR;
+	memcpy(&state->buf[state->pos], ptr, nmemb);
+	state->pos += nmemb;
+	return nmemb;
+}
+
+static int _http_seek(void *stream, curl_off_t offset, int origin)
+{
+	struct http_curl_stream *state = stream;
+	if (offset < state->max && origin == SEEK_SET) {
+		state->pos = offset;
+		return CURL_SEEKFUNC_OK;
+	} else
+		return CURL_SEEKFUNC_FAIL;
+}
+
+static enum fio_q_status fio_http_queue(struct thread_data *td,
+					 struct io_u *io_u)
+{
+	struct http_data *http = td->io_ops_data;
+	struct http_options *o = td->eo;
+	struct http_curl_stream _curl_stream;
+	struct curl_slist *slist = NULL;
+	char object[512];
+	char url[1024];
+	long status;
+	CURLcode res;
+	int r = -1;
+
+	fio_ro_check(td, io_u);
+	memset(&_curl_stream, 0, sizeof(_curl_stream));
+	snprintf(object, sizeof(object), "%s_%llu_%llu", td->files[0]->file_name, io_u->offset, io_u->xfer_buflen);
+	snprintf(url, sizeof(url), "%s://%s%s", o->https ? "https" : "http", o->host, object);
+	curl_easy_setopt(http->curl, CURLOPT_URL, url);
+	_curl_stream.buf = io_u->xfer_buf;
+	_curl_stream.max = io_u->xfer_buflen;
+	curl_easy_setopt(http->curl, CURLOPT_SEEKDATA, &_curl_stream);
+	curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, (curl_off_t)io_u->xfer_buflen);
+
+	if (o->s3)
+		_add_aws_auth_header(http->curl, slist, o, io_u->ddir, object,
+			io_u->xfer_buf, io_u->xfer_buflen);
+
+	if (io_u->ddir == DDIR_WRITE) {
+		curl_easy_setopt(http->curl, CURLOPT_READDATA, &_curl_stream);
+		curl_easy_setopt(http->curl, CURLOPT_WRITEDATA, NULL);
+		curl_easy_setopt(http->curl, CURLOPT_UPLOAD, 1L);
+		res = curl_easy_perform(http->curl);
+		if (res == CURLE_OK) {
+			curl_easy_getinfo(http->curl, CURLINFO_RESPONSE_CODE, &status);
+			if (status == 100 || (status >= 200 && status <= 204))
+				goto out;
+			log_err("DDIR_WRITE failed with HTTP status code %ld\n", status);
+			goto err;
+		}
+	} else if (io_u->ddir == DDIR_READ) {
+		curl_easy_setopt(http->curl, CURLOPT_READDATA, NULL);
+		curl_easy_setopt(http->curl, CURLOPT_WRITEDATA, &_curl_stream);
+		curl_easy_setopt(http->curl, CURLOPT_HTTPGET, 1L);
+		res = curl_easy_perform(http->curl);
+		if (res == CURLE_OK) {
+			curl_easy_getinfo(http->curl, CURLINFO_RESPONSE_CODE, &status);
+			if (status == 200)
+				goto out;
+			else if (status == 404) {
+				/* Object doesn't exist. Pretend we read
+				 * zeroes */
+				memset(io_u->xfer_buf, 0, io_u->xfer_buflen);
+				goto out;
+			}
+			log_err("DDIR_READ failed with HTTP status code %ld\n", status);
+		}
+		goto err;
+	} else if (io_u->ddir == DDIR_TRIM) {
+		curl_easy_setopt(http->curl, CURLOPT_HTTPGET, 1L);
+		curl_easy_setopt(http->curl, CURLOPT_CUSTOMREQUEST, "DELETE");
+		curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, 0);
+		curl_easy_setopt(http->curl, CURLOPT_READDATA, NULL);
+		curl_easy_setopt(http->curl, CURLOPT_WRITEDATA, NULL);
+		res = curl_easy_perform(http->curl);
+		if (res == CURLE_OK) {
+			curl_easy_getinfo(http->curl, CURLINFO_RESPONSE_CODE, &status);
+			if (status == 200 || status == 202 || status == 204 || status == 404)
+				goto out;
+			log_err("DDIR_TRIM failed with HTTP status code %ld\n", status);
+		}
+		goto err;
+	}
+
+	log_err("WARNING: Only DDIR_READ/DDIR_WRITE/DDIR_TRIM are supported!\n");
+
+err:
+	io_u->error = r;
+	td_verror(td, io_u->error, "transfer");
+out:
+	curl_slist_free_all(slist);
+	return FIO_Q_COMPLETED;
+}
+
+static struct io_u *fio_http_event(struct thread_data *td, int event)
+{
+	/* sync IO engine - never any outstanding events */
+	return NULL;
+}
+
+int fio_http_getevents(struct thread_data *td, unsigned int min,
+	unsigned int max, const struct timespec *t)
+{
+	/* sync IO engine - never any outstanding events */
+	return 0;
+}
+
+static int fio_http_setup(struct thread_data *td)
+{
+	struct http_data *http = NULL;
+	struct http_options *o = td->eo;
+	int r;
+	/* allocate engine specific structure to deal with libhttp. */
+	http = calloc(1, sizeof(*http));
+	if (!http) {
+		log_err("calloc failed.\n");
+		goto cleanup;
+	}
+
+	http->curl = curl_easy_init();
+	if (o->verbose)
+		curl_easy_setopt(http->curl, CURLOPT_VERBOSE, 1L);
+	if (o->verbose > 1)
+		curl_easy_setopt(http->curl, CURLOPT_DEBUGFUNCTION, &_curl_trace);
+	curl_easy_setopt(http->curl, CURLOPT_NOPROGRESS, 1L);
+	curl_easy_setopt(http->curl, CURLOPT_FOLLOWLOCATION, 1L);
+	curl_easy_setopt(http->curl, CURLOPT_PROTOCOLS, CURLPROTO_HTTP|CURLPROTO_HTTPS);
+	curl_easy_setopt(http->curl, CURLOPT_READFUNCTION, _http_read);
+	curl_easy_setopt(http->curl, CURLOPT_WRITEFUNCTION, _http_write);
+	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, _http_seek);
+	if (o->user && o->pass) {
+		curl_easy_setopt(http->curl, CURLOPT_USERNAME, o->user);
+		curl_easy_setopt(http->curl, CURLOPT_PASSWORD, o->pass);
+		curl_easy_setopt(http->curl, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
+	}
+
+	td->io_ops_data = http;
+
+	/* Force single process mode. */
+	td->o.use_thread = 1;
+
+	return 0;
+cleanup:
+	fio_http_cleanup(td);
+	return r;
+}
+
+static int fio_http_open(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+static int fio_http_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name = "http",
+	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_DISKLESSIO,
+	.setup			= fio_http_setup,
+	.queue			= fio_http_queue,
+	.getevents		= fio_http_getevents,
+	.event			= fio_http_event,
+	.cleanup		= fio_http_cleanup,
+	.open_file		= fio_http_open,
+	.invalidate		= fio_http_invalidate,
+	.options		= options,
+	.option_struct_size	= sizeof(struct http_options),
+};
+
+static void fio_init fio_http_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_http_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/http-s3.fio b/examples/http-s3.fio
new file mode 100644
index 0000000..a9805da
--- /dev/null
+++ b/examples/http-s3.fio
@@ -0,0 +1,34 @@
+# Example test for the HTTP engine's S3 support against Amazon AWS.
+# Obviously, you have to adjust the S3 credentials; for this example,
+# they're passed in via the environment.
+#
+
+[global]
+ioengine=http
+name=test
+direct=1
+filename=/larsmb-fio-test/object
+http_verbose=0
+https=1
+http_s3=1
+http_s3_key=${S3_KEY}
+http_s3_keyid=${S3_ID}
+http_host=s3.eu-central-1.amazonaws.com
+http_s3_region=eu-central-1
+group_reporting
+
+# With verify, this both writes and reads the object
+[create]
+rw=write
+bs=4k
+size=64k
+io_size=4k
+verify=sha256
+
+[trim]
+stonewall
+rw=trim
+bs=4k
+size=64k
+io_size=4k
+
diff --git a/examples/http-webdav.fio b/examples/http-webdav.fio
new file mode 100644
index 0000000..c0624f8
--- /dev/null
+++ b/examples/http-webdav.fio
@@ -0,0 +1,26 @@
+[global]
+ioengine=http
+rw=randwrite
+name=test
+direct=1
+http_verbose=0
+http_s3=0
+https=0
+http_host=localhost
+filename_format=/dav/bucket.$jobnum
+group_reporting
+bs=64k
+size=1M
+
+[create]
+numjobs=16
+rw=randwrite
+io_size=10M
+verify=sha256
+
+# This will delete all created objects again
+[trim]
+stonewall
+numjobs=16
+rw=trim
+io_size=1M
diff --git a/fio.1 b/fio.1
index 18bf6a2..883a31b 100644
--- a/fio.1
+++ b/fio.1
@@ -1608,6 +1608,15 @@ I/O engine supporting direct access to Ceph Rados Block Devices
 (RBD) via librbd without the need to use the kernel rbd driver. This
 ioengine defines engine specific options.
 .TP
+.B http
+I/O engine supporting GET/PUT requests over HTTP(S) with libcurl to
+a WebDAV or S3 endpoint.  This ioengine defines engine specific options.
+
+This engine only supports direct IO of iodepth=1; you need to scale this
+via numjobs. blocksize defines the size of the objects to be created.
+
+TRIM is translated to object deletion.
+.TP
 .B gfapi
 Using GlusterFS libgfapi sync interface to direct access to
 GlusterFS volumes without having to go through FUSE. This ioengine
@@ -1810,6 +1819,37 @@ by default.
 Poll store instead of waiting for completion. Usually this provides better
 throughput at cost of higher(up to 100%) CPU utilization.
 .TP
+.BI (http)http_host \fR=\fPstr
+Hostname to connect to. For S3, this could be the bucket name. Default
+is \fBlocalhost\fR
+.TP
+.BI (http)http_user \fR=\fPstr
+Username for HTTP authentication.
+.TP
+.BI (http)http_pass \fR=\fPstr
+Password for HTTP authentication.
+.TP
+.BI (http)https \fR=\fPbool
+Whether to use HTTPS instead of plain HTTP. Default is \fB0\fR.
+.TP
+.BI (http)http_s3 \fR=\fPbool
+Include S3 specific HTTP headers such as authenticating requests with
+AWS Signature Version 4. Default is \fB0\fR.
+.TP
+.BI (http)http_s3_region \fR=\fPstr
+The S3 region/zone to include in the request. Default is \fBus-east-1\fR.
+.TP
+.BI (http)http_s3_key \fR=\fPstr
+The S3 secret key.
+.TP
+.BI (http)http_s3_keyid \fR=\fPstr
+The S3 key/access id.
+.TP
+.BI (http)http_verbose \fR=\fPint
+Enable verbose requests from libcurl. Useful for debugging. 1 turns on
+verbose logging from libcurl, 2 additionally enables HTTP IO tracing.
+Default is \fB0\fR
+.TP
 .BI (mtd)skip_bad \fR=\fPbool
 Skip operations against known bad blocks.
 .TP
diff --git a/optgroup.h b/optgroup.h
index d5e968d..adf4d09 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -56,6 +56,7 @@ enum opt_category_group {
 	__FIO_OPT_G_ACT,
 	__FIO_OPT_G_LATPROF,
 	__FIO_OPT_G_RBD,
+	__FIO_OPT_G_HTTP,
 	__FIO_OPT_G_GFAPI,
 	__FIO_OPT_G_MTD,
 	__FIO_OPT_G_HDFS,
@@ -91,6 +92,7 @@ enum opt_category_group {
 	FIO_OPT_G_ACT		= (1ULL << __FIO_OPT_G_ACT),
 	FIO_OPT_G_LATPROF	= (1ULL << __FIO_OPT_G_LATPROF),
 	FIO_OPT_G_RBD		= (1ULL << __FIO_OPT_G_RBD),
+	FIO_OPT_G_HTTP		= (1ULL << __FIO_OPT_G_HTTP),
 	FIO_OPT_G_GFAPI		= (1ULL << __FIO_OPT_G_GFAPI),
 	FIO_OPT_G_MTD		= (1ULL << __FIO_OPT_G_MTD),
 	FIO_OPT_G_HDFS		= (1ULL << __FIO_OPT_G_HDFS),
diff --git a/options.c b/options.c
index e53b717..9ee1ba3 100644
--- a/options.c
+++ b/options.c
@@ -1863,6 +1863,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "PMDK libpmem based IO engine",
 			  },
 #endif
+#ifdef CONFIG_HTTP
+			  { .ival = "http",
+			    .help = "HTTP (WebDAV/S3) IO engine",
+			  },
+#endif
 		},
 	},
 	{

