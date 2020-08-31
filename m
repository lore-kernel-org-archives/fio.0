Return-Path: <fio-owner@vger.kernel.org>
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:51348 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbgHaFy0 (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 31 Aug 2020 01:54:26 -0400
Date: Mon, 31 Aug 2020 07:54:17 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: [PATCH 3/3] cgroup: Try to use blkio.bfq.weight if blkio.weight
 is not available
Message-ID: <20200831055417.GK6041@suselix>
References: <20200827120722.GC6041@suselix>
 <20200827121533.GF6041@suselix>
 <CALjAwxhUcbqQoAKJQYoxeKzw+XfbAbiSe-yKSFHW85hzE0SEQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CALjAwxhUcbqQoAKJQYoxeKzw+XfbAbiSe-yKSFHW85hzE0SEQw@mail.gmail.com>
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, fio <fio@vger.kernel.org>

On Fri, Aug 28, 2020 at 06:29:38PM +0100, Sitsofe Wheeler wrote:
> On Thu, 27 Aug 2020 at 13:26, Andreas Herrmann <aherrmann@suse.com> wrote=
:
> >
> > Newer kernels just provide blkio.bfq.weight for blkio contoller. Try
> > to use this attribute when legacy file is not available.
> >
> > Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
> > ---
> >  cgroup.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/cgroup.c b/cgroup.c
> > index 43513733..6edb5b14 100644
> > --- a/cgroup.c
> > +++ b/cgroup.c
> > @@ -218,8 +218,14 @@ int cgroup_setup(struct thread_data *td, struct fl=
ist_head *clist, struct cgroup
> >                 }
> >                 if (write_int_to_file(td, root, "blkio.weight",
> >                                         td->o.cgroup_weight,
> > -                                       "cgroup open weight"))
> > -                       goto err;
> > +                                       "cgroup open blkio.weight")) {
> > +                       td_clear_error(td);
> > +                       log_err("Trying to use blkio.bfq.weight\n");
>=20
> It doesn't feel right to print an error just because you tried a
> fallback. Maybe try both and print an error if neither works?

Ok.
Most likely it's better to merge this patch into patch 2 of my second
submission.

Thanks.

> > +                       if (write_int_to_file(td, root, "blkio.bfq.weig=
ht",
> > +                                               td->o.cgroup_weight,
> > +                                               "cgroup open blkio.bfq.=
weight"))
> > +                               goto err;
> > +               }
> >         }
> >
> >         if (!cgroup_write_pid(td, root, (*mnt)->cgroup2)) {
> > --
> > 2.28.0
> >
>=20
>=20
> --=20
> Sitsofe | http://sucs.org/~sits/
>=20

--=20
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer (HRB 36809, AG N=C3=BCrnberg)


