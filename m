Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:34692 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbeBFFQB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Feb 2018 00:16:01 -0500
Received: by mail-wr0-f181.google.com with SMTP id z6so605002wrb.1
        for <fio@vger.kernel.org>; Mon, 05 Feb 2018 21:16:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmSKtMj5yGR2Wb3AY54_CGfWbdEqoWKYy1fKDBiQ3Uo4=Q@mail.gmail.com>
References: <CAPSTwmSKtMj5yGR2Wb3AY54_CGfWbdEqoWKYy1fKDBiQ3Uo4=Q@mail.gmail.com>
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Mon, 5 Feb 2018 22:15:59 -0700
Message-ID: <CAPSTwmRSGS2xrg=uTtWP-0mU8n0us_1QE8wAF7_tEkUPKJ8CnQ@mail.gmail.com>
Subject: Fwd: Failures noticed in FIO run
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Occasionally stepping into couple of failures with FIO with arguments
captured below
So wanted to get opinion on if I am missing something in parameters

Failure 1:
The arguments passed are: sudo fio --thread --direct=1 --minimal
--ioengine=libaio --numjobs=1 --filename=/dev/nvme0n1 -o
/tmp/nvme0n1_temp.log --name=bs16384_rwwrite_qd256 --buffer_pattern=0
--iodepth=256 --size=409600 --percentage_random=0 --bs=256k
--offset=625181037 --rw=write

Error in FIO run: fio: io_u error on file /dev/nvme0n1: Invalid
argument: write offset=625181037, buflen=262144

Error in FIO run: fio: io_u error on file /dev/nvme0n1: Invalid
argument: write offset=625443181, buflen=262144



Failure 2:

Write followed by verify:
sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
--filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs16384_rwwrite_qd256 --buffer_pattern=1 --iodepth=256
--size=40960 --percentage_random=0 --bs=16384 --rw=write


sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
--filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs16384_rwverify_qd256 --buffer_pattern=1 --iodepth=256
--size=40960 --percentage_random=0 --bs=16384 --rw=read
--verify=pattern --verify_pattern=1

Error in starting FIO: fio: got pattern '00', wanted '01'. Bad bits 1
fio: bad pattern block offset 2048

pattern: verify failed at file /dev/nvme0n1 offset 0, length 16843009
fio: verify type mismatch (257 media, 18 given)
fio: got pattern '00', wanted '01'. Bad bits 1
fio: bad pattern block offset 2048
pattern: verify failed at file /dev/nvme0n1 offset 16384, length 16843009
fio: verify type mismatch (257 media, 18 given)
fio: got pattern '00', wanted '01'. Bad bits 1
fio: bad pattern block offset 2048
pattern: verify failed at file /dev/nvme0n1 offset 32768, length 16843009
fio: verify type mismatch (257 media, 18 given)

Regards,
Gnana
