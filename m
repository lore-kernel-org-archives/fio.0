Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3427.houston.hpe.com ([15.241.140.73]:27156 "EHLO
        g4t3427.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752247AbdADGvZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Jan 2017 01:51:25 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id F396356
        for <fio@vger.kernel.org>; Wed,  4 Jan 2017 06:51:23 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 2/4] pmemblk, dev-dax: Update descriptions
Date: Wed,  4 Jan 2017 00:54:51 -0600
Message-Id: <20170104065453.15106-3-elliott@hpe.com>
In-Reply-To: <20170104065453.15106-1-elliott@hpe.com>
References: <20170104065453.15106-1-elliott@hpe.com>
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

