Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:33754 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdKNAtv (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Nov 2017 19:49:51 -0500
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id C5A3835F8
        for <fio@vger.kernel.org>; Tue, 14 Nov 2017 00:49:50 +0000 (UTC)
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net [16.208.49.245])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id 1CF5F57
        for <fio@vger.kernel.org>; Tue, 14 Nov 2017 00:49:50 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] os-windows: fix cpumask operations
Date: Mon, 13 Nov 2017 19:00:40 -0600
Message-Id: <20171114010040.72921-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Fix cpumask manipulation on (64-bit) Windows systems.

cpus_allowed=nn values greater than 32 does not work, due
to the compiler not promoting expressions like "1 << cpu" to
64 bits, the clear function clearing the wrong bit (using "cpu - 1"),
and the clear function using XOR to clear (which only works if the
bit was previously set).

Example problems (from extra debug prints):
* setting CPU 32 really sets bit 1 (CPU 0)
	Set mask of 0000000000000000 to add 0000000000000001 (32)

* setting CPU 63 really sets bit 31 (CPU 32)
	Set mask of 0000000000000000 to add 0000000080000000 (63)

* clearing CPU 0 really clears bit 63 (CPU 64)
	Clear mask of 0000000055555555 to remove 8000000000000000 (0)

* clearing CPU 2 really clears bit 2 (CPU 1)
	Clear mask of 0000000055555555 to remove 0000000000000002 (2)

Tested with x86_64-w64-mingw32-gcc 6.4.0 from cygwin on a system
with 64 CPU cores (all fitting in one Windows processor group).
---
 os/os-windows.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/os/os-windows.h b/os/os-windows.h
index 520da19..c7941f4 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -209,17 +209,17 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 
 static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
 {
-	*mask ^= 1 << (cpu-1);
+	*mask &= ~(1ULL << cpu);
 }
 
 static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
 {
-	*mask |= 1 << cpu;
+	*mask |= 1ULL << cpu;
 }
 
 static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
 {
-	return (*mask & (1U << cpu));
+	return (*mask & (1ULL << cpu));
 }
 
 static inline int fio_cpu_count(os_cpu_mask_t *mask)
-- 
2.9.3

