Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36729 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbeBIKKt (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Feb 2018 05:10:49 -0500
Received: by mail-vk0-f53.google.com with SMTP id m197so4522814vka.3
        for <fio@vger.kernel.org>; Fri, 09 Feb 2018 02:10:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmTCDO4tn4u1=GyZB3xm5JUjB8LQyvjeFhig8uWH+-HJjA@mail.gmail.com>
References: <CAPSTwmSKtMj5yGR2Wb3AY54_CGfWbdEqoWKYy1fKDBiQ3Uo4=Q@mail.gmail.com>
 <CAPSTwmRSGS2xrg=uTtWP-0mU8n0us_1QE8wAF7_tEkUPKJ8CnQ@mail.gmail.com>
 <CALjAwxhb2ozbDNv02CqiaHUzHmCFDYU6+_DNwhde2GnRT2pEcw@mail.gmail.com>
 <CAPSTwmSAFStSizVSp4cMJv8NMnP=wVnfnp_A6SPXTfgOO-FmaQ@mail.gmail.com>
 <CALjAwxiA_oFXEp224WD1Txg80vYxG6VEZLL-+fa2=2YHquOT=Q@mail.gmail.com> <CAPSTwmTCDO4tn4u1=GyZB3xm5JUjB8LQyvjeFhig8uWH+-HJjA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 9 Feb 2018 10:10:18 +0000
Message-ID: <CALjAwxjA9Mv1FhqUXGRwOK7=b_vS830VODbJRd4ObfFZMSTvSA@mail.gmail.com>
Subject: Re: Failures noticed in FIO run
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 9 February 2018 at 04:21, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> Below is the drive information
> blockdev --getsize64  /dev/nvme0n1
>
> 3840755982336
>
> fdisk -l
>
> Disk /dev/nvme0n1: 3840.8 GB, 3840755982336 bytes, 7501476528 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
>
> I had to change the sector size from 4K to 512 and now I didn't see
> the failure mentioned below. Will loop through and update

Seems strange that the problem would go away just due to shrinking
fio's blocksize given that 4k is a multiple of 512. You never said if
dmesg showed any clues though...

> I was using offset and sizeToWrite parameters when I wanted to fill
> certain number of bytes from certain start location.
> Currently I am using "sizeToWrite" to specify the bytes to write and
> "offset" from the byte to start
> But from the suggestions it seems I have to chose the offset such that
> its divisible by blocksize of filesystem. I am using blockdev --getbsz

Note in the examples you gave you were not doing I/O to a file in a
filesystem - you were just writing directly to a disk so I'm going to
assume you just mean disk where you have written filesystem :-) But
yes, you will have to ensure an absolute offset is a multiple of the
disk's block size when doing direct IO to a disk on Linux.

> Let me know if you guys think that should solve the problem or you
> come across any other optimal way to do the same without using offset
> and sizeToWrite

Only passing in an aligned offset should solve the problem and I'm not
aware of anther way.

> Also which of the below do you think I should use to get the LBA size on device
> blockdev --getbsz /dev/nvme0n1 or blockdev --getss /dev/nvme0n1

Either will do but if I were choosing I'd prefer the number from
getbsz. From what I can see getbsz corresponds to the physical block
size (which is closer to the minimum block size the "disk" actually
has to use behind the scenes) and getss corresponds to the logical
block size (the minimum block size your "disk" can accept even if it
means it means faking it and doing extra work).

-- 
Sitsofe | http://sucs.org/~sits/
