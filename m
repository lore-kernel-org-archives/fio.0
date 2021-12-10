Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E055C433FE
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhLJCTU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:20 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33935 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbhLJCTU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102546; x=1670638546;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=0QccqimQomF+9UVj/Yvl72UZt/2g/xfvMGl/MQ/S/4I=;
  b=B9UJvGNeTuv1r4pdF5bi8suc8fxbfjzR4BNBByj43XaurXcYSmad2VHb
   PNyRuvm9A8DmzqloDD8Xyqjeu8KIv2K/xMKAFHt9SzWDNUAQgekFCixDD
   mTCBfmYkXdsTkjOTAGUrIiIqY/Fk7BFj7hf9ryWlLPiudUJjnOmShi1C7
   +cmsrCC+8hTKl2FdRrWwedhb34U4cGle7GHL2U6TEic9m2xJ7Vl3MKeU3
   Kqr5q+uzp4XmaGqL4nSd6ntmkC7eSxLlIinOPL/0p6aKqDwxCzI06rg/u
   CALnbtfkLN5tv553SGAM6evqhR919laQOQMb8kTRmuI3rshjKSPG/r0v8
   w==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907576"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:46 +0800
IronPort-SDR: v76THALAKKIA8GgmOCrmCqcF3HiRxWahOJVtdnjy8p7YFC4hr1hSgSQjwsUcjyNXlWlBB4mGA1
 BAokdQKNNqX4WhL3qKMrUTJSNbKuD288l2tdPN0GLPy1pxyxBtLb6aJjAwG+5O4lvUwbo6sSyM
 eCowuP0Yd40TL4ga9vkAapP5p32mgX0tz4SUuX5hwkd9olsWpR+c1j2pLWcN2mlvQH38KWfVCs
 KpC2OgUyT3RHV22DbaJ9VBOm1KZ7NrfOpTPas3i7vQotx7PgyBHRk7cV7Xfi1w7rziauCNrKnW
 LE8y/0QGHCNww6VWXvf7B6Qx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:17 -0800
IronPort-SDR: +52nzDq9hIaBNCDzPjxfh+GuqMIS+eqW+6XqJCX4cKVNRdYH9nfBz1dvqKIpNjkba+xFpHgWzb
 r5LpgF9Mo7tYDEjyzy5sCy03yeSR4HUy3XphYwqHKlKfelmJ32BMjQuvExJANVlBWsAJUtIwDe
 8IWj2/nx7A1sqfcfxdhfpLVxvY50OTOY9OdS4pVXtCEoAzN2lyvNJ1D2eGDA1tOwhXQGO/4vsd
 l6zUSc9bCwbgOuS6+emsRdX8N8URHuT2JwgJFCyJwSL/yYTUCbWCsGQjcs8vAOi7Bq5oMr/qKS
 sB4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dym3NJfz1RwFN
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:44 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102544; x=1641694545; bh=0QccqimQomF+9UVj/Y
        vl72UZt/2g/xfvMGl/MQ/S/4I=; b=fywM1wWCOu7ayfmEzScG81f6EWjhI+scfO
        08O9jOoiKzFJsa133fAzQ1PNCSTH2ZG/DQIQJZ2fN31FI3MhgQ7SIqSZhF5HWsI3
        iroPD/VmaUcOxF+LgAq9bGdiLjAgPK6ur3q6lautTePW/8/54P7eIvZ37bCacYkT
        tIp9CitlKFKrU72qFebd2bDTKdPZgBNsq1CkwTzpqtbDZ7grzfY/1j5/z/W9niKQ
        7RIDyDMFKiPA1LZYSBGnnJvmhpOwKRS1cSH9oUbNdhoFBXefkH/Yz4f1FHmnX91q
        yWWXdWa5s+lmHwQ3P1RLiUKxDIZbhii5GuTXWGg90wAL6RmRtv+Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZgIw5HMd_ynW for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:44 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyl4y4gz1RvTh;
        Thu,  9 Dec 2021 18:15:43 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/11] fio: Improve documentation of ignore_zone_limits option
Date:   Fri, 10 Dec 2021 11:15:31 +0900
Message-Id: <20211210021541.317315-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

In the manual pages, change the description of the option
ignore_zone_limits to its action when set, instead of the confusing text
describing what happens when it is not set. Also add the description
of this option in the HOWTO file as it is missing.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 HOWTO | 6 ++++++
 fio.1 | 6 +++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 8c9e4135..2956e50d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1063,6 +1063,12 @@ Target file/device
 	Limit on the number of simultaneously opened zones per single
 	thread/process.
=20
+.. option:: ignore_zone_limits=3Dbool
+	If this option is used, fio will ignore the maximum number of open
+	zones limit of the zoned block device in use, thus allowing the
+	option :option:`max_open_zones` value to be larger than the device
+	reported limit. Default: false.
+
 .. option:: zone_reset_threshold=3Dfloat
=20
 	A number between zero and one that indicates the ratio of logical
diff --git a/fio.1 b/fio.1
index a3ebb67d..e0458c22 100644
--- a/fio.1
+++ b/fio.1
@@ -838,9 +838,9 @@ threads/processes.
 Limit on the number of simultaneously opened zones per single thread/pro=
cess.
 .TP
 .BI ignore_zone_limits \fR=3D\fPbool
-If this isn't set, fio will query the max open zones limit from the zone=
d block
-device, and exit if the specified \fBmax_open_zones\fR value is larger t=
han the
-limit reported by the device. Default: false.
+If this option is used, fio will ignore the maximum number of open zones=
 limit
+of the zoned block device in use, thus allowing the option \fBmax_open_z=
ones\fR
+value to be larger than the device reported limit. Default: false.
 .TP
 .BI zone_reset_threshold \fR=3D\fPfloat
 A number between zero and one that indicates the ratio of logical blocks=
 with
--=20
2.31.1

