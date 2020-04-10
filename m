Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f42.google.com ([209.85.221.42]:37438 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgDJH1g (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Apr 2020 03:27:36 -0400
Received: by mail-wr1-f42.google.com with SMTP id w10so1336111wrm.4
        for <fio@vger.kernel.org>; Fri, 10 Apr 2020 00:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAD7DgVVmfHVZg6s8H9sDyMGrg-fx5KBhbE8v73hV=Gn=MG1e7A@mail.gmail.com>
In-Reply-To: <CAD7DgVVmfHVZg6s8H9sDyMGrg-fx5KBhbE8v73hV=Gn=MG1e7A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 10 Apr 2020 08:27:08 +0100
Message-ID: <CALjAwxg=8JiyQbrSPkpyqcsxShnqwPAU665cNPM3ugayYmJP7A@mail.gmail.com>
Subject: Re: what is the unit for usr_cpu and sys_cpu in fio3.16? Inbox x
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shridhar Sahukar <shridhar.sahukar2@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 10 Apr 2020 at 04:34, Shridhar Sahukar
<shridhar.sahukar2@gmail.com> wrote:
>
> Hello,
>
> I have a bunch of benchmark results from fio-3.16 in json format and I
> am unable to find the units for sys_cpu and usr_cpu fields.
>
> For example, the output shows
>
> "sys_cpu": 1.560156
> "usr_cpu": 0.420997
>
> Is this in seconds?

No it should be a percentage (of the total run time). From
https://github.com/axboe/fio/blob/839f607b5771081e96942977a1ff9f1b24b77bca/stat.c#L1089
:

usr_cpu = (double) ts->usr_time * 100 / runt;

-- 
Sitsofe | http://sucs.org/~sits/

