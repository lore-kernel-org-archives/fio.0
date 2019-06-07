Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f41.google.com ([209.85.217.41]:43966 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729715AbfFGTtz (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Jun 2019 15:49:55 -0400
Received: by mail-vs1-f41.google.com with SMTP id d128so1846641vsc.10
        for <fio@vger.kernel.org>; Fri, 07 Jun 2019 12:49:55 -0700 (PDT)
MIME-Version: 1.0
From: Kurt Dorsey <batlin@gmail.com>
Date: Fri, 7 Jun 2019 14:49:42 -0500
Message-ID: <CAJzzwJziVYzTV4wjmA6CzGO-NcmXxMFvzYr3-b9juHmY2R-oMw@mail.gmail.com>
Subject: Round Robin IO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am trying to do multi device round robin, I have been utilizing
--filename=dev1:dev2 and it works great for Randoms but it doesn't
work correctly for sequential (This is for multi path devices)
Looking at the debug output and a blktrace for sequential it looks
like it is sending the same offset to both devices
Is there a way to issue Sequential IO where it increments the LBA for each IO?
File1  LBA 0-4
File2 LBA  4-8
File1 LBA 8-12
File2 LBA 12-16
If this is not implemented would it be possible to implement this?

Thank you!
Kurt
(Below is debug output)
file     10720 get file /dev/nvme1n1, ref=1
io       10720 fill: io_u 0x55620e76b380:
off=0x0,len=0x20000,ddir=1,file=/dev/nvme1n1
io       10720 prep: io_u 0x55620e76b380:
off=0x0,len=0x20000,ddir=1,file=/dev/nvme1n1
io       10720 prep: io_u 0x55620e76b380: ret=0
io       10720 queue: io_u 0x55620e76b380:
off=0x0,len=0x20000,ddir=1,file=/dev/nvme1n1
io       10720 calling ->commit(), depth 1
file     10720 trying file /dev/nvme3n1 10
file     10720 fd open /dev/nvme3n1
file     10720 file not found in hash /dev/nvme3n1
file     10720 get file /dev/nvme3n1, ref=0
io       10720 drop page cache /dev/nvme3n1
file     10720 goodf=1, badf=2, ff=31
file     10720 get_next_file_rr: 0x7f80f9fb06f0
file     10720 get_next_file: 0x7f80f9fb06f0 [/dev/nvme3n1]
file     10720 get file /dev/nvme3n1, ref=1
io       10720 fill: io_u 0x55620e76b140:
off=0x0,len=0x20000,ddir=1,file=/dev/nvme3n1
io       10720 prep: io_u 0x55620e76b140:
off=0x0,len=0x20000,ddir=1,file=/dev/nvme3n1
io       10720 prep: io_u 0x55620e76b140: ret=0
io       10720 queue: io_u 0x55620e76b140:
off=0x0,len=0x20000,ddir=1,file=/dev/nvme3n1
io       10720 calling ->commit(), depth 2
file     10720 trying file /dev/nvme1n1 31
file     10720 goodf=1, badf=2, ff=31
file     10720 get_next_file_rr: 0x7f80f9fb0510
file     10720 get_next_file: 0x7f80f9fb0510 [/dev/nvme1n1]
file     10720 get file /dev/nvme1n1, ref=2
io       10720 fill: io_u 0x55620e76af40:
off=0x20000,len=0x20000,ddir=1,file=/dev/nvme1n1
io       10720 prep: io_u 0x55620e76af40:
off=0x20000,len=0x20000,ddir=1,file=/dev/nvme1n1
io       10720 prep: io_u 0x55620e76af40: ret=0
io       10720 queue: io_u 0x55620e76af40:
off=0x20000,len=0x20000,ddir=1,file=/dev/nvme1n1
io       10720 calling ->commit(), depth 3
file     10720 trying file /dev/nvme3n1 31
file     10720 goodf=1, badf=2, ff=31
file     10720 get_next_file_rr: 0x7f80f9fb06f0
file     10720 get_next_file: 0x7f80f9fb06f0 [/dev/nvme3n1]
file     10720 get file /dev/nvme3n1, ref=2
io       10720 fill: io_u 0x55620e76ad00:
off=0x20000,len=0x20000,ddir=1,file=/dev/nvme3n1
io       10720 prep: io_u 0x55620e76ad00:
off=0x20000,len=0x20000,ddir=1,file=/dev/nvme3n1
io       10720 prep: io_u 0x55620e76ad00: ret=0
io       10720 queue: io_u 0x55620e76ad00:
off=0x20000,len=0x20000,ddir=1,file=/dev/nvme3n1
io       10720 calling ->commit(), depth 4
file     10720 trying file /dev/nvme1n1 31

