Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:50949 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932331AbdJXPKs (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Oct 2017 11:10:48 -0400
Received: by mail-wm0-f45.google.com with SMTP id u138so16368810wmu.5
        for <fio@vger.kernel.org>; Tue, 24 Oct 2017 08:10:48 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: buffer-cache builds up with invalidate=1 too
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com>
Date: Tue, 24 Oct 2017 17:10:44 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <FC918187-B671-44DF-B412-077FC7B683D7@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org> <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com> <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org> <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


> Il giorno 24 ott 2017, alle ore 08:28, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
>=20
> Hi,
>=20
> If memory serves it's actually slightly more complicated. If you are
> using loops=3D<number> then I *think* (you'll have to check) you will
> find that invalidation happens once per each loop start. However when
> you use time_based to do the repetition there is essentially only one
> "loop" (even though the job goes on forever) so loop actions only
> happen right at the start of the job with that option (that's why I
> put the scare quotes around "beginning" ;-).
>=20

Thanks for this additional, useful piece of information.  Actually,
this further, possibly different caching behavior makes me think that
some extra comment in the manpage might be helpful.

Thanks,
Paolo

> On 24 October 2017 at 04:23, Paolo Valente <paolo.valente@linaro.org> =
wrote:
>>=20
>> thank you very much for answering this and my other question
>> thoroughly!
>>=20
>> Maybe I would specify, in the description of invalidate, that the
>> invalidation is not repeated in case the I/O on a file restarts from
>> the beginning go the file.
>=20
> --=20
> Sitsofe | http://sucs.org/~sits/

