Return-Path: <fio-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46000 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbcAYNEh (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Jan 2016 08:04:37 -0500
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <dqzhang@linux.vnet.ibm.com>;
	Mon, 25 Jan 2016 06:04:36 -0700
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id ECEDB19D8041
	for <fio@vger.kernel.org>; Mon, 25 Jan 2016 05:52:34 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0PD4Y0010944536
	for <fio@vger.kernel.org>; Mon, 25 Jan 2016 06:04:34 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0PD4XpW001346
	for <fio@vger.kernel.org>; Mon, 25 Jan 2016 06:04:34 -0700
From: Dan Qing Zhang <dqzhang@linux.vnet.ibm.com>
Subject: [FIO][PATCH v1] powerpc: fix cpus_online() to get correct max CPU number for powerpc64
Date: Mon, 25 Jan 2016 13:04:18 +0000
Message-Id: <1453727058-45619-1-git-send-email-dqzhang@linux.vnet.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@fb.com
Cc: fio@vger.kernel.org, zhong@linux.vnet.ibm.com, Dan Qing Zhang <dqzhang@linux.vnet.ibm.com>

This patch tries to fix cpus_online() for powerpc64 when running fio
by using parameter "cpus_allowed", in order to obtain correct max CPU
number on powerpc64 architecture.

When changing SMT settings on powerpc architecture, the way of cpu
numbering is changing as well. For example, when SMT=off, CPUs are
numbered like 0,8,16,..., while when SMT=2, CPUs are numbered like
0,1,8,9,.... Therefore, sysconf(_SC_NPROCESSORS_ONLN) is not applied
to get exact max CPU number on powerpc. And the max_cpu value can be
correctly ontained by using sysconf(_SC_NPROCESSORS_CONF).

Signed-off-by: Dan Qing Zhang <dqzhang@linux.vnet.ibm.com>
---
 os/os.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/os/os.h b/os/os.h
index fd47f22..02ab40d 100644
--- a/os/os.h
+++ b/os/os.h
@@ -343,6 +343,14 @@ static inline unsigned long long get_fs_free_size(const char *path)
 }
 #endif
 
+#ifdef __powerpc64__
+#define FIO_HAVE_CPU_ONLINE_SYSCONF
+static inline unsigned int cpus_online(void)
+{
+        return sysconf(_SC_NPROCESSORS_CONF);
+}
+#endif
+
 #ifndef FIO_HAVE_CPU_ONLINE_SYSCONF
 static inline unsigned int cpus_online(void)
 {
-- 
2.4.0

