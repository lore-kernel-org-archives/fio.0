Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:57756 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdHZBqM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 Aug 2017 21:46:12 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 5DAABA8446
        for <fio@vger.kernel.org>; Sat, 26 Aug 2017 01:46:12 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fGNz0Tq0PhIZ for <fio@vger.kernel.org>;
        Sat, 26 Aug 2017 01:46:11 +0000 (UTC)
Received: from [192.168.1.67] (c-73-131-237-119.hsd1.ut.comcast.net [73.131.237.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Sat, 26 Aug 2017 01:46:11 +0000 (UTC)
From: Rebecca Cran <rebecca@bluestop.org>
Subject: Optimizing mmap_queue on AVX/AVX2 CPUs
Message-ID: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org>
Date: Fri, 25 Aug 2017 19:46:10 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I'm not sure how far we want to get into optimizing fio for specific CPUs?

I've done some testing and found that when running the mmap ioengine 
against an NVDIMM-N on a modern Intel CPU I can gain a few hundred MB/s 
by optimizing the memory copy using avx/avx2 versus the system's memcpy 
implementation.


Should I proceed with submitting a patch, or do we want to avoid getting 
into these sort of optimizations?


-- 
Rebecca

