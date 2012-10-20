Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:38937 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2JTDTs (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Oct 2012 23:19:48 -0400
Received: by mail-vc0-f198.google.com with SMTP id d16so1787207vcd.1
        for <fio@vger.kernel.org>; Fri, 19 Oct 2012 20:19:47 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH 1/4] cpuio engine cpuload bug fix
Date: Fri, 19 Oct 2012 23:11:49 -0400
Message-Id: <1350702712-5168-2-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <renyufei83@gmail.com>

From: Yufei Ren <renyufei83@gmail.com>

Current cpu ioengine always bruns out 100 percent cpu cycles
no matter what the cpuload value is. Since no data is transferred
with cpuio, bytes_done would be ZERO. Consequently, think_time
is omitted and loops keeps running.

A cpuio example is added as well.
---
 engines/cpu.c  |    5 +++++
 examples/cpuio |    8 ++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 examples/cpuio

diff --git a/engines/cpu.c b/engines/cpu.c
index 8bc9fd5..322dfde 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -10,6 +10,11 @@
 static int fio_cpuio_queue(struct thread_data *td, struct io_u fio_unused *io_u)
 {
 	usec_spin(td->o.cpucycle);
+
+	if (io_u->buflen == 0)
+		io_u->buflen = 1;
+	io_u->resid = 0;
+
 	return FIO_Q_COMPLETED;
 }
 
diff --git a/examples/cpuio b/examples/cpuio
new file mode 100644
index 0000000..577e072
--- /dev/null
+++ b/examples/cpuio
@@ -0,0 +1,8 @@
+[global]
+ioengine=cpuio
+time_based
+runtime=10
+
+[burn50percent]
+cpuload=50
+
-- 
1.7.2.3

