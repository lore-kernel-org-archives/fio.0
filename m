Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdKWNA0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Nov 2017 08:00:26 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eHr7B-00013h-M2
        for fio@vger.kernel.org; Thu, 23 Nov 2017 13:00:25 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171123130002.BD44F2C011A@kernel.dk>
Date: Thu, 23 Nov 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 40e5f1bf1aca5970528724873a4544c43712a75d:

  Merge branch 'libpmem' (2017-11-17 09:21:19 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b9c153b9023c3de65f01aeac4d1e993986a7107e:

  Merge branch 'cleanup' of https://github.com/sitsofe/fio (2017-11-22 19:58:21 -0700)

----------------------------------------------------------------
Jeff Furlong (1):
      add significant_figures parameter

Jens Axboe (1):
      Merge branch 'cleanup' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      HOWTO: fix up broken formatting in logging options
      doc: reword buffer_compress_percentage, buffer_compress_chunk, dedupe_percentage

Stephen Bates (1):
      rdma: Add bind option

 HOWTO            | 63 ++++++++++++++++++++++++++++++++++++-------------------
 cconv.c          |  2 ++
 client.c         |  4 ++++
 engines/rdma.c   | 64 +++++++++++++++++++++++++++++++++++++++++++++-----------
 eta.c            |  4 ++--
 fio.1            | 45 ++++++++++++++++++++++++++-------------
 gclient.c        | 54 +++++++++++++++++++++++------------------------
 init.c           | 12 +++++------
 options.c        | 13 ++++++++++++
 server.c         |  2 ++
 stat.c           | 32 +++++++++++++++-------------
 stat.h           |  5 +++++
 thread_options.h |  4 ++++
 13 files changed, 205 insertions(+), 99 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index dce96bc..4d3a8c8 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1434,9 +1434,12 @@ Buffers and memory
 .. option:: refill_buffers
 
 	If this option is given, fio will refill the I/O buffers on every
-	submit. The default is to only fill it at init time and reuse that
-	data. Only makes sense if zero_buffers isn't specified, naturally. If data
-	verification is enabled, `refill_buffers` is also automatically enabled.
+	submit. Only makes sense if :option:`zero_buffers` isn't specified,
+	naturally. Defaults to being unset i.e., the buffer is only filled at
+	init time and the data in it is reused when possible but if any of
+	:option:`verify`, :option:`buffer_compress_percentage` or
+	:option:`dedupe_percentage` are enabled then `refill_buffers` is also
+	automatically enabled.
 
 .. option:: scramble_buffers=bool
 
@@ -1448,23 +1451,30 @@ Buffers and memory
 
 .. option:: buffer_compress_percentage=int
 
-	If this is set, then fio will attempt to provide I/O buffer content (on
-	WRITEs) that compresses to the specified level. Fio does this by providing a
-	mix of random data and a fixed pattern. The fixed pattern is either zeros,
-	or the pattern specified by :option:`buffer_pattern`. If the pattern option
-	is used, it might skew the compression ratio slightly. Note that this is per
-	block size unit, see :option:`buffer_compress_chunk` for setting a finer
-	granularity of compression regions.
+	If this is set, then fio will attempt to provide I/O buffer content
+	(on WRITEs) that compresses to the specified level. Fio does this by
+	providing a mix of random data followed by fixed pattern data. The
+	fixed pattern is either zeros, or the pattern specified by
+	:option:`buffer_pattern`. If the `buffer_pattern` option is used, it
+	might skew the compression ratio slightly. Setting
+	`buffer_compress_percentage` to a value other than 100 will also
+	enable :option:`refill_buffers` in order to reduce the likelihood that
+	adjacent blocks are so similar that they over compress when seen
+	together. See :option:`buffer_compress_chunk` for how to set a finer or
+	coarser granularity for the random/fixed data region. Defaults to unset
+	i.e., buffer data will not adhere to any compression level.
 
 .. option:: buffer_compress_chunk=int
 
-	See :option:`buffer_compress_percentage`. This setting allows fio to manage
-	how big the ranges of random data and zeroed data is. Without this set, fio
-	will provide :option:`buffer_compress_percentage` of blocksize random data,
-	followed by the remaining zeroed. With this set to some chunk size smaller
-	than the block size, fio can alternate random and zeroed data throughout the
-	I/O buffer. This is particularly useful when bigger block sizes are used
-	for a job. Defaults to 512.
+	This setting allows fio to manage how big the random/fixed data region
+	is when using :option:`buffer_compress_percentage`. When
+	`buffer_compress_chunk` is set to some non-zero value smaller than the
+	block size, fio can repeat the random/fixed region throughout the I/O
+	buffer at the specified interval (which particularly useful when
+	bigger block sizes are used for a job). When set to 0, fio will use a
+	chunk size that matches the block size resulting in a single
+	random/fixed region within the I/O buffer. Defaults to 512. When the
+	unit is omitted, the value is interpreted in bytes.
 
 .. option:: buffer_pattern=str
 
@@ -1501,7 +1511,9 @@ Buffers and memory
 	writing. These buffers will be naturally dedupable. The contents of the
 	buffers depend on what other buffer compression settings have been set. It's
 	possible to have the individual buffers either fully compressible, or not at
-	all. This option only controls the distribution of unique buffers.
+	all -- this option only controls the distribution of unique buffers. Setting
+	this option will also enable :option:`refill_buffers` to prevent every buffer
+	being identical.
 
 .. option:: invalidate=bool
 
@@ -2748,8 +2760,8 @@ Measurements and reporting
 .. option:: write_lat_log=str
 
 	Same as :option:`write_bw_log`, except this option creates I/O
-	submission (e.g., `file:`name_slat.x.log`), completion (e.g.,
-	`file:`name_clat.x.log`), and total (e.g., `file:`name_lat.x.log`)
+	submission (e.g., :file:`name_slat.x.log`), completion (e.g.,
+	:file:`name_clat.x.log`), and total (e.g., :file:`name_lat.x.log`)
 	latency files instead. See :option:`write_bw_log` for details about
 	the filename format and `Log File Formats`_ for how data is structured
 	within the files.
@@ -2757,7 +2769,7 @@ Measurements and reporting
 .. option:: write_hist_log=str
 
 	Same as :option:`write_bw_log` but writes an I/O completion latency
-	histogram file (e.g., `file:`name_hist.x.log`) instead. Note that this
+	histogram file (e.g., :file:`name_hist.x.log`) instead. Note that this
 	file will be empty unless :option:`log_hist_msec` has also been set.
 	See :option:`write_bw_log` for details about the filename format and
 	`Log File Formats`_ for how data is structured within the file.
@@ -2765,7 +2777,7 @@ Measurements and reporting
 .. option:: write_iops_log=str
 
 	Same as :option:`write_bw_log`, but writes an IOPS file (e.g.
-	`file:`name_iops.x.log`) instead. See :option:`write_bw_log` for
+	:file:`name_iops.x.log`) instead. See :option:`write_bw_log` for
 	details about the filename format and `Log File Formats`_ for how data
 	is structured within the file.
 
@@ -2909,6 +2921,13 @@ Measurements and reporting
 	completion latency below which 99.5% and 99.9% of the observed latencies
 	fell, respectively.
 
+.. option:: significant_figures=int
+
+	If using :option:`--output-format` of `normal`, set the significant figures 
+	to this	value. Higher values will yield more precise IOPS and throughput 
+	units, while lower values will round. Requires a minimum value of 1 and a 
+	maximum value of 10. Defaults to 4.
+
 
 Error handling
 ~~~~~~~~~~~~~~
diff --git a/cconv.c b/cconv.c
index dc3c4e6..1a41dc3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -270,6 +270,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->clat_percentiles = le32_to_cpu(top->clat_percentiles);
 	o->lat_percentiles = le32_to_cpu(top->lat_percentiles);
 	o->percentile_precision = le32_to_cpu(top->percentile_precision);
+	o->sig_figs = le32_to_cpu(top->sig_figs);
 	o->continue_on_error = le32_to_cpu(top->continue_on_error);
 	o->cgroup_weight = le32_to_cpu(top->cgroup_weight);
 	o->cgroup_nodelete = le32_to_cpu(top->cgroup_nodelete);
@@ -458,6 +459,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->clat_percentiles = cpu_to_le32(o->clat_percentiles);
 	top->lat_percentiles = cpu_to_le32(o->lat_percentiles);
 	top->percentile_precision = cpu_to_le32(o->percentile_precision);
+	top->sig_figs = cpu_to_le32(o->sig_figs);
 	top->continue_on_error = cpu_to_le32(o->continue_on_error);
 	top->cgroup_weight = cpu_to_le32(o->cgroup_weight);
 	top->cgroup_nodelete = cpu_to_le32(o->cgroup_nodelete);
diff --git a/client.c b/client.c
index 779fb9d..11fa262 100644
--- a/client.c
+++ b/client.c
@@ -942,6 +942,8 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->kb_base		= le32_to_cpu(src->kb_base);
 	dst->unit_base		= le32_to_cpu(src->unit_base);
 
+	dst->sig_figs		= le32_to_cpu(src->sig_figs);
+
 	dst->latency_depth	= le32_to_cpu(src->latency_depth);
 	dst->latency_target	= le64_to_cpu(src->latency_target);
 	dst->latency_window	= le64_to_cpu(src->latency_window);
@@ -982,6 +984,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 
 	dst->kb_base	= le32_to_cpu(src->kb_base);
 	dst->unit_base	= le32_to_cpu(src->unit_base);
+	dst->sig_figs	= le32_to_cpu(src->sig_figs);
 	dst->groupid	= le32_to_cpu(src->groupid);
 	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
 }
@@ -1167,6 +1170,7 @@ static void convert_jobs_eta(struct jobs_eta *je)
 	je->nr_threads		= le32_to_cpu(je->nr_threads);
 	je->is_pow2		= le32_to_cpu(je->is_pow2);
 	je->unit_base		= le32_to_cpu(je->unit_base);
+	je->sig_figs		= le32_to_cpu(je->sig_figs);
 }
 
 void fio_client_sum_jobs_eta(struct jobs_eta *dst, struct jobs_eta *je)
diff --git a/engines/rdma.c b/engines/rdma.c
index da00cba..6b173a8 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -59,6 +59,7 @@ struct rdmaio_options {
 	struct thread_data *td;
 	unsigned int port;
 	enum rdma_io_mode verb;
+	char *bindname;
 };
 
 static int str_hostname_cb(void *data, const char *input)
@@ -82,6 +83,16 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_RDMA,
 	},
 	{
+		.name	= "bindname",
+		.lname	= "rdma engine bindname",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct rdmaio_options, bindname),
+		.help	= "Bind for RDMA IO engine",
+		.def    = "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_RDMA,
+	},
+	{
 		.name	= "port",
 		.lname	= "rdma engine port",
 		.type	= FIO_OPT_INT,
@@ -1004,30 +1015,53 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+static int aton(struct thread_data *td, const char *host,
+		     struct sockaddr_in *addr)
+{
+	if (inet_aton(host, &addr->sin_addr) != 1) {
+		struct hostent *hent;
+
+		hent = gethostbyname(host);
+		if (!hent) {
+			td_verror(td, errno, "gethostbyname");
+			return 1;
+		}
+
+		memcpy(&addr->sin_addr, hent->h_addr, 4);
+	}
+	return 0;
+}
+
 static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 				    unsigned short port)
 {
 	struct rdmaio_data *rd = td->io_ops_data;
+	struct rdmaio_options *o = td->eo;
+	struct sockaddr_storage addrb;
 	struct ibv_recv_wr *bad_wr;
 	int err;
 
 	rd->addr.sin_family = AF_INET;
 	rd->addr.sin_port = htons(port);
 
-	if (inet_aton(host, &rd->addr.sin_addr) != 1) {
-		struct hostent *hent;
+	err = aton(td, host, &rd->addr);
+	if (err)
+		return err;
 
-		hent = gethostbyname(host);
-		if (!hent) {
-			td_verror(td, errno, "gethostbyname");
-			return 1;
-		}
+	/* resolve route */
+	if (strcmp(o->bindname, "") != 0) {
+		addrb.ss_family = AF_INET;
+		err = aton(td, o->bindname, (struct sockaddr_in *)&addrb);
+		if (err)
+			return err;
+		err = rdma_resolve_addr(rd->cm_id, (struct sockaddr *)&addrb,
+					(struct sockaddr *)&rd->addr, 2000);
 
-		memcpy(&rd->addr.sin_addr, hent->h_addr, 4);
+	} else {
+		err = rdma_resolve_addr(rd->cm_id, NULL,
+					(struct sockaddr *)&rd->addr, 2000);
 	}
 
-	/* resolve route */
-	err = rdma_resolve_addr(rd->cm_id, NULL, (struct sockaddr *)&rd->addr, 2000);
 	if (err != 0) {
 		log_err("fio: rdma_resolve_addr: %d\n", err);
 		return 1;
@@ -1072,15 +1106,20 @@ static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 {
 	struct rdmaio_data *rd = td->io_ops_data;
+	struct rdmaio_options *o = td->eo;
 	struct ibv_recv_wr *bad_wr;
 	int state = td->runstate;
 
 	td_set_runstate(td, TD_SETTING_UP);
 
 	rd->addr.sin_family = AF_INET;
-	rd->addr.sin_addr.s_addr = htonl(INADDR_ANY);
 	rd->addr.sin_port = htons(port);
 
+	if (strcmp(o->bindname, "") == 0)
+		rd->addr.sin_addr.s_addr = htonl(INADDR_ANY);
+	else
+		rd->addr.sin_addr.s_addr = htonl(*o->bindname);
+
 	/* rdma_listen */
 	if (rdma_bind_addr(rd->cm_id, (struct sockaddr *)&rd->addr) != 0) {
 		log_err("fio: rdma_bind_addr fail: %m\n");
@@ -1155,7 +1194,8 @@ static int compat_options(struct thread_data *td)
 {
 	// The original RDMA engine had an ugly / seperator
 	// on the filename for it's options. This function
-	// retains backwards compatibility with it.100
+	// retains backwards compatibility with it. Note we do not
+	// support setting the bindname option is this legacy mode.
 
 	struct rdmaio_options *o = td->eo;
 	char *modep, *portp;
diff --git a/eta.c b/eta.c
index baaa681..1b0b000 100644
--- a/eta.c
+++ b/eta.c
@@ -537,9 +537,9 @@ void display_thread_status(struct jobs_eta *je)
 		char *tr, *mr;
 
 		mr = num2str(je->m_rate[0] + je->m_rate[1] + je->m_rate[2],
-				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
 		tr = num2str(je->t_rate[0] + je->t_rate[1] + je->t_rate[2],
-				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
 
 		p += sprintf(p, ", %s-%s", mr, tr);
 		free(tr);
diff --git a/fio.1 b/fio.1
index bd7670a..3224e9a 100644
--- a/fio.1
+++ b/fio.1
@@ -1237,22 +1237,29 @@ more clever block compression attempts, but it will stop naive dedupe of
 blocks. Default: true.
 .TP
 .BI buffer_compress_percentage \fR=\fPint
-If this is set, then fio will attempt to provide I/O buffer content (on
-WRITEs) that compresses to the specified level. Fio does this by providing a
-mix of random data and a fixed pattern. The fixed pattern is either zeros,
-or the pattern specified by \fBbuffer_pattern\fR. If the pattern option
-is used, it might skew the compression ratio slightly. Note that this is per
-block size unit, see \fBbuffer_compress_chunk\fR for setting a finer granularity
-of compressible regions.
+If this is set, then fio will attempt to provide I/O buffer content
+(on WRITEs) that compresses to the specified level. Fio does this by
+providing a mix of random data followed by fixed pattern data. The
+fixed pattern is either zeros, or the pattern specified by
+\fBbuffer_pattern\fR. If the \fBbuffer_pattern\fR option is used, it
+might skew the compression ratio slightly. Setting
+\fBbuffer_compress_percentage\fR to a value other than 100 will also
+enable \fBrefill_buffers\fR in order to reduce the likelihood that
+adjacent blocks are so similar that they over compress when seen
+together. See \fBbuffer_compress_chunk\fR for how to set a finer or
+coarser granularity of the random/fixed data regions. Defaults to unset
+i.e., buffer data will not adhere to any compression level.
 .TP
 .BI buffer_compress_chunk \fR=\fPint
-See \fBbuffer_compress_percentage\fR. This setting allows fio to manage
-how big the ranges of random data and zeroed data is. Without this set, fio
-will provide \fBbuffer_compress_percentage\fR of blocksize random data,
-followed by the remaining zeroed. With this set to some chunk size smaller
-than the block size, fio can alternate random and zeroed data throughout the
-I/O buffer. This is particularly useful when bigger block sizes are used
-for a job. Defaults to 512.
+This setting allows fio to manage how big the random/fixed data region
+is when using \fBbuffer_compress_percentage\fR. When
+\fBbuffer_compress_chunk\fR is set to some non-zero value smaller than the
+block size, fio can repeat the random/fixed region throughout the I/O
+buffer at the specified interval (which particularly useful when
+bigger block sizes are used for a job). When set to 0, fio will use a
+chunk size that matches the block size resulting in a single
+random/fixed region within the I/O buffer. Defaults to 512. When the
+unit is omitted, the value is interpreted in bytes.
 .TP
 .BI buffer_pattern \fR=\fPstr
 If set, fio will fill the I/O buffers with this pattern or with the contents
@@ -1295,7 +1302,9 @@ If set, fio will generate this percentage of identical buffers when
 writing. These buffers will be naturally dedupable. The contents of the
 buffers depend on what other buffer compression settings have been set. It's
 possible to have the individual buffers either fully compressible, or not at
-all. This option only controls the distribution of unique buffers.
+all \-\- this option only controls the distribution of unique buffers. Setting
+this option will also enable \fBrefill_buffers\fR to prevent every buffer
+being identical.
 .TP
 .BI invalidate \fR=\fPbool
 Invalidate the buffer/page cache parts of the files to be used prior to
@@ -2586,6 +2595,12 @@ numbers, and list the numbers in ascending order. For example,
 `\-\-percentile_list=99.5:99.9' will cause fio to report the values of
 completion latency below which 99.5% and 99.9% of the observed latencies
 fell, respectively.
+.TP
+.BI significant_figures \fR=\fPint
+If using \fB\-\-output\-format\fR of `normal', set the significant figures 
+to this value. Higher values will yield more precise IOPS and throughput 
+units, while lower values will round. Requires a minimum value of 1 and a 
+maximum value of 10. Defaults to 4.
 .SS "Error handling"
 .TP
 .BI exitall_on_error
diff --git a/gclient.c b/gclient.c
index daa9153..ab7aa10 100644
--- a/gclient.c
+++ b/gclient.c
@@ -379,24 +379,24 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 			sprintf(output, "%3.1f%% done", perc);
 		}
 
-		iops_str[0] = num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
-		iops_str[1] = num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
-		iops_str[2] = num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
+		iops_str[0] = num2str(je->iops[0], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[1] = num2str(je->iops[1], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[2] = num2str(je->iops[2], je->sig_figs, 1, 0, N2S_PERSEC);
 
-		rate_str[0] = num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[0] = num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[0] = num2str(je->rate[0], je->sig_figs, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[0] = num2str(je->rate[0], je->sig_figs, 10, !i2p, N2S_BYTEPERSEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_iops), iops_str[0]);
 
-		rate_str[1] = num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[1] = num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[1] = num2str(je->rate[1], je->sig_figs, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[1] = num2str(je->rate[1], je->sig_figs, 10, !i2p, N2S_BYTEPERSEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_iops), iops_str[1]);
 
-		rate_str[2] = num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[2] = num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[2] = num2str(je->rate[2], je->sig_figs, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[2] = num2str(je->rate[2], je->sig_figs, 10, !i2p, N2S_BYTEPERSEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_iops), iops_str[2]);
@@ -463,24 +463,24 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 			sprintf(output, "%3.1f%% done", perc);
 		}
 
-		iops_str[0] = num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
-		iops_str[1] = num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
-		iops_str[2] = num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
+		iops_str[0] = num2str(je->iops[0], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[1] = num2str(je->iops[1], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[2] = num2str(je->iops[2], je->sig_figs, 1, 0, N2S_PERSEC);
 
-		rate_str[0] = num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[0] = num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[0] = num2str(je->rate[0], je->sig_figs, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[0] = num2str(je->rate[0], je->sig_figs, 10, !i2p, N2S_BYTEPERSEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_iops), iops_str[0]);
 
-		rate_str[1] = num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[1] = num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[1] = num2str(je->rate[1], je->sig_figs, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[1] = num2str(je->rate[1], je->sig_figs, 10, !i2p, N2S_BYTEPERSEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_iops), iops_str[1]);
 
-		rate_str[2] = num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[2] = num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[2] = num2str(je->rate[2], je->sig_figs, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[2] = num2str(je->rate[2], je->sig_figs, 10, !i2p, N2S_BYTEPERSEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_iops), iops_str[2]);
@@ -587,10 +587,10 @@ static void gfio_add_job_op(struct fio_client *client, struct fio_net_cmd *cmd)
 	multitext_add_entry(&ge->eta.iotype, tmp);
 
 	i2p = is_power_of_2(o->kb_base);
-	c1 = num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-	c2 = num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-	c3 = num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
-	c4 = num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+	c1 = num2str(o->min_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+	c2 = num2str(o->max_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+	c3 = num2str(o->min_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
+	c4 = num2str(o->max_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
 
 	sprintf(tmp, "%s-%s,%s-%s", c1, c2, c3, c4);
 	free(c1);
@@ -1183,7 +1183,7 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	bw = (1000 * ts->io_bytes[ddir]) / runt;
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p = num2str(iops, 4, 1, 0, N2S_PERSEC);
+	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_PERSEC);
 
 	box = gtk_hbox_new(FALSE, 3);
 	gtk_box_pack_start(GTK_BOX(mbox), box, TRUE, FALSE, 3);
@@ -1198,14 +1198,14 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	gtk_box_pack_start(GTK_BOX(main_vbox), box, TRUE, FALSE, 3);
 
 	label = new_info_label_in_frame(box, "IO");
-	io_p = num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
-	io_palt = num2str(ts->io_bytes[ddir], 4, 1, !i2p, N2S_BYTE);
+	io_p = num2str(ts->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
+	io_palt = num2str(ts->io_bytes[ddir], ts->sig_figs, 1, !i2p, N2S_BYTE);
 	snprintf(tmp, sizeof(tmp), "%s (%s)", io_p, io_palt);
 	gtk_label_set_text(GTK_LABEL(label), tmp);
 
 	label = new_info_label_in_frame(box, "Bandwidth");
-	bw_p = num2str(bw, 4, 1, i2p, ts->unit_base);
-	bw_palt = num2str(bw, 4, 1, !i2p, ts->unit_base);
+	bw_p = num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
+	bw_palt = num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
 	snprintf(tmp, sizeof(tmp), "%s (%s)", bw_p, bw_palt);
 	gtk_label_set_text(GTK_LABEL(label), tmp);
 
diff --git a/init.c b/init.c
index 736c6ff..b7e9c0e 100644
--- a/init.c
+++ b/init.c
@@ -1589,14 +1589,14 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 				char *c5 = NULL, *c6 = NULL;
 				int i2p = is_power_of_2(o->kb_base);
 
-				c1 = num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-				c2 = num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-				c3 = num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
-				c4 = num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+				c1 = num2str(o->min_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+				c2 = num2str(o->max_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+				c3 = num2str(o->min_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
+				c4 = num2str(o->max_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
 
 				if (!o->bs_is_seq_rand) {
-					c5 = num2str(o->min_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
-					c6 = num2str(o->max_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
+					c5 = num2str(o->min_bs[DDIR_TRIM], o->sig_figs, 1, i2p, N2S_BYTE);
+					c6 = num2str(o->max_bs[DDIR_TRIM], o->sig_figs, 1, i2p, N2S_BYTE);
 				}
 
 				log_info("%s: (g=%d): rw=%s, ", td->o.name,
diff --git a/options.c b/options.c
index a0fcd8f..7caccb3 100644
--- a/options.c
+++ b/options.c
@@ -4127,6 +4127,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_STAT,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "significant_figures",
+		.lname	= "Significant figures",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, sig_figs),
+		.maxval	= 10,
+		.minval	= 1,
+		.help	= "Significant figures for output-format set to normal",
+		.def	= "4",
+		.interval = 1,
+		.category = FIO_OPT_C_STAT,
+		.group	= FIO_OPT_G_INVALID,
+	},
 
 #ifdef FIO_HAVE_DISK_UTIL
 	{
diff --git a/server.c b/server.c
index e6ea4cd..967cebe 100644
--- a/server.c
+++ b/server.c
@@ -1538,6 +1538,8 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.latency_window	= cpu_to_le64(ts->latency_window);
 	p.ts.latency_percentile.u.i = cpu_to_le64(fio_double_to_uint64(ts->latency_percentile.u.f));
 
+	p.ts.sig_figs		= cpu_to_le32(ts->sig_figs);
+
 	p.ts.nr_block_infos	= cpu_to_le64(ts->nr_block_infos);
 	for (i = 0; i < p.ts.nr_block_infos; i++)
 		p.ts.block_infos[i] = cpu_to_le32(ts->block_infos[i]);
diff --git a/stat.c b/stat.c
index 89e2e6c..48d8e7d 100644
--- a/stat.c
+++ b/stat.c
@@ -299,14 +299,14 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		if (!rs->max_run[i])
 			continue;
 
-		io = num2str(rs->iobytes[i], 4, 1, i2p, N2S_BYTE);
-		ioalt = num2str(rs->iobytes[i], 4, 1, !i2p, N2S_BYTE);
-		agg = num2str(rs->agg[i], 4, 1, i2p, rs->unit_base);
-		aggalt = num2str(rs->agg[i], 4, 1, !i2p, rs->unit_base);
-		min = num2str(rs->min_bw[i], 4, 1, i2p, rs->unit_base);
-		minalt = num2str(rs->min_bw[i], 4, 1, !i2p, rs->unit_base);
-		max = num2str(rs->max_bw[i], 4, 1, i2p, rs->unit_base);
-		maxalt = num2str(rs->max_bw[i], 4, 1, !i2p, rs->unit_base);
+		io = num2str(rs->iobytes[i], rs->sig_figs, 1, i2p, N2S_BYTE);
+		ioalt = num2str(rs->iobytes[i], rs->sig_figs, 1, !i2p, N2S_BYTE);
+		agg = num2str(rs->agg[i], rs->sig_figs, 1, i2p, rs->unit_base);
+		aggalt = num2str(rs->agg[i], rs->sig_figs, 1, !i2p, rs->unit_base);
+		min = num2str(rs->min_bw[i], rs->sig_figs, 1, i2p, rs->unit_base);
+		minalt = num2str(rs->min_bw[i], rs->sig_figs, 1, !i2p, rs->unit_base);
+		max = num2str(rs->max_bw[i], rs->sig_figs, 1, i2p, rs->unit_base);
+		maxalt = num2str(rs->max_bw[i], rs->sig_figs, 1, !i2p, rs->unit_base);
 		log_buf(out, "%s: bw=%s (%s), %s-%s (%s-%s), io=%s (%s), run=%llu-%llumsec\n",
 				rs->unified_rw_rep ? "  MIXED" : str[i],
 				agg, aggalt, min, max, minalt, maxalt, io, ioalt,
@@ -435,12 +435,12 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	runt = ts->runtime[ddir];
 
 	bw = (1000 * ts->io_bytes[ddir]) / runt;
-	io_p = num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
-	bw_p = num2str(bw, 4, 1, i2p, ts->unit_base);
-	bw_p_alt = num2str(bw, 4, 1, !i2p, ts->unit_base);
+	io_p = num2str(ts->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
+	bw_p = num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
+	bw_p_alt = num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p = num2str(iops, 4, 1, 0, N2S_NONE);
+	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
 
 	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)\n",
 			rs->unified_rw_rep ? "mixed" : str[ddir],
@@ -738,9 +738,9 @@ static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 	bw_mean = steadystate_bw_mean(ts);
 	iops_mean = steadystate_iops_mean(ts);
 
-	p1 = num2str(bw_mean / ts->kb_base, 4, ts->kb_base, i2p, ts->unit_base);
-	p1alt = num2str(bw_mean / ts->kb_base, 4, ts->kb_base, !i2p, ts->unit_base);
-	p2 = num2str(iops_mean, 4, 1, 0, N2S_NONE);
+	p1 = num2str(bw_mean / ts->kb_base, ts->sig_figs, ts->kb_base, i2p, ts->unit_base);
+	p1alt = num2str(bw_mean / ts->kb_base, ts->sig_figs, ts->kb_base, !i2p, ts->unit_base);
+	p2 = num2str(iops_mean, ts->sig_figs, 1, 0, N2S_NONE);
 
 	log_buf(out, "  steadystate  : attained=%s, bw=%s (%s), iops=%s, %s%s=%.3f%s\n",
 		ts->ss_state & __FIO_SS_ATTAINED ? "yes" : "no",
@@ -1690,6 +1690,7 @@ void __show_run_stats(void)
 
 			ts->kb_base = td->o.kb_base;
 			ts->unit_base = td->o.unit_base;
+			ts->sig_figs = td->o.sig_figs;
 			ts->unified_rw_rep = td->o.unified_rw_rep;
 		} else if (ts->kb_base != td->o.kb_base && !kb_base_warned) {
 			log_info("fio: kb_base differs for jobs in group, using"
@@ -1752,6 +1753,7 @@ void __show_run_stats(void)
 		rs = &runstats[ts->groupid];
 		rs->kb_base = ts->kb_base;
 		rs->unit_base = ts->unit_base;
+		rs->sig_figs = ts->sig_figs;
 		rs->unified_rw_rep += ts->unified_rw_rep;
 
 		for (j = 0; j < DDIR_RWDIR_CNT; j++) {
diff --git a/stat.h b/stat.h
index 6ddcad2..ba66c40 100644
--- a/stat.h
+++ b/stat.h
@@ -11,6 +11,7 @@ struct group_run_stats {
 	uint64_t agg[DDIR_RWDIR_CNT];
 	uint32_t kb_base;
 	uint32_t unit_base;
+	uint32_t sig_figs;
 	uint32_t groupid;
 	uint32_t unified_rw_rep;
 } __attribute__((packed));
@@ -221,6 +222,8 @@ struct thread_stat {
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
 
+	uint32_t sig_figs;
+
 	uint64_t ss_dur;
 	uint32_t ss_state;
 	uint32_t ss_head;
@@ -257,6 +260,8 @@ struct jobs_eta {
 	uint32_t is_pow2;
 	uint32_t unit_base;
 
+	uint32_t sig_figs;
+
 	uint32_t files_open;
 
 	/*
diff --git a/thread_options.h b/thread_options.h
index 5a037bf..ca549b5 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -309,6 +309,8 @@ struct thread_options {
 	unsigned long long latency_window;
 	fio_fp64_t latency_percentile;
 
+	unsigned int sig_figs;
+
 	unsigned block_error_hist;
 
 	unsigned int replay_align;
@@ -584,6 +586,8 @@ struct thread_options_pack {
 	uint64_t latency_window;
 	fio_fp64_t latency_percentile;
 
+	uint32_t sig_figs;
+
 	uint32_t block_error_hist;
 
 	uint32_t replay_align;
