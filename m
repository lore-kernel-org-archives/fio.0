Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:32919 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754450AbeFMF1F (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Jun 2018 01:27:05 -0400
Received: by mail-ot0-f176.google.com with SMTP id h6-v6so1582347otj.0
        for <fio@vger.kernel.org>; Tue, 12 Jun 2018 22:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <SN6PR04MB40649343247761CFB42764468F7F0@SN6PR04MB4064.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB40649343247761CFB42764468F7F0@SN6PR04MB4064.namprd04.prod.outlook.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 13 Jun 2018 14:26:30 +0900
Message-ID: <CAHndrB=vMFT8Si+9VCYVzdt17E3MiN=FF=MHd_0f__+LPr_n3Q@mail.gmail.com>
Subject: Re: fio environment var bug
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: fio <fio@vger.kernel.org>

Jeff Furlong <jeff.furlong@wdc.com>:
>
> Hi All,
> There seems to be a bug while parsing environment variables when using client/server mode.  Consider the following:
>
> # fio -version
> fio-3.7-21-gab56
>
> # fio --server=localhost&
>
> # cat test.job
> [test]
> ioengine=libaio
> direct=1
> rw=randread
> iodepth=${QD}
> size=100%
> bs=4k
> filename=/dev/nvme0n1
> runtime=5s
>
> # QD=1 fio test.job
> fio-3.7-21-gab56
> Starting 1 process
> Jobs: 1 (f=1): [r(1)][100.0%][r=320MiB/s,w=0KiB/s][r=81.9k,w=0 IOPS][eta 00m:00s]
>
> # QD=1 fio --client=localhost test.job
> be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-3.7-21-gab56, flags=1
> fio: failed parsing iodepth=${QD}
> fio: job test dropped
>
> I haven't deciphered where exactly the issue is in parse.c.  Any thoughts?  Thanks.

Do you have QD=1 on server side ?
If not then your server probably failed to parse test.job contents
sent from client after socket is initialized.

>
> Regards,
> Jeff
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
