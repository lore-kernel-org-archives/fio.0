Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37610 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0BWJUb (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Feb 2010 04:20:31 -0500
Date: Tue, 23 Feb 2010 10:20:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio doesn't seem to generate IO
Message-ID: <20100223092029.GO1025@kernel.dk>
References: <4B72792C.5030709@auckland.ac.nz> <4B792645.8020109@auckland.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B792645.8020109@auckland.ac.nz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>
Cc: fio@vger.kernel.org

On Mon, Feb 15 2010, Michael O'Sullivan wrote:
> Hi everyone,
>
> I am having a problem using iolog files to generate I/O. The attached  
> test_fio file and spc_bsu0_str3 iolog files should run together to  
> generate 6 reads and 10 writes on /mnt/xphost/asu1. Fio runs via
>
> fio test_fio
>
> and generates the following output that looks good
>
> stream0: (groupid=0, jobs=1): err= 0: pid=19187
>  read : io=24,576B, bw=18,745B/s, iops=4, runt=  1311msec
>    clat (usec): min=35, max=564, avg=125.17, stdev=214.99
>    bw (KB/s) : min=   12, max=   31, per=119.44%, avg=21.50, stdev=13.44
>  write: io=40,960B, bw=31,243B/s, iops=7, runt=  1311msec
>    clat (usec): min=25, max=72, avg=49.00, stdev=12.35
>    bw (KB/s) : min=   25, max=   25, per=83.33%, avg=25.00, stdev= 0.00
>  cpu          : usr=0.00%, sys=0.31%, ctx=27, majf=0, minf=22
>  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,  
> >=64=0.0%
>     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,  
> >=64=0.0%
>     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,  
> >=64=0.0%
>     issued r/w: total=6/10, short=0/0
>     lat (usec): 50=62.50%, 100=31.25%, 750=6.25%
>
>
> Run status group 0 (all jobs):
>   READ: io=24KB, aggrb=18KB/s, minb=18KB/s, maxb=18KB/s, mint=1311msec,  
> maxt=1311msec
>  WRITE: io=40KB, aggrb=30KB/s, minb=31KB/s, maxb=31KB/s, mint=1311msec,  
> maxt=1311msec
>
> Also, if I use inotifywatch shows the correct number of access and  
> modify (read and write) on /mnt/xphost/asu1. However, iotop shows that  
> only 8KB of reads and 8KB of writes have been performed by the IO  
> generating process...! I have run soe other tests and fio shows much  
> better performance than expected because it is only generating a small  
> fraction of the requested IO. I have been tinkering with the fio code,  
> so I'm worried I broke something and would like to know what. Can anyone  
> help?

Caching? If you uncomment the direct=1, does it do as you want?

Or is it fio not actually issuing those reads and writes?

-- 
Jens Axboe

