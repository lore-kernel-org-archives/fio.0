Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40136 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeAFNA3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 6 Jan 2018 08:00:29 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eXo5I-00070f-Rb
        for fio@vger.kernel.org; Sat, 06 Jan 2018 13:00:28 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180106130002.893302C0113@kernel.dk>
Date: Sat,  6 Jan 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c619c0fdb28fbe043d7a7f75bba2ea82b4eca298:

  Merge branch 'percentiles' of https://github.com/sitsofe/fio (2018-01-02 09:05:44 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 57a61cd0e4c5f131cfe75587d8b995191d87ba57:

  verify: don't adjust verification length based on interval when unaligned (2018-01-05 13:38:40 -0700)

----------------------------------------------------------------
Jeff Furlong (1):
      Fix client/server "all clients" reporting

Jens Axboe (2):
      Change bluestop link to be https
      verify: don't adjust verification length based on interval when unaligned

 README    | 4 +++-
 client.c  | 1 +
 gclient.c | 1 +
 init.c    | 1 +
 server.c  | 1 +
 stat.c    | 2 ++
 verify.c  | 8 ++++++--
 7 files changed, 15 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 72ff465..fc28b16 100644
--- a/README
+++ b/README
@@ -120,7 +120,9 @@ Solaris:
 
 Windows:
 	Rebecca Cran <rebecca+fio@bluestop.org> has fio packages for Windows at
-	http://www.bluestop.org/fio/ .
+	https://www.bluestop.org/fio/ . The latest builds for Windows can also
+	be grabbed from https://ci.appveyor.com/project/axboe/fio by clicking
+	the latest x86 or x64 build, then selecting the ARTIFACTS tab.
 
 BSDs:
 	Packages for BSDs may be available from their binary package repositories.
diff --git a/client.c b/client.c
index 18247ef..6fe6d9f 100644
--- a/client.c
+++ b/client.c
@@ -1024,6 +1024,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	client_ts.thread_number = p->ts.thread_number;
 	client_ts.groupid = p->ts.groupid;
 	client_ts.unified_rw_rep = p->ts.unified_rw_rep;
+	client_ts.sig_figs = p->ts.sig_figs;
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
diff --git a/gclient.c b/gclient.c
index ab7aa10..70dda48 100644
--- a/gclient.c
+++ b/gclient.c
@@ -298,6 +298,7 @@ static void gfio_thread_status_op(struct fio_client *client,
 	client_ts.members++;
 	client_ts.thread_number = p->ts.thread_number;
 	client_ts.groupid = p->ts.groupid;
+	client_ts.sig_figs = p->ts.sig_figs;
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
diff --git a/init.c b/init.c
index decd3b4..8a80138 100644
--- a/init.c
+++ b/init.c
@@ -1472,6 +1472,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	td->ts.lat_percentiles = o->lat_percentiles;
 	td->ts.percentile_precision = o->percentile_precision;
 	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_list));
+	td->ts.sig_figs = o->sig_figs;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		td->ts.clat_stat[i].min_val = ULONG_MAX;
diff --git a/server.c b/server.c
index 54d703d..ce9dca3 100644
--- a/server.c
+++ b/server.c
@@ -1443,6 +1443,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 	dst->unit_base	= cpu_to_le32(src->unit_base);
 	dst->groupid	= cpu_to_le32(src->groupid);
 	dst->unified_rw_rep	= cpu_to_le32(src->unified_rw_rep);
+	dst->sig_figs	= cpu_to_le32(src->sig_figs);
 }
 
 /*
diff --git a/stat.c b/stat.c
index cc171a4..509bd6d 100644
--- a/stat.c
+++ b/stat.c
@@ -1490,6 +1490,8 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->kb_base = src->kb_base;
 	if (!dst->unit_base)
 		dst->unit_base = src->unit_base;
+	if (!dst->sig_figs)
+		dst->sig_figs = src->sig_figs;
 }
 
 void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
diff --git a/verify.c b/verify.c
index 2faeaad..b178450 100644
--- a/verify.c
+++ b/verify.c
@@ -87,8 +87,13 @@ static unsigned int get_hdr_inc(struct thread_data *td, struct io_u *io_u)
 {
 	unsigned int hdr_inc;
 
+	/*
+	 * If we use bs_unaligned, buflen can be larger than the verify
+	 * interval (which just defaults to the smallest blocksize possible).
+	 */
 	hdr_inc = io_u->buflen;
-	if (td->o.verify_interval && td->o.verify_interval <= io_u->buflen)
+	if (td->o.verify_interval && td->o.verify_interval <= io_u->buflen &&
+	    !td->o.bs_unaligned)
 		hdr_inc = td->o.verify_interval;
 
 	return hdr_inc;
@@ -1175,7 +1180,6 @@ static void fill_hdr(struct thread_data *td, struct io_u *io_u,
 		     struct verify_header *hdr, unsigned int header_num,
 		     unsigned int header_len, uint64_t rand_seed)
 {
-
 	if (td->o.verify != VERIFY_PATTERN_NO_HDR)
 		__fill_hdr(td, io_u, hdr, header_num, header_len, rand_seed);
 }
