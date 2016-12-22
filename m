Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:60068 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755509AbcLVGHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:30 -0500
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id C7736606AB
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:29 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id DF3FF7D
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:36 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 11/12] Improve IEC binary and SI decimal prefix handling
Date: Thu, 22 Dec 2016 00:08:52 -0600
Message-Id: <20161222060853.64104-12-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Use kb_base=1000 to follow international standards for unit prefixes.

To specify power-of-10 decimal values defined in the International
System of Units (SI):
	Ki means kilo (K) or 1000
	Mi means mega (M) or 1000**2
	Gi means giga (G) or 1000**3
	Ti means tera (T) or 1000**4
	Pi means peta (P) or 1000**5

To specify power-of-2 binary values defined in IEC 80000-13:
	k means kibi (Ki) or 1024
	M means mebi (Mi) or 1024**2
	G means gibi (Gi) or 1024**3
	T means tebi (Ti) or 1024**4
	P means pebi (Pi) or 1024**5

For example, this specifies a blocksize of 4096 bytes:
	kb_base=1000
	bs=4KiB

With kb_base=1024 (the default), the unit prefixes are opposite from
those specified in the SI and IEC 80000-13 standards to provide
compatibility with old scripts.  For example, this specifies a
blocksize of 4096 bytes:
	kb_base=1024
	bs=4K

For outputs printing quantities and bandwidths:
* eta stats only use the preferred prefix
* final stats include both (non-preferred prefix in parenthesis)
* in gfio, all windows include both

Text outputs are rearranged to try to obviously break any scripts
parsing the output rather than silently confuse them.  The terse
and json outputs, which are intended for parsing, are unchanged.

Old:
Jobs: 576 (f=576), CR=86.4GB/576MB KB/s: [w(288),r(288)] [0.0% done] [33884MB/27114MB/0KB /s] [8471K/6778K/0 iops] [eta 06h:59m:57s]
   read: io=363338MB, bw=34014MB/s, iops=8304.3K, runt= 10682msec
  write: io=282447MB, bw=26225MB/s, iops=6402.7K, runt= 10770msec
   READ: io=363338MB, aggrb=34014MB/s, minb=34014MB/s, maxb=34014MB/s, mint=10682msec, maxt=10682msec
  WRITE: io=282447MB, aggrb=26225MB/s, minb=26225MB/s, maxb=26225MB/s, mint=10770msec, maxt=10770msec

New:
Jobs: 576 (f=576), 590MB/s-89.2GB/s: [w(288),r(288)][0.0%][r=34.2GB/s,w=26.3GB/s][r=8542k,w=6572k IOPS][eta 06h:59m:55s]
   read: IOPS=8362k, BW=34.3GB/s (31.1GiB/s)(665GB/19417msec)
  write: IOPS=6423k, BW=26.4GB/s (24.6GiB/s)(511GB/19431msec)
   READ: bw=34.3GB/s (31.1GiB/s), 34.3GB/s-34.3GB/s (31.1GiB/s-31.1GiB/s), io=665GB (619GiB), run=19417-19417msec
  WRITE: bw=26.4GB/s (24.6GiB/s), 26.4GB/s-26.4GB/s (24.6GiB/s-24.6GiB/s), io=511GB (476GiB), run=19431-19431msec

Documentation changes are in a subsequent patch.
---
 eta.c         |  44 ++++++++++++++-------
 fio.h         |   7 ++++
 gclient.c     | 123 ++++++++++++++++++++++++++++++++++++++--------------------
 init.c        |  39 +++++--------------
 lib/num2str.c |  57 ++++++++++++++++++++-------
 options.c     |   8 ++--
 parse.c       |  40 +++++++++++++------
 stat.c        |  91 ++++++++++++++++++++++++++-----------------
 8 files changed, 259 insertions(+), 150 deletions(-)

diff --git a/eta.c b/eta.c
index 68dc0c9..1d66163 100644
--- a/eta.c
+++ b/eta.c
@@ -530,19 +530,28 @@ void display_thread_status(struct jobs_eta *je)
 	}
 
 	p += sprintf(p, "Jobs: %d (f=%d)", je->nr_running, je->files_open);
-	if (je->m_rate[0] || je->m_rate[1] || je->t_rate[0] || je->t_rate[1]) {
+
+	/* rate limits, if any */
+	if (je->m_rate[0] || je->m_rate[1] || je->m_rate[2] ||
+	    je->t_rate[0] || je->t_rate[1] || je->t_rate[2]) {
 		char *tr, *mr;
 
-		mr = num2str(je->m_rate[0] + je->m_rate[1], 4, 0, je->is_pow2, 8);
-		tr = num2str(je->t_rate[0] + je->t_rate[1], 4, 0, je->is_pow2, 8);
-		p += sprintf(p, ", CR=%s/%s KB/s", tr, mr);
+		mr = num2str(je->m_rate[0] + je->m_rate[1] + je->m_rate[2],
+				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+		tr = num2str(je->t_rate[0] + je->t_rate[1] + je->t_rate[2],
+				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+
+		p += sprintf(p, ", %s-%s", mr, tr);
 		free(tr);
 		free(mr);
-	} else if (je->m_iops[0] || je->m_iops[1] || je->t_iops[0] || je->t_iops[1]) {
-		p += sprintf(p, ", CR=%d/%d IOPS",
-					je->t_iops[0] + je->t_iops[1],
-					je->m_iops[0] + je->m_iops[1]);
+	} else if (je->m_iops[0] || je->m_iops[1] || je->m_iops[2] ||
+		   je->t_iops[0] || je->t_iops[1] || je->t_iops[2]) {
+		p += sprintf(p, ", %d-%d IOPS",
+					je->m_iops[0] + je->m_iops[1] + je->m_iops[2],
+					je->t_iops[0] + je->t_iops[1] + je->t_iops[2]);
 	}
+
+	/* current run string, % done, bandwidth, iops, eta */
 	if (je->eta_sec != INT_MAX && je->nr_running) {
 		char perc_str[32];
 		char *iops_str[DDIR_RWDIR_CNT];
@@ -553,7 +562,7 @@ void display_thread_status(struct jobs_eta *je)
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running ||
 		    je->eta_sec == -1)
-			strcpy(perc_str, "-.-% done");
+			strcpy(perc_str, "-.-%");
 		else {
 			double mult = 100.0;
 
@@ -562,22 +571,31 @@ void display_thread_status(struct jobs_eta *je)
 
 			eta_good = 1;
 			perc *= mult;
-			sprintf(perc_str, "%3.1f%% done", perc);
+			sprintf(perc_str, "%3.1f%%", perc);
 		}
 
 		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
-			rate_str[ddir] = num2str(je->rate[ddir], 5,
+			rate_str[ddir] = num2str(je->rate[ddir], 4,
 						1024, je->is_pow2, je->unit_base);
-			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, 0);
+			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, N2S_NONE);
 		}
 
 		left = sizeof(output) - (p - output) - 1;
 
-		l = snprintf(p, left, ": [%s] [%s] [%s/%s/%s /s] [%s/%s/%s iops] [eta %s]",
+		if (je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM])
+			l = snprintf(p, left,
+				": [%s][%s][r=%s,w=%s,t=%s][r=%s,w=%s,t=%s IOPS][eta %s]",
 				je->run_str, perc_str, rate_str[DDIR_READ],
 				rate_str[DDIR_WRITE], rate_str[DDIR_TRIM],
 				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
 				iops_str[DDIR_TRIM], eta_str);
+		else
+			l = snprintf(p, left,
+				": [%s][%s][r=%s,w=%s][r=%s,w=%s IOPS][eta %s]",
+				je->run_str, perc_str,
+				rate_str[DDIR_READ], rate_str[DDIR_WRITE],
+				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
+				eta_str);
 		p += l;
 		if (l >= 0 && l < linelen_last)
 			p += sprintf(p, "%*s", linelen_last - l, "");
diff --git a/fio.h b/fio.h
index df17074..62ff7ab 100644
--- a/fio.h
+++ b/fio.h
@@ -535,6 +535,13 @@ extern uintptr_t page_size;
 extern int initialize_fio(char *envp[]);
 extern void deinitialize_fio(void);
 
+#define N2S_NONE	0
+#define N2S_BITPERSEC 	1	/* match unit_base for bit rates */
+#define N2S_PERSEC	2
+#define N2S_BIT		3
+#define N2S_BYTE	4
+#define N2S_BYTEPERSEC 	8	/* match unit_base for byte rates */
+
 #define FIO_GETOPT_JOB		0x89000000
 #define FIO_GETOPT_IOENGINE	0x98000000
 #define FIO_NR_OPTIONS		(FIO_MAX_OPTS + 128)
diff --git a/gclient.c b/gclient.c
index 59b0404..5ce33d0 100644
--- a/gclient.c
+++ b/gclient.c
@@ -367,6 +367,8 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 	if (je->eta_sec != INT_MAX && je->nr_running) {
 		char *iops_str[DDIR_RWDIR_CNT];
 		char *rate_str[DDIR_RWDIR_CNT];
+		char *rate_alt[DDIR_RWDIR_CNT];
+		char tmp[128];
 		int i;
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running)
@@ -377,19 +379,26 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 			sprintf(output, "%3.1f%% done", perc);
 		}
 
-		rate_str[0] = num2str(je->rate[0], 5, 10, i2p, 0);
-		rate_str[1] = num2str(je->rate[1], 5, 10, i2p, 0);
-		rate_str[2] = num2str(je->rate[2], 5, 10, i2p, 0);
+		iops_str[0] = num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
+		iops_str[1] = num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
+		iops_str[2] = num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
 
-		iops_str[0] = num2str(je->iops[0], 4, 1, 0, 0);
-		iops_str[1] = num2str(je->iops[1], 4, 1, 0, 0);
-		iops_str[2] = num2str(je->iops[2], 4, 1, 0, 0);
-
-		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_bw), rate_str[0]);
+		rate_str[0] = num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[0] = num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
+		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_iops), iops_str[0]);
-		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_bw), rate_str[1]);
+
+		rate_str[1] = num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[1] = num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
+		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_iops), iops_str[1]);
-		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_bw), rate_str[2]);
+
+		rate_str[2] = num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[2] = num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
+		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_iops), iops_str[2]);
 
 		graph_add_xy_data(ge->graphs.iops_graph, ge->graphs.read_iops, je->elapsed_sec, je->iops[0], iops_str[0]);
@@ -401,6 +410,7 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 			free(rate_str[i]);
+			free(rate_alt[i]);
 			free(iops_str[i]);
 		}
 	}
@@ -440,8 +450,10 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 	entry_set_int_value(ui->eta.jobs, je->nr_running);
 
 	if (je->eta_sec != INT_MAX && je->nr_running) {
-		char *iops_str[3];
-		char *rate_str[3];
+		char *iops_str[DDIR_RWDIR_CNT];
+		char *rate_str[DDIR_RWDIR_CNT];
+		char *rate_alt[DDIR_RWDIR_CNT];
+		char tmp[128];
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running)
 			strcpy(output, "-.-% done");
@@ -451,19 +463,26 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 			sprintf(output, "%3.1f%% done", perc);
 		}
 
-		rate_str[0] = num2str(je->rate[0], 5, 10, i2p, 0);
-		rate_str[1] = num2str(je->rate[1], 5, 10, i2p, 0);
-		rate_str[2] = num2str(je->rate[2], 5, 10, i2p, 0);
-
-		iops_str[0] = num2str(je->iops[0], 4, 1, 0, 0);
-		iops_str[1] = num2str(je->iops[1], 4, 1, 0, 0);
-		iops_str[2] = num2str(je->iops[2], 4, 1, 0, 0);
+		iops_str[0] = num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
+		iops_str[1] = num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
+		iops_str[2] = num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
 
-		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_bw), rate_str[0]);
+		rate_str[0] = num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[0] = num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
+		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_iops), iops_str[0]);
-		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_bw), rate_str[1]);
+
+		rate_str[1] = num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[1] = num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
+		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_iops), iops_str[1]);
-		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_bw), rate_str[2]);
+
+		rate_str[2] = num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[2] = num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
+		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_iops), iops_str[2]);
 
 		graph_add_xy_data(ui->graphs.iops_graph, ui->graphs.read_iops, je->elapsed_sec, je->iops[0], iops_str[0]);
@@ -475,6 +494,7 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 			free(rate_str[i]);
+			free(rate_alt[i]);
 			free(iops_str[i]);
 		}
 	}
@@ -552,6 +572,7 @@ static void gfio_add_job_op(struct fio_client *client, struct fio_net_cmd *cmd)
 	struct thread_options *o;
 	char *c1, *c2, *c3, *c4;
 	char tmp[80];
+	int i2p;
 
 	p->thread_number = le32_to_cpu(p->thread_number);
 	p->groupid = le32_to_cpu(p->groupid);
@@ -565,11 +586,13 @@ static void gfio_add_job_op(struct fio_client *client, struct fio_net_cmd *cmd)
 	sprintf(tmp, "%s %s", o->odirect ? "direct" : "buffered", ddir_str(o->td_ddir));
 	multitext_add_entry(&ge->eta.iotype, tmp);
 
-	c1 = fio_uint_to_kmg(o->min_bs[DDIR_READ]);
-	c2 = fio_uint_to_kmg(o->max_bs[DDIR_WRITE]);
-	c3 = fio_uint_to_kmg(o->min_bs[DDIR_READ]);
-	c4 = fio_uint_to_kmg(o->max_bs[DDIR_WRITE]);
-	sprintf(tmp, "%s-%s/%s-%s", c1, c2, c3, c4);
+	i2p = is_power_of_2(o->kb_base);
+	c1 = num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+	c2 = num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+	c3 = num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+	c4 = num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+
+	sprintf(tmp, "%s-%s,%s-%s", c1, c2, c3, c4);
 	free(c1);
 	free(c2);
 	free(c3);
@@ -971,8 +994,8 @@ static void gfio_show_lat(GtkWidget *vbox, const char *name, unsigned long min,
 	if (usec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
 
-	minp = num2str(min, 6, 1, 0, 0);
-	maxp = num2str(max, 6, 1, 0, 0);
+	minp = num2str(min, 6, 1, 0, N2S_NONE);
+	maxp = num2str(max, 6, 1, 0, N2S_NONE);
 
 	sprintf(tmp, "%s %s", name, base);
 	frame = gtk_frame_new(tmp);
@@ -1133,7 +1156,8 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	unsigned long long bw, iops;
 	unsigned int flags = 0;
 	double mean[3], dev[3];
-	char *io_p, *bw_p, *iops_p;
+	char *io_p, *io_palt, *bw_p, *bw_palt, *iops_p;
+	char tmp[128];
 	int i2p;
 
 	if (!ts->runtime[ddir])
@@ -1143,11 +1167,9 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	runt = ts->runtime[ddir];
 
 	bw = (1000 * ts->io_bytes[ddir]) / runt;
-	io_p = num2str(ts->io_bytes[ddir], 6, 1, i2p, 8);
-	bw_p = num2str(bw, 6, 1, i2p, ts->unit_base);
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p = num2str(iops, 6, 1, 0, 0);
+	iops_p = num2str(iops, 4, 1, 0, N2S_PERSEC);
 
 	box = gtk_hbox_new(FALSE, 3);
 	gtk_box_pack_start(GTK_BOX(mbox), box, TRUE, FALSE, 3);
@@ -1162,9 +1184,17 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	gtk_box_pack_start(GTK_BOX(main_vbox), box, TRUE, FALSE, 3);
 
 	label = new_info_label_in_frame(box, "IO");
-	gtk_label_set_text(GTK_LABEL(label), io_p);
+	io_p = num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
+	io_palt = num2str(ts->io_bytes[ddir], 4, 1, !i2p, N2S_BYTE);
+	snprintf(tmp, sizeof(tmp), "%s (%s)", io_p, io_palt);
+	gtk_label_set_text(GTK_LABEL(label), tmp);
+
 	label = new_info_label_in_frame(box, "Bandwidth");
-	gtk_label_set_text(GTK_LABEL(label), bw_p);
+	bw_p = num2str(bw, 4, 1, i2p, ts->unit_base);
+	bw_palt = num2str(bw, 4, 1, !i2p, ts->unit_base);
+	snprintf(tmp, sizeof(tmp), "%s (%s)", bw_p, bw_palt);
+	gtk_label_set_text(GTK_LABEL(label), tmp);
+
 	label = new_info_label_in_frame(box, "IOPS");
 	gtk_label_set_text(GTK_LABEL(label), iops_p);
 	label = new_info_label_in_frame(box, "Runtime (msec)");
@@ -1172,7 +1202,7 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 
 	if (calc_lat(&ts->bw_stat[ddir], &min[0], &max[0], &mean[0], &dev[0])) {
 		double p_of_agg = 100.0;
-		const char *bw_str = "KB";
+		const char *bw_str = "KiB/s";
 		char tmp[32];
 
 		if (rs->agg[ddir]) {
@@ -1181,14 +1211,21 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 				p_of_agg = 100.0;
 		}
 
-		if (mean[0] > 999999.9) {
-			min[0] /= 1000.0;
-			max[0] /= 1000.0;
-			mean[0] /= 1000.0;
-			dev[0] /= 1000.0;
-			bw_str = "MB";
+		if (mean[0] > 1073741824.9) {
+			min[0] /= 1048576.0;
+			max[0] /= 1048576.0;
+			mean[0] /= 1048576.0;
+			dev[0] /= 1048576.0;
+			bw_str = "GiB/s";
 		}
 
+		if (mean[0] > 1047575.9) {
+			min[0] /= 1024.0;
+			max[0] /= 1024.0;
+			mean[0] /= 1024.0;
+			dev[0] /= 1024.0;
+			bw_str = "MiB/s";
+		}
 		sprintf(tmp, "Bandwidth (%s)", bw_str);
 		frame = gtk_frame_new(tmp);
 		gtk_box_pack_start(GTK_BOX(main_vbox), frame, FALSE, FALSE, 5);
@@ -1238,6 +1275,8 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 
 	free(io_p);
 	free(bw_p);
+	free(io_palt);
+	free(bw_palt);
 	free(iops_p);
 }
 
diff --git a/init.c b/init.c
index f26f35d..3c925a3 100644
--- a/init.c
+++ b/init.c
@@ -31,6 +31,7 @@
 #include "oslib/strcasestr.h"
 
 #include "crc/test.h"
+#include "lib/pow2.h"
 
 const char fio_version_string[] = FIO_VERSION;
 
@@ -865,27 +866,6 @@ static int fixup_options(struct thread_data *td)
 	return ret;
 }
 
-/*
- * This function leaks the buffer
- */
-char *fio_uint_to_kmg(unsigned int val)
-{
-	char *buf = malloc(32);
-	char post[] = { 0, 'K', 'M', 'G', 'P', 'E', 0 };
-	char *p = post;
-
-	do {
-		if (val & 1023)
-			break;
-
-		val >>= 10;
-		p++;
-	} while (*p);
-
-	snprintf(buf, 32, "%u%c", val, *p);
-	return buf;
-}
-
 /* External engines are specified by "external:name.o") */
 static const char *get_engine_name(const char *str)
 {
@@ -1528,15 +1508,16 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			if (!td_ioengine_flagged(td, FIO_NOIO)) {
 				char *c1, *c2, *c3, *c4;
 				char *c5 = NULL, *c6 = NULL;
+				int i2p = is_power_of_2(o->kb_base);
 
-				c1 = fio_uint_to_kmg(o->min_bs[DDIR_READ]);
-				c2 = fio_uint_to_kmg(o->max_bs[DDIR_READ]);
-				c3 = fio_uint_to_kmg(o->min_bs[DDIR_WRITE]);
-				c4 = fio_uint_to_kmg(o->max_bs[DDIR_WRITE]);
+				c1 = num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+				c2 = num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+				c3 = num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+				c4 = num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
 
 				if (!o->bs_is_seq_rand) {
-					c5 = fio_uint_to_kmg(o->min_bs[DDIR_TRIM]);
-					c6 = fio_uint_to_kmg(o->max_bs[DDIR_TRIM]);
+					c5 = num2str(o->min_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
+					c6 = num2str(o->max_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
 				}
 
 				log_info("%s: (g=%d): rw=%s, ", td->o.name,
@@ -1544,10 +1525,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 							ddir_str(o->td_ddir));
 
 				if (o->bs_is_seq_rand)
-					log_info("bs(seq/rand)=%s-%s/%s-%s, ",
+					log_info("bs=%s-%s,%s-%s, bs_is_seq_rand, ",
 							c1, c2, c3, c4);
 				else
-					log_info("bs=%s-%s/%s-%s/%s-%s, ",
+					log_info("bs=%s-%s,%s-%s,%s-%s, ",
 							c1, c2, c3, c4, c5, c6);
 
 				log_info("ioengine=%s, iodepth=%u\n",
diff --git a/lib/num2str.c b/lib/num2str.c
index 0ed05f3..940d4a5 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -6,36 +6,63 @@
 
 #define ARRAY_LENGTH(arr)	sizeof(arr) / sizeof((arr)[0])
 
-/*
- * Cheesy number->string conversion, complete with carry rounding error.
+/**
+ * num2str() - Cheesy number->string conversion, complete with carry rounding error.
+ * @num: quantity (e.g., number of blocks, bytes or bits)
+ * @maxlen: max number of digits in the output string (not counting prefix and units)
+ * @base: multiplier for num (e.g., if num represents Ki, use 1024)
+ * @pow2: select unit prefix - 0=power-of-10 decimal SI, nonzero=power-of-2 binary IEC
+ * @units: select units - N2S_* macros defined in fio.h
+ * @returns a malloc'd buffer containing "number[<unit prefix>][<units>]"
  */
-char *num2str(uint64_t num, int maxlen, int base, int pow2, int unit_base)
+char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 {
-	const char *postfix[] = { "", "K", "M", "G", "P", "E" };
-	const char *byte_postfix[] = { "", "B", "bit" };
+	const char *sistr[] = { "", "k", "M", "G", "T", "P" };
+	const char *iecstr[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi" };
+	const char **unitprefix;
+	const char *unitstr[] = { "", "/s", "B", "bit", "B/s", "bit/s" };
 	const unsigned int thousand[] = { 1000, 1024 };
 	unsigned int modulo, decimals;
-	int byte_post_index = 0, post_index, carry = 0;
+	int unit_index = 0, post_index, carry = 0;
 	char tmp[32];
 	char *buf;
 
+	compiletime_assert(sizeof(sistr) == sizeof(iecstr), "unit prefix arrays must be identical sizes");
+
 	buf = malloc(128);
+	if (!buf)
+		return NULL;
+
+	if (pow2)
+		unitprefix = iecstr;
+	else
+		unitprefix = sistr;
 
 	for (post_index = 0; base > 1; post_index++)
 		base /= thousand[!!pow2];
 
-	switch (unit_base) {
-	case 1:
-		byte_post_index = 2;
+	switch (units) {
+	case N2S_PERSEC:
+		unit_index = 1;
+		break;
+	case N2S_BYTE:
+		unit_index = 2;
+		break;
+	case N2S_BIT:
+		unit_index = 3;
 		num *= 8;
 		break;
-	case 8:
-		byte_post_index = 1;
+	case N2S_BYTEPERSEC:
+		unit_index = 4;
+		break;
+	case N2S_BITPERSEC:
+		unit_index = 5;
+		num *= 8;
 		break;
 	}
 
 	modulo = -1U;
-	while (post_index < sizeof(postfix)) {
+	while (post_index < sizeof(sistr)) {
 		sprintf(tmp, "%llu", (unsigned long long) num);
 		if (strlen(tmp) <= maxlen)
 			break;
@@ -48,11 +75,11 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int unit_base)
 
 	if (modulo == -1U) {
 done:
-		if (post_index >= ARRAY_LENGTH(postfix))
+		if (post_index >= ARRAY_LENGTH(sistr))
 			post_index = 0;
 
 		sprintf(buf, "%llu%s%s", (unsigned long long) num,
-			postfix[post_index], byte_postfix[byte_post_index]);
+			unitprefix[post_index], unitstr[unit_index]);
 		return buf;
 	}
 
@@ -73,6 +100,6 @@ done:
 	} while (1);
 
 	sprintf(buf, "%llu.%u%s%s", (unsigned long long) num, modulo,
-			postfix[post_index], byte_postfix[byte_post_index]);
+			unitprefix[post_index], unitstr[unit_index]);
 	return buf;
 }
diff --git a/options.c b/options.c
index 3830521..0d0d550 100644
--- a/options.c
+++ b/options.c
@@ -4180,20 +4180,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.posval = {
 			  { .ival = "1024",
 			    .oval = 1024,
-			    .help = "Use 1024 as the K base",
+			    .help = "Inputs invert IEC and SI prefixes (for compatibility); outputs prefer binary",
 			  },
 			  { .ival = "1000",
 			    .oval = 1000,
-			    .help = "Use 1000 as the K base",
+			    .help = "Inputs use IEC and SI prefixes; outputs prefer SI",
 			  },
 		},
-		.help	= "How many bytes per KB for reporting (1000 or 1024)",
+		.help	= "Unit prefix interpretation for quantities of data (IEC and SI)",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
 		.name	= "unit_base",
-		.lname	= "Base unit for reporting (Bits or Bytes)",
+		.lname	= "Unit for quantities of data (Bits or Bytes)",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, unit_base),
 		.prio	= 1,
diff --git a/parse.c b/parse.c
index 8ed4619..f67cdf4 100644
--- a/parse.c
+++ b/parse.c
@@ -207,32 +207,50 @@ static unsigned long long __get_mult_bytes(const char *p, void *data,
 		}
 	}
 
+	/* If kb_base is 1000, use true units.
+	 * If kb_base is 1024, use opposite units.
+	 */
 	if (!strncmp("pib", c, 3)) {
 		pow = 5;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
 	} else if (!strncmp("tib", c, 3)) {
 		pow = 4;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
 	} else if (!strncmp("gib", c, 3)) {
 		pow = 3;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
 	} else if (!strncmp("mib", c, 3)) {
 		pow = 2;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
 	} else if (!strncmp("kib", c, 3)) {
 		pow = 1;
-		mult = 1000;
-	} else if (!strncmp("p", c, 1) || !strncmp("pb", c, 2))
+		if (kb_base == 1000)
+			mult = 1024;
+	} else if (!strncmp("p", c, 1) || !strncmp("pb", c, 2)) {
 		pow = 5;
-	else if (!strncmp("t", c, 1) || !strncmp("tb", c, 2))
+		if (kb_base == 1024)
+			mult = 1000;
+	} else if (!strncmp("t", c, 1) || !strncmp("tb", c, 2)) {
 		pow = 4;
-	else if (!strncmp("g", c, 1) || !strncmp("gb", c, 2))
+		if (kb_base == 1024)
+			mult = 1000;
+	} else if (!strncmp("g", c, 1) || !strncmp("gb", c, 2)) {
 		pow = 3;
-	else if (!strncmp("m", c, 1) || !strncmp("mb", c, 2))
+		if (kb_base == 1024)
+			mult = 1000;
+	} else if (!strncmp("m", c, 1) || !strncmp("mb", c, 2)) {
 		pow = 2;
-	else if (!strncmp("k", c, 1) || !strncmp("kb", c, 2))
+		if (kb_base == 1024)
+			mult = 1000;
+	} else if (!strncmp("k", c, 1) || !strncmp("kb", c, 2)) {
 		pow = 1;
-	else if (!strncmp("%", c, 1)) {
+		if (kb_base == 1024)
+			mult = 1000;
+	} else if (!strncmp("%", c, 1)) {
 		*percent = 1;
 		free(c);
 		return ret;
diff --git a/stat.c b/stat.c
index 8562ab4..f1d468c 100644
--- a/stat.c
+++ b/stat.c
@@ -279,7 +279,8 @@ bool calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 
 void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 {
-	char *p1, *p2, *p3, *p4;
+	char *io, *agg, *min, *max;
+	char *ioalt, *aggalt, *minalt, *maxalt;
 	const char *str[] = { "   READ", "  WRITE" , "   TRIM"};
 	int i;
 
@@ -291,22 +292,28 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		if (!rs->max_run[i])
 			continue;
 
-		p1 = num2str(rs->iobytes[i], 6, 1, i2p, 8);
-		p2 = num2str(rs->agg[i], 6, 1, i2p, rs->unit_base);
-		p3 = num2str(rs->min_bw[i], 6, 1, i2p, rs->unit_base);
-		p4 = num2str(rs->max_bw[i], 6, 1, i2p, rs->unit_base);
-
-		log_buf(out, "%s: io=%s, aggrb=%s/s, minb=%s/s, maxb=%s/s,"
-			 " mint=%llumsec, maxt=%llumsec\n",
+		io = num2str(rs->iobytes[i], 4, 1, i2p, N2S_BYTE);
+		ioalt = num2str(rs->iobytes[i], 4, 1, !i2p, N2S_BYTE);
+		agg = num2str(rs->agg[i], 4, 1, i2p, rs->unit_base);
+		aggalt = num2str(rs->agg[i], 4, 1, !i2p, rs->unit_base);
+		min = num2str(rs->min_bw[i], 4, 1, i2p, rs->unit_base);
+		minalt = num2str(rs->min_bw[i], 4, 1, !i2p, rs->unit_base);
+		max = num2str(rs->max_bw[i], 4, 1, i2p, rs->unit_base);
+		maxalt = num2str(rs->max_bw[i], 4, 1, !i2p, rs->unit_base);
+		log_buf(out, "%s: bw=%s (%s), %s-%s (%s-%s), io=%s (%s), run=%llu-%llumsec\n",
 				rs->unified_rw_rep ? "  MIXED" : str[i],
-				p1, p2, p3, p4,
+				agg, aggalt, min, max, minalt, maxalt, io, ioalt,
 				(unsigned long long) rs->min_run[i],
 				(unsigned long long) rs->max_run[i]);
 
-		free(p1);
-		free(p2);
-		free(p3);
-		free(p4);
+		free(io);
+		free(agg);
+		free(min);
+		free(max);
+		free(ioalt);
+		free(aggalt);
+		free(minalt);
+		free(maxalt);
 	}
 }
 
@@ -367,8 +374,8 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 	if (usec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
 
-	minp = num2str(min, 6, 1, 0, 0);
-	maxp = num2str(max, 6, 1, 0, 0);
+	minp = num2str(min, 6, 1, 0, N2S_NONE);
+	maxp = num2str(max, 6, 1, 0, N2S_NONE);
 
 	log_buf(out, "    %s %s: min=%s, max=%s, avg=%5.02f,"
 		 " stdev=%5.02f\n", name, base, minp, maxp, mean, dev);
@@ -384,7 +391,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	unsigned long min, max, runt;
 	unsigned long long bw, iops;
 	double mean, dev;
-	char *io_p, *bw_p, *iops_p;
+	char *io_p, *bw_p, *bw_p_alt, *iops_p;
 	int i2p;
 
 	assert(ddir_rw(ddir));
@@ -396,19 +403,21 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	runt = ts->runtime[ddir];
 
 	bw = (1000 * ts->io_bytes[ddir]) / runt;
-	io_p = num2str(ts->io_bytes[ddir], 6, 1, i2p, 8);
-	bw_p = num2str(bw, 6, 1, i2p, ts->unit_base);
+	io_p = num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
+	bw_p = num2str(bw, 4, 1, i2p, ts->unit_base);
+	bw_p_alt = num2str(bw, 4, 1, !i2p, ts->unit_base);
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p = num2str(iops, 6, 1, 0, 0);
+	iops_p = num2str(iops, 4, 1, 0, N2S_NONE);
 
-	log_buf(out, "  %s: io=%s, bw=%s/s, iops=%s, runt=%6llumsec\n",
-				rs->unified_rw_rep ? "mixed" : str[ddir],
-				io_p, bw_p, iops_p,
-				(unsigned long long) ts->runtime[ddir]);
+	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)\n",
+			rs->unified_rw_rep ? "mixed" : str[ddir],
+			iops_p, bw_p, bw_p_alt, io_p,
+			(unsigned long long) ts->runtime[ddir]);
 
 	free(io_p);
 	free(bw_p);
+	free(bw_p_alt);
 	free(iops_p);
 
 	if (calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev))
@@ -426,7 +435,16 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	}
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
-		const char *bw_str = (rs->unit_base == 1 ? "Kbit" : "KB");
+		const char *bw_str;
+
+		if ((rs->unit_base == 1) && i2p)
+			bw_str = "Kibit";
+		else if (rs->unit_base == 1)
+			bw_str = "kbit";
+		else if (i2p)
+			bw_str = "KiB";
+		else
+			bw_str = "kB";
 
 		if (rs->unit_base == 1) {
 			min *= 8.0;
@@ -446,12 +464,11 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			max /= fkb_base;
 			mean /= fkb_base;
 			dev /= fkb_base;
-			bw_str = (rs->unit_base == 1 ? "Mbit" : "MB");
+			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
 		}
 
-		log_buf(out, "    bw (%-4s/s): min=%5lu, max=%5lu, per=%3.2f%%,"
-			 " avg=%5.02f, stdev=%5.02f\n", bw_str, min, max,
-							p_of_agg, mean, dev);
+		log_buf(out, "   bw (%5s/s): min=%5lu, max=%5lu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
+			bw_str, min, max, p_of_agg, mean, dev);
 	}
 }
 
@@ -659,7 +676,7 @@ static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
 
 static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 {
-	char *p1, *p2;
+	char *p1, *p1alt, *p2;
 	unsigned long long bw_mean, iops_mean;
 	const int i2p = is_power_of_2(ts->kb_base);
 
@@ -669,18 +686,20 @@ static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 	bw_mean = steadystate_bw_mean(ts);
 	iops_mean = steadystate_iops_mean(ts);
 
-	p1 = num2str(bw_mean / ts->kb_base, 6, ts->kb_base, i2p, ts->unit_base);
-	p2 = num2str(iops_mean, 6, 1, 0, 0);
+	p1 = num2str(bw_mean / ts->kb_base, 4, ts->kb_base, i2p, ts->unit_base);
+	p1alt = num2str(bw_mean / ts->kb_base, 4, ts->kb_base, !i2p, ts->unit_base);
+	p2 = num2str(iops_mean, 4, 1, 0, N2S_NONE);
 
-	log_buf(out, "  steadystate  : attained=%s, bw=%s/s, iops=%s, %s%s=%.3f%s\n",
+	log_buf(out, "  steadystate  : attained=%s, bw=%s (%s), iops=%s, %s%s=%.3f%s\n",
 		ts->ss_state & __FIO_SS_ATTAINED ? "yes" : "no",
-		p1, p2,
+		p1, p1alt, p2,
 		ts->ss_state & __FIO_SS_IOPS ? "iops" : "bw",
 		ts->ss_state & __FIO_SS_SLOPE ? " slope": " mean dev",
 		ts->ss_criterion.u.f,
 		ts->ss_state & __FIO_SS_PCT ? "%" : "");
 
 	free(p1);
+	free(p1alt);
 	free(p2);
 }
 
@@ -761,9 +780,9 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					io_u_dist[1], io_u_dist[2],
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
-	log_buf(out, "     issued    : total=r=%llu/w=%llu/d=%llu,"
-				 " short=r=%llu/w=%llu/d=%llu,"
-				 " drop=r=%llu/w=%llu/d=%llu\n",
+	log_buf(out, "     issued rwt: total=%llu,%llu,%llu,"
+				 " short=%llu,%llu,%llu,"
+				 " dropped=%llu,%llu,%llu\n",
 					(unsigned long long) ts->total_io_u[0],
 					(unsigned long long) ts->total_io_u[1],
 					(unsigned long long) ts->total_io_u[2],
-- 
2.9.3

