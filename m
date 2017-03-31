Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34337 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753430AbdCaVZr (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2017 17:25:47 -0400
Received: by mail-vk0-f41.google.com with SMTP id z204so103674564vkd.1
        for <fio@vger.kernel.org>; Fri, 31 Mar 2017 14:25:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACqzM2DuU22spqRO3n78zpfMNJ+FiDTYPmSv3ZOpQhVCb2WAQQ@mail.gmail.com>
References: <CACqzM2CTN9w45owkjvoTR+Ca4QJFvM_MnOZE9+BU+dCxo2nuEQ@mail.gmail.com>
 <CALjAwxgZx+QHcM74ERtj1zUZo1r+aCfgCP8wnhNicJ01b768FA@mail.gmail.com>
 <CACqzM2AmmgacpGd+QVt42=SdqQrDENigb7TUs-x50iuD9KWt6Q@mail.gmail.com>
 <CALjAwxiHDO0AwQWNYR4J_TL821hhbjn6J0Arm5p73t5dZotV3w@mail.gmail.com>
 <CACqzM2AwbutwGND4PiC+EaH-DHCr=xQiz6HZTApAcjv8qNczxw@mail.gmail.com> <CACqzM2DuU22spqRO3n78zpfMNJ+FiDTYPmSv3ZOpQhVCb2WAQQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Mar 2017 22:25:16 +0100
Message-ID: <CALjAwxh5UoEZCn6Ov4JCKaOpKi_mSCcWG1vAFzct_wLRdLjqYA@mail.gmail.com>
Subject: Re: numberio failure with numjobs=1
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Guruganesh Hegde <guruhegde4u@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Ok good to know. I'm not surprised you can't reproduce it with loops=1
- each time you're laying down the same thing so if the disk is
"forgetting" to write a block what you want will be there anyway from
the last pass. If you keep the size=256M can you keep halving the
iodepth (16, 8, 4, 2) can you still reproduce the issue? When you let
fio pick the initial starting seed by not explicitly setting randseed?
Can you make it happen with rw=write? bsrange=4k-64k?

If it deterministically happens at small sizes and low iodepths it
should be possible for me to reproduce it too. Can you make it happen
on non-nvme devices with the same small workloads?

On 31 March 2017 at 14:47, Guruganesh Hegde <guruhegde4u@gmail.com> wrote:
> I am able to reproduce this issue even in fio 2.18 with Size 1G & 256M
>
> I have figured out a work around,
> If I set loops=1 in a config file and launch fio from a shell script,
> this issue is not seen.
>
> However if I set loops > 1, then most likely this issue is seen.
>
> Another interesting observation, if combination of loop & size results
> into very small amount of data and if fio test finishes in few seconds
> this issue is not seen.
> For example,
> if I set size=1M & loops=10, then test runs without failure.
>
> One another observation is,
> I had run test with loops=1 size=32 for 100 iterations. (Launching
> from shell scripts) and no single failure is observed.
> After finishing above test, repeated test with loops =1 and size=64G,
> test failed in 1st iteration remaining iterations are fine. (This test
> is still running currently at 8th iteration)
>
> Failing log
>
> Jobs: 1 (f=1): [V(1)][72.1%][r=587MiB/s,w=0KiB/s][r=150k,w=0 IOPS][eta
> 00m:57s]^Mfio: pid=16009, err=84/file:io_u.c:1982,
> func=io_u_queued_complete, error=Invalid or incomplete multibyte or
> wide character
>
> write-phase: (groupid=0, jobs=1): err=84 (file:io_u.c:1982,
> func=io_u_queued_complete, error=Invalid or incomplete multibyte or
> wide character): pid=16009: Fri Mar 31 06:23:47 2017
>    read: IOPS=165k, BW=643MiB/s (674MB/s)(28.3GiB/45039msec)
>
> Disk stats (read/write):
>   nvme0n1: ios=7392130/16777216, merge=0/0, ticks=1261335/792207,
> in_queue=2052208, util=99.94%

-- 
Sitsofe | http://sucs.org/~sits/
