Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA11C433EF
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbhLNBYR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:17 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51731 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBYR (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445056; x=1670981056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iGDLSgslMgwbPDKW9/61iEc25EMmpv3THVTLGOI0zGM=;
  b=d8R1NS/ckJ/5dVpK2ySQl3w3oY+Xv1mkGbEQXWez9VX3AIrIwD4IZEko
   sCvgyrL3daEvnWCAwODmk4bFhTjw9uYBJz76kX4RiEflFoAdYtzwFQyO3
   Ver7ZfbD3MNjJpkhAAphu/uQAXsGMVeV1e99U1p0s+qbY+sSH1T1EduMp
   nwgw9RltH01LB2hVU3Y4DJWh6icobD5bUPAjLXvzOEQaKx7iCVH4+70Ds
   S2CwJg7DQHBgXhkhD45/pZp3Jz5J2AaIZybr7HX3Br23IIV8UTg9msHIb
   Fo1MN6CwqHSjEa90h/9F+Rh02ehlIZmfmwzg6H1IEaWHrHWADGckO0zb0
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="188163301"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:16 +0800
IronPort-SDR: grpGyrtbiXnBmqQidj14sk86ERK+S8MBBxllW560ak4EETm08/Dadqf2JvhSzVzzjogKrFaFdr
 luHGBjxxIbfxPTXoJfZMsoRUUEWwurIiuKN2iybuf8qERj9erAA4xGVUx9y1NnrtpJI84YdGAa
 PY0NtBJ++aK1S7YTCKTW8W/ac4pixC1BJ0fbSwCBMnmMjigewUc/wjAHltmOsgMmG3gIu/kBW4
 oBzbjUGeCcBBdtOyzHXt88oSxGaVl+J2V3E6oOc3QiXTRUTQkDbHsbqQd+Xc/k8ivgPxGhhMR2
 UnlwzQL5IPnrEPt+pvTL3VJl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:43 -0800
IronPort-SDR: k8mOS8tvELh0inlb1sbF0xajSAtwRHN26hw2plh9TEuYJCQOWtO+ndAHjtAza58iggDHWFmDmS
 rAYhDilJ7j14Gicdxo3ZMKSVkalzwb2fP66fiOqUE7RIoTlOnXyrCmsyDj4SmVImOafZgjwgRK
 dsSolIvWMwfg+KqgEH1TSWd++2KsIukPcWVafGVsA01ItcP00uLIP+o+L2pssfizxn1SsLGtaz
 gS9sNEoHAgPptACW9xxP1jvhpLTXa26gn/UP2G9vbpo+Tp1+a+8iQTdns9eLzoZclyyZ3tYmlH
 lvg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:17 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdX56h7z1Rvlf
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:16 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1639445055;
         x=1642037056; bh=iGDLSgslMgwbPDKW9/61iEc25EMmpv3THVTLGOI0zGM=; b=
        afn2yEMJSfRBkO0i2bTAmLRBoOwClhAEfPPVi/9zx9MPgeR5NdebgM6p6qWYxq6K
        GJKwHEpeyjNZQDsCaCmIQ/HPgMuRc5PSl9u+XWLO5e2Xi8zNpK6tb0E7okFw8ikr
        NXlVMfsTmjvCWG2ScU9PhmKOVTDAK48tf7e+4nz8XBErTdq5eUXART0fZhlCy/jO
        La944Yt0pYL56aR2TohegyP4WQyP4r1uKyO1aIRDMdo5lteCv2sG20BKLF8TVmLf
        jc7YaPV2YdE5ir1t3F6Jhw6QVVsjm4Sis8BRSIx+Qfze90r4XyuPmVbixWsGrh9h
        OGMSuiCBmQ8K4hh5aVw3tw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M8-o4Wtu4FPm for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:15 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdW1Swtz1RtVG;
        Mon, 13 Dec 2021 17:24:14 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 00/12] Cleanup zbd code
Date:   Tue, 14 Dec 2021 10:24:01 +0900
Message-Id: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The patch series cleans up zbd.c code, improving code readability.
Patches 1 to 11 do not introduce any functional change. Patch 12 fixes
a problem with the zbd test script.

Changes from v1:
* Renamed zbd_verify_file_sizes() to zbd_zone_align_file_sizes() in
  patch 5
* Change function names as suggested by Niklas in patches 10 and 11
* Added Niklas Reviewed-by tag
* Added patch 12

Damien Le Moal (11):
  fio: Improve documentation of ignore_zone_limits option
  zbd: define local functions as static
  zbd: move and cleanup code
  zbd: remove is_zone_open() helper
  zbd: introduce zbd_zone_align_file_sizes() helper
  zbd: fix code style issues
  zbd: simplify zbd_close_zone()
  zbd: simplify zbd_open_zone()
  zbd: rename zbd_zone_idx() and zbd_zone_nr()
  zbd: rename get_zone()
  zbd: introduce zbd_offset_to_zone() helper

Shin'ichiro Kawasaki (1):
  t/zbd: Avoid inappropriate blkzone command call in zone_cap_bs

 HOWTO           |   6 +
 fio.1           |   6 +-
 t/zbd/functions |   6 +-
 zbd.c           | 963 ++++++++++++++++++++++++++----------------------
 4 files changed, 531 insertions(+), 450 deletions(-)

--=20
2.31.1

