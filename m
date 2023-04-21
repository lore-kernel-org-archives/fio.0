Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8629CC77B75
	for <fio@archiver.kernel.org>; Fri, 21 Apr 2023 12:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjDUMAQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Apr 2023 08:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjDUMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Apr 2023 08:00:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A06A3
        for <fio@vger.kernel.org>; Fri, 21 Apr 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=nwtUPvG/HbdbovtQFVan41S7M3Egwr7EpcDc0B2VhtU=; b=Ot/xHR5Y+/nWVz4NvhzLopjc+y
        qj2/HpjBbaC0U47kGKd6vypYTXPdzgojCalqBethYiSsbtz73vjkZSN0pPX2xqmbhrlyYx2OI3zXI
        k6Tp/odJ4hRonM6E5MMDcxXbibNZiH/glfGSgI/abLjKWUE4zVkcIL7R7cGLmE7nFIrou/tBaHTAW
        5CxyRu7QMvqJ+fereVo6JIn3oN3KNL7l3GRGnucGPiPPlFUVaim+FSUD2iEa/8ORsQtOhYsFsXALv
        /2tcl3kq3i8VwdBOgwEu1YPVC/0K8k1SlJxeI7JXw6CsgIM71Pwv4gGHsIu6UUDX3LYmAu2ERTlnI
        C5/+fPUQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pppQq-005Hu9-17
        for fio@vger.kernel.org;
        Fri, 21 Apr 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 667811BC0161; Fri, 21 Apr 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230421120001.667811BC0161@kernel.dk>
Date:   Fri, 21 Apr 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7624d58953d38612c11496551a855a1aeee7ad24:

  docs: update documentation for randrepeat and allrandrepeat (2023-04-13 13:38:52 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 073974b24aac23610e9e13e3eb56438ad108ab31:

  filesetup: better handle non-uniform distributions (2023-04-20 15:24:39 +0000)

----------------------------------------------------------------
Vincent Fu (5):
      ci: disable __thread support for Windows msys2 build
      engines: cleanup casts and move memset
      engines: separate declaration and assignment
      fio: replace malloc+memset with calloc
      filesetup: better handle non-uniform distributions

 .appveyor.yml        |  4 +++-
 client.c             |  6 ++----
 configure            |  7 ++++++-
 engines/e4defrag.c   |  3 +--
 engines/io_uring.c   |  3 +--
 engines/libhdfs.c    |  3 +--
 engines/libiscsi.c   |  3 +--
 engines/net.c        |  4 +---
 engines/nfs.c        |  6 ++----
 engines/null.c       |  6 +++---
 engines/posixaio.c   |  8 +++-----
 engines/rdma.c       | 22 +++++++---------------
 engines/solarisaio.c |  7 +++----
 engines/sync.c       |  3 +--
 eta.c                |  6 ++----
 filesetup.c          |  8 +++-----
 gfio.c               |  3 +--
 graph.c              |  3 +--
 init.c               |  3 +--
 t/io_uring.c         |  3 +--
 t/lfsr-test.c        |  3 +--
 verify.c             |  3 +--
 22 files changed, 46 insertions(+), 71 deletions(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 92301ca9..a63cf24f 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -6,9 +6,11 @@ image:
 environment:
   CYG_MIRROR: http://cygwin.mirror.constant.com
   matrix:
+# --disable-tls for the msys2 build to work around
+# breakage with clang/lld 16.0.0-1
     - ARCHITECTURE: x64
       CC: clang
-      CONFIGURE_OPTIONS: --enable-pdb
+      CONFIGURE_OPTIONS: --enable-pdb --disable-tls
       DISTRO: msys2
 # Skip 32 bit clang build
 #    - ARCHITECTURE: x86
diff --git a/client.c b/client.c
index 51496c77..7cd2ba66 100644
--- a/client.c
+++ b/client.c
@@ -369,8 +369,7 @@ static struct fio_client *get_new_client(void)
 {
 	struct fio_client *client;
 
-	client = malloc(sizeof(*client));
-	memset(client, 0, sizeof(*client));
+	client = calloc(1, sizeof(*client));
 
 	INIT_FLIST_HEAD(&client->list);
 	INIT_FLIST_HEAD(&client->hash_list);
@@ -793,8 +792,7 @@ static int __fio_client_send_remote_ini(struct fio_client *client,
 	dprint(FD_NET, "send remote ini %s to %s\n", filename, client->hostname);
 
 	p_size = sizeof(*pdu) + strlen(filename) + 1;
-	pdu = malloc(p_size);
-	memset(pdu, 0, p_size);
+	pdu = calloc(1, p_size);
 	pdu->name_len = strlen(filename);
 	strcpy((char *) pdu->file, filename);
 	pdu->client_type = cpu_to_le16((uint16_t) client->type);
diff --git a/configure b/configure
index 45d10a31..abb6d016 100755
--- a/configure
+++ b/configure
@@ -264,6 +264,8 @@ for opt do
   ;;
   --seed-buckets=*) seed_buckets="$optarg"
   ;;
+  --disable-tls) tls_check="no"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -313,6 +315,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-dfs           Disable DAOS File System support even if found"
   echo "--enable-asan           Enable address sanitizer"
   echo "--seed-buckets=         Number of seed buckets for the refill-buffer"
+  echo "--disable-tls		Disable __thread local storage"
   exit $exit_val
 fi
 
@@ -1549,7 +1552,8 @@ print_config "socklen_t" "$socklen_t"
 if test "$tls_thread" != "yes" ; then
   tls_thread="no"
 fi
-cat > $TMPC << EOF
+if test "$tls_check" != "no"; then
+  cat > $TMPC << EOF
 #include <stdio.h>
 static __thread int ret;
 int main(int argc, char **argv)
@@ -1560,6 +1564,7 @@ EOF
 if compile_prog "" "" "__thread"; then
   tls_thread="yes"
 fi
+fi
 print_config "__thread" "$tls_thread"
 
 ##########################################
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 0a0004d0..37cc2ada 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -77,12 +77,11 @@ static int fio_e4defrag_init(struct thread_data *td)
 		return 1;
 	}
 
-	ed = malloc(sizeof(*ed));
+	ed = calloc(1, sizeof(*ed));
 	if (!ed) {
 		td_verror(td, ENOMEM, "io_queue_init");
 		return 1;
 	}
-	memset(ed, 0 ,sizeof(*ed));
 
 	if (td->o.directory)
 		len = sprintf(donor_name, "%s/", td->o.directory);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 7f743c2a..f5ffe9f4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -800,11 +800,10 @@ static void fio_ioring_probe(struct thread_data *td)
 	/* default to off, as that's always safe */
 	o->nonvectored = 0;
 
-	p = malloc(sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	p = calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
 	if (!p)
 		return;
 
-	memset(p, 0, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
 	ret = syscall(__NR_io_uring_register, ld->ring_fd,
 			IORING_REGISTER_PROBE, p, 256);
 	if (ret < 0)
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index f20e45ca..d0a26840 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -315,8 +315,7 @@ static int fio_hdfsio_setup(struct thread_data *td)
 	uint64_t file_size, total_file_size;
 
 	if (!td->io_ops_data) {
-		hd = malloc(sizeof(*hd));
-		memset(hd, 0, sizeof(*hd));
+		hd = calloc(1, sizeof(*hd));
 		
 		hd->curr_file_id = -1;
 
diff --git a/engines/libiscsi.c b/engines/libiscsi.c
index c97b5709..37c9b55a 100644
--- a/engines/libiscsi.c
+++ b/engines/libiscsi.c
@@ -68,8 +68,7 @@ static int fio_iscsi_setup_lun(struct iscsi_info *iscsi_info,
 	struct scsi_readcapacity16	*rc16	    = NULL;
 	int				 ret	    = 0;
 
-	iscsi_lun = malloc(sizeof(struct iscsi_lun));
-	memset(iscsi_lun, 0, sizeof(struct iscsi_lun));
+	iscsi_lun = calloc(1, sizeof(struct iscsi_lun));
 
 	iscsi_lun->iscsi_info = iscsi_info;
 
diff --git a/engines/net.c b/engines/net.c
index c6cec584..fec53d74 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1370,9 +1370,7 @@ static int fio_netio_setup(struct thread_data *td)
 	}
 
 	if (!td->io_ops_data) {
-		nd = malloc(sizeof(*nd));
-
-		memset(nd, 0, sizeof(*nd));
+		nd = calloc(1, sizeof(*nd));
 		nd->listenfd = -1;
 		nd->pipes[0] = nd->pipes[1] = -1;
 		td->io_ops_data = nd;
diff --git a/engines/nfs.c b/engines/nfs.c
index 336e670b..970962a3 100644
--- a/engines/nfs.c
+++ b/engines/nfs.c
@@ -224,8 +224,7 @@ static int do_mount(struct thread_data *td, const char *url)
 		return -1;
 	}
 
-	options->events = malloc(event_size);
-	memset(options->events, 0, event_size);
+	options->events = calloc(1, event_size);
 
 	options->prev_requested_event_index = -1;
 	options->queue_depth = td->o.iodepth;
@@ -278,8 +277,7 @@ static int fio_libnfs_open(struct thread_data *td, struct fio_file *f)
 			options->nfs_url, ret, nfs_get_error(options->context));
 		return ret;
 	}
-	nfs_data = malloc(sizeof(struct nfs_data));
-	memset(nfs_data, 0, sizeof(struct nfs_data));
+	nfs_data = calloc(1, sizeof(struct nfs_data));
 	nfs_data->options = options;
 
 	if (td->o.td_ddir == TD_DDIR_WRITE)
diff --git a/engines/null.c b/engines/null.c
index 68759c26..7236ec94 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -106,13 +106,13 @@ static void null_cleanup(struct null_data *nd)
 
 static struct null_data *null_init(struct thread_data *td)
 {
-	struct null_data *nd = (struct null_data *) malloc(sizeof(*nd));
+	struct null_data *nd;
+	nd = malloc(sizeof(*nd));
 
 	memset(nd, 0, sizeof(*nd));
 
 	if (td->o.iodepth != 1) {
-		nd->io_us = (struct io_u **) malloc(td->o.iodepth * sizeof(struct io_u *));
-		memset(nd->io_us, 0, td->o.iodepth * sizeof(struct io_u *));
+		nd->io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
 		td->io_ops->flags |= FIO_ASYNCIO_SETS_ISSUE_TIME;
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 135d088c..0f4eea68 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -197,11 +197,9 @@ static void fio_posixaio_cleanup(struct thread_data *td)
 
 static int fio_posixaio_init(struct thread_data *td)
 {
-	struct posixaio_data *pd = malloc(sizeof(*pd));
-
-	memset(pd, 0, sizeof(*pd));
-	pd->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
-	memset(pd->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
+	struct posixaio_data *pd;
+	pd = calloc(1, sizeof(*pd));
+	pd->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 
 	td->io_ops_data = pd;
 	return 0;
diff --git a/engines/rdma.c b/engines/rdma.c
index fcb41068..ee2844d3 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -1296,23 +1296,18 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 	if ((rd->rdma_protocol == FIO_RDMA_MEM_WRITE) ||
 	    (rd->rdma_protocol == FIO_RDMA_MEM_READ)) {
-		rd->rmt_us =
-			malloc(FIO_RDMA_MAX_IO_DEPTH * sizeof(struct remote_u));
-		memset(rd->rmt_us, 0,
-			FIO_RDMA_MAX_IO_DEPTH * sizeof(struct remote_u));
+		rd->rmt_us = calloc(FIO_RDMA_MAX_IO_DEPTH,
+				    sizeof(struct remote_u));
 		rd->rmt_nr = 0;
 	}
 
-	rd->io_us_queued = malloc(td->o.iodepth * sizeof(struct io_u *));
-	memset(rd->io_us_queued, 0, td->o.iodepth * sizeof(struct io_u *));
+	rd->io_us_queued = calloc(td->o.iodepth, sizeof(struct io_u *));
 	rd->io_u_queued_nr = 0;
 
-	rd->io_us_flight = malloc(td->o.iodepth * sizeof(struct io_u *));
-	memset(rd->io_us_flight, 0, td->o.iodepth * sizeof(struct io_u *));
+	rd->io_us_flight = calloc(td->o.iodepth, sizeof(struct io_u *));
 	rd->io_u_flight_nr = 0;
 
-	rd->io_us_completed = malloc(td->o.iodepth * sizeof(struct io_u *));
-	memset(rd->io_us_completed, 0, td->o.iodepth * sizeof(struct io_u *));
+	rd->io_us_completed = calloc(td->o.iodepth, sizeof(struct io_u *));
 	rd->io_u_completed_nr = 0;
 
 	if (td_read(td)) {	/* READ as the server */
@@ -1339,8 +1334,7 @@ static int fio_rdmaio_post_init(struct thread_data *td)
 	for (i = 0; i < td->io_u_freelist.nr; i++) {
 		struct io_u *io_u = td->io_u_freelist.io_us[i];
 
-		io_u->engine_data = malloc(sizeof(struct rdma_io_u_data));
-		memset(io_u->engine_data, 0, sizeof(struct rdma_io_u_data));
+		io_u->engine_data = calloc(1, sizeof(struct rdma_io_u_data));
 		((struct rdma_io_u_data *)io_u->engine_data)->wr_id = i;
 
 		io_u->mr = ibv_reg_mr(rd->pd, io_u->buf, max_bs,
@@ -1386,9 +1380,7 @@ static int fio_rdmaio_setup(struct thread_data *td)
 	}
 
 	if (!td->io_ops_data) {
-		rd = malloc(sizeof(*rd));
-
-		memset(rd, 0, sizeof(*rd));
+		rd = calloc(1, sizeof(*rd));
 		init_rand_seed(&rd->rand_state, (unsigned int) GOLDEN_RATIO_64, 0);
 		td->io_ops_data = rd;
 	}
diff --git a/engines/solarisaio.c b/engines/solarisaio.c
index 21e95935..b2b47fed 100644
--- a/engines/solarisaio.c
+++ b/engines/solarisaio.c
@@ -185,8 +185,9 @@ static void fio_solarisaio_init_sigio(void)
 
 static int fio_solarisaio_init(struct thread_data *td)
 {
-	struct solarisaio_data *sd = malloc(sizeof(*sd));
 	unsigned int max_depth;
+	struct solarisaio_data *sd;
+	sd = calloc(1, sizeof(*sd));
 
 	max_depth = td->o.iodepth;
 	if (max_depth > MAXASYNCHIO) {
@@ -195,9 +196,7 @@ static int fio_solarisaio_init(struct thread_data *td)
 							max_depth);
 	}
 
-	memset(sd, 0, sizeof(*sd));
-	sd->aio_events = malloc(max_depth * sizeof(struct io_u *));
-	memset(sd->aio_events, 0, max_depth * sizeof(struct io_u *));
+	sd->aio_events = calloc(max_depth, sizeof(struct io_u *));
 	sd->max_depth = max_depth;
 
 #ifdef USE_SIGNAL_COMPLETIONS
diff --git a/engines/sync.c b/engines/sync.c
index 339ba999..d1999122 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -402,8 +402,7 @@ static int fio_vsyncio_init(struct thread_data *td)
 {
 	struct syncio_data *sd;
 
-	sd = malloc(sizeof(*sd));
-	memset(sd, 0, sizeof(*sd));
+	sd = calloc(1, sizeof(*sd));
 	sd->last_offset = -1ULL;
 	sd->iovecs = malloc(td->o.iodepth * sizeof(struct iovec));
 	sd->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
diff --git a/eta.c b/eta.c
index ce1c6f2d..af4027e0 100644
--- a/eta.c
+++ b/eta.c
@@ -409,8 +409,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	if (!ddir_rw_sum(disp_io_bytes))
 		fill_start_time(&disp_prev_time);
 
-	eta_secs = malloc(thread_number * sizeof(uint64_t));
-	memset(eta_secs, 0, thread_number * sizeof(uint64_t));
+	eta_secs = calloc(thread_number, sizeof(uint64_t));
 
 	je->elapsed_sec = (mtime_since_genesis() + 999) / 1000;
 
@@ -692,10 +691,9 @@ struct jobs_eta *get_jobs_eta(bool force, size_t *size)
 		return NULL;
 
 	*size = sizeof(*je) + THREAD_RUNSTR_SZ + 8;
-	je = malloc(*size);
+	je = calloc(1, *size);
 	if (!je)
 		return NULL;
-	memset(je, 0, *size);
 
 	if (!calc_thread_status(je, force)) {
 		free(je);
diff --git a/filesetup.c b/filesetup.c
index 8e505941..816d1081 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -303,13 +303,12 @@ static bool pre_read_file(struct thread_data *td, struct fio_file *f)
 	if (bs > left)
 		bs = left;
 
-	b = malloc(bs);
+	b = calloc(1, bs);
 	if (!b) {
 		td_verror(td, errno, "malloc");
 		ret = false;
 		goto error;
 	}
-	memset(b, 0, bs);
 
 	if (lseek(f->fd, f->file_offset, SEEK_SET) < 0) {
 		td_verror(td, errno, "lseek");
@@ -1448,9 +1447,8 @@ static void __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 
 	nranges = (fsize + range_size - 1ULL) / range_size;
 
-	seed = jhash(f->file_name, strlen(f->file_name), 0) * td->thread_number;
-	if (!td->o.rand_repeatable)
-		seed = td->rand_seeds[FIO_RAND_BLOCK_OFF];
+	seed = jhash(f->file_name, strlen(f->file_name), 0) * td->thread_number *
+		td->rand_seeds[FIO_RAND_BLOCK_OFF];
 
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
 		zipf_init(&f->zipf, nranges, td->o.zipf_theta.u.f, td->o.random_center.u.f, seed);
diff --git a/gfio.c b/gfio.c
index 22c5314d..10c9b094 100644
--- a/gfio.c
+++ b/gfio.c
@@ -730,8 +730,7 @@ static struct gui_entry *alloc_new_gui_entry(struct gui *ui)
 {
 	struct gui_entry *ge;
 
-	ge = malloc(sizeof(*ge));
-	memset(ge, 0, sizeof(*ge));
+	ge = calloc(1, sizeof(*ge));
 	ge->state = GE_STATE_NEW;
 	ge->ui = ui;
 	return ge;
diff --git a/graph.c b/graph.c
index c49cdae1..3d2b6c96 100644
--- a/graph.c
+++ b/graph.c
@@ -713,8 +713,7 @@ static void graph_label_add_value(struct graph_label *i, void *value,
 	struct graph *g = i->parent;
 	struct graph_value *x;
 
-	x = malloc(sizeof(*x));
-	memset(x, 0, sizeof(*x));
+	x = calloc(1, sizeof(*x));
 	INIT_FLIST_HEAD(&x->alias);
 	INIT_FLIST_HEAD(&x->list);
 	flist_add_tail(&x->list, &i->value_list);
diff --git a/init.c b/init.c
index 48121f14..437406ec 100644
--- a/init.c
+++ b/init.c
@@ -1946,8 +1946,7 @@ static int __parse_jobs_ini(struct thread_data *td,
 	 * it's really 256 + small bit, 280 should suffice
 	 */
 	if (!nested) {
-		name = malloc(280);
-		memset(name, 0, 280);
+		name = calloc(1, 280);
 	}
 
 	opts = NULL;
diff --git a/t/io_uring.c b/t/io_uring.c
index f9f4b840..6b0efef8 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -487,11 +487,10 @@ static void io_uring_probe(int fd)
 	struct io_uring_probe *p;
 	int ret;
 
-	p = malloc(sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	p = calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
 	if (!p)
 		return;
 
-	memset(p, 0, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
 	ret = syscall(__NR_io_uring_register, fd, IORING_REGISTER_PROBE, p, 256);
 	if (ret < 0)
 		goto out;
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 4b255e19..632de383 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -78,8 +78,7 @@ int main(int argc, char *argv[])
 	/* Create verification table */
 	if (verify) {
 		v_size = numbers * sizeof(uint8_t);
-		v = malloc(v_size);
-		memset(v, 0, v_size);
+		v = calloc(1, v_size);
 		printf("\nVerification table is %lf KiB\n", (double)(v_size) / 1024);
 	}
 	v_start = v;
diff --git a/verify.c b/verify.c
index e7e4c69c..2848b686 100644
--- a/verify.c
+++ b/verify.c
@@ -1595,8 +1595,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 	*sz = sizeof(*rep);
 	*sz += nr * sizeof(struct thread_io_list);
 	*sz += depth * sizeof(struct file_comp);
-	rep = malloc(*sz);
-	memset(rep, 0, *sz);
+	rep = calloc(1, *sz);
 
 	rep->threads = cpu_to_le64((uint64_t) nr);
 
