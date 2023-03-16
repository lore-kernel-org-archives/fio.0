Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC3BC6FD1F
	for <fio@archiver.kernel.org>; Thu, 16 Mar 2023 12:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCPMAb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 16 Mar 2023 08:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCPMAa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Mar 2023 08:00:30 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38396110
        for <fio@vger.kernel.org>; Thu, 16 Mar 2023 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=G+9Xe/bOpFFFrf4f0irYwp7FxUnx3y28UO1zYvdYlds=; b=l2JvJBU3Apu145tpqU/e1wco3c
        xg9uDoQmBiYflJHixa4uNZz1iT1V8yu6TR40pmfPogiBe/5tP8ycLB49bpHzNB7ityp+bA1Zzge0k
        88NeINL/uS3f0b1aX8IAnCrNpZ1ouCB+VUm1fuzdGwLrmtTDFuoeTO3GxFWOU+e1O/hnNRf39OoLV
        p/j1VasrzJfe5hm/jl8C041QEIx6h3sPqCsqQwm4nI83eVwhcdXdvO+Njdkj30SpiwKBEHtkzSpAE
        dVtQQBhUcabwBQJwkb0tMTaSgvstBVigdiE8TjOPowlyaVsoVCzX2wBU/sZr548k01+5qoWLX+mHv
        fBtj09rA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pcmHD-002QhK-1A
        for fio@vger.kernel.org;
        Thu, 16 Mar 2023 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 15C821BC014D; Thu, 16 Mar 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230316120002.15C821BC014D@kernel.dk>
Date:   Thu, 16 Mar 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 4ad09b569a2689b3b67744eaccd378d013eb82a7:

  t/io_uring: abstract out init_new_io() helper (2023-03-14 14:03:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a967e54d34afe3bb10cd521d78bcaea2dd8c7cdc:

  stat: Fix ioprio print (2023-03-15 19:18:47 -0400)

----------------------------------------------------------------
Damien Le Moal (1):
      stat: Fix ioprio print

 os/os-dragonfly.h |  2 ++
 os/os-linux.h     |  3 ++
 os/os.h           |  2 ++
 stat.c            | 85 +++++++++++++++++++++++++++++--------------------------
 4 files changed, 52 insertions(+), 40 deletions(-)

---

Diff of recent changes:

diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 5b37a37e..bde39101 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -175,6 +175,8 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 #define ioprio_set(which, who, ioprio_class, ioprio)	\
 	ioprio_set(which, who, ioprio)
 
+#define ioprio(ioprio)		(ioprio)
+
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	struct partinfo pi;
diff --git a/os/os-linux.h b/os/os-linux.h
index 7a78b42d..2f9f7e79 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -153,6 +153,9 @@ static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 		       ioprio_value(ioprio_class, ioprio));
 }
 
+#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
+#define ioprio(ioprio)		((ioprio) & 7)
+
 #ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
diff --git a/os/os.h b/os/os.h
index ebaf8af5..036fc233 100644
--- a/os/os.h
+++ b/os/os.h
@@ -116,12 +116,14 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
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
index e0a2dcc6..56be330b 100644
--- a/stat.c
+++ b/stat.c
@@ -590,17 +590,18 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	/* Only print per prio stats if there are >= 2 prios with samples */
 	if (get_nr_prios_with_samples(ts, ddir) >= 2) {
 		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
-			if (calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
-				     &max, &mean, &dev)) {
-				char buf[64];
+			char buf[64];
 
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
 
@@ -632,20 +633,22 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		/* Only print per prio stats if there are >= 2 prios with samples */
 		if (get_nr_prios_with_samples(ts, ddir) >= 2) {
 			for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
-				uint64_t prio_samples = ts->clat_prio[ddir][i].clat_stat.samples;
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
+				uint64_t prio_samples =
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
@@ -1508,22 +1511,24 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		json_object_add_value_array(dir_object, "prios", array);
 
 		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
-			if (ts->clat_prio[ddir][i].clat_stat.samples > 0) {
-				struct json_object *obj = json_create_object();
-				unsigned long long class, level;
-
-				class = ts->clat_prio[ddir][i].ioprio >> 13;
-				json_object_add_value_int(obj, "prioclass", class);
-				level = ts->clat_prio[ddir][i].ioprio & 7;
-				json_object_add_value_int(obj, "prio", level);
-
-				tmp_object = add_ddir_lat_json(ts,
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
+			obj = json_create_object();
+
+			json_object_add_value_int(obj, "prioclass",
+				ioprio_class(ts->clat_prio[ddir][i].ioprio));
+			json_object_add_value_int(obj, "prio",
+				ioprio(ts->clat_prio[ddir][i].ioprio));
+
+			tmp_object = add_ddir_lat_json(ts,
+					ts->clat_percentiles | ts->lat_percentiles,
+					&ts->clat_prio[ddir][i].clat_stat,
+					ts->clat_prio[ddir][i].io_u_plat);
+			json_object_add_value_object(obj, obj_name, tmp_object);
+			json_array_add_value_object(array, obj);
 		}
 	}
 
