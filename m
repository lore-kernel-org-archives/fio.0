Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38455 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbbDQPmq (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Apr 2015 11:42:46 -0400
Received: by wiun10 with SMTP id n10so24931917wiu.1
        for <fio@vger.kernel.org>; Fri, 17 Apr 2015 08:42:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Apr 2015 16:42:45 +0100
Message-ID: <CAMwGr2sg+3HY469fipJhPaqzcCtbgvu6Pejw055O_NP+dO=+sA@mail.gmail.com>
Subject: fio trim bug
From: Neil Durbridge <neildurbridge@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I think I've found a bug with fio when using trim.
The size of the workload is reduced proportionally to the number of
trim/dsm commands that are issued. This applies to the write size and
(if specified) the verify size too, so no corruption is reported.
However, if you later repeat the workload with verify_only set, it
attempts to verify the whole range, and finds corruption at the LBAs
which were never written,


Example
I've got this down to a tiny example to fit on a bus trace so i could debug it:

./fio --ioengine=libaio --direct=1 --rw=write --bs=4k --size=40k
--iodepth=1 --randrepeat=1 --trim_backlog=1 --trim_percent=20
--trim_verify=1 --verify_dump=1 --error_dump=1 --numjobs=1
--verify=meta --loops=1 --filename=/dev/sdb --name=dsmtest
--output=trace.log

This should result in 10x 4K sequential Writes to LBAs 0x0, 0x8, 0x10
... 0x48; and two 4K ranges being trimmed (20%)

Instead, only 8x 4K ranges are written: the last Write goes to LBA
0x38; and two 4K ranges are trimmed, Same for the Read commands.

If I increase trim_percent to 30%, you get 7x 4K writes and 3 trims, and so on.

Then when I run this same command with --verify_only, corruption is
reported from the first block that was never written

fio version is 2.2.6
Linux is Ubuntu 14.04LTS; k3.13.0-24

Any chance of a fix?!?

Great tool though, cheers
