Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhHZP5s (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Aug 2021 11:57:48 -0400
Received: from scc-mailout-kit-02.scc.kit.edu (scc-mailout-kit-02.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e752])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C626CC061757
        for <fio@vger.kernel.org>; Thu, 26 Aug 2021 08:57:00 -0700 (PDT)
From: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
Subject: Re: Question: t/io_uring performance
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
Message-ID: <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
Date: Thu, 26 Aug 2021 17:57:16 +0200
MIME-Version: 1.0
In-Reply-To: <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: Erwan Velu <e.velu@criteo.com>, fio@vger.kernel.org


Thank you very much for your reply.

> You didn't mention the size of your P4510

Sorry, the P4510 SSDs each have 2 TB.

> Did you checked how your NVMEs are connected via their PCI lanes? It's obvious here that you need multiple PCI-GEN3 lanes to reach 1.6M IOPS (I'd say two).

If I understand the lspci output (listed below) correctly, the SSDs are connected directly to the same PCIe root complex, each of them getting their maximum of x4 lanes. Given that I can saturate the SSDs when using 2 t/io_uring instances, I think the hardware-side connection should not be the limitation - or am I missing something?

> Then considering the EPYC processor, what's your current Numa configuration? 

The processor was configured to use one single Numa node (NPS=1). I just tried to switch to NPS=4 and ran the benchmark on a core belonging to the SSDs' Numa node (using numactl). It brought the IOPS from 580k to 590k. That's still nowhere near the values that Jens got.

> If you want to run a single core benchmark, you should also ensure how the IRQs are pinned over the Cores and NUMA domains (even if it's a single socket CPU).

Is IRQ pinning the "big thing" that will double the IOPS? To me, it sounds like there must be something else that is wrong. I will definitely try it, though.


= Details =

# lspci -tv
-+-[0000:c0]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
  |           +- [...]
  +-[0000:80]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
  |           +- [...]
  +-[0000:40]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
  |           +- [...]
  \-[0000:00]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
              +- [...]
              +-03.1-[01]----00.0  Intel Corporation NVMe Datacenter SSD [3DNAND, Beta Rock Controller]
              +-03.2-[02]----00.0  Intel Corporation NVMe Datacenter SSD [3DNAND, Beta Rock Controller]

# lspci -vv
01:00.0 Non-Volatile memory controller: Intel Corporation NVMe Datacenter SSD [3DNAND, Beta Rock Controller] (prog-if 02 [NVM Express])
         Subsystem: Intel Corporation NVMe Datacenter SSD [3DNAND] SE 2.5" U.2 (P4510)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 65
         NUMA node: 0
         [...]
         Capabilities: [60] Express (v2) Endpoint, MSI 00
                 LnkCap: Port #0, Speed 8GT/s, Width x4, ASPM L0s, Exit Latency L0s <64ns
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s (ok), Width x4 (ok)
                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                 [...]
02:00.0 Non-Volatile memory controller: Intel Corporation NVMe Datacenter SSD [3DNAND, Beta Rock Controller] (prog-if 02 [NVM Express])
         Subsystem: Intel Corporation NVMe Datacenter SSD [3DNAND] SE 2.5" U.2 (P4510)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 67
         NUMA node: 0
         [...]
         Capabilities: [60] Express (v2) Endpoint, MSI 00
                 LnkCap: Port #0, Speed 8GT/s, Width x4, ASPM L0s, Exit Latency L0s <64ns
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s (ok), Width x4 (ok)
                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                 [...]

