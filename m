Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am6eur05on2092.outbound.protection.outlook.com ([40.107.22.92]:41441
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234415AbhHZH21 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Aug 2021 03:28:27 -0400
Subject: Re: Question: t/io_uring performance
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
From: Erwan Velu <e.velu@criteo.com>
Message-ID: <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
Date: Thu, 26 Aug 2021 09:27:37 +0200
In-Reply-To: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>, fio@vger.kernel.org


Le 25/08/2021 à 17:57, Hans-Peter Lehmann a écrit :
>
> Hello,
>
> I am currently trying to run the t/io_uring benchmark but I am unable 
> to achieve the IOPS that I would expect. In 2019, Axboe achieved 1.6M 
> IOPS [3] or 1.7M IOPS [1] using a single CPU core (4k random reads). 
> On my machine (AMD EPYC 7702P, 2x Intel P4510 NVMe SSD, separate 3rd 
> SSD for the OS), I can't even get close to those numbers.
>
> Each of my SSDs can handle about 560k IOPS when running t/io_uring. 
> Now, when I launch the benchmark with both SSDs, I still only get 
> about 580k IOPS, from which each SSD gets about 300k IOPS. When I 
> launch two separate t/io_uring instances, I get the full 560k IOPS on 
> each device. To me, this sounds like the benchmark is CPU bound. Given 
> that the CPU is quite decent, I am surprised that I only get half of 
> the single-threaded IOPS that my SSDs could handle (and 1/3 of what 
> Axboe got).
>
A few considerations here about your hardware.

You didn't mention the size of your P4510 and that's important as this 
will strongly defines the max you can achieve on this SSD. The 1TB model 
is limited at 465K read random, nearly 640K for the greater sizes.

These numbers are given for a QD set to 64 with 4 workers.

So in any way here to expect to reach what Jens did ;)


Did you checked how your NVMEs are connected via their PCI lanes ?

It's obvious here that you need multiple PCI-GEN3 lanes to reach 1.6M 
IOPS (I'd say two).

So if your disks are running on the same lane, then you'll have no 
chance getting higher than a single PCI GEN3 lane even with 2 NVMEs.


Then considering the EPYC processor, what's your current Numa 
configuration ? Are you NPS=1 ? 2 ? 4 ? (lscpu would give the answer)

If you want to run a single core benchmark, you should also ensure how 
the IRQs are pinned over the Cores and NUMA domains (even if it's a 
single socket CPU).

Depending on your server vendor, you should also considering tweaking 
the bios if you want to get the most of it. I'm especially thinking of 
the DRAM & IODie power management that are using set into 
powersaving/dynamic even if the cpu govenor is set to performance. This 
could influence the final result but that's not your main trouble here.



