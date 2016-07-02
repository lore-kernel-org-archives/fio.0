Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:34272 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbcGBRGv (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 2 Jul 2016 13:06:51 -0400
Received: by mail-vk0-f47.google.com with SMTP id c2so188985333vkg.1
        for <fio@vger.kernel.org>; Sat, 02 Jul 2016 10:06:51 -0700 (PDT)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 2 Jul 2016 18:06:50 +0100
Message-ID: <CALjAwxi9Md5yshyO=sKjM2egMoEkhnMJGVm-2=oU-rtd9=sdMw@mail.gmail.com>
Subject: Forcing bsrange to be reset between jobs when using randseed?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

When running the following job the second job (read) always fails with an error:

./fio --size=10M --verify=crc32c-intel --randseed=1 --randrepeat=1
--iodepth=1 --filename /dev/shm/fio --ioengine=libaio
--bsrange=16k-128k --stonewall=1 --name=write --rw=randwrite
--name=read --rw=randread

Running the either of the following after the above also fails on the
second group:
./fio --size=10M --verify=crc32c-intel --randseed=1 --randrepeat=1
--iodepth=1 --filename /dev/shm/fio --ioengine=libaio
--bsrange=16k-128k --stonewall=1 --name=read1 --rw=randread
--name=read2 --rw=randread

./fio --size=10M --verify=crc32c-intel --randseed=1 --randrepeat=1
--iodepth=1 --filename /dev/shm/fio --ioengine=libaio
--bsrange=16k-128k --stonewall=1 --name=read --rw=randread --numjobs=2

Is something more required to force random seeding of bsrange to be
reset predictably between jobs?

-- 
Sitsofe | http://sucs.org/~sits/
