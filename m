Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50170
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab3A2UKu (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Jan 2013 15:10:50 -0500
Date: Tue, 29 Jan 2013 21:10:05 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
Message-ID: <20130129201005.GH8800@kernel.dk>
References: <20130129130212.GB8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129134652.GF8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D26D5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129135401.GG8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D27A5@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6D27A5@SACEXCMBX02-PRD.hq.netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> > On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> > > atency: (clat) 577usecs - 0.577ms
> > > >
> > > >Correct too.
> > > >
> > > >> Am I doing the correct analysis?
> > > >
> > > >Yep.
> > > >
> > > >> One question is: Is it possible to have global IOPS and latency?
> > > >
> > > >You mean for both read and write combined? Fio does not report 
> > > >that, but for IOPS you could just add them. For latency, the larger of the two.
> > > >
> > > >--=20
> > > >Jens Axboe
> > > >
> > > 
> > > Hi Jens
> > > 
> > > This is neto from Brazil
> > > 
> > > How are you?
> > > 
> > > Thank you so much for your answer.
> > > 
> > > How can I have a combined IOPS reported?
> > 
> > You can't, at least not automatically. You would have to sum them up. 
> > It would not be hard to add at all, though, controlled by an option. I 
> > haven't had any requests for it before now, usually people ask for 
> > more fine grained metrics, not the other way around :-)
> > 
> > --
> > Jens Axboe
> > 
> > Thank you Jens, I understand. To have an option to group everything 
> > could be a good thing especially when you are doing a POC or 
> > demonstrating performance for a customer where they are interested in 
> > how many IOPS and total latency :-)
> 
> I agree, I can see the use case. I'll add a 'unified_rw_reporting'
> option to be able to do that. Most accounting is done collectively, so it should be pretty simple to do this.
> 
> --
> Jens Axboe
> 
> Thank you so much! I am starting to use FIO for all my performance
> POCs here. I hope to have this option as soon as possible ... So I can
> demonstrate next week.

The below should have a chance at working, though I haven't tested it
much yet. Will try and find some time to do that shortly.

> One question: I am doing a PCO using Windows, and if I download all
> changes via github how can I compile for Windows? (The POC is on
> Windows :-)

Bruce, correct me if I'm wrong, but I'm pretty sure I saw a "How to
build fio" setup guide from you at some point. If correct, can you post
it here too? Antonio probably isn't the only one.

diff --git a/client.c b/client.c
index 6021e4a..0dc620d 100644
--- a/client.c
+++ b/client.c
@@ -595,6 +595,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->groupid	= le32_to_cpu(src->groupid);
 	dst->pid	= le32_to_cpu(src->pid);
 	dst->members	= le32_to_cpu(src->members);
+	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]);
@@ -667,6 +668,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 
 	dst->kb_base	= le32_to_cpu(src->kb_base);
 	dst->groupid	= le32_to_cpu(src->groupid);
+	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
 }
 
 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
@@ -687,6 +689,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	client_ts.members++;
 	client_ts.groupid = p->ts.groupid;
+	client_ts.unified_rw_rep = p->ts.unified_rw_rep;
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
diff --git a/eta.c b/eta.c
index fdf55c5..39fe10f 100644
--- a/eta.c
+++ b/eta.c
@@ -226,7 +226,8 @@ static int thread_eta(struct thread_data *td)
 	return eta_sec;
 }
 
-static void calc_rate(unsigned long mtime, unsigned long long *io_bytes,
+static void calc_rate(int unified_rw_rep, unsigned long mtime,
+		      unsigned long long *io_bytes,
 		      unsigned long long *prev_io_bytes, unsigned int *rate)
 {
 	int i;
@@ -235,19 +236,32 @@ static void calc_rate(unsigned long mtime, unsigned long long *io_bytes,
 		unsigned long long diff;
 
 		diff = io_bytes[i] - prev_io_bytes[i];
-		rate[i] = ((1000 * diff) / mtime) / 1024;
+		if (unified_rw_rep) {
+			rate[i] = 0;
+			rate[0] += ((1000 * diff) / mtime) / 1024;
+		} else
+			rate[i] = ((1000 * diff) / mtime) / 1024;
 
 		prev_io_bytes[i] = io_bytes[i];
 	}
 }
 
-static void calc_iops(unsigned long mtime, unsigned long long *io_iops,
+static void calc_iops(int unified_rw_rep, unsigned long mtime,
+		      unsigned long long *io_iops,
 		      unsigned long long *prev_io_iops, unsigned int *iops)
 {
 	int i;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		iops[i] = ((io_iops[i] - prev_io_iops[i]) * 1000) / mtime;
+		unsigned long long diff;
+
+		diff = io_iops[i] - prev_io_iops[i];
+		if (unified_rw_rep) {
+			iops[i] = 0;
+			iops[0] += (diff * 1000) / mtime;
+		} else
+			iops[i] = (diff * 1000) / mtime;
+
 		prev_io_iops[i] = io_iops[i];
 	}
 }
@@ -259,7 +273,7 @@ static void calc_iops(unsigned long mtime, unsigned long long *io_iops,
 int calc_thread_status(struct jobs_eta *je, int force)
 {
 	struct thread_data *td;
-	int i;
+	int i, unified_rw_rep;
 	unsigned long rate_time, disp_time, bw_avg_time, *eta_secs;
 	unsigned long long io_bytes[DDIR_RWDIR_CNT];
 	unsigned long long io_iops[DDIR_RWDIR_CNT];
@@ -293,7 +307,9 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	io_bytes[DDIR_READ] = io_bytes[DDIR_WRITE] = io_bytes[DDIR_TRIM] = 0;
 	io_iops[DDIR_READ] = io_iops[DDIR_WRITE] = io_iops[DDIR_TRIM] = 0;
 	bw_avg_time = ULONG_MAX;
+	unified_rw_rep = 0;
 	for_each_td(td, i) {
+		unified_rw_rep += td->o.unified_rw_rep;
 		if (is_power_of_2(td->o.kb_base))
 			je->is_pow2 = 1;
 		if (td->o.bw_avg_time < bw_avg_time)
@@ -339,9 +355,15 @@ int calc_thread_status(struct jobs_eta *je, int force)
 
 		if (td->runstate > TD_RAMP) {
 			int ddir;
+
 			for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
-				io_bytes[ddir] += td->io_bytes[ddir];
-				io_iops[ddir] += td->io_blocks[ddir];
+				if (unified_rw_rep) {
+					io_bytes[0] += td->io_bytes[ddir];
+					io_iops[0] += td->io_blocks[ddir];
+				} else {
+					io_bytes[ddir] += td->io_bytes[ddir];
+					io_iops[ddir] += td->io_blocks[ddir];
+				}
 			}
 		}
 	}
@@ -367,7 +389,8 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	rate_time = mtime_since(&rate_prev_time, &now);
 
 	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
-		calc_rate(rate_time, io_bytes, rate_io_bytes, je->rate);
+		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
+				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		add_agg_sample(je->rate[DDIR_READ], DDIR_READ, 0);
 		add_agg_sample(je->rate[DDIR_WRITE], DDIR_WRITE, 0);
@@ -382,8 +405,8 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	if (!force && disp_time < 900)
 		return 0;
 
-	calc_rate(disp_time, io_bytes, disp_io_bytes, je->rate);
-	calc_iops(disp_time, io_iops, disp_io_iops, je->iops);
+	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
+	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
 
 	memcpy(&disp_prev_time, &now, sizeof(now));
 
diff --git a/fio.h b/fio.h
index 9e20299..2fd354a 100644
--- a/fio.h
+++ b/fio.h
@@ -237,6 +237,7 @@ struct thread_options {
 	unsigned int disable_clat;
 	unsigned int disable_slat;
 	unsigned int disable_bw;
+	unsigned int unified_rw_rep;
 	unsigned int gtod_reduce;
 	unsigned int gtod_cpu;
 	unsigned int gtod_offload;
diff --git a/options.c b/options.c
index 1009df3..799e77a 100644
--- a/options.c
+++ b/options.c
@@ -2497,6 +2497,13 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.verify	= gtod_cpu_verify,
 	},
 	{
+		.name	= "unified_rw_reporting",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(unified_rw_rep),
+		.help	= "Unify reporting across data direction",
+		.def	= "0",
+	},
+	{
 		.name	= "continue_on_error",
 		.type	= FIO_OPT_STR,
 		.off1	= td_var_offset(continue_on_error),
diff --git a/server.c b/server.c
index 0cc3fad..7ec8531 100644
--- a/server.c
+++ b/server.c
@@ -648,6 +648,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 
 	dst->kb_base	= cpu_to_le32(src->kb_base);
 	dst->groupid	= cpu_to_le32(src->groupid);
+	dst->unified_rw_rep	= cpu_to_le32(src->unified_rw_rep);
 }
 
 /*
@@ -669,8 +670,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	p.ts.error	= cpu_to_le32(ts->error);
 	p.ts.groupid	= cpu_to_le32(ts->groupid);
+	p.ts.unified_rw_rep	= cpu_to_le32(ts->unified_rw_rep);
 	p.ts.pid	= cpu_to_le32(ts->pid);
 	p.ts.members	= cpu_to_le32(ts->members);
+	p.ts.unified_rw_rep	= cpu_to_le32(ts->unified_rw_rep);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]);
diff --git a/server.h b/server.h
index 3f1bde4..15b802b 100644
--- a/server.h
+++ b/server.h
@@ -36,7 +36,7 @@ struct fio_net_int_cmd {
 };
 
 enum {
-	FIO_SERVER_VER		= 9,
+	FIO_SERVER_VER		= 10,
 
 	FIO_SERVER_MAX_PDU	= 1024,
 
diff --git a/stat.c b/stat.c
index 8e1034b..05a29f5 100644
--- a/stat.c
+++ b/stat.c
@@ -277,9 +277,9 @@ void show_group_stats(struct group_run_stats *rs)
 		p4 = num2str(rs->max_bw[i], 6, rs->kb_base, i2p);
 
 		log_info("%s: io=%sB, aggrb=%sB/s, minb=%sB/s, maxb=%sB/s,"
-			 " mint=%llumsec, maxt=%llumsec\n", ddir_str[i], p1, p2,
-						p3, p4, rs->min_run[i],
-						rs->max_run[i]);
+			 " mint=%llumsec, maxt=%llumsec\n",
+				rs->unified_rw_rep ? "  MIXED" : ddir_str[i],
+				p1, p2, p3, p4, rs->min_run[i], rs->max_run[i]);
 
 		free(p1);
 		free(p2);
@@ -381,8 +381,8 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	iops_p = num2str(iops, 6, 1, 0);
 
 	log_info("  %s: io=%sB, bw=%sB/s, iops=%s, runt=%6llumsec\n",
-					ddir_str[ddir], io_p, bw_p, iops_p,
-					ts->runtime[ddir]);
+				rs->unified_rw_rep ? "mixed" : ddir_str[ddir],
+				io_p, bw_p, iops_p, ts->runtime[ddir]);
 
 	free(io_p);
 	free(bw_p);
@@ -1062,15 +1062,27 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr)
 	int l, k;
 
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
-		sum_stat(&dst->clat_stat[l], &src->clat_stat[l], nr);
-		sum_stat(&dst->slat_stat[l], &src->slat_stat[l], nr);
-		sum_stat(&dst->lat_stat[l], &src->lat_stat[l], nr);
-		sum_stat(&dst->bw_stat[l], &src->bw_stat[l], nr);
-
-		dst->io_bytes[l] += src->io_bytes[l];
-
-		if (dst->runtime[l] < src->runtime[l])
-			dst->runtime[l] = src->runtime[l];
+		if (!dst->unified_rw_rep) {
+			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], nr);
+			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], nr);
+			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], nr);
+			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], nr);
+
+			dst->io_bytes[l] += src->io_bytes[l];
+
+			if (dst->runtime[l] < src->runtime[l])
+				dst->runtime[l] = src->runtime[l];
+		} else {
+			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], nr);
+			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], nr);
+			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], nr);
+			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], nr);
+
+			dst->io_bytes[0] += src->io_bytes[l];
+
+			if (dst->runtime[0] < src->runtime[l])
+				dst->runtime[0] = src->runtime[l];
+		}
 	}
 
 	dst->usr_time += src->usr_time;
@@ -1091,14 +1103,24 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr)
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
 
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
-		dst->total_io_u[k] += src->total_io_u[k];
-		dst->short_io_u[k] += src->short_io_u[k];
+		if (!dst->unified_rw_rep) {
+			dst->total_io_u[k] += src->total_io_u[k];
+			dst->short_io_u[k] += src->short_io_u[k];
+		} else {
+			dst->total_io_u[0] += src->total_io_u[k];
+			dst->short_io_u[0] += src->short_io_u[k];
+		}
 	}
 
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
 		int m;
-		for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
-			dst->io_u_plat[k][m] += src->io_u_plat[k][m];
+
+		for (m = 0; m < FIO_IO_U_PLAT_NR; m++) {
+			if (!dst->unified_rw_rep)
+				dst->io_u_plat[k][m] += src->io_u_plat[k][m];
+			else
+				dst->io_u_plat[0][m] += src->io_u_plat[k][m];
+		}
 	}
 
 	dst->total_run_time += src->total_run_time;
@@ -1210,6 +1232,7 @@ void show_run_stats(void)
 			ts->pid = td->pid;
 
 			ts->kb_base = td->o.kb_base;
+			ts->unified_rw_rep = td->o.unified_rw_rep;
 		} else if (ts->kb_base != td->o.kb_base && !kb_base_warned) {
 			log_info("fio: kb_base differs for jobs in group, using"
 				 " %u as the base\n", ts->kb_base);
@@ -1239,6 +1262,7 @@ void show_run_stats(void)
 		ts = &threadstats[i];
 		rs = &runstats[ts->groupid];
 		rs->kb_base = ts->kb_base;
+		rs->unified_rw_rep += ts->unified_rw_rep;
 
 		for (j = 0; j < DDIR_RWDIR_CNT; j++) {
 			if (!ts->runtime[j])
diff --git a/stat.h b/stat.h
index 4ca8261..97186c1 100644
--- a/stat.h
+++ b/stat.h
@@ -8,6 +8,7 @@ struct group_run_stats {
 	uint64_t agg[DDIR_RWDIR_CNT];
 	uint32_t kb_base;
 	uint32_t groupid;
+	uint32_t unified_rw_rep;
 };
 
 /*
@@ -120,6 +121,7 @@ struct thread_stat {
 	uint32_t pid;
 	char description[FIO_JOBNAME_SIZE];
 	uint32_t members;
+	uint32_t unified_rw_rep;
 
 	/*
 	 * bandwidth and latency stats

-- 
Jens Axboe

