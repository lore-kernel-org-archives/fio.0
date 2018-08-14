Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f51.google.com ([209.85.221.51]:44560 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbeHNXnN (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Aug 2018 19:43:13 -0400
Received: by mail-wr1-f51.google.com with SMTP id r16-v6so18306414wrt.11
        for <fio@vger.kernel.org>; Tue, 14 Aug 2018 13:54:15 -0700 (PDT)
MIME-Version: 1.0
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Tue, 14 Aug 2018 14:54:14 -0600
Message-ID: <CAPSTwmT79gq_WY89XpQ-VPNYi27sSDokZFxBmOrUhLCGRzCXww@mail.gmail.com>
Subject: FIO Question with random I/O
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi,

I am experiencing data miscompare during verify with FIO after random write

Also the time for the random I/O operation is lesser than what it
takes for sequential I/O operation for the same 5%. So wanted to
ensure
1. If I am missing the essential parameters to be passed to FIO
2. If any parameters passed are not essential

Parameters for Write:
sudo fio --thread --minimal --ioengine=libaio --numjobs=1
--exitall_on_error --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs65536_rwrandwrite_qd3 --buffer_pattern=64206 --iodepth=3
--write_bw_log=/tmp/nvme0n1_bandwidth.log --log_avg_msec=1000
--max_latency=30s --continue_on_error=none --size=5%
--percentage_random=50 --bs=65536 --randseed=1234 --rw=randwrite


Parameters for Verify:
sudo fio --thread --minimal --ioengine=libaio --numjobs=1
--exitall_on_error --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs65536_rwrandverify_qd3 --buffer_pattern=64206 --iodepth=3
--write_bw_log=/tmp/nvme0n1_bandwidth.log --log_avg_msec=1000
--max_latency=30s --continue_on_error=none --size=5%
--percentage_random=50 --bs=65536 --randseed=1234 --rw=randread
--verify=pattern --verify_pattern=64206

The message from fio looks as below
fio: got pattern '00', wanted 'ce'. Bad bits 5
fio: bad pattern block offset 0
pattern: verify failed at file /dev/nvme0n1 offset 86291775488, length 0
fio: verify type mismatch (0 media, 18 given)
fio: got pattern '00', wanted 'ce'. Bad bits 5
fio: bad pattern block offset 0
pattern: verify failed at file /dev/nvme0n1 offset 86291906560, length 0
fio: verify type mismatch (0 media, 18 given)


Regards,
Gnana

