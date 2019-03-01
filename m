Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f47.google.com ([209.85.221.47]:34861 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfCAEVw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Feb 2019 23:21:52 -0500
Received: by mail-wr1-f47.google.com with SMTP id t18so24347923wrx.2
        for <fio@vger.kernel.org>; Thu, 28 Feb 2019 20:21:51 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR04MB395750846A4577AE03C100F1AB760@BYAPR04MB3957.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB395750846A4577AE03C100F1AB760@BYAPR04MB3957.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 1 Mar 2019 04:21:32 +0000
Message-ID: <CALjAwxir74sOo-2drJ5Cu_sHbAZQgbd5x7fv2SXB0ttSQQadVA@mail.gmail.com>
Subject: Re: fio.exe has stopped working
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Fri, 1 Mar 2019 at 02:12, TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com> wrote:
>
> Hi,
>
> I have installed FIO 3.12 on 4 desktop PCs - all running Windows 7 with different processors.
> 2 of them are running FIO without problem, but another 2 has this windows error
>
> "fio.exe has stopped working
> A problem caused the program to stop working correctly.
> Windows will close the program and notify you if a solution is
> Available.
>                                 Close program [button]"
>
>  Has anyone run into this problem before? And if yes, what is the solution?

Where are you grabbing the fio.exe binary from? Was it from
https://bluestop.org/fio/ ?

At a wild guess it could be the binary was built with instructions
some of your PCs don't support due to march=native... Does the binary
from https://ci.appveyor.com/project/axboe/fio/builds/20011071/job/54r8b1d6u8jpcth9/artifacts
work?

-- 
Sitsofe | http://sucs.org/~sits/

