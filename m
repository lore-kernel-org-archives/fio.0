Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr80129.outbound.protection.outlook.com ([40.107.8.129]:5635
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229558AbhIANSD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Sep 2021 09:18:03 -0400
Subject: Re: Question: t/io_uring performance
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
From: Erwan Velu <e.velu@criteo.com>
Message-ID: <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
Date: Wed, 1 Sep 2021 15:17:03 +0200
In-Reply-To: <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Le 01/09/2021 à 12:36, Hans-Peter Lehmann a écrit :
> I couldn't find details about Jens' processor frequency but I would be 
> surprised if he had ~3 times the frequency of ours (2.0 GHz base, 3.2 
> GHz boost). 


Can you check how the processor performance goes during the run ?

This would help ensuring the processors clocks perfectly during your run.

To ease this part, you can use the exec module I committed recently in 
fio : https://github.com/axboe/fio/blob/master/examples/exec.fio

There is an example on how dumping the cpuperf in // of a particular 
workload.

If you don't want to use this, you can just run the turbostat cmdline 
I'm sharing in this example.


Cheers,

Erwan,


