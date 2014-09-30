Return-Path: <axboe@kernel.dk>
Message-ID: <542A1A21.4070406@kernel.dk>
Date: Mon, 29 Sep 2014 20:49:05 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Limit LBA Range
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>	<5429B424.7080903@kernel.dk>	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>	<5429C839.7090408@kernel.dk>	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl> <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>
In-Reply-To: <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-09-29 20:23, Sitsofe Wheeler wrote:
> On 29 September 2014 22:10, Jon Tango <cheerios123@outlook.com> wrote:
>>
>> I include both of those commands, in addition to size=745g, and it seems to
>> be conducting the workload over the entire LBA range. Is this the correct
>> combination of the three parameters? Here is the test script:
>>
>>   [global]
>> name=4ktest
>> filename=\\.\physicaldrive1
>> direct=1
>> numjobs=8
>> norandommap
>> ba=4k
>> time_based
>> size=745g
>> log_avg_msec=100000
>> group_reporting=1
>> #########################################################
>>
>> [4K Precon]
>> stonewall
>> runtime=15000
>> iodepth=32
>> bs=4k
>> rw=randwrite
>
> Bear in mind that because you are asking for eight stonewalled jobs
> this fio run will take 8 * 15000 seconds (around 33 hours) to finish
> because after the first job has run for four hours the second job will
> start etc.

Since they are grouped with numjobs=x, they belong to the same group. 
Hence the stonewall isn't going to do anything here. If it was split in 
two precondition sections, ala:

[global]
numjobs=4
...

[4K Precon stage 1]
runtime=15000
iodepth=32
bs=4k
rw=randwrite

[4K Precon stage 2]
stonewall
runtime=15000
iodepth=32
bs=4k
rw=randwrite

Then stage 2 would not start until stage 1 had finished.

-- 
Jens Axboe


