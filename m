Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfBVNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Feb 2019 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gxAQu-000539-Vs
        for fio@vger.kernel.org; Fri, 22 Feb 2019 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190222130002.1A6DC2C040D@kernel.dk>
Date: Fri, 22 Feb 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 71144e676e710b37966f447ccd8d944813dfa6d1:

  configure: enable -Wimplicit-fallthrough if we have it (2019-02-11 13:30:52 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a294b8704a4125f12e3c3dec36667e68d821be0:

  options: catch division by zero in setting CPU affinity (2019-02-21 10:55:32 -0700)

----------------------------------------------------------------
Vincent Fu (2):
      stat: use long doubles to identify latency percentiles
      options: catch division by zero in setting CPU affinity

 options.c | 3 +++
 stat.c    | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 6d832354..95086074 100644
--- a/options.c
+++ b/options.c
@@ -493,6 +493,9 @@ int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu_index)
 	const long max_cpu = cpus_online();
 
 	cpus_in_mask = fio_cpu_count(mask);
+	if (!cpus_in_mask)
+		return 0;
+
 	cpu_index = cpu_index % cpus_in_mask;
 
 	index = 0;
diff --git a/stat.c b/stat.c
index c1f46e1d..66a13bca 100644
--- a/stat.c
+++ b/stat.c
@@ -170,7 +170,7 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 	is_last = false;
 	for (i = 0; i < FIO_IO_U_PLAT_NR && !is_last; i++) {
 		sum += io_u_plat[i];
-		while (sum >= (plist[j].u.f / 100.0 * nr)) {
+		while (sum >= ((long double) plist[j].u.f / 100.0 * nr)) {
 			assert(plist[j].u.f <= 100.0);
 
 			ovals[j] = plat_idx_to_val(i);
@@ -187,6 +187,9 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 		}
 	}
 
+	if (!is_last)
+		log_err("fio: error calculating latency percentiles\n");
+
 	*output = ovals;
 	return len;
 }

