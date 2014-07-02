Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f65.google.com ([209.85.215.65]:51356 "EHLO
	mail-la0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbaGBTmb (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Jul 2014 15:42:31 -0400
Received: by mail-la0-f65.google.com with SMTP id e16so2354749lan.4
        for <fio@vger.kernel.org>; Wed, 02 Jul 2014 12:42:29 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Jul 2014 15:42:29 -0400
Message-ID: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
Subject: multiple block devices question
From: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hi all,

I am using FIO (2.1.7) to profile block level performance of multiple
RAID devices. (see config file below). The test is done on a capable
16-core server. With a sigle raid device, I am getting roughly
1.4GB/s, with two devices in place, I am still getting around 1.4GB/s,
which is weird. Another in-house developed benchmark tool, running
SINGLE-thread suggested we can almost double. I could get double the
performance through FIO by configuring two jobs, with each job
handling one device only. However, it still puzzles me as to why a
single process FIO can't drive the performance of two devices. Did I
do anything wrong as to the configure file?

Thanks

Alex.


[globals]

rw=write
ioengine=libaio
iodepth=16
direct=1
blocksize=1m
runtime=30

[devices]
filename=/dev/mapper/raid-0
filename=/dev/mapper/raid-1
