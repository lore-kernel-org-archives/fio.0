Return-Path: <axboe@kernel.dk>
Subject: Re: time_based option broken
References: <BN3PR0401MB145733E19D0EC0B19F88C9D1F7F40@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxjV8Qb2op2Og5RoZtGQ781vn5VCSRsWgrXZm8Fo8j7UNg@mail.gmail.com>
 <CADr68WbPCum7F3eSee8zs4Y=sasByzfqbuqurfmcgNY_YzYAOQ@mail.gmail.com>
 <BN3PR0401MB14575B8D6E7F8ADF762878C0F7F60@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <5697DBD7.7010201@kernel.dk>
 <BN3PR0401MB14579072365E22B95D9D08FFF7CC0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <569800D2.1010406@kernel.dk>
Date: Thu, 14 Jan 2016 13:10:58 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14579072365E22B95D9D08FFF7CC0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, Jens Rosenboom <j.rosenboom@x-ion.de>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/14/2016 12:51 PM, Jeff Furlong wrote:
> Latest commit seems to help, but found one more issue:
>
> # blockdev --getsize64 /dev/nvme2n1
> 800166076416
>
> 800166076416B = 763097.8MB
>
> Test1: Round io_size to match bs: PASS
> # ./fio/fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=1% --runtime=60s --time_based --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme2n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-26-g19dd
> Starting 1 process
> Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/1380MB/0KB /s] [0/1380/0 iops] [eta 00m:00s]
> SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=80311: Thu Jan 14 10:11:36 2016
>    write: io=84966MB, bw=1415.1MB/s, iops=1415, runt= 60009msec
>
> Test2: Loop around max device size and continue IO with fixed runtime: PASS
> # ./fio/fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=100% --runtime=15m --time_based --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme2n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-26-g19dd
> Starting 1 process
> Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/1388MB/0KB /s] [0/1388/0 iops] [eta 00m:00s]
> SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=80377: Thu Jan 14 10:28:27 2016
>    write: io=1231.9GB, bw=1401.6MB/s, iops=1401, runt=900008msec
>
> Test3: Loop around max device size and continue IO with fixed total IO, round total IO to bs: FAIL (does not loop around to start LBA)
> # ./fio/fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=100% --io_size=810000000000 --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme2n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-26-g19dd
> Starting 1 process
> Jobs: 1 (f=0): [W(1)] [98.9% done] [0KB/1453MB/0KB /s] [0/1453/0 iops] [eta 00m:06s]
> SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=81065: Thu Jan 14 10:49:53 2016
>    write: io=763097MB, bw=1399.5MB/s, iops=1399, runt=545278msec
>
> Test4: Loop around max device size and continue IO with fixed total IO, total IO is already aligned to bs: FAIL (does not loop around to start LBA)
> # ./fio/fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=100% --io_size=810675077120 --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme2n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-26-g19dd
> Starting 1 process
> Jobs: 1 (f=1): [W(1)] [98.6% done] [0KB/1404MB/0KB /s] [0/1404/0 iops] [eta 00m:08s]
> SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=81339: Thu Jan 14 11:01:57 2016
>    write: io=763097MB, bw=1399.9MB/s, iops=1399, runt=545142msec

Very strange, I can't reproduce 3/4 test case failures. I've got a small 
nvme0n1 device here:

axboe@dell:~ $ sudo blockdev --getsize64 /dev/nvme0n1
4286578688

and I tried:

./fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write 
--iodepth=1 --size=100% --io_size=4386578688 --numjobs=1 --bs=1m 
--overwrite=1 --filename=/dev/nvme0n1

and 4300000000 for sizes, and it produces the desired outcome in writing 
the bytes specified by io_size. I added a quick dump to the offset, and 
that looks correct too:

[...]
off=4281335808
off=4282384384
off=4283432960
off=4284481536
off=4285530112
off=0
off=1048576
off=2097152
off=3145728
[...]

which loops around and starts writing from 0 again.

I'll try a bigger device, though it'd be weird if that behaved differently.


-- 
Jens Axboe


