Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr10105.outbound.protection.outlook.com ([40.107.1.105]:52802
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244035AbhIAOSV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Sep 2021 10:18:21 -0400
Subject: Re: Question: t/io_uring performance
From: Erwan Velu <e.velu@criteo.com>
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
 <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
 <2df22c68-6040-298e-4512-752cd10b7201@kit.edu>
 <5015f1e3-eaeb-ef9e-e530-83c21db5aeb7@criteo.com>
Message-ID: <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com>
Date: Wed, 1 Sep 2021 16:17:21 +0200
In-Reply-To: <5015f1e3-eaeb-ef9e-e530-83c21db5aeb7@criteo.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>, "fio@vger.kernel.org" <fio@vger.kernel.org>


Le 01/09/2021 à 16:05, Erwan Velu a écrit :
>
> [...]
> These numbers are perfect.
>
> I rebuild fio on a 5.4 kernel on a high-end nvme which is 1M iops read 
> capable and got stuck at the same number as you aka 580K iops.
>
> So, I'd agree with you something is curious here.
>
Same on a 5.10.35.

Jens, did we missed something here ?

Erwan,


