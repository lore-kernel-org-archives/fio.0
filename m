Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46998 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeHQPDf (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Aug 2018 11:03:35 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fqdQU-0001AS-AY
        for fio@vger.kernel.org; Fri, 17 Aug 2018 12:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180817120001.F413B2C2FEA@kernel.dk>
Date: Fri, 17 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 35e2d88fad2151f272af60babb5e6c98922d0bcd:

  Fix compilation on centos 7 (2018-08-15 12:06:14 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9ee669faa39003c2317e5df892314bcfcee069e3:

  configure: avoid pkg-config usage for http engine (2018-08-16 18:58:27 +0200)

----------------------------------------------------------------
David Disseldorp (3):
      configure: use pkg-config to detect libcurl & openssl
      engines/http: support openssl < 1.1.0
      configure: avoid pkg-config usage for http engine

Jens Axboe (3):
      Merge branch 'http_older_openssl' of https://github.com/ddiss/fio
      engines/http: fix use of uninitialized variable
      Merge branch 'wip-http-swift' of https://github.com/l-mb/fio

Lars Marowsky-Bree (1):
      engines/http: Add support for Swift storage backend

 HOWTO                    |  17 ++++--
 configure                |  35 ++++++++++--
 engines/http.c           | 135 +++++++++++++++++++++++++++++++++++++++++------
 examples/http-s3.fio     |   4 +-
 examples/http-swift.fio  |  32 +++++++++++
 examples/http-webdav.fio |   4 +-
 fio.1                    |  16 ++++--
 7 files changed, 209 insertions(+), 34 deletions(-)
 create mode 100644 examples/http-swift.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index c77dad1..743144f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2137,14 +2137,16 @@ with the caveat that when used on the command line, they must come after the
 
 	Password for HTTP authentication.
 
-.. option:: https=bool : [http]
+.. option:: https=str : [http]
 
-	Enable HTTPS instead of http. Default is **0**
+	Enable HTTPS instead of http. *on* enables HTTPS; *insecure*
+	will enable HTTPS, but disable SSL peer verification (use with
+	caution!). Default is **off**
 
-.. option:: http_s3=bool : [http]
+.. option:: http_mode=str : [http]
 
-	Enable S3 specific HTTP headers such as authenticating requests
-	with AWS Signature Version 4. Default is **0**
+	Which HTTP access mode to use: *webdav*, *swift*, or *s3*.
+	Default is **webdav**
 
 .. option:: http_s3_region=str : [http]
 
@@ -2159,6 +2161,11 @@ with the caveat that when used on the command line, they must come after the
 
 	The S3 key/access id.
 
+.. option:: http_swift_auth_token=str : [http]
+
+	The Swift auth token. See the example configuration file on how
+	to retrieve this.
+
 .. option:: http_verbose=int : [http]
 
 	Enable verbose requests from libcurl. Useful for debugging. 1
diff --git a/configure b/configure
index 103ea94..a03f7fa 100755
--- a/configure
+++ b/configure
@@ -14,12 +14,13 @@ else
 fi
 
 TMPC="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.c"
+TMPC2="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}-2.c"
 TMPO="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.o"
 TMPE="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.exe"
 
 # NB: do not call "exit" in the trap handler; this is buggy with some shells;
 # see <1285349658-3122-1-git-send-email-loic.minier@linaro.org>
-trap "rm -f $TMPC $TMPO $TMPE" EXIT INT QUIT TERM
+trap "rm -f $TMPC $TMPC2 $TMPO $TMPE" EXIT INT QUIT TERM
 
 rm -rf config.log
 
@@ -1573,6 +1574,7 @@ print_config "IPv6 helpers" "$ipv6"
 if test "$http" != "yes" ; then
   http="no"
 fi
+# check for openssl >= 1.1.0, which uses an opaque HMAC_CTX pointer
 cat > $TMPC << EOF
 #include <curl/curl.h>
 #include <openssl/hmac.h>
@@ -1591,9 +1593,34 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if test "$disable_http" != "yes"  && compile_prog "" "-lcurl -lssl -lcrypto" "curl"; then
-  LIBS="-lcurl -lssl -lcrypto $LIBS"
-  http="yes"
+# openssl < 1.1.0 uses the HMAC_CTX type directly
+cat > $TMPC2 << EOF
+#include <curl/curl.h>
+#include <openssl/hmac.h>
+
+int main(int argc, char **argv)
+{
+  CURL *curl;
+  HMAC_CTX ctx;
+
+  curl = curl_easy_init();
+  curl_easy_cleanup(curl);
+
+  HMAC_CTX_init(&ctx);
+  HMAC_CTX_cleanup(&ctx);
+  return 0;
+}
+EOF
+if test "$disable_http" != "yes"; then
+  HTTP_LIBS="-lcurl -lssl -lcrypto"
+  if compile_prog "" "$HTTP_LIBS" "curl-new-ssl"; then
+    output_sym "CONFIG_HAVE_OPAQUE_HMAC_CTX"
+    http="yes"
+    LIBS="$HTTP_LIBS $LIBS"
+  elif mv $TMPC2 $TMPC && compile_prog "" "$HTTP_LIBS" "curl-old-ssl"; then
+    http="yes"
+    LIBS="$HTTP_LIBS $LIBS"
+  fi
 fi
 print_config "http engine" "$http"
 
diff --git a/engines/http.c b/engines/http.c
index d3fdba8..cb66ebe 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -25,25 +25,37 @@
 #include <curl/curl.h>
 #include <openssl/hmac.h>
 #include <openssl/sha.h>
+#include <openssl/md5.h>
 #include "fio.h"
 #include "../optgroup.h"
 
 
+enum {
+	FIO_HTTP_WEBDAV	    = 0,
+	FIO_HTTP_S3	    = 1,
+	FIO_HTTP_SWIFT	    = 2,
+
+	FIO_HTTPS_OFF	    = 0,
+	FIO_HTTPS_ON	    = 1,
+	FIO_HTTPS_INSECURE  = 2,
+};
+
 struct http_data {
 	CURL *curl;
 };
 
 struct http_options {
 	void *pad;
-	int  https;
+	unsigned int https;
 	char *host;
 	char *user;
 	char *pass;
 	char *s3_key;
 	char *s3_keyid;
 	char *s3_region;
+	char *swift_auth_token;
 	int verbose;
-	int s3;
+	unsigned int mode;
 };
 
 struct http_curl_stream {
@@ -56,10 +68,24 @@ static struct fio_option options[] = {
 	{
 		.name     = "https",
 		.lname    = "https",
-		.type     = FIO_OPT_BOOL,
+		.type     = FIO_OPT_STR,
 		.help     = "Enable https",
 		.off1     = offsetof(struct http_options, https),
-		.def      = "0",
+		.def      = "off",
+		.posval = {
+			  { .ival = "off",
+			    .oval = FIO_HTTPS_OFF,
+			    .help = "No HTTPS",
+			  },
+			  { .ival = "on",
+			    .oval = FIO_HTTPS_ON,
+			    .help = "Enable HTTPS",
+			  },
+			  { .ival = "insecure",
+			    .oval = FIO_HTTPS_INSECURE,
+			    .help = "Enable HTTPS, disable peer verification",
+			  },
+		},
 		.category = FIO_OPT_C_ENGINE,
 		.group    = FIO_OPT_G_HTTP,
 	},
@@ -112,6 +138,16 @@ static struct fio_option options[] = {
 		.group    = FIO_OPT_G_HTTP,
 	},
 	{
+		.name     = "http_swift_auth_token",
+		.lname    = "Swift auth token",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "OpenStack Swift auth token",
+		.off1     = offsetof(struct http_options, swift_auth_token),
+		.def	  = "",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
 		.name     = "http_s3_region",
 		.lname    = "S3 region",
 		.type     = FIO_OPT_STR_STORE,
@@ -122,18 +158,32 @@ static struct fio_option options[] = {
 		.group    = FIO_OPT_G_HTTP,
 	},
 	{
-		.name     = "http_s3",
-		.lname    = "S3 extensions",
-		.type     = FIO_OPT_BOOL,
-		.help     = "Whether to enable S3 specific headers",
-		.off1     = offsetof(struct http_options, s3),
-		.def	  = "0",
+		.name     = "http_mode",
+		.lname    = "Request mode to use",
+		.type     = FIO_OPT_STR,
+		.help     = "Whether to use WebDAV, Swift, or S3",
+		.off1     = offsetof(struct http_options, mode),
+		.def	  = "webdav",
+		.posval = {
+			  { .ival = "webdav",
+			    .oval = FIO_HTTP_WEBDAV,
+			    .help = "WebDAV server",
+			  },
+			  { .ival = "s3",
+			    .oval = FIO_HTTP_S3,
+			    .help = "S3 storage backend",
+			  },
+			  { .ival = "swift",
+			    .oval = FIO_HTTP_SWIFT,
+			    .help = "OpenStack Swift storage",
+			  },
+		},
 		.category = FIO_OPT_C_ENGINE,
 		.group    = FIO_OPT_G_HTTP,
 	},
 	{
 		.name     = "http_verbose",
-		.lname    = "CURL verbosity",
+		.lname    = "HTTP verbosity level",
 		.type     = FIO_OPT_INT,
 		.help     = "increase http engine verbosity",
 		.off1     = offsetof(struct http_options, verbose),
@@ -204,15 +254,34 @@ static char *_gen_hex_sha256(const char *p, size_t len)
 	return _conv_hex(hash, SHA256_DIGEST_LENGTH);
 }
 
+static char *_gen_hex_md5(const char *p, size_t len)
+{
+	unsigned char hash[MD5_DIGEST_LENGTH];
+
+	MD5((unsigned char*)p, len, hash);
+	return _conv_hex(hash, MD5_DIGEST_LENGTH);
+}
+
 static void _hmac(unsigned char *md, void *key, int key_len, char *data) {
+#ifndef CONFIG_HAVE_OPAQUE_HMAC_CTX
+	HMAC_CTX _ctx;
+#endif
 	HMAC_CTX *ctx;
 	unsigned int hmac_len;
 
+#ifdef CONFIG_HAVE_OPAQUE_HMAC_CTX
 	ctx = HMAC_CTX_new();
+#else
+	ctx = &_ctx;
+#endif
 	HMAC_Init_ex(ctx, key, key_len, EVP_sha256(), NULL);
 	HMAC_Update(ctx, (unsigned char*)data, strlen(data));
 	HMAC_Final(ctx, md, &hmac_len);
+#ifdef CONFIG_HAVE_OPAQUE_HMAC_CTX
 	HMAC_CTX_free(ctx);
+#else
+	HMAC_CTX_cleanup(ctx);
+#endif
 }
 
 static int _curl_trace(CURL *handle, curl_infotype type,
@@ -338,6 +407,29 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	free(signature);
 }
 
+static void _add_swift_header(CURL *curl, struct curl_slist *slist, struct http_options *o,
+		int op, const char *uri, char *buf, size_t len)
+{
+	char *dsha = NULL;
+	char s[512];
+
+	if (op == DDIR_WRITE) {
+		dsha = _gen_hex_md5(buf, len);
+	}
+	/* Surpress automatic Accept: header */
+	slist = curl_slist_append(slist, "Accept:");
+
+	snprintf(s, sizeof(s), "etag: %s", dsha);
+	slist = curl_slist_append(slist, s);
+
+	snprintf(s, sizeof(s), "x-auth-token: %s", o->swift_auth_token);
+	slist = curl_slist_append(slist, s);
+
+	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, slist);
+
+	free(dsha);
+}
+
 static void fio_http_cleanup(struct thread_data *td)
 {
 	struct http_data *http = td->io_ops_data;
@@ -402,17 +494,24 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 
 	fio_ro_check(td, io_u);
 	memset(&_curl_stream, 0, sizeof(_curl_stream));
-	snprintf(object, sizeof(object), "%s_%llu_%llu", td->files[0]->file_name, io_u->offset, io_u->xfer_buflen);
-	snprintf(url, sizeof(url), "%s://%s%s", o->https ? "https" : "http", o->host, object);
+	snprintf(object, sizeof(object), "%s_%llu_%llu", td->files[0]->file_name,
+		io_u->offset, io_u->xfer_buflen);
+	if (o->https == FIO_HTTPS_OFF)
+		snprintf(url, sizeof(url), "http://%s%s", o->host, object);
+	else
+		snprintf(url, sizeof(url), "https://%s%s", o->host, object);
 	curl_easy_setopt(http->curl, CURLOPT_URL, url);
 	_curl_stream.buf = io_u->xfer_buf;
 	_curl_stream.max = io_u->xfer_buflen;
 	curl_easy_setopt(http->curl, CURLOPT_SEEKDATA, &_curl_stream);
 	curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, (curl_off_t)io_u->xfer_buflen);
 
-	if (o->s3)
+	if (o->mode == FIO_HTTP_S3)
 		_add_aws_auth_header(http->curl, slist, o, io_u->ddir, object,
 			io_u->xfer_buf, io_u->xfer_buflen);
+	else if (o->mode == FIO_HTTP_SWIFT)
+		_add_swift_header(http->curl, slist, o, io_u->ddir, object,
+			io_u->xfer_buf, io_u->xfer_buflen);
 
 	if (io_u->ddir == DDIR_WRITE) {
 		curl_easy_setopt(http->curl, CURLOPT_READDATA, &_curl_stream);
@@ -487,7 +586,7 @@ static int fio_http_setup(struct thread_data *td)
 {
 	struct http_data *http = NULL;
 	struct http_options *o = td->eo;
-	int r;
+
 	/* allocate engine specific structure to deal with libhttp. */
 	http = calloc(1, sizeof(*http));
 	if (!http) {
@@ -503,6 +602,10 @@ static int fio_http_setup(struct thread_data *td)
 	curl_easy_setopt(http->curl, CURLOPT_NOPROGRESS, 1L);
 	curl_easy_setopt(http->curl, CURLOPT_FOLLOWLOCATION, 1L);
 	curl_easy_setopt(http->curl, CURLOPT_PROTOCOLS, CURLPROTO_HTTP|CURLPROTO_HTTPS);
+	if (o->https == FIO_HTTPS_INSECURE) {
+		curl_easy_setopt(http->curl, CURLOPT_SSL_VERIFYPEER, 0L);
+		curl_easy_setopt(http->curl, CURLOPT_SSL_VERIFYHOST, 0L);
+	}
 	curl_easy_setopt(http->curl, CURLOPT_READFUNCTION, _http_read);
 	curl_easy_setopt(http->curl, CURLOPT_WRITEFUNCTION, _http_write);
 	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, _http_seek);
@@ -520,7 +623,7 @@ static int fio_http_setup(struct thread_data *td)
 	return 0;
 cleanup:
 	fio_http_cleanup(td);
-	return r;
+	return 1;
 }
 
 static int fio_http_open(struct thread_data *td, struct fio_file *f)
diff --git a/examples/http-s3.fio b/examples/http-s3.fio
index a9805da..2dcae36 100644
--- a/examples/http-s3.fio
+++ b/examples/http-s3.fio
@@ -9,8 +9,8 @@ name=test
 direct=1
 filename=/larsmb-fio-test/object
 http_verbose=0
-https=1
-http_s3=1
+https=on
+http_mode=s3
 http_s3_key=${S3_KEY}
 http_s3_keyid=${S3_ID}
 http_host=s3.eu-central-1.amazonaws.com
diff --git a/examples/http-swift.fio b/examples/http-swift.fio
new file mode 100644
index 0000000..b591adb
--- /dev/null
+++ b/examples/http-swift.fio
@@ -0,0 +1,32 @@
+[global]
+ioengine=http
+rw=randwrite
+name=test
+direct=1
+http_verbose=0
+http_mode=swift
+https=on
+# This is the hostname and port portion of the public access link for
+# the container:
+http_host=swift.srv.openstack.local:8081
+filename_format=/swift/v1/fio-test/bucket.$jobnum
+group_reporting
+bs=64k
+size=1M
+# Currently, fio cannot yet generate the Swift Auth-Token itself.
+# You need to set this prior to running fio via
+# eval $(openstack token issue -f shell --prefix SWIFT_) ; export SWIFT_id
+http_swift_auth_token=${SWIFT_id}
+
+[create]
+numjobs=1
+rw=randwrite
+io_size=256k
+verify=sha256
+
+# This will delete all created objects again
+[trim]
+stonewall
+numjobs=1
+rw=trim
+io_size=64k
diff --git a/examples/http-webdav.fio b/examples/http-webdav.fio
index c0624f8..2d1ca73 100644
--- a/examples/http-webdav.fio
+++ b/examples/http-webdav.fio
@@ -4,8 +4,8 @@ rw=randwrite
 name=test
 direct=1
 http_verbose=0
-http_s3=0
-https=0
+http_mode=webdav
+https=off
 http_host=localhost
 filename_format=/dav/bucket.$jobnum
 group_reporting
diff --git a/fio.1 b/fio.1
index 883a31b..73a0422 100644
--- a/fio.1
+++ b/fio.1
@@ -1829,12 +1829,14 @@ Username for HTTP authentication.
 .BI (http)http_pass \fR=\fPstr
 Password for HTTP authentication.
 .TP
-.BI (http)https \fR=\fPbool
-Whether to use HTTPS instead of plain HTTP. Default is \fB0\fR.
+.BI (http)https \fR=\fPstr
+Whether to use HTTPS instead of plain HTTP. \fRon\fP enables HTTPS;
+\fRinsecure\fP will enable HTTPS, but disable SSL peer verification (use
+with caution!).  Default is \fBoff\fR.
 .TP
-.BI (http)http_s3 \fR=\fPbool
-Include S3 specific HTTP headers such as authenticating requests with
-AWS Signature Version 4. Default is \fB0\fR.
+.BI (http)http_mode \fR=\fPstr
+Which HTTP access mode to use: webdav, swift, or s3. Default is
+\fBwebdav\fR.
 .TP
 .BI (http)http_s3_region \fR=\fPstr
 The S3 region/zone to include in the request. Default is \fBus-east-1\fR.
@@ -1845,6 +1847,10 @@ The S3 secret key.
 .BI (http)http_s3_keyid \fR=\fPstr
 The S3 key/access id.
 .TP
+.BI (http)http_swift_auth_token \fR=\fPstr
+The Swift auth token. See the example configuration file on how to
+retrieve this.
+.TP
 .BI (http)http_verbose \fR=\fPint
 Enable verbose requests from libcurl. Useful for debugging. 1 turns on
 verbose logging from libcurl, 2 additionally enables HTTP IO tracing.

