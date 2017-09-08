Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34763 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdIHErC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Sep 2017 00:47:02 -0400
Received: by mail-ua0-f169.google.com with SMTP id s15so2575194uag.1
        for <fio@vger.kernel.org>; Thu, 07 Sep 2017 21:47:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADAGN7X+kH82jxchxxZmim05rd7FcLS35uU2Kzf=5WaqdY5zyw@mail.gmail.com>
References: <CADAGN7X+kH82jxchxxZmim05rd7FcLS35uU2Kzf=5WaqdY5zyw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 8 Sep 2017 05:46:31 +0100
Message-ID: <CALjAwxh_yt=D0ctXnp85hZsRFTiYZeM3Xeq5=xzPwDSByAP4PQ@mail.gmail.com>
Subject: Re: 'No I/O performed by libaio' error
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brandon Schwartz <schwartz.xn@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 8 September 2017 at 01:13, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
> Hi,
>
> Running the following job file with --io_submit_mode=offload set will
> occasionally give a 'No I/O performed by libaio' error
>
> Using the latest FIO version (fio-3.0-48-g83a9)
>
> [128k-RR-64k-RW-q1]
> filename=/dev/sdb
> direct=1
> iodepth=1
> rw=randrw
> bs=128k,64k
> rwmixread=50
> ioengine=libaio
> io_submit_mode=offload
> runtime=15m
>
> After a few minutes of running FIO will exit with the following
> message:  "No I/O performed by libaio, perhaps try --debug=io option
> for details"
>
> With debug set, I see this near the end of the trace:
>
> io       7720  io complete: io_u 0x55e10ee4abc0:
> off=1304219746304/len=65536/ddir=1io       7720  //dev/sdbio
> 7720
> io       7720  fill_io_u: io_u 0x55e10ee4abc0:
> off=233107357696/len=0/ddir=0io       7720  //dev/sdbio       7720

That's weird - fio tried to submit a zero length read. How big was your device?

-- 
Sitsofe | http://sucs.org/~sits/
