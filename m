Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f51.google.com ([209.85.222.51]:36266 "EHLO
        mail-ua1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbeHKNSr (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 11 Aug 2018 09:18:47 -0400
Received: by mail-ua1-f51.google.com with SMTP id c12-v6so4543509uan.3
        for <fio@vger.kernel.org>; Sat, 11 Aug 2018 03:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <299b1737.698d.165281df382.Coremail.msn18@mails.tsinghua.edu.cn>
In-Reply-To: <299b1737.698d.165281df382.Coremail.msn18@mails.tsinghua.edu.cn>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 11 Aug 2018 11:44:31 +0100
Message-ID: <CALjAwxh_8HXVjRFB-f4p73b_dm9cUB1FEkqGStrYXE88qMi-2A@mail.gmail.com>
Subject: Re: How to use fio to test performance of a large amount of small files?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: msn18@mails.tsinghua.edu.cn
Cc: fio <fio@vger.kernel.org>

Hi,

On Sat, 11 Aug 2018 at 09:44, Shaonan Ma <msn18@mails.tsinghua.edu.cn> wrote:
>
> I am using fio to test performance of a large amount of small files. I use rbd of ceph and map the image to a device, mount the device and write a lot of small files.
>
> I want to know whether fio can test performance of small files well.
>
> I use the engine libaio, my config is:
>
> [global]
> ioengine=libaio
> buffered=0
> rw=randwrite
> bs=4k
> size=1G
> io_size=1G
> iodepth=256
> filesize=4k
> nrfiles=256000
> [job1]
> directory=rbdmap/rbdmap0

You have one process/fio job that will randomly write to the first
file, then choose the next file and randomly write to that and so on.
As your block size matches your file size I'd imagine each file will
see one I/O until 1GBytes worth of I/O has been done in total
(regardless of file). Is that what you intended?

> I don't know whether my config is correct. Because I increase the filesize from 4k to 256k, and modify size and io_size. The result of bandwidth and iops is as following:
>

^^^ I don't see any results - are you sure you included them inline?
What did you increase size and io_size to?

> I don't know whether the performance is correct, or fio is not suitable for a lot of small files.

This is going to be dependent on your system set u so we're unlikely
to know if the number look "right". The ceph folks
(http://lists.ceph.com/listinfo.cgi/ceph-community-ceph.com ) might
know though...

-- 
Sitsofe | http://sucs.org/~sits/

