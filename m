Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23285 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbdKVCJz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Nov 2017 21:09:55 -0500
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH] add sig_figs parameter
Date: Wed, 22 Nov 2017 02:09:51 +0000
Message-ID: <BN3PR0401MB1457EE94EC3FDDC638DCF5638F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Attached is a patch for adding a new significant figures parameter to the n=
ormal output format.  Somes when using large I/O sizes, the hardcoded 4 sig=
 figs does not truly represent the throughput, due to rounding/truncating. =
 So this parameter allows the value to be user settable, without having to =
inspect json outputs (intended for machine readable, not human readable).  =
With this patch, the default behavior is exactly as it is today, meaning th=
e default sig_figs is 4.  If a user enables --sig_figs=3D5, then one extra =
digit will be displayed.  Please let me know of any bugs/issues.  Thanks.

Regards,
Jeff



diff --git a/HOWTO b/HOWTO
index dce96bc..811e6ca 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2909,6 +2909,13 @@ Measurements and reporting
 	completion latency below which 99.5% and 99.9% of the observed latencies
 	fell, respectively.
=20
+.. option:: sig_figs=3Dint
+
+	If using :option:`--output-format` of `normal`, set the significant figur=
es=20
+	to this	value. Higher values will yield more precise IOPS and throughput=
=20
+	units, while lower values will round. Requires a minimum value of 1 and a=
=20
+	maximum value of 10. Defaults to 4.
+
=20
 Error handling
 ~~~~~~~~~~~~~~
diff --git a/cconv.c b/cconv.c
index dc3c4e6..1a41dc3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -270,6 +270,7 @@ void convert_thread_options_to_cpu(struct thread_option=
s *o,
 	o->clat_percentiles =3D le32_to_cpu(top->clat_percentiles);
 	o->lat_percentiles =3D le32_to_cpu(top->lat_percentiles);
 	o->percentile_precision =3D le32_to_cpu(top->percentile_precision);
+	o->sig_figs =3D le32_to_cpu(top->sig_figs);
 	o->continue_on_error =3D le32_to_cpu(top->continue_on_error);
 	o->cgroup_weight =3D le32_to_cpu(top->cgroup_weight);
 	o->cgroup_nodelete =3D le32_to_cpu(top->cgroup_nodelete);
@@ -458,6 +459,7 @@ void convert_thread_options_to_net(struct thread_option=
s_pack *top,
 	top->clat_percentiles =3D cpu_to_le32(o->clat_percentiles);
 	top->lat_percentiles =3D cpu_to_le32(o->lat_percentiles);
 	top->percentile_precision =3D cpu_to_le32(o->percentile_precision);
+	top->sig_figs =3D cpu_to_le32(o->sig_figs);
 	top->continue_on_error =3D cpu_to_le32(o->continue_on_error);
 	top->cgroup_weight =3D cpu_to_le32(o->cgroup_weight);
 	top->cgroup_nodelete =3D cpu_to_le32(o->cgroup_nodelete);
diff --git a/client.c b/client.c
index 779fb9d..11fa262 100644
--- a/client.c
+++ b/client.c
@@ -942,6 +942,8 @@ static void convert_ts(struct thread_stat *dst, struct =
thread_stat *src)
 	dst->kb_base		=3D le32_to_cpu(src->kb_base);
 	dst->unit_base		=3D le32_to_cpu(src->unit_base);
=20
+	dst->sig_figs		=3D le32_to_cpu(src->sig_figs);
+
 	dst->latency_depth	=3D le32_to_cpu(src->latency_depth);
 	dst->latency_target	=3D le64_to_cpu(src->latency_target);
 	dst->latency_window	=3D le64_to_cpu(src->latency_window);
@@ -982,6 +984,7 @@ static void convert_gs(struct group_run_stats *dst, str=
uct group_run_stats *src)
=20
 	dst->kb_base	=3D le32_to_cpu(src->kb_base);
 	dst->unit_base	=3D le32_to_cpu(src->unit_base);
+	dst->sig_figs	=3D le32_to_cpu(src->sig_figs);
 	dst->groupid	=3D le32_to_cpu(src->groupid);
 	dst->unified_rw_rep	=3D le32_to_cpu(src->unified_rw_rep);
 }
@@ -1167,6 +1170,7 @@ static void convert_jobs_eta(struct jobs_eta *je)
 	je->nr_threads		=3D le32_to_cpu(je->nr_threads);
 	je->is_pow2		=3D le32_to_cpu(je->is_pow2);
 	je->unit_base		=3D le32_to_cpu(je->unit_base);
+	je->sig_figs		=3D le32_to_cpu(je->sig_figs);
 }
=20
 void fio_client_sum_jobs_eta(struct jobs_eta *dst, struct jobs_eta *je)
diff --git a/eta.c b/eta.c
index baaa681..1b0b000 100644
--- a/eta.c
+++ b/eta.c
@@ -537,9 +537,9 @@ void display_thread_status(struct jobs_eta *je)
 		char *tr, *mr;
=20
 		mr =3D num2str(je->m_rate[0] + je->m_rate[1] + je->m_rate[2],
-				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
 		tr =3D num2str(je->t_rate[0] + je->t_rate[1] + je->t_rate[2],
-				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
=20
 		p +=3D sprintf(p, ", %s-%s", mr, tr);
 		free(tr);
diff --git a/fio.1 b/fio.1
index bd7670a..caa8a76 100644
--- a/fio.1
+++ b/fio.1
@@ -2586,6 +2586,12 @@ numbers, and list the numbers in ascending order. Fo=
r example,
 `\-\-percentile_list=3D99.5:99.9' will cause fio to report the values of
 completion latency below which 99.5% and 99.9% of the observed latencies
 fell, respectively.
+.TP
+.BI sig_figs \fR=3D\fPint
+If using \fB\-\-output\-format\fR of `normal', set the significant figures=
=20
+to this	value. Higher values will yield more precise IOPS and throughput=20
+units, while lower values will round. Requires a minimum value of 1 and a=
=20
+maximum value of 10. Defaults to 4.
 .SS "Error handling"
 .TP
 .BI exitall_on_error
diff --git a/gclient.c b/gclient.c
index daa9153..ab7aa10 100644
--- a/gclient.c
+++ b/gclient.c
@@ -379,24 +379,24 @@ static void gfio_update_client_eta(struct fio_client =
*client, struct jobs_eta *j
 			sprintf(output, "%3.1f%% done", perc);
 		}
=20
-		iops_str[0] =3D num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
-		iops_str[1] =3D num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
-		iops_str[2] =3D num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
+		iops_str[0] =3D num2str(je->iops[0], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[1] =3D num2str(je->iops[1], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[2] =3D num2str(je->iops[2], je->sig_figs, 1, 0, N2S_PERSEC);
=20
-		rate_str[0] =3D num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[0] =3D num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[0] =3D num2str(je->rate[0], je->sig_figs, 10, i2p, N2S_BYTEPERS=
EC);
+		rate_alt[0] =3D num2str(je->rate[0], je->sig_figs, 10, !i2p, N2S_BYTEPER=
SEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_iops), iops_str[0]);
=20
-		rate_str[1] =3D num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[1] =3D num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[1] =3D num2str(je->rate[1], je->sig_figs, 10, i2p, N2S_BYTEPERS=
EC);
+		rate_alt[1] =3D num2str(je->rate[1], je->sig_figs, 10, !i2p, N2S_BYTEPER=
SEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_iops), iops_str[1]);
=20
-		rate_str[2] =3D num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[2] =3D num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[2] =3D num2str(je->rate[2], je->sig_figs, 10, i2p, N2S_BYTEPERS=
EC);
+		rate_alt[2] =3D num2str(je->rate[2], je->sig_figs, 10, !i2p, N2S_BYTEPER=
SEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_iops), iops_str[2]);
@@ -463,24 +463,24 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 			sprintf(output, "%3.1f%% done", perc);
 		}
=20
-		iops_str[0] =3D num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
-		iops_str[1] =3D num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
-		iops_str[2] =3D num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
+		iops_str[0] =3D num2str(je->iops[0], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[1] =3D num2str(je->iops[1], je->sig_figs, 1, 0, N2S_PERSEC);
+		iops_str[2] =3D num2str(je->iops[2], je->sig_figs, 1, 0, N2S_PERSEC);
=20
-		rate_str[0] =3D num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[0] =3D num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[0] =3D num2str(je->rate[0], je->sig_figs, 10, i2p, N2S_BYTEPERS=
EC);
+		rate_alt[0] =3D num2str(je->rate[0], je->sig_figs, 10, !i2p, N2S_BYTEPER=
SEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_iops), iops_str[0]);
=20
-		rate_str[1] =3D num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[1] =3D num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[1] =3D num2str(je->rate[1], je->sig_figs, 10, i2p, N2S_BYTEPERS=
EC);
+		rate_alt[1] =3D num2str(je->rate[1], je->sig_figs, 10, !i2p, N2S_BYTEPER=
SEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_iops), iops_str[1]);
=20
-		rate_str[2] =3D num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
-		rate_alt[2] =3D num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		rate_str[2] =3D num2str(je->rate[2], je->sig_figs, 10, i2p, N2S_BYTEPERS=
EC);
+		rate_alt[2] =3D num2str(je->rate[2], je->sig_figs, 10, !i2p, N2S_BYTEPER=
SEC);
 		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_iops), iops_str[2]);
@@ -587,10 +587,10 @@ static void gfio_add_job_op(struct fio_client *client=
, struct fio_net_cmd *cmd)
 	multitext_add_entry(&ge->eta.iotype, tmp);
=20
 	i2p =3D is_power_of_2(o->kb_base);
-	c1 =3D num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-	c2 =3D num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-	c3 =3D num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
-	c4 =3D num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+	c1 =3D num2str(o->min_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+	c2 =3D num2str(o->max_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+	c3 =3D num2str(o->min_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
+	c4 =3D num2str(o->max_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
=20
 	sprintf(tmp, "%s-%s,%s-%s", c1, c2, c3, c4);
 	free(c1);
@@ -1183,7 +1183,7 @@ static void gfio_show_ddir_status(struct gfio_client =
*gc, GtkWidget *mbox,
 	bw =3D (1000 * ts->io_bytes[ddir]) / runt;
=20
 	iops =3D (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p =3D num2str(iops, 4, 1, 0, N2S_PERSEC);
+	iops_p =3D num2str(iops, ts->sig_figs, 1, 0, N2S_PERSEC);
=20
 	box =3D gtk_hbox_new(FALSE, 3);
 	gtk_box_pack_start(GTK_BOX(mbox), box, TRUE, FALSE, 3);
@@ -1198,14 +1198,14 @@ static void gfio_show_ddir_status(struct gfio_clien=
t *gc, GtkWidget *mbox,
 	gtk_box_pack_start(GTK_BOX(main_vbox), box, TRUE, FALSE, 3);
=20
 	label =3D new_info_label_in_frame(box, "IO");
-	io_p =3D num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
-	io_palt =3D num2str(ts->io_bytes[ddir], 4, 1, !i2p, N2S_BYTE);
+	io_p =3D num2str(ts->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
+	io_palt =3D num2str(ts->io_bytes[ddir], ts->sig_figs, 1, !i2p, N2S_BYTE);
 	snprintf(tmp, sizeof(tmp), "%s (%s)", io_p, io_palt);
 	gtk_label_set_text(GTK_LABEL(label), tmp);
=20
 	label =3D new_info_label_in_frame(box, "Bandwidth");
-	bw_p =3D num2str(bw, 4, 1, i2p, ts->unit_base);
-	bw_palt =3D num2str(bw, 4, 1, !i2p, ts->unit_base);
+	bw_p =3D num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
+	bw_palt =3D num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
 	snprintf(tmp, sizeof(tmp), "%s (%s)", bw_p, bw_palt);
 	gtk_label_set_text(GTK_LABEL(label), tmp);
=20
diff --git a/init.c b/init.c
index 736c6ff..b7e9c0e 100644
--- a/init.c
+++ b/init.c
@@ -1589,14 +1589,14 @@ static int add_job(struct thread_data *td, const ch=
ar *jobname, int job_add_num,
 				char *c5 =3D NULL, *c6 =3D NULL;
 				int i2p =3D is_power_of_2(o->kb_base);
=20
-				c1 =3D num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-				c2 =3D num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
-				c3 =3D num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
-				c4 =3D num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+				c1 =3D num2str(o->min_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+				c2 =3D num2str(o->max_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
+				c3 =3D num2str(o->min_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
+				c4 =3D num2str(o->max_bs[DDIR_WRITE], o->sig_figs, 1, i2p, N2S_BYTE);
=20
 				if (!o->bs_is_seq_rand) {
-					c5 =3D num2str(o->min_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
-					c6 =3D num2str(o->max_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
+					c5 =3D num2str(o->min_bs[DDIR_TRIM], o->sig_figs, 1, i2p, N2S_BYTE);
+					c6 =3D num2str(o->max_bs[DDIR_TRIM], o->sig_figs, 1, i2p, N2S_BYTE);
 				}
=20
 				log_info("%s: (g=3D%d): rw=3D%s, ", td->o.name,
diff --git a/options.c b/options.c
index a0fcd8f..ae29aeb 100644
--- a/options.c
+++ b/options.c
@@ -4127,6 +4127,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
 		.category =3D FIO_OPT_C_STAT,
 		.group	=3D FIO_OPT_G_INVALID,
 	},
+	{
+		.name	=3D "sig_figs",
+		.lname	=3D "Significant figures",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct thread_options, sig_figs),
+		.maxval	=3D 10,
+		.minval	=3D 1,
+		.help	=3D "Significant figures for output-format set to normal",
+		.def	=3D "4",
+		.interval =3D 1,
+		.category =3D FIO_OPT_C_STAT,
+		.group	=3D FIO_OPT_G_INVALID,
+	},
=20
 #ifdef FIO_HAVE_DISK_UTIL
 	{
diff --git a/server.c b/server.c
index e6ea4cd..967cebe 100644
--- a/server.c
+++ b/server.c
@@ -1538,6 +1538,8 @@ void fio_server_send_ts(struct thread_stat *ts, struc=
t group_run_stats *rs)
 	p.ts.latency_window	=3D cpu_to_le64(ts->latency_window);
 	p.ts.latency_percentile.u.i =3D cpu_to_le64(fio_double_to_uint64(ts->late=
ncy_percentile.u.f));
=20
+	p.ts.sig_figs		=3D cpu_to_le32(ts->sig_figs);
+
 	p.ts.nr_block_infos	=3D cpu_to_le64(ts->nr_block_infos);
 	for (i =3D 0; i < p.ts.nr_block_infos; i++)
 		p.ts.block_infos[i] =3D cpu_to_le32(ts->block_infos[i]);
diff --git a/stat.c b/stat.c
index 89e2e6c..48d8e7d 100644
--- a/stat.c
+++ b/stat.c
@@ -299,14 +299,14 @@ void show_group_stats(struct group_run_stats *rs, str=
uct buf_output *out)
 		if (!rs->max_run[i])
 			continue;
=20
-		io =3D num2str(rs->iobytes[i], 4, 1, i2p, N2S_BYTE);
-		ioalt =3D num2str(rs->iobytes[i], 4, 1, !i2p, N2S_BYTE);
-		agg =3D num2str(rs->agg[i], 4, 1, i2p, rs->unit_base);
-		aggalt =3D num2str(rs->agg[i], 4, 1, !i2p, rs->unit_base);
-		min =3D num2str(rs->min_bw[i], 4, 1, i2p, rs->unit_base);
-		minalt =3D num2str(rs->min_bw[i], 4, 1, !i2p, rs->unit_base);
-		max =3D num2str(rs->max_bw[i], 4, 1, i2p, rs->unit_base);
-		maxalt =3D num2str(rs->max_bw[i], 4, 1, !i2p, rs->unit_base);
+		io =3D num2str(rs->iobytes[i], rs->sig_figs, 1, i2p, N2S_BYTE);
+		ioalt =3D num2str(rs->iobytes[i], rs->sig_figs, 1, !i2p, N2S_BYTE);
+		agg =3D num2str(rs->agg[i], rs->sig_figs, 1, i2p, rs->unit_base);
+		aggalt =3D num2str(rs->agg[i], rs->sig_figs, 1, !i2p, rs->unit_base);
+		min =3D num2str(rs->min_bw[i], rs->sig_figs, 1, i2p, rs->unit_base);
+		minalt =3D num2str(rs->min_bw[i], rs->sig_figs, 1, !i2p, rs->unit_base);
+		max =3D num2str(rs->max_bw[i], rs->sig_figs, 1, i2p, rs->unit_base);
+		maxalt =3D num2str(rs->max_bw[i], rs->sig_figs, 1, !i2p, rs->unit_base);
 		log_buf(out, "%s: bw=3D%s (%s), %s-%s (%s-%s), io=3D%s (%s), run=3D%llu-=
%llumsec\n",
 				rs->unified_rw_rep ? "  MIXED" : str[i],
 				agg, aggalt, min, max, minalt, maxalt, io, ioalt,
@@ -435,12 +435,12 @@ static void show_ddir_status(struct group_run_stats *=
rs, struct thread_stat *ts,
 	runt =3D ts->runtime[ddir];
=20
 	bw =3D (1000 * ts->io_bytes[ddir]) / runt;
-	io_p =3D num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
-	bw_p =3D num2str(bw, 4, 1, i2p, ts->unit_base);
-	bw_p_alt =3D num2str(bw, 4, 1, !i2p, ts->unit_base);
+	io_p =3D num2str(ts->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
+	bw_p =3D num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
+	bw_p_alt =3D num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
=20
 	iops =3D (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p =3D num2str(iops, 4, 1, 0, N2S_NONE);
+	iops_p =3D num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
=20
 	log_buf(out, "  %s: IOPS=3D%s, BW=3D%s (%s)(%s/%llumsec)\n",
 			rs->unified_rw_rep ? "mixed" : str[ddir],
@@ -738,9 +738,9 @@ static void show_ss_normal(struct thread_stat *ts, stru=
ct buf_output *out)
 	bw_mean =3D steadystate_bw_mean(ts);
 	iops_mean =3D steadystate_iops_mean(ts);
=20
-	p1 =3D num2str(bw_mean / ts->kb_base, 4, ts->kb_base, i2p, ts->unit_base)=
;
-	p1alt =3D num2str(bw_mean / ts->kb_base, 4, ts->kb_base, !i2p, ts->unit_b=
ase);
-	p2 =3D num2str(iops_mean, 4, 1, 0, N2S_NONE);
+	p1 =3D num2str(bw_mean / ts->kb_base, ts->sig_figs, ts->kb_base, i2p, ts-=
>unit_base);
+	p1alt =3D num2str(bw_mean / ts->kb_base, ts->sig_figs, ts->kb_base, !i2p,=
 ts->unit_base);
+	p2 =3D num2str(iops_mean, ts->sig_figs, 1, 0, N2S_NONE);
=20
 	log_buf(out, "  steadystate  : attained=3D%s, bw=3D%s (%s), iops=3D%s, %s=
%s=3D%.3f%s\n",
 		ts->ss_state & __FIO_SS_ATTAINED ? "yes" : "no",
@@ -1690,6 +1690,7 @@ void __show_run_stats(void)
=20
 			ts->kb_base =3D td->o.kb_base;
 			ts->unit_base =3D td->o.unit_base;
+			ts->sig_figs =3D td->o.sig_figs;
 			ts->unified_rw_rep =3D td->o.unified_rw_rep;
 		} else if (ts->kb_base !=3D td->o.kb_base && !kb_base_warned) {
 			log_info("fio: kb_base differs for jobs in group, using"
@@ -1752,6 +1753,7 @@ void __show_run_stats(void)
 		rs =3D &runstats[ts->groupid];
 		rs->kb_base =3D ts->kb_base;
 		rs->unit_base =3D ts->unit_base;
+		rs->sig_figs =3D ts->sig_figs;
 		rs->unified_rw_rep +=3D ts->unified_rw_rep;
=20
 		for (j =3D 0; j < DDIR_RWDIR_CNT; j++) {
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
=20
+	uint32_t sig_figs;
+
 	uint64_t ss_dur;
 	uint32_t ss_state;
 	uint32_t ss_head;
@@ -257,6 +260,8 @@ struct jobs_eta {
 	uint32_t is_pow2;
 	uint32_t unit_base;
=20
+	uint32_t sig_figs;
+
 	uint32_t files_open;
=20
 	/*
diff --git a/thread_options.h b/thread_options.h
index 5a037bf..ca549b5 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -309,6 +309,8 @@ struct thread_options {
 	unsigned long long latency_window;
 	fio_fp64_t latency_percentile;
=20
+	unsigned int sig_figs;
+
 	unsigned block_error_hist;
=20
 	unsigned int replay_align;
@@ -584,6 +586,8 @@ struct thread_options_pack {
 	uint64_t latency_window;
 	fio_fp64_t latency_percentile;
=20
+	uint32_t sig_figs;
+
 	uint32_t block_error_hist;
=20
 	uint32_t replay_align;




