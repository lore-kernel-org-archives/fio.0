Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: RE: Group reporting with latency and IOPS
Date: Tue, 29 Jan 2013 20:28:53 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6D396C@SACEXCMBX02-PRD.hq.netapp.com>
References: <20130129130212.GB8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129134652.GF8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D26D5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129135401.GG8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D27A5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129201005.GH8800@kernel.dk>
In-Reply-To: <20130129201005.GH8800@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

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
> > > >You mean for both read and write combined? Fio does not report=20
> > > >that, but for IOPS you could just add them. For latency, the larger =
of the two.
> > > >
> > > >--=3D20
> > > >Jens Axboe
> > > >
> > >=20
> > > Hi Jens
> > >=20
> > > This is neto from Brazil
> > >=20
> > > How are you?
> > >=20
> > > Thank you so much for your answer.
> > >=20
> > > How can I have a combined IOPS reported?
> >=20
> > You can't, at least not automatically. You would have to sum them up.=20
> > It would not be hard to add at all, though, controlled by an option.=20
> > I haven't had any requests for it before now, usually people ask for=20
> > more fine grained metrics, not the other way around :-)
> >=20
> > --
> > Jens Axboe
> >=20
> > Thank you Jens, I understand. To have an option to group everything=20
> > could be a good thing especially when you are doing a POC or=20
> > demonstrating performance for a customer where they are interested=20
> > in how many IOPS and total latency :-)
>=20
> I agree, I can see the use case. I'll add a 'unified_rw_reporting'
> option to be able to do that. Most accounting is done collectively, so it=
 should be pretty simple to do this.
>=20
> --
> Jens Axboe
>=20
> Thank you so much! I am starting to use FIO for all my performance=20
> POCs here. I hope to have this option as soon as possible ... So I can=20
> demonstrate next week.

The below should have a chance at working, though I haven't tested it much =
yet. Will try and find some time to do that shortly.

> One question: I am doing a PCO using Windows, and if I download all=20
> changes via github how can I compile for Windows? (The POC is on=20
> Windows :-)

Bruce, correct me if I'm wrong, but I'm pretty sure I saw a "How to build f=
io" setup guide from you at some point. If correct, can you post it here to=
o? Antonio probably isn't the only one.

Jens, sorry to bother you again, but I am trying to apply the I've got this=
 error. Could you please help me how to fix it?

Thank you neto

[root@mickey fio]# patch <a.diff
patching file client.c
Hunk #1 succeeded at 595 with fuzz 2.
patching file eta.c
patch: **** malformed patch at line 38: @@ -235,19 +236,32 @@ static void c=
alc_rate(unsigned long mtime, unsigned long long *io_bytes,






diff --git a/client.c b/client.c
index 6021e4a..0dc620d 100644
--- a/client.c
+++ b/client.c
@@ -595,6 +595,7 @@ static void convert_ts(struct thread_stat *dst, struct =
thread_stat *src)
 	dst->groupid	=3D le32_to_cpu(src->groupid);
 	dst->pid	=3D le32_to_cpu(src->pid);
 	dst->members	=3D le32_to_cpu(src->members);
+	dst->unified_rw_rep	=3D le32_to_cpu(src->unified_rw_rep);
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]); @@ -667,6 +668,=
7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_s=
tats *src)
=20
 	dst->kb_base	=3D le32_to_cpu(src->kb_base);
 	dst->groupid	=3D le32_to_cpu(src->groupid);
+	dst->unified_rw_rep	=3D le32_to_cpu(src->unified_rw_rep);
 }
=20
 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd) =
@@ -687,6 +689,7 @@ static void handle_ts(struct fio_client *client, struct=
 fio_net_cmd *cmd)
=20
 	client_ts.members++;
 	client_ts.groupid =3D p->ts.groupid;
+	client_ts.unified_rw_rep =3D p->ts.unified_rw_rep;
=20
 	if (++sum_stat_nr =3D=3D sum_stat_clients) {
 		strcpy(client_ts.name, "All clients"); diff --git a/eta.c b/eta.c index =
fdf55c5..39fe10f 100644
--- a/eta.c
+++ b/eta.c
@@ -226,7 +226,8 @@ static int thread_eta(struct thread_data *td)
 	return eta_sec;
 }
=20
-static void calc_rate(unsigned long mtime, unsigned long long *io_bytes,
+static void calc_rate(int unified_rw_rep, unsigned long mtime,
+		      unsigned long long *io_bytes,
 		      unsigned long long *prev_io_bytes, unsigned int *rate)  {
 	int i;
@@ -235,19 +236,32 @@ static void calc_rate(unsigned long mtime, unsigned l=
ong long *io_bytes,
 		unsigned long long diff;
=20
 		diff =3D io_bytes[i] - prev_io_bytes[i];
-		rate[i] =3D ((1000 * diff) / mtime) / 1024;
+		if (unified_rw_rep) {
+			rate[i] =3D 0;
+			rate[0] +=3D ((1000 * diff) / mtime) / 1024;
+		} else
+			rate[i] =3D ((1000 * diff) / mtime) / 1024;
=20
 		prev_io_bytes[i] =3D io_bytes[i];
 	}
 }
=20
-static void calc_iops(unsigned long mtime, unsigned long long *io_iops,
+static void calc_iops(int unified_rw_rep, unsigned long mtime,
+		      unsigned long long *io_iops,
 		      unsigned long long *prev_io_iops, unsigned int *iops)  {
 	int i;
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		iops[i] =3D ((io_iops[i] - prev_io_iops[i]) * 1000) / mtime;
+		unsigned long long diff;
+
+		diff =3D io_iops[i] - prev_io_iops[i];
+		if (unified_rw_rep) {
+			iops[i] =3D 0;
+			iops[0] +=3D (diff * 1000) / mtime;
+		} else
+			iops[i] =3D (diff * 1000) / mtime;
+
 		prev_io_iops[i] =3D io_iops[i];
 	}
 }
@@ -259,7 +273,7 @@ static void calc_iops(unsigned long mtime, unsigned lon=
g long *io_iops,  int calc_thread_status(struct jobs_eta *je, int force)  {
 	struct thread_data *td;
-	int i;
+	int i, unified_rw_rep;
 	unsigned long rate_time, disp_time, bw_avg_time, *eta_secs;
 	unsigned long long io_bytes[DDIR_RWDIR_CNT];
 	unsigned long long io_iops[DDIR_RWDIR_CNT]; @@ -293,7 +307,9 @@ int calc_=
thread_status(struct jobs_eta *je, int force)
 	io_bytes[DDIR_READ] =3D io_bytes[DDIR_WRITE] =3D io_bytes[DDIR_TRIM] =3D =
0;
 	io_iops[DDIR_READ] =3D io_iops[DDIR_WRITE] =3D io_iops[DDIR_TRIM] =3D 0;
 	bw_avg_time =3D ULONG_MAX;
+	unified_rw_rep =3D 0;
 	for_each_td(td, i) {
+		unified_rw_rep +=3D td->o.unified_rw_rep;
 		if (is_power_of_2(td->o.kb_base))
 			je->is_pow2 =3D 1;
 		if (td->o.bw_avg_time < bw_avg_time)
@@ -339,9 +355,15 @@ int calc_thread_status(struct jobs_eta *je, int force)
=20
 		if (td->runstate > TD_RAMP) {
 			int ddir;
+
 			for (ddir =3D DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
-				io_bytes[ddir] +=3D td->io_bytes[ddir];
-				io_iops[ddir] +=3D td->io_blocks[ddir];
+				if (unified_rw_rep) {
+					io_bytes[0] +=3D td->io_bytes[ddir];
+					io_iops[0] +=3D td->io_blocks[ddir];
+				} else {
+					io_bytes[ddir] +=3D td->io_bytes[ddir];
+					io_iops[ddir] +=3D td->io_blocks[ddir];
+				}
 			}
 		}
 	}
@@ -367,7 +389,8 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	rate_time =3D mtime_since(&rate_prev_time, &now);
=20
 	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
-		calc_rate(rate_time, io_bytes, rate_io_bytes, je->rate);
+		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
+				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		add_agg_sample(je->rate[DDIR_READ], DDIR_READ, 0);
 		add_agg_sample(je->rate[DDIR_WRITE], DDIR_WRITE, 0); @@ -382,8 +405,8 @@=
 int calc_thread_status(struct jobs_eta *je, int force)
 	if (!force && disp_time < 900)
 		return 0;
=20
-	calc_rate(disp_time, io_bytes, disp_io_bytes, je->rate);
-	calc_iops(disp_time, io_iops, disp_io_iops, je->iops);
+	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
+	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
=20
 	memcpy(&disp_prev_time, &now, sizeof(now));
=20
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
@@ -2497,6 +2497,13 @@ static struct fio_option options[FIO_MAX_OPTS] =3D {
 		.verify	=3D gtod_cpu_verify,
 	},
 	{
+		.name	=3D "unified_rw_reporting",
+		.type	=3D FIO_OPT_BOOL,
+		.off1	=3D td_var_offset(unified_rw_rep),
+		.help	=3D "Unify reporting across data direction",
+		.def	=3D "0",
+	},
+	{
 		.name	=3D "continue_on_error",
 		.type	=3D FIO_OPT_STR,
 		.off1	=3D td_var_offset(continue_on_error),
diff --git a/server.c b/server.c
index 0cc3fad..7ec8531 100644
--- a/server.c
+++ b/server.c
@@ -648,6 +648,7 @@ static void convert_gs(struct group_run_stats *dst, str=
uct group_run_stats *src)
=20
 	dst->kb_base	=3D cpu_to_le32(src->kb_base);
 	dst->groupid	=3D cpu_to_le32(src->groupid);
+	dst->unified_rw_rep	=3D cpu_to_le32(src->unified_rw_rep);
 }
=20
 /*
@@ -669,8 +670,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct=
 group_run_stats *rs)
=20
 	p.ts.error	=3D cpu_to_le32(ts->error);
 	p.ts.groupid	=3D cpu_to_le32(ts->groupid);
+	p.ts.unified_rw_rep	=3D cpu_to_le32(ts->unified_rw_rep);
 	p.ts.pid	=3D cpu_to_le32(ts->pid);
 	p.ts.members	=3D cpu_to_le32(ts->members);
+	p.ts.unified_rw_rep	=3D cpu_to_le32(ts->unified_rw_rep);
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]); diff --git a/ser=
ver.h b/server.h index 3f1bde4..15b802b 100644
--- a/server.h
+++ b/server.h
@@ -36,7 +36,7 @@ struct fio_net_int_cmd {  };
=20
 enum {
-	FIO_SERVER_VER		=3D 9,
+	FIO_SERVER_VER		=3D 10,
=20
 	FIO_SERVER_MAX_PDU	=3D 1024,
=20
diff --git a/stat.c b/stat.c
index 8e1034b..05a29f5 100644
--- a/stat.c
+++ b/stat.c
@@ -277,9 +277,9 @@ void show_group_stats(struct group_run_stats *rs)
 		p4 =3D num2str(rs->max_bw[i], 6, rs->kb_base, i2p);
=20
 		log_info("%s: io=3D%sB, aggrb=3D%sB/s, minb=3D%sB/s, maxb=3D%sB/s,"
-			 " mint=3D%llumsec, maxt=3D%llumsec\n", ddir_str[i], p1, p2,
-						p3, p4, rs->min_run[i],
-						rs->max_run[i]);
+			 " mint=3D%llumsec, maxt=3D%llumsec\n",
+				rs->unified_rw_rep ? "  MIXED" : ddir_str[i],
+				p1, p2, p3, p4, rs->min_run[i], rs->max_run[i]);
=20
 		free(p1);
 		free(p2);
@@ -381,8 +381,8 @@ static void show_ddir_status(struct group_run_stats *rs=
, struct thread_stat *ts,
 	iops_p =3D num2str(iops, 6, 1, 0);
=20
 	log_info("  %s: io=3D%sB, bw=3D%sB/s, iops=3D%s, runt=3D%6llumsec\n",
-					ddir_str[ddir], io_p, bw_p, iops_p,
-					ts->runtime[ddir]);
+				rs->unified_rw_rep ? "mixed" : ddir_str[ddir],
+				io_p, bw_p, iops_p, ts->runtime[ddir]);
=20
 	free(io_p);
 	free(bw_p);
@@ -1062,15 +1062,27 @@ void sum_thread_stats(struct thread_stat *dst, stru=
ct thread_stat *src, int nr)
 	int l, k;
=20
 	for (l =3D 0; l < DDIR_RWDIR_CNT; l++) {
-		sum_stat(&dst->clat_stat[l], &src->clat_stat[l], nr);
-		sum_stat(&dst->slat_stat[l], &src->slat_stat[l], nr);
-		sum_stat(&dst->lat_stat[l], &src->lat_stat[l], nr);
-		sum_stat(&dst->bw_stat[l], &src->bw_stat[l], nr);
-
-		dst->io_bytes[l] +=3D src->io_bytes[l];
-
-		if (dst->runtime[l] < src->runtime[l])
-			dst->runtime[l] =3D src->runtime[l];
+		if (!dst->unified_rw_rep) {
+			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], nr);
+			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], nr);
+			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], nr);
+			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], nr);
+
+			dst->io_bytes[l] +=3D src->io_bytes[l];
+
+			if (dst->runtime[l] < src->runtime[l])
+				dst->runtime[l] =3D src->runtime[l];
+		} else {
+			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], nr);
+			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], nr);
+			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], nr);
+			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], nr);
+
+			dst->io_bytes[0] +=3D src->io_bytes[l];
+
+			if (dst->runtime[0] < src->runtime[l])
+				dst->runtime[0] =3D src->runtime[l];
+		}
 	}
=20
 	dst->usr_time +=3D src->usr_time;
@@ -1091,14 +1103,24 @@ void sum_thread_stats(struct thread_stat *dst, stru=
ct thread_stat *src, int nr)
 		dst->io_u_lat_m[k] +=3D src->io_u_lat_m[k];
=20
 	for (k =3D 0; k < DDIR_RWDIR_CNT; k++) {
-		dst->total_io_u[k] +=3D src->total_io_u[k];
-		dst->short_io_u[k] +=3D src->short_io_u[k];
+		if (!dst->unified_rw_rep) {
+			dst->total_io_u[k] +=3D src->total_io_u[k];
+			dst->short_io_u[k] +=3D src->short_io_u[k];
+		} else {
+			dst->total_io_u[0] +=3D src->total_io_u[k];
+			dst->short_io_u[0] +=3D src->short_io_u[k];
+		}
 	}
=20
 	for (k =3D 0; k < DDIR_RWDIR_CNT; k++) {
 		int m;
-		for (m =3D 0; m < FIO_IO_U_PLAT_NR; m++)
-			dst->io_u_plat[k][m] +=3D src->io_u_plat[k][m];
+
+		for (m =3D 0; m < FIO_IO_U_PLAT_NR; m++) {
+			if (!dst->unified_rw_rep)
+				dst->io_u_plat[k][m] +=3D src->io_u_plat[k][m];
+			else
+				dst->io_u_plat[0][m] +=3D src->io_u_plat[k][m];
+		}
 	}
=20
 	dst->total_run_time +=3D src->total_run_time; @@ -1210,6 +1232,7 @@ void =
show_run_stats(void)
 			ts->pid =3D td->pid;
=20
 			ts->kb_base =3D td->o.kb_base;
+			ts->unified_rw_rep =3D td->o.unified_rw_rep;
 		} else if (ts->kb_base !=3D td->o.kb_base && !kb_base_warned) {
 			log_info("fio: kb_base differs for jobs in group, using"
 				 " %u as the base\n", ts->kb_base); @@ -1239,6 +1262,7 @@ void show_ru=
n_stats(void)
 		ts =3D &threadstats[i];
 		rs =3D &runstats[ts->groupid];
 		rs->kb_base =3D ts->kb_base;
+		rs->unified_rw_rep +=3D ts->unified_rw_rep;
=20
 		for (j =3D 0; j < DDIR_RWDIR_CNT; j++) {
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
=20
 /*
@@ -120,6 +121,7 @@ struct thread_stat {
 	uint32_t pid;
 	char description[FIO_JOBNAME_SIZE];
 	uint32_t members;
+	uint32_t unified_rw_rep;
=20
 	/*
 	 * bandwidth and latency stats

--
Jens Axboe


