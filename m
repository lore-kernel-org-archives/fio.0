Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS (solved, I think)
Date: Tue, 2 Aug 2011 23:28:52 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201108021632.00600.Martin@lichtvoll.de> <4E38549F.5080601@kernel.dk> (sfid-20110802_231129_498896_C6557942)
In-Reply-To: <4E38549F.5080601@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108022328.52415.Martin@lichtvoll.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Am Dienstag, 2. August 2011 schrieben Sie:
> That's a long email! The stonewall should be put in the job section
> that has to wait for previous jobs. So, ala:
> 
> [job1]
> something
> 
> [job2]
> stonewall       # will wait for job1 to finish
> something
> 
> [job3]
> something       # will run in parallel with job2
> 
> [job4]
> stonewall       # will run when job2+3 are finished
> something
> 
> If that's not the case, something is broken. A quick test here seems to
> show that it works.

Its documented. From the manpage that I read several times by now:

Wait for preceding jobs in the job file to exit before starting this one.  
stonewall implies new_group.


Somehow despite my reading of manpage, README, HOWTO I came to the thought 
that it tells fio to wait for the current job to finish, thus I had the 
stonewall options misordered.

I expect that it works exactly as you said and try it this way. Instead of 
omitting the last stonewall option in my iops job file I could omit the 
first for the first job. Cause the first job does not need to wait for a 
previous job.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

