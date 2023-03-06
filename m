Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4650EC6FA9E
	for <fio@archiver.kernel.org>; Mon,  6 Mar 2023 05:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjCFF6r (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Mar 2023 00:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFF6p (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Mar 2023 00:58:45 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FB159F1
        for <fio@vger.kernel.org>; Sun,  5 Mar 2023 21:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678082322; x=1709618322;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KOoByybyBgGZlsSDk4Cgw86YuVdKJyfY1Jr5zIoLH4Q=;
  b=J4hGcqHbKiyBeX6pl8DX9Atv1hU3iFvUhNsyn2EruIL7GjOv/NqibZiw
   STgHssmue3S5rWUP7Dv8P7U319MCaE4JD9VrhrLiVyt+Uf441sxmCVe0k
   dfWItn1c0nKBIwxkP9pykcY0MvQ4cd+kuYW0ZsD4SSAeOTlokmoOJm2jp
   gijjQgH3V5sA8hp5vADAixXPAYZN2KV8OpIotYy0kboLh+Tj2fAVx5Rj8
   lukYLnqNR+teE+6uRsjmcco8KIdkAjgHeaHKrnnYaD/yjnNEZ1Enzfa6z
   GtKaaAAhzwHzSKpiF+5yVOHaPczaDWzN8n6BBcEB3yImCUmc9nOHB7C+g
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="223161441"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 13:58:41 +0800
IronPort-SDR: vt/jSCxmFGlNTINgPNU4fmCqbiYIybUNxM+rFpGD61PjBVu1fbkiNSYG6wAXoJ8lFcmC2Uam9F
 487mBTUDh9JaC6fr28pUg7plV+8UY4VgSUmYBIB2vL+qRNSCERDl2jxN7nzX/y8Aa/cYnxtOQV
 fzymgKYU8XxLFKZmrOhFmTm5zJZAtuYQyDgg6/sSgkZznikl06jPTmEVbKr8ptwLgEDzT+sTpF
 gsDBbm6Z8zFQd7ATP13PlrKYdCFljcabNondSCXoHvHF8deiXFubxDvj9axSu+X5WQUf3AGhXO
 Fo0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 21:15:23 -0800
IronPort-SDR: lDb1ScaxHvxynrC+jrU7vhQZnw2n6QOh2palPFZaGoV0kc7C8girVr8CBPYDG8CwTRD5WYSv17
 MaL6e9hN2eBj51I53Uz06N0Mhiy94OaGpCCOPOg1meYryWTVW9PVgYsq7YCfn0wehJuCVPS5S4
 KV95pISP/etgtzk8epGLg2Xr6zI4nQK6nZNS8efmbSURrZscj4WbIuAARor2uoF+05OvNknVOI
 a1qBiHN1eZoBaP3vf0IHybF7c30qrD/3fHGdpfEiEVa4P9z9bNv6D+d6m1/rPBrbCxh9OPXgk+
 eWA=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2023 21:58:42 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] t/zbd: fix minimum write size to sequential write required zones
Date:   Mon,  6 Mar 2023 14:58:38 +0900
Message-Id: <20230306055840.3375830-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

ZBC and ZAC require that writes to sequential write required zones shall
be aligned to physical block size. However, the t/zbd/test-zbd-support
script uses logical block size as the minimum write unit, then some test
cases fail due to unaligned write command errors. This series fix the
failures. The first patch is a preparation. The second patch fixes the test
script to refer the correct size as the minimum write size.

Shin'ichiro Kawasaki (2):
  t/zbd: rename logical_block_size to min_seq_write_size
  t/zbd: fix minimum write size to sequential write required zones

 t/zbd/functions        | 28 +++++++++++++++++++++++++---
 t/zbd/test-zbd-support | 42 +++++++++++++++++++++---------------------
 2 files changed, 46 insertions(+), 24 deletions(-)

-- 
2.38.1

