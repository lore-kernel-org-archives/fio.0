Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B659FC64EC4
	for <fio@archiver.kernel.org>; Fri, 10 Mar 2023 01:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCJB2q (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Mar 2023 20:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCJB2p (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Mar 2023 20:28:45 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA179E980F
        for <fio@vger.kernel.org>; Thu,  9 Mar 2023 17:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678411723; x=1709947723;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jiLLgi2/te4Ox4T0io4aM9zeadSbu/UIS97pBu4hWEs=;
  b=FcuLXgOxHXreKBddh48i+1T1dB06bISgKFn6q7Uq1SlSs6podwDvLoPs
   kUKUAkrRV3txjwjDZuuHEIiJKrBYELkopDY+ER41tbVRFnFSmCP4UbNjU
   U3Xxte/GKQqrXb16R02SN7gJk3blrmy/gDgEDvLEGKnDHLZlhO3rOShCI
   PtYzuZ6shSqxHWtGz9dmDDCz06QNqMK+oUPYyvjGqa8p0Wu8tQQZo+U1z
   0T0cET2ktZlVVf66J4Hv4HuAvCC6GKka/lt9rFRVMQ3ZdzevOzDY3PKTs
   EEW8VfHPu2th6Nt/ZJrkKGTsSctA1jaGqCF+aw97BqDPMFoyCMRpZlnG0
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,248,1673884800"; 
   d="scan'208";a="329642373"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 09:28:43 +0800
IronPort-SDR: khzDqXowwEMNTLavSz5GFS7QGNVkZXGkyr29B/29XP93LT35Aj0uuGHjxt5Ce/d69r4UQPruIG
 UqrDlJVRHbIOnNGF4WbVpfXY9uieeq/8lpvHk/fCRlaEGInHJkW2y4H8I0M/lp0LK65MO8ziyB
 vsdLo0OTBcW2oAzjlJZH508C4EDdwyz2UqSQgE+5H0wVDfVrxd85+HUdHYaLThZhw5cdi38Vkv
 PRCfIzQJhHHVcFxyYoyRZRqr7kjrMMCUg97+ifSW8ycvXsIAlqEwn6Ck8/lMvVYjPJkmspiyCr
 DXY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 16:45:17 -0800
IronPort-SDR: MqpjAEQf0d1uLQ/xixp3buuKOYCvhdYQXyyyPp27dKBsiCJYUlTchI6AcOsxE4z2H49gNr63Zj
 3OEC6XblM4IA0dBgKCuFhT9zb3YPYmLMAWBC8WvD2ZrwcR/jK+uOJ7JcyKqcUhDdtGe5qWSkgQ
 OAxMIehe5eA03Fym7gS0EqWni48TzNPL6dAcZJbfx3s38SiwW8KxCxYYcsgvp+/M1/asUYeJvw
 dEzfI3FnCl68tByv23oWDOM/wPzlB0DvVb8Q3nU1KbgPTO0/OprXvVs74js7LhImHC1cZunBA3
 z6Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 17:28:42 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PXpNV75HCz1RwqL
        for <fio@vger.kernel.org>; Thu,  9 Mar 2023 17:28:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1678411722;
         x=1681003723; bh=jiLLgi2/te4Ox4T0io4aM9zeadSbu/UIS97pBu4hWEs=; b=
        lhXHRpdMU506Ifv4O3qcWLNBD1lMC4vaJA80tB/u7IgM9iFe4O6jQjKunzlgTxtE
        QOBhDtEW7T/zBUXUqcIzy0vsFh1feOXO7lEJMsiJW7Fxfvn9SvSjYzuXXu/LfmIY
        GKq1Fi3AfznIxwA8P6UzufiaCGea0ssK76RvMa95vDi0opgCi/X/xtbOQ1XMn1ox
        Pl6Q57Ei6ISmzXee9T1IM85IsbPbqa5PNpPCprdSohLnxaB2K+Lkk/2o1lBqPSpP
        6j8xABVraEFKm8bsTZ8yKoI9jKX85UKKvyUveoMnCh0Un0Ql0FcyFRmTidXUCKL+
        qEWC7WelDDVUn7tTGpteEA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id q0Duj3l0viTk for <fio@vger.kernel.org>;
        Thu,  9 Mar 2023 17:28:42 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PXpNT46x9z1RvLy;
        Thu,  9 Mar 2023 17:28:41 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH] stat: Fix ioprio print
Date:   Fri, 10 Mar 2023 10:28:39 +0900
Message-Id: <20230310012839.9532-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When using per-priority statistics for workloads using multiple
different priority values, the statistics output displays the priority
class and value (level) for each set of statistics. However, this is
done using linux priority values coding, that is, assuming that the
priority level is at most 7 (lower 3-bits). However, this is not always
the case for all OSes. E.g. dragonfly allows IO priorities up to a
value of 10.

Introduce the OS dependent ioprio_class() and ioprio() macros to extract
the fields from an ioprio value according to the OS capabilities. A
generic definition (always returning 0) for these macros in os/os.h is
added and used for all OSes that do not define these macros.

The functions show_ddir_status() and add_ddir_status_json() are modified
to use these new macros to fix per priority statistics output. The
modification includes changes to the loops over the clat_prio array to
reduce indentation levels, making the code a little cleaner.

Fixes: 692dec0cfb4b ("stat: report clat stats on a per priority granulari=
ty")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 os/os-dragonfly.h |  2 ++
 os/os-linux.h     |  3 ++
 os/os.h           |  2 ++
 stat.c            | 85 +++++++++++++++++++++++++----------------------
 4 files changed, 52 insertions(+), 40 deletions(-)

diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 5b37a37e19fd..bde39101b536 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -175,6 +175,8 @@ static inline int fio_getaffinity(int pid, os_cpu_mas=
k_t *mask)
 #define ioprio_set(which, who, ioprio_class, ioprio)	\
 	ioprio_set(which, who, ioprio)
=20
+#define ioprio(ioprio)		(ioprio)
+
 static inline int blockdev_size(struct fio_file *f, unsigned long long *=
bytes)
 {
 	struct partinfo pi;
diff --git a/os/os-linux.h b/os/os-linux.h
index 7a78b42d4d10..2f9f7e796dac 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -153,6 +153,9 @@ static inline int ioprio_set(int which, int who, int =
ioprio_class, int ioprio)
 		       ioprio_value(ioprio_class, ioprio));
 }
=20
+#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
+#define ioprio(ioprio)		((ioprio) & 7)
+
 #ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
diff --git a/os/os.h b/os/os.h
index ebaf8af5e2f3..036fc233fe2e 100644
--- a/os/os.h
+++ b/os/os.h
@@ -116,12 +116,14 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsi=
gned int cpu);
 #endif
=20
 #ifndef FIO_HAVE_IOPRIO_CLASS
+#define ioprio_class(prio)		0
 #define ioprio_value_is_class_rt(prio)	(false)
 #define IOPRIO_MIN_PRIO_CLASS		0
 #define IOPRIO_MAX_PRIO_CLASS		0
 #endif
 #ifndef FIO_HAVE_IOPRIO
 #define ioprio_value(prioclass, prio)	(0)
+#define ioprio(ioprio)			0
 #define ioprio_set(which, who, prioclass, prio)	(0)
 #define IOPRIO_MIN_PRIO			0
 #define IOPRIO_MAX_PRIO			0
diff --git a/stat.c b/stat.c
index b963973a5824..b60d0a75eec0 100644
--- a/stat.c
+++ b/stat.c
@@ -590,17 +590,18 @@ static void show_ddir_status(struct group_run_stats=
 *rs, struct thread_stat *ts,
 	/* Only print per prio stats if there are >=3D 2 prios with samples */
 	if (get_nr_prios_with_samples(ts, ddir) >=3D 2) {
 		for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
-			if (calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
-				     &max, &mean, &dev)) {
-				char buf[64];
+			char buf[64];
=20
-				snprintf(buf, sizeof(buf),
-					 "%s prio %u/%u",
-					 clat_type,
-					 ts->clat_prio[ddir][i].ioprio >> 13,
-					 ts->clat_prio[ddir][i].ioprio & 7);
-				display_lat(buf, min, max, mean, dev, out);
-			}
+			if (!calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
+				      &max, &mean, &dev))
+				continue;
+
+			snprintf(buf, sizeof(buf),
+				 "%s prio %u/%u",
+				 clat_type,
+				 ioprio_class(ts->clat_prio[ddir][i].ioprio),
+				 ioprio(ts->clat_prio[ddir][i].ioprio));
+			display_lat(buf, min, max, mean, dev, out);
 		}
 	}
=20
@@ -632,20 +633,22 @@ static void show_ddir_status(struct group_run_stats=
 *rs, struct thread_stat *ts,
 		/* Only print per prio stats if there are >=3D 2 prios with samples */
 		if (get_nr_prios_with_samples(ts, ddir) >=3D 2) {
 			for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
-				uint64_t prio_samples =3D ts->clat_prio[ddir][i].clat_stat.samples;
-
-				if (prio_samples > 0) {
-					snprintf(prio_name, sizeof(prio_name),
-						 "%s prio %u/%u (%.2f%% of IOs)",
-						 clat_type,
-						 ts->clat_prio[ddir][i].ioprio >> 13,
-						 ts->clat_prio[ddir][i].ioprio & 7,
-						 100. * (double) prio_samples / (double) samples);
-					show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
-							      prio_samples, ts->percentile_list,
-							      ts->percentile_precision,
-							      prio_name, out);
-				}
+				uint64_t prio_samples =3D
+					ts->clat_prio[ddir][i].clat_stat.samples;
+
+				if (!prio_samples)
+					continue;
+
+				snprintf(prio_name, sizeof(prio_name),
+					 "%s prio %u/%u (%.2f%% of IOs)",
+					 clat_type,
+					 ioprio_class(ts->clat_prio[ddir][i].ioprio),
+					 ioprio(ts->clat_prio[ddir][i].ioprio),
+					 100. * (double) prio_samples / (double) samples);
+				show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
+						prio_samples, ts->percentile_list,
+						ts->percentile_precision,
+						prio_name, out);
 			}
 		}
 	}
@@ -1508,22 +1511,24 @@ static void add_ddir_status_json(struct thread_st=
at *ts,
 		json_object_add_value_array(dir_object, "prios", array);
=20
 		for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
-			if (ts->clat_prio[ddir][i].clat_stat.samples > 0) {
-				struct json_object *obj =3D json_create_object();
-				unsigned long long class, level;
-
-				class =3D ts->clat_prio[ddir][i].ioprio >> 13;
-				json_object_add_value_int(obj, "prioclass", class);
-				level =3D ts->clat_prio[ddir][i].ioprio & 7;
-				json_object_add_value_int(obj, "prio", level);
-
-				tmp_object =3D add_ddir_lat_json(ts,
-							       ts->clat_percentiles | ts->lat_percentiles,
-							       &ts->clat_prio[ddir][i].clat_stat,
-							       ts->clat_prio[ddir][i].io_u_plat);
-				json_object_add_value_object(obj, obj_name, tmp_object);
-				json_array_add_value_object(array, obj);
-			}
+			struct json_object *obj;
+
+			if (!ts->clat_prio[ddir][i].clat_stat.samples)
+				continue;
+
+			obj =3D json_create_object();
+
+			json_object_add_value_int(obj, "prioclass",
+				ioprio_class(ts->clat_prio[ddir][i].ioprio));
+			json_object_add_value_int(obj, "prio",
+				ioprio(ts->clat_prio[ddir][i].ioprio));
+
+			tmp_object =3D add_ddir_lat_json(ts,
+					ts->clat_percentiles | ts->lat_percentiles,
+					&ts->clat_prio[ddir][i].clat_stat,
+					ts->clat_prio[ddir][i].io_u_plat);
+			json_object_add_value_object(obj, obj_name, tmp_object);
+			json_array_add_value_object(array, obj);
 		}
 	}
=20
--=20
2.39.2

