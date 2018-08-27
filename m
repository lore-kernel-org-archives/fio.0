Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35490 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbeH1A2x (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Aug 2018 20:28:53 -0400
Received: by mail-qk0-f196.google.com with SMTP id 89-v6so263832qkp.2
        for <fio@vger.kernel.org>; Mon, 27 Aug 2018 13:40:40 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH] engines/sg: improve error handling
Date: Mon, 27 Aug 2018 16:40:11 -0400
Message-Id: <1535402411-8396-1-git-send-email-vincentfu@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@wdc.com>

From: Vincent Fu <Vincent.Fu@wdc.com>

The Linux sg driver accepts only 16 SCSI commands in flight
at a time per file descriptor. fio does not exit gracefully
when it attempts to queue up 17 or more trim commands via
the sg ioengine. This patch improves error handling in the
sg ioengine commit function to achieve a graceful exit if
fio attempts to queue up too many trim commands. The key to
this is calling clear_io_u on each io_u in the 17th trim
command. With this patch fio no longer loops forever
waiting for the IOs in the (not succesffully submitted)
17th trim command to complete.
---
 engines/sg.c | 49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index 7741f83..3cc068f 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -675,36 +675,37 @@ static int fio_sgio_commit(struct thread_data *td)
 
 	ret = fio_sgio_rw_doio(io_u->file, io_u, 0);
 
-	if (ret < 0)
-		for (i = 0; i < st->unmap_range_count; i++)
-			st->trim_io_us[i]->error = errno;
-	else if (hdr->status)
-		for (i = 0; i < st->unmap_range_count; i++) {
-			st->trim_io_us[i]->resid = hdr->resid;
-			st->trim_io_us[i]->error = EIO;
+	if (ret < 0 || hdr->status) {
+		int error;
+
+		if (ret < 0)
+			error = errno;
+		else {
+			error = EIO;
+			ret = -EIO;
 		}
-	else {
-		if (fio_fill_issue_time(td)) {
-			fio_gettime(&now, NULL);
-			for (i = 0; i < st->unmap_range_count; i++) {
-				struct io_u *io_u = st->trim_io_us[i];
-
-				memcpy(&io_u->issue_time, &now, sizeof(now));
-				io_u_queued(td, io_u);
-			}
+
+		for (i = 0; i < st->unmap_range_count; i++) {
+			st->trim_io_us[i]->error = error;
+			clear_io_u(td, st->trim_io_us[i]);
+			if (hdr->status)
+				st->trim_io_us[i]->resid = hdr->resid;
 		}
-		io_u_mark_submit(td, st->unmap_range_count);
+
+		td_verror(td, error, "xfer");
+		return ret;
 	}
 
-	if (io_u->error) {
-		td_verror(td, io_u->error, "xfer");
-		return 0;
+	if (fio_fill_issue_time(td)) {
+		fio_gettime(&now, NULL);
+		for (i = 0; i < st->unmap_range_count; i++) {
+			memcpy(&st->trim_io_us[i]->issue_time, &now, sizeof(now));
+			io_u_queued(td, io_u);
+		}
 	}
+	io_u_mark_submit(td, st->unmap_range_count);
 
-	if (ret == FIO_Q_QUEUED)
-		return 0;
-	else
-		return ret;
+	return 0;
 }
 
 static struct io_u *fio_sgio_event(struct thread_data *td, int event)
-- 
2.7.4


