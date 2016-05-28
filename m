Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46164 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbcE1MAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 28 May 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b6cuS-0004qv-QQ
	for fio@vger.kernel.org; Sat, 28 May 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160528120002.972202C00EE@kernel.dk>
Date: Sat, 28 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 34febb23fa9c7b9b0d54c324effff1a808a8fe6e:

  mutex: abstract out cond/lock pshared init (2016-05-25 13:55:48 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aa7d2ef092d5a8e417fcddaf8808fb0d48f1064b:

  Added millisecond-accurate timestamp to JSON output (2016-05-27 14:26:16 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      server: ensure that we flush compressed logs correctly

Ryan Hardin (1):
      Added millisecond-accurate timestamp to JSON output

 server.c | 38 +++++++++++++++++++++++++++++++++-----
 stat.c   | 13 +++++++++----
 2 files changed, 42 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index d36c511..667a66c 100644
--- a/server.c
+++ b/server.c
@@ -1656,7 +1656,7 @@ void fio_server_send_du(void)
 static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
 				 struct io_logs *cur_log, z_stream *stream)
 {
-	struct sk_entry *entry;
+	unsigned int this_len;
 	void *out_pdu;
 	int ret;
 
@@ -1664,7 +1664,7 @@ static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
 	stream->avail_in = cur_log->nr_samples * log_entry_sz(log);
 
 	do {
-		unsigned int this_len;
+		struct sk_entry *entry;
 
 		/*
 		 * Dirty - since the log is potentially huge, compress it into
@@ -1675,7 +1675,7 @@ static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
 
 		stream->avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
 		stream->next_out = out_pdu;
-		ret = deflate(stream, Z_FINISH);
+		ret = deflate(stream, Z_BLOCK);
 		/* may be Z_OK, or Z_STREAM_END */
 		if (ret < 0) {
 			free(out_pdu);
@@ -1716,8 +1716,36 @@ static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
 			break;
 	}
 
-	deflateEnd(&stream);
-	return ret;
+	ret = deflate(&stream, Z_FINISH);
+
+	while (ret != Z_STREAM_END) {
+		struct sk_entry *entry;
+		unsigned int this_len;
+		void *out_pdu;
+
+		out_pdu = malloc(FIO_SERVER_MAX_FRAGMENT_PDU);
+		stream.avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
+		stream.next_out = out_pdu;
+
+		ret = deflate(&stream, Z_FINISH);
+		/* may be Z_OK, or Z_STREAM_END */
+		if (ret < 0) {
+			free(out_pdu);
+			break;
+		}
+
+		this_len = FIO_SERVER_MAX_FRAGMENT_PDU - stream.avail_out;
+
+		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
+					 NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
+		flist_add_tail(&entry->list, &first->next);
+	} while (ret != Z_STREAM_END);
+
+	ret = deflateEnd(&stream);
+	if (ret == Z_OK)
+		return 0;
+
+	return 1;
 }
 #else
 static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
diff --git a/stat.c b/stat.c
index fc1efd4..5384884 100644
--- a/stat.c
+++ b/stat.c
@@ -1636,16 +1636,21 @@ void __show_run_stats(void)
 	if (output_format & FIO_OUTPUT_JSON) {
 		struct thread_data *global;
 		char time_buf[32];
-		time_t time_p;
+		struct timeval now;
+		unsigned long long ms_since_epoch;
 
-		time(&time_p);
-		os_ctime_r((const time_t *) &time_p, time_buf,
+		gettimeofday(&now, NULL);
+		ms_since_epoch = (unsigned long long)(now.tv_sec) * 1000 +
+		                 (unsigned long long)(now.tv_usec) / 1000;
+
+		os_ctime_r((const time_t *) &now.tv_sec, time_buf,
 				sizeof(time_buf));
 		time_buf[strlen(time_buf) - 1] = '\0';
 
 		root = json_create_object();
 		json_object_add_value_string(root, "fio version", fio_version_string);
-		json_object_add_value_int(root, "timestamp", time_p);
+		json_object_add_value_int(root, "timestamp", now.tv_sec);
+		json_object_add_value_int(root, "timestamp_ms", ms_since_epoch);
 		json_object_add_value_string(root, "time", time_buf);
 		global = get_global_options();
 		json_add_job_opts(root, "global options", &global->opt_list, false);
