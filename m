Return-Path: <karen.higgins@sanmina.com>
MIME-Version: 1.0
In-Reply-To: <53E3CBF4.6020502@kernel.dk>
References: <CAPY19uW8EV58gvZ2184DcuJ8gnSG-iTcbbqgWFOLYaHuicwPDA@mail.gmail.com>
	<53E3C65E.5080002@kernel.dk>
	<53E3CBF4.6020502@kernel.dk>
Date: Thu, 7 Aug 2014 12:31:36 -0700
Message-ID: <CAPY19uV29BGu4Y-36M=VWcvP-tptFh-Fbd8Yv-wPCmkGhczBbQ@mail.gmail.com>
Subject: Re: FIO Disk Stats - 0% Utilization
From: Karen Higgins <karen.higgins@sanmina.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Aug 7, 2014 at 11:56 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/07/2014 12:33 PM, Jens Axboe wrote:
>> On 08/07/2014 11:08 AM, Karen Higgins wrote:
>>> I am loading a Ramdisk driver in various block driver modes (RQ, BIO,
>>> and Multi-Queue[MQ]) to compare IOPS.
>>>
>>> When I load the driver in BIO mode and run fio, the Disk Stats shows a
>>> utilization of 0.0%, which makes me wonder if the disk is being
>>> accessed.  On the other hand, when I load the driver in RQ or MQ mode,
>>> the Disk Stats show a utilization of 100% (or near 100%).  The IOPS
>>> for BIO mode are greater than the IOPS for MQ mode, which is another
>>> red flag that the BIO mode IOPS may not be accurate.
>>>
>>> I am able to successfully perform read/write/verification tests
>>> outside of fio in all block driver modes.
>>>
>>> My question is how can I get an accurate IOPS performance measurement
>>> for the driver in BIO mode?  Is there a bug in fio, or am I missing
>>> some parameter?
>>>
>>> Also, it seems that IOPS should be higher in general for MQ mode.  Are
>>> there any performance tuning suggestions for MQ?
>>
>> In bio mode, the driver is bypassing the entire stack. This means that
>> you miss out on certain things, IO stats being one of them.
>>
>> Since bio is a raw mode, it's also not unusual for it to be slightly
>> faster than MQ, depending on what you run. Some of that might be due to
>> a suboptimal conversion to MQ, I can't really say without seeing the
>> code. Things like IO/part stats can be a bit costly as well, so just
>> turning that off in MQ mode may make you run closer to the BIO speed.
>
> BTW, to expand on this - this was primarily in the context of a ramdisk
> driver, which isn't representative of how a real world device would
> actually operate. MQ tags everything, since real hw requires this. This
> is just a waste on a ramdisk driver. And if the ramdisk driver processes
> everything inline, then you would also lose some of the MQ benefit
> there. MQ also provides inline storage for hw commands, a ramdisk driver
> would not need that either. So basically all the functionality that MQ
> provides in a scalable way is not going to be useful for your test case,
> it will only slow things down a little bit. This is similar to the noop
> blk driver that was included with blk-mq. It really only serves as a
> comparison between RQ and MQ mode, the BIO mode is mostly useful to
> highlight problems elsewhere in the stack. It's just not a fair comparison.
>
> On the stats part, you can trust what fio tells you. Only the disk util
> stats are provided by the kernel, the rest is calculated by fio.
>
>
> --
> Jens Axboe
>

Thank you.
CONFIDENTIALITY
This e-mail message and any attachments thereto, is intended only for use by the addressee(s) named herein and may contain legally privileged and/or confidential information. If you are not the intended recipient of this e-mail message, you are hereby notified that any dissemination, distribution or copying of this e-mail message, and any attachments thereto, is strictly prohibited.  If you have received this e-mail message in error, please immediately notify the sender and permanently delete the original and any copies of this email and any prints thereof.
ABSENT AN EXPRESS STATEMENT TO THE CONTRARY HEREINABOVE, THIS E-MAIL IS NOT INTENDED AS A SUBSTITUTE FOR A WRITING.  Notwithstanding the Uniform Electronic Transactions Act or the applicability of any other law of similar substance and effect, absent an express statement to the contrary hereinabove, this e-mail message its contents, and any attachments hereto are not intended to represent an offer or acceptance to enter into a contract and are not otherwise intended to bind the sender, Sanmina Corporation (or any of its subsidiaries), or any other person or entity.

DISCLAIMER:  The individual sending this e-mail is not an employee of Sanmina Corporation or its subsidiaries, but serves as an independent contractor.  Accordingly, the individual sending this e-mail has no authority to legally bind Sanmina or its subsidiaries.  Only employees possessing the requisite level of authority under Sanmina policies have the ability to bind Sanmina.  If you have a question regarding an individual's ability to bind Sanmina, please contact Sanmina's Legal Department at (408) 964-3156.


