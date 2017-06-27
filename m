Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36036 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdF0I3D (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Jun 2017 04:29:03 -0400
Received: by mail-oi0-f49.google.com with SMTP id p187so13628965oif.3
        for <fio@vger.kernel.org>; Tue, 27 Jun 2017 01:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALKvLUk55=ZHf61_QSewXsUKgyv62wYqHmKXiUdD1DXg=otMOA@mail.gmail.com>
References: <CALKvLUk55=ZHf61_QSewXsUKgyv62wYqHmKXiUdD1DXg=otMOA@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 27 Jun 2017 11:28:22 +0300
Message-ID: <CAHndrBm=ytrMYEyrgTH8qWF+JFZ4edPdCdE=xprtb7E-O8Gq8Q@mail.gmail.com>
Subject: Re: in what units is offset option?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>
Cc: fio@vger.kernel.org

bytes or percentage.

(I think it needs explanation on how to specify in percentage unless
already mentioned in howto)

2017-06-27 10:25 GMT+03:00 Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>:
> Hi,
>
>
>
> To be sure: in what units is the offset option -  In bytes, in block
> sizes or in units of block size?
>
>
>
> Thank you
>
> Konstantin
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
