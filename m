Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47274 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab3GYTL0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 15:11:26 -0400
Message-ID: <51F17849.4060506@kernel.dk>
Date: Thu, 25 Jul 2013 13:11:05 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Helping to model this workload
References: <CE16EF2F.12D53%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE16EF2F.12D53%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/25/2013 01:07 PM, Neto, Antonio Jose Rodrigues wrote:
> 
> On 7/25/13 3:03 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
> 
>> On 07/25/2013 01:02 PM, Neto, Antonio Jose Rodrigues wrote:
>>> Just to confirm..
>>>
>>> bs_is_seq_rand=1
>>>
>>> bs=64k,4k 
>>>
>>> It's 64K for sequential and 4K for random
>>>
>>> Right?
>>
>> Correct. If bs_is_seq_rand is set, any READ block size setting is
>> applied to sequential IO, and any WRITE block size setting is applied to
>> random IO.
>>
>> -- 
>> Jens Axboe
>>
> 
> Let me see if I understood:
> 
> But Jens, if I want sequential read AND write 64KB and random read AND
> write 4KB?

Then you'd do:

bs=64k,4k
bs_is_seq_rand=1

any ANY sequential IO will be 64kb, and ANY random IO will be 4kb.

-- 
Jens Axboe

