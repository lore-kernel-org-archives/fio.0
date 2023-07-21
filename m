Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B768EB64DD
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 04:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjGUEow (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 00:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjGUEov (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 00:44:51 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4981BEF
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 21:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689914686; x=1721450686;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tT6MOWx4WlttcPc0nRgPfz1hkbC8RruoxVa9Ftqsy4s=;
  b=ojquTxueOD/Kq8tAPH0XPCP3B9oiehl2EYFYIT6C/eGddUVRf5gGHo42
   3dRS2RHl7MVIkXnkpmHgeWLBQtFX5/OxMkvcllY6dZEV49oxbllH8b79O
   iI6OKlc77RcocEMQfYDhhbuUx4AK8d13h9T+sEifm8ghRBsNTTcJ6RYUI
   ipfNGtsEV+mSEJwrjjWGRnb/0JkXuORRlIyH8N1qu7VGnUVOnNuE6aeDo
   GgnyVbJ8HigjZpINxDdasPbUdTS8T+IxvGGGthNHij5bFX14Fud9C6i/Q
   j1G9YQeK493txadaEZ0CeY/T6AEPqAuBtAm+KvZJZ/2/hTb7ykO9yMiVc
   A==;
X-IronPort-AV: E=Sophos;i="6.01,220,1684771200"; 
   d="scan'208";a="350640375"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2023 12:44:46 +0800
IronPort-SDR: A89lBaMHaqeS2HChTUETK4nlijqhe5ma3tdjit50bfic2GXCLEpeEHxfXaezG00mcWA+xwlNbV
 7abu16ul/cxSThg4R3V2R39Up3WCYqqfmTKqGaq71W0TG470wMQsWqdEKFTU8S6fN36WduE0gq
 ePwCmz//BeD+K1HOxQI9OdOtYuI8B0okTVDLNdh6y4pnKTanGm6hcV1jXG4SPDCG7cEXGyvhKZ
 qtLwnI5WDrouYerMpy1P1Ad/SGhOhhR5eSY4lwaz9y7c8M1pKQWUW7mim+dNtqXg6s7KnSKkPQ
 tPU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2023 20:52:56 -0700
IronPort-SDR: YaJhiBzzLc5ExiNmKkFjv3MRNjzJfaPIAbW8llKFoLLXoQydN9f7dQx4pJRHiNoj60+A9PMb39
 7t05oSErRSEhmC4JGIjehdAtbl5VaryzAXfoWHl4Rai+i7JfaSbG8Br7Wez3VuQzxR8fBvxOZT
 AVkm3WRHAOpZGoQQp0+a+n5pkqJJ3BRIriRkWsHHj4njKZ6vxwBQOSqOPZ4/TE1+qEBfyi2Ur6
 YkR7GYyl0s6SxqPLSegCaD1yc+WNqzylRcng24vPimoUjeT0byNl5rhyOC8hU0HKcqU9Seq1rn
 cEQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Jul 2023 21:44:46 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] backend: clear IO_U_F_FLIGHT flag in zero byte read path
Date:   Fri, 21 Jul 2023 13:44:44 +0900
Message-Id: <20230721044444.749537-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When read io_u completes with zero byte read, it sets EIO as the error
and put the io_u. However, it does not clear the IO_U_F_FLIGHT flag.
When fio runs with --ignore_error=EIO option, the io_u with the flag is
reused for next I/O and causes an assertion failure:

  fio: ioengines.c:335: td_io_queue: Assertion `(io_u->flags & IO_U_F_FLIGHT) == 0' failed.

The failure is observed with blktests test case block/011 which runs fio
with the --ignore_error=EIO option [1].

  [1] https://github.com/osandov/blktests/issues/29

Fix this by calling clear_io_u() instead of put_io_u() in the zero byte
read path. clear_io_u() clears the IO_U_F_FLIGHT flag then calls
put_io_u().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index b06a11a5..cb5844db 100644
--- a/backend.c
+++ b/backend.c
@@ -466,7 +466,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 				if (!from_verify)
 					unlog_io_piece(td, io_u);
 				td_verror(td, EIO, "full resid");
-				put_io_u(td, io_u);
+				clear_io_u(td, io_u);
 				break;
 			}
 
-- 
2.40.1

