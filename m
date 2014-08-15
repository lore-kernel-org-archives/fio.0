Return-Path: <fio-owner@vger.kernel.org>
Received: from mailsrv.s3group.com ([193.120.90.35]:57891 "EHLO
	mailsrv.s3group.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaHOQyn (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 15 Aug 2014 12:54:43 -0400
Received: from avsrvd.s3group.com (avsrvd.s3group.com [193.120.90.37])
        by mailsrv.s3group.com  with ESMTP id s7FGseBq001259
        for <fio@vger.kernel.org>; Fri, 15 Aug 2014 17:54:40 +0100
Received: from avsrvd.s3group.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AEB015005D
	for <fio@vger.kernel.org>; Fri, 15 Aug 2014 17:54:40 +0100 (IST)
Received: from excork2.dublin.ad.s3group.com (unknown [193.120.91.10])
	by avsrvd.s3group.com (Postfix) with ESMTP id 1EFE3150052
	for <fio@vger.kernel.org>; Fri, 15 Aug 2014 17:54:40 +0100 (IST)
Message-ID: <53EE3B4F.1090501@s3group.com>
Date: Fri, 15 Aug 2014 17:54:39 +0100
From: John OCallaghan <john.ocallaghan@s3group.com>
MIME-Version: 1.0
Subject: Re: runtime and status-interval
References: <53ECAAB8.7040205@s3group.com>
In-Reply-To: <53ECAAB8.7040205@s3group.com>
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org



FYI I found the problem in fio/backend.c. Seems to be working fine now.


The fix I put together is this:

		if (td_read(td) && td->io_bytes[DDIR_READ]) {
			elapsed = utime_since_now(&td->start);
			td->ts.runtime[DDIR_READ] += elapsed/1000;
		}
		if (td_write(td) && td->io_bytes[DDIR_WRITE]) {
			elapsed = utime_since_now(&td->start);
			td->ts.runtime[DDIR_WRITE] += elapsed/1000;
		}
		if (td_trim(td) && td->io_bytes[DDIR_TRIM]) {
			elapsed = utime_since_now(&td->start);
			td->ts.runtime[DDIR_TRIM] += elapsed/1000;
		}


The problem is is that runtime is holding milliseconds but
utime_since_now() returns microseconds. I added the "/1000" to make the
conversion.

My change is a simple fix but quite possibly there are other places
within fio making the same mistake?


J




On 14/08/14 13:25, John OCallaghan wrote:
> 
> 
> Hi
> 
> I am running the fio2.1.11 and am seeing something odd with the "runt"
> value on jobs.
> 
> If I run a test with "--status-interval=5" and let it run for over 20
> seconds I see the runt go from sensible values to nonsensical values
> once it reaches the 20 second boundary.
> 
> Below is a snip from a log that I took. Notice that at the 19 second
> boundary the runt is OK (19925msec). But at the next status interval the
> runt has grown from 19 seconds to 21009 seconds!
> 
> This throws out the bw calcs (1505KB/s down to 1900B/s).
> 
> Here is my fio config file
> [global]
> time_based=1
> runtime=180
> directory=.
> size=64m
> 
> [job1-HD-ReadWrite]
> rw=readwrite
> blocksize=1500k
> filename=HDRW.STR
> rate=1500k,1500k
> 
> And I run as follows:
> 
> ./fio --status-interval=5 test.fio
> 
> 
> Hope thats useful to someone!
> John
> 
> ----------------------
> 
> job1-HD-ReadWrite: (groupid=0, jobs=1): err= 0: pid=25640: Thu Aug 14
> 13:13:20 2014
>   Description  : [HD Seq read/write]
>   read : io=30000KB, bw=1505.7KB/s, iops=1, runt= 19925msec
>     clat (msec): min=4, max=9, avg= 7.80, stdev= 1.24
>      lat (msec): min=4, max=9, avg= 7.80, stdev= 1.24
> <snip>
>     bw (KB  /s): min= 1495, max= 2991, per=100.00%, avg=1871.37,
> stdev=664.94
>   write: io=30000KB, bw=1505.7KB/s, iops=1, runt= 19925msec
>     clat (usec): min=553, max=2030, avg=1498.71, stdev=449.27
>      lat (usec): min=658, max=2161, avg=1617.00, stdev=464.46
>     clat percentiles (usec):
> <snip>
>     bw (KB  /s): min= 1488, max= 3024, per=100.00%, avg=1857.12,
> stdev=665.91
>     lat (usec) : 750=4.88%, 1000=4.88%
>     lat (msec) : 2=34.15%, 4=7.32%, 10=48.78%
> <snip>
> job1-HD-ReadWrite: (groupid=0, jobs=1): err= 0: pid=25640: Thu Aug 14
> 13:13:25 2014
>   Description  : [HD Seq read/write]
>   read : io=39000KB, bw=1900B/s, iops=0, runt=21009984msec
>     clat (msec): min=4, max=78, avg=10.49, stdev=13.99
>      lat (msec): min=4, max=78, avg=10.49, stdev=13.99
> <snip>
>     bw (KB  /s): min= 1495, max= 2991, per=100.00%, avg=1853.76,
> stdev=649.04
>   write: io=37500KB, bw=1827B/s, iops=0, runt=21009984msec
>     clat (usec): min=553, max=2030, avg=1405.73, stdev=462.04
>      lat (usec): min=610, max=2161, avg=1519.96, stdev=480.39
> <snip>
>     bw (KB  /s): min= 1488, max= 3024, per=100.00%, avg=1860.43,
> stdev=662.42
>     lat (usec) : 750=5.77%, 1000=5.77%
>     lat (msec) : 2=32.69%, 4=5.77%, 10=48.08%, 100=1.92%
>   cpu          : usr=0.02%, sys=0.34%, ctx=172, majf=0, minf=32
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>> =64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0%
>      issued    : total=r=26/w=26/d=0, short=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    READ: io=39000KB, aggrb=1KB/s, minb=1KB/s, maxb=1KB/s,
> mint=21009984msec, maxt=21009984msec
>   WRITE: io=37500KB, aggrb=1KB/s, minb=1KB/s, maxb=1KB/s,
> mint=21009984msec, maxt=21009984msec
> -----
> 
> The information contained in this e-mail and in any attachments is confidential and is designated solely for the attention of the intended recipient(s). If you are not an intended recipient, you must not use, disclose, copy, distribute or retain this e-mail or any part thereof. If you have received this e-mail in error, please notify the sender by return e-mail and delete all copies of this e-mail from your computer system(s). Please direct any additional queries to: communications@s3group.com. Thank You. Silicon and Software Systems Limited (S3 Group). Registered in Ireland no. 378073. Registered Office: South County Business Park, Leopardstown, Dublin 18.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-----

The information contained in this e-mail and in any attachments is confidential and is designated solely for the attention of the intended recipient(s). If you are not an intended recipient, you must not use, disclose, copy, distribute or retain this e-mail or any part thereof. If you have received this e-mail in error, please notify the sender by return e-mail and delete all copies of this e-mail from your computer system(s). Please direct any additional queries to: communications@s3group.com. Thank You. Silicon and Software Systems Limited (S3 Group). Registered in Ireland no. 378073. Registered Office: South County Business Park, Leopardstown, Dublin 18.

