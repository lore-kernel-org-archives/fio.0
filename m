Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:50238 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbaD3Gnq (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 30 Apr 2014 02:43:46 -0400
From: Daniel Gollub <d.gollub@telekom.de>
Subject: [PATCH] Fix gfio build due to disk_stat struct seperation
Date: Wed, 30 Apr 2014 08:27:53 +0200
Message-Id: <1398839273-21596-1-git-send-email-d.gollub@telekom.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>, Daniel Gollub <daniel.gollub@t-online.de>

Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
Cc: Daniel Gollub <daniel.gollub@t-online.de>
---
 gclient.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/gclient.c b/gclient.c
index 4360aea..d236f86 100644
--- a/gclient.c
+++ b/gclient.c
@@ -195,39 +195,39 @@ static int __gfio_disk_util_show(GtkWidget *res_notebook,
 	vbox = gtk_hbox_new(TRUE, 3);
 	gtk_container_add(GTK_CONTAINER(frame), vbox);
 	entry = new_info_entry_in_frame(vbox, "IOs");
-	entry_set_int_value(entry, p->dus.ios[0]);
+	entry_set_int_value(entry, p->dus.s.ios[0]);
 	entry = new_info_entry_in_frame(vbox, "Merges");
-	entry_set_int_value(entry, p->dus.merges[0]);
+	entry_set_int_value(entry, p->dus.s.merges[0]);
 	entry = new_info_entry_in_frame(vbox, "Sectors");
-	entry_set_int_value(entry, p->dus.sectors[0]);
+	entry_set_int_value(entry, p->dus.s.sectors[0]);
 	entry = new_info_entry_in_frame(vbox, "Ticks");
-	entry_set_int_value(entry, p->dus.ticks[0]);
+	entry_set_int_value(entry, p->dus.s.ticks[0]);
 
 	frame = gtk_frame_new("Write");
 	gtk_box_pack_start(GTK_BOX(box), frame, FALSE, FALSE, 2);
 	vbox = gtk_hbox_new(TRUE, 3);
 	gtk_container_add(GTK_CONTAINER(frame), vbox);
 	entry = new_info_entry_in_frame(vbox, "IOs");
-	entry_set_int_value(entry, p->dus.ios[1]);
+	entry_set_int_value(entry, p->dus.s.ios[1]);
 	entry = new_info_entry_in_frame(vbox, "Merges");
-	entry_set_int_value(entry, p->dus.merges[1]);
+	entry_set_int_value(entry, p->dus.s.merges[1]);
 	entry = new_info_entry_in_frame(vbox, "Sectors");
-	entry_set_int_value(entry, p->dus.sectors[1]);
+	entry_set_int_value(entry, p->dus.s.sectors[1]);
 	entry = new_info_entry_in_frame(vbox, "Ticks");
-	entry_set_int_value(entry, p->dus.ticks[1]);
+	entry_set_int_value(entry, p->dus.s.ticks[1]);
 
 	frame = gtk_frame_new("Shared");
 	gtk_box_pack_start(GTK_BOX(box), frame, FALSE, FALSE, 2);
 	vbox = gtk_hbox_new(TRUE, 3);
 	gtk_container_add(GTK_CONTAINER(frame), vbox);
 	entry = new_info_entry_in_frame(vbox, "IO ticks");
-	entry_set_int_value(entry, p->dus.io_ticks);
+	entry_set_int_value(entry, p->dus.s.io_ticks);
 	entry = new_info_entry_in_frame(vbox, "Time in queue");
-	entry_set_int_value(entry, p->dus.time_in_queue);
+	entry_set_int_value(entry, p->dus.s.time_in_queue);
 
 	util = 0.0;
-	if (p->dus.msec)
-		util = (double) 100 * p->dus.io_ticks / (double) p->dus.msec;
+	if (p->dus.s.msec)
+		util = (double) 100 * p->dus.s.io_ticks / (double) p->dus.s.msec;
 	if (util > 100.0)
 		util = 100.0;
 
-- 
1.7.10.4

