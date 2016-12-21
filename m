Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:32329 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934166AbcLUPbG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2016 10:31:06 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 1654C342AA
        for <fio@vger.kernel.org>; Wed, 21 Dec 2016 15:31:05 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id G2GfPj7wc86I for <fio@vger.kernel.org>;
        Wed, 21 Dec 2016 15:31:04 +0000 (UTC)
Received: from [192.168.1.28] (c-73-20-20-155.hsd1.ut.comcast.net [73.20.20.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Wed, 21 Dec 2016 15:31:04 +0000 (UTC)
From: Rebecca Cran <rebecca@bluestop.org>
Subject: t/stest - OOM due to "smalloc bug, commit 271067a6"
Message-ID: <36842b7c-5273-70a8-ef12-c3e156982d52@bluestop.org>
Date: Wed, 21 Dec 2016 08:31:05 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I don't remember seeing this before, but running t/stest reports an OOM 
condition just before finishing, due to the code:

         /* smalloc bug, commit 271067a6 */
         do_specific_alloc(671386584);

Is that a regression, or is it expected?

-- 
Rebecca
