Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E714240DFB3
	for <fio@vger.kernel.org>; Thu, 12 Mar 2026 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773322475; cv=pass; b=owMsHFCvgFBTdKgHHFnDp3k43z3NLhWi368sdUjIeOyeYkRFrAK+B1YG4CF5NSRHDJsCUIQe0/8PazfqH8Ge//Txb4xSWRqWKlp1M6QrVidropdBiawzlNgotwD9U9CicxlHghWHkEfjBkrGwQAp9IS8t8QVysi/xX2VYHaBeSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773322475; c=relaxed/simple;
	bh=9GoloRBsRPfeRKIiUkpbMnkctRR/+Q5o21St9UKFwbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YtB3qM3lUMA10TgRwrWt03aUGb06yIXCqPv0HtZ6Qo5CTQLN5pu7X4Ej7Ps39EDlbKc39VKzRomJ0RSqaYhfZM3e89V2npj8do/J5CCCCX298QjwqzfcBOuEou6/2EbFOWwtbjvexuHO2+4il7QkXpUD/9icZn4/E+lQ5atEIGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLOZHD3A; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLOZHD3A"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-38a5584e31fso16884621fa.0
        for <fio@vger.kernel.org>; Thu, 12 Mar 2026 06:34:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773322472; cv=none;
        d=google.com; s=arc-20240605;
        b=eYhCrdq4f8BW6mvpwTNcFgt3MrruPOCg4RFZgODOLh+musLq0cz/qZ+lRnvjFtqvfo
         /8BahnlUnk+tmBZwaGfVsElA97bcrXr7wZOZoqBvZgKQhEe8EdYYpNt4R7qrAk6QYcY6
         pq931UaKcJI+2yrRAyZA9fdNMoNrMS8Zh3BgmD7THEppcO5kn3I+hzs8rUGcLgQLVJig
         d0Q680oIDnuws6VgSeHbawCB5Ed7KvkUQrviTpwRnQGS4tHwxdfAe9ThQWqNqAUwMMOb
         WO0hJplBJmyrtvHT2WIVxG10KTMat+MW4oSo2Hij8AqjvfsodCgZxNVvKn8c9r5EjeWv
         zeCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x7onykUrUZ8++1G2gGa6U/MzD2W9cwTpylDzWVVlsq8=;
        fh=PEpL0DsVK5Hfk/0CYRgxgK+oVMS+3Q0IWUX/P/uLqeM=;
        b=PeEGpN60uXCS4kfHOk1GuUlhUDB9nAV9nyoWnOyspMQJPnrYVNdqSz+xTkGuOw30Ks
         uFv8F8jVQ4fz1rMPXKK7v0NYHUjj1T/yrRTd9IhV59Tw4UjIeZaPFXp6rLCoYYt58IDd
         2sJ7HRh9m2QAlYpDAuwsZwo/ezC6Fp9Qz7P9wtKQOaGa5RwSU/c0TF+3ewr9Wmae+I3h
         n0fEz5j93J3q0BjSvPmmKSVBbqJvpVcyTpFQJQxAQKWu40AqW6j4zAb1eBZS6qlnmJIJ
         J2wJ4GGrX2YD9VpO71+/icUgIneObXPLubYc/4/UNEasLC1oawaotv0VPWTQBVwR4Dm6
         9wXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773322472; x=1773927272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7onykUrUZ8++1G2gGa6U/MzD2W9cwTpylDzWVVlsq8=;
        b=GLOZHD3AGSmIa+TXz+CGgUnmh9PJNDvYR1fWOF/vJo2wqTI7vLUzD3ZGKd2RfOuatI
         PczeB6n5KPhrP1hn571Dk9A7iifkwPAUzHnLyf4eiSj86skxnymZIqS4mArWWt0B+KDI
         afSGnN7Rs6dZuDUeDnCPcEE2ILf56ZPNRlx+FOJ17hCxBx+Dtb0qdjZE1sstcE5Cb80r
         Sokdlj7wR0IQGpx+8dcVN5hxhYSNlvhaTO3A3USDBOIGYrTK5i/iYBETYMhDWN24W37x
         b7dhyhVzrsAB//+pUVvqQRaIRN3BPU4CURu0SqeK9RHLkT3pL7NazcW4aLncq9M3Yb2g
         agOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773322472; x=1773927272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x7onykUrUZ8++1G2gGa6U/MzD2W9cwTpylDzWVVlsq8=;
        b=tFQIvogstBAkj/m35ofMB/xdEhOL1txv3rrY4/stt9wkqrDVm4Pwa1tUB9K/qug3zW
         NicjYR0C5syCcBZqU59vOsapWa7HOhNdOUU/m+AW604Z9BFZJVHrs8gjyv90mOf1vGzM
         VnZUTs6Cny+r+VvaeJo4YDgCpBRAl4ndg8zgjza556NrGdR3LdktZKvUI1Fow8Hj2iPc
         eNt9DPzszv/cZQB63JyrYic0wIfpe4FydKAhTYpY4iPYBkupq66jP4hAg5Mse53MJcbo
         ugraJEwmZeUcvj1G19EE5EWfPj9IXkNufW/jZRO/gACJUHhDyTNI6EmX+7aG7kEYRdZ8
         jSQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUBKRUE3UjmFa+wpyxMfZKtQ3Q0TqNjdttwo7OZpmB4LcCJgDgPQXJWLPzh2yP+D4u4Yc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4JCoyXVxZS7EwZPGQcaVsVzcTShqgQkn/HezSt7XiLr0Ysdpp
	PnUUZfyHMq3YjN5s14dOI82oKMyg7NBw9kScTe7Z8lTSzShjzjTLKHQIPdk4Dot0JE8mHQeEwJq
	aZJXEyYPuw0EzX9YCzmlKiHO0Jo6wy70=
X-Gm-Gg: ATEYQzzX2WXEJZF4HUDa+nHDxD2wdB0V7eqgKcCsTUGU1fPE/DDATtgvL/klfdVfXV9
	H7lEZFp80280arXo7v/Ita3gH3MykEP3eLIdRdS74OK+hMSQttlE0auayF+1OHaButT4ilILnW0
	VZm3bZvhqEpat6ifjZKkfxt4rF+ywE/L4VMmqb+8BXgmO4XVkkCHmkRizp0VrvapOCArECO4375
	61h0ETMXfFGGzRo2+09/4kUuARd3qcaQTMozq2ZNcQ9iQplvDZRfhSeI0/nlThATO+zvVZQJ1H2
	Iw6VUA==
X-Received: by 2002:a2e:a593:0:b0:389:f86a:f51 with SMTP id
 38308e7fff4ca-38a7286df75mr11887121fa.17.1773322471664; Thu, 12 Mar 2026
 06:34:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311155114.198006-1-npache@redhat.com> <20260311155114.198006-2-npache@redhat.com>
In-Reply-To: <20260311155114.198006-2-npache@redhat.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Thu, 12 Mar 2026 09:34:19 -0400
X-Gm-Features: AaiRm51iTn_THjB5T3LqKOhxzgy5Jrrn5JYHifQaRvLChtKuF7_lDkJVcYAe8yU
Message-ID: <CAOp=CXkc=47=2=xkqyZwwZE5kxDGfF+zm+oVi8dvc8R_9N5qrw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] page_fault: add mmap-backed ioengine for anonymous faults
To: Nico Pache <npache@redhat.com>
Cc: axboe@kernel.dk, fio@vger.kernel.org, jvozar@redhat.com, jjurca@redhat.com, 
	jhladky@redhat.com, peterx@redhat.com, spetrovi@redhat.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 11:52=E2=80=AFAM Nico Pache <npache@redhat.com> wro=
te:
>
> Introduce a new ioengine that mmaps anonymous memory and copies data
> on read/write to trigger page faults. This allows us to leverage FIOs
> powerful framework for MM related testing, and will ideally allow us to
> quickly expand testing, by leveraging previously FS related fio scripts.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Makefile                |   2 +-
>  engines/page_fault.c    | 116 ++++++++++++++++++++++++++++++++++++++++
>  examples/page_fault.fio |  60 +++++++++++++++++++++
>  3 files changed, 177 insertions(+), 1 deletion(-)
>  create mode 100644 engines/page_fault.c
>  create mode 100644 examples/page_fault.fio
>
> diff --git a/Makefile b/Makefile
> index 0337e8fe..099e2f94 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -57,7 +57,7 @@ SOURCE :=3D     $(sort $(patsubst $(SRCDIR)/%,%,$(wildc=
ard $(SRCDIR)/crc/*.c)) \
>                 smalloc.c filehash.c profile.c debug.c engines/cpu.c \
>                 engines/mmap.c engines/sync.c engines/null.c engines/net.=
c \
>                 engines/ftruncate.c engines/fileoperations.c \
> -               engines/exec.c \
> +               engines/exec.c engines/page_fault.c \
>                 server.c client.c iolog.c backend.c libfio.c flow.c cconv=
.c \
>                 gettime-thread.c helpers.c json.c idletime.c td_error.c \
>                 profiles/tiobench.c profiles/act.c io_u_queue.c filelock.=
c \
> diff --git a/engines/page_fault.c b/engines/page_fault.c
> new file mode 100644
> index 00000000..88108644
> --- /dev/null
> +++ b/engines/page_fault.c
> @@ -0,0 +1,116 @@
> +/*
> + * page_fault engine
> + *
> + * IO engine that reads/writes directly to/from anonymous memory
> + * by triggering page faults.
> + */
> +#include "fio.h"
> +#include "ioengines.h"
> +#include <sys/mman.h>
> +
> +struct fio_page_fault_data {
> +  void *mmap_ptr;
> +  size_t mmap_sz;
> +};
> +
> +static int fio_page_fault_init(struct thread_data *td) {

The style we follow is to put the { on a new line. Also please use
tabs. We basically follow the kernel's style conventions. Did you use
the default LLVM conventions with clang-format?

> +  size_t total_io_size;
> +  struct fio_page_fault_data *fpd;
> +
> +  if (td->o.nr_files > 1) {
> +    log_err("page_fault engine does not support multiple files\n");

How about, "fio: page_fault ioengine ..."?

> +    return 1;
> +  }

Consider checking that td->o.offset =3D=3D 0 and emitting an error message
saying that the offset option must be zero for this ioengine to work.

> +
> +  fpd =3D calloc(1, sizeof(*fpd));
> +  if (!fpd)
> +    return 1;
> +
> +  total_io_size =3D td->o.size;
> +  fpd->mmap_sz =3D total_io_size;
> +  fpd->mmap_ptr =3D mmap(NULL, total_io_size, PROT_READ | PROT_WRITE,
> +                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +  if (fpd->mmap_ptr =3D=3D MAP_FAILED) {
> +    free(fpd);
> +    return 1;
> +  }
> +
> +  td->io_ops_data =3D fpd;
> +  FILE_SET_ENG_DATA(td->files[0], fpd);

I would avoid directly manipulating files[] here. Since there is only
a single instance of fpd, why not omit this and just access fpd via
td->io_ops_data in queue()?

Vincent
