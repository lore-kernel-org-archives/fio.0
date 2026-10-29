Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275210;
	b=h+cvWpKY9Rwn64EgB3165CQzU8dtjqWPttAbqKlNCu2pCVlyrQi8ikzgiWW6cQHYQ56S
	 yivO208gzco/a+Gw8yDD2hTrXTai6er224R9/384gCaw6h2VR8rJGmG0jUWNYVJ4D5nX2
	 EMXdkkWtw23cFBjDsWdg3jdeRS29i6ajadYIwu+dF85TYIJxps2sSTfj4pJGKD42ipgH6
	 wA6EN/uQbXnxF3krmHUmPGu1Xsb+8cGiF4WsI0ebRsIL1tivlxl8Oun07gAUeOfzD0AwP
	 aR3mApBg5Og4fNxZOnvjP5ZO2DilvCcoIKmFyKgc8PNWkAmx8BE8pxyBNYvYgworvnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275210;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=cGLFIOj4hc/uWoAw/Lk7q+gewvCnyUnDIUL8Z8PE76A=;
	b=rWE68zYa3T9KwV5zLT6NaC0VDE0twDYtkuIrT+dbuTDmzX6D8BJ2YD5pUUzJHMd6ptB9
	 l1EQF7K4V8SJN4QutzWd3qKQuPsQ6WzrW6egPuH96eqndrnkNnmBiywXDSHQsepMg+Kax
	 l47MSJakH5U6/6L5dDJqHgQcntRM2hzoJ8Fhox88Xur2+6zC6C63tU19NvzDsMIOhECxm
	 ldaC7pG9qD+ia1nwbzeck0TI5S6DcYIg15Yg4O/AVVGLsuaWV599aq6a9yyV0cdT6QopG
	 hvrhZDyIMPIgss8nwZZgpGLY8qhfjR0hSk7Son+2E7zM1P7JTj5/Tckm6Gl/JOTjb3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=RZVeUrYM;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4FC606A31D
	for <fio@vger.kernel.org>; Thu, 29 Oct 2026 12:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A4FC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=RZVeUrYM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=cGLFIOj4hc/uWoAw/Lk7q+gewvCnyUnDIUL8Z8PE76A=; b=RZVeUrYMNBdA/L/aaI2iVPUJ1v
	FkML/xTleTEHUJBK6xwo0mCMnYOjkLYPRXpRkrynUwhksIqjOsFlYm/22VvVPpcxD3O8futS82dVV
	ZmHvBmqe/by/daFpAzh3PrRjjZ6pITTCkiV8MWcEiYrDMZjKrhPCCz4jz6DAujfY2AV3mhx7e3+zz
	Yt6wuOJkumBdMF9tcKH4Ra+OKcdP+kdms5PJ6+7wAjgrpjVszbwTQtpIJk8m3iacAyANj6KpNZFv2
	jWMDI3pmSAbhOkZJjneVPFbKxKZQh8DeBTGwWrDRRU93czKxDPJFgrNIveX0UCsW6SB1O6dnGZTHk
	9cojV3Hg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMOnc-0000000Gvla-2oSP
	for fio@vger.kernel.org;
	Thu, 29 Oct 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A96311BC0174; Thu, 29 Oct 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 29 Oct 2026 06:00:01 -0600
Message-Id: <20261029120001.A96311BC0174@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 80eb2516037c627d77cd7e8a428cb534b830f9b6:

  Merge branch 'configure-libatomic' of https://github.com/kraj/fio (2026-10-21 10:47:54 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f8127399732876749f4855fb35ac3b8693fc7463:

  Merge branch 'zbyrne/gpuaccel-null-backend-fix' of https://github.com/ROCm/fio (2026-10-28 14:14:27 -0400)

----------------------------------------------------------------
Artsem Lebiadzevich (1):
      backend: issue the remaining backlog trims at the end of do_io()

Vincent Fu (2):
      Merge branch 'trim-backlog-drain' of https://github.com/ViderStar/fio
      Merge branch 'zbyrne/gpuaccel-null-backend-fix' of https://github.com/ROCm/fio

zbyrne (1):
      engines/gpuaccel: Null check engine backend before registering opened file.

 backend.c          | 15 ++++++++++++++-
 engines/gpuaccel.c |  6 +++++-
 t/verify-trim.py   | 29 +++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 88557f0b..8843cdda 100644
--- a/backend.c
+++ b/backend.c
@@ -1198,6 +1198,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		td->o.time_based) {
 		struct timespec comp_time;
 		struct io_u *io_u;
+		bool drain_trims = false;
 		int full;
 		enum fio_ddir ddir;
 
@@ -1219,13 +1220,25 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		if (flow_threshold_exceeded(td))
 			continue;
 
+		/*
+		 * Trims queued by trim_backlog are only issued when
+		 * io_hist_len reaches a multiple of the backlog. Once all
+		 * regular I/O has been issued, issue the remaining ones in
+		 * one batch instead of leaking them.
+		 */
+		if (td->trim_entries && (td->flags & TD_F_TRIM_BACKLOG) &&
+		    !td->o.time_based && io_issue_bytes_exceeded(td)) {
+			td->trim_batch = td->trim_entries;
+			drain_trims = true;
+		}
+
 		/*
 		 * Break if we exceeded the bytes. The exception is time
 		 * based runs, but we still need to break out of the loop
 		 * for those to run verification, if enabled.
 		 * Jobs read from iolog do not use this stop condition.
 		 */
-		if (bytes_issued >= total_bytes &&
+		if (!drain_trims && bytes_issued >= total_bytes &&
 		    !td->o.read_iolog_file &&
 		    (!td->o.time_based ||
 		     (td->o.time_based && td->o.verify != VERIFY_NONE)))
diff --git a/engines/gpuaccel.c b/engines/gpuaccel.c
index 75e89ac7..dc8415c5 100644
--- a/engines/gpuaccel.c
+++ b/engines/gpuaccel.c
@@ -394,7 +394,11 @@ int fio_gpuaccel_open_file(struct thread_data *td, struct fio_file *f)
 	if (rc)
 		return rc;
 
-	if (o->io_mode == IO_DIRECT) {
+	/*
+	 * setup_files() opens block devices for a size check before ->init has
+	 * set o->backend; the handle is registered on the later real open.
+	 */
+	if (be && o->io_mode == IO_DIRECT) {
 		rc = be->file_handle_register(f->fd, &handle);
 		if (rc != 0) {
 			goto exit_err;
diff --git a/t/verify-trim.py b/t/verify-trim.py
index e95b2709..e072c7c5 100755
--- a/t/verify-trim.py
+++ b/t/verify-trim.py
@@ -31,6 +31,7 @@ VERIFY_OPT_LIST = [
     'direct',
     'iodepth',
     'filesize',
+    'size',
     'bs',
     'time_based',
     'runtime',
@@ -209,6 +210,34 @@ TEST_LIST = [
             },
         "test_class": VerifyTrimTest,
     },
+    {
+        # seq write, trim_backlog larger than the number of writes:
+        # the queued trims must still be issued at the end
+        "test_id": 106,
+        "fio_opts": {
+            "rw": "write",
+            "trim_percentage": 50,
+            "trim_backlog": 1000,
+            "trim_verify_zero": 1,
+            "size": "1M",
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # rand write, trim_backlog larger than the number of writes:
+        # the queued trims must still be issued at the end
+        "test_id": 107,
+        "fio_opts": {
+            "rw": "randwrite",
+            "trim_percentage": 50,
+            "trim_backlog": 1000,
+            "trim_verify_zero": 1,
+            "size": "1M",
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
     {
         # do_verify=0: trim must still be issued when trim_percentage=100
         "test_id": 200,
