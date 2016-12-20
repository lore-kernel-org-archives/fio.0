Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:23779 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753600AbcLTVnz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 16:43:55 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 27AD2F808
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 21:34:04 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ss-fXFa8s84C for <fio@vger.kernel.org>;
        Tue, 20 Dec 2016 21:34:03 +0000 (UTC)
Received: from My-MBP.int.bluestop.org (c-73-20-20-155.hsd1.ut.comcast.net [73.20.20.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 21:34:03 +0000 (UTC)
From: Rebecca Cran <rebecca@bluestop.org>
Subject: OSX build error: POSIX_FADV_NORMAL undeclared
Message-ID: <92eceba1-55a9-b936-48a1-ddd2dd1c2695@bluestop.org>
Date: Tue, 20 Dec 2016 14:34:02 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

It looks like the commit ecb2083d39558db2664c41b5d78aa73cd51bff58 
yesterday broke building on OS X (macOS Sierra) because it doesn't have 
POSIX_FADV_NORMAL:


ioengines.c:467:12: error: use of undeclared identifier 'POSIX_FADV_NORMAL'
                         flags = POSIX_FADV_NORMAL;


-- 
Rebecca
