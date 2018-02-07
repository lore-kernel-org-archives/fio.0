Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:39529 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754377AbeBGQMm (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Feb 2018 11:12:42 -0500
Received: by mail-ua0-f179.google.com with SMTP id r4so887129uak.6
        for <fio@vger.kernel.org>; Wed, 07 Feb 2018 08:12:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmSAFStSizVSp4cMJv8NMnP=wVnfnp_A6SPXTfgOO-FmaQ@mail.gmail.com>
References: <CAPSTwmSKtMj5yGR2Wb3AY54_CGfWbdEqoWKYy1fKDBiQ3Uo4=Q@mail.gmail.com>
 <CAPSTwmRSGS2xrg=uTtWP-0mU8n0us_1QE8wAF7_tEkUPKJ8CnQ@mail.gmail.com>
 <CALjAwxhb2ozbDNv02CqiaHUzHmCFDYU6+_DNwhde2GnRT2pEcw@mail.gmail.com> <CAPSTwmSAFStSizVSp4cMJv8NMnP=wVnfnp_A6SPXTfgOO-FmaQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Feb 2018 16:12:10 +0000
Message-ID: <CALjAwxiA_oFXEp224WD1Txg80vYxG6VEZLL-+fa2=2YHquOT=Q@mail.gmail.com>
Subject: Re: Failures noticed in FIO run
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 7 February 2018 at 00:19, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> Experimented few loops and ran into the below failures even when I
> didn't pass in the write offset to FIO. The block size is 4k on the
> drive
>
> 2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - The arguments
> passed are: sudo fio --thread --direct=1 --minimal --ioengine=libaio
> --numjobs=1 --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
> --name=bs16384_rwwrite_qd256 --buffer_pattern=1193046 --iodepth=256
> --size=100% --percentage_random=0 --bs=256k --ba=4k --rw=write
> 2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - Error in FIO
> run: fio: io_u error on file /dev/nvme0n1: Input/output error: write
> offset=27160215552, buflen=262144
>
> 2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - Error in FIO
> run: fio: io_u error on file /dev/nvme0n1: Input/output error: write
> offset=27205828608,

(note that blockalign/ba is only really for random I/O)

This looks strange. What does
blockdev --getsize64  /dev/nvme0n1
report and is there anything interesting in the tail end of dmesg just
after you trigger this issue?

> Similarly if I pass offsets that aren't aligned with file system
> underneath, is there a way to inform fio to round it up

Jeff answered this one in another reply.

-- 
Sitsofe | http://sucs.org/~sits/
