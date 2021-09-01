Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhIAKh2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Sep 2021 06:37:28 -0400
Received: from scc-mailout-kit-02.scc.kit.edu (scc-mailout-kit-02.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e752])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8923DC061575
        for <fio@vger.kernel.org>; Wed,  1 Sep 2021 03:36:31 -0700 (PDT)
Subject: Re: Question: t/io_uring performance
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
From: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
Message-ID: <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
Date: Wed, 1 Sep 2021 12:36:27 +0200
MIME-Version: 1.0
In-Reply-To: <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: Erwan Velu <e.velu@criteo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Sorry for the late reply.

> Stupid question : what if you run two benchmarks, one per disk ?

I did a few measurements with different configurations below. (The numbers come from "iostat -hy 1 1" because t/io_uring only shows the per-process numbers. The iostat numbers are the same that t/io_uring shows when only running one instance)

Single t/io_uring process with one disk
==> 570k IOPS total (SSD1 = 570k IOPS, SSD2 = 0 IOPS)
Single t/io_uring process with both disks
==> 570k IOPS total (SSD1 = 290k IOPS, SSD2 = 280k IOPS
)

Two t/io_uring processes, both on the same disk
==> 785k IOPS total (SSD1 = 785k IOPS, SSD2 = 0 IOPS
)
Two t/io_uring processes, each on both disks
==> 1135k IOPS total (SSD1 = 570k IOPS, SSD2 = 565k IOPS
)
Two t/io_uring processes, one per disk
==> 1130k IOPS total (SSD1 = 565k IOPS, SSD2 = 565k IOPS
)

Three t/io_uring processes, each on both disks
==> 1570k IOPS total (SSD1 = 785k IOPS, SSD2 = 785k IOPS
)
Four t/io_uring processes, each on both disks

==> 1570k IOPS total (SSD1 = 785k IOPS, SSD2 = 785k IOPS)

So apparently, I need at least 3 cores to fully saturate the SSDs, while Jens can get similar total IOPS using only a single core. I couldn't find details about Jens' processor frequency but I would be surprised if he had ~3 times the frequency of ours (2.0 GHz base, 3.2 GHz boost).

> If you want to run a single core benchmark, you should also ensure how the IRQs are pinned over the Cores and NUMA domains (even if it's a single socket CPU). 

I pinned the interrupts of nvme0q0 and nvme1q0 to the core that runs t/io_uring but that does not change the IOPS. Assigning the other nvme related interrupts (like nvme1q42, listed in /proc/interrupts) fails. I think that happens because the kernel uses IRQD_AFFINITY_MANAGED and I would need to re-compile the kernel to change that. t/io_uring uses polled IO by default, so are the interrupts actually relevant in that case?

As a next step I will try upgrading the kernel, after all (even though I hoped to be able to reproduce Jens' measurements with the same kernel).

Thanks again
Hans-Peter Lehmann

Am 27.08.21 um 09:20 schrieb Erwan Velu:
> 
> Le 26/08/2021 à 17:57, Hans-Peter Lehmann a écrit :
>>
>> [...]
>> Sorry, the P4510 SSDs each have 2 TB.
> 
> Ok so we could expect 640K each.
> 
> Please note that jens was using optane disks that have a lower latency than a 4510 but this doesn't explain your issue.
> 
>>
>>> Did you checked how your NVMEs are connected via their PCI lanes? It's obvious here that you need multiple PCI-GEN3 lanes to reach 1.6M IOPS (I'd say two).
>>
>> If I understand the lspci output (listed below) correctly, the SSDs are connected directly to the same PCIe root complex, each of them getting their maximum of x4 lanes. Given that I can saturate the SSDs when using 2 t/io_uring instances, I think the hardware-side connection should not be the limitation - or am I missing something?
> 
> You are right but this question was important to sort out to ensure your setup was compatible with your expectations.
> 
> 
>>
>>> Then considering the EPYC processor, what's your current Numa configuration? 
>>
>> The processor was configured to use one single Numa node (NPS=1). I just tried to switch to NPS=4 and ran the benchmark on a core belonging to the SSDs' Numa node (using numactl). It brought the IOPS from 580k to 590k. That's still nowhere near the values that Jens got.
>>
>>> If you want to run a single core benchmark, you should also ensure how the IRQs are pinned over the Cores and NUMA domains (even if it's a single socket CPU).
>>
>> Is IRQ pinning the "big thing" that will double the IOPS? To me, it sounds like there must be something else that is wrong. I will definitely try it, though.
> 
> I didn't say it was the big thing, said it was to be considered to do a full optmization ;)
> 
> 
> Stupid question : what if you run two benchmarks, one per disk ?
> 

