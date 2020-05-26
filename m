Return-Path: <axboe@kernel.dk>
Subject: Re: [io_uring] Problems using io_uring engine
References: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
 <f552027a-25bd-d953-9b19-58e5e44121c6@kernel.dk>
 <ed949243-f657-5f41-79f2-dc8a34459f27@eafit.edu.co>
 <931cfc02-d662-f154-c453-276553e19a1e@kernel.dk>
 <c5f64029-31c3-a9c0-5bbf-8a71bdb13557@eafit.edu.co>
 <ae5acec8-b630-982f-b809-6d14f82e29b2@kernel.dk>
 <f5ba6ebb-afda-1570-5f40-49cb0ef81c88@eafit.edu.co>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bf606cc2-8cb2-3c13-edc3-d535a7c7516e@kernel.dk>
Date: Tue, 26 May 2020 14:26:45 -0600
MIME-Version: 1.0
In-Reply-To: <f5ba6ebb-afda-1570-5f40-49cb0ef81c88@eafit.edu.co>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/26/20 2:21 PM, Hamilton Tobon Mosquera wrote:
> On 26/05/20 3:18 p. m., Jens Axboe wrote:
> 
>> On 5/26/20 7:57 AM, Hamilton Tobon Mosquera wrote:
>>> Thank you for your answer.
>>>
>>> This is how I'm making sure that it is polling. The workloads take 2
>>> minutes, I'm checking the interrupts registered in /proc/interrupts for
>>> the nvme device (the Intel Optane) when the workload starts and when the
>>> workload ends. The interrupts count is almost zero, about 25 or so,
>>> while when using an interrupt based engine I get about 600K interrupts.
>>>
>>> Also, the way I'm loading the nvme driver is:
>>>
>>> modprobe nvme poll_queues=4
>>>
>>> As you said I'm using 4 polling queues because I only have 4 physical
>>> cores. To check that they were actually created I use:
>>>
>>> systool -vm nvme
>>>
>>> Which shows that effectively there are 4 polling queues created.
>>>
>>> I also checked the file /sys/block/nvme0n1/queue/io_poll and it is set
>>> to 1. Sometimes I change the file /sys/block/nvme0n1/queue/io_poll_delay
>>> to switch between hybrid and normal polling and it shows differences in
>>> the CPU usage, the latencies, IOPS, ...
>>>
>>> Another way is by checking the CPU usage, which says that the CPU is
>>> almost completely occupied when polling.
>>>
>>> Also, I tried with dmesg as you suggested and this is the output:
>>>
>>> [627676.640431] nvme nvme0: 4/0/4 default/read/poll queues
>>>
>>> I guess that shows that I was effectively using polling in the
>>> workloads. What is weird is that when I don't use the flag HIPRI it runs
>>> ok but using interrupts not polling. It might be important to say that
>>> I'm always running with root user.
>>>
>>> Does this information give you more hints about the problem?. Could you
>>> please tell me in what filesystem polling is known to work 100% of the
>>> time?.
>>>
>>> Thank you for your help.
>> You did the right thing on the NVMe side, I'm guessing then that it's
>> ext4 again. What kernel are you using? I think only 5.7 and newer
>> supports polling on ext4, you'll have better luck with XFS.
>>
>> And btw, please don't top-post. Reply with proper quoting, top
>> posting totally messes up the flow of conversation.
>>
>> --
>> Jens Axboe
> 
> 
> Thank you for your answer.
> 
> Effectively it seems to be ext4 the problem. I tried with XFS and it 
> works, which seems weird to me. Does this mean that pvsync2 wasn't 
> polling at all?.

There's basically two types of polling:

- sync polling, this is what was introduced with preadv2 and RWF_HIPRI
- async polling, this allows to poll for explicit IO

The former just polls the device for _any_ completion, the latter can
poll for an explicit IO. The latter is what io_uring uses, as the sync
polling doesn't really work that well for a single sync IO from a single
poll user.

To support async polling, the fs needs to support it. ext4 only recently
got that support, I added XFS support when I wrote the code originally.

-- 
Jens Axboe


