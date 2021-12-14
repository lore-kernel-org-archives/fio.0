Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F31BC433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243138AbhLNBYT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:19 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51731 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBYS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445057; x=1670981057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3JsbmqK1/VeV5BtICT6zSAZDbpI8NRKlxrV069uVOJY=;
  b=Fuj/q7g7reZrQOeaVtwCcOzV4rHGaNGxqseQpE3lVUI+8VAF8A/Ffy3l
   DazbocVM3tQZ0DHnP3MG/EoZDrcAOBdU8ohaBuMA/f0KPjqa3l38VOb/L
   DMW8zhKqCW6eoPLKm4oDnKhfulgJ5v7rp0m1VTMM6woRRkn7Yt0dbky42
   GMY6CAEnPctWxUtLWFHR7m+upj6xskur57uZYxOnhOPjcXSS4UGjooZC+
   oPfEbUQdWsUV9dQ7FQqhIGveByA6e10zNkLjuLNqoDAjFMJ0cLcLsDlGx
   3RM/FWpvHzdg8gXI/iY6maP7DloEX45KOZvns4gDjKCQ8HkI9taNPRmLe
   g==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="188163303"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:17 +0800
IronPort-SDR: 8IZ05195+BcDfMLrtDcHFJc00krhrjBk/B37Aq/STiUQWwILwIA41gLUXdL1N8u81YRWNrLh9U
 rOf9EFWUr2OzSSy6fZ23ArbEJseVS7DcYmsQ/yp2LSATZH7E7DdTCPkS4EgR4k1YUpkRh3y0/e
 jMxs96gbkskFCIf7wMhlBe147vnm1A1wq2Y2h+FDEj4ld0y8BWxjjDfhVIok3Jq4Uh/lWzoQIY
 IW437vZZNn75Fm4FImowhtDARYhHuT/KJaek7WKQ+zNUxgKlfqBAP91Vme6Ndyg52UQGeMvu9+
 VU1VaAPv3eR87RSgc/iA2JY1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:44 -0800
IronPort-SDR: tbaRajd++4ZNjEkpT6p1LgUHugjoou35LWH+e4k1G58yW22Z0fQD2ftUTOmER5uN8i2kIt8JAj
 vdDXdEcUbLTMrNjhFrorIgEhR50M99nyz9JFYuyr58kY7UsCGQpPtGSShLfS4/Q+ZCxxc7pBSu
 70/2zyC45YEFv6Zw3yCOVYGFvX+URpHGW9xh4AmtzqDZqkQopfAzfioGS4vo8rr5pXIQC7lc5j
 ud5ZvfdH7OXD8sJsIg5N4GuiytVNEbSJEnFiv8emowNnfnhQjCdq/L+ZVRGR/8MscGxIjsgC08
 hec=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdY4CWZz1Rvlf
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:17 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445056; x=1642037057; bh=3JsbmqK1/VeV5BtICT
        6zSAZDbpI8NRKlxrV069uVOJY=; b=OCwK0SauqDb69tyxJ4hPSnb871APxCuUHK
        JAI3qv+c+TZA1y2ybwsqDIBvdFokhIdgIDwM7csg1CZz/PujS/MMNRIKGqTDbGep
        VLftQ5izpfON3urv4zBvS/fJywHw2WB68dnMoXW8Z5uyT6RCQ0/V9HOJnotoYJF4
        D2KeKtRhjK6TgneM4pC6Gu1h61hEKX/G7g0LD6fb/I3Gsj4CPvgZ61d29YsMrJzD
        iPwKctJ0X/CMD2Kx7fRSikLOX3kRyXnSRgauFhf/zN69xBDY2pMg8Rdlb+I4bYkG
        dyLs1ZRJqO2I1pKCxmSIcHo7lskamQDnEJ6qtxN/zf3Q2z+UVXoA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SwFvMHfUQkhx for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:16 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdX1H1hz1RvTh;
        Mon, 13 Dec 2021 17:24:16 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 01/12] fio: Improve documentation of ignore_zone_limits option
Date:   Tue, 14 Dec 2021 10:24:02 +0900
Message-Id: <20211214012413.464798-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
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

