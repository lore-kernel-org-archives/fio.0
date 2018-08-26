Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:38216 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbeHZM3C (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Aug 2018 08:29:02 -0400
Received: by mail-vk0-f54.google.com with SMTP id h200-v6so6213095vke.5
        for <fio@vger.kernel.org>; Sun, 26 Aug 2018 01:47:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAFF4W0Xhk_UArnwAMdj_GY_ZRxEtZG+5tE-0yn+5_qdHGQgftg@mail.gmail.com>
In-Reply-To: <CAFF4W0Xhk_UArnwAMdj_GY_ZRxEtZG+5tE-0yn+5_qdHGQgftg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 26 Aug 2018 09:46:47 +0100
Message-ID: <CALjAwxjUqfdtSBu_=_sCQv2RUGEy12LQsZmqXSiU=nKOSAy4TQ@mail.gmail.com>
Subject: Re: Understaning direct option in fio for rw=read and rw=randread.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: bmohanraj91@gmail.com
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 24 Aug 2018 at 11:50, Mohanraj B <bmohanraj91@gmail.com> wrote:
>
> I have few query on fio direct=0/1 option.
>
> fio version: fio-3.8-88-ge971
> linux version: Ubuntu 18.04 4.15.0-29-generic
>
> Below are the job files that I am testing and its output snippet.
>
> Job file1: read_bypass_cache.fio
>
> [read_bypass_cache]
> rw=read
> ioengine=sync
> size=10MB
> filename=read_file
>
> Output snippet of multiple runs:
>            read issued = 2560
> Run1:  sda: ios=8/0, merge=0/0, ticks=820/0, in_queue=1040, util=86.14%
> Run2:  sda: ios=39/0, merge=0/0, ticks=240/0, in_queue=268, util=57.38%
> Run3:  sda: ios=39/0, merge=0/0, ticks=248/0, in_queue=276, util=59.02%
>
> Above job files seems working fine, io hits the cache and not the file
> for read operation.
>
>
> Job file2: randread_bypass_cache.fio
>
> [randread_bypass_cache]
> rw=randread
> ioengine=sync
> size=10MB
> filename=randread_file
>
> Output snippet of multiple runs:
> read issued: 2560
>  sda: ios=2227/0, merge=0/0, ticks=2500/0, in_queue=2500, util=88.97%
>  sda: ios=2148/7, merge=0/3, ticks=1200/76, in_queue=1276, util=80.64%
>  sda: ios=2137/0, merge=0/0, ticks=1196/0, in_queue=1196, util=80.16%
>
> Why when rw=randread and direct=0(by default) is set, io still hitting
> file for read operation instead of cache?
> As 2560-2227= 333 only accessed from cache.

How do you know the file is fully cached already and wasn't just
created before you started this job? Also be aware that by default fio
random reading hits every area equally - just in a random order (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-distribution
)...

> set direct=1 option in below file.
> Job file3: randread_bypass_cache_direct.fio
>
> [randread_bypass_cache]
> rw=randread
> direct=1
> ioengine=sync
> size=10MB
> filename=randread_file_direct
>
> Output snippet of multiple runs:
>   read issued: 2560
>   sda: ios=2343/0, merge=0/0, ticks=3692/0, in_queue=3692, util=92.65%
>   sda: ios=2334/0, merge=0/0, ticks=1896/0, in_queue=1896, util=84.57%
>   sda: ios=2365/0, merge=0/0, ticks=1940/0, in_queue=1940, util=86.57%
>
> Actually there is not much difference in sda ios when direct =0 and
> direct=1 is set rw=randread.
> Is it how io randread suppose to work?

See above and there's also information and techniques that may be
helpful in https://www.spinics.net/lists/fio/msg05772.html .
--
Sitsofe | http://sucs.org/~sits/

