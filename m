Return-Path: <axboe@kernel.dk>
Message-ID: <53E3CBF4.6020502@kernel.dk>
Date: Thu, 07 Aug 2014 12:56:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO Disk Stats - 0% Utilization
References: <CAPY19uW8EV58gvZ2184DcuJ8gnSG-iTcbbqgWFOLYaHuicwPDA@mail.gmail.com> <53E3C65E.5080002@kernel.dk>
In-Reply-To: <53E3C65E.5080002@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Karen Higgins <karen.higgins@sanmina.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/07/2014 12:33 PM, Jens Axboe wrote:
> On 08/07/2014 11:08 AM, Karen Higgins wrote:
>> I am loading a Ramdisk driver in various block driver modes (RQ, BIO,
>> and Multi-Queue[MQ]) to compare IOPS.
>>
>> When I load the driver in BIO mode and run fio, the Disk Stats shows a
>> utilization of 0.0%, which makes me wonder if the disk is being
>> accessed.  On the other hand, when I load the driver in RQ or MQ mode,
>> the Disk Stats show a utilization of 100% (or near 100%).  The IOPS
>> for BIO mode are greater than the IOPS for MQ mode, which is another
>> red flag that the BIO mode IOPS may not be accurate.
>>
>> I am able to successfully perform read/write/verification tests
>> outside of fio in all block driver modes.
>>
>> My question is how can I get an accurate IOPS performance measurement
>> for the driver in BIO mode?  Is there a bug in fio, or am I missing
>> some parameter?
>>
>> Also, it seems that IOPS should be higher in general for MQ mode.  Are
>> there any performance tuning suggestions for MQ?
> 
> In bio mode, the driver is bypassing the entire stack. This means that
> you miss out on certain things, IO stats being one of them.
> 
> Since bio is a raw mode, it's also not unusual for it to be slightly
> faster than MQ, depending on what you run. Some of that might be due to
> a suboptimal conversion to MQ, I can't really say without seeing the
> code. Things like IO/part stats can be a bit costly as well, so just
> turning that off in MQ mode may make you run closer to the BIO speed.

BTW, to expand on this - this was primarily in the context of a ramdisk
driver, which isn't representative of how a real world device would
actually operate. MQ tags everything, since real hw requires this. This
is just a waste on a ramdisk driver. And if the ramdisk driver processes
everything inline, then you would also lose some of the MQ benefit
there. MQ also provides inline storage for hw commands, a ramdisk driver
would not need that either. So basically all the functionality that MQ
provides in a scalable way is not going to be useful for your test case,
it will only slow things down a little bit. This is similar to the noop
blk driver that was included with blk-mq. It really only serves as a
comparison between RQ and MQ mode, the BIO mode is mostly useful to
highlight problems elsewhere in the stack. It's just not a fair comparison.

On the stats part, you can trust what fio tells you. Only the disk util
stats are provided by the kernel, the rest is calculated by fio.


-- 
Jens Axboe


