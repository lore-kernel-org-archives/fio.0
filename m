Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35573 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbdFGGTS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2017 02:19:18 -0400
Received: by mail-ua0-f179.google.com with SMTP id q15so1613267uaa.2
        for <fio@vger.kernel.org>; Tue, 06 Jun 2017 23:19:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457EFC8350E7DAB393315B28FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457EFC8350E7DAB393315B28FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Jun 2017 07:18:46 +0100
Message-ID: <CALjAwxjKwFty9C42YcBkb7NStRMZrKRPKda5_gFejd358mCi_g@mail.gmail.com>
Subject: Re: fio server errors
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 6 June 2017 at 18:39, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> When using the client/server mode, I'm having two issues.  First, I seemingly randomly get an inflate error, which happens after several hours, and reproducing it is challenging:
>
> fio: inflate error -5
> fio: failed decompressing log
> fio: failed converting IO log
>
> I have --write_iops_log turned on so guessing the IO log transferred across the network is not working smoothly.  I don't have a reliable job file that reproduces the issue, unfortunately.

Hmm -5 is going to be Z_BUF_ERROR so the suggestion is we didn't have
enough space to store the decompressed data. Do you get this problem
with older versions (e.g. 2.19) of fio too? You'll probably need to
add debugging to trace nr_samples and where possible total (e.g.
around https://github.com/axboe/fio/blob/master/client.c#L1467 and
https://github.com/axboe/fio/blob/9af5a2450a555a725dd18e6845967cd7cf3aad64/server.c#L1927
).

> Second, I also get (less randomly) a timeout on SEND_ETA.  Here are the details:
>
> # fio -version
> fio-2.20-39-gc12d
>
> # fio --client=server1 test.job --client=server2 test.job
> client <server2>: timeout on SEND_ETA
> client <server1>: timeout on SEND_ETA
> fio: client: unable to find matching tag (76f680)
>
> # cat test.job
> [test_job]
> ioengine=libaio
> direct=1
> rw=randread
> norandommap
> randrepeat=0
> iodepth=256
> size=100%
> numjobs=1
> bs=4k
> filename=/dev/nvme0n1
> group_reporting
> write_lat_log=test_job
> runtime=3m

Again can you reproduce this one with the previous fio release? Other
things that would help is if you cut the job down to the fewest lines
that still allow the problem to reproduce and reduce values (such as
iodepth, runtime and size) as far as possible that again still allow
the problem to occur (e.g. if size=4G still makes it happen that's
useful to know). If it happens relatively quickly you may be able to
use --debug=all to narrow down the last thing the client did but be
aware this generates a lot of output...

-- 
Sitsofe | http://sucs.org/~sits/
