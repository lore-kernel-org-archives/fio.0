Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035C2C433F5
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E379261361
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353585AbhJAKeq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 06:34:46 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20618 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353595AbhJAKep (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 06:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633084380; x=1664620380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BOSGA8OpnxtLlVLIonjzOn747heV4Vu5Rn8Rza4wHdA=;
  b=oojG5+ml9Y1YKfYt8FMBZrkyJajGqH6kc3R1Dfe1TZ2A/dff/bJwH0UA
   O09pf8Ywv1rw+JJv2f5F9SEPrJpRxFb8d/BPqw2Pj2xybe3O5rsZldAob
   a6lY4pC/QWgHwG9epuJO9Pwr9mjs74mFadYwoaRWm0vVFkcbykuxTR6I1
   D/+88LTH2Q4S0Z7NfUb7otUPnQhIYWGwn70Jllb2OC52wIUJrheSUIv+Y
   eFQE/hh3WJde+iLhezZd8It1dcY8hY/W7ZgkRndr5nC5iuKb84Twp0TA8
   eW5jAWqv5593H+I2Ax+y5awLvlLrMI6Ow3E7SI2COvqjUKCTXpiHZGlF9
   w==;
X-IronPort-AV: E=Sophos;i="5.85,337,1624291200"; 
   d="scan'208";a="186328215"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Oct 2021 18:32:59 +0800
IronPort-SDR: Z3MNChq8U3wZnCoDs2SL0Q6bbpCaYf3xxUJo0dGZPPZGYMetwncfFWb9AKeilfiQ7mlLiNiVr5
 vbpX3GLl60dLUlPbh6mal+WF7TvfokkEgh30P+AP4tTXOYEA5TVFF8d8eONyQCJn49RDLGwZer
 uJwG6M2gAAm+vgLYy+pqXoKLcs7FAKYcCaY0UWtq06l1maBjHmoksR8K2yRYo7LVpiDHiDbgvo
 dvobhMxZUbmpIdSxf2g6qmAbKM5j81h3IaCy9fX497RDZ5h2f3acxX/8OfkM5peSO6jfvL+1Tl
 3a4/DxrNiLgJoBWf7tBhCzK+
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 03:07:30 -0700
IronPort-SDR: v+vTz0HQqSnC7WYtICY+2J49FY0CnWZP1QVOwm1sOHB+acGnDp7bvkvR+oMloRkkk39ApYgOIG
 38I8Zkg/KwLmgv/lMXwSJB+CTlJ9PavMzX3sOuv9PmLsEdm9eie6x3ojWqQVn7+CxCbhLbgWT5
 9rfYeU+r70OyPbSVY2m2Fg/zlmq966pmlORJiizABai+FXIm+p1zeqd23ZLz9X8hsis7fbjFp1
 t8Q/uSjmvZRtXQEdUYQvNsjt0htvFbs0rtbl1hw4A5+J3ZeomxPWUmGQ4503W5lptY8vKE76hq
 Hy8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Oct 2021 03:33:01 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] Refer td->loops instead of td->o.loops to fix loop count issue
Date:   Fri,  1 Oct 2021 19:32:57 +0900
Message-Id: <20211001103257.4130231-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001103257.4130231-1-shinichiro.kawasaki@wdc.com>
References: <20211001103257.4130231-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

In the github issues #1093 and #1278, it was reported that the loops
option does not work as expected when do_verify=0 option is specified.
Per analysis by Sowmya Ravi, the cause was as follows:

1) keep_running() decrements td->o.loops at job repetition, then
   td->o.loops has zero value when the last loop is executed.
2) clear_io_state() is called at the beginning of the thread_main loop
   for each repetition for loops option.
3) clear_io_state() calls reset_io_counters() which resets
   td->nr_done_files to zero when td->o.loops is non-zero.
4) For the last loop of loops option, clear_io_state() call does not
   clear td->nr_done_files since td->l.loops is zero. This results in a
   setup error in do_io().

To fix the issue, modify reset_io_counters() to refer td->loops instead
of td->o.loops. td->o.loops is not a good reference since it is updated
in keep_running(). td->loops is not updated during fio run, and safe to
refer.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 libfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libfio.c b/libfio.c
index 6144a474..ed5906d4 100644
--- a/libfio.c
+++ b/libfio.c
@@ -104,7 +104,7 @@ static void reset_io_counters(struct thread_data *td, int all)
 	/*
 	 * reset file done count if we are to start over
 	 */
-	if (td->o.time_based || td->o.loops || td->o.do_verify)
+	if (td->o.time_based || td->loops > 1 || td->o.do_verify)
 		td->nr_done_files = 0;
 }
 
-- 
2.31.1

