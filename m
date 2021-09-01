Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244832AbhIAODO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Sep 2021 10:03:14 -0400
Received: from scc-mailout-kit-02.scc.kit.edu (scc-mailout-kit-02.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e752])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366BBC061575
        for <fio@vger.kernel.org>; Wed,  1 Sep 2021 07:02:17 -0700 (PDT)
Subject: Re: Question: t/io_uring performance
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
 <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
From: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
Message-ID: <2df22c68-6040-298e-4512-752cd10b7201@kit.edu>
Date: Wed, 1 Sep 2021 16:02:13 +0200
MIME-Version: 1.0
In-Reply-To: <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: Erwan Velu <e.velu@criteo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

> Can you check how the processor performance goes during the run ?

I just executed turbostat manually, like it was in your config file. Looks like the processor performance works as expected - the output clearly shows the point where I started/stopped a single-threaded t/io_uring run. The machine has 128 cores, so a Busy% of 0.78 is exactly one core.

# turbostat -c package -qS --interval 5 -s Busy%,Bzy_MHz,Avg_MHz,CorWatt,PkgWatt,RAMWatt,PkgTmp
Avg_MHz Busy%   Bzy_MHz CorWatt PkgWatt
0       0.01    1500    0.01    68.91
0       0.01    1641    0.01    68.90
0       0.01    1621    0.01    68.91
0       0.03    1561    0.03    68.91
0       0.03    1547    0.02    68.93
0       0.01    1500    0.01    68.91
0       0.01    1657    0.01    68.89
26      0.78    3322    3.58    74.58
26      0.79    3328    3.63    74.72
26      0.79    3331    3.63    74.79
26      0.79    3321    3.66    74.87
26      0.79    3329    3.64    74.88
26      0.79    3328    3.65    74.92
26      0.79    3334    3.62    74.92
26      0.79    3329    3.62    74.94
23      0.69    3331    3.17    74.25
0       0.01    1664    0.00    69.12
0       0.01    1501    0.01    69.12
0       0.02    1566    0.01    69.10
0       0.00    1499    0.00    69.07
1       0.06    1558    0.04    69.10

Best regards,
Hans-Peter

