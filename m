Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35179 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab1EWLhu (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 May 2011 07:37:50 -0400
Message-ID: <4DDA470A.8040403@fusionio.com>
Date: Mon, 23 May 2011 13:37:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fadvise and small random reads
References: <OFEB35B0EC.DA0CC6A8-ONC1257896.004DEE8A-C1257896.0050CE26@ch.ibm.com>
In-Reply-To: <OFEB35B0EC.DA0CC6A8-ONC1257896.004DEE8A-C1257896.0050CE26@ch.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Animesh K Trivedi1 <ATR@zurich.ibm.com>
Cc: fio@vger.kernel.org

On 2011-05-20 16:42, Animesh K Trivedi1 wrote:
> 
> Hi all,
> 
> I'm running the random read test on a 64MB file with 4K block size. The
> file is small enough to fit in the buffer cache of the system (8 GB DRAM).
> But default fadvise calls to OS pass two flags (POSIX_FADV_DONTNEED, and
> POSIX_FADV_RANDOM). With these two settings OS does not try to cache any
> reads and they all go to the disk. I get ~280 IOPS with 99% disk
> utilization. And that is fine. But even when I turn fadvise_hint=0, it
> shows the similar behaviour. Upon further investigation I noticed that
> irrespective of settings, POSIX_FADV_DONTNEED is always passed to OS
> (filesetup.c, line 361). Should not it also be restricted when
> --fadvise_hint is set to zero ?

FADV_DONTNEED is used to invalidate the mapping cache so that buffered
runs are "identical" and not influenced by previous cache hotness of the
page cache.

FADV_DONTNEED should not have any effects on the caching later done,
whereas FADV_RANDOM definitely will impact caching or read-ahead.

> If I don't pass any hint to OS, then after stabilizing whole  file is
> cached in the buffer and IOPS reaches upto 700+K (which I was expecting for
> small file sizes). Here is the snipped sample output :
> 
> fio --fadvise_hint=0 --ioengine=psync --direct=0 --rw=randread --bs=4K
> --size=64M --numjob=1 --runtime=60 --time_based --group_reporting
> --name=file
> file: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=psync, iodepth=1
> fio 1.54
> Starting 1 process
> Jobs: 1 (f=1): [r] [100.0% done] [3043M/0K /s] [761K/0  iops] [eta 00m:00s]
> file: (groupid=0, jobs=1): err= 0: pid=3820
>   read : io=121156MB, bw=2019.3MB/s, iops=516931 , runt= 60000msec
> ......
> Disk stats (read/write):
>   sda: ios=7742/82, merge=0/4060, ticks=34608/9112, in_queue=43712,
> util=32.27%
> 
> Am I missing something ?

You can always disable the cache clear hint with invalidate=0.

-- 
Jens Axboe

