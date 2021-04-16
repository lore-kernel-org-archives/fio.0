Return-Path: <fio-owner@vger.kernel.org>
Received: from dish-sg.nttdocomo.co.jp ([202.19.227.74]:41858 "EHLO
        dish-sg.nttdocomo.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbhDPBqI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Apr 2021 21:46:08 -0400
Subject: Re: [Question] Sequential mesuaring and filename option
References: <059fa98d-9088-5daa-834e-5c87d60bb836@nttcom.co.jp_1>
 <7875665d-82ca-2bf5-faf2-21c67dfc613e@criteo.com>
 <6bf156f9-5771-0afe-92c5-d8bb1e04b69f@nttcom.co.jp_1>
 <CALjAwxj_-Q1HteM1MdcmxfeuAD54jvQMNpQi5Rt78sC-9ZRgHw@mail.gmail.com>
 <f2e9d44d-9d1f-46a2-3112-a1982c559ac5@nttcom.co.jp_1>
 <CALjAwxh79d7ebKNU3xZUaQgF50q-3bVLVSC1QJ+Ub=3DsX6XPQ@mail.gmail.com>
From: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Message-id: <7cd0c68b-e3fe-10fe-27ba-9e92688ea931@nttcom.co.jp_1>
Date: Fri, 16 Apr 2021 10:42:57 +0900
MIME-version: 1.0
In-reply-to: <CALjAwxh79d7ebKNU3xZUaQgF50q-3bVLVSC1QJ+Ub=3DsX6XPQ@mail.gmail.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-US
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Erwan Velu <e.velu@criteo.com>

On 2021/04/16 4:37, Sitsofe Wheeler wrote:
> On Thu, 15 Apr 2021 at 03:49, Nakajima Akira 
> <nakajima.akira@nttcom.co.jp <mailto:nakajima.akira@nttcom.co.jp>> wrote:
> 
> 
>     Hi.
> 
>     Sorry. Due to my company's email sender domain restrictions,
>        it could not be sent to gmail.
> 
> 
>     Above is the result on unencrypted ext4/xfs.
>     Similar results are obtained on encrypted ext4/xfs.
> 
> 
>     Since the memory is 24GB, I tried it with 72GB + α = 76GB.
> 
>     # fio -filename=/testfile -direct=1 -ioengine=libaio -rw=write -bs=1m
>     -size=76G -runtime=60 -numjobs=1 -group_reporting -name=a
>         write: IOPS=195, BW=195MiB/s (205MB/s)(11.4GiB/60023msec)
> 
>     # fio -filename=/testfile -direct=1 -ioengine=libaio -rw=write -bs=1m
>     -size=76G -runtime=60 -numjobs=10 -group_reporting -name=a
>         write: IOPS=1622, BW=1622MiB/s (1701MB/s)(95.1GiB/60042msec)
> 
>     # fio -filename=/testfile -direct=1 -ioengine=libaio -rw=write -bs=1m
>     -size=76G -runtime=300 -numjobs=10 -group_reporting -name=a
>         write: IOPS=1879, BW=1880MiB/s (1971MB/s)(551GiB/300004msec)
> 
> 
> Ah, that numjobs value is REALLY important for the type of job file 
> you have! Using numjobs on the same filename can lead to reuse of the 
> same area (think job 1 and job 2 writing the same blocks in lockstep) 
> which may in turn lead to not all I/Os being sent down to the disk if 
> they are close enough together. This may make a nonsense of your 
> benchmark...
> 
>     Up to numjobs = about 10, it increases in proportion to the value of
>     numjobs.
> 
> -- 
> Sitsofe

Hi.


Now I tried, but these had the same results.
   (twice as much as numjobs=1)
-filename=/mnt/test1:/mnt/test2
-filename=/dev/sdb  (after umount /mnt)

# fio -filename=xxx -direct=1 -ioengine=libaio -rw=write -bs=1m -size=8G 
-runtime=60 -numjobs=2 -group_reporting -name=a


Using -directory instead of -filename is only way to get correct result?


Thanks.
Nakajima.


