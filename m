Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:37019 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754245AbeFQGtb (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 17 Jun 2018 02:49:31 -0400
Received: by mail-vk0-f47.google.com with SMTP id w8-v6so7841574vkh.4
        for <fio@vger.kernel.org>; Sat, 16 Jun 2018 23:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD9xLVT+peBDZ9Sanp3pJ6+wue0C5phNPAZLjQVd1rGa9SLyMA@mail.gmail.com>
References: <CAD9xLVT+peBDZ9Sanp3pJ6+wue0C5phNPAZLjQVd1rGa9SLyMA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 17 Jun 2018 07:49:00 +0100
Message-ID: <CALjAwxgeO-o-hrF9+Gyre9T6eS+G7-o4EcNoWtuDHb_3-5spXQ@mail.gmail.com>
Subject: Re: Query regarding [bsrange upper limit]
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: shashank chaurasia <shashankch9009@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 17 June 2018 at 01:57, shashank chaurasia <shashankch9009@gmail.com> wrote:
> what is the bsrange upper limit that can be handled by fio properly?
>
> I sometimes see "invalid argument error" when I use
> bsrange=1k-32M

This is going to be down to the environment you're running (I shall
assume Linux for the rest of this email), the hardware you are using,
the ioengine you choose and the options you passed. If you are using
direct I/O (I can't tell because you didn't include the whole job
file/command line you using) then you cannot use a block size smaller
than the device's minimum sector size (for some devices that may be
4kbytes). Additionally there's a maximum transfer size of the "disk"
(/sys/block/<disk>/queue/max_sectors_kb) and there's the maximum size
the kernel will use (/sys/block/sda/queue/max_sectors_kb ). Further,
if you are choosing to transfer giant size blocks what's happening is
you typically forcing the kernel to split the block up into little
pieces for you (ideally the optimal_io_size which is generally much
smaller than the maximum). If you aren't able to submit I/O
asynchronously this can be a benefit (because you then get depth
parallelism) but if you can, sending such large I/Os just pushing
overhead into the kernel.

Another problem area can be down to unrealistically high option values
when everything is running together. For example, if you choose a high
iodepth, direct I/O, an asynchronous I/O engine, giant blocks and tons
of jobs your kernel may simply not have the resources to keep that
number of resultant hardware I/Os in flight.

-- 
Sitsofe | http://sucs.org/~sits/
