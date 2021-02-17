Return-Path: <daniel.menzel@menzel-it.net>
Subject: Re: io_uring on CentOS8?
References: <6d57985d-b784-f9a5-68d0-3a0c3857b4a4@menzel-it.net>
 <99539c2d-15e0-db7c-d7bc-e1624bd1e43f@kernel.dk>
 <CO1PR11MB48044A2F300CE9B9FCE08D0B8B879@CO1PR11MB4804.namprd11.prod.outlook.com>
 <c115f8ee-a466-8225-99e9-765384bb2ba2@kernel.dk>
From: Daniel Menzel <daniel.menzel@menzel-it.net>
Message-ID: <0fa8b1c4-ccdf-7f75-7962-c97e55153707@menzel-it.net>
Date: Wed, 17 Feb 2021 09:42:40 +0100
MIME-Version: 1.0
In-Reply-To: <c115f8ee-a466-8225-99e9-765384bb2ba2@kernel.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, "Ober, Frank" <frank.ober@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

By the way: Does anyone do some system profiling (flame graphs or
something like that) while testing devices to make sure you reached the
devices' capabilities instead of the systems?

I just made some tests of nvme drives and a friend of mine (who is a
scientist) said that if that was a paper he would reject it because I do
not know whether I measure the devices or the system.

Am 16.02.21 um 20:51 schrieb Jens Axboe:
> On 2/16/21 12:00 PM, Ober, Frank wrote:
>> Hi Daniel, Intel uses pvsync2 for QD1 testing so if you cannot use spdk or io_uring (these are the fastest ways to test a device), you can switch your engine to pvsync2 on this kernel and this will work. 
>>
>> Here's what I tried on PCIe Gen3 system with an Optane drive and your drive.
>>
>>
>> [root@fm42adsdemo001 block]# fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1  --size=10000M \
>>> --filename=/dev/nvme6n1 --name=mylittletest --direct=1 --fsync=1 \
>>> --refill_buffers --ioengine=pvsync2 --group_reporting \
>>> --fallocate=none --runtime=60 --time_based --hipri
>> mylittletest: (g=0): rw=randwrite, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=pvsync2, iodepth=1
>> fio-3.24-5-g2ee2
>> Starting 1 process
>> Jobs: 1 (f=1): [w(1)][100.0%][w=2048MiB/s][w=2048 IOPS][eta 00m:00s]
>>
>> I ran the same exact job on this mid-range Intel Xeon cpu and found io_uring only very slightly faster than pvsync2
>> Jobs: 1 (f=1): [w(1)][100.0%][w=2057MiB/s][w=2057 IOPS][eta 00m:00s]
> That's not too surprising, if you're at queuedepth=1 or doing sync IO, then
> I'd consider it a major win that the async API is just as fast or faster
> than the sync one :-)
>
>
-- 
Daniel Menzel
Geschäftsführer

Menzel IT GmbH
Charlottenburger Str. 33a
13086 Berlin

+49 (0) 30 / 5130 444 - 00
daniel.menzel@menzel-it.net
https://menzel-it.net

Geschäftsführer: Daniel Menzel, Josefin Menzel
Unternehmenssitz: Berlin
Handelsregister: Amtsgericht Charlottenburg
Handelsregister-Nummer: HRB 149835 B
USt-ID: DE 309 226 751


