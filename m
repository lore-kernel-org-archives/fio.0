Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaHWMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Aug 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XL9zJ-00066Y-Nv
	for fio@vger.kernel.org; Sat, 23 Aug 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140823120003.AA26740203@lyth.info>
Date: Sat, 23 Aug 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 35af10e11a470a33fe8e9d839bd15b86d97ec1f6:

  Update io engine version (2014-08-19 15:16:29 -0500)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9a4424c81b146b9a08b105af9e53d8435e888cd1:

  Fix crash in client with NULL hostname (2014-08-22 17:16:44 -0500)

----------------------------------------------------------------
Castor Fu (1):
      Fix crash in client with NULL hostname

Jens Axboe (2):
      options: warn if we fail to make sense of buffer_pattern
      Add string support for buffer_pattern

 HOWTO     |    2 ++
 client.c  |    6 ++++--
 fio.1     |    3 ++-
 options.c |   33 ++++++++++++++++++++++++++++++---
 4 files changed, 38 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a0b89c8..73e58ff 100644
--- a/HOWTO
+++ b/HOWTO
@@ -569,6 +569,8 @@ buffer_pattern=str	If set, fio will fill the io buffers with this pattern.
 		If not set, the contents of io buffers is defined by the other
 		options related to buffer contents. The setting can be any
 		pattern of bytes, and can be prefixed with 0x for hex values.
+		It may also be a string, where the string must then be
+		wrapped with "".
 
 nrfiles=int	Number of files to use for this job. Defaults to 1.
 
diff --git a/client.c b/client.c
index 1f52734..1dded09 100644
--- a/client.c
+++ b/client.c
@@ -823,9 +823,11 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 }
 
 static void json_object_add_client_info(struct json_object *obj,
-struct fio_client *client)
+					struct fio_client *client)
 {
-	json_object_add_value_string(obj, "hostname", client->hostname);
+	const char *hostname = client->hostname ? client->hostname : "";
+
+	json_object_add_value_string(obj, "hostname", hostname);
 	json_object_add_value_int(obj, "port", client->port);
 }
 
diff --git a/fio.1 b/fio.1
index c61948b..e3334bd 100644
--- a/fio.1
+++ b/fio.1
@@ -478,7 +478,8 @@ size, fio can alternate random and zeroed data throughout the IO buffer.
 If set, fio will fill the IO buffers with this pattern. If not set, the contents
 of IO buffers is defined by the other options related to buffer contents. The
 setting can be any pattern of bytes, and can be prefixed with 0x for hex
-values.
+values. It may also be a string, where the string must then be wrapped with
+"".
 .TP
 .BI nrfiles \fR=\fPint
 Number of files to use for this job.  Default: 1.
diff --git a/options.c b/options.c
index 3acfdc8..bc07885 100644
--- a/options.c
+++ b/options.c
@@ -930,6 +930,29 @@ static int pattern_cb(char *pattern, unsigned int max_size,
 	uint32_t pattern_length;
 	char *loc1, *loc2;
 
+	/*
+	 * Check if it's a string input
+	 */
+	loc1 = strchr(input, '\"');
+	if (loc1) {
+		do {
+			loc1++;
+			if (*loc1 == '\0' || *loc1 == '\"')
+				break;
+
+			pattern[i] = *loc1;
+			i++;
+		} while (i < max_size);
+
+		if (!i)
+			return 1;
+
+		goto fill;
+	}
+
+	/*
+	 * No string, find out if it's decimal or hexidecimal
+	 */
 	loc1 = strstr(input, "0x");
 	loc2 = strstr(input, "0X");
 	if (loc1 || loc2)
@@ -966,6 +989,7 @@ static int pattern_cb(char *pattern, unsigned int max_size,
 	 * Fill the pattern all the way to the end. This greatly reduces
 	 * the number of memcpy's we have to do when verifying the IO.
 	 */
+fill:
 	pattern_length = i;
 	while (i > 1 && i * 2 <= max_size) {
 		memcpy(&pattern[i], &pattern[0], i);
@@ -985,8 +1009,8 @@ static int pattern_cb(char *pattern, unsigned int max_size,
 
 	if (i == 1) {
 		/*
-		 * The code in verify_io_u_pattern assumes a single byte pattern
-		 * fills the whole verify pattern buffer.
+		 * The code in verify_io_u_pattern assumes a single byte
+		 * pattern fills the whole verify pattern buffer.
 		 */
 		memset(pattern, pattern[0], max_size);
 	}
@@ -1003,10 +1027,13 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 	ret = pattern_cb(td->o.buffer_pattern, MAX_PATTERN_SIZE, input,
 				&td->o.buffer_pattern_bytes);
 
-	if (!ret) {
+	if (!ret && td->o.buffer_pattern_bytes) {
 		td->o.refill_buffers = 0;
 		td->o.scramble_buffers = 0;
 		td->o.zero_buffers = 0;
+	} else {
+		log_err("fio: failed parsing pattern `%s`\n", input);
+		ret = 1;
 	}
 
 	return ret;
