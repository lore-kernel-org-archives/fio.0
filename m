Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:15697 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752416AbdAJVRu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Jan 2017 16:17:50 -0500
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 637D2606BB
        for <fio@vger.kernel.org>; Tue, 10 Jan 2017 21:17:49 +0000 (UTC)
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2354.austin.hpe.com (Postfix) with ESMTP id 7B22650
        for <fio@vger.kernel.org>; Tue, 10 Jan 2017 21:17:48 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 2/4] pmemblk, dev-dax: Update descriptions
Date: Tue, 10 Jan 2017 15:21:25 -0600
Message-Id: <20170110212127.64926-2-elliott@hpe.com>
In-Reply-To: <20170110212127.64926-1-elliott@hpe.com>
References: <20170104065453.15106-1-elliott@hpe.com>
 <20170110212127.64926-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Make the descriptions of the pmemblk and dev-dax ioengines
more symmetric.
---
 HOWTO | 10 ++++++----
 fio.1 |  6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/HOWTO b/HOWTO
index 4354e46..9e1ffa6 100644
--- a/HOWTO
+++ b/HOWTO
@@ -903,11 +903,13 @@ ioengine=str	Defines how the job issues io to the file. The following
 				overwriting. The writetrim mode works well
 				for this constraint.
 
-			pmemblk	Read and write through the NVML libpmemblk
-				interface.
+			pmemblk	Read and write using filesystem DAX to a file
+				on a filesystem mounted with DAX on a persistent
+				memory device through the NVML libpmemblk library.
 
-			dev-dax Read and write through a DAX device exposed
-				from persistent memory.
+			dev-dax Read and write using device DAX to a persistent
+				memory device (e.g., /dev/dax0.0) through the
+				NVML libpmem library.
 
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
diff --git a/fio.1 b/fio.1
index f486276..56f2d11 100644
--- a/fio.1
+++ b/fio.1
@@ -811,10 +811,12 @@ and discarding before overwriting. The trimwrite mode works well for this
 constraint.
 .TP
 .B pmemblk
-Read and write through the NVML libpmemblk interface.
+Read and write using filesystem DAX to a file on a filesystem mounted with
+DAX on a persistent memory device through the NVML libpmemblk library.
 .TP
 .B dev-dax
-Read and write through a DAX device exposed from persistent memory.
+Read and write using device DAX to a persistent memory device
+(e.g., /dev/dax0.0) through the NVML libpmem library.
 .RE
 .P
 .RE
-- 
2.9.3

