Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7A8C001B2
	for <fio@archiver.kernel.org>; Thu, 15 Dec 2022 01:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLOB4N (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 14 Dec 2022 20:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiLOB4L (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Dec 2022 20:56:11 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B74A477
        for <fio@vger.kernel.org>; Wed, 14 Dec 2022 17:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671069369; x=1702605369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d0miwDszUVxhcRmbBwgVHx72eSijV8Kz4T/bfyadCpA=;
  b=f8YosxC0uJGjmTYi6UmK1TVhbg7bbh2eo36rgYt3aeukxwDtZIs8NfNw
   1geez+tirM4sd0cOkpe76qX4EWgMHbTzNbKtqOA01uLB/n0fFrpAyqhrq
   CMPg57GCTu6UiMZQ5TQzqiF3GDZUsJ7Pn3aCCwn3b8JuJ/0jh4f2MVjni
   Z2vMBhRzrvYLNF4bhDtTNcoJHBC6QJXAEgKZzWkjJOnpYyazjlBb3FApP
   gE1zy0FdQPoNAXs6/64f+8WimkbU25TVvwnaJbS7G6cYL7kJP1wWClQZh
   6hSpNb5Z7hPC9UCmuAyLkcY/ZiLICfKm1Xb4prcTySvnFjJAlq4BnZyTB
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,246,1665417600"; 
   d="scan'208";a="218930647"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2022 09:56:09 +0800
IronPort-SDR: oo6gd7prO+F015v2t8QOj5QeBbC3mmUsDlEMe8HeTQ6P6OEB7+NaEh9XzIoBkZHW9t4jGCUFz8
 PxXale+/dNeg8bHJGLEh54hzOy3lV2bIqRYllyzk9jyObpFy9D0EupCR8vmDdcis0DF46lQExV
 PM2Sr4yEaLN5nd+4zrxMm1fLO0E1a6IjoThH4s5nikhA2Jnq7gZy94Dflmg2Gwu5Dpq6VB4gdO
 FqN+TrhTNgsrlWdqAoFzMiAOLCkQkGf+//Ns5L6Ir5W/DCOcBhihvi+jCqYaKeZQQqllrerH8e
 HLI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Dec 2022 17:14:31 -0800
IronPort-SDR: rl5oOxue7TCN32GtggFdPWTA4xVFf9LtsW6Ld6gmNkIbj24wrvnMGgGzooUsLBxQWMLVurl1oe
 JYuMxQRunnR8U8dkGpvxZNZ/1oWUsfuSeBoXe/CXHqq6RVCvTJ+ALnyQ247jqOosvR13Dxx2CQ
 /DT++A9av0RZ7+iKyAbJlIdTT6MA7Asbxfgysn6AYUcKV7zNC3Q2oVpvF8001O0iRnTLJSiQxx
 jlzyjPd7PKnxBHWsAhnJvf9vicbmwVZkww/ZNkrxhc9KCDb7JG6juISAAv/P3U1IaPlQyV1Jib
 Drw=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Dec 2022 17:56:09 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/4] man: fix troff warning
Date:   Thu, 15 Dec 2022 10:56:03 +0900
Message-Id: <20221215015606.2767187-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
References: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

'make doc' reports a warning:

  troff: <standard input>:2554: warning: can't find font 'b'

To avoid it, add missing 'P' for troff built-in command '\f'.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index 7a153731..a0d765e5 100644
--- a/fio.1
+++ b/fio.1
@@ -2544,7 +2544,7 @@ replaced by the name of the job
 .BI (exec)grace_time\fR=\fPint
 Defines the time between the SIGTERM and SIGKILL signals. Default is 1 second.
 .TP
-.BI (exec)std_redirect\fR=\fbool
+.BI (exec)std_redirect\fR=\fPbool
 If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
 .TP
 .BI (xnvme)xnvme_async\fR=\fPstr
-- 
2.37.1

