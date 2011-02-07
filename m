Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:50519 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1BGVIO (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 7 Feb 2011 16:08:14 -0500
Message-ID: <4D505F39.9000500@fusionio.com>
Date: Mon, 7 Feb 2011 22:08:09 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: test definition help needed
References: <4D4C51B2.1090700@austin.ibm.com> <4D4F0C09.2010601@fusionio.com> <4D505B6C.8090905@austin.ibm.com>
In-Reply-To: <4D505B6C.8090905@austin.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-02-07 21:51, Steven Pratt wrote:
> On 02/06/2011 03:00 PM, Jens Axboe wrote:
>> On 2011-02-04 20:21, Steven Pratt wrote:
>>> I am trying to create a job file that randomly select a file form an imported list and reads the entire file sequentially. Them moves to the next file. I also want multiple jobs(processe) running the same workload. I have this:
>>>
>>> [global]
>>> bs=4k
>>> time_based=1
>>> runtime=15m
>>> iodepth=4
>>> rw=read
>>> ioengine=libaio
>>> time_based=1
>>> ramp_time=600s
>>> norandommap
>>>
>>> [job1]
>>> opendir=/${FIO_MOUNT}/session1/small_file1
>>> file_service_type=sequential
>>> numjobs=8
>>>
>>>
>>>
>>> I used file_service_type=sequential because tought without it it would
>>> only do a single read (block) from the file before switching to a
>>> different file, which is not what I want. The issue with this test as
>>> written is it seems like all the fio processes choose files in the
>>> same order so I get way more cache hits than I want. I want this to be
>>> more of a random file selection, but with reading whole file.  Any
>>> advice?
>> file_service_type=random:<largenum>
>>
>> should do what you need, I think. If you ensure that <largenum> is
>> sufficiently large that the file will always be finished before you run
>> out, then that should work.
> Had thought of that, but seemed kind of hackish.  Any way gave it a

It is sort-of hackish. I guess it would be cleaner to add a separate
file_service_type define for that.

> shot and it kind of worked.  It seemed to randomly select a file to
> operate on, however fio eventually went into a tight spin loop and
> never exited. Traced that back to get_next_file_rand where apparently
> if you ever access every file you will never exit(get stuck in  "if
> (fio_file_done(f))  continue;" forever).  So now I have 2 problems.
> One is this infinite loop which is obviously not good. The second
> (which may help solve the first) is that I want to randomly reuse
> files. I don't want a perfect no reuse case, and I can't find any way
> to get that to happen. If reuse were possible, this loop would not be
> a problem.  I guess for now I can just remove the continue and it will
> do what I want and not loop.  Thoughts on a better solution?

I'll look into that tomorrow, sounds like a bug that has been there
since that service type was introduced.

-- 
Jens Axboe

