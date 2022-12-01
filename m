Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21002C4321E
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 02:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLACob (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 30 Nov 2022 21:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiLACo3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Nov 2022 21:44:29 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500D994567
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 18:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669862669; x=1701398669;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h/19UPF/C1w3HOqWoniiP3qyNqrtVA6oETSggmI+uaA=;
  b=ixlGIyXOxdYZjiaZBs1pEz5F6fGzoLuUDQX+L2BdlvP/6NfUJj6gVwPQ
   02WzeROtGalnLluoKK/GgCV/Uc7fQiaby1WwZDyk0NvS0hgAyI5Y7YJhn
   Px0Uae8ncqmBxYiTuA9xqpLBGWx0W9bADqqpQJiqStP/GkCHGCBUkTxLf
   mcms6ey0+xb8+XFnNVtxXTDNc59v77vpZ8GAUJmpqdu27uJT2jqPy5BUe
   x3iTVhuK+xbJmtruC1OdJVATB4wj7WJh1YVAjvMC6TYaWzJxHc+OhZOdn
   9OdnJRJDgawo7yuEXtnH5LGkGY2RlvCm7o370K9dxzUt86a5vBtMFwcNX
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,207,1665417600"; 
   d="scan'208";a="321963472"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2022 10:44:26 +0800
IronPort-SDR: Qir/WTg/598RTF/JEEYEL5erst72r8ximT4FuGLTLr26HY/WPNneXUW8o7TJjBNbS+yS1g/C2n
 1x0phMP2vIzBBUA/3eKhfn5noqxTedSBaqmVuQZx4KKLpm35pQ0cXp7XJFiImyxQ9n6h/oOyFZ
 /EkJh1wg9oCZNHV7RSzv7B4vISu8P9Wg6bWM8nCvtbWTA3oAqxjlyCloC29RjcJNY0ZXm4Ju2/
 55nqVtdaK9zdL8f5ndWGcX0qsjm+N/sriUFnxorrBYoSkfxPK9mtWUt7CrtAJJUW7lKNw0yTm+
 uDI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Nov 2022 17:57:20 -0800
IronPort-SDR: alde1Gs3utEGv1KvJK9ogedAMg6n368Wo1JqS1v/bK/9cEcFE6YunWElnuOHLuzB/rCPsGvLBX
 fr99LTMHEoXNPXD1QryCJJCGbcjVAQUNSKdlrE9FLwp8RC+0ihWKYKV6tVN+RfV7smN+8eOAiH
 bjcNk5q0iQPCrOfaK9AupKqUSAON/vpXthHwdkEatYLAWSsLRifkY9ZEdDTkqWcBgLvcuMZF+7
 CqneGEWVtVqybC2D/LR1ChGp91tgVPUiIVSpTXRo5YKvUu6tkYmVxLHY12uHSgY+b11garT2Nn
 tuU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 Nov 2022 18:44:26 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH] backend: respect return value of init_io_u_buffers
Date:   Thu,  1 Dec 2022 11:44:25 +0900
Message-Id: <20221201024425.2340442-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When workloads require large buffer for I/O, fio fails to allocate I/O
buffer but does not report meaningful error message. It just accesses
to null pointer and fail with signal 11. This symptom is observed with
the command line below:

$ fio --name=job --filename=/tmp/fio --rw=write --bs=1g --size=1g \
      --iodepth=128 --ioengine=libaio

The I/O buffer allocation is done in function init_io_u_buffers. The
allocation failure is not reported because return value of the function
is ignored. Check the return value and report to the higher layer.

Fixes: 71e6e5a2fd5c ("iolog replay: Realloc io_u buffers to adapt to operation size.")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c  | 3 ++-
 blktrace.c | 3 ++-
 iolog.c    | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/backend.c b/backend.c
index ba954a6b..928e524a 100644
--- a/backend.c
+++ b/backend.c
@@ -1301,7 +1301,8 @@ static int init_io_u(struct thread_data *td)
 		}
 	}
 
-	init_io_u_buffers(td);
+	if (init_io_u_buffers(td))
+		return 1;
 
 	if (init_file_completion_logging(td, max_units))
 		return 1;
diff --git a/blktrace.c b/blktrace.c
index 00e5f9a9..d5c8aee7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -545,7 +545,8 @@ bool read_blktrace(struct thread_data* td)
 			td->o.max_bs[DDIR_TRIM] = max(td->o.max_bs[DDIR_TRIM], rw_bs[DDIR_TRIM]);
 			io_u_quiesce(td);
 			free_io_mem(td);
-			init_io_u_buffers(td);
+			if (init_io_u_buffers(td))
+				return false;
 		}
 		return true;
 	}
diff --git a/iolog.c b/iolog.c
index aa9c3bb1..62f2f524 100644
--- a/iolog.c
+++ b/iolog.c
@@ -620,7 +620,8 @@ static bool read_iolog(struct thread_data *td)
 		{
 			io_u_quiesce(td);
 			free_io_mem(td);
-			init_io_u_buffers(td);
+			if (init_io_u_buffers(td))
+				return false;
 		}
 		return true;
 	}
-- 
2.37.1

