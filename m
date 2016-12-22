Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:8415 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756919AbcLVGH3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:29 -0500
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id A8560CF7
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:27 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id D309067
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:26 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 02/12] gfio: Improve IOPS textbox labels
Date: Thu, 22 Dec 2016 00:08:43 -0600
Message-Id: <20161222060853.64104-3-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Change the three textboxes labeled IOPS to Read IOPS, Write IOPS,
and Trim IOPS, add Trim to the Blocksize label, and fix Steve's
last name in the Credits.
---
 gfio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/gfio.c b/gfio.c
index ce18091..9ccf78c 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1215,7 +1215,7 @@ static void about_dialog(GtkWidget *w, gpointer data)
 {
 	const char *authors[] = {
 		"Jens Axboe <axboe@kernel.dk>",
-		"Stephen Carmeron <stephenmcameron@gmail.com>",
+		"Stephen Cameron <stephenmcameron@gmail.com>",
 		NULL
 	};
 	const char *license[] = {
@@ -1386,7 +1386,7 @@ static GtkWidget *new_client_page(struct gui_entry *ge)
 	g_signal_connect(ge->eta.names, "changed", G_CALLBACK(combo_entry_changed), ge);
 	g_signal_connect(ge->eta.names, "destroy", G_CALLBACK(combo_entry_destroy), ge);
 	ge->eta.iotype.entry = new_info_entry_in_frame(probe_box, "IO");
-	ge->eta.bs.entry = new_info_entry_in_frame(probe_box, "Blocksize (Read/Write)");
+	ge->eta.bs.entry = new_info_entry_in_frame(probe_box, "Blocksize (Read/Write/Trim)");
 	ge->eta.ioengine.entry = new_info_entry_in_frame(probe_box, "IO Engine");
 	ge->eta.iodepth.entry = new_info_entry_in_frame(probe_box, "IO Depth");
 	ge->eta.jobs = new_info_entry_in_frame(probe_box, "Jobs");
@@ -1395,11 +1395,11 @@ static GtkWidget *new_client_page(struct gui_entry *ge)
 	probe_box = gtk_hbox_new(FALSE, 3);
 	gtk_box_pack_start(GTK_BOX(probe_frame), probe_box, FALSE, FALSE, 3);
 	ge->eta.read_bw = new_info_entry_in_frame_rgb(probe_box, "Read BW", GFIO_READ_R, GFIO_READ_G, GFIO_READ_B);
-	ge->eta.read_iops = new_info_entry_in_frame_rgb(probe_box, "IOPS", GFIO_READ_R, GFIO_READ_G, GFIO_READ_B);
+	ge->eta.read_iops = new_info_entry_in_frame_rgb(probe_box, "Read IOPS", GFIO_READ_R, GFIO_READ_G, GFIO_READ_B);
 	ge->eta.write_bw = new_info_entry_in_frame_rgb(probe_box, "Write BW", GFIO_WRITE_R, GFIO_WRITE_G, GFIO_WRITE_B);
-	ge->eta.write_iops = new_info_entry_in_frame_rgb(probe_box, "IOPS", GFIO_WRITE_R, GFIO_WRITE_G, GFIO_WRITE_B);
+	ge->eta.write_iops = new_info_entry_in_frame_rgb(probe_box, "Write IOPS", GFIO_WRITE_R, GFIO_WRITE_G, GFIO_WRITE_B);
 	ge->eta.trim_bw = new_info_entry_in_frame_rgb(probe_box, "Trim BW", GFIO_TRIM_R, GFIO_TRIM_G, GFIO_TRIM_B);
-	ge->eta.trim_iops = new_info_entry_in_frame_rgb(probe_box, "IOPS", GFIO_TRIM_R, GFIO_TRIM_G, GFIO_TRIM_B);
+	ge->eta.trim_iops = new_info_entry_in_frame_rgb(probe_box, "Trim IOPS", GFIO_TRIM_R, GFIO_TRIM_G, GFIO_TRIM_B);
 
 	/*
 	 * Only add this if we have a commit rate
-- 
2.9.3

