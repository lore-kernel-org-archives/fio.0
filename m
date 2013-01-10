Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61458 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3AJVJs (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Jan 2013 16:09:48 -0500
Received: by mail-ob0-f171.google.com with SMTP id dn14so1070754obc.30
        for <fio@vger.kernel.org>; Thu, 10 Jan 2013 13:09:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
Date: Thu, 10 Jan 2013 14:09:47 -0700
Message-ID: <CANWz5fhzJ03ADojUSrQNAFx621BOHU2GftUNDJyrv-DAqo5Ysg@mail.gmail.com>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: brian arb <brianjamesarb@gmail.com>
Cc: fio@vger.kernel.org

Try norandommap ... that gives me an issue sometimes if I don't have
enough memory.

On Thu, Jan 10, 2013 at 1:57 PM, brian arb <brianjamesarb@gmail.com> wrote:
> Seems fio is being killed by the oom-killer after fio verify runs for
> some time ~13 hours. What parameters can I tweak or how can I run my
> test differently so the test will be completed with out interruption?
>
> Any help is appericated
>
> My System has 16GB of memory, 12 x 3TB Drives and one 60GB SSD
>
> Disk information
> cat /sys/bus/scsi/devices/*/model | sort | uniq -c
>      12 Hitachi HUA72303
>       1 KINGSTON SVP200S
>
> fio --version
> fio 1.50
>
> uname -a
> Linux myhostname 2.6.39-t4.el5 #1 SMP Tue Jan 31 13:18:29 PST 2012
> x86_64 x86_64 x86_64 GNU/Linux
>
>
> the script:
> #!/bin/bash
> set -e
>
> IO_DEPTH=1
> BLOCK_SIZE=4096
> IO_ENGINE=libaio
> READ_WRITE=write
> DIRECT=1
> VERIFY=crc32c-intel
> BUFFERED=0
> VERIFY_FATAL=1
>
> /usr/bin/fio \
>         --minimal \
>         --readwrite=${READ_WRITE} \
>         --blocksize=${BLOCK_SIZE} \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdj \
>         --new_group \
>         --filename=/dev/sdj \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdm \
>         --new_group \
>         --filename=/dev/sdm \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdd \
>         --new_group \
>         --filename=/dev/sdd \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sde \
>         --new_group \
>         --filename=/dev/sde \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdf \
>         --new_group \
>         --filename=/dev/sdf \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdg \
>         --new_group \
>         --filename=/dev/sdg \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sda \
>         --new_group \
>         --filename=/dev/sda \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdb \
>         --new_group \
>         --filename=/dev/sdb \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdc \
>         --new_group \
>         --filename=/dev/sdc \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdl \
>         --new_group \
>         --filename=/dev/sdl \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdk \
>         --new_group \
>         --filename=/dev/sdk \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdh \
>         --new_group \
>         --filename=/dev/sdh \
>         --ioengine=${IO_ENGINE} \
>         --direct=${DIRECT} \
>         --buffered=${BUFFERED} \
>         --iodepth=${IO_DEPTH} \
>         --verify=${VERIFY} \
>         --verify_fatal=${VERIFY_FATAL} \
>         --name=verify_sdi \
>         --new_group \
>         --filename=/dev/sdi
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
