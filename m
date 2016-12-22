Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3425.houston.hpe.com ([15.241.140.78]:51633 "EHLO
        g4t3425.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941597AbcLVUrr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 15:47:47 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id B3A9D76
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 20:47:46 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 08/12] gclient: Use proper time units in latency buckets chart
Date: Thu, 22 Dec 2016 14:50:47 -0600
Message-Id: <20161222205051.4677-8-elliott@hpe.com>
In-Reply-To: <20161222205051.4677-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
 <20161222205051.4677-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

In the Results page Latency buckets chart, use us and ms rather
than u and s for the time units.  This matches the use of s for
seconds that is already being done.
---
 gclient.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/gclient.c b/gclient.c
index 451d81c..59b0404 100644
--- a/gclient.c
+++ b/gclient.c
@@ -908,10 +908,10 @@ static void gfio_show_latency_buckets(struct gfio_client *gc, GtkWidget *vbox,
 				      struct thread_stat *ts)
 {
 	double io_u_lat[FIO_IO_U_LAT_U_NR + FIO_IO_U_LAT_M_NR];
-	const char *ranges[] = { "2u", "4u", "10u", "20u", "50u", "100u",
-				 "250u", "500u", "750u", "1m", "2m",
-				 "4m", "10m", "20m", "50m", "100m",
-				 "250m", "500m", "750m", "1s", "2s", ">= 2s" };
+	const char *ranges[] = { "2us", "4us", "10us", "20us", "50us", "100us",
+				 "250us", "500us", "750us", "1ms", "2ms",
+				 "4ms", "10ms", "20ms", "50ms", "100ms",
+				 "250ms", "500ms", "750ms", "1s", "2s", ">= 2s" };
 	int start, end, i;
 	const int total = FIO_IO_U_LAT_U_NR + FIO_IO_U_LAT_M_NR;
 	GtkWidget *frame, *tree_view, *hbox, *completion_vbox, *drawing_area;
@@ -940,7 +940,7 @@ static void gfio_show_latency_buckets(struct gfio_client *gc, GtkWidget *vbox,
 		return;
 
 	tree_view = gfio_output_lat_buckets(&io_u_lat[start], &ranges[start], end - start + 1);
-	ge->lat_bucket_graph = setup_lat_bucket_graph("Latency Buckets", &io_u_lat[start], &ranges[start], end - start + 1, 700.0, 300.0);
+	ge->lat_bucket_graph = setup_lat_bucket_graph("Latency buckets", &io_u_lat[start], &ranges[start], end - start + 1, 700.0, 300.0);
 
 	frame = gtk_frame_new("Latency buckets");
 	gtk_box_pack_start(GTK_BOX(vbox), frame, FALSE, FALSE, 5);
-- 
2.9.3

