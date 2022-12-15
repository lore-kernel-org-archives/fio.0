Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF1CC4167B
	for <fio@archiver.kernel.org>; Thu, 15 Dec 2022 01:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiLOB4N (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 14 Dec 2022 20:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiLOB4M (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Dec 2022 20:56:12 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EBA2C65F
        for <fio@vger.kernel.org>; Wed, 14 Dec 2022 17:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671069371; x=1702605371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=STrIyRDD1QTNkG8Iopx0Jx8Ijcu2eguGkLRPwOzsR6E=;
  b=Zx+bI8mHSFjffq6Dn0HEefVYGceIZJVyIF+nzVQNK3azddn9TO8y0SG9
   CrqYluQ/6s0JCWC43Bk0XGlshyqnLCLeCIxXeNzeQ3Pg6fMfty+jloyiK
   XWphWTNCE02PbymfmrPRcTQ3nRGju+VLKpAEfBzHd4fZEolnL7S6vhYxs
   674mmPqurr6PVBInvGggHHBHdJwcN//3HAhr49d817lZ4j9OF4afXRErD
   YTfjc0AKNM1RmM3ajt3S1dj6wX86NAzLv5DCC/gaKht8LzKD/QEinX18Y
   DmeYqO89b/41MBknGAB1RPir5wm6J431QoGkxzFKZJHeqgE3JZiWNgGjb
   w==;
X-IronPort-AV: E=Sophos;i="5.96,246,1665417600"; 
   d="scan'208";a="218930651"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2022 09:56:10 +0800
IronPort-SDR: +1ClUuP9j9yOZWY8+byoEI/bL/Z/3L346p++ojjsuH2LAhAiED2kYXEETeAIYRkwb6D4xm3+fo
 LIK8cpWq/XdmxvuiQLdzLJCBOZjOF3jEoAspWrVAQDv2dCs3MkwiwJD7/hFMI0AtTJVJ5OhfZB
 lZDtZfJ1WUnAoi6pe1QBqwkRXE7IQm98R7saRdpT/sZXgjeweUEKRrySwYIfY7pVz53TuaK/G0
 GAqrPRKKd+2a/zXbswTfUuUuAoys/BtJsMyL5k3AdPwKciixv5oP0p7Xg9a3j07waDs0+H2NuY
 UQk=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Dec 2022 17:14:32 -0800
IronPort-SDR: I+b15ruiEaZn7d8+VS2iCWRFQONV6t/qpz4ZGetMP7KvZk3y8LgxPs6ApL+M2kPURVy+6lZoB5
 uWjEe8Qi82pDXScj0k80lIhmdKPbJqdD4TP1vkYBoCcPMQFN+syyKziqtOAfYyCDHyQ3zYBLeo
 riQh42mST/kbmZM1FHNU3zo3En4HLIRQ/Uc0NN28kjw1Djw5XNeVGm4VWHEIXod6idXrLaqLbK
 hIRdd4ztIkw69QXFyDC+bAdRPDg7JVEeHGW1Ol6ccfJQPY1rpvhXN5BVuriEKQ63/Pj33wMfaB
 i+I=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Dec 2022 17:56:10 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/4] HOWTO/man: improve descriptions of max open zones options
Date:   Thu, 15 Dec 2022 10:56:04 +0900
Message-Id: <20221215015606.2767187-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
References: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The options max_open_zones and job_max_open_zones control the number of
open zones for zonemode=zbd. However, descriptions in HOWTO and man
about these options are not clear enough since it is not well described
what an open zone is. Improve the description by adding explanation of
the open zone state. Also explain the default values for these options.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 27 ++++++++++++++++++++-------
 fio.1     | 23 +++++++++++++++++------
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 5a5263c3..ad43d162 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1052,16 +1052,29 @@ Target file/device
 
 .. option:: max_open_zones=int
 
-	When running a random write test across an entire drive many more
-	zones will be open than in a typical application workload. Hence this
-	command line option that allows one to limit the number of open zones. The
-	number of open zones is defined as the number of zones to which write
-	commands are issued.
+	A zone of a zoned block device is in the open state when it is partially
+	written (i.e. not all sectors of the zone have been written). Zoned
+	block devices may have limitation on the total number of zones that can
+	be simultaneously in the open state, that is, the number of zones that
+	can be written to simultaneously. The :option:`max_open_zones` parameter
+	limits the number of zones to which write commands are issued by all fio
+	jobs, that is, limits the number of zones that will be in the open
+	state. This parameter is relevant only if the :option:`zonemode` =zbd is
+	used. The default value is always equal to maximum number of open zones
+	of the target zoned block device and a value higher than this limit
+	cannot be specified by users unless the option
+	:option:`ignore_zone_limits` is specified. When
+	:option:`ignore_zone_limits` is specified or the target device has no
+	limit on the number of zones that can be in an open state,
+	:option:`max_open_zones` can specify 0 to disable any limit on the
+	number of zones that can be simultaneously written to by all jobs.
 
 .. option:: job_max_open_zones=int
 
-	Limit on the number of simultaneously opened zones per single
-	thread/process.
+	In the same manner as :option:`max_open_zones`, limit the number of open
+	zones per fio job, that is, the number of zones that a single job can
+	simultaneously write to. A value of zero indicates no limit.
+	Default: zero.
 
 .. option:: ignore_zone_limits=bool
 
diff --git a/fio.1 b/fio.1
index a0d765e5..d6ad0e27 100644
--- a/fio.1
+++ b/fio.1
@@ -828,14 +828,25 @@ numbers fio only reads beyond the write pointer if explicitly told to do
 so. Default: false.
 .TP
 .BI max_open_zones \fR=\fPint
-When running a random write test across an entire drive many more zones will be
-open than in a typical application workload. Hence this command line option
-that allows one to limit the number of open zones. The number of open zones is
-defined as the number of zones to which write commands are issued by all
-threads/processes.
+A zone of a zoned block device is in the open state when it is partially written
+(i.e. not all sectors of the zone have been written). Zoned block devices may
+have limitation on the total number of zones that can be simultaneously in the
+open state, that is, the number of zones that can be written to simultaneously.
+The \fBmax_open_zones\fR parameter limits the number of zones to which write
+commands are issued by all fio jobs, that is, limits the number of zones that
+will be in the open state. This parameter is relevant only if the
+\fBzonemode=zbd\fR is used. The default value is always equal to maximum number
+of open zones of the target zoned block device and a value higher than this
+limit cannot be specified by users unless the option \fBignore_zone_limits\fR is
+specified. When \fBignore_zone_limits\fR is specified or the target device has
+no limit on the number of zones that can be in an open state,
+\fBmax_open_zones\fR can specify 0 to disable any limit on the number of zones
+that can be simultaneously written to by all jobs.
 .TP
 .BI job_max_open_zones \fR=\fPint
-Limit on the number of simultaneously opened zones per single thread/process.
+In the same manner as \fBmax_open_zones\fR, limit the number of open zones per
+fio job, that is, the number of zones that a single job can simultaneously write
+to. A value of zero indicates no limit. Default: zero.
 .TP
 .BI ignore_zone_limits \fR=\fPbool
 If this option is used, fio will ignore the maximum number of open zones limit
-- 
2.37.1

