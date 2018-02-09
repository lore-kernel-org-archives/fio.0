Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:35965 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752239AbeBIEVJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Feb 2018 23:21:09 -0500
Received: by mail-wr0-f177.google.com with SMTP id y3so6881585wrh.3
        for <fio@vger.kernel.org>; Thu, 08 Feb 2018 20:21:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiA_oFXEp224WD1Txg80vYxG6VEZLL-+fa2=2YHquOT=Q@mail.gmail.com>
References: <CAPSTwmSKtMj5yGR2Wb3AY54_CGfWbdEqoWKYy1fKDBiQ3Uo4=Q@mail.gmail.com>
 <CAPSTwmRSGS2xrg=uTtWP-0mU8n0us_1QE8wAF7_tEkUPKJ8CnQ@mail.gmail.com>
 <CALjAwxhb2ozbDNv02CqiaHUzHmCFDYU6+_DNwhde2GnRT2pEcw@mail.gmail.com>
 <CAPSTwmSAFStSizVSp4cMJv8NMnP=wVnfnp_A6SPXTfgOO-FmaQ@mail.gmail.com> <CALjAwxiA_oFXEp224WD1Txg80vYxG6VEZLL-+fa2=2YHquOT=Q@mail.gmail.com>
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Thu, 8 Feb 2018 21:21:07 -0700
Message-ID: <CAPSTwmTCDO4tn4u1=GyZB3xm5JUjB8LQyvjeFhig8uWH+-HJjA@mail.gmail.com>
Subject: Re: Failures noticed in FIO run
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Thanks Sitsofe and Jeff

As suggested removed the --ba parameter for sequential writes


Below is the drive information
blockdev --getsize64  /dev/nvme0n1

3840755982336

fdisk -l

Disk /dev/nvme0n1: 3840.8 GB, 3840755982336 bytes, 7501476528 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

I had to change the sector size from 4K to 512 and now I didn't see
the failure mentioned below. Will loop through and update


I was using offset and sizeToWrite parameters when I wanted to fill
certain number of bytes from certain start location.
Currently I am using "sizeToWrite" to specify the bytes to write and
"offset" from the byte to start
But from the suggestions it seems I have to chose the offset such that
its divisible by blocksize of filesystem. I am using blockdev --getbsz
/dev/nvme0n1 to determine the blocksize
Let me know if you guys think that should solve the problem or you
come across any other optimal way to do the same without using offset
and sizeToWrite

Also which of the below do you think I should use to get the LBA size on device
blockdev --getbsz /dev/nvme0n1 or blockdev --getss /dev/nvme0n1


Regards,
Gnana

On Wed, Feb 7, 2018 at 9:12 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 7 February 2018 at 00:19, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>>
>> Experimented few loops and ran into the below failures even when I
>> didn't pass in the write offset to FIO. The block size is 4k on the
>> drive
>>
>> 2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - The arguments
>> passed are: sudo fio --thread --direct=1 --minimal --ioengine=libaio
>> --numjobs=1 --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
>> --name=bs16384_rwwrite_qd256 --buffer_pattern=1193046 --iodepth=256
>> --size=100% --percentage_random=0 --bs=256k --ba=4k --rw=write
>> 2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - Error in FIO
>> run: fio: io_u error on file /dev/nvme0n1: Input/output error: write
>> offset=27160215552, buflen=262144
>>
>> 2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - Error in FIO
>> run: fio: io_u error on file /dev/nvme0n1: Input/output error: write
>> offset=27205828608,
>
> (note that blockalign/ba is only really for random I/O)
>
> This looks strange. What does
> blockdev --getsize64  /dev/nvme0n1
> report and is there anything interesting in the tail end of dmesg just
> after you trigger this issue?
>
>> Similarly if I pass offsets that aren't aligned with file system
>> underneath, is there a way to inform fio to round it up
>
> Jeff answered this one in another reply.
>
> --
> Sitsofe | http://sucs.org/~sits/
