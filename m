Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896D8C4332F
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbhLNBYa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:30 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbhLNBY3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445069; x=1670981069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fmrMcVQDbkhBGCSb/F0hNhqheiWK/sw12Bybdj1UPHk=;
  b=fRRsHfi3PFokpmPDWcsAX337Pob0z19Bkm1BfjEvg4hEEm5uR89sGCuV
   9pmRdByC00LGJV71PkAQF0RVR+1jCQdhpD8OguyD5phlYSEl5JufV9nsx
   HQ9f85OpvG1AGPPEVaBXq4rwVE/Ej5KvnrJlYvi3C2VZcP8++EctXrsNd
   O7hjsqS0IKyfdexV1TLyJDDvZ0ARdhEvGDnSvjggjmZ43ewuQT4vxpZP+
   79j0I7OuDrSRE6YFosWXHIa46gTPzXn4gmIxJu6rB3OmqHxQp9jwzjSow
   sM2fJKauJsQw1LhGLpt4KCTzY89QKXlWSel71nwmYM5zHiTZWtJKUE+sX
   g==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014512"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:29 +0800
IronPort-SDR: vo/3tFH1909mwIwCL/j+g/TEBhDt6Ij060uJXEqb/zhluCcVsBy5fZTUiWD2poZzvmk1jL6E39
 Mod8J2da9Irc5mz1QR0i1XxJLjgK1zU74dxg9jzMTodmp7UmWewFC9RWDfeaHxpGVKjX3+xtmo
 nPIu6G89pPmTle3wKpjQ6VnUfhF1JXfHH/Mzg2gc2Cppq7EAjYfjYVUkLZY40pplSbq4f9k8xD
 xqBOY98dcv88p8T8m+Iwz17RVaEMmOWjTQz9GMe2l/HzFsX8DQ6uLwW7q4mgdkMsltV0zSyfCa
 LG9sdAjklUBqYDsy2jftiSH1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:55 -0800
IronPort-SDR: sBM3nERk5fynWAPv/vKpyK2WsJD2uRDr1CLOWBMJEW6a63TVICgg9eSOB6+prxcI//R5hLW3nW
 E6Uxjmuk3l6et+kXQy142Nn1lmGN0mzlfEKoGI34LSZbeiAwJP1Eg7nA+WJ2uCSMZQr97FRBzf
 9/5/8w6UMvpoRMv0CF6iCkgea47xQVdomlkq2Avd5UNF++AF1zOKrQRF73Xg8w8ZlHrAivO7te
 fUQ4rXiZEe6Q+YUQE1eAForzvD6eUKcJ/Q+EK0kXPZ94I48/o6TLk5munPfwaXBGPd11X+V8QB
 u5o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdm73h5z1Rwns
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445068; x=1642037069; bh=fmrMcVQDbkhBGCSb/F
        0hNhqheiWK/sw12Bybdj1UPHk=; b=DCDYjRKLIO/LX9COsL3glJpuGRVOi16fXI
        skwJtHuy7uxqyZdnMnWY6At172YUbHLwggSCNgQaR8mckJQZCbruYj1XnXCnVyXn
        FSlHgfP1Z7uJ8poM4PSwhsMyArMAlQGCo5UOa+pajlw1iR30qEaA5jzhWu+awfXx
        i3WCURR2N63MaS6ETb9FFSwaC+gM2dh7Nq8JIIceda1m4KxBRptDJz2INyc38Lff
        9y0tbH4Fpx8h7z5Eug8o3k5zXhlmO5NVG+MU2GochXoiKFmqkcUUaRc0WOpF4E8/
        zbvA1mdtv09KSsBafKSdBDnjqXZeGeqpg55VgAZrL2e6hXjqMiIQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VV315X2kIOy4 for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:28 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdl680Rz1RtVG;
        Mon, 13 Dec 2021 17:24:27 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 12/12] t/zbd: Avoid inappropriate blkzone command call in zone_cap_bs
Date:   Tue, 14 Dec 2021 10:24:13 +0900
Message-Id: <20211214012413.464798-13-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

When the script test-zbd-support is run for regular block devices or
SG nodes, blkzone command shall not be called. However, zone_cap_bs()
helper function calls the command regardless of the zone model or
device type, and results in error messages such as "unable to determine
zone size" or "not a block device". Avoid the command call by returning
the zone size argument passed to this function when the test device is
a regular block device or a SG node.

Fixes: 1ae82d673cf5 ("t/zbd: Align block size to zone capacity")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 t/zbd/functions | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index e4e248b9..7cff18fd 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -72,9 +72,11 @@ zone_cap_bs() {
 	local sed_str=3D's/.*len \([0-9A-Za-z]*\), cap \([0-9A-Za-z]*\).*/\1 \2=
/p'
 	local cap bs=3D"$zone_size"
=20
-	# When blkzone is not available or blkzone does not report capacity,
+	# When blkzone command is neither available nor relevant to the
+	# test device, or when blkzone command does not report capacity,
 	# assume that zone capacity is same as zone size for all zones.
-	if [ -z "${blkzone}" ] || ! blkzone_reports_capacity "${dev}"; then
+	if [ -z "${blkzone}" ] || [ -z "$is_zbd" ] || [ -c "$dev" ] ||
+		   ! blkzone_reports_capacity "${dev}"; then
 		echo "$zone_size"
 		return
 	fi
--=20
2.31.1

