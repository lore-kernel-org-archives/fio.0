Return-Path: <axboe@kernel.dk>
Subject: Re: Specify range and distribution of accesses
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com>
 <20160303161828.GC22164@kernel.dk> <20160303200446.GA2234@kernel.dk>
 <BN3PR0401MB1457E708CC129BD01FE8B94EF7B10@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CANvN+e=jaYQZNS7KRHALDeEF6bwJ0uqDf7ra+qoCwy5OYXMzwA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56DE3BC2.6040206@kernel.dk>
Date: Mon, 7 Mar 2016 19:41:06 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+e=jaYQZNS7KRHALDeEF6bwJ0uqDf7ra+qoCwy5OYXMzwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, Jeff Furlong <jeff.furlong@hgst.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/07/2016 02:02 PM, Andrey Kuzmin wrote:
> On Mon, Mar 7, 2016 at 11:46 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote:
>> Thanks for the suggestions and patches.  Using the latest fio version, the JESD219 workload is possible:
>
> Nice.
>
>>
>> # fio -version
>> fio-2.6-27-gd283
>>
>> # fio --name=JESD219 --ioengine=libaio --direct=1 --rw=randrw --norandommap --randrepeat=0 --rwmixread=40 --rwmixwrite=60 --iodepth=256 --size=100% --numjobs=4 --bssplit=512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:16k/7:32k/3:64k/3 --random_distribution=zoned:50/5:30/15:20/80 --overwrite=1 --filename=/dev/nvme0n1 --group_reporting --runtime=5m --time_based --output=JESD219
>>
>> A quick statistical analysis of the results shows:
>>
>> Found 20380582 IOs
>>
>>   Found 39.9903152913% reads
>>   Found 60.0096847087% writes
>>
>>   Found 4.00492979052% 512
>>   Found 1.00495658073% 1024
>>   Found 1.00079575745% 1536
>>   Found 1.00046701316% 2048
>>   Found 0.998764412125% 2560
>>   Found 0.998043137335% 3072
>>   Found 0.999520033334% 3584
>>   Found 67.0145778958% 4096
>>   Found 9.98662844859% 8192
>>   Found 6.99898560306% 16384
>>   Found 2.99961993235% 32768
>>   Found 2.99271139558% 65536
>>
>>   Found 49.9895734086% 0-5%
>>   Found 30.0126463513% 5-20%%
>>   Found 19.99778024% 20-100%
>>
>
> It hardly matters, but is still somewhat surprising to see that both
> bs and zone split percentage are accurate only up to 5x10^-3.

So I did the math on these, an fio is on (or really close) to the 
expected deviation for random outcomes.

The first two of the block sizes (didn't check more):

 >   Found 4.00492979052% 512

3.99387% to 4.00612% would be in the range.

 > Found 1.00495658073% 1024

0.9938778% to 1.00612% would be in the range.

For the access location:

 >   Found 49.9895734086% 0-5%

49.98955% to 50.01044% would be in the range.

 >   Found 30.0126463513% 5-20%%

29.98955% to 30.01044% would be in the range.

 >   Found 19.99778024% 20-100%

19.98955% to 20.01044% would be in the range.

So while the deviations from the specified does seem larger than 
intuition would lead you to believe, it's actually really close. I think 
we can call this one closed.

-- 
Jens Axboe


