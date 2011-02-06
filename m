Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:43085 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1BFVBH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 6 Feb 2011 16:01:07 -0500
Message-ID: <4D4F0C09.2010601@fusionio.com>
Date: Sun, 6 Feb 2011 22:00:57 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: test definition help needed
References: <4D4C51B2.1090700@austin.ibm.com>
In-Reply-To: <4D4C51B2.1090700@austin.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Cc: fio@vger.kernel.org

On 2011-02-04 20:21, Steven Pratt wrote:
> I am trying to create a job file that randomly select a file form an imported list and reads the entire file sequentially. Them moves to the next file. I also want multiple jobs(processe) running the same workload. I have this:
> 
> [global]
> bs=4k
> time_based=1
> runtime=15m
> iodepth=4
> rw=read
> ioengine=libaio
> time_based=1
> ramp_time=600s
> norandommap
> 
> [job1]
> opendir=/${FIO_MOUNT}/session1/small_file1
> file_service_type=sequential
> numjobs=8
> 
> 
> 
> I used file_service_type=sequential because tought without it it would
> only do a single read (block) from the file before switching to a
> different file, which is not what I want. The issue with this test as
> written is it seems like all the fio processes choose files in the
> same order so I get way more cache hits than I want. I want this to be
> more of a random file selection, but with reading whole file.  Any
> advice?

file_service_type=random:<largenum>

should do what you need, I think. If you ensure that <largenum> is
sufficiently large that the file will always be finished before you run
out, then that should work.

-- 
Jens Axboe

