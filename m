Return-Path: <axboe@kernel.dk>
Subject: Re: time_based option broken
References: <BN3PR0401MB145733E19D0EC0B19F88C9D1F7F40@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxjV8Qb2op2Og5RoZtGQ781vn5VCSRsWgrXZm8Fo8j7UNg@mail.gmail.com>
 <CADr68WbPCum7F3eSee8zs4Y=sasByzfqbuqurfmcgNY_YzYAOQ@mail.gmail.com>
 <BN3PR0401MB14575B8D6E7F8ADF762878C0F7F60@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5697DBD7.7010201@kernel.dk>
Date: Thu, 14 Jan 2016 10:33:11 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14575B8D6E7F8ADF762878C0F7F60@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, Jens Rosenboom <j.rosenboom@x-ion.de>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/08/2016 12:35 PM, Jeff Furlong wrote:
> Good points.  Here is further data:
>
> # blockdev --getsize64 /dev/nvme2n1
> 800166076416
>
> # fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=1000m --runtime=60s --time_based --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme2n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-11-g5f3b
> Starting 1 process
> Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/990.2MB/0KB /s] [0/990/0 iops] [eta 00m:00s]
> SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=19511: Fri Jan  8 11:08:55 2016
>    write: io=58620MB, bw=976.11MB/s, iops=976, runt= 60001msec
>
> So the above using a fixed --size that is compatible with --bs is one workaround.
>
> When trying to write more than 100% of the device (wrapping around after end of device), instead of --size=100% we could use a fixed size (where above 800166076416 bytes is 763097.8 MB), even if time_based is not used (use --io_size instead):
>
> # fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=763097m --io_size=764000m --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme2n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-11-g5f3b
> Starting 1 process
> Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/567.9MB/0KB /s] [0/567/0 iops] [eta 00m:00s]
> SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=129928: Thu Jan  7 12:45:52 2016
>    write: io=764000MB, bw=600510KB/s, iops=586, runt=1302786msec
>
> Alternatively, if we simply back out the commit c82ea3d49aa then we can make the 1% or 100% options (--time_based or --io_size) work fine:
>
> # fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=1% --runtime=60s --time_based --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme2n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-11-g5f3b
> Starting 1 process
> Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/954.2MB/0KB /s] [0/954/0 iops] [eta 00m:00s]
> SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=21853: Fri Jan  8 11:20:04 2016
>    write: io=56931MB, bw=971606KB/s, iops=948, runt= 60001msec

So the bug isn't really in the bisected commit, it just changes how fio 
backs out and then shows another bug. The real bug is that we don't 
align the new start properly, so we end up with these weird unaligned 
start offsets that don't work with O_DIRECT IO.

Try current -git, I just committed this fix:

http://git.kernel.dk/cgit/fio/commit/?id=19ddc35b9b97be5af371bb65e93a4864d1dce7b6

-- 
Jens Axboe


