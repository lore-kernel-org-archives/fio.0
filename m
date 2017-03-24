Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36179 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdCXHQH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Mar 2017 03:16:07 -0400
Received: by mail-vk0-f44.google.com with SMTP id s68so6284407vke.3
        for <fio@vger.kernel.org>; Fri, 24 Mar 2017 00:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <72e659317cc3b61aaf5ad05504d83919@mail.gmail.com>
References: <CAJAr4ZUSv8RNoiFp23WUV48CBn-Vv8qs3zczz2ZQSnBctwx=9w@mail.gmail.com>
 <72e659317cc3b61aaf5ad05504d83919@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 24 Mar 2017 07:15:35 +0000
Message-ID: <CALjAwxhHpkdqnzw6Pb48kVqydePoSX_1t22+LHH0-xx-et4a6w@mail.gmail.com>
Subject: Re: How to simulate bursty I/O traffic with fio?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jason Sirichoke <jason.sirichoke@broadcom.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 23 March 2017 at 20:59, Jason Sirichoke <jason.sirichoke@broadcom.com> w=
rote:
>
> I am trying to evaluate the behavior of some RAID controllers when faced
> with =E2=80=9Cbursty=E2=80=9D IOs. Typically in our storage performance t=
esting we evaluate

If you don't need exact control have you looked at using rate=3D with
rate_process=3Dpoisson -
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rate-process
?

> controllers using a steady stream of I/Os by controlling the iodepth opti=
on
> and leaving the rest of the IO depth and IO rate parameters undefined so
> they take the defaults. The behavior I am trying to simulate is an
> application sending multiple IOs at once, retrieve + processing time and
> then submitting the next group of IOs. From the fio HOWTO document it loo=
ks
> like the best way to do this is:
>
> iodepth =3D (number of I/Os to send at once, i.e 32)
>
> iodepth_batch_submit =3D 0 (submit the full set of iodepth IOs at once)
>
> iodepth_batch_complete_min =3D 1
>
> iodepth_batch_complete_max =3D iodepth (fio should try to retrieve at lea=
st a
> single IO and up to the iodepth number of IOs)

I suspect in your case it doesn't matter so much how much you retrieve
in one go so long as you control when things are submitted again...

> iodepth_low =3D default (always fill the queue)

See below.

> thinktime =3D number of milliseconds between each burst
>
> thinktime_blocks =3D ? (This is where I was confused=E2=80=A6do I set thi=
s to the
> iodepth so it will burst all iodepth IOs before waiting thinktime
> milliseconds? Or should this be set to 1 because I want the thinktime to
> occur after a single batch of IOs?)

You will need to set thinktime_blocks=3D<iodepth> in your case otherwise
you will try and "think" after each I/O (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-thinktime-bl=
ocks
which talks about how it will otherwise make iodepth redundant). NB:
For these options to have an effect ensure you are using a
asynchronous I/O engine.

> So I=E2=80=99m hoping the end behavior is along the lines of:
>
> =C2=B7         Send 32 IOs
>
> =C2=B7         Retrieve all 32 IOs
>
> =C2=B7         Wait 5 ms  (will it continue to wait if all IOs from the p=
revious
> batch have not been retrieved yet?)

You may want to set iodepth_low=3D0 to ensure you don't try and send
anything before all 32 previous I/Os have been retrieved.

> =C2=B7         Send the next 32 IOs, repeat

--=20
Sitsofe | http://sucs.org/~sits/
