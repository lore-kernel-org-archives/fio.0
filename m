Return-Path: <axboe@kernel.dk>
Message-ID: <533D97B5.8080600@kernel.dk>
Date: Thu, 03 Apr 2014 11:17:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO hangs and shows HUGE eta while replaying blkparse.bin files
 - 2.1.6.1
References: <CAEyTGCfGRExp32sZhnEash1LN26z9mCUeVuSP5T8mKpMu002+g@mail.gmail.com>
In-Reply-To: <CAEyTGCfGRExp32sZhnEash1LN26z9mCUeVuSP5T8mKpMu002+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/03/2014 09:49 AM, Lakshmi wrote:
> Hello,
>
>    I am having a strange problem. I am trying to replay the blkparsed
> binary files through FIO and FIO hangs staying at a certain % and the
> eta time just keeps increasing.
> =====================================
> job2: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio-2.1.6.1
> Starting 1 process
> Jobs: 1 (f=1): [W] [45.9% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 00m:20s]
>
> =====================================
>
> Input file for FIO job to replay- file_65208400.bin
>
> Attached are the file_65208400.bin file used in FIO and the text file
> of the blktrace that was run in parallel when the above job was
> running.
>
> The trace text file doesn't show any information on what went wrong ,
> and can anyone give me some pointers on debugging this?

If you look at the blktrace, there is a lot of time between events. Does 
it complete if you add replay_no_stall=1 as an option?

-- 
Jens Axboe


