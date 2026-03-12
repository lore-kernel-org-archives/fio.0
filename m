Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0443FE356
	for <fio@vger.kernel.org>; Thu, 12 Mar 2026 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337069; cv=pass; b=ZKLQOh3d7Hk+8f1+7KtALrxl2SAFHLjNhD2O9QcAjNB3/lVb2gL+za963aOHhX6ZUtxWR6t2Lqj7X0+npcmxokYa9/XxSwcHyNtVEFBQ/ViGmrs5mfBSjKmHHUBWZR4bK+13mYrhV50jEOp8wHqqw2xawlBxJd0ztZmKwaj/dbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337069; c=relaxed/simple;
	bh=Qxow5KE9QudJvWOYEmKFuMrwr5MO3EHzvASxfYVSkAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DykaZQ/Do80XOSEE9eagIX6gLIE5pi/TQo4FYAGCqJETWZ9Cv6zAQO0cBigYSDzqL1oDCxZPOr7QBY0fKH5BB/Oy0aaiGRFD3nbxI9zNBLH/X7K6dXyrWgsr8EbEwIR6JsMC9hU9hXIdOeNUdnmyd3L7Bcp6ucIuxkIgXNt1LPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BqB2XscP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nsgt1G3q; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BqB2XscP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nsgt1G3q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773337067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vk8Y3gq6AUDRA7pJx0GKOBMg/V89CxvFE6JACX4CNHI=;
	b=BqB2XscPmDYeLPp8DlvTgzsPVpo3Zs+xD2r4MYHTfj1xQUTEuvJzqBMIGlfb0od5gZF+Mo
	cmVW35EnfvpU3lk2xfzrwoZ0NV25v/boLeleys0Wup0RJHwoEdg/fhhK++45msaAiXw3nd
	9zwdjV9Enq4W61YRipic6qq543JxqWQ=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-hPEg4RgGNASw-Tk187PMuQ-1; Thu, 12 Mar 2026 13:37:45 -0400
X-MC-Unique: hPEg4RgGNASw-Tk187PMuQ-1
X-Mimecast-MFC-AGG-ID: hPEg4RgGNASw-Tk187PMuQ_1773337065
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64ca9ec3eedso1664086d50.2
        for <fio@vger.kernel.org>; Thu, 12 Mar 2026 10:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773337065; cv=none;
        d=google.com; s=arc-20240605;
        b=NFJrv1OrSRUtTuVCLWd7I6JvsYiPzA4upXN0tqg1ALGb7AXs4bxlNLTGy1wz8wIhle
         RRWXpUpioJ/H9dDssyOuhS6x17sviUTj3f8qibiB760WdwOe+dPHdrtJhqS7rwrc1KZE
         x5HJhVj79KOorYxWtw6Kq6rdFBGeK8LWqJoIs0KShL+CXvWkX2t9ggxB78zvsoqXAb1G
         p5cBTUTRshZa1n0Buix8VzboWwSkGIsZI576FORr0G54tlrweg6tLNdQeoMfPrHMhUas
         imwDEERTOeHKzkqJAT63KsS//y/Ej1X9FqDLFq7mkhziCmkGyo58/lzx4JifyrDlXalx
         hDfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vk8Y3gq6AUDRA7pJx0GKOBMg/V89CxvFE6JACX4CNHI=;
        fh=MJOFXVLLtvr+gMXc71+AJzugyaqF3ePcM31Zr49seJo=;
        b=a2ToaKFCuwBMZX0oa2oD5cVv4OBwxlf/rIBbK9gwJSYqZ9a+RjluHqrIH9iS5RO0W/
         LiWPZLQ4dhqX1lLtKv6O7PqTcrnQiU8OhDJda6Ojb88OYgS5l+qOImIdhTxhdRNXgYq+
         tXgPUhg796Tl4zNp6B7r/MRyVj773vHo/9SXaV5YQyIW9TZxzQPosG4/9f/8ZioZxK7c
         2SPK7UoTuY2OtyaPRW2MLv4/vncAJAIa//W7AwYySqnBoL1mQXLaX0vy5SwlHXL75RtN
         UlwPxj/fHYp59QpnA7pQTy3k2C48zE2ycS0bE9ERJzo73phCHrvGWDNsyWkqxqnUso9c
         1feQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773337065; x=1773941865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vk8Y3gq6AUDRA7pJx0GKOBMg/V89CxvFE6JACX4CNHI=;
        b=Nsgt1G3qaAiEHpi6LAZiYsAOIBkTT0NaZVRqBxSTU/NdXzaKUMwUxU73cRcJvlbdgd
         A3nZ5IfjtwLzj4MX5ha+XWY5/TLvtFh/GZ8BhNlxt9bAV3vKQoms5I2bBxlrcFqPA8vR
         82eeVmLB7zHmLnkxyRxjov/mGkrI8JBAa/lCDGuXWpPYKTRKqwp3r9HQn+xaJS4fiHSX
         Je8mm3tDLu/ZEJl/wRkV+nsJgRA3ogMsAHg2R/cJYWndUUn4EA3euE9AkLn2t3K4gf11
         ddX9QOEc5I5j1KSUcblALaj0J3VQLI2SGxfBlLQBc1qhIDS7wJrSSKdgEzHOK4HJo+lN
         4HRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773337065; x=1773941865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vk8Y3gq6AUDRA7pJx0GKOBMg/V89CxvFE6JACX4CNHI=;
        b=fI5r9ojkS7wN6sZyAtF8ox1HQH9jkw6fKyzzIynd2hd9rKZ/+qoHGFfl0Gqf+E3eQN
         7YLll0Qh2Wfjl177e6wzxAQQ1Nk2iCqyWXe0LESr5R3iHQw15rl5VMf49J8XCxRV74eq
         KtDq8jawwMDG61YUso7bwFuVSPgxuUy48O3+PUBiN+myU7hlnZhUE+ROgh4gfzogqZ1A
         wOeGfB2pWWEIc4wTtFdQYej5WTTdaEc0zdaDWY+cVbPc5lOTeBAHzsmx5G4+7UUBQD60
         71APvBhxQx7SiQXECC5pZZSiWpvfM57TWB8EB4VqGUc235gh0LQz96oddAZlRws7sHAh
         6CVA==
X-Forwarded-Encrypted: i=1; AJvYcCW+0KuWUphnM69vvs8Jn1MfZ5UMbMDbpshhFhNi39X4gK6WHPIFfQC4GSTfB/oe4KULHhw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2sIhymHHyyf97tm5+T1yplUN5uACJZljWKvQr2Os19X76MLPF
	cMMdvvmbZNBNF2/CnEw9SnAmrruERDJ35XpT+GaTq+NL3HpAVqJCtKQQ3VWdjvGuzXPT9oWHG4/
	z3iBLSOi2pfEUvhmRuEn1E2ZV7/41957RWJUwQSMa7tRtOlIJCkkDr1bJC+3vtXOLGks/QN/C8v
	b4z1+hyim9wVxVTC8h14YcLNIBNIZ/
X-Gm-Gg: ATEYQzzyt2iWEEQIMFcyXvepQiU/4oaI44F/Yj8WnYBqJDbLOa21bBMIcz7vN1g2ZF+
	Fo99XyBfxJzxrKjTR0EsNjDohM6jlBdWpTefARlJbpt5AWC3Lv0uR20bepRnM+oEUE71bBFIHHQ
	wi7K5s+XVyx6U5gyTUyCRp14bnzod8jPxXvmwcO7S04X14AOpEByVe6DpSluePxPAEkNf3tgiNj
	v1J
X-Received: by 2002:a05:690e:444b:b0:64c:ac70:9422 with SMTP id 956f58d0204a3-64e630aa130mr274584d50.79.1773337065167;
        Thu, 12 Mar 2026 10:37:45 -0700 (PDT)
X-Received: by 2002:a05:690e:444b:b0:64c:ac70:9422 with SMTP id
 956f58d0204a3-64e630aa130mr274564d50.79.1773337064550; Thu, 12 Mar 2026
 10:37:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311155114.198006-1-npache@redhat.com> <20260311155114.198006-2-npache@redhat.com>
 <CAOp=CXkc=47=2=xkqyZwwZE5kxDGfF+zm+oVi8dvc8R_9N5qrw@mail.gmail.com>
In-Reply-To: <CAOp=CXkc=47=2=xkqyZwwZE5kxDGfF+zm+oVi8dvc8R_9N5qrw@mail.gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 12 Mar 2026 11:37:18 -0600
X-Gm-Features: AaiRm50TK_AV0fh7TNbnZnF55nbCr7EIBsQKpgud9p8GHAoe5mi5HCuWDwYt9lw
Message-ID: <CAA1CXcAfV=FuY8hqDDnzfBLqSDqOAoBWCrvy+hByrcaK6zAAYA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] page_fault: add mmap-backed ioengine for anonymous faults
To: Vincent Fu <vincentfu@gmail.com>
Cc: axboe@kernel.dk, fio@vger.kernel.org, jvozar@redhat.com, jjurca@redhat.com, 
	jhladky@redhat.com, peterx@redhat.com, spetrovi@redhat.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 7:34=E2=80=AFAM Vincent Fu <vincentfu@gmail.com> wr=
ote:
>
> On Wed, Mar 11, 2026 at 11:52=E2=80=AFAM Nico Pache <npache@redhat.com> w=
rote:
> >
> > Introduce a new ioengine that mmaps anonymous memory and copies data
> > on read/write to trigger page faults. This allows us to leverage FIOs
> > powerful framework for MM related testing, and will ideally allow us to
> > quickly expand testing, by leveraging previously FS related fio scripts=
.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  Makefile                |   2 +-
> >  engines/page_fault.c    | 116 ++++++++++++++++++++++++++++++++++++++++
> >  examples/page_fault.fio |  60 +++++++++++++++++++++
> >  3 files changed, 177 insertions(+), 1 deletion(-)
> >  create mode 100644 engines/page_fault.c
> >  create mode 100644 examples/page_fault.fio
> >
> > diff --git a/Makefile b/Makefile
> > index 0337e8fe..099e2f94 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -57,7 +57,7 @@ SOURCE :=3D     $(sort $(patsubst $(SRCDIR)/%,%,$(wil=
dcard $(SRCDIR)/crc/*.c)) \
> >                 smalloc.c filehash.c profile.c debug.c engines/cpu.c \
> >                 engines/mmap.c engines/sync.c engines/null.c engines/ne=
t.c \
> >                 engines/ftruncate.c engines/fileoperations.c \
> > -               engines/exec.c \
> > +               engines/exec.c engines/page_fault.c \
> >                 server.c client.c iolog.c backend.c libfio.c flow.c cco=
nv.c \
> >                 gettime-thread.c helpers.c json.c idletime.c td_error.c=
 \
> >                 profiles/tiobench.c profiles/act.c io_u_queue.c fileloc=
k.c \
> > diff --git a/engines/page_fault.c b/engines/page_fault.c
> > new file mode 100644
> > index 00000000..88108644
> > --- /dev/null
> > +++ b/engines/page_fault.c
> > @@ -0,0 +1,116 @@
> > +/*
> > + * page_fault engine
> > + *
> > + * IO engine that reads/writes directly to/from anonymous memory
> > + * by triggering page faults.
> > + */
> > +#include "fio.h"
> > +#include "ioengines.h"
> > +#include <sys/mman.h>
> > +
> > +struct fio_page_fault_data {
> > +  void *mmap_ptr;
> > +  size_t mmap_sz;
> > +};
> > +
> > +static int fio_page_fault_init(struct thread_data *td) {
>
> The style we follow is to put the { on a new line. Also please use
> tabs. We basically follow the kernel's style conventions. Did you use
> the default LLVM conventions with clang-format?

Hmm perhaps I called clang-format incorrectly. I assumed it would read
the format file automatically but that is not the case. Sorry, first
time using the clang-format function.

>
> > +  size_t total_io_size;
> > +  struct fio_page_fault_data *fpd;
> > +
> > +  if (td->o.nr_files > 1) {
> > +    log_err("page_fault engine does not support multiple files\n");
>
> How about, "fio: page_fault ioengine ..."?

Sounds good, yeah I wasnt thinking about the reporting format you guys
use. Ill keep that in mind.

>
> > +    return 1;
> > +  }
>
> Consider checking that td->o.offset =3D=3D 0 and emitting an error messag=
e
> saying that the offset option must be zero for this ioengine to work.

Hmm, I didnt even notice, but while doing my cleanup and ripping out
the other features I added I accidently removed the offset...

Ill add that back. Thanks :)

>
> > +
> > +  fpd =3D calloc(1, sizeof(*fpd));
> > +  if (!fpd)
> > +    return 1;
> > +
> > +  total_io_size =3D td->o.size;
> > +  fpd->mmap_sz =3D total_io_size;
> > +  fpd->mmap_ptr =3D mmap(NULL, total_io_size, PROT_READ | PROT_WRITE,
> > +                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > +  if (fpd->mmap_ptr =3D=3D MAP_FAILED) {
> > +    free(fpd);
> > +    return 1;
> > +  }
> > +
> > +  td->io_ops_data =3D fpd;
> > +  FILE_SET_ENG_DATA(td->files[0], fpd);
>
> I would avoid directly manipulating files[] here. Since there is only
> a single instance of fpd, why not omit this and just access fpd via
> td->io_ops_data in queue()?

Yeah I had to switch to using io_ops_data directly and use the cleanup
hook (rather than close_file) because of a bug I found, but now it
just looks messy. Ill clean it up as you suggested! thanks.

Cheers,
-- Nico

>
> Vincent
>

