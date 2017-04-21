Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35562 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035704AbdDUGd6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Apr 2017 02:33:58 -0400
Received: by mail-ua0-f179.google.com with SMTP id f10so73562647uaa.2
        for <fio@vger.kernel.org>; Thu, 20 Apr 2017 23:33:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000201d2ba62$d6900610$83b01230$@citigo.com.vn>
References: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn>
 <CABtFm2W3cL2f96xpHERD-7E-7509Hn6E3F_kVhNBfy=19PbNgw@mail.gmail.com> <000201d2ba62$d6900610$83b01230$@citigo.com.vn>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 21 Apr 2017 07:33:26 +0100
Message-ID: <CALjAwxjOc-hrLqgGatLKftxjK0GfonpHqG6Y_jL+W2pmrYA4dg@mail.gmail.com>
Subject: Re: Does fio really bypass page cache with option direct=1?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Son Chu <son.ct@citigo.com.vn>
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Can you show the exact dd command (options, "of" and all) you used?
Also which filesystem is /opt/ running on and are you sure you're
looking at the page cache just for the file you're writing (e.g. is
something writing/reading elsewhere on the system at the same time if
you're looking at the whole system page cache stats)?

On 21 April 2017 at 06:48, Son Chu <son.ct@citigo.com.vn> wrote:
>
> I still got page cache increasing even when I used those option.
> Here is output without those option:
> fio --filename=/opt/test --size=1G --direct=1 --sync=1 --rw=randrw --bs=4k --numjobs=1 --iodepth=8 --runtime=60 --time_based --group_reporting --name=journal-test --invalidate=1 --gtod_reduce=1 --ioengine=libaio
> HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB
> 337        0        0   100.0%            0         95
>      411        0    89005   100.0%            0        664
>      337        0    38526   100.0%            0        816
>      337        0    26605   100.0%            0        920
>      591        0    19906   100.0%            0        998
>      337        0    12283   100.0%            0       1046
>      457        0    11351   100.0%            0       1090
>      337        0    12398   100.0%            0       1138
>      337        0    13252   100.0%            0       1190
>      337        0    11876   100.0%            0       1237
>      337        0     8723   100.0%            0       1271
>      337        0    12844   100.0%            0       1321
>      337        0     4612   100.0%            0       1340
>      457        0        0   100.0%            0       1340
>      337        0        3   100.0%            0       1340
>      457        0        0   100.0%            0       1340
>      457        0        0   100.0%            0       1340
>      337        0        0   100.0%            0       1340
>      336        1        0    99.7%            0        316
>
> And here is output with those option:
> fio --filename=/opt/test --size=1G --direct=1 --sync=1 --rw=randrw --bs=4k --numjobs=1 --iodepth=8 --runtime=60 --time_based --group_reporting --name=journal-test --invalidate=1 --gtod_reduce=1 --ioengine=libaio --create_on_open=1 --fallocate=none
> HITS MISSES DIRTIES RATIO BUFFERS_MB CACHE_MB
> 337        0        0   100.0%            0         95
>      337        0        0   100.0%            0         95
>      337        0        0   100.0%            0         95
>      410        1        0    99.8%            0        316
>      337        0        9   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        3   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        0   100.0%            0        316
>     1828        0       10   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        0   100.0%            0        316
>      337        0        0   100.0%            0        316
>
> As you can see the page cache still increase from 95 to 316 when using those option.
> I don't understand why the dd command with option oflag=direct gave no page cache increasing while fio increased page cache.

-- 
Sitsofe | http://sucs.org/~sits/
