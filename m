Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:59216 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab0LAVsx (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 1 Dec 2010 16:48:53 -0500
Date: Wed, 1 Dec 2010 22:38:31 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: iodepth and synchronous ioengines ("pitfall")
Message-ID: <20101201213831.GU28050@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

Hi,

I just stumbled into a glaring pitfall when playing with iodepth=X for
the first time. Was using ioengine=sync (default), increased iodepth > 1
and wondered briefly why my results didn't change. Thinking about it,
this made perfect sense and the "IO depths" distribution in the result
summary even pointed me to it.

Nevertheless, it might help others to avoid this alltogether if the man
page paragraph on iodepth would include a small heads up / reference to
ioengines. Example patch attached, not quite sure about the wording for
the verify_async aspect.

Sebastian

--7AUc2qLy4jB3hD7Z
Content-Type: message/rfc822
Content-Disposition: inline

From: Sebastian Kayser <sebastian@skayser.de>
Date: Wed, 1 Dec 2010 22:28:47 +0100
Subject: [PATCH] fio.1: Add ioengines heads up to the iodepth section

---
 fio.1 |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fio.1 b/fio.1
index b0276c4..ab147f2 100644
--- a/fio.1
+++ b/fio.1
@@ -379,7 +379,9 @@ Loads an external I/O engine object file.  Append the engine filename as
 .RE
 .TP
 .BI iodepth \fR=\fPint
-Number of I/O units to keep in flight against the file.  Default: 1.
+Number of I/O units to keep in flight against the file. Note that increasing
+iodepth beyond 1 will not affect synchronous ioengines (except for small
+degress when verify_async is in use).  Default: 1.
 .TP
 .BI iodepth_batch \fR=\fPint
 Number of I/Os to submit at once.  Default: \fBiodepth\fR.
-- 
1.4.4.4

--7AUc2qLy4jB3hD7Z--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


