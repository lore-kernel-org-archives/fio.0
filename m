Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:35486 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbcIORBw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Sep 2016 13:01:52 -0400
Received: by mail-yb0-f173.google.com with SMTP id d69so37456012ybf.2
        for <fio@vger.kernel.org>; Thu, 15 Sep 2016 10:01:51 -0700 (PDT)
MIME-Version: 1.0
From: Ryan Stiles <rstiles.org@gmail.com>
Date: Thu, 15 Sep 2016 10:01:50 -0700
Message-ID: <CACDTvf5PhEZ55+CYQV6JpBAr7=KDQQSiWySA=EZWJiE0f42KSQ@mail.gmail.com>
Subject: bssplit functionality seems broken in 2.13
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Good day,

We have automation that uses the "bssplit" function to get a wide
variety of IO patterns, I have noticed that in 2.13 (compiled with
no-shared-mem).  The bsssplit only takes the first variable, meaning:

bssplit=1k/50:128k/50

will yield a 100% 1k workload.

This is the workload:
[global]
random_generator=tausworthe64
direct=1
loops=1
ioengine=libaio
iodepth=16
group_reporting
filename=/dev/disk/by-uuid/27602b49-4a18-4dca-a896-e2fc86746015

[workload]
rw=randread
bssplit=1k/50:128k/50

I tried to work around this using block range but when using a large
number of targets, ~150, the memory consumption is around 150GB.

Thank you for your help!
Ryan
