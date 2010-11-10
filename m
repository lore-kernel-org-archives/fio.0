Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:38554 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab0KJTs0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Nov 2010 14:48:26 -0500
Message-ID: <4CDAF701.8000301@fusionio.com>
Date: Wed, 10 Nov 2010 20:48:17 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de>
In-Reply-To: <20101110171856.GI28050@sebastiankayser.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On 2010-11-10 18:18, Sebastian Kayser wrote:
> * Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2010-11-10 09:22, Sebastian Kayser wrote:
>>> Just to make sure my understanding is correct:
>>> - direct=1 should mitigate (disable?) OS caching effects
>>> - sync=1, iodepth=1 should make sure that an I/O has really made it to
>>>   disk before the next on is issued, i.e. should de-facto disable
>>>   I/O coalescing or device caching
>>>
>>> Are these sane/valid assumptions?
>>
>> Yes, your assumptions are valid. I think the issue here is that you give
>> randwrite, but don't also specify that you want overwrites. So what
>> happens is that the file will be truncated and then randomly written,
>> allowing the file system to place randomly chosen file block together.
>> If you remove the test file and re-run with overwrite=1 added, then see
>> if those results are more in line with what you expect.
> 
> Thanks for the additional aspect! So the possible pitfall is that w/o
> overwrite=1 the test file could be sparse and the file system then
> re-arrange random file addresses to fall onto consecutive device blocks?
> 
> (If so, wouldn't that be evil / deliberate data fragmentation?)

Depends on whether you care about the write performance or the read-back
performance :-)

> Tested it again with overwrite=1, same IOPS figures. Test file size as
> measured with du -ks is the same in both cases btw. (which combined with
> the limited runtime=120 doesn't seem to indicate sparseness in case of
> overwrite=0, right?).

Was the file pre-created? I'm pretty sure that fio will not lay it out
first with a write workload, even for random writes (I could be wrong
though, and if the file is indeed non-sparse and the test stopped before
all IO was written, then it would have been sparse for this case).

> What I will do now is to export the whole 2TB of the disk (instead of
> just 10GB) and increase size= to see whether that makes any difference
> (hopefully). Other than that, further ideas?

Lets see what that yields.

-- 
Jens Axboe

