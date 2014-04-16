Return-Path: <axboe@kernel.dk>
Message-ID: <534EFA40.7040305@kernel.dk>
Date: Wed, 16 Apr 2014 15:46:40 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Suspected Block Size 8m limit, Help with larget transfer sizes
References: <89470388ACB8A24491F3E64F24385FD75A487F66@wdscexmb03>
In-Reply-To: <89470388ACB8A24491F3E64F24385FD75A487F66@wdscexmb03>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Stephen Nichols <Stephen.Nichols@wdc.com>, "'fio@vger.kernel.org'" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/16/2014 03:32 PM, Stephen Nichols wrote:
> To any applicable persons,
> 
> My attempts to use block sizes above 8m lead to threads not working properly. I did not notice anything in the documentation stating if there was a limit at 8m. Is this a bug or an intended limit? Has anyone experienced these issues as well? Any work around or fixes?
> 
> My workloads and results.
> 
> 
> *********************************
> Using 8m and lower BS
> **********************************
> fio --runtime=1h--numjobs=1--filesize=64m --time_based --direct=1 --ioengine=libaio --norandommap --refill_buffers -rw=rw --iodepth=128--bs=8m
> 
> /dev/sdb_rw_128: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=libaio, iodepth=128
> /dev/sdc_rw_128: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=libaio, iodepth=128
> /dev/sdd_rw_128: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=libaio, iodepth=128
> fio-2.1.8
> Starting 3 processes
> Jobs: 3 (f=3): [MMM] [0.2% done] [191.9MB/191.9MB/0KB /s] [23/23/0 iops] [eta 59m:55s]
> 
> *********************************
> Using 16m and Higher BS
> **********************************
> fio --runtime=1h--numjobs=1--filesize=64m --time_based --direct=1 --ioengine=libaio --norandommap --refill_buffers -rw=rw --iodepth=128--bs=64m
> 
> /dev/sdb_rw_128: (g=0): rw=rw, bs=32M-32M/32M-32M/32M-32M, ioengine=libaio, iodepth=128
> /dev/sdc_rw_128: (g=0): rw=rw, bs=32M-32M/32M-32M/32M-32M, ioengine=libaio, iodepth=128
> /dev/sdd_rw_128: (g=0): rw=rw, bs=32M-32M/32M-32M/32M-32M, ioengine=libaio, iodepth=128
> fio-2.1.8
> Starting 3 processes
> fio: pid=8007, got signal=9done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 1158050434d:01h:53m:55s]
> Jobs: 2 (f=0): [KMM] [1.9% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 59m:42s]
> 
> 
> ^^ Note no data is being transferred on each thread and the eta is being calculated wrong. Then some threads are reaped when the time adjusts itself.

It's probably a bug with blocksizes getting close to the actual file
size. I'll take a look at this, but I'd advise you to make the files
bigger to get rid of this problem temporarily.

You might also be running out of memory. 3 jobs, at queue depth 128,
with 64M block size is 24G of memory!

-- 
Jens Axboe


