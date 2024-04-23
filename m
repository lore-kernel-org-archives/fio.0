Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3135535D6
	for <fio@vger.kernel.org>; Tue, 23 Apr 2024 08:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713861982; cv=none; b=uSkDM5KkaEZ1ViKO2GHKavimDpoiplUoxhqjTommNUWXGUFk43bSM5OGy4OZ4v/wtGFCQrEmkfNl4OX3Thp45cgCe3SVCeZHcx2wxHKioGfwYLcrBIr4TJHcq3KvkvQT9IKYymPjBYhkQGNNE2dDiL4icLf4U6biMKc9hTTtgOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713861982; c=relaxed/simple;
	bh=p+y6qYo2LR+jKUbdCCiZMWLIOM04ii1kDWRprA7mB9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uhGRHeq7Dx0i1KqoK1d5VIfquBUcTOMH3vunJCoox7a+jL1csQgL5ikq4a8/c2ijovvxX5n7HsYpldi3k+tf1XXaDsgpP5A/sf9eT0acPZEKQKKd9AWLisF3djzGvbD6S2K94DkIV52RqI8VdmEhSNGno7V92QEFmLscEmSJszo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8uQ0yKE; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8uQ0yKE"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-572040691c9so3821227a12.1
        for <fio@vger.kernel.org>; Tue, 23 Apr 2024 01:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713861979; x=1714466779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJSlqCERPrwbp4rNTfahSlAV57TFKTCoYlC+lNMTeNg=;
        b=D8uQ0yKE88iiQcgzxxiaAFLbdStfS2CXkG6m8/V3ba8t4QAoIhVuAFyBH5VnZbXSh3
         6TjnY2/4I7QQmvLPjhUlY2Apu42x0+vV2acdpKPyHZMmRkEHXoV5I35ttqAqV+23qhsv
         ArSZX8yymx3j8wnYu1WH/PxOh8kaZiDJoJ3GOSYMpQB0n0Ug2rJhhK07pw54bNKI8UQI
         hb2RdQDh4XKsoZaL25CoYW9V9pckikaqVGBlMBil6WgpY/NjuE3oqVlVVxXKyce2n2s6
         RaNbFwS6Pg5cpudYyCbuaR6dfeT6tdyu42dDAWqivDs2onPPn0CWtnDZfxBdDSQPI+P7
         WiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713861979; x=1714466779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJSlqCERPrwbp4rNTfahSlAV57TFKTCoYlC+lNMTeNg=;
        b=R7UdkhiCWL8wOUTlTHW9q/NPwgUWzQIaGmW9P76+2Z/TTnaiEY+w4L2jj5DjCt9WnR
         CTOfKE2Szm420JEH53H0NNFxmJKhQWu+MOKgjsxaY2c+ZvGlpGgv1ej/kk40BgRsilC3
         AXZ8kvFqTmsV+2fqJ1Gl8pJmEQTDRY3T+w5ZKxpK54r2mDinyxj+D00N9KmaOPiZPLGW
         suYTo2Hlt1MovAiQO5C8wO92aXPX0J4lR3lmXGHrlAVpY2ds3gTSnkjh+Rwhg5xMey4R
         aMWorfce7DNqLS6vifYsUbW837tRHQ6oqu++DvflnJ8tg/uRWYFdphnL8StYx0nOOCEO
         zZRw==
X-Forwarded-Encrypted: i=1; AJvYcCU38Jcbab1hu2xllmFKtfzcrs/8m+oq68KQ28SmRXIIJq+zcITZCUXRvaM+CZz2PB3iSnmOojIfaxqZtzuNMkq43VQO
X-Gm-Message-State: AOJu0YyyGpCZ1IOmsfbNxhJXNe1ijaEzkoIS4/PLgZWbEJFdfbf1/Yn/
	qniOmr7BaERwKNDeLjsOI0aayRvqWF+s0K3RSA7+joDbpD0kW2iiY1VAMIuRoB64jTeNz6hbyIU
	QRNLhkGVcFmHASfzqh9y6klmwXyg=
X-Google-Smtp-Source: AGHT+IEgj/XDe6kFZqaWaYYe+y71Kj9Yn2Ks13EdRK/Qy4G52y3K8YT3mGl9gQ7ntvpOJ4QcrylfF37qcDWfjCVkyoU=
X-Received: by 2002:a05:6402:b62:b0:572:1fb7:2a77 with SMTP id
 cb2-20020a0564020b6200b005721fb72a77mr1423696edb.6.1713861978664; Tue, 23 Apr
 2024 01:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240422175522.4614-1-vincent.fu@samsung.com> <20240422175522.4614-3-vincent.fu@samsung.com>
In-Reply-To: <20240422175522.4614-3-vincent.fu@samsung.com>
From: Ankit Kumar <ankit1455@gmail.com>
Date: Tue, 23 Apr 2024 14:06:49 +0530
Message-ID: <CAKi7+wcrvg4_ouCU2HUEWjA-TKwbTkc0xHjq5fGiufYw=hQWig@mail.gmail.com>
Subject: Re: [PATCH 2/9] fio: create over-arching data placement option
To: Vincent Fu <vincentfu@gmail.com>
Cc: axboe@kernel.dk, ankit.kumar@samsung.com, kbusch@kernel.org, 
	fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

-               .lname  =3D "FDP Placement ID select",
+               .name   =3D "dataplacement",

Wondering if instead of dataplacement we should use data_placement. I
am ok either way.

On Mon, Apr 22, 2024 at 11:26=E2=80=AFPM Vincent Fu <vincentfu@gmail.com> w=
rote:
>
> Since FDP and streams are similar, we should have an over-arching data
> placement option that encompasses both of these frameworks instead of
> having separate sets of similar options for FDP and streams.
>
> With a common set of options, users will be able to select the data
> placement strategy (fdp or streams), the placement identifiers to use,
> and the algorithm for selecting from the list of placement identifiers.
>
> The original set of FDP options is retained for backward compatibility.
>
> No functional change.
>
> Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
> ---
>  cconv.c          | 18 +++++++++-------
>  dataplacement.c  | 14 ++++++-------
>  dataplacement.h  | 11 ++++++++--
>  filesetup.c      |  2 +-
>  init.c           | 10 ++++++++-
>  io_u.c           |  2 +-
>  options.c        | 54 +++++++++++++++++++++++++++++++++++-------------
>  server.h         |  2 +-
>  thread_options.h | 15 +++++++-------
>  9 files changed, 86 insertions(+), 42 deletions(-)
>
> diff --git a/cconv.c b/cconv.c
> index ead47248..16112248 100644
> --- a/cconv.c
> +++ b/cconv.c
> @@ -354,10 +354,11 @@ int convert_thread_options_to_cpu(struct thread_opt=
ions *o,
>                 o->merge_blktrace_iters[i].u.f =3D fio_uint64_to_double(l=
e64_to_cpu(top->merge_blktrace_iters[i].u.i));
>
>         o->fdp =3D le32_to_cpu(top->fdp);
> -       o->fdp_pli_select =3D le32_to_cpu(top->fdp_pli_select);
> -       o->fdp_nrpli =3D le32_to_cpu(top->fdp_nrpli);
> -       for (i =3D 0; i < o->fdp_nrpli; i++)
> -               o->fdp_plis[i] =3D le32_to_cpu(top->fdp_plis[i]);
> +       o->dp_type =3D le32_to_cpu(top->dp_type);
> +       o->dp_id_select =3D le32_to_cpu(top->dp_id_select);
> +       o->dp_nr_ids =3D le32_to_cpu(top->dp_nr_ids);
> +       for (i =3D 0; i < o->dp_nr_ids; i++)
> +               o->dp_ids[i] =3D le32_to_cpu(top->dp_ids[i]);
>  #if 0
>         uint8_t cpumask[FIO_TOP_STR_MAX];
>         uint8_t verify_cpumask[FIO_TOP_STR_MAX];
> @@ -652,10 +653,11 @@ void convert_thread_options_to_net(struct thread_op=
tions_pack *top,
>                 top->merge_blktrace_iters[i].u.i =3D __cpu_to_le64(fio_do=
uble_to_uint64(o->merge_blktrace_iters[i].u.f));
>
>         top->fdp =3D cpu_to_le32(o->fdp);
> -       top->fdp_pli_select =3D cpu_to_le32(o->fdp_pli_select);
> -       top->fdp_nrpli =3D cpu_to_le32(o->fdp_nrpli);
> -       for (i =3D 0; i < o->fdp_nrpli; i++)
> -               top->fdp_plis[i] =3D cpu_to_le32(o->fdp_plis[i]);
> +       top->dp_type =3D cpu_to_le32(o->dp_type);
> +       top->dp_id_select =3D cpu_to_le32(o->dp_id_select);
> +       top->dp_nr_ids =3D cpu_to_le32(o->dp_nr_ids);
> +       for (i =3D 0; i < o->dp_nr_ids; i++)
> +               top->dp_ids[i] =3D cpu_to_le32(o->dp_ids[i]);
>  #if 0
>         uint8_t cpumask[FIO_TOP_STR_MAX];
>         uint8_t verify_cpumask[FIO_TOP_STR_MAX];
> diff --git a/dataplacement.c b/dataplacement.c
> index 7518d193..a7170863 100644
> --- a/dataplacement.c
> +++ b/dataplacement.c
> @@ -59,13 +59,13 @@ static int init_ruh_info(struct thread_data *td, stru=
ct fio_file *f)
>         if (ruhs->nr_ruhs > FDP_MAX_RUHS)
>                 ruhs->nr_ruhs =3D FDP_MAX_RUHS;
>
> -       if (td->o.fdp_nrpli =3D=3D 0) {
> +       if (td->o.dp_nr_ids =3D=3D 0) {
>                 f->ruhs_info =3D ruhs;
>                 return 0;
>         }
>
> -       for (i =3D 0; i < td->o.fdp_nrpli; i++) {
> -               if (td->o.fdp_plis[i] >=3D ruhs->nr_ruhs) {
> +       for (i =3D 0; i < td->o.dp_nr_ids; i++) {
> +               if (td->o.dp_ids[i] >=3D ruhs->nr_ruhs) {
>                         ret =3D -EINVAL;
>                         goto out;
>                 }
> @@ -77,9 +77,9 @@ static int init_ruh_info(struct thread_data *td, struct=
 fio_file *f)
>                 goto out;
>         }
>
> -       tmp->nr_ruhs =3D td->o.fdp_nrpli;
> -       for (i =3D 0; i < td->o.fdp_nrpli; i++)
> -               tmp->plis[i] =3D ruhs->plis[td->o.fdp_plis[i]];
> +       tmp->nr_ruhs =3D td->o.dp_nr_ids;
> +       for (i =3D 0; i < td->o.dp_nr_ids; i++)
> +               tmp->plis[i] =3D ruhs->plis[td->o.dp_ids[i]];
>         f->ruhs_info =3D tmp;
>  out:
>         sfree(ruhs);
> @@ -119,7 +119,7 @@ void dp_fill_dspec_data(struct thread_data *td, struc=
t io_u *io_u)
>                 return;
>         }
>
> -       if (td->o.fdp_pli_select =3D=3D FIO_FDP_RR) {
> +       if (td->o.dp_id_select =3D=3D FIO_DP_RR) {
>                 if (ruhs->pli_loc >=3D ruhs->nr_ruhs)
>                         ruhs->pli_loc =3D 0;
>
> diff --git a/dataplacement.h b/dataplacement.h
> index 72bd4c08..b6ceb5bc 100644
> --- a/dataplacement.h
> +++ b/dataplacement.h
> @@ -5,15 +5,22 @@
>
>  #define FDP_DIR_DTYPE  2
>  #define FDP_MAX_RUHS   128
> +#define FIO_MAX_DP_IDS         16
>
>  /*
>   * How fio chooses what placement identifier to use next. Choice of
>   * uniformly random, or roundrobin.
>   */
> +enum {
> +       FIO_DP_RANDOM   =3D 0x1,
> +       FIO_DP_RR       =3D 0x2,
> +};
> +
>
>  enum {
> -       FIO_FDP_RANDOM  =3D 0x1,
> -       FIO_FDP_RR      =3D 0x2,
> +       FIO_DP_NONE     =3D 0x0,
> +       FIO_DP_FDP      =3D 0x1,
> +       FIO_DP_STREAMS  =3D 0x2,
>  };
>
>  struct fio_ruhs_info {
> diff --git a/filesetup.c b/filesetup.c
> index 8923f2b3..6fbfced5 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -1411,7 +1411,7 @@ done:
>
>         td_restore_runstate(td, old_state);
>
> -       if (td->o.fdp) {
> +       if (td->o.dp_type =3D=3D FIO_DP_FDP) {
>                 err =3D dp_init(td);
>                 if (err)
>                         goto err_out;
> diff --git a/init.c b/init.c
> index 7a0b14a3..ff3e9a90 100644
> --- a/init.c
> +++ b/init.c
> @@ -1015,7 +1015,15 @@ static int fixup_options(struct thread_data *td)
>                 ret |=3D 1;
>         }
>
> -
> +       if (td->o.fdp) {
> +               if (fio_option_is_set(&td->o, dp_type) &&
> +                       (td->o.dp_type =3D=3D FIO_DP_STREAMS || td->o.dp_=
type =3D=3D FIO_DP_NONE)) {
> +                       log_err("fio: fdp=3D1 is not compatible with data=
placement=3D{streams, none}\n");
> +                       ret |=3D 1;
> +               } else {
> +                       td->o.dp_type =3D FIO_DP_FDP;
> +               }
> +       }
>         return ret;
>  }
>
> diff --git a/io_u.c b/io_u.c
> index 735d9005..e9b94c48 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1065,7 +1065,7 @@ static int fill_io_u(struct thread_data *td, struct=
 io_u *io_u)
>                 }
>         }
>
> -       if (td->o.fdp)
> +       if (td->o.dp_type =3D=3D FIO_DP_FDP)
>                 dp_fill_dspec_data(td, io_u);
>
>         if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
> diff --git a/options.c b/options.c
> index de935efc..09a24652 100644
> --- a/options.c
> +++ b/options.c
> @@ -270,12 +270,12 @@ static int str_fdp_pli_cb(void *data, const char *i=
nput)
>         strip_blank_front(&str);
>         strip_blank_end(str);
>
> -       while ((v =3D strsep(&str, ",")) !=3D NULL && i < FIO_MAX_PLIS)
> -               td->o.fdp_plis[i++] =3D strtoll(v, NULL, 0);
> +       while ((v =3D strsep(&str, ",")) !=3D NULL && i < FIO_MAX_DP_IDS)
> +               td->o.dp_ids[i++] =3D strtoll(v, NULL, 0);
>         free(p);
>
> -       qsort(td->o.fdp_plis, i, sizeof(*td->o.fdp_plis), fio_fdp_cmp);
> -       td->o.fdp_nrpli =3D i;
> +       qsort(td->o.dp_ids, i, sizeof(*td->o.dp_ids), fio_fdp_cmp);
> +       td->o.dp_nr_ids =3D i;
>
>         return 0;
>  }
> @@ -3710,32 +3710,58 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
>                 .group  =3D FIO_OPT_G_INVALID,
>         },
>         {
> -               .name   =3D "fdp_pli_select",
> -               .lname  =3D "FDP Placement ID select",
> +               .name   =3D "dataplacement",
> +               .lname  =3D "Data Placement interface",
>                 .type   =3D FIO_OPT_STR,
> -               .off1   =3D offsetof(struct thread_options, fdp_pli_selec=
t),
> -               .help   =3D "Select which FDP placement ID to use next",
> +               .off1   =3D offsetof(struct thread_options, dp_type),
> +               .help   =3D "Data Placement interface to use",
> +               .def    =3D "none",
> +               .category =3D FIO_OPT_C_IO,
> +               .group  =3D FIO_OPT_G_INVALID,
> +               .posval =3D {
> +                         { .ival =3D "none",
> +                           .oval =3D FIO_DP_NONE,
> +                           .help =3D "Do not specify a data placement in=
terface",
> +                         },
> +                         { .ival =3D "fdp",
> +                           .oval =3D FIO_DP_FDP,
> +                           .help =3D "Use Flexible Data Placement interf=
ace",
> +                         },
> +                         { .ival =3D "streams",
> +                           .oval =3D FIO_DP_STREAMS,
> +                           .help =3D "Use Streams interface",
> +                         },
> +               },
> +       },
> +       {
> +               .name   =3D "plid_select",
> +               .alias  =3D "fdp_pli_select",
> +               .lname  =3D "Data Placement ID selection strategy",
> +               .type   =3D FIO_OPT_STR,
> +               .off1   =3D offsetof(struct thread_options, dp_id_select)=
,
> +               .help   =3D "Strategy for selecting next Data Placement I=
D",
>                 .def    =3D "roundrobin",
>                 .category =3D FIO_OPT_C_IO,
>                 .group  =3D FIO_OPT_G_INVALID,
>                 .posval =3D {
>                           { .ival =3D "random",
> -                           .oval =3D FIO_FDP_RANDOM,
> +                           .oval =3D FIO_DP_RANDOM,
>                             .help =3D "Choose a Placement ID at random (u=
niform)",
>                           },
>                           { .ival =3D "roundrobin",
> -                           .oval =3D FIO_FDP_RR,
> +                           .oval =3D FIO_DP_RR,
>                             .help =3D "Round robin select Placement IDs",
>                           },
>                 },
>         },
>         {
> -               .name   =3D "fdp_pli",
> -               .lname  =3D "FDP Placement ID indicies",
> +               .name   =3D "plids",
> +               .alias  =3D "fdp_pli",
> +               .lname  =3D "Stream IDs/Data Placement ID indices",
>                 .type   =3D FIO_OPT_STR,
>                 .cb     =3D str_fdp_pli_cb,
> -               .off1   =3D offsetof(struct thread_options, fdp_plis),
> -               .help   =3D "Sets which placement ids to use (defaults to=
 all)",
> +               .off1   =3D offsetof(struct thread_options, dp_ids),
> +               .help   =3D "Sets which Data Placement ids to use (defaul=
ts to all for FDP)",
>                 .hide   =3D 1,
>                 .category =3D FIO_OPT_C_IO,
>                 .group  =3D FIO_OPT_G_INVALID,
> diff --git a/server.h b/server.h
> index 6d2659b0..83ce449b 100644
> --- a/server.h
> +++ b/server.h
> @@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
>  };
>
>  enum {
> -       FIO_SERVER_VER                  =3D 103,
> +       FIO_SERVER_VER                  =3D 104,
>
>         FIO_SERVER_MAX_FRAGMENT_PDU     =3D 1024,
>         FIO_SERVER_MAX_CMD_MB           =3D 2048,
> diff --git a/thread_options.h b/thread_options.h
> index c2e71518..a36b7909 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -391,11 +391,11 @@ struct thread_options {
>         fio_fp64_t zrt;
>         fio_fp64_t zrf;
>
> -#define FIO_MAX_PLIS 16
>         unsigned int fdp;
> -       unsigned int fdp_pli_select;
> -       unsigned int fdp_plis[FIO_MAX_PLIS];
> -       unsigned int fdp_nrpli;
> +       unsigned int dp_type;
> +       unsigned int dp_id_select;
> +       unsigned int dp_ids[FIO_MAX_DP_IDS];
> +       unsigned int dp_nr_ids;
>
>         unsigned int log_entries;
>         unsigned int log_prio;
> @@ -709,9 +709,10 @@ struct thread_options_pack {
>         uint32_t log_prio;
>
>         uint32_t fdp;
> -       uint32_t fdp_pli_select;
> -       uint32_t fdp_plis[FIO_MAX_PLIS];
> -       uint32_t fdp_nrpli;
> +       uint32_t dp_type;
> +       uint32_t dp_id_select;
> +       uint32_t dp_ids[FIO_MAX_DP_IDS];
> +       uint32_t dp_nr_ids;
>
>         uint32_t num_range;
>         /*
> --
> 2.43.0
>
>
