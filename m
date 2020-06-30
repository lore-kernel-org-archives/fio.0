Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgF3TaB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Jun 2020 15:30:01 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C051C061755
        for <fio@vger.kernel.org>; Tue, 30 Jun 2020 12:30:01 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g139so12063884lfd.10
        for <fio@vger.kernel.org>; Tue, 30 Jun 2020 12:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592981060.git.ykorman@gmail.com> <678d10332ad5edb5d076d0fe94a833fe595a3020.1592981060.git.ykorman@gmail.com>
 <x49zh8l28t1.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49zh8l28t1.fsf@segfault.boston.devel.redhat.com>
From: Yigal Korman <ykorman@gmail.com>
Date: Tue, 30 Jun 2020 22:29:47 +0300
Message-ID: <CAOdGBnGBcAEUEJziix6ysoTs7c4=TrBBdxEq9ELRARKcDWK+5g@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] fio: suggest installing engine package when missing
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org

On Mon, Jun 29, 2020 at 6:25 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Yigal Korman <ykorman@gmail.com> writes:
>
> > Signed-off-by: Yigal Korman <ykorman@gmail.com>
> > ---
> >  ioengines.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/ioengines.c b/ioengines.c
> > index 78262bc1..20224e59 100644
> > --- a/ioengines.c
> > +++ b/ioengines.c
> > @@ -79,10 +79,16 @@ static struct ioengine_ops *find_ioengine(const char *name)
> >  static void *dlopen_external(struct thread_data *td, const char *engine)
> >  {
> >       char engine_path[PATH_MAX];
> > +     void *dlhandle;
> >
> >       sprintf(engine_path, "%s/lib%s.so", FIO_EXT_ENG_DIR, engine);
> >
> > -     return dlopen(engine_path, RTLD_LAZY);
> > +     dlhandle = dlopen(engine_path, RTLD_LAZY);
> > +     if (!dlhandle)
> > +             log_info("Engine not available; Install the fio-engine-%s package\n",
> > +                      engine);
> > +
> > +     return dlhandle;
> >  }
> >  #else
> >  #define dlopen_external(td, engine) (NULL)
>
> This assumes fio is part of a package, and that's not always (often?)
> the case.  It may be that the engine simply wasn't built.

I agree.
This patch is more of a showcase of how to help package maintainers
transition users to the new packaging model.
I will drop it from the next patchset version.
This patch might have made more sense if I had implemented a whitelist
of engines that were compiled dynamically.

Thanks,
Yigal

>
> -Jeff
>

