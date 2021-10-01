Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA17C433FE
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B016161361
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353588AbhJAKeo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 06:34:44 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20618 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353585AbhJAKeo (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 06:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633084378; x=1664620378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pRJ1sMMikSqIOpQcmoFGuWUBh2VG9zsYj1cP1dqU0BY=;
  b=be+D3QmYVfLsyjAyFKB8RCADqAYBPyk3Vb36V40Fb8fu2PP7wYgGwXeC
   TGnwCoYVF3MYHeJ6OMvjJvbAmeVbsX+Nr1eeOqrI4DCMBPV2eXtp8bNsS
   U5ZH9Khe98vV18XXSN/k4z0egebuANLYnCKEKj0/af4pV52lirWr6PNC6
   suGaE2eE8MMbG830yGI2pPOVTJkXBCD8TPr52bWU7Ag+srHz89p3HBjvq
   r0Irq4vokEGqrkkIzJ49xKR4flVGJxPCj3mokWyW3WBltV70zFrQ/4ngB
   vAMsalS0iZ5kEPP9WaX2P9RMXho44zYpyUPZ0C2CViWtGOgTY522PGRKd
   w==;
X-IronPort-AV: E=Sophos;i="5.85,337,1624291200"; 
   d="scan'208";a="186328211"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Oct 2021 18:32:58 +0800
IronPort-SDR: 12Mb36Hn0YLp2DxERSkAx8v6ro+RYc/ZihmGoeFxir79zPyEzjgRyYde/PbqcCf9WnwcmQXSwa
 X49tak6uiEa9+7bZY/akoocPtGcgaDcehGwshHpNli7+7Byoz6GB2UGOUhQzU/Vg2GqcIrKkCB
 A7b47gzslMXzeGQh09OpUZuUylA75Wp8DWA1OhnY39vp2UJLRgUDg0+vGzrL0VkGnP+uRx4Iuw
 PTguvwnGHdeqskBerIbPndx0WEWkS5T9jZd+IP0PU7UHKuAUJ/zRNoxv0MlJk1nkLnEacipQhu
 DqGChruyToEv8UWaVrWgOPcr
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 03:07:28 -0700
IronPort-SDR: YQS4yT9I/kw2tO2YKPEBRjt+aIuHzgN/ff8+C41fLFC4jxv04AXZ1kxGMx+lYVlv7RhgmNqQP+
 IVBQMmP163ZlHb9vNlDa1jadvGrwmuA5eC2Tqf7jRxPWtdNYmB6DQZ3eELmiR7cmHmXZ7vnXiv
 Me5ZGYfFGr2x3Vy6Gbn4L5XVIfwzf3O8GybjDOGjzh1C9WoTS7NW+/OH1tyEFY3vebYQcZCY+e
 60l1EOdousjJThkLZBoTmxceyAYSQ3H5FV3cBesWS7ez9aDZXQdJ+pX21GxZ4G99ApBLChJ1ak
 bQI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Oct 2021 03:32:59 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] Revert "Fix for loop count issue when do_verify=0 (#1093)"
Date:   Fri,  1 Oct 2021 19:32:56 +0900
Message-Id: <20211001103257.4130231-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001103257.4130231-1-shinichiro.kawasaki@wdc.com>
References: <20211001103257.4130231-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This reverts commit 499cded5f435a0a7c379b606eb3e903d7f43c360.

The commit enabled clear_io_state() call in the loop of thread_main()
after completion of IOs, regardless of verify option. This sets zero to
td->nr_done_files even when the IOs are sequential workload with holes.
Such IOs depend on td->nr_done_files to judge job completion in
__get_next_file(). With zero value in td->nr_done_files, the sequential
IOs do not complete as expected, and results in failure of a test case

Revert the commit to avoid the failure. Regarding the loop count issue
with do_verify=0 option, another fix patch follows.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/backend.c b/backend.c
index 4c260747..86fa6d41 100644
--- a/backend.c
+++ b/backend.c
@@ -1920,13 +1920,13 @@ static void *thread_main(void *data)
 		if (td->error || td->terminate)
 			break;
 
-		clear_io_state(td, 0);
-		
 		if (!o->do_verify ||
 		    o->verify == VERIFY_NONE ||
 		    td_ioengine_flagged(td, FIO_UNIDIR))
 			continue;
 
+		clear_io_state(td, 0);
+
 		fio_gettime(&td->start, NULL);
 
 		do_verify(td, verify_bytes);
-- 
2.31.1

