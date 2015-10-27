Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:35507 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbbJ0Fde convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 27 Oct 2015 01:33:34 -0400
Received: by vkfw189 with SMTP id w189so113307249vkf.2
        for <fio@vger.kernel.org>; Mon, 26 Oct 2015 22:33:33 -0700 (PDT)
MIME-Version: 1.0
From: Hyukjoong Kim <wangmir@gmail.com>
Date: Tue, 27 Oct 2015 14:33:14 +0900
Message-ID: <CAAkw5-PAt2O01H-i4WrvPaBPuMX7zPDyg8u9jS3KyA4PrNu=2A@mail.gmail.com>
Subject: Problem on using fio replay function with fio iolog trace
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to replay iolog using fio iolog, but i failed with that.

simply, I check the example trace with write_iolog option, and I got
trace like this,
--------------
fio version 2 iolog
/mnt/test/rand-write.1.0 add
/mnt/test/rand-write.1.0 open
/mnt/test/rand-write.1.0 read 64757760 4096
/mnt/test/rand-write.1.0 read 794873856 4096
/mnt/test/rand-write.1.0 read 905355264 4096
/mnt/test/rand-write.1.0 write 504672256 4096
-------------
So, I make a new trace with similar format like this
-------------
fio version 2 iolog
/dev/sdb open
/dev/sdb write 4096 4096
------------
However, I failed to replay both with different error.

Firstly, I ran extracted file (fio --name test --read_iolog=trace
--replay_redirect=/dev/sdb), but error was like this,
--------------------------------------------
test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.0.10
Starting 1 process
bad iolog2: fio version 2 iolog
fio: pid=14839, got signal=11


Run status group 0 (all jobs):
--------------------------------------------

and if I delete the first line than, fio said don't support iolog 1


Secondly, I ran the file I made with same command, and error was
different from former,

----------------------------------------
test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.0.10
Starting 1 process
fio: pid=12868, got signal=11


Run status group 0 (all jobs):
--------------------------------------------------

I think fio was killed by someone, but I don't know why.

So,, how can I fix this problem? I tried this behavior with apt
repository fio, and current git, and fio 2.0.10 also, but error was
same.

Thnks,
-Hyukjoong



김 혁 중
성균관대학교 IT 융합학과 박사과정
임베디드 소프트웨어 연구실

Kim, Hyukjoong
Sungkyunkwan University
Ph.D Course in Computer Engineering, IT Convergence
Embedded Software Lab.
e-mail : wangmir@skku.edu / wangmir@gmail.com
phone : +82 10-9489-8974
