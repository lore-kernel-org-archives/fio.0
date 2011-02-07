Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:45554 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1BGOoY (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 7 Feb 2011 09:44:24 -0500
Message-ID: <4D50057F.6010105@fusionio.com>
Date: Mon, 7 Feb 2011 15:45:19 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: test definition help needed
References: <4D4C51B2.1090700@austin.ibm.com> <4D4F0C09.2010601@fusionio.com> <x49oc6n9ak6.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49oc6n9ak6.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Steven Pratt <slpratt@austin.ibm.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-02-07 15:35, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
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
>>
>> file_service_type=random:<largenum>
>>
>> should do what you need, I think. If you ensure that <largenum> is
>> sufficiently large that the file will always be finished before you run
>> out, then that should work.
> 
> Also note that with ioengine=libaio, you'll also want to specify direct
> io (otherwise io_submit will block until the I/O is complete).  If you
> really want buffered, then you need to choose a different io engine.

Good point. I used to have a warning for that, but dropped it since it
got annoying when I was testing the buffered aio patches. Perhaps I
should reinstate it.

In any case, if the result is inspected, it'll be apparent that the
queue depth was 1 throughout the run.

-- 
Jens Axboe

