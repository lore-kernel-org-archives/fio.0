Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37146 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdGSIYw (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2017 04:24:52 -0400
Received: by mail-wm0-f47.google.com with SMTP id g127so7974000wmd.0
        for <fio@vger.kernel.org>; Wed, 19 Jul 2017 01:24:52 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: random-time I/O with fio
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CALjAwxh-rE6vnRc8TsoOe0Sx8hFbSrhoHgXJa8WAYfLhjooECw@mail.gmail.com>
Date: Wed, 19 Jul 2017 10:24:49 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <90DB9BC3-CC6B-4BFC-8FC6-F4685B07642F@linaro.org>
References: <787DD20D-DCFE-4E01-8F6E-A84853E89F12@linaro.org> <CALjAwxh-rE6vnRc8TsoOe0Sx8hFbSrhoHgXJa8WAYfLhjooECw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


> Il giorno 18 lug 2017, alle ore 22:22, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
>=20
> Hi,
>=20
> On 18 July 2017 at 09:03, Paolo Valente <paolo.valente@linaro.org> =
wrote:
>>=20
>> by chance, is there a (possibly indirect) way to generate I/Os
>> occurring at random times with fio?  Even a minimum variation with
>> respect to periodic I/O, such as rate-limited I/O I guess, would be
>> perfect.
>=20
> How about rate_process=3Dpoisson
> =
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rate-proce=
ss
> )?
>=20

That's exactly what I need!  I missed that parameter because I
looked for a useful parameter with un-matching keywords.

Thank you very much,
Paolo

> --=20
> Sitsofe | http://sucs.org/~sits/

