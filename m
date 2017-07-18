Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:45411 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751346AbdGRDqC (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jul 2017 23:46:02 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id BF7763381A
        for <fio@vger.kernel.org>; Tue, 18 Jul 2017 03:46:01 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jF0BT8ORYnuq for <fio@vger.kernel.org>;
        Tue, 18 Jul 2017 03:46:01 +0000 (UTC)
Received: from [10.50.2.106] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Tue, 18 Jul 2017 03:46:01 +0000 (UTC)
From: Rebecca Cran <rebecca@bluestop.org>
Subject: pmemblk ioengine broken (pmemblk_bsize unknown)
Message-ID: <68e2387b-4010-aadf-4df8-1f7f434b6258@bluestop.org>
Date: Mon, 17 Jul 2017 21:46:00 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed the pmemblk ioengine is broken - I've tested with commit 
785e49c659023df1735bff195ad4ba133ebd23a7 (i.e. git master as of today).

engines/pmemblk.c: In function ‘pmb_open’:
engines/pmemblk.c:219:3: warning: implicit declaration of function 
‘pmemblk_bsize’ [-Wimplicit-function-declaration]
    pmb->pmb_bsize = pmemblk_bsize(pmb->pmb_pool);
    ^
...
engines/pmemblk.o: In function `pmb_open':
/home/bcran/workspace/fio/engines/pmemblk.c:219: undefined reference to 
`pmemblk_bsize'
collect2: error: ld returned 1 exit status

I have libpmemblk 0.2 installed.

-- 
Rebecca
