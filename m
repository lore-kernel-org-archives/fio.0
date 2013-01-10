Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:59230 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3AJVCa (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Jan 2013 16:02:30 -0500
Received: by mail-qa0-f48.google.com with SMTP id l8so957988qaq.7
        for <fio@vger.kernel.org>; Thu, 10 Jan 2013 13:02:29 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 10 Jan 2013 15:57:18 -0500
Message-ID: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
Subject: fio is being killed by the oom-killer after fio verify runs for some
 time ~13 hours
From: brian arb <brianjamesarb@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Seems fio is being killed by the oom-killer after fio verify runs for
some time ~13 hours. What parameters can I tweak or how can I run my
test differently so the test will be completed with out interruption?

Any help is appericated

My System has 16GB of memory, 12 x 3TB Drives and one 60GB SSD

Disk information
cat /sys/bus/scsi/devices/*/model | sort | uniq -c
     12 Hitachi HUA72303
      1 KINGSTON SVP200S

fio --version
fio 1.50

uname -a
Linux myhostname 2.6.39-t4.el5 #1 SMP Tue Jan 31 13:18:29 PST 2012
x86_64 x86_64 x86_64 GNU/Linux


the script:
#!/bin/bash
set -e

IO_DEPTH=1
BLOCK_SIZE=4096
IO_ENGINE=libaio
READ_WRITE=write
DIRECT=1
VERIFY=crc32c-intel
BUFFERED=0
VERIFY_FATAL=1

/usr/bin/fio \
	--minimal \
	--readwrite=${READ_WRITE} \
	--blocksize=${BLOCK_SIZE} \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdj \
	--new_group \
	--filename=/dev/sdj \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdm \
	--new_group \
	--filename=/dev/sdm \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdd \
	--new_group \
	--filename=/dev/sdd \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sde \
	--new_group \
	--filename=/dev/sde \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdf \
	--new_group \
	--filename=/dev/sdf \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdg \
	--new_group \
	--filename=/dev/sdg \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sda \
	--new_group \
	--filename=/dev/sda \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdb \
	--new_group \
	--filename=/dev/sdb \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdc \
	--new_group \
	--filename=/dev/sdc \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdl \
	--new_group \
	--filename=/dev/sdl \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdk \
	--new_group \
	--filename=/dev/sdk \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdh \
	--new_group \
	--filename=/dev/sdh \
	--ioengine=${IO_ENGINE} \
	--direct=${DIRECT} \
	--buffered=${BUFFERED} \
	--iodepth=${IO_DEPTH} \
	--verify=${VERIFY} \
	--verify_fatal=${VERIFY_FATAL} \
	--name=verify_sdi \
	--new_group \
	--filename=/dev/sdi
