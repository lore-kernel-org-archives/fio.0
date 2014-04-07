Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
In-Reply-To: <533D97B5.8080600@kernel.dk>
References: <CAEyTGCfGRExp32sZhnEash1LN26z9mCUeVuSP5T8mKpMu002+g@mail.gmail.com>
	<533D97B5.8080600@kernel.dk>
Date: Mon, 7 Apr 2014 12:16:14 -0500
Message-ID: <CAEyTGCcujBsEZujqjV3EW-RgOw_VFmLEBex4TJ1tcRpDqWPUQA@mail.gmail.com>
Subject: Re: FIO hangs and shows HUGE eta while replaying blkparse.bin files - 2.1.6.1
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks Jens, yes that worked.

-Lakshmi

On Thu, Apr 3, 2014 at 12:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/03/2014 09:49 AM, Lakshmi wrote:
>>
>> Hello,
>>
>>    I am having a strange problem. I am trying to replay the blkparsed
>> binary files through FIO and FIO hangs staying at a certain % and the
>> eta time just keeps increasing.
>> =====================================
>> job2: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
>> fio-2.1.6.1
>> Starting 1 process
>> Jobs: 1 (f=1): [W] [45.9% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
>> 00m:20s]
>>
>> =====================================
>>
>> Input file for FIO job to replay- file_65208400.bin
>>
>> Attached are the file_65208400.bin file used in FIO and the text file
>> of the blktrace that was run in parallel when the above job was
>> running.
>>
>> The trace text file doesn't show any information on what went wrong ,
>> and can anyone give me some pointers on debugging this?
>
>
> If you look at the blktrace, there is a lot of time between events. Does it
> complete if you add replay_no_stall=1 as an option?
>
> --
> Jens Axboe
>

