Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:47128 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752443AbcISCu6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 18 Sep 2016 22:50:58 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 3B92289335
        for <fio@vger.kernel.org>; Mon, 19 Sep 2016 02:50:57 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id S_LV3k5fH2nq for <fio@vger.kernel.org>;
        Mon, 19 Sep 2016 02:50:56 +0000 (UTC)
Received: from [10.50.3.126] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Mon, 19 Sep 2016 02:50:56 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: ETA and percentage complete seem a bit broken in git master
 (d22042d2117b78e16b06bab0880422c417007d37)
Message-ID: <17a0f77b-733b-44e7-6f74-70215fb2c2a6@cran.org.uk>
Date: Sun, 18 Sep 2016 20:50:56 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed the eta and percentage complete seem a bit broken in the 
latest git code, when running examples/tiobench-example.fio.

The eta starts really high (90000m?), drops to 3 minutes then 2, and 
then after another 10 seconds or so drops again to about 15 seconds at 
which point it counts down almost normally.  Meanwhile the percentage 
complete counts normally to about 10% at which point it jumps to 30, 50, 
70, 90, then 100% at which point fio exits.


-- 
Bruce

