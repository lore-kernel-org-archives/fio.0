Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56645 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2BTTUV (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Feb 2012 14:20:21 -0500
Message-ID: <4F429CF0.5010702@kernel.dk>
Date: Mon, 20 Feb 2012 20:20:16 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Formats for log files
References: <8C39003C166535489D52AF2C9D8C58BC1A316C92@NTXBOIMBX04.micron.com> <953A2B33-81B7-4ECC-9E21-4C6393CF8B7E@joshcarter.com> <8C39003C166535489D52AF2C9D8C58BC1A316D31@NTXBOIMBX04.micron.com>,<B53FFA03-CFB4-46BB-882A-602F045FAF24@joshcarter.com> <8C39003C166535489D52AF2C9D8C58BC1A316DBD@NTXBOIMBX04.micron.com> <EF8C77A9-96EC-42F3-BC18-535FDDD9B0DF@joshcarter.com> <4F420D85.1090803@kernel.dk> <8C39003C166535489D52AF2C9D8C58BC1A317129@NTXBOIMBX04.micron.com> <4F429798.2020506@kernel.dk>
In-Reply-To: <4F429798.2020506@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Bill Hooper (whooper)" <whooper@micron.com>
Cc: Josh Carter <public@joshcarter.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-02-20 19:57, Jens Axboe wrote:
> On 2012-02-20 18:17, Bill Hooper (whooper) wrote:
>>> -----Original Message-----
>>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>>> Behalf Of Jens Axboe
>>> Sent: Monday, February 20, 2012 1:08 AM
>>> To: Josh Carter
>>> Cc: fio@vger.kernel.org; Bill Hooper (whooper)
>>> Subject: Re: Formats for log files
>>>
>>> On 02/16/2012 08:46 PM, Josh Carter wrote:
>>>> Hi Bill,
>>>>
>>>> Looking at the code, I believe you're correct, the bandwidth logging
>>>> for mixed loads isn't right. While read and write logs are kept
>>>> separate, only one direction's log will get flushed on each interval.
>>>> Instead, fio should flush both directions.
>>>>
>>>> I'm attaching a patch. Jens: could you take a look at this? I've
>>>> tested both mixed and single-direction workloads, seems to work fine.
>>>
>>> Patch looks good, applied. Thanks!
>>>
>>> --
>>> Jens Axboe
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> I did test the patch from Josh and it appears to work correctly. I
>> noticed that the issue also exists in the iops and latency logging. I
>> was able to use the code Josh provided to correct the iops logging. I
>> did not spend any time attempting to correct the latency logging
>> issue, although I suspect the fix is similar to the others. Could
>> someone take a deeper look into this?
> 
> Can you send what you have? I can fix up the rest.

I committed a fix for the IOPS logging. The latency logging is per-IO,
so it should work fine as-is.

-- 
Jens Axboe

