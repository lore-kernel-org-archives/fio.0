Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E62C4332F
	for <fio@archiver.kernel.org>; Thu, 15 Dec 2022 01:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLOB4M (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 14 Dec 2022 20:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiLOB4L (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Dec 2022 20:56:11 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1A0A445
        for <fio@vger.kernel.org>; Wed, 14 Dec 2022 17:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671069369; x=1702605369;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f+ZXdTgVL7/7FjljyPoPPs+rTzYFJ8LGVhUDWhh2b1o=;
  b=fZRGgewl0ecOwHkiZbYCzPg+ea37zicX7BBCaZYrbf9HTvci/0iNnOxt
   T6L1jp6wryl6NnkydIJJTnZIiaPTgw2jHd9Nu06TUeSCc/pC5n4wd8UQJ
   TA1/eVZfQLlTRAd5fgEb1pqCu2P+4s0Z4G7nozGyzU1CqRyn4ByCWPaSb
   1RFFWo6iFSXehoc/QllAJqlUoWqqBmYx3ajlbffDDav9GN1i3DlIJt+yu
   lR5pyqd+d4w6JiRsw5yCHovveM67Vke3rSdxJpXKcL/gayj+twdlxDQcl
   3wWzpF2gggAUbIvNQNFIUi3MZIVrq0kEYTm/1gf6KftCLo8iHBzFtnfPq
   w==;
X-IronPort-AV: E=Sophos;i="5.96,246,1665417600"; 
   d="scan'208";a="218930644"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2022 09:56:08 +0800
IronPort-SDR: +kOF8eHv//Y3BL4fqe+vqYlCRHSxRgB9pz8JHrFmYNmHbUXr6bKvp9ieQfmp4v7MajQFYDYsDu
 cVawR2twx1uhAiMGyXBbuP+v6cSaZBkqmUfcrShfJ57HJ9dcQ4CMjeS6KlHFyORJ/8srFchdtX
 mKS2/kNPNIymZdHmOE7o0ZdO3ju+YY3NiWgYMgwpUJK3FP3bCjswpooRnOP7D+oTJ3CBHL+7YJ
 t/Jua6Yvob9mc6Asq2ls5Uq7qWtEh3RrLFmqdU//1fyN3C6rXmN/bI8VijGUED0DnQQfdhJ8FW
 byw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Dec 2022 17:14:29 -0800
IronPort-SDR: NpkfIcuhUL6SnqMZWqmqMT7JbK/oDgBJAM0I90GXoHAOfMnwvxBrJTpRY36qY/J6ysgWnQ/AbI
 thLf6UcGE5K+2W1IF3HFAZZA2FKmvAGGLY4hhmkwq7L0Ne75QeLGoxipiY6DpQHQoEsVxAzppl
 UfVYNja3qbJIbAZhSo5qkSRo4ZAsY8njUDB7v5BpQSCHhK338291xbjZNJsvNavUxZyOy+YLKo
 JfjIC5ubWzCI/IHz+UGJwR6tGeDrI410H0v6wkbP3GjJjPTf+86LKgapAtKnjOabETrC+ux1Lx
 5QI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Dec 2022 17:56:08 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/4] clarify usage of options for zonemode=zbd
Date:   Thu, 15 Dec 2022 10:56:02 +0900
Message-Id: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Options for zonemode=zbd have some confusions. Clarify their usage by improving
HOWTO/man descriptions and example scripts. The first patch fixes a minor issue
found during man page update. The second patch improves the descriptions about
max_open_zones and job_max_open_zones. The third and forth patches show how to
use zone_reset_threshold, zone_reset_frequency, trim workload and 'z' postfix of
size option.

Shin'ichiro Kawasaki (4):
  man: fix troff warning
  HOWTO/man: improve descriptions of max open zones options
  example: add a zoned block device write example with GC by zone resets
  example: add a zoned block device write example with GC by trim
    workload

 HOWTO.rst                                 |  27 ++++++++++----
 examples/zbd-rand-write-trim-gc.fio       |  43 ++++++++++++++++++++++
 examples/zbd-rand-write-trim-gc.png       | Bin 0 -> 104661 bytes
 examples/zbd-rand-write-zone-reset-gc.fio |  27 ++++++++++++++
 examples/zbd-rand-write-zone-reset-gc.png | Bin 0 -> 59186 bytes
 fio.1                                     |  25 +++++++++----
 6 files changed, 108 insertions(+), 14 deletions(-)
 create mode 100644 examples/zbd-rand-write-trim-gc.fio
 create mode 100644 examples/zbd-rand-write-trim-gc.png
 create mode 100644 examples/zbd-rand-write-zone-reset-gc.fio
 create mode 100644 examples/zbd-rand-write-zone-reset-gc.png

-- 
2.37.1

