Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E48381B1
	for <fio@vger.kernel.org>; Wed, 28 Aug 2024 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864219; cv=none; b=TS8vRRuqd/KxuJ9mjrWcjZDHJtJ3mHl+X8/5AdX//D3Hp8lly4ampB8sSie503mzrj5bBRQcNc7AdGADzv+fAH2DYdAuG9CT9znlny9ciREGv2lswrEywJRPO3lVIpe26zSw0hnfqCdqYVFTewYBlgG322DKvp001Wb6sDVMHqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864219; c=relaxed/simple;
	bh=maZn6ib0+4CwBojyV3vhA2rrBW4ckC7Tq5cqMVTD18Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7Ifl2MaUiaNC9dz4vEMb7vTh7eW9lRIDEebamAZ4aiTmRFJm7qcXUsxrjw2uMHzm423dblWUBn9lWacs7QwydiygOreoT9i0LFcqsCkv8yUJ7GKc7GDO2iOP4Mm0F9stkwhPefEecp8YVf8BO9b/wLP2pSYZvaFWb6YF3tFu5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=pwSU6lU/; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="pwSU6lU/"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52ef9714673so1184491e87.0
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 09:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1724864215; x=1725469015; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0pwee0gbVcuq6yj2zqQL8iZ6pSRAFabX3qcvdlUjjY=;
        b=pwSU6lU/nHulK0NfbVRNV75xRlPyyDojjOVXOxjsnLu8OF9QSWmP0XoMtGBdApZVqe
         IDQ5qOuQxDvfk8YT6J4nbaRJw18ZLzw/nI5JXReSfSdxv1ehxxuGuc5dhpU6KwZAqUBI
         XrDf6a85yJLTqw3owmahdNiL4mqT4oxuSO05+nYdcZgK8p0Vm+Ge37EJHXGwrQb+bUTv
         GZMI5o4Ieq7t7heu4tgb/2OGBEhz7jzYrcgP+Q1OOraMzYbrVDVl08quVcgrEbcKTpnq
         N/O2gvWn/kvqkuCh8tuACdsi4dE6MJTzYLH1pialWUPANu1o1hh7yEv1zxbRUwGUgD/K
         iiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724864215; x=1725469015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0pwee0gbVcuq6yj2zqQL8iZ6pSRAFabX3qcvdlUjjY=;
        b=rus/zdrNVs/hqD/A82fP+Vzq4eU6RUdRYg+QjzZ7YWb9sCojgUPCVQP3lUX+7Pi9w0
         C7zR92D7k8UHOVrQkFE7EdnAGKCNZAeaoZx//VYosJ+NimbI9KQ3khRm8IXuYZxmcbMI
         NrkTiGjYPjTgLKusFfAsmTrvwRoCqAW7dGz31Oh1mJpeS8dk2zh0taJUf6piGOBukBzB
         DO1Kb/p2mj2kJQjOWB/bF54Lpjjy1NHGcHfxlo9kPoTEKRghgwZuEFWFn8n/JQWTr0Uj
         1BQpPBSqYArq1pLwyzDkGJYo+ewdONwXlpIgXcbLtxMEEdsbLfvGSlECmRYlcBsohO54
         wdHw==
X-Gm-Message-State: AOJu0YyVjjNtUhWfEDEjKvnRiBObsjpTB4JsNasXMoWJkmq39NHF+hYa
	W+qMxBGJJdftXvcSecWiqEqcdQzjZBKEh/sIU/vkkdYdSlNl27LDEZwL9avxHLX4asGqwn081p1
	8lQPDwDAbOkvYXgfJ5OYIS12xyTAPp8lVFeimIw==
X-Google-Smtp-Source: AGHT+IFVEgT5k4rl4q5cHoAk+VwDKYqmnmdC0t3RORhWDaFztHLDx0034lsllaF6dAiojyHgfT48ilUnxJUsxjFz9J4=
X-Received: by 2002:a2e:bc25:0:b0:2ef:307d:17 with SMTP id 38308e7fff4ca-2f610392649mr1732411fa.1.1724864215081;
 Wed, 28 Aug 2024 09:56:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com> <20240827070850.947037-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240827070850.947037-4-shinichiro.kawasaki@wdc.com>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Wed, 28 Aug 2024 11:56:42 -0500
Message-ID: <CADqNVTqp0KDySU7+5vHmAnfBXorkMZnYVrQAcKGMsSFBZfU7nw@mail.gmail.com>
Subject: Re: [PATCH 3/9] iolog: refactor flush_samples()
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>, 
	Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One quick observation though I'm guessing you probably have already
checked it. It would be good to be sure the performance after this
refactor for outputting the log files is similar or bettter, due to
how long it can take to output per-I/O log files.

Thanks,
Nick


On Tue, Aug 27, 2024 at 2:09=E2=80=AFAM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> flush_samples() controls the log file format depending on the options
> log_avg_msec, log_window_value, log_offset and log_prio. It has deeply
> nested branches to check the options. These nested branches make it
> difficult to add more fields to the log file format. For ease of the log
> file format improvements, refactor the function. Instead of checking all
> conditions at once, check each condition one by one, generate small
> strings for each field and add them to the final string to output. For
> this purpose, introduce the new function print_sample_fields() which
> generates each field string.
>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  iolog.c | 131 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 67 insertions(+), 64 deletions(-)
>
> diff --git a/iolog.c b/iolog.c
> index f727c97f..06b51ea0 100644
> --- a/iolog.c
> +++ b/iolog.c
> @@ -1009,13 +1009,42 @@ static void flush_hist_samples(FILE *f, int hist_=
coarseness, void *samples,
>         }
>  }
>
> +static int print_sample_fields(char **p, size_t *left, const char *fmt, =
...) {
> +       va_list ap;
> +       int ret;
> +
> +       va_start(ap, fmt);
> +       ret =3D vsnprintf(*p, *left, fmt, ap);
> +       if (ret < 0 || ret >=3D *left) {
> +               log_err("sample file write failed: %d\n", ret);
> +               return -1;
> +       }
> +       va_end(ap);
> +
> +       *p +=3D ret;
> +       *left -=3D ret;
> +
> +       return 0;
> +}
> +
> +/*
> + * flush_samples - Generate output for log samples
> + * Each sample output is built using a temporary buffer. This buffer siz=
e
> + * assumptions are:
> + * - Each sample has less than 10 fields
> + * - Each sample field fits in 25 characters (20 digits for 64 bit numbe=
r
> + *   and a few bytes delimiter)
> + */
>  void flush_samples(FILE *f, void *samples, uint64_t sample_size)
>  {
>         struct io_sample *s;
> -       int log_offset, log_prio, log_avg_max;
> +       struct io_sample_offset *sa;
> +       bool log_offset, log_prio, log_avg_max;
>         uint64_t i, nr_samples;
> -       unsigned int prio_val;
> -       const char *fmt;
> +       char buf[256];
> +       char *p;
> +       size_t left;
> +       int ret;
>
>         if (!sample_size)
>                 return;
> @@ -1025,75 +1054,49 @@ void flush_samples(FILE *f, void *samples, uint64=
_t sample_size)
>         log_prio =3D (s->__ddir & LOG_PRIO_SAMPLE_BIT) !=3D 0;
>         log_avg_max =3D (s->__ddir & LOG_AVG_MAX_SAMPLE_BIT) !=3D 0;
>
> -       if (log_offset) {
> -               if (log_prio) {
> -                       if (log_avg_max)
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %" PRI=
d64 ", %u, %llu, %llu, 0x%04x\n";
> -                       else
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %u, %l=
lu, %llu, 0x%04x\n";
> -               } else {
> -                       if (log_avg_max)
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %" PRI=
d64 ", %u, %llu, %llu, %u\n";
> -                       else
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %u, %l=
lu, %llu, %u\n";
> -               }
> -       } else {
> -               if (log_prio) {
> -                       if (log_avg_max)
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %" PRI=
d64 ", %u, %llu, 0x%04x\n";
> -                       else
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %u, %l=
lu, 0x%04x\n";
> -               } else {
> -                       if (log_avg_max)
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %" PRI=
d64 ", %u, %llu, %u\n";
> -                       else
> -                               fmt =3D "%" PRIu64 ", %" PRId64 ", %u, %l=
lu, %u\n";
> -               }
> -       }
> -
>         nr_samples =3D sample_size / __log_entry_sz(log_offset);
>
>         for (i =3D 0; i < nr_samples; i++) {
>                 s =3D __get_sample(samples, log_offset, i);
> +               sa =3D (void *) s;
> +               p =3D buf;
> +               left =3D sizeof(buf);
> +
> +               ret =3D print_sample_fields(&p, &left, "%" PRIu64 ", %" P=
RId64,
> +                                         s->time, s->data.val.val0);
> +               if (ret)
> +                       return;
> +
> +               if (log_avg_max) {
> +                       ret =3D print_sample_fields(&p, &left, ", %" PRId=
64,
> +                                                 s->data.val.val1);
> +                       if (ret)
> +                               return;
> +               }
> +
> +               ret =3D print_sample_fields(&p, &left, ", %u, %llu",
> +                                         io_sample_ddir(s),
> +                                         (unsigned long long) s->bs);
> +               if (ret)
> +                       return;
> +
> +               if (log_offset) {
> +                       ret =3D print_sample_fields(&p, &left, ", %llu",
> +                                                 (unsigned long long) sa=
->offset);
> +                       if (ret)
> +                               return;
> +               }
>
>                 if (log_prio)
> -                       prio_val =3D s->priority;
> +                       ret =3D print_sample_fields(&p, &left, ", 0x%04x"=
,
> +                                                 s->priority);
>                 else
> -                       prio_val =3D ioprio_value_is_class_rt(s->priority=
);
> +                       ret =3D print_sample_fields(&p, &left, ", %u",
> +                                                 ioprio_value_is_class_r=
t(s->priority));
> +               if (ret)
> +                       return;
>
> -               if (!log_offset) {
> -                       if (log_avg_max)
> -                               fprintf(f, fmt,
> -                                       s->time,
> -                                       s->data.val.val0,
> -                                       s->data.val.val1,
> -                                       io_sample_ddir(s), (unsigned long=
 long) s->bs,
> -                                       prio_val);
> -                       else
> -                               fprintf(f, fmt,
> -                                       s->time,
> -                                       s->data.val.val0,
> -                                       io_sample_ddir(s), (unsigned long=
 long) s->bs,
> -                                       prio_val);
> -               } else {
> -                       struct io_sample_offset *so =3D (void *) s;
> -
> -                       if (log_avg_max)
> -                               fprintf(f, fmt,
> -                                       s->time,
> -                                       s->data.val.val0,
> -                                       s->data.val.val1,
> -                                       io_sample_ddir(s), (unsigned long=
 long) s->bs,
> -                                       (unsigned long long) so->offset,
> -                                       prio_val);
> -                       else
> -                               fprintf(f, fmt,
> -                                       s->time,
> -                                       s->data.val.val0,
> -                                       io_sample_ddir(s), (unsigned long=
 long) s->bs,
> -                                       (unsigned long long) so->offset,
> -                                       prio_val);
> -               }
> +               fprintf(f, "%s\n", buf);
>         }
>  }
>
> --
> 2.45.2
>
>
