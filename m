Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0FAC433F5
	for <fio@archiver.kernel.org>; Sat, 18 Sep 2021 22:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC43F610A4
	for <fio@archiver.kernel.org>; Sat, 18 Sep 2021 22:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240409AbhIRWsO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 18 Sep 2021 18:48:14 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54109 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232125AbhIRWsO (ORCPT
        <rfc822;fio@vger.kernel.org>); Sat, 18 Sep 2021 18:48:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 97F7A320047A
        for <fio@vger.kernel.org>; Sat, 18 Sep 2021 18:46:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 18 Sep 2021 18:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hJY1ka
        lZ30hoDfQ73G/YqpTuHgRlklVEzpsGgs6hafE=; b=oBLzj8Z975WnDwD4vW3jn6
        xwEsYgemtDz1DkdZ9/WD75WhCngQmg/XyNbgB1WOXBwbQMscGZsnroPkmeHKGh4d
        Gui3kcDR7+rm7QRNoehiyBk8pewFUv7oJiCu0e0KbKnwwBTZyeRHHp0ajvKv3Ggt
        PTGdQ7r6PppoOFvvlBceIQBCRyTS8SASGizQ4w2gFF//4OZ+h4gTAS8qBWS60Qgm
        7Ql8sWGX5xdgIBa0pjy1BWc2EPm/kcOsR8R9os58dQGz7nv0o9DmoTG44d+0Eo4W
        tWwL9YMqrb4IobE2nsYLHH0u2XWmyG0m17kuAf1mhMsrg6nRY2mjy8ffhYYBsJXg
        ==
X-ME-Sender: <xms:WWxGYa6GD8R3RpDeNcRhi_IOioDyjg97sPjUcPiVwTAdouQz2XPmkQ>
    <xme:WWxGYT7I-sHh-ovqjsVI4TIkKnshlFmVhm9MGjsF-luo8t07s7xLOFcNCKq9K0MaK
    NFqoUfI8JiyuGsQe1Y>
X-ME-Received: <xmr:WWxGYZdONzzGBByH36n5h1ar4g7fbIbfoMcLN4JSlAqbiZvzP8E2EaKkt_hYzejAeioE8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehledgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefvhffukffffgggtgfgsehtkeertd
    dtfeejnecuhfhrohhmpefkshgrfigrnhcuofhilhhlihgtrghnuceolhhinhhugiesihhs
    rgifrghnrdhnvghtqeenucggtffrrghtthgvrhhnpedvffefveehgfetkedutdeikeehhf
    fftedvhfekgeekteehleefleekfeeigfdvgeenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehlihhnuhigsehishgrfigrnhdrnhgvth
X-ME-Proxy: <xmx:WWxGYXKMP_7E5r41LHSNbWc0Do5dZIFRoqu1d1R1G7A9VfdIscZfdg>
    <xmx:WWxGYeL8mOrp1QM0R69W8UHKIbtnjTWRSLykBmPp6yxyY6IZK2FuIQ>
    <xmx:WWxGYYxUlfNsD5CqsOC5bx1kizXc_FC-khWWSgkGkJv_uEdb63afQw>
    <xmx:WWxGYTXZHABm0zdGXEJO8yeO6lxzVZWKaEjVDQrh2MtwDYYEpgQ-SA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <fio@vger.kernel.org>; Sat, 18 Sep 2021 18:46:48 -0400 (EDT)
To:     fio@vger.kernel.org
From:   Isawan Millican <linux@isawan.net>
Subject: fadvise_hint behavior unclear from documentation
Message-ID: <769eb00b-fa01-a9f1-4fcc-09f4f7bbce38@isawan.net>
Date:   Sat, 18 Sep 2021 23:46:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

I was using fio and noticed that the throughput was lower than expected for
random reads to a small file; I would expect it to be entirely cached in
memory. The issue seems to be because fadvise_hint=0 is not behaving as
documented as POSIX_FADV_DONTNEED is being called.
This might be the intended bahavior as the program is flushing the pages
to purely test IO throughput

If the current behaviour is intentional, is there an existing flag that 
could
provide the desired functionality? Essentially I'd like to test the IO
throughput of various file sizes without bypassing the page cache to see the
effects of caching.

To reproduce:

Version:
     Built from source from master (commit f3057d268d)
     Output of /fio --version
         fio-3.28-18-gf3057

We can see fadvise is being used when ran with strace:

     isawan@hypermachine:~/Software/fio$ strace -f  -e fadvise64 ./fio  
--name=test-reader --ioengine=mmap --readwrite=randread --readonly 
--filename=/tmp/test --bs=4k --size=128M --numjobs=1 --runtime=30s 
--time_based --buffered=1 --allow_file_create=0 --fadvise_hint=0
     test-reader: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 
4096B-4096B, (T) 4096B-4096B, ioengine=mmap, iodepth=1
     fio-3.28-18-gf3057
     strace: Process 28297 attached
     strace: Process 28298 attached
     strace: Process 28299 attached
     strace: Process 28300 attached
     strace: Process 28301 attached
     strace: Process 28302 attached
     strace: Process 28303 attached
     strace: Process 28304 attached
     [pid 28301] +++ exited with 0 +++
     [pid 28297] +++ exited with 0 +++
     [pid 28303] +++ exited with 0 +++
     [pid 28298] +++ exited with 0 +++
     [pid 28299] +++ exited with 0 +++
     [pid 28304] +++ exited with 0 +++
     [pid 28302] +++ exited with 0 +++
     [pid 28300] +++ exited with 0 +++
     strace: Process 28305 attached
     Starting 1 process
     strace: Process 28306 attached
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0
     [pid 28306] fadvise64(6, 0, 134217728, POSIX_FADV_DONTNEED) = 0

As we see here, fadvise is being called, while the documentation states:

     fadvise_hint=str

         Use posix_fadvise(2) or posix_fadvise(2) to advise the kernel 
on what I/O patterns are likely to be issued.
         Accepted values are:
             "0": Backwards-compatible hint for “no hint”

