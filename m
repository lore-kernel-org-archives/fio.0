Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE446C77B73
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 12:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243952AbjD0M0r (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 08:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243155AbjD0M0q (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 08:26:46 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B262730E8
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 05:26:41 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id a1e0cc1a2514c-77217c862b3so2619355241.3
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 05:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682598401; x=1685190401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFrE3CeAqHwAFKZYq37rw+xwf97lowEk51sHUTahFI4=;
        b=GgJvirlXamVUUSPFhUtqxPww1m+ZOw4sCwBs5JU3yrLpl/tK3U1Cg+6nlABNVYGNwT
         3Lvz4hBGzkQ70BYHGHzWfP/Vj7jW6WGgrzG4YmSYR+UG8FQ4oMYg16AKj37W+FK0HkzQ
         A2wJP6UBURhbLaZhcsk6SQwGjYH9ZWcSWLpf6PQcLBKfQUTwEe+tgSEPVgfIcE7WCoP7
         4Otg91z5TCXVscz18alIY7cuHEiupPe0OrOslyWvc9EDG7ICQpHgLUCpggez4L6giWea
         geroL36yMe0Is467ms2ppeHSgdepK9dngCSAGeBTPnd5ZT5N7Mwdhu9IwFrAl8He70yB
         eZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682598401; x=1685190401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VFrE3CeAqHwAFKZYq37rw+xwf97lowEk51sHUTahFI4=;
        b=aGGq09Auk6NF/bzxGCH6g+Xniso8tOGo6xAFVd85o+Jw/y2r22Cd5ERN0+SrSN2752
         Q4XWYZdrIGG0ICMKFyLxKVrsiwXc/Llnn0Rp3vt89eICSPJ4P5luNTybGqrGZMa9sA46
         4geSQSDzu5z9a/uZj93XNk4lMGhXFOPIwqDFckgtM1h45N9EaPg70gMSgpUPLdldccNn
         EhPCUeracO/bVidnu/L56E8dQuGibW5Hzk+4ml7+msNwHoRbDjP3kn9MhkYwnGPdw6rq
         oxDD52GxHBzqI6fco+mwPUxk/huRNKOEkLNizz4oQU2fiZ19MajOxTs7T8mRP8ij85wF
         Vyog==
X-Gm-Message-State: AC+VfDymib5iGiEmcsxK99WgsfEwHs7e3aHIcnCZMnZLQgN4dTmvdMCU
        cHStamlTcvbSffGffi12Tjrvb20xTSZbmoRliV3MwEDwsQ==
X-Google-Smtp-Source: ACHHUZ5l2USG1gUIjDkroJOf9qhmWWyKpPrnoM2fTJXp47CNaAVLnL4rNyzIGdItD7mHEnjGoC/iayvQMWJ7IYuchlY=
X-Received: by 2002:a1f:450a:0:b0:44b:2450:e4c8 with SMTP id
 s10-20020a1f450a000000b0044b2450e4c8mr382486vka.9.1682598400557; Thu, 27 Apr
 2023 05:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8@epcas5p3.samsung.com>
 <20230427151004.1146679-1-anuj20.g@samsung.com> <4e368610-30aa-4f2a-202b-d93050ea1f02@kernel.dk>
 <cdbabe77-9b1d-c020-e7fe-528e453af002@kernel.dk>
In-Reply-To: <cdbabe77-9b1d-c020-e7fe-528e453af002@kernel.dk>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Thu, 27 Apr 2023 17:56:03 +0530
Message-ID: <CACzX3AvLdk8rLH-3DOe1Ono9xabi2NMsoXBnvpmMj6rFPVfM-A@mail.gmail.com>
Subject: Re: [PATCH] t/io_uring: fix error handling for setup_ring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Anuj Gupta <anuj20.g@samsung.com>, vincent.fu@samsung.com,
        fio@vger.kernel.org, ankit.kumar@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Apr 27, 2023 at 5:23=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/27/23 5:48?AM, Jens Axboe wrote:
> > On 4/27/23 9:10?AM, Anuj Gupta wrote:
> >> s->sq_ring.ring_entries and s->cq_ring.ring_entries will be NULL,
> >> incase setup_ring fails. This will cause a segmentation fault.
> >>
> >> In case setup_ring fails, bail out by setting finish.
> >
> > Any reason why we don't just use the return code of submitter_init()
> > on whether to abort or not?
>
> Something like this as a prep patch, then do the trivial version
> of your patch after that.
>
> Totally untested...
>
>
> diff --git a/t/io_uring.c b/t/io_uring.c
> index 6b0efef85cb7..2f8d63fbe67e 100644
> --- a/t/io_uring.c
> +++ b/t/io_uring.c
> @@ -1049,7 +1049,7 @@ static int submitter_init(struct submitter *s)
>
>                 buf =3D allocate_mem(s, bs);
>                 if (!buf)
> -                       return 1;
> +                       return -1;
>                 s->iovecs[i].iov_base =3D buf;
>                 s->iovecs[i].iov_len =3D bs;
>         }
> @@ -1066,7 +1066,7 @@ static int submitter_init(struct submitter *s)
>         }
>         if (err) {
>                 printf("queue setup failed: %s, %d\n", strerror(errno), e=
rr);
> -               return 1;
> +               return -1;
>         }
>
>         if (!init_printed) {
> @@ -1172,9 +1172,15 @@ static void *submitter_aio_fn(void *data)
>         struct iocb *iocbs;
>         struct io_event *events;
>  #ifdef ARCH_HAVE_CPU_CLOCK
> -       int nr_batch =3D submitter_init(s);
> -#else
> -       submitter_init(s);
> +       int nr_batch;
> +#endif
> +
> +       ret =3D submitter_init(s);
> +       if (ret < 0)
> +               goto done;
> +
> +#ifdef ARCH_HAVE_CPU_CLOCK
> +       nr_batch =3D ret;
>  #endif
>
>         iocbsptr =3D calloc(depth, sizeof(struct iocb *));
> @@ -1238,6 +1244,7 @@ static void *submitter_aio_fn(void *data)
>         free(iocbsptr);
>         free(iocbs);
>         free(events);
> +done:
>         finish =3D 1;
>         return NULL;
>  }
> @@ -1277,9 +1284,15 @@ static void *submitter_uring_fn(void *data)
>         struct io_sq_ring *ring =3D &s->sq_ring;
>         int ret, prepped;
>  #ifdef ARCH_HAVE_CPU_CLOCK
> -       int nr_batch =3D submitter_init(s);
> -#else
> -       submitter_init(s);
> +       int nr_batch;
> +#endif
> +
> +       ret =3D submitter_init(s);
> +       if (ret < 0)
> +               goto done;
> +
> +#ifdef ARCH_HAVE_CPU_CLOCK
> +       nr_batch =3D ret;
>  #endif
>
>         if (register_ring)
> @@ -1383,6 +1396,7 @@ submit:
>         if (register_ring)
>                 io_uring_unregister_ring(s);
>
> +done:
>         finish =3D 1;
>         return NULL;
>  }
> @@ -1393,7 +1407,8 @@ static void *submitter_sync_fn(void *data)
>         struct submitter *s =3D data;
>         int ret;
>
> -       submitter_init(s);
> +       if (submitter_init(s) < 0)
> +               goto done;
>
>         do {
>                 uint64_t offset;
> @@ -1429,6 +1444,7 @@ static void *submitter_sync_fn(void *data)
>                         add_stat(s, s->clock_index, 1);
>         } while (!s->finish);
>
> +done:
>         finish =3D 1;
>         return NULL;
>  }
>

Tested this and the patch works out fine. This can go on top of this
to avoid access to NULL pointer -

--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1059,7 +1059,8 @@ static int submitter_init(struct submitter s)
                err =3D 0;
        } else if (!aio) {
                err =3D setup_ring(s);
-               sprintf(buf, "Engine=3Dio_uring, sq_ring=3D%d,
cq_ring=3D%d\n",s->sq_ring.ring_entries, s->cq_ring.ring_entries);
+               if (!err)
+                       sprintf(buf, "Engine=3Dio_uring, sq_ring=3D%d,
cq_ring=3D%d\n",s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
        } else {
                sprintf(buf, "Engine=3Daio\n");
                err =3D setup_aio(s);

> --
> Jens Axboe
>

--
Anuj Gupta
