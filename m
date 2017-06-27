Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:36498 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752516AbdF0Ixe (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Jun 2017 04:53:34 -0400
Received: by mail-yb0-f177.google.com with SMTP id s9so7365366ybe.3
        for <fio@vger.kernel.org>; Tue, 27 Jun 2017 01:53:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALKvLUkmy93Tcoe58V5Sufb-Dmv=WhSns9TTzBZekDinoGtyGQ@mail.gmail.com>
References: <CALKvLUk55=ZHf61_QSewXsUKgyv62wYqHmKXiUdD1DXg=otMOA@mail.gmail.com>
 <CAHndrBm=ytrMYEyrgTH8qWF+JFZ4edPdCdE=xprtb7E-O8Gq8Q@mail.gmail.com> <CALKvLUkmy93Tcoe58V5Sufb-Dmv=WhSns9TTzBZekDinoGtyGQ@mail.gmail.com>
From: Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>
Date: Tue, 27 Jun 2017 11:53:32 +0300
Message-ID: <CALKvLUkui5FbZfdKdv+R-dPHYjLrd9un7RdRa4W7uQJ-JPK-Ww@mail.gmail.com>
Subject: Fwd: in what units is offset option?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org

Thank you! Can you please add the explanation about percentage and
also about offset units in bytes to HOWTO? It is absent.

On Tue, Jun 27, 2017 at 11:28 AM, Tomohiro Kusumi
<kusumi.tomohiro@gmail.com> wrote:
>
> bytes or percentage.
>
> (I think it needs explanation on how to specify in percentage unless
> already mentioned in howto)
>
> 2017-06-27 10:25 GMT+03:00 Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>:
> > Hi,
> >
> >
> >
> > To be sure: in what units is the offset option -  In bytes, in block
> > sizes or in units of block size?
> >
> >
> >
> > Thank you
> >
> > Konstantin
> > --
> > To unsubscribe from this list: send the line "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
