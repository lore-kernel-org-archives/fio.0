Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f177.google.com ([209.85.167.177]:46546 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387393AbgAXUja (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Jan 2020 15:39:30 -0500
Received: by mail-oi1-f177.google.com with SMTP id 13so754349oij.13
        for <fio@vger.kernel.org>; Fri, 24 Jan 2020 12:39:29 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV6AqY=u=PZ2EAxLwM2a3TL6ByAwTRyURA=9CA1dAtwLbw@mail.gmail.com>
 <MWHPR11MB16790DF710A8EA7EB9118C37A9370@MWHPR11MB1679.namprd11.prod.outlook.com>
 <CANvN+ekCr5CxPe1pcVwc7MQG+MoUPK=YVpfcGT1Hn=4H1JQOqA@mail.gmail.com>
 <CAHEKYV6tMRCyhWnT9D+LaZ_U7j=wRLcMMU4yjBv1Te72FUYBag@mail.gmail.com>
 <CANvN+enS9cZpJrnvL=Z-X-cYHO4eGdfaG9aR5NQQ-KJUTM9Zug@mail.gmail.com>
 <CAHEKYV5L0wz0AKvuc9=zDYN0ug-dQYwTf7aGzE16Yu0S9Hi3Fg@mail.gmail.com>
 <CANvN+emieOE7jBdmTwaB+j-jrpyn4mjnO7+iUDD9bYBQJ18Szw@mail.gmail.com>
 <CAHEKYV4qoGxYQ=NMsidt23c3O4YePrpcYXFimu04wjE4-2LWyg@mail.gmail.com>
 <CAGfUJcGpJ2kx3Q0+nyYD22bsNMgGhe+4SpGbcN_K67Lbs5Gbhg@mail.gmail.com>
 <CANvN+e=w2Rd88CAfeuubYEXLSabCJBU=bTGGfGjnQzNh_Qx11w@mail.gmail.com>
 <CAGfUJcFBW-46v7Fna1E-Fh1CL=LTnv5cpJjO=-Ls+xMFPda3BQ@mail.gmail.com> <CAF+0mvmYdsnWj4dPSjeGzrYRgMBh+XFvQxrYB=TGCEDudRiebA@mail.gmail.com>
In-Reply-To: <CAF+0mvmYdsnWj4dPSjeGzrYRgMBh+XFvQxrYB=TGCEDudRiebA@mail.gmail.com>
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Fri, 24 Jan 2020 15:39:18 -0500
Message-ID: <CAHEKYV4vQ30vSzv7_O4Tzm4S3eFHEA7az91Vrd1dAJXVWuzbMA@mail.gmail.com>
Subject: Re: CPUs, threads, and speed
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

On Fri, Jan 17, 2020 at 5:08 PM Matthew Eaton <m.eaton82@gmail.com> wrote:
>
> On Thu, Jan 16, 2020 at 11:04 AM Jared Walton <jawalking@gmail.com> wrote:
> >
> > Correct, I pre-condition for IOPS testing by utilizing the the last if
> > block, only using randwrite. which will run random writes for about
> > 45min, until a steady state is achieved.
> >
[...]
>
> I have pretty much standardized on two sequential drive writes and
> four random drive writes to get to steady state. It may be overkill
> but has worked well for me since we test a variety of SSDs and some
> reach steady state faster than others.

Thank you for all the replies and to Jared for the script, which leads
me to one related question: even though it used steady state as
criteria to consider drive preconditioned, am I correct to assume that
steady state does not necessarily have any relationship with the
steady state where I want to take the measurements when actually
running the tests?

