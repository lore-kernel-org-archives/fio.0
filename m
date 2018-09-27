Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ed1-f44.google.com ([209.85.208.44]:33904 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbeI0XU5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Sep 2018 19:20:57 -0400
Received: by mail-ed1-f44.google.com with SMTP id q19-v6so5730386edr.1
        for <fio@vger.kernel.org>; Thu, 27 Sep 2018 10:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <000001d455b9$6e4e6850$4aeb38f0$@integritech.solutions>
 <CALjAwxiUCAsmXC7xx4QLS+zfz0k6erdbgd89nYbJNp9KtfhruA@mail.gmail.com> <000901d45681$27887050$769950f0$@integritech.solutions>
In-Reply-To: <000901d45681$27887050$769950f0$@integritech.solutions>
From: Samuel Shapiro <samuel.sh79@gmail.com>
Date: Thu, 27 Sep 2018 20:01:32 +0300
Message-ID: <CANt18PyMhcy7=1Y3hnyT9q+JPLepw44q+o18UjxeKUQ_Gmn7xA@mail.gmail.com>
Subject: Re: Resending: fio testing on S3 object storage
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: eliezer@integritech.solutions
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org

Well, I'm just investigating this engine myself as well, but you can
start playing with that workload and modify it accordingly:
https://github.com/axboe/fio/blob/master/examples/http-s3.fio

On Thu, Sep 27, 2018 at 7:43 PM <eliezer@integritech.solutions> wrote:
>
> Thank you Sitsofe and Samuel for the response.
>
> Per your suggestion, I installed the following packages on my RH 7.5:
>
> openssl
> openssl-devel
> curl-devel
>
> Then I downloaded the latest fio source and compiled it.
>
> Now, I'm seeing the "http" engine listed:
>
> # fio --enghelp
> Available IO engines:
>         cpuio
>         mmap
>         sync
>         psync
>         vsync
>         pvsync
>         pvsync2
>         null
>         net
>         netsplice
>         ftruncate
>         filecreate
>         posixaio
>         falloc
>         e4defrag
>         splice
> >>    http  <<
>         mtd
>         sg
>
>
> Many thanks!
>
> Do you have some examples of fio benchmark params for object storage that=
 you could share?
>
>
> Regards,
> Eliezer
>
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf Of Sitsofe Wheeler
> Sent: Thursday, September 27, 2018 8:18 AM
> To: eliezer@integritech.solutions
> Cc: fio
> Subject: Re: Resending: fio testing on S3 object storage
>
> Hi,
>
> You
> On Wed, 26 Sep 2018 at 17:54, <eliezer@integritech.solutions> wrote:
> >
> > It looks like I don=E2=80=99t have the "http" ioengine on my server:
> >
> > # fio --enghelp
> > Available IO engines:
> >         cpuio
> >         mmap
> >         sync
> >         psync
> >         vsync
> >         pvsync
> >         pvsync2
> >         null
> >         net
> >         netsplice
> >         ftruncate
> >         libaio
> >         rdma
> >         posixaio
> >         falloc
> >         e4defrag
> >         splice
> >         rbd
> >         mtd
> >         pmemblk
> >         dev-dax
> >         sg
> >         binject
>
> You need to have the appropriate dependencies available when you go to
> compile fio (you'll find that ./configure says that http is enabled).
> I believe for the http engine you need the development libraries for
> curl and openssl installed...
>
> --
> Sitsofe | http://sucs.org/~sits/
>

