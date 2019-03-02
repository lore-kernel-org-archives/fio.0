Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38225 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfCBIly (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Mar 2019 03:41:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id g12so261288wrm.5
        for <fio@vger.kernel.org>; Sat, 02 Mar 2019 00:41:53 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR04MB395750846A4577AE03C100F1AB760@BYAPR04MB3957.namprd04.prod.outlook.com>
 <CALjAwxir74sOo-2drJ5Cu_sHbAZQgbd5x7fv2SXB0ttSQQadVA@mail.gmail.com> <BYAPR04MB39573C849C7FDFB05866D4A7AB760@BYAPR04MB3957.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB39573C849C7FDFB05866D4A7AB760@BYAPR04MB3957.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 2 Mar 2019 08:41:37 +0000
Message-ID: <CALjAwxhQOo4_LaD996KEhRO1ZwHNqv1_MJU_3SnF5AHBcmKv8g@mail.gmail.com>
Subject: Re: fio.exe has stopped working
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello Rebecca,

It sounds like an over specialized version of your Windows fio
binaries is being built. Could you check you're compiling them with
--disable-native or that Build march=native somehow reports no?

On Fri, 1 Mar 2019 at 07:42, TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com> wrote:
>
> Hi Sitsofe,
>
> Yes the original FIO ver 3.12 was downloaded from bluestop.
> I uninstalled that version and reinstall with the link that you provided and problem resolved.
>
> Thanks for your help!
>
> TK
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Sitsofe Wheeler
> Sent: Thursday, February 28, 2019 8:22 PM
> To: TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com>
> Cc: fio@vger.kernel.org
> Subject: Re: fio.exe has stopped working
>
> Hi,
>
> On Fri, 1 Mar 2019 at 02:12, TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com> wrote:
> >
> > Hi,
> >
> > I have installed FIO 3.12 on 4 desktop PCs - all running Windows 7 with different processors.
> > 2 of them are running FIO without problem, but another 2 has this
> > windows error
> >
> > "fio.exe has stopped working
> > A problem caused the program to stop working correctly.
> > Windows will close the program and notify you if a solution is
> > Available.
> >                                 Close program [button]"
> >
> >  Has anyone run into this problem before? And if yes, what is the solution?
>
> Where are you grabbing the fio.exe binary from? Was it from https://bluestop.org/fio/ ?
>
> At a wild guess it could be the binary was built with instructions some of your PCs don't support due to march=native... Does the binary from https://ci.appveyor.com/project/axboe/fio/builds/20011071/job/54r8b1d6u8jpcth9/artifacts
> work?

-- 
Sitsofe | http://sucs.org/~sits/

