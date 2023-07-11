Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A828EB64DC
	for <fio@archiver.kernel.org>; Tue, 11 Jul 2023 15:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbjGKPsl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jul 2023 11:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjGKPsk (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2023 11:48:40 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB73FB
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 08:48:39 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-c4dfe2a95fbso6526946276.3
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 08:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689090518; x=1691682518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrfbD/UKhlxv9mOKZIPyl+9EtdClVvU+tc603h/stzQ=;
        b=WI7ami6r0GAI+m3tOxZpMtlEftxhSaxKAYrcPq4lrtslRxvONs+5Tqr4QAONLSGzMz
         Uu+cgNU4hSDBE8L+366QRQSUAZTGLWI4webjhRpcw/AD41iwksbQH10EANHkDvKiXxT2
         Tjvx/5qLFTUtAqPSJy7zABfhDZPYKBiIBebAOOvaMkOC1m7IPhbksph+MqT+YEoYzLRX
         Vb8Bblf5ieUbNtsigiSBstHzJWITZyeK4gb4AzjJ7lus983J9bX0UEDxMtKiUA2O7Tay
         gOP5F6K9Km6ejCpc7jaY26Xc8/fzx532njCbFaxWWkN0l6Os0DCrqkqcIa5lq5jWoKQl
         xifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689090518; x=1691682518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrfbD/UKhlxv9mOKZIPyl+9EtdClVvU+tc603h/stzQ=;
        b=l64zYi04WX4Rnt77jdKFRu/ByuNShGNdwHkFw6ifq9hiFLTwFzXWhIDfFGHEXh+6Vg
         bAeL7UzCyudYGSsKwnHLL/fZVXBxojqM7njOYMMKFA3IXfY3t0TbxzMZJLl/iCDjpQ8j
         GcupWuCYQJacXF1WoSaBFKNOHQan9bVxM6xdwo3yf7x6wIknXMirmvLfV9p2V1UPcuUS
         Fic/BiyLMSgm2AxHDdKhRZ0MKLgJqtJ4hDDLqCwYm4HU4REeQ0AMypgl9o66n8JMQjXn
         aDXC2rG0j6BKhKVQvscS8BZa1QseaZy7aPQmG2ma0U02ksySPPzkWLF7LHHhADT12JQ9
         9xAQ==
X-Gm-Message-State: ABy/qLZsL8Z8TH+2N7utmqI7WmZw+JNKFWhDssAwEKP68kfr62IbNzc/
        Gw0mOo3DZDMKlKUNDB8PpfWxRSiK0Q5gBvJ2UUE=
X-Google-Smtp-Source: APBJJlGfa/ZmoEzO6zmP7mO/CnLhbaBzIzx9rnCzsyXl/eu4AizV8B4qaEpWVwCX7TO+JWLYSh75/sn2NE9xQM7hWPU=
X-Received: by 2002:a25:13c9:0:b0:c4d:4ffc:6807 with SMTP id
 192-20020a2513c9000000b00c4d4ffc6807mr12809672ybt.51.1689090518131; Tue, 11
 Jul 2023 08:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230711125434.14691-1-ankit.kumar@samsung.com>
 <CGME20230711073512epcas5p4d10da8eefbc198953212cbfd5ca83198@epcas5p4.samsung.com>
 <20230711125434.14691-2-ankit.kumar@samsung.com> <b4e47ae7-1333-a47a-16f6-ecdddf462e13@gmail.com>
In-Reply-To: <b4e47ae7-1333-a47a-16f6-ecdddf462e13@gmail.com>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Tue, 11 Jul 2023 21:14:44 +0530
Message-ID: <CAKi7+wfRE6v64fmRGq1RB+7oF1=C7YRKABJMHHOuuUHW-8YO+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] fdp: use macro for max ruhs and fix placement id check
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Yeah makes sense, I will do that in v2.

On Tue, Jul 11, 2023 at 8:16=E2=80=AFPM Vincent Fu <vincentfu@gmail.com> wr=
ote:
>
> On 7/11/23 08:54, Ankit Kumar wrote:
> > Use macro for max ruhs.
> > Number of reclaim unit handle descriptors are 1 based, whereas the
> > input placement id index / indices are 0 based. Add the correct check
> > for that.
> >
> > Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> > ---
> >   engines/io_uring.c | 2 +-
> >   fdp.c              | 8 ++++----
> >   fdp.h              | 2 ++
> >   3 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/engines/io_uring.c b/engines/io_uring.c
> > index 5021239e..407d65ce 100644
> > --- a/engines/io_uring.c
> > +++ b/engines/io_uring.c
> > @@ -1310,7 +1310,7 @@ static int fio_ioring_cmd_fetch_ruhs(struct threa=
d_data *td, struct fio_file *f,
> >       struct nvme_fdp_ruh_status *ruhs;
> >       int bytes, ret, i;
> >
> > -     bytes =3D sizeof(*ruhs) + 128 * sizeof(struct nvme_fdp_ruh_status=
_desc);
> > +     bytes =3D sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(struct nvme_fdp_r=
uh_status_desc);
> >       ruhs =3D scalloc(1, bytes);
> >       if (!ruhs)
> >               return -ENOMEM;
> > diff --git a/fdp.c b/fdp.c
> > index d92dbc67..72afca01 100644
> > --- a/fdp.c
> > +++ b/fdp.c
> > @@ -45,7 +45,7 @@ static int init_ruh_info(struct thread_data *td, stru=
ct fio_file *f)
> >       struct fio_ruhs_info *ruhs, *tmp;
> >       int i, ret;
> >
> > -     ruhs =3D scalloc(1, sizeof(*ruhs) + 128 * sizeof(*ruhs->plis));
> > +     ruhs =3D scalloc(1, sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(*ruhs->=
plis));
> >       if (!ruhs)
> >               return -ENOMEM;
> >
> > @@ -56,8 +56,8 @@ static int init_ruh_info(struct thread_data *td, stru=
ct fio_file *f)
> >               goto out;
> >       }
> >
> > -     if (ruhs->nr_ruhs > 128)
> > -             ruhs->nr_ruhs =3D 128;
> > +     if (ruhs->nr_ruhs > FDP_MAX_RUHS)
> > +             ruhs->nr_ruhs =3D FDP_MAX_RUHS;
> >
> >       if (td->o.fdp_nrpli =3D=3D 0) {
> >               f->ruhs_info =3D ruhs;
> > @@ -65,7 +65,7 @@ static int init_ruh_info(struct thread_data *td, stru=
ct fio_file *f)
> >       }
> >
> >       for (i =3D 0; i < td->o.fdp_nrpli; i++) {
> > -             if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
> > +             if (td->o.fdp_plis[i] >=3D ruhs->nr_ruhs) {
> >                       ret =3D -EINVAL;
> >                       goto out;
> >               }
> > diff --git a/fdp.h b/fdp.h
> > index 81691f62..4a5e0e54 100644
> > --- a/fdp.h
> > +++ b/fdp.h
> > @@ -3,6 +3,8 @@
> >
> >   #include "io_u.h"
> >
> > +#define FDP_MAX_RUHS 128
> > +
> >   struct fio_ruhs_info {
> >       uint32_t nr_ruhs;
> >       uint32_t pli_loc;
>
>
> Ankit, the commit history will be cleaner if the refactoring change and
> the bug fix were split into separate commits. Would you mind doing that?
>
> Vincent
