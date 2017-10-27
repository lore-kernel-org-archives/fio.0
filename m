Return-Path: <paolo.valente@linaro.org>
Return-Path: <paolo.valente@linaro.org>
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: buffer-cache builds up with invalidate=1 too
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CAD7QDb2mYJzVUbscNq72MLYzD_cPish+=5S_fu9awxm7Sz+hzw@mail.gmail.com>
Date: Fri, 27 Oct 2017 08:52:42 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <ECE9D641-A649-4B25-8088-CCA6DF4BCB57@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org> <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com> <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org> <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com> <FC918187-B671-44DF-B412-077FC7B683D7@linaro.org> <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk> <CAD7QDb2mYJzVUbscNq72MLYzD_cPish+=5S_fu9awxm7Sz+hzw@mail.gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

[RESENDING, BECAUSE REJECTED BY THE VGER]

> Il giorno 27 ott 2017, alle ore 08:22, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
>=20
>=20
> Il 26/ott/2017 06:32 AM, "Jens Axboe" <axboe@kernel.dk> ha scritto:
> On 10/24/2017 08:10 AM, Paolo Valente wrote:
> >
> >> Il giorno 24 ott 2017, alle ore 08:28, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
> >>
> >> Hi,
> >>
> >> If memory serves it's actually slightly more complicated. If you =
are
> >> using loops=3D<number> then I *think* (you'll have to check) you =
will
> >> find that invalidation happens once per each loop start. However =
when
> >> you use time_based to do the repetition there is essentially only =
one
> >> "loop" (even though the job goes on forever) so loop actions only
> >> happen right at the start of the job with that option (that's why I
> >> put the scare quotes around "beginning" ;-).
> >>
> >
> > Thanks for this additional, useful piece of information.  Actually,
> > this further, possibly different caching behavior makes me think =
that
> > some extra comment in the manpage might be helpful.
>=20
> Would probably make sense to change 'invalidate' to be a range of
> possible values:
>=20
> 0       As it is now, never invalidate
> 1       As it is now, invalidate initially
> once    Same as '1', invalidate initially / once
> open    New value, invalidate on every open
> close   New value, invalidate on close
>=20
> as I can definitely see reasons why you would want to invalidate every
> time you open the file.
>=20
> To do that, the 'invalidate' option should be changed from a
> FIO_OPT_BOOL to a FIO_OPT_STR, and the above possible values should be
> added as posval[] for that option.
>=20
> Compliment that with the an enum of ranges for the ovals:
>=20
> enum {
>         FIO_FILE_INVALIDATE_OFF =3D 0,
>         FIO_FILE_INVALIDATE_ONCE,
>         FIO_FILE_INVALIDATE_OPEN,
>         FIO_FILE_INVALIDATE_CLOSE
> };
>=20
> Hope this makes sense, should be trivial to add as most of the work is
> already documented in this email :-). The remaining bits is just =
calling
> file_invalidate_cache() in the proper locations,
> td_io_{open,close}_file() would be prime candidates.
>=20
> IMO this solution would make things both clearer and more flexible
>=20
> Thanks,
> Paolo
>=20
> --
> Jens Axboe


