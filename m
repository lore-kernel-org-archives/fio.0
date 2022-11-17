Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36143C43219
	for <fio@archiver.kernel.org>; Thu, 17 Nov 2022 22:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbiKQWGf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241127AbiKQWGL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Nov 2022 17:06:11 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0081DF02
        for <fio@vger.kernel.org>; Thu, 17 Nov 2022 14:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=muDTYl3sR46Wb6PUOstu9i1a/IAsPd4gVTZUyKTeNnE=; b=gI1WjKs/WmDGvLY1Vw+fMX+VwD
        bOugcg5tbkM7Fhmm+LyRWnXzMcaK9lJOERdbX22bgXGmsRa9YpWGFPdiVuJskA4sJdawMdiOH7hzf
        aad9PQE7qScgc7t7pVU8gpyJFgWBtDCnKqhUOOChAys1W92ClEjIVEbbHlDSArfNgbo935l3NfWlC
        zEv5M3/Vj8FVWUlWLYakD3EIF5H07mR9IlSRipQueA7gY5zYS7mdvjcwBf/naewjNWix8YPLdMpDd
        YSKOBNvUZqDwiMKp/tbFlibdQiO+caPJvorksY4MNLBmVVTbxeMv04kAQkEyKoe9bGGw9SauwpV0L
        zJpkSaIQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0i-004pDA-If; Thu, 17 Nov 2022 15:05:31 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0h-000Ljh-TV; Thu, 17 Nov 2022 15:05:27 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu, 17 Nov 2022 15:05:19 -0700
Message-Id: <20221117220523.83501-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117220523.83501-1-logang@deltatee.com>
References: <20221117220523.83501-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v2 1/5] cconv: Support pattern buffers of arbitrary size
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Change the thread_options_pack structure to support pattern buffers
of arbitrary size by using a flexible array at the end of the the
structure to store both the verify_pattern and the buffer_pattern
in that order.

In this way, only the actual bytes of each pattern will be sent over
the wire and patterns of an arbitrary size can be used with the packed
structure.

In order to determine the required size of the structure the function
thread_options_pack_size() is introduced which returns the total
number of bytes required for a given thread_options instance.

The two callsites of convert_thread_options_to_net() are then converted
to dynamically allocate a pdu of the appropriate size and the
two callsites of convert_thread_options_to_cpu() are modified to
take the size of the received data to prevent buffer overruns.

Also add specific testing of this feature in fio_test_cconv().

Seeing this changes the client/server protocol, the FIO_SERVER_VER
is bumped.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 cconv.c          | 75 +++++++++++++++++++++++++++++++++---------------
 client.c         | 17 +++++++----
 gclient.c        | 12 ++++++--
 server.c         | 23 +++++++++------
 server.h         |  2 +-
 thread_options.h | 11 +++++--
 6 files changed, 96 insertions(+), 44 deletions(-)

diff --git a/cconv.c b/cconv.c
index 6c36afb72d1e..bb1af4970e97 100644
--- a/cconv.c
+++ b/cconv.c
@@ -54,8 +54,15 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 	}
 }
 
-void convert_thread_options_to_cpu(struct thread_options *o,
-				   struct thread_options_pack *top)
+size_t thread_options_pack_size(struct thread_options *o)
+{
+	return sizeof(struct thread_options_pack) + o->verify_pattern_bytes +
+		o->buffer_pattern_bytes;
+}
+
+int convert_thread_options_to_cpu(struct thread_options *o,
+				  struct thread_options_pack *top,
+				  size_t top_sz)
 {
 	int i, j;
 
@@ -171,10 +178,17 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_interval = le32_to_cpu(top->verify_interval);
 	o->verify_offset = le32_to_cpu(top->verify_offset);
 
-	memcpy(o->verify_pattern, top->verify_pattern, MAX_PATTERN_SIZE);
-	memcpy(o->buffer_pattern, top->buffer_pattern, MAX_PATTERN_SIZE);
-
 	o->verify_pattern_bytes = le32_to_cpu(top->verify_pattern_bytes);
+	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
+	if (o->verify_pattern_bytes >= MAX_PATTERN_SIZE ||
+	    o->buffer_pattern_bytes >= MAX_PATTERN_SIZE ||
+	    thread_options_pack_size(o) > top_sz)
+		return -EINVAL;
+
+	memcpy(o->verify_pattern, top->patterns, o->verify_pattern_bytes);
+	memcpy(o->buffer_pattern, &top->patterns[o->verify_pattern_bytes],
+	       o->buffer_pattern_bytes);
+
 	o->verify_fatal = le32_to_cpu(top->verify_fatal);
 	o->verify_dump = le32_to_cpu(top->verify_dump);
 	o->verify_async = le32_to_cpu(top->verify_async);
@@ -268,7 +282,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zero_buffers = le32_to_cpu(top->zero_buffers);
 	o->refill_buffers = le32_to_cpu(top->refill_buffers);
 	o->scramble_buffers = le32_to_cpu(top->scramble_buffers);
-	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
 	o->time_based = le32_to_cpu(top->time_based);
 	o->disable_lat = le32_to_cpu(top->disable_lat);
 	o->disable_clat = le32_to_cpu(top->disable_clat);
@@ -334,6 +347,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
 	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
+
+	return 0;
 }
 
 void convert_thread_options_to_net(struct thread_options_pack *top,
@@ -572,8 +587,9 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		top->max_latency[i] = __cpu_to_le64(o->max_latency[i]);
 	}
 
-	memcpy(top->verify_pattern, o->verify_pattern, MAX_PATTERN_SIZE);
-	memcpy(top->buffer_pattern, o->buffer_pattern, MAX_PATTERN_SIZE);
+	memcpy(top->patterns, o->verify_pattern, o->verify_pattern_bytes);
+	memcpy(&top->patterns[o->verify_pattern_bytes], o->buffer_pattern,
+	       o->buffer_pattern_bytes);
 
 	top->size = __cpu_to_le64(o->size);
 	top->io_size = __cpu_to_le64(o->io_size);
@@ -620,7 +636,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
 	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
-
 }
 
 /*
@@ -630,18 +645,32 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
  */
 int fio_test_cconv(struct thread_options *__o)
 {
-	struct thread_options o;
-	struct thread_options_pack top1, top2;
-
-	memset(&top1, 0, sizeof(top1));
-	memset(&top2, 0, sizeof(top2));
-
-	convert_thread_options_to_net(&top1, __o);
-	memset(&o, 0, sizeof(o));
-	convert_thread_options_to_cpu(&o, &top1);
-	convert_thread_options_to_net(&top2, &o);
-
-	free_thread_options_to_cpu(&o);
-
-	return memcmp(&top1, &top2, sizeof(top1));
+	struct thread_options o1 = *__o, o2;
+	struct thread_options_pack *top1, *top2;
+	size_t top_sz;
+	int ret;
+
+	o1.verify_pattern_bytes = 61;
+	memset(o1.verify_pattern, 'V', o1.verify_pattern_bytes);
+	o1.buffer_pattern_bytes = 15;
+	memset(o1.buffer_pattern, 'B', o1.buffer_pattern_bytes);
+
+	top_sz = thread_options_pack_size(&o1);
+	top1 = calloc(1, top_sz);
+	top2 = calloc(1, top_sz);
+
+	convert_thread_options_to_net(top1, &o1);
+	memset(&o2, 0, sizeof(o2));
+	ret = convert_thread_options_to_cpu(&o2, top1, top_sz);
+	if (ret)
+		goto out;
+
+	convert_thread_options_to_net(top2, &o2);
+	ret = memcmp(top1, top2, top_sz);
+
+out:
+	free_thread_options_to_cpu(&o2);
+	free(top2);
+	free(top1);
+	return ret;
 }
diff --git a/client.c b/client.c
index 37da74bca5d7..51496c770248 100644
--- a/client.c
+++ b/client.c
@@ -922,13 +922,20 @@ int fio_clients_send_ini(const char *filename)
 int fio_client_update_options(struct fio_client *client,
 			      struct thread_options *o, uint64_t *tag)
 {
-	struct cmd_add_job_pdu pdu;
+	size_t cmd_sz = offsetof(struct cmd_add_job_pdu, top) +
+		thread_options_pack_size(o);
+	struct cmd_add_job_pdu *pdu;
+	int ret;
 
-	pdu.thread_number = cpu_to_le32(client->thread_number);
-	pdu.groupid = cpu_to_le32(client->groupid);
-	convert_thread_options_to_net(&pdu.top, o);
+	pdu = malloc(cmd_sz);
+	pdu->thread_number = cpu_to_le32(client->thread_number);
+	pdu->groupid = cpu_to_le32(client->groupid);
+	convert_thread_options_to_net(&pdu->top, o);
 
-	return fio_net_send_cmd(client->fd, FIO_NET_CMD_UPDATE_JOB, &pdu, sizeof(pdu), tag, &client->cmd_list);
+	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_UPDATE_JOB, pdu,
+			       cmd_sz, tag, &client->cmd_list);
+	free(pdu);
+	return ret;
 }
 
 static void convert_io_stat(struct io_stat *dst, struct io_stat *src)
diff --git a/gclient.c b/gclient.c
index c59bcfe2f6f3..73f64b3b87f1 100644
--- a/gclient.c
+++ b/gclient.c
@@ -553,12 +553,15 @@ static void gfio_quit_op(struct fio_client *client, struct fio_net_cmd *cmd)
 }
 
 static struct thread_options *gfio_client_add_job(struct gfio_client *gc,
-			struct thread_options_pack *top)
+			struct thread_options_pack *top, size_t top_sz)
 {
 	struct gfio_client_options *gco;
 
 	gco = calloc(1, sizeof(*gco));
-	convert_thread_options_to_cpu(&gco->o, top);
+	if (convert_thread_options_to_cpu(&gco->o, top, top_sz)) {
+		dprint(FD_NET, "client: failed parsing add_job command\n");
+		return NULL;
+	}
 	INIT_FLIST_HEAD(&gco->list);
 	flist_add_tail(&gco->list, &gc->o_list);
 	gc->o_list_nr = 1;
@@ -577,7 +580,10 @@ static void gfio_add_job_op(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	p->thread_number = le32_to_cpu(p->thread_number);
 	p->groupid = le32_to_cpu(p->groupid);
-	o = gfio_client_add_job(gc, &p->top);
+	o = gfio_client_add_job(gc, &p->top,
+			cmd->pdu_len - offsetof(struct cmd_add_job_pdu, top));
+	if (o == NULL)
+		return;
 
 	gdk_threads_enter();
 
diff --git a/server.c b/server.c
index b869d3872734..a6347efd8281 100644
--- a/server.c
+++ b/server.c
@@ -1082,6 +1082,7 @@ static int handle_update_job_cmd(struct fio_net_cmd *cmd)
 	struct cmd_add_job_pdu *pdu = (struct cmd_add_job_pdu *) cmd->payload;
 	struct thread_data *td;
 	uint32_t tnumber;
+	int ret;
 
 	tnumber = le32_to_cpu(pdu->thread_number);
 
@@ -1093,8 +1094,9 @@ static int handle_update_job_cmd(struct fio_net_cmd *cmd)
 	}
 
 	td = tnumber_to_td(tnumber);
-	convert_thread_options_to_cpu(&td->o, &pdu->top);
-	send_update_job_reply(cmd->tag, 0);
+	ret = convert_thread_options_to_cpu(&td->o, &pdu->top,
+			cmd->pdu_len - offsetof(struct cmd_add_job_pdu, top));
+	send_update_job_reply(cmd->tag, ret);
 	return 0;
 }
 
@@ -2323,15 +2325,18 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 
 void fio_server_send_add_job(struct thread_data *td)
 {
-	struct cmd_add_job_pdu pdu = {
-		.thread_number = cpu_to_le32(td->thread_number),
-		.groupid = cpu_to_le32(td->groupid),
-	};
+	struct cmd_add_job_pdu *pdu;
+	size_t cmd_sz = offsetof(struct cmd_add_job_pdu, top) +
+		thread_options_pack_size(&td->o);
 
-	convert_thread_options_to_net(&pdu.top, &td->o);
+	pdu = malloc(cmd_sz);
+	pdu->thread_number = cpu_to_le32(td->thread_number);
+	pdu->groupid = cpu_to_le32(td->groupid);
 
-	fio_net_queue_cmd(FIO_NET_CMD_ADD_JOB, &pdu, sizeof(pdu), NULL,
-				SK_F_COPY);
+	convert_thread_options_to_net(&pdu->top, &td->o);
+
+	fio_net_queue_cmd(FIO_NET_CMD_ADD_JOB, pdu, cmd_sz, NULL, SK_F_COPY);
+	free(pdu);
 }
 
 void fio_server_send_start(struct thread_data *td)
diff --git a/server.h b/server.h
index b0c5e2dfafa0..281330202884 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 97,
+	FIO_SERVER_VER			= 98,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 634070af00ec..d2897ac274bf 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -464,7 +464,6 @@ struct thread_options_pack {
 	uint32_t do_verify;
 	uint32_t verify_interval;
 	uint32_t verify_offset;
-	uint8_t verify_pattern[MAX_PATTERN_SIZE];
 	uint32_t verify_pattern_bytes;
 	uint32_t verify_fatal;
 	uint32_t verify_dump;
@@ -572,7 +571,6 @@ struct thread_options_pack {
 	uint32_t zero_buffers;
 	uint32_t refill_buffers;
 	uint32_t scramble_buffers;
-	uint8_t buffer_pattern[MAX_PATTERN_SIZE];
 	uint32_t buffer_pattern_bytes;
 	uint32_t compress_percentage;
 	uint32_t compress_chunk;
@@ -699,9 +697,16 @@ struct thread_options_pack {
 
 	uint32_t log_entries;
 	uint32_t log_prio;
+
+	/*
+	 * verify_pattern followed by buffer_pattern from the unpacked struct
+	 */
+	uint8_t patterns[];
 } __attribute__((packed));
 
-extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
+extern int convert_thread_options_to_cpu(struct thread_options *o,
+		struct thread_options_pack *top, size_t top_sz);
+extern size_t thread_options_pack_size(struct thread_options *o);
 extern void convert_thread_options_to_net(struct thread_options_pack *top, struct thread_options *);
 extern int fio_test_cconv(struct thread_options *);
 extern void options_default_fill(struct thread_options *o);
-- 
2.30.2

