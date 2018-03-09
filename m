Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:50182 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751349AbeCIUMX (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Mar 2018 15:12:23 -0500
Received: by mail-it0-f48.google.com with SMTP id d13so4144042itf.0
        for <fio@vger.kernel.org>; Fri, 09 Mar 2018 12:12:23 -0800 (PST)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Fri, 9 Mar 2018 12:11:41 -0800
Message-ID: <CAKwzdDoswbH-Zun2i0pawWHLDDO3wgNW6PKE46ubixHtEm5cqg@mail.gmail.com>
Subject: log_offset parameter not logging offset
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

All,
Can someone please confirm if my usage is correct as earlier the
offset used to be logged by using the log_offset=1 in the files.
I am using FIO3.5.

fio --name=global --time_based --size=100% --direct=1 --norandommap
--randrepeat=0 --buffered=0 --refill_buffers --name=job
--ioengine=libaio --group_reporting --filename=/dev/nvme0n1
--numjobs=1 --iodepth=128 --bs=128k --rw=rw --rwmixread=70
--runtime=10800 --write_iops_log=wr.log -write_lat_log=wr.clat.log
--log_avg_msec=1000 --log_offset=1

appreciate the support.

Life is too short for silly things so invest your time in some
productive outputs!!
