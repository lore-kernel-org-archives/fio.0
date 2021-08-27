Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db8eur05on2091.outbound.protection.outlook.com ([40.107.20.91]:15521
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231592AbhH0HVh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Aug 2021 03:21:37 -0400
Subject: Re: Question: t/io_uring performance
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
From: Erwan Velu <e.velu@criteo.com>
Message-ID: <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
Date: Fri, 27 Aug 2021 09:20:41 +0200
In-Reply-To: <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>, fio@vger.kernel.org


Le 26/08/2021 à 17:57, Hans-Peter Lehmann a écrit :
>
> [...]
> Sorry, the P4510 SSDs each have 2 TB.

Ok so we could expect 640K each.

Please note that jens was using optane disks that have a lower latency 
than a 4510 but this doesn't explain your issue.

>
>> Did you checked how your NVMEs are connected via their PCI lanes? 
>> It's obvious here that you need multiple PCI-GEN3 lanes to reach 1.6M 
>> IOPS (I'd say two).
>
> If I understand the lspci output (listed below) correctly, the SSDs 
> are connected directly to the same PCIe root complex, each of them 
> getting their maximum of x4 lanes. Given that I can saturate the SSDs 
> when using 2 t/io_uring instances, I think the hardware-side 
> connection should not be the limitation - or am I missing something?

You are right but this question was important to sort out to ensure your 
setup was compatible with your expectations.


>
>> Then considering the EPYC processor, what's your current Numa 
>> configuration? 
>
> The processor was configured to use one single Numa node (NPS=1). I 
> just tried to switch to NPS=4 and ran the benchmark on a core 
> belonging to the SSDs' Numa node (using numactl). It brought the IOPS 
> from 580k to 590k. That's still nowhere near the values that Jens got.
>
>> If you want to run a single core benchmark, you should also ensure 
>> how the IRQs are pinned over the Cores and NUMA domains (even if it's 
>> a single socket CPU).
>
> Is IRQ pinning the "big thing" that will double the IOPS? To me, it 
> sounds like there must be something else that is wrong. I will 
> definitely try it, though.

I didn't say it was the big thing, said it was to be considered to do a 
full optmization ;)


Stupid question : what if you run two benchmarks, one per disk ?


