Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36020 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbcGAAFs (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 Jun 2016 20:05:48 -0400
Received: by mail-vk0-f47.google.com with SMTP id m127so73115466vkb.3
        for <fio@vger.kernel.org>; Thu, 30 Jun 2016 17:05:47 -0700 (PDT)
MIME-Version: 1.0
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Thu, 30 Jun 2016 17:05:46 -0700
Message-ID: <CAF+0mvny52U+Z9LWaHyuEVZjem8q8X11bF6fp-qepa4Y6W8pcQ@mail.gmail.com>
Subject: Iosched_switch error
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

I have run into this error when using ioscheduler=noop in my job
files. I only run into the error when specifying unsupported devices
such as nvme or md raid device. Should this be a fatal error? I ask
because sometimes I want to run the same job on various devices.

sudo fname=/dev/nvme0n1 ./fio seqread.ini
seq-read: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K,
ioengine=libaio, iodepth=32
fio-2.12-3-g8a09
Starting 1 process
fio: io scheduler noop not found
fio: pid=5541, err=22/file:backend.c:1306, func=iosched_switch,
error=Invalid argument


Run status group 0 (all jobs):

Disk stats (read/write):
  nvme0n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
