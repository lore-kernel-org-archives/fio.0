Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f180.google.com ([209.85.166.180]:36818 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfC1Qz7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Mar 2019 12:55:59 -0400
Received: by mail-it1-f180.google.com with SMTP id h9so7182584itl.1
        for <fio@vger.kernel.org>; Thu, 28 Mar 2019 09:55:59 -0700 (PDT)
MIME-Version: 1.0
From: Shivam Dhir <dhirs1@uci.edu>
Date: Thu, 28 Mar 2019 09:55:47 -0700
Message-ID: <CAKaVHqfGJnRP9mM_o8x+jY3e9Bq2XDieXssMU7J3VH6HTstrzQ@mail.gmail.com>
Subject: FIO Issue #755
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi

Continuing the discussion on FIO issue #755 from the github page

My intention is to simulate a mixed i/o for overlapped reads/writes.
More specifically, I want some reads and write to be overlapped so
that I can test a cache feature of a write i.e. if the write is still
not written to NAND and there is a read issued for that specific data,
I want to cover that edge case in my drive firmware.

For this, I came up with 70-30 ratio for reads and writes respectively
and used the following parameters: (changed from original post, I
mistakenly put the wrong filename in ealier one)

./fio --ioengine=libaio --filename=/dev/nvme0n1 --direct=1 --bs=4K
--rw=randrw --percentage_random=100,0 --rwmixread=70 --iodepth=128
--do_verify=1 --verify=md5 --verify_interval=4096 --runtime=300

My assumption here is that when I issue the above command, fio is
doing some writes on some blocks and reads the same data. So with a
do_verify=1, it should run fine. Is this correct?

In view of the above, I am looking for further clarity on below things.

sitsofe-->"This questions is vague... fio does I/O against specific
points of the file so with your job above if fio chooses to do a read
at offset 0 fio will read whatever the first 32 killobytes of the file
is."

Which file is being referred to here. Is it the same as being written?
If not, then what is it reading if the drive is fully erased.

Also, If the read and write are independent i.e fio is writing
something else and reading something else, what does do_verify=1 will
be verifying then. My current assumption here is that do_verify=1
verifies that read data was same as written data.

sitsofe-->"Not exactly but it is complicated."

Your comment is suggesting that its reading some other blocks
unrelated to where the writes are issued. If that is the case

1. How can I make sure it is reading what I am writing through fio.
2. how the command needs to be modified simulate a overlapped
read/writes as intended above.

Thanks in advance!

