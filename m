Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B899AC433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhLJCTT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:19 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33935 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbhLJCTT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102545; x=1670638545;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MieVJk4hey7zVxTlI7x/YLCsPYNMrIuXhwjWJbrIVX0=;
  b=nYQBL8kSvmRtsSJJQP2TuCTrncxw43LqXxeQzN8XxzT6bw1uMnGXRO5N
   ODYaRDdVTo771sW2w/RNezl2PZSPRGnDGTNtEZiy4NxVV08U6qGctckAY
   dA+0ms7CiGuyR+2goJRRR/guq0fIDp3E5xVvY7tWfQgxsi+ZISz2rnWL7
   bjITf2vP6P/pc4ERf4uHqjuhVeZvZHe/2v4yFJux49/Nc9gLXt3Du1esy
   9XImD2Hc1A/fvzNAKBY5nOgOhJ1a2nycIhazj+yVBbcZIKJe4MNH87n0c
   mIuavuH/yP2UoOAoe8wgI62JgxDm5MhHDZxM6GRx/dMRYtwfh/6sROPAe
   w==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907572"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:45 +0800
IronPort-SDR: +kds7hoimzHfh+1kBbmCsrJnCeRLIHHWZIH24TUaJZfENI7p3/fsVdgBD9B6fZHJEfsOnMdLzg
 XRr4kG48uANEK+xDej9HVRbebqlxvk/MTbB1rYAdrw98jd8Ct8nDZ5mP3R3xsBN0h4H5GoZb9h
 kGZvnPABkDOg7WbWIfIhqWMTdBXeF04D1A+0KltRFVM+wsUlabAms9R8ht0FOxLTe4UxIvkFJI
 WOsLJDuBWU87sAWS25shuJtRzFlXQff1rj9cDSogA+rMm8RCTgZzBKvFC7fvt7v9bHye9TYQxF
 7vs+nSBtm8Xa+gPvsD1NxY6C
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:16 -0800
IronPort-SDR: R1q7NgrcbFkS1R3EM6yiKUKeOLQ2ov3Xr/W9/bU6MdxD4/G0sufK5eaBm+wnrS+u1g75YNVBHV
 rj3yGTH1TYBcyCL/bVECGBhiIgYmeAJ0RmoREr+phxf0c5uWJI4shDYyR6BNBpbL1Vlta2LmNw
 gMBDcB/yAMmNHbyl1KB1lSwCwyAm4aphtIeC6R2sivQf5TzB1bt0CZZ03v5dJykW+v/+gdo3lP
 rXakSAAAtlx4XrBPDqx3YFZFZ8afJVNWQn7s1FOS4tGxHoGOzppRqh75k60/ycM6lMkFNSnUwm
 Y8Y=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dym15LNz1RwFN
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:44 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1639102543;
         x=1641694544; bh=MieVJk4hey7zVxTlI7x/YLCsPYNMrIuXhwjWJbrIVX0=; b=
        pWPadEe/DEWz/ujPJPzKZo8fhSFk+dlDiQTkPe7306OgE7SptZ0wz15km3ZF5CEg
        ShhJW+YorqVNg/Tl22+X4jpdwkcDaMTTYuSqp1Twaqqemrk5kywz9Ar9TD+FtQ13
        A1L9h95rGr1aUwNm5z03qUDPblIamagKXj8wzzidyw1hPI+wQJ6LU9jonyRtxCV5
        badWpadG1/vmQcSQtR/JJ+jag2TSvZGJ7giJ35s9jdI9TurEWC0PXgFgdPtphCKC
        DLk2krdXCzVK/0YrZjPRFDYDOGXtuWjeyOtGDtwxttT1HTfBstzrDVvVZKMdlKGj
        NYkNdbiBuxGqDyhEzOmVxg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vLTQzf3o_QBz for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:43 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyk6sT0z1RtVG;
        Thu,  9 Dec 2021 18:15:42 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 00/11] Cleanup zbd code                                 
Date:   Fri, 10 Dec 2021 11:15:30 +0900
Message-Id: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The patch series cleans up zbd.c code, improving code readability.     =20
Overall, no functional change is introduced.

Damien Le Moal (11):
  fio: Improve documentation of ignore_zone_limits option
  zbd: define local functions as static
  zbd: move and cleanup code
  zbd: remove is_zone_open() helper
  zbd: introduce zbd_verify_file_sizes()
  zbd: fix code style issues
  zbd: simplify zbd_close_zone()
  zbd: simplify zbd_open_zone()
  zbd: rename zbd_zone_idx() and zbd_zone_nr()
  zbd: rename get_zone()
  zbd: introduce zbd_get_zone_from_offset() helper

 HOWTO |   6 +
 fio.1 |   6 +-
 zbd.c | 960 +++++++++++++++++++++++++++++++---------------------------
 3 files changed, 524 insertions(+), 448 deletions(-)

--=20
2.31.1

