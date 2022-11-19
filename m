Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9D0C4332F
	for <fio@archiver.kernel.org>; Sat, 19 Nov 2022 13:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiKSNAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 19 Nov 2022 08:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiKSNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 19 Nov 2022 08:00:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88F175D8A
        for <fio@vger.kernel.org>; Sat, 19 Nov 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=c4J0TRM9XE7je9fiSwsGt5BqirNP5FVsjlXdlTgGwpc=; b=j8DU86/22Mv+AIIxN2bIWOfarV
        X2ADdbs8SpBfXLuD5eq1Lvd1j76MwzVSfB7hA9MpjJHpmVgiTuJvBkBUkZuDsVzaMhTwaPBfg314J
        MmGs+sVG6LUgyz/c/gARz+I2WG3qveyn3z6YpwJqgOhEIJpW2D4Sfnvj8o/zJz1wYK7gqqYJo18q9
        i9Lif7sjakd8HH/tZJQ5ZqO0bb4kfOd4hrzGaKednP9o1mni0ITCuUZFTppRuon/7uxfmmlRfAsKT
        D9D+FQsh6A0hFsPE6JzbN/S1dMipEs3O6iDmxEvfSdZIhL0+ade+TSTX7PCHXFdJ/GoAAwF/ra8gr
        gjKNdwxw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owNS6-003EN5-N3
        for fio@vger.kernel.org; Sat, 19 Nov 2022 13:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D18251BC0128; Sat, 19 Nov 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221119130001.D18251BC0128@kernel.dk>
Date:   Sat, 19 Nov 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 07c8fe21021681f86fbfd3c3d63b88a5ebd4e557:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-11-14 08:47:00 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ede04c27b618842e32b2a3349672f6b59a1697e1:

  test: add large pattern test (2022-11-18 19:36:10 -0500)

----------------------------------------------------------------
Logan Gunthorpe (6):
      cconv: Support pattern buffers of arbitrary size
      lib/pattern: Support NULL output buffer in parse_and_fill_pattern()
      lib/pattern: Support short repeated read calls when loading from file
      options: Support arbitrarily long pattern buffers
      lib/pattern: Support binary pattern buffers on windows
      test: add large pattern test

Shin'ichiro Kawasaki (13):
      oslib: blkzoned: add blkzoned_finish_zone() helper function
      engines/libzbc: add libzbc_finish_zone() helper function
      zbd: add zbd_zone_remainder() helper function
      zbd: finish zones with remainder smaller than minimum write block size
      zbd: allow block size not divisor of zone size
      zbd, verify: verify before zone reset for zone_reset_threshold/frequency
      zbd: fix zone reset condition for verify
      zbd: prevent experimental verify with zonemode=zbd
      t/zbd: fix test case #33 for block size unaligned to zone size
      t/zbd: modify test case #34 for block size unaligned to zone size
      t/zbd: add test case to check zone_reset_threshold/frequency with verify
      t/zbd: remove experimental_verify option from test case #54
      t/zbd: add test case to check experimental_verify option

 cconv.c                |  86 +++++++++++++++++-------
 client.c               |  17 +++--
 engines/libzbc.c       |  34 ++++++++++
 gclient.c              |  12 +++-
 ioengines.h            |   2 +
 lib/pattern.c          | 100 +++++++++++++++++++++++-----
 lib/pattern.h          |  21 ++++--
 options.c              |  10 +--
 oslib/blkzoned.h       |   8 +++
 oslib/linux-blkzoned.c |  37 +++++++++++
 server.c               |  23 ++++---
 server.h               |   2 +-
 stat.h                 |   1 -
 t/jobs/t0027.fio       |  14 ++++
 t/run-fio-tests.py     |  29 ++++++++
 t/zbd/test-zbd-support |  60 +++++++++++++----
 thread_options.h       |  15 +++--
 verify.c               |   6 +-
 zbd.c                  | 175 +++++++++++++++++++++++++++++++++----------------
 zbd.h                  |   2 -
 20 files changed, 507 insertions(+), 147 deletions(-)
 create mode 100644 t/jobs/t0027.fio

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index 6c36afb7..d755844f 100644
--- a/cconv.c
+++ b/cconv.c
@@ -48,14 +48,24 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 	free(o->profile);
 	free(o->cgroup);
 
+	free(o->verify_pattern);
+	free(o->buffer_pattern);
+
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		free(o->bssplit[i]);
 		free(o->zone_split[i]);
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
 
@@ -171,10 +181,21 @@ void convert_thread_options_to_cpu(struct thread_options *o,
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
+	o->verify_pattern = realloc(o->verify_pattern,
+				    o->verify_pattern_bytes);
+	o->buffer_pattern = realloc(o->buffer_pattern,
+				    o->buffer_pattern_bytes);
+	memcpy(o->verify_pattern, top->patterns, o->verify_pattern_bytes);
+	memcpy(o->buffer_pattern, &top->patterns[o->verify_pattern_bytes],
+	       o->buffer_pattern_bytes);
+
 	o->verify_fatal = le32_to_cpu(top->verify_fatal);
 	o->verify_dump = le32_to_cpu(top->verify_dump);
 	o->verify_async = le32_to_cpu(top->verify_async);
@@ -268,7 +289,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zero_buffers = le32_to_cpu(top->zero_buffers);
 	o->refill_buffers = le32_to_cpu(top->refill_buffers);
 	o->scramble_buffers = le32_to_cpu(top->scramble_buffers);
-	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
 	o->time_based = le32_to_cpu(top->time_based);
 	o->disable_lat = le32_to_cpu(top->disable_lat);
 	o->disable_clat = le32_to_cpu(top->disable_clat);
@@ -334,6 +354,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
 	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
+
+	return 0;
 }
 
 void convert_thread_options_to_net(struct thread_options_pack *top,
@@ -572,8 +594,9 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		top->max_latency[i] = __cpu_to_le64(o->max_latency[i]);
 	}
 
-	memcpy(top->verify_pattern, o->verify_pattern, MAX_PATTERN_SIZE);
-	memcpy(top->buffer_pattern, o->buffer_pattern, MAX_PATTERN_SIZE);
+	memcpy(top->patterns, o->verify_pattern, o->verify_pattern_bytes);
+	memcpy(&top->patterns[o->verify_pattern_bytes], o->buffer_pattern,
+	       o->buffer_pattern_bytes);
 
 	top->size = __cpu_to_le64(o->size);
 	top->io_size = __cpu_to_le64(o->io_size);
@@ -620,7 +643,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
 	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
-
 }
 
 /*
@@ -630,18 +652,36 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
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
+	o1.verify_pattern = malloc(o1.verify_pattern_bytes);
+	memset(o1.verify_pattern, 'V', o1.verify_pattern_bytes);
+	o1.buffer_pattern_bytes = 15;
+	o1.buffer_pattern = malloc(o1.buffer_pattern_bytes);
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
+	free(o1.buffer_pattern);
+	free(o1.verify_pattern);
+	return ret;
 }
diff --git a/client.c b/client.c
index 37da74bc..51496c77 100644
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
diff --git a/engines/libzbc.c b/engines/libzbc.c
index 2bc2c7e0..2b63ef1a 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -332,6 +332,39 @@ err:
 	return -ret;
 }
 
+static int libzbc_finish_zone(struct thread_data *td, struct fio_file *f,
+			      uint64_t offset, uint64_t length)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	uint64_t sector = offset >> 9;
+	unsigned int nr_zones;
+	struct zbc_errno err;
+	int i, ret;
+
+	assert(ld);
+	assert(ld->zdev);
+
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+	assert(nr_zones > 0);
+
+	for (i = 0; i < nr_zones; i++, sector += td->o.zone_size >> 9) {
+		ret = zbc_finish_zone(ld->zdev, sector, 0);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	zbc_errno(ld->zdev, &err);
+	td_verror(td, errno, "zbc_finish_zone failed");
+	if (err.sk)
+		log_err("%s: finish zone failed %s:%s\n",
+			f->file_name,
+			zbc_sk_str(err.sk), zbc_asc_ascq_str(err.asc_ascq));
+	return -ret;
+}
+
 static int libzbc_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				     unsigned int *max_open_zones)
 {
@@ -434,6 +467,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.report_zones		= libzbc_report_zones,
 	.reset_wp		= libzbc_reset_wp,
 	.get_max_open_zones	= libzbc_get_max_open_zones,
+	.finish_zone		= libzbc_finish_zone,
 	.queue			= libzbc_queue,
 	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
 };
diff --git a/gclient.c b/gclient.c
index c59bcfe2..73f64b3b 100644
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
 
diff --git a/ioengines.h b/ioengines.h
index fafa1e48..11d2115c 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -61,6 +61,8 @@ struct ioengine_ops {
 			uint64_t, uint64_t);
 	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
 				  unsigned int *);
+	int (*finish_zone)(struct thread_data *, struct fio_file *,
+			   uint64_t, uint64_t);
 	int option_struct_size;
 	struct fio_option *options;
 };
diff --git a/lib/pattern.c b/lib/pattern.c
index d8203630..9be29af6 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -32,7 +32,7 @@ static const char *parse_file(const char *beg, char *out,
 	const char *end;
 	char *file;
 	int fd;
-	ssize_t count;
+	ssize_t rc, count = 0;
 
 	if (!out_len)
 		goto err_out;
@@ -47,13 +47,32 @@ static const char *parse_file(const char *beg, char *out,
 	if (file == NULL)
 		goto err_out;
 
+#ifdef _WIN32
+	fd = open(file, O_RDONLY | O_BINARY);
+#else
 	fd = open(file, O_RDONLY);
+#endif
 	if (fd < 0)
 		goto err_free_out;
 
-	count = read(fd, out, out_len);
-	if (count == -1)
-		goto err_free_close_out;
+	if (out) {
+		while (1) {
+			rc = read(fd, out, out_len - count);
+			if (rc == 0)
+				break;
+			if (rc == -1)
+				goto err_free_close_out;
+
+			count += rc;
+			out += rc;
+		}
+	} else {
+		count = lseek(fd, 0, SEEK_END);
+		if (count == -1)
+			goto err_free_close_out;
+		if (count >= out_len)
+			count = out_len;
+	}
 
 	*filled = count;
 	close(fd);
@@ -100,7 +119,8 @@ static const char *parse_string(const char *beg, char *out,
 	if (end - beg > out_len)
 		return NULL;
 
-	memcpy(out, beg, end - beg);
+	if (out)
+		memcpy(out, beg, end - beg);
 	*filled = end - beg;
 
 	/* Catch up quote */
@@ -156,12 +176,14 @@ static const char *parse_number(const char *beg, char *out,
 		i = 0;
 		if (!lval) {
 			num    = 0;
-			out[i] = 0x00;
+			if (out)
+				out[i] = 0x00;
 			i      = 1;
 		} else {
 			val = (unsigned int)lval;
 			for (; val && out_len; out_len--, i++, val >>= 8)
-				out[i] = val & 0xff;
+				if (out)
+					out[i] = val & 0xff;
 			if (val)
 				return NULL;
 		}
@@ -183,7 +205,8 @@ static const char *parse_number(const char *beg, char *out,
 			const char *fmt;
 
 			fmt = (num & 1 ? "%1hhx" : "%2hhx");
-			sscanf(beg, fmt, &out[i]);
+			if (out)
+				sscanf(beg, fmt, &out[i]);
 			if (num & 1) {
 				num++;
 				beg--;
@@ -251,7 +274,8 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
 	if (f->desc->len > out_len)
 		return NULL;
 
-	memset(out, '\0', f->desc->len);
+	if (out)
+		memset(out, '\0', f->desc->len);
 	*filled = f->desc->len;
 
 	return in + len;
@@ -262,7 +286,9 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
  *                            numbers and pattern formats.
  * @in - string input
  * @in_len - size of the input string
- * @out - output buffer where parsed result will be put
+ * @out - output buffer where parsed result will be put, may be NULL
+ *	  in which case this function just calculates the required
+ *	  length of the buffer
  * @out_len - lengths of the output buffer
  * @fmt_desc - array of pattern format descriptors [input]
  * @fmt - array of pattern formats [output]
@@ -305,16 +331,16 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
  *
  * Returns number of bytes filled or err < 0 in case of failure.
  */
-int parse_and_fill_pattern(const char *in, unsigned int in_len,
-			   char *out, unsigned int out_len,
-			   const struct pattern_fmt_desc *fmt_desc,
-			   struct pattern_fmt *fmt,
-			   unsigned int *fmt_sz_out)
+static int parse_and_fill_pattern(const char *in, unsigned int in_len,
+				  char *out, unsigned int out_len,
+				  const struct pattern_fmt_desc *fmt_desc,
+				  struct pattern_fmt *fmt,
+				  unsigned int *fmt_sz_out)
 {
 	const char *beg, *end, *out_beg = out;
 	unsigned int total = 0, fmt_rem = 0;
 
-	if (!in || !in_len || !out || !out_len)
+	if (!in || !in_len || !out_len)
 		return -EINVAL;
 	if (fmt_sz_out)
 		fmt_rem = *fmt_sz_out;
@@ -370,6 +396,48 @@ int parse_and_fill_pattern(const char *in, unsigned int in_len,
 	return total;
 }
 
+/**
+ * parse_and_fill_pattern_alloc() - Parses combined input, which consists of
+ *				    strings, numbers and pattern formats and
+ *				    allocates a buffer for the result.
+ *
+ * @in - string input
+ * @in_len - size of the input string
+ * @out - pointer to the output buffer pointer, this will be set to the newly
+ *        allocated pattern buffer which must be freed by the caller
+ * @fmt_desc - array of pattern format descriptors [input]
+ * @fmt - array of pattern formats [output]
+ * @fmt_sz - pointer where the size of pattern formats array stored [input],
+ *           after successful parsing this pointer will contain the number
+ *           of parsed formats if any [output].
+ *
+ * See documentation on parse_and_fill_pattern() above for a description
+ * of the functionality.
+ *
+ * Returns number of bytes filled or err < 0 in case of failure.
+ */
+int parse_and_fill_pattern_alloc(const char *in, unsigned int in_len,
+		char **out, const struct pattern_fmt_desc *fmt_desc,
+		struct pattern_fmt *fmt, unsigned int *fmt_sz_out)
+{
+	int count;
+
+	count = parse_and_fill_pattern(in, in_len, NULL, MAX_PATTERN_SIZE,
+				       fmt_desc, fmt, fmt_sz_out);
+	if (count < 0)
+		return count;
+
+	*out = malloc(count);
+	count = parse_and_fill_pattern(in, in_len, *out, count, fmt_desc,
+				       fmt, fmt_sz_out);
+	if (count < 0) {
+		free(*out);
+		*out = NULL;
+	}
+
+	return count;
+}
+
 /**
  * dup_pattern() - Duplicates part of the pattern all over the buffer.
  *
diff --git a/lib/pattern.h b/lib/pattern.h
index a6d9d6b4..7123b42d 100644
--- a/lib/pattern.h
+++ b/lib/pattern.h
@@ -1,6 +1,19 @@
 #ifndef FIO_PARSE_PATTERN_H
 #define FIO_PARSE_PATTERN_H
 
+/*
+ * The pattern is dynamically allocated, but that doesn't mean there
+ * are not limits. The network protocol has a limit of
+ * FIO_SERVER_MAX_CMD_MB and potentially two patterns must fit in there.
+ * There's also a need to verify the incoming data from the network and
+ * this provides a sensible check.
+ *
+ * 128MiB is an arbitrary limit that meets these criteria. The patterns
+ * tend to be truncated at the IO size anyway and IO sizes that large
+ * aren't terribly practical.
+ */
+#define MAX_PATTERN_SIZE	(128 << 20)
+
 /**
  * Pattern format description. The input for 'parse_pattern'.
  * Describes format with its name and callback, which should
@@ -21,11 +34,9 @@ struct pattern_fmt {
 	const struct pattern_fmt_desc *desc;
 };
 
-int parse_and_fill_pattern(const char *in, unsigned int in_len,
-			   char *out, unsigned int out_len,
-			   const struct pattern_fmt_desc *fmt_desc,
-			   struct pattern_fmt *fmt,
-			   unsigned int *fmt_sz_out);
+int parse_and_fill_pattern_alloc(const char *in, unsigned int in_len,
+		char **out, const struct pattern_fmt_desc *fmt_desc,
+		struct pattern_fmt *fmt, unsigned int *fmt_sz_out);
 
 int paste_format_inplace(char *pattern, unsigned int pattern_len,
 			 struct pattern_fmt *fmt, unsigned int fmt_sz,
diff --git a/options.c b/options.c
index 9e4d8cd1..49612345 100644
--- a/options.c
+++ b/options.c
@@ -1488,8 +1488,8 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 	int ret;
 
 	/* FIXME: for now buffer pattern does not support formats */
-	ret = parse_and_fill_pattern(input, strlen(input), td->o.buffer_pattern,
-				     MAX_PATTERN_SIZE, NULL, NULL, NULL);
+	ret = parse_and_fill_pattern_alloc(input, strlen(input),
+				&td->o.buffer_pattern, NULL, NULL, NULL);
 	if (ret < 0)
 		return 1;
 
@@ -1537,9 +1537,9 @@ static int str_verify_pattern_cb(void *data, const char *input)
 	int ret;
 
 	td->o.verify_fmt_sz = FIO_ARRAY_SIZE(td->o.verify_fmt);
-	ret = parse_and_fill_pattern(input, strlen(input), td->o.verify_pattern,
-				     MAX_PATTERN_SIZE, fmt_desc,
-				     td->o.verify_fmt, &td->o.verify_fmt_sz);
+	ret = parse_and_fill_pattern_alloc(input, strlen(input),
+			&td->o.verify_pattern, fmt_desc, td->o.verify_fmt,
+			&td->o.verify_fmt_sz);
 	if (ret < 0)
 		return 1;
 
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 719b041d..29fb034f 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -18,6 +18,8 @@ extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
 extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				       unsigned int *max_open_zones);
+extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
+				uint64_t offset, uint64_t length);
 #else
 /*
  * Define stubs for systems that do not have zoned block device support.
@@ -51,6 +53,12 @@ static inline int blkzoned_get_max_open_zones(struct thread_data *td, struct fio
 {
 	return -EIO;
 }
+static inline int blkzoned_finish_zone(struct thread_data *td,
+				       struct fio_file *f,
+				       uint64_t offset, uint64_t length)
+{
+	return -EIO;
+}
 #endif
 
 #endif /* FIO_BLKZONED_H */
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 185bd501..c3130d0e 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -308,3 +308,40 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 
 	return ret;
 }
+
+int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
+			 uint64_t offset, uint64_t length)
+{
+#ifdef BLKFINISHZONE
+	struct blk_zone_range zr = {
+		.sector         = offset >> 9,
+		.nr_sectors     = length >> 9,
+	};
+	int fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
+
+	if (ioctl(fd, BLKFINISHZONE, &zr) < 0)
+		ret = -errno;
+
+	if (f->fd < 0)
+		close(fd);
+
+	return ret;
+#else
+	/*
+	 * Kernel versions older than 5.5 does not support BLKFINISHZONE. These
+	 * old kernels assumed zones are closed automatically at max_open_zones
+	 * limit. Also they did not support max_active_zones limit. Then there
+	 * was no need to finish zones to avoid errors caused by max_open_zones
+	 * or max_active_zones. For those old versions, just do nothing.
+	 */
+	return 0;
+#endif
+}
diff --git a/server.c b/server.c
index b869d387..a6347efd 100644
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
index b0c5e2df..28133020 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 97,
+	FIO_SERVER_VER			= 98,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.h b/stat.h
index 4c3bf71f..8ceabc48 100644
--- a/stat.h
+++ b/stat.h
@@ -142,7 +142,6 @@ enum block_info_state {
 	BLOCK_STATE_COUNT,
 };
 
-#define MAX_PATTERN_SIZE	512
 #define FIO_JOBNAME_SIZE	128
 #define FIO_JOBDESC_SIZE	256
 #define FIO_VERROR_SIZE		128
diff --git a/t/jobs/t0027.fio b/t/jobs/t0027.fio
new file mode 100644
index 00000000..b5b97a30
--- /dev/null
+++ b/t/jobs/t0027.fio
@@ -0,0 +1,14 @@
+[global]
+filename=t0027file
+size=16k
+bs=16k
+
+[write_job]
+readwrite=write
+buffer_pattern='t0027.pattern'
+
+[read_job]
+stonewall=1
+readwrite=read
+verify=pattern
+verify_pattern='t0027.pattern'
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e5b307ac..a06f8126 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -799,6 +799,26 @@ class FioJobTest_t0025(FioJobTest):
         if self.json_data['jobs'][0]['read']['io_kbytes'] != 128:
             self.passed = False
 
+class FioJobTest_t0027(FioJobTest):
+    def setup(self, *args, **kws):
+        super(FioJobTest_t0027, self).setup(*args, **kws)
+        self.pattern_file = os.path.join(self.test_dir, "t0027.pattern")
+        self.output_file = os.path.join(self.test_dir, "t0027file")
+        self.pattern = os.urandom(16 << 10)
+        with open(self.pattern_file, "wb") as f:
+            f.write(self.pattern)
+
+    def check_result(self):
+        super(FioJobTest_t0027, self).check_result()
+
+        if not self.passed:
+            return
+
+        with open(self.output_file, "rb") as f:
+            data = f.read()
+
+        if data != self.pattern:
+            self.passed = False
 
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
@@ -1214,6 +1234,15 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [Requirements.not_windows],
     },
+    {
+        'test_id':          27,
+        'test_class':       FioJobTest_t0027,
+        'job':              't0027.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index cdc03f28..4091d9ac 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -813,7 +813,8 @@ test33() {
     local bs io_size size
     local off capacity=0;
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
     size=$((2 * zone_size))
@@ -822,20 +823,30 @@ test33() {
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $(((io_size + bs - 1) / bs * bs)) || return $?
+    check_written $((io_size / bs * bs)) || return $?
 }
 
-# Write to sequential zones with a block size that is not a divisor of the
-# zone size and with data verification enabled.
+# Test repeated async write job with verify using two unaligned block sizes.
 test34() {
-    local size
+	local bs off zone_capacity
+	local -a block_sizes
 
-    prep_write
-    size=$((2 * zone_size))
-    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
-		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
-		   >> "${logfile}.${test_number}" 2>&1 && return 1
-    grep -q 'not a divisor of' "${logfile}.${test_number}"
+	require_zbd || return $SKIP_TESTCASE
+	prep_write
+
+	off=$((first_sequential_zone_sector * 512))
+	zone_capacity=$(total_zone_capacity 1 $off $dev)
+	block_sizes=($((4096 * 7)) $(($(min ${zone_capacity} 4194304) - 4096)))
+
+	for bs in ${block_sizes[@]}; do
+		run_fio --name=job --filename="${dev}" --rw=randwrite \
+			--bs="${bs}" --offset="${off}" \
+			--size=$((4 * zone_size)) --iodepth=256 \
+			"$(ioengine "libaio")" --time_based=1 --runtime=15s \
+			--zonemode=zbd --direct=1 --zonesize="${zone_size}" \
+			--verify=crc32c --do_verify=1 ${job_var_opts[@]} \
+			>> "${logfile}.${test_number}" 2>&1 || return $?
+	done
 }
 
 # Test 1/4 for the I/O boundary rounding code: $size < $zone_size.
@@ -1171,7 +1182,6 @@ test54() {
 		--rw=randrw:2 --rwmixwrite=25 --bsrange=4k-${zone_size} \
 		--zonemode=zbd --zonesize=${zone_size} \
 		--verify=crc32c --do_verify=1 --verify_backlog=2 \
-		--experimental_verify=1 \
 		--alloc-size=65536 --random_generator=tausworthe64 \
 		${job_var_opts[@]} --debug=zbd \
 		>> "${logfile}.${test_number}" 2>&1 || return $?
@@ -1269,6 +1279,32 @@ test58() {
 	    >>"${logfile}.${test_number}" 2>&1
 }
 
+# Test zone_reset_threshold with verify.
+test59() {
+	local off bs loops=2 size=$((zone_size)) w
+	local -a workloads=(write randwrite rw randrw)
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+
+	bs=$(min $((256*1024)) "$zone_size")
+	for w in "${workloads[@]}"; do
+		run_fio_on_seq "$(ioengine "psync")" --rw=${w} --bs="$bs" \
+			       --size=$size --loops=$loops --do_verify=1 \
+			       --verify=md5 --zone_reset_frequency=.9 \
+			       --zone_reset_threshold=.1 \
+			       >> "${logfile}.${test_number}" 2>&1 || return $?
+	done
+}
+
+# Test fio errors out experimental_verify option with zonemode=zbd.
+test60() {
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --size=$zone_size \
+		       --do_verify=1 --verify=md5 --experimental_verify=1 \
+		       >> "${logfile}.${test_number}" 2>&1 && return 1
+	grep -q 'not support experimental verify' "${logfile}.${test_number}"
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/thread_options.h b/thread_options.h
index 634070af..74e7ea45 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -144,7 +144,7 @@ struct thread_options {
 	unsigned int do_verify;
 	unsigned int verify_interval;
 	unsigned int verify_offset;
-	char verify_pattern[MAX_PATTERN_SIZE];
+	char *verify_pattern;
 	unsigned int verify_pattern_bytes;
 	struct pattern_fmt verify_fmt[8];
 	unsigned int verify_fmt_sz;
@@ -256,7 +256,7 @@ struct thread_options {
 	unsigned int zero_buffers;
 	unsigned int refill_buffers;
 	unsigned int scramble_buffers;
-	char buffer_pattern[MAX_PATTERN_SIZE];
+	char *buffer_pattern;
 	unsigned int buffer_pattern_bytes;
 	unsigned int compress_percentage;
 	unsigned int compress_chunk;
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
diff --git a/verify.c b/verify.c
index d6a229ca..ddfadcc8 100644
--- a/verify.c
+++ b/verify.c
@@ -917,9 +917,11 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		hdr = p;
 
 		/*
-		 * Make rand_seed check pass when have verify_backlog.
+		 * Make rand_seed check pass when have verify_backlog or
+		 * zone reset frequency for zonemode=zbd.
 		 */
-		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG))
+		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
+		    td->o.zrf.u.f)
 			io_u->rand_seed = hdr->rand_seed;
 
 		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
diff --git a/zbd.c b/zbd.c
index 627fb968..d1e469f6 100644
--- a/zbd.c
+++ b/zbd.c
@@ -70,6 +70,19 @@ static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info *z)
 	return z->start + z->capacity;
 }
 
+/**
+ * zbd_zone_remainder - Return the number of bytes that are still available for
+ *                      writing before the zone gets full
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
+{
+	if (z->wp >= zbd_zone_capacity_end(z))
+		return 0;
+
+	return zbd_zone_capacity_end(z) - z->wp;
+}
+
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
  * @f: file pointer.
@@ -83,8 +96,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 {
 	assert((required & 511) == 0);
 
-	return z->has_wp &&
-		z->wp + required > zbd_zone_capacity_end(z);
+	return z->has_wp && required > zbd_zone_remainder(z);
 }
 
 static void zone_lock(struct thread_data *td, const struct fio_file *f,
@@ -279,7 +291,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	z->wp = z->start;
-	z->verify_block = 0;
 
 	td->ts.nr_zone_resets++;
 
@@ -322,6 +333,44 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	z->open = 0;
 }
 
+/**
+ * zbd_finish_zone - finish the specified zone
+ * @td: FIO thread data.
+ * @f: FIO file for which to finish a zone
+ * @z: Zone to finish.
+ *
+ * Finish the zone at @offset with open or close status.
+ */
+static int zbd_finish_zone(struct thread_data *td, struct fio_file *f,
+			   struct fio_zone_info *z)
+{
+	uint64_t offset = z->start;
+	uint64_t length = f->zbd_info->zone_size;
+	int ret = 0;
+
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		if (td->io_ops && td->io_ops->finish_zone)
+			ret = td->io_ops->finish_zone(td, f, offset, length);
+		else
+			ret = blkzoned_finish_zone(td, f, offset, length);
+		break;
+	default:
+		break;
+	}
+
+	if (ret < 0) {
+		td_verror(td, errno, "finish zone failed");
+		log_err("%s: finish zone at sector %"PRIu64" failed (%d).\n",
+			f->file_name, offset >> 9, errno);
+	} else {
+		z->wp = (z+1)->start;
+	}
+
+	return ret;
+}
+
 /**
  * zbd_reset_zones - Reset a range of zones.
  * @td: fio thread data.
@@ -440,7 +489,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 		 * already in-flight, handle it as a full zone instead of an
 		 * open zone.
 		 */
-		if (z->wp >= zbd_zone_capacity_end(z))
+		if (!zbd_zone_remainder(z))
 			res = false;
 		goto out;
 	}
@@ -602,7 +651,7 @@ static bool zbd_verify_bs(void)
 {
 	struct thread_data *td;
 	struct fio_file *f;
-	int i, j, k;
+	int i, j;
 
 	for_each_td(td, i) {
 		if (td_trim(td) &&
@@ -624,15 +673,6 @@ static bool zbd_verify_bs(void)
 					 zone_size);
 				return false;
 			}
-			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
-				if (td->o.verify != VERIFY_NONE &&
-				    zone_size % td->o.bs[k] != 0) {
-					log_info("%s: block size %llu is not a divisor of the zone size %"PRIu64"\n",
-						 f->file_name, td->o.bs[k],
-						 zone_size);
-					return false;
-				}
-			}
 		}
 	}
 	return true;
@@ -1044,6 +1084,11 @@ int zbd_setup_files(struct thread_data *td)
 	if (!zbd_verify_bs())
 		return 1;
 
+	if (td->o.experimental_verify) {
+		log_err("zonemode=zbd does not support experimental verify\n");
+		return 1;
+	}
+
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd = f->zbd_info;
 		struct fio_zone_info *z;
@@ -1208,6 +1253,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
 	uint64_t swd;
+	bool verify_data_left = false;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
@@ -1224,8 +1270,16 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing any data to avoid that a zone reset has to be issued while
 	 * writing data, which causes data loss.
 	 */
-	if (td->o.verify != VERIFY_NONE && td->runstate != TD_VERIFYING)
-		zbd_reset_zones(td, f, zb, ze);
+	if (td->o.verify != VERIFY_NONE) {
+		verify_data_left = td->runstate == TD_VERIFYING ||
+			td->io_hist_len || td->verify_batch;
+		if (td->io_hist_len && td->o.verify_backlog)
+			verify_data_left =
+				td->io_hist_len % td->o.verify_backlog;
+		if (!verify_data_left)
+			zbd_reset_zones(td, f, zb, ze);
+	}
+
 	zbd_reset_write_cnt(td, f);
 }
 
@@ -1368,7 +1422,7 @@ found_candidate_zone:
 	/* Both z->mutex and zbdi->mutex are held. */
 
 examine_zone:
-	if (z->wp + min_bs <= zbd_zone_capacity_end(z)) {
+	if (zbd_zone_remainder(z) >= min_bs) {
 		pthread_mutex_unlock(&zbdi->mutex);
 		goto out;
 	}
@@ -1433,7 +1487,7 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
+		if (zbd_zone_remainder(z) >= min_bs)
 			goto out;
 		pthread_mutex_lock(&zbdi->mutex);
 	}
@@ -1476,42 +1530,6 @@ out:
 	return z;
 }
 
-/* The caller must hold z->mutex. */
-static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
-						    struct io_u *io_u,
-						    struct fio_zone_info *z)
-{
-	const struct fio_file *f = io_u->file;
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
-
-	if (!zbd_open_zone(td, f, z)) {
-		zone_unlock(z);
-		z = zbd_convert_to_open_zone(td, io_u);
-		assert(z);
-	}
-
-	if (z->verify_block * min_bs >= z->capacity) {
-		log_err("%s: %d * %"PRIu64" >= %"PRIu64"\n",
-			f->file_name, z->verify_block, min_bs, z->capacity);
-		/*
-		 * If the assertion below fails during a test run, adding
-		 * "--experimental_verify=1" to the command line may help.
-		 */
-		assert(false);
-	}
-
-	io_u->offset = z->start + z->verify_block * min_bs;
-	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
-		log_err("%s: %llu + %llu >= %"PRIu64"\n",
-			f->file_name, io_u->offset, io_u->buflen,
-			zbd_zone_capacity_end(z));
-		assert(false);
-	}
-	z->verify_block += io_u->buflen / min_bs;
-
-	return z;
-}
-
 /*
  * Find another zone which has @min_bytes of readable data. Search in zones
  * @zb + 1 .. @zl. For random workload, also search in zones @zb - 1 .. @zf.
@@ -1862,10 +1880,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		if (td->runstate == TD_VERIFYING && td_write(td)) {
-			zb = zbd_replay_write_order(td, io_u, zb);
+		if (td->runstate == TD_VERIFYING && td_write(td))
 			goto accept;
-		}
 
 		/*
 		 * Check that there is enough written data in the zone to do an
@@ -1941,6 +1957,33 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto eof;
 		}
 
+retry:
+		if (zbd_zone_remainder(zb) > 0 &&
+		    zbd_zone_remainder(zb) < min_bs) {
+			pthread_mutex_lock(&f->zbd_info->mutex);
+			zbd_close_zone(td, f, zb);
+			pthread_mutex_unlock(&f->zbd_info->mutex);
+			dprint(FD_ZBD,
+			       "%s: finish zone %d\n",
+			       f->file_name, zbd_zone_idx(f, zb));
+			io_u_quiesce(td);
+			zbd_finish_zone(td, f, zb);
+			if (zbd_zone_idx(f, zb) + 1 >= f->max_zone) {
+				if (!td_random(td))
+					goto eof;
+			}
+			zone_unlock(zb);
+
+			/* Find the next write pointer zone */
+			do {
+				zb++;
+				if (zbd_zone_idx(f, zb) >= f->max_zone)
+					zb = zbd_get_zone(f, f->min_zone);
+			} while (!zb->has_wp);
+
+			zone_lock(td, f, zb);
+		}
+
 		if (!zbd_open_zone(td, f, zb)) {
 			zone_unlock(zb);
 			zb = zbd_convert_to_open_zone(td, io_u);
@@ -1951,6 +1994,10 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			}
 		}
 
+		if (zbd_zone_remainder(zb) > 0 &&
+		    zbd_zone_remainder(zb) < min_bs)
+			goto retry;
+
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
 			if (zbdi->wp_sectors_with_data >= f->io_size * td->o.zrt.u.f &&
@@ -1960,7 +2007,19 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
-			assert(td->o.verify == VERIFY_NONE);
+			if (td->o.verify != VERIFY_NONE) {
+				/*
+				 * Unset io-u->file to tell get_next_verify()
+				 * that this IO is not requeue.
+				 */
+				io_u->file = NULL;
+				if (!get_next_verify(td, io_u)) {
+					zone_unlock(zb);
+					return io_u_accept;
+				}
+				io_u->file = f;
+			}
+
 			/*
 			 * Since previous write requests may have been submitted
 			 * asynchronously and since we will submit the zone
diff --git a/zbd.h b/zbd.h
index 0a73b41d..d425707e 100644
--- a/zbd.h
+++ b/zbd.h
@@ -25,7 +25,6 @@ enum io_u_action {
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
  * @capacity: maximum size usable from the start of a zone (bytes)
- * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
@@ -39,7 +38,6 @@ struct fio_zone_info {
 	uint64_t		start;
 	uint64_t		wp;
 	uint64_t		capacity;
-	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		has_wp:1;
