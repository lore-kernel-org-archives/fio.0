Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:18822 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752089AbcJLBia (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Oct 2016 21:38:30 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 83ECA83702
        for <fio@vger.kernel.org>; Wed, 12 Oct 2016 01:38:29 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id N2NVpUgLzzja for <fio@vger.kernel.org>;
        Wed, 12 Oct 2016 01:38:29 +0000 (UTC)
Received: from [10.50.3.126] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Wed, 12 Oct 2016 01:38:29 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: "disable_bw" option in HOWTO should be "disable_bw_measurement"
Message-ID: <3dcd7620-5355-680d-ae2e-c20f7a50045e@cran.org.uk>
Date: Wed, 12 Oct 2016 01:38:28 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm hoping to have time to put together a patch, but just so it's 
reported: the HOWTO mentions an option "disable_bw", but options.c calls 
it "disable_bw_measurement".

-- 
Bruce

