Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ed1-f49.google.com ([209.85.208.49]:34964 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgDJSz7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Apr 2020 14:55:59 -0400
Received: by mail-ed1-f49.google.com with SMTP id c7so3542782edl.2
        for <fio@vger.kernel.org>; Fri, 10 Apr 2020 11:55:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAD7DgVVmfHVZg6s8H9sDyMGrg-fx5KBhbE8v73hV=Gn=MG1e7A@mail.gmail.com>
 <CALjAwxg=8JiyQbrSPkpyqcsxShnqwPAU665cNPM3ugayYmJP7A@mail.gmail.com>
In-Reply-To: <CALjAwxg=8JiyQbrSPkpyqcsxShnqwPAU665cNPM3ugayYmJP7A@mail.gmail.com>
From: Shridhar Sahukar <shridhar.sahukar2@gmail.com>
Date: Fri, 10 Apr 2020 11:55:44 -0700
Message-ID: <CAD7DgVVDNJ7JM86qTU3Y__FsAtg6tDVLuuQ+b7GOz9x6-1FsYQ@mail.gmail.com>
Subject: Re: what is the unit for usr_cpu and sys_cpu in fio3.16? Inbox x
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

Thanks for the quick response.

In the trial run where I got values "sys_cpu": 1.560156 and "usr_cpu":
0.420997, the total run time was 10mins, so does it mean that fio used
about ~2% CPU (or 12 seconds) - user and system combined?

Is it 2% of one single Core? Or 2% of all the CPU available?

Regards,
Shridhar


On Fri, 10 Apr 2020 at 00:27, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Fri, 10 Apr 2020 at 04:34, Shridhar Sahukar
> <shridhar.sahukar2@gmail.com> wrote:
> >
> > Hello,
> >
> > I have a bunch of benchmark results from fio-3.16 in json format and I
> > am unable to find the units for sys_cpu and usr_cpu fields.
> >
> > For example, the output shows
> >
> > "sys_cpu": 1.560156
> > "usr_cpu": 0.420997
> >
> > Is this in seconds?
>
> No it should be a percentage (of the total run time). From
> https://github.com/axboe/fio/blob/839f607b5771081e96942977a1ff9f1b24b77bca/stat.c#L1089
> :
>
> usr_cpu = (double) ts->usr_time * 100 / runt;
>
> --
> Sitsofe | http://sucs.org/~sits/

