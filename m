Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AABC4332F
	for <fio@archiver.kernel.org>; Mon,  7 Nov 2022 13:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiKGNAn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiKGNAm (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 Nov 2022 08:00:42 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854F713F5B
        for <fio@vger.kernel.org>; Mon,  7 Nov 2022 05:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GdwD4HG/2WFOlBlTZwoBpnam5CO8cA46ktPa5fPPhJY=; b=epZdf0wQwapNNfguDVeQWnxTyx
        3VSf7wazxoM3rq4eUN90UOqFgS/ZCsp2FYu/PULbHPJvv4bTWjDJeT0xhzbiMIR3+GD4MiknIXelQ
        AIWntedputVDuTqMWfTLh+H6bD0zPsXNqq/nOcbxCWuhcY2ye/LqFXzSAHg9Sj921Fd99FO9TRgtZ
        g4daYj+2FiEuQbJXmmK7UObK+cXq5Yv6h6GD40YUYCFZEveYgWnNnP5UvP4r8PC63V2R9yh/d13nI
        UASDdfWKd03kwmfePDUCv18UJ79CDHgGoTWd0itwz16xhn9WyE0piHkodMFsLtiZdlT+BgIm937Np
        bGjO7hFQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1os1jh-009kKH-08
        for fio@vger.kernel.org; Mon, 07 Nov 2022 13:00:25 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id A61BA1BC016F; Mon,  7 Nov 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221107130001.A61BA1BC016F@kernel.dk>
Date:   Mon,  7 Nov 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 02ee8a1ba7ea798f03fb029f589382b6f799be24:

  test: use homebrew to install sphinx instead of pip on macOS (2022-11-04 13:50:31 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 72bcaffd7d56d4c2ebad6d0a1e465e0e9db8be40:

  Fio 3.33 (2022-11-06 13:55:41 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.33

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index db073818..5a0822c9 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.32
+DEF_VER=fio-3.33
 
 LF='
 '
