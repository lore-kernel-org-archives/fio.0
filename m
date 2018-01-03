Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:5674 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbeACXUl (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Jan 2018 18:20:41 -0500
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH] Fix client/server "all clients" reporting
Date: Wed, 3 Jan 2018 23:20:38 +0000
Message-ID: <BN3PR0401MB145797A13CE4C82EF8B131018F1E0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

In commit e883cb3501de0f99297282c18842d50aaa7fa531, the default significant=
 figures was added.  The default value was preserved for local jobs and whe=
n client/server was used if jobs=3D1, but not when client/server was used i=
f jobs > 1.  This patch restores some reporting outputs ("all clients" outp=
ut for IOPS and BW) when client/server is used if > 1 jobs, for example:

OLD:
All clients: (groupid=3D0, jobs=3D2): err=3D 0: pid=3D0: Wed Jan  3 14:30:1=
3 2018
   read: IOPS=3D0, BW=3D0 (0)(0B/5001msec)                                 =
              <--ZERO VALUES
    slat (nsec): min=3D762, max=3D108579, avg=3D1058.97, stdev=3D221.30
    clat (nsec): min=3D254, max=3D4544.2k, avg=3D11297.64, stdev=3D8284.14
     lat (usec): min=3D9, max=3D4545, avg=3D12.41, stdev=3D 8.30
   bw (  KiB/s): min=3D290192, max=3D347160, per=3D49.35%, avg=3D303613.33,=
 stdev=3D11582.87, samples=3D18
   iops        : min=3D72548, max=3D86790, avg=3D75903.33, stdev=3D2895.72,=
 samples=3D18

NEW:
All clients: (groupid=3D0, jobs=3D2): err=3D 0: pid=3D0: Wed Jan  3 15:08:3=
3 2018
   read: IOPS=3D147k, BW=3D575Mi (603M)(2876MiB/5001msec)	<--CORRECT VALUES
    slat (nsec): min=3D841, max=3D61945, avg=3D1304.83, stdev=3D232.75
    clat (nsec): min=3D544, max=3D4487.2k, avg=3D11736.68, stdev=3D9123.64
     lat (usec): min=3D10, max=3D4489, avg=3D13.10, stdev=3D 9.13
   bw (  KiB/s): min=3D260945, max=3D305976, per=3D49.99%, avg=3D294350.22,=
 stdev=3D9192.53, samples=3D18
   iops        : min=3D65236, max=3D76494, avg=3D73587.56, stdev=3D2298.13,=
 samples=3D18

Regards,
Jeff



diff --git a/client.c b/client.c
index 18247ef..6fe6d9f 100644
--- a/client.c
+++ b/client.c
@@ -1024,6 +1024,7 @@ static void handle_ts(struct fio_client *client, stru=
ct fio_net_cmd *cmd)
 	client_ts.thread_number =3D p->ts.thread_number;
 	client_ts.groupid =3D p->ts.groupid;
 	client_ts.unified_rw_rep =3D p->ts.unified_rw_rep;
+	client_ts.sig_figs =3D p->ts.sig_figs;
=20
 	if (++sum_stat_nr =3D=3D sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
diff --git a/gclient.c b/gclient.c
index ab7aa10..70dda48 100644
--- a/gclient.c
+++ b/gclient.c
@@ -298,6 +298,7 @@ static void gfio_thread_status_op(struct fio_client *cl=
ient,
 	client_ts.members++;
 	client_ts.thread_number =3D p->ts.thread_number;
 	client_ts.groupid =3D p->ts.groupid;
+	client_ts.sig_figs =3D p->ts.sig_figs;
=20
 	if (++sum_stat_nr =3D=3D sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
diff --git a/init.c b/init.c
index decd3b4..8a80138 100644
--- a/init.c
+++ b/init.c
@@ -1472,6 +1472,7 @@ static int add_job(struct thread_data *td, const char=
 *jobname, int job_add_num,
 	td->ts.lat_percentiles =3D o->lat_percentiles;
 	td->ts.percentile_precision =3D o->percentile_precision;
 	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_l=
ist));
+	td->ts.sig_figs =3D o->sig_figs;
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		td->ts.clat_stat[i].min_val =3D ULONG_MAX;
diff --git a/server.c b/server.c
index 54d703d..ce9dca3 100644
--- a/server.c
+++ b/server.c
@@ -1443,6 +1443,7 @@ static void convert_gs(struct group_run_stats *dst, s=
truct group_run_stats *src)
 	dst->unit_base	=3D cpu_to_le32(src->unit_base);
 	dst->groupid	=3D cpu_to_le32(src->groupid);
 	dst->unified_rw_rep	=3D cpu_to_le32(src->unified_rw_rep);
+	dst->sig_figs	=3D cpu_to_le32(src->sig_figs);
 }
=20
 /*
diff --git a/stat.c b/stat.c
index cc171a4..509bd6d 100644
--- a/stat.c
+++ b/stat.c
@@ -1490,6 +1490,8 @@ void sum_group_stats(struct group_run_stats *dst, str=
uct group_run_stats *src)
 		dst->kb_base =3D src->kb_base;
 	if (!dst->unit_base)
 		dst->unit_base =3D src->unit_base;
+	if (!dst->sig_figs)
+		dst->sig_figs =3D src->sig_figs;
 }
=20
 void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,

