Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f66.google.com ([209.85.222.66]:40236 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbeJ3FCy (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Oct 2018 01:02:54 -0400
Received: by mail-ua1-f66.google.com with SMTP id n7so1404752uao.7
        for <fio@vger.kernel.org>; Mon, 29 Oct 2018 13:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR04MB032025E64451635D09E474C08FF30@MWHPR04MB0320.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB032025E64451635D09E474C08FF30@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 29 Oct 2018 20:12:16 +0000
Message-ID: <CALjAwxiuF2hn99MTGGB-AZp=wbQeud2TOtTUx=PeetyETqECgA@mail.gmail.com>
Subject: Re: fio win affinity broken
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: fio <fio@vger.kernel.org>

Hi Jeff,

On Mon, 29 Oct 2018 at 20:04, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> Hi All,
> Back in http://git.kernel.dk/cgit/fio/commit/?id=c479640d6208236744f0562b1e79535eec290e2b several updates were made for Windows CPU affinity.  However, using the cpus_allowed since fio 3.6 and latest git appears to throw error messages.  Consider a job:
>
> fio --name=test --ioengine=windowsaio --direct=1 --rw=write --overwrite=1 --filename=\\.\PHYSICALDRIVE1 --runtime=1s --thread --cpus_allowed=0-1 --cpus_allowed_policy=shared
>
> fio_setaffinity: failed to set thread affinity (pid 2768, group 0, mask 10000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (pid 2372, group 0, mask 20000, GetLastError=87)
> clock setaffinity failed: No error
>
> It seems err 87 is ERROR_INVALID_PARAMETER, but any idea why "GROUP_AFFINITY struct's Reserved members are not initialised to 0?"  Might it be related to Windows version?  Seems to fail on 2012 and 2016.  Thanks.

Which version of fio are you compiling with, which cpus do you have
and what is the output when you use --debug=process in fio line?

-- 
Sitsofe | http://sucs.org/~sits/

