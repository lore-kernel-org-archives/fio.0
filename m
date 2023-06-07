Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63974C77B7A
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 08:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjFGIcf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjFGIce (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 04:32:34 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A59E10F8
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 01:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686126752; x=1717662752;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AUmR9xnDUWMiAXUjcqlEIrnN5VETPzih1AhF7NikLHM=;
  b=nzbM6yWW7LRKhHKN22q+tyuHPOS8CifG1Vf42nguVCAzkEbFd67VjKUm
   XGFp/Keh5nXuMB2vb9HJh1BMG4eJtG2uyKThniJruYxb8sZ8ntO9HiZ5O
   LdT8Q16LP+p5KKgABlpZwbdWvHHdNBc5vdY7njALUG9/b9niDfO77l6qk
   ZA2RUC9G3fAgvX0i523NJ2PCvZ84OTljzI1D11u+g02KifXugRFtB7fHK
   R7wg7abPn8Ys1uaWmbbtwT8KAbnOcxyUwPLXmW8Dopx6U1qLrmh5njOH1
   p5dehv2vHYMYQKGFVLVduko4yqzed1BD6JuVolffYWwU3oyOkPz9IIAKT
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681142400"; 
   d="scan'208";a="233003992"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 16:32:31 +0800
IronPort-SDR: Nu0zyoOulBKlPAJO3Kw8V8trqPx3THVasSTXUWT4AiOYGkifCRf8KvqIMDma5BKAv97eQyC/xu
 sgFuyvCrG7mAtQRR5DOVrk13pHrsQG5Xfv53plG6CWfUOBpVh/RJCnZ45o4h6OU+Ic+tUrB1i3
 ae5AQ604RdOLQVSLpnBbXHhqJ/W7bxXsQaBQPfj1zgjLCfVnTEreQ0BhzEGQDIObA+gllNpLsw
 Q1+MfDA4ZQ2+0Kt3vo+7g9aYhGY9jJEWkn7AT8O7C+ML2ZqvxeND0qhHs/qWxda2JaPZ552cTx
 t44=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 00:41:35 -0700
IronPort-SDR: HpAAl+fQikM+eCDBzvDDZiLrOMzePHZZBDVLpUApj/K7ycH8iUI0OOUPj0TnFOEuK+p6zQEErz
 RfJMLat180C2Sii0MrCgA01pBPmiHSrFHZxyeHD2OspgxVuEk4PTiYmIIbmJaQ7/GpPU/TCJuU
 HdNG8Jg972hoW0i9gBsXA44tXV3f5aFHEM7MzNQ1DDa/Rv7aV8ktYkUZYSWLS7RAUDJOk+DLG/
 Keh0tTNRf8JLP1fNfqUm3DJQZGyrcdlSsh8BczZhtWWmCTx0Kt0fR90MsWcwuIKcPqS13w6YmD
 puI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Jun 2023 01:32:31 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/7] zbd: clean up code and fix bugs for open zones accounting
Date:   Wed,  7 Jun 2023 17:32:23 +0900
Message-Id: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fio with zonemode=zbd does accounting of 'open zones'. However, the meaning of
'open zone' is confusing because its definition is similar but different
between fio and zoned block devices. The first patch in this series avoids the
confusion by renaming the word 'open zone' to 'write zone'.

Also, recently three bugs were found related to the open zones accounting.
Following three patches fix the bugs. The last three patches improve test cases
corresponding to the fixes.

Shin'ichiro Kawasaki (7):
  zbd: rename 'open zones' to 'write zones'
  zbd: do not reset extra zones in open conditions
  zbd: fix write zone accounting of almost full zones
  zbd: fix write zone accounting of trim workload
  t/zbd: reset zones before tests with max_open_zones option
  t/zbd: test write zone accounting of almost full zones
  t/zbd: test write zone accounting of trim workload

 engines/io_uring.c     |   2 +-
 fio.h                  |   2 +-
 io_u.c                 |   2 +-
 io_u.h                 |   2 +-
 options.c              |   4 +-
 t/zbd/test-zbd-support |  64 ++++++++-
 zbd.c                  | 293 ++++++++++++++++++++++++-----------------
 zbd.h                  |  25 ++--
 zbd_types.h            |   2 +-
 9 files changed, 249 insertions(+), 147 deletions(-)

-- 
2.40.1

