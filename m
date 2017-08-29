Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34992 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdH2FKH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Aug 2017 01:10:07 -0400
Received: by mail-vk0-f42.google.com with SMTP id z187so6774613vkd.2
        for <fio@vger.kernel.org>; Mon, 28 Aug 2017 22:10:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAEM5qKmvP5ZR9hYVFa=JxjrnTLwiEp4gy+0aJ-r1eaLJnLAnQ@mail.gmail.com>
References: <CAAEM5qL7Ze0fwDrohz7Mn-kjWzV3G3BKST0BvYFRpW+2bB38Ag@mail.gmail.com>
 <CALjAwxjJKsgaUA7+LsvAmG4dG6iRgKL_g5aFhj_=oELzBTjc=Q@mail.gmail.com> <CAAEM5qKmvP5ZR9hYVFa=JxjrnTLwiEp4gy+0aJ-r1eaLJnLAnQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 29 Aug 2017 06:09:36 +0100
Message-ID: <CALjAwxg1XZJaYsGXJVkP81Pt8bBL2FcfbqHu5s=5=X6za3j=Bw@mail.gmail.com>
Subject: Re: exitall_on_error option with stats
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: siha lawrence <sihaj33@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Siha,

To try and take this further can you:
1. Update and build the latest git version fio and try and reproduce
the problem with your original command line.
2. Try to remove every job option possible such that you end up with
the minimum set that still allows the problem to happen.
3. Post an update here with your results including all the information
that is mentioned in
https://github.com/axboe/fio/blob/master/REPORTING-BUGS and the output
that fio produces.

Thanks!

On 29 August 2017 at 05:21, siha lawrence <sihaj33@gmail.com> wrote:
>
> The job command I'm using is:
>
> sudo fio --ioengine=libaio --size=100% --ramp_time=10 --runtime=40
> --time_based=1 --verify_backlog=1 --verify_dump=1 --verify_fatal=1
> --norandommap --numjobs=1 --direct=1 --rw=write --bs=1K --iodepth=8
> --exitall_on_error --buffer_pattern=0x10000000000000000L --minimal
> --random_generator=tausworthe64 --name=/dev/sda  --name=/dev/sdcd
> --name=/dev/sdce  --name=/dev/sdcb
>
> On Sat, Aug 26, 2017 at 12:29 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> I'm afraid I can't reproduce the problem with a post 3.0 fio build:
>>
>> sudo -s
>> echo -e "0 511 zero\n511 1 error" | dmsetup create errorend
>> fio --exitall_on_error --direct=1 --bs=512 --rate=64k --name=null
>> --ioengine=null --size=512k --name=errorjob
>> --filename=/dev/mapper/errorend
>> null: (g=0): rw=read, bs=(R) 512B-512B, (W) 512B-512B, (T) 512B-512B,
>> ioengine=null, iodepth=1
>> errorjob: (g=0): rw=read, bs=(R) 512B-512B, (W) 512B-512B, (T)
>> 512B-512B, ioengine=psync, iodepth=1
>> fio-3.0-5-g168b
>> Starting 2 processes
>> fio: io_u error on file /dev/mapper/errorend: Input/output error: read
>> offset=261632, buflen=512
>> fio: pid=26078, err=5/file:io_u.c:1756, func=io_u error,
>> error=Input/output error
[...]
>>
>> But I can't tell if there's more to your issue because you didn't
>> include the exact job file/command line you were running with. Can you
>> update your fio to at least 3.0 (or git master), reproduce the problem
>> and include at least the information in
>> https://github.com/axboe/fio/blob/master/REPORTING-BUGS ? Thanks!
>
>> On 21 August 2017 at 03:32, siha lawrence <sihaj33@gmail.com> wrote:
>>> I'm using fio version 2.20 with the option exitall_on_error. On error,
>>> it exits and reports all stats as zero.
>>> How can this be modified so that we can get partial stats and not zeros?

-- 
Sitsofe | http://sucs.org/~sits/
