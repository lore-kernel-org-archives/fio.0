Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58349 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3IYUGJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 Sep 2013 16:06:09 -0400
Message-ID: <52434212.6050404@kernel.dk>
Date: Wed, 25 Sep 2013 14:05:38 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Amount of data read with mixed workload sequential/random with
 percentage_random set
References: <20130918145830.GA24714@wattwurm.rz.uni-ulm.de> <20130924195508.GB13483@highx.de>
In-Reply-To: <20130924195508.GB13483@highx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juergen Salk <juergen.salk@uni-ulm.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 09/24/2013 01:55 PM, Juergen Salk wrote:
> * Juergen Salk <juergen.salk@uni-ulm.de> [130918 16:58]:
>>
>> --- snip ---
>>
>> [global]
>> ioengine=sync
>> direct=0
>> # Block sizes for I/O units: 25% 19k, 15% 177k, 60% 350k 
>> bssplit=19k/25:177k/15:350k/60
>> # Use mixed workload: 30% random IO, 70% sequential IO
>> percentage_random=30
>> size=${SIZE}
>> numjobs=${NUMJOBS}
>> runtime=${RUNTIME}
>> directory=${DIRECTORY}
>>
>> [application]
>> # Define of I/O pattern: Random read. 
>> rw=randread
>>
>> --- snip ---
>>
>> This is run with the following command: 
>>
>> $ RUNTIME=0 NUMJOBS=4 SIZE=4096m DIRECTORY=/work/testsoft fio jobfile.fio >fio.out 2>&1
>>
>> I have noticed from the output file, that this results in different 
>> amounts of data read by the individual processes:
>>
>> $ grep io= fio.out
>> read : io=5847.5MB, bw=149458KB/s, iops=627, runt= 40063msec
>> read : io=4096.2MB, bw=140358KB/s, iops=595, runt= 29884msec
>> read : io=4096.3MB, bw=140889KB/s, iops=596, runt= 29772msec
>> read : io=5246.4MB, bw=134821KB/s, iops=560, runt= 39847msec
>>  READ: io=19286MB, aggrb=492947KB/s, minb=134820KB/s, maxb=149458KB/s, mint=29772msec, maxt=40063msec 
>>
>> I have expected that every individual process will read 
>> its 4096 MB and then stop further reading. Or am I missing 
>> something?
> 
> Hi,
> 
> I'm still a bit puzzled about the amount of data read by
> individual processes spawned by fio. Given the following (now
> simplified) job file:
> 
> --- snip ---
> [global]
> ioengine=sync
> direct=0
> bssplit=19k/25:177k/15:350k/60
> size=100m
> numjobs=4
> directory=/tmp
> 
> [work]
> rw=randread
> --- snip ---
> 
> $ fio jobfile.fio >fio.out
> $ grep io= fio.out
>   read : io=199968KB, bw=4892.6KB/s, iops=27, runt= 40872msec
>   read : io=200062KB, bw=5083.5KB/s, iops=28, runt= 39359msec
>   read : io=200156KB, bw=4989.1KB/s, iops=27, runt= 40112msec
>   read : io=199940KB, bw=4492.4KB/s, iops=24, runt= 44507msec
>    READ: io=800126KB, aggrb=17977KB/s, minb=4492KB/s, maxb=5083KB/s, mint=39359msec, maxt=44507msec
> 
> I.e. every individual process reads approx. 200 MB of data rather 
> than 100 MB as specified in the job file. For sequential reads 
> (i.e. replaced rw=randread by rw=read, but otherwise unchanged job 
> file) the amount of data read by each process is close to 100 MB as 
> expected.
> 
> I am probably missing something obvious, but why does the job file 
> above result in 200 MB read by every process?

It should not, that's definitely a bug. I'm guessing it's triggered by
the strange block sizes being used. Can you see if adding:

random_generator=lfsr

helps?

-- 
Jens Axboe

