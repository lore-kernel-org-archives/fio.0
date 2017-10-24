Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:46499 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdJXDXj (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Oct 2017 23:23:39 -0400
Received: by mail-wm0-f48.google.com with SMTP id m72so12929204wmc.1
        for <fio@vger.kernel.org>; Mon, 23 Oct 2017 20:23:39 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: buffer-cache builds up with invalidate=1 too
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com>
Date: Tue, 24 Oct 2017 05:23:36 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org> <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


> Il giorno 23 ott 2017, alle ore 20:26, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
>=20
> Hi,
>=20
> On 23 October 2017 at 11:02, Paolo Valente <paolo.valente@linaro.org> =
wrote:
>>=20
>> in a time_based test with direct=3D0, a small file happened to be =
read several times. Yet I/O was actually done only when the file was =
read for the first time, even if invalidate was set.
>>=20
>> So, if I'm not mistaken, the buffer cache still builds up even if =
invalidate is set, right?
>=20
> Correct - invalidate just invalidates the cache at the "beginning"
> (see =
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-invalidate
> ).

Hi,
thank you very much for answering this and my other question
thoroughly!

Maybe I would specify, in the description of invalidate, that the
invalidation is not repeated in case the I/O on a file restarts from
the beginning go the file.

Thanks,
Paolo

> See below where I agree with using your direct=3D1 suggestion if you
> want to avoid the cache. See
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-direct
> for documentation on direct.
>=20
>> Then, in a time_based test, the only way to make sure that I/O is =
constantly done, is to use direct=3D1, isn't it? Of course, unless the =
file is so large that one knows that no portion of the file will be =
found in the buffer cache when read again.
>=20
> If you mean "the only way for fio to try and avoid all I/O being
> cached/being only serviced by Linux's buffer cache is to use direct=3D1"=

> then yes. Also as you suggest you can do I/O over a region big enough
> that a significant amount of I/O must not be cacheable therefore the
> average speed would better reflect that of the underlying disk (that's
> why you hear the old bonnie benchmark rule that you had to use a file
> size at least twice memory etc as it had no cache bypass mode). If you
> do a lot of I/O to only a small region then this is clearly still
> cachable though.
>=20
> --=20
> Sitsofe | http://sucs.org/~sits/

