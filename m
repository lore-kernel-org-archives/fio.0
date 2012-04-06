Return-Path: <sureshdrajan@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4F7E35F2.5010701@kernel.dk>
References: <CAN8qX8YZoZ2TtcqU0QOTEguHoqsYQRuMoFvRsT3JTJc9Uba19w@mail.gmail.com>
	<4F7E35F2.5010701@kernel.dk>
Date: Thu, 5 Apr 2012 17:28:19 -0700
Message-ID: <CAN8qX8ZnCCZz3cBbhocdTwXgBqsL=JV=QYFD_OSj4nmEFVUZMQ@mail.gmail.com>
Subject: Re: query on verify_dump option
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,

I am looking for this files in the same location where my fio is and i
dont see the two files that you refereed.

We have option to give pattern during verify only.
What i mentioned is during Write and reads there is no option to
provide the patterns.

thanks,
Suresh.D

On Thu, Apr 5, 2012 at 5:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-04-05 17:20, Suresh Dhanarajan wrote:
>> Hi,
>>
>> I am trying data integration cases with verify_pattern option.
>> I am not seeing any dump file generated for the mismatch.
>> Here are the steps i followed,
>> Started fio and waited till 30 % writes done the disk and issued a dd
>> write on the same disc for the first 512 bytes with pattern zero.
>> then waited till verify gets completed.
>> I can see the error's in the output log file but not the dump file.
>>
>> Here is my job file.
>>
>> [global]
>> size=10g
>> direct=1
>> filename=/dev/sdc
>> verify_pattern=0x01010101
>> verify=meta
>> bs=64k
>> group_reporting
>>
>> [write-phase]
>> rw=write
>> do_verify=0
>>
>> [verify-phase]
>> stonewall
>> rw=read
>> do_verify=1
>> continue_on_error=all
>> verify_dump=1
>> ~
>>
>>
>>
>> Let me know if i am missing something over here.
>
> You don't get the .received and .expected files?
>
>> 2)Also i have one query like verify_pattern option is it possible to
>> provide known pattern for write and reads this will be very useful in
>> DI verification test cases
>
> Not sure I understand this one. You are already providing the pattern
> you want. What am I missing?
>
> --
> Jens Axboe
>

