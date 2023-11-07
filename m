Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE74182C8
	for <fio@vger.kernel.org>; Tue,  7 Nov 2023 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TSmXi7Ga"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B0CAF99
	for <fio@vger.kernel.org>; Tue,  7 Nov 2023 05:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Bid/7UWVuuj/9NIe8DdFLj0+jL9o0rR0eQLhf19Mcr8=; b=TSmXi7GaEHUxSUci0DCDfoSmv+
	thX8jVXXeSP0T6EuTVmYG2G7fZ8ukWMbUe/VHCnnPa0sslsIRYSVORig2+DJJPquO+/g9phi3jdI4
	STdAP0rGoUAc/YALmMBw/y3UvS1z7lD+vuzvH6QprErcjxK69/mbgsT/dKRn1IPUwxDsdBPqlgCrd
	ob1og5SLuDJEARYkO2VbR4jLneLCBgJaai9eCiz/qgxINODt60pYtK3rjR+DYAC/SCabchxu78sif
	a1SJQD8PRCIxRmX+u19zsWh34APtFNBV1CIl4uQw6Qo9GhG5ZgdJheKdKBDwf2MZwQFfC5xINo77r
	megi6Lfw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r0Lgj-00COSd-1Y
	for fio@vger.kernel.org; Tue, 07 Nov 2023 13:00:13 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id ECDBD1BC0145; Tue,  7 Nov 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231107130001.ECDBD1BC0145@kernel.dk>
Date: Tue,  7 Nov 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2c0b784a12172da1533dfd40b66a0e4e5609065f:

  Merge branch 'thinkcycles-parameter' of https://github.com/cloehle/fio (2023-11-03 11:21:22 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 05fce19c7d2668adb38243636a1781c0f8fae523:

  docs: add warning to per_job_logs option (2023-11-06 13:46:30 -0500)

----------------------------------------------------------------
Vincent Fu (2):
      client/server: enable per_job_logs option
      docs: add warning to per_job_logs option

 HOWTO.rst |  8 +++++---
 client.c  | 18 ++++++++++++++----
 fio.1     |  6 ++++--
 server.c  |  1 +
 server.h  |  3 ++-
 5 files changed, 26 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 42b2b119..d173702b 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3968,9 +3968,11 @@ Measurements and reporting
 
 .. option:: per_job_logs=bool
 
-	If set, this generates bw/clat/iops log with per file private filenames. If
-	not set, jobs with identical names will share the log filename. Default:
-	true.
+        If set to true, fio generates bw/clat/iops logs with per job unique
+        filenames. If set to false, jobs with identical names will share a log
+        filename. Note that when this option is set to false log files will be
+        opened in append mode and if log files already exist the previous
+        contents will not be overwritten. Default: true.
 
 .. option:: group_reporting
 
diff --git a/client.c b/client.c
index 345fa910..699a2e5b 100644
--- a/client.c
+++ b/client.c
@@ -1452,10 +1452,13 @@ static int fio_client_handle_iolog(struct fio_client *client,
 	if (store_direct) {
 		ssize_t wrote;
 		size_t sz;
-		int fd;
+		int fd, flags;
 
-		fd = open((const char *) log_pathname,
-				O_WRONLY | O_CREAT | O_TRUNC, 0644);
+		if (pdu->per_job_logs)
+			flags = O_WRONLY | O_CREAT | O_TRUNC;
+		else
+			flags = O_WRONLY | O_CREAT | O_APPEND;
+		fd = open((const char *) log_pathname, flags, 0644);
 		if (fd < 0) {
 			log_err("fio: open log %s: %s\n",
 				log_pathname, strerror(errno));
@@ -1476,7 +1479,13 @@ static int fio_client_handle_iolog(struct fio_client *client,
 		ret = 0;
 	} else {
 		FILE *f;
-		f = fopen((const char *) log_pathname, "w");
+		const char *mode;
+
+		if (pdu->per_job_logs)
+			mode = "w";
+		else
+			mode = "a";
+		f = fopen((const char *) log_pathname, mode);
 		if (!f) {
 			log_err("fio: fopen log %s : %s\n",
 				log_pathname, strerror(errno));
@@ -1695,6 +1704,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 	ret->log_offset		= le32_to_cpu(ret->log_offset);
 	ret->log_prio		= le32_to_cpu(ret->log_prio);
 	ret->log_hist_coarseness = le32_to_cpu(ret->log_hist_coarseness);
+	ret->per_job_logs	= le32_to_cpu(ret->per_job_logs);
 
 	if (*store_direct)
 		return ret;
diff --git a/fio.1 b/fio.1
index d62da688..8f659f1d 100644
--- a/fio.1
+++ b/fio.1
@@ -3667,8 +3667,10 @@ interpreted in seconds.
 .SS "Measurements and reporting"
 .TP
 .BI per_job_logs \fR=\fPbool
-If set, this generates bw/clat/iops log with per file private filenames. If
-not set, jobs with identical names will share the log filename. Default:
+If set to true, fio generates bw/clat/iops logs with per job unique filenames.
+If set to false, jobs with identical names will share a log filename. Note that
+when this option is set to false log files will be opened in append mode and if
+log files already exist the previous contents will not be overwritten. Default:
 true.
 .TP
 .BI group_reporting
diff --git a/server.c b/server.c
index 27332e32..06eac584 100644
--- a/server.c
+++ b/server.c
@@ -2260,6 +2260,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 		.thread_number		= cpu_to_le32(td->thread_number),
 		.log_type		= cpu_to_le32(log->log_type),
 		.log_hist_coarseness	= cpu_to_le32(log->hist_coarseness),
+		.per_job_logs		= cpu_to_le32(td->o.per_job_logs),
 	};
 	struct sk_entry *first;
 	struct flist_head *entry;
diff --git a/server.h b/server.h
index ad706118..0eb594ce 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 101,
+	FIO_SERVER_VER			= 102,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -198,6 +198,7 @@ struct cmd_iolog_pdu {
 	uint32_t log_offset;
 	uint32_t log_prio;
 	uint32_t log_hist_coarseness;
+	uint32_t per_job_logs;
 	uint8_t name[FIO_NET_NAME_MAX];
 	struct io_sample samples[0];
 };
