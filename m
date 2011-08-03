Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:57830 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1HCHRG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Aug 2011 03:17:06 -0400
Message-ID: <4E38F5F1.6010502@kernel.dk>
Date: Wed, 03 Aug 2011 09:17:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Measuring IOPS (solved, I think)
References: <201107291737.40463.Martin@lichtvoll.de> <201108021632.00600.Martin@lichtvoll.de> <4E38549F.5080601@kernel.dk> (sfid-20110802_231129_498896_C6557942) <201108022328.52415.Martin@lichtvoll.de>
In-Reply-To: <201108022328.52415.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

On 2011-08-02 23:28, Martin Steigerwald wrote:
> Am Dienstag, 2. August 2011 schrieben Sie:
>> That's a long email! The stonewall should be put in the job section
>> that has to wait for previous jobs. So, ala:
>>
>> [job1]
>> something
>>
>> [job2]
>> stonewall       # will wait for job1 to finish
>> something
>>
>> [job3]
>> something       # will run in parallel with job2
>>
>> [job4]
>> stonewall       # will run when job2+3 are finished
>> something
>>
>> If that's not the case, something is broken. A quick test here seems to
>> show that it works.
> 
> Its documented. From the manpage that I read several times by now:
> 
> Wait for preceding jobs in the job file to exit before starting this one.  
> stonewall implies new_group.
> 
> 
> Somehow despite my reading of manpage, README, HOWTO I came to the thought 
> that it tells fio to wait for the current job to finish, thus I had the 
> stonewall options misordered.
> 
> I expect that it works exactly as you said and try it this way. Instead of 
> omitting the last stonewall option in my iops job file I could omit the 
> first for the first job. Cause the first job does not need to wait for a 
> previous job.

Good, that makes me feel a little better :-)

Perhaps the name isn't that great? I'll gladly put in an alias for that
option, "wait_for_previous" or "barrier" or something like that. Fence?

-- 
Jens Axboe

