Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE89436130
	for <fio@vger.kernel.org>; Wed, 28 Aug 2024 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724866714; cv=none; b=A653RM5sw2fU053+Fmdi8lQ4AyQktp7Co0zU8B2uz5JrXYo0VQv9cEujlYSA15i7E2AmkZ6XJpWi9mDAJSeXkScD4ftQhfkdNTCMhHd+5AUMsHyIOOBZrOQTa6LSSuCO3Psh1Sntg4KuNyCXnNR2/BGe4HiiJeRbxnlynPWHJw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724866714; c=relaxed/simple;
	bh=WxrFWutb/BkJiMs3URmGGogSDQVfuvIjhIuq3aOhPQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hS2GBv81BBkGQ2F+8+f+WhYwcAteRzazMbmr6K5cN5ginVEDtWbxDRxVeo2MOGUlS1EWAZuXNzyRsow0HVnCZHiMw6EVuUMBuyw2waYfEG9cMrC8DKui38z9R7EY9+kuHPZNGXcETLYovB2CA7TqUCLZCxSts7rwEWPzei0oIzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=kyP+yZ/m; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="kyP+yZ/m"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a86939e9d7cso45532466b.2
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 10:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1724866709; x=1725471509; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOLj4x1rTW10vYMcd4yJJZHdlTvX5unZmceQ8NSQcqg=;
        b=kyP+yZ/mj8ZSN3L74QofI21ktL8+tfbjXU/ciw/rYr68ZbrodTN7/W+UKfSVjqr3Bi
         gTQirQngnzHyW54Hbe98YSaf8cTbi3+sHUg0bVkN2NIPAY+knw6OrKkg7LhajTl09dd3
         qK49DM/xr10dtGgsnO4AbKphP7O8E8psgwk0XzSevTdUamMaBq0MFkGWBukMOEjoTFps
         qrLU8fhEFyLPAzFSCa75UV4ub++fYJ/pFvU8uM6zdwp0lZdj9gXYCz4txJHD3nDiMjPu
         /Xev8TYPOpevCXl2FLfrXpr+gJtkMZM5EXrCpDPrzcjLazP0tsm8xKi92uLn/vV6EBp1
         uHsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724866709; x=1725471509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pOLj4x1rTW10vYMcd4yJJZHdlTvX5unZmceQ8NSQcqg=;
        b=jXVfUgDiPB6ocnFPl2Wm+vfF51AnKTq5SC8ZVS6+zp8yow3gyFCK6WgSiNqhxCmsq6
         vRo872EjFXBXsm238vItu+Qhn+/tUSB0e9q+ImjhW0Rhovyvx54aR9ha59fQJhhWGeC0
         x9V7XpWLG5AV+sQtNl0hKfUqDeo1o8PlsNlJdpVvpHvNBehM8Lagg/g9tNeKTW/by9Xt
         fCsocgGAOiZgfX43pfOIe5B4RPp2sVDO4lzZe9ceowy0WkZ0RtOP3+aMcgeJn3EmIceF
         mF8nXLfquqoqeNuEulSYQMrR2HPXjAXb1SohDAE8GdmZu3FhP55PW3k8DXTZhe+s0GMq
         0SPw==
X-Gm-Message-State: AOJu0Yz2apkoJIla+MwbkSAPpC/5pG7+ZUjw1LZEGyPgeUYJuYThK7ij
	RzOyoajsR8nCCbxmQz6vzP3Tll7SE9L7VT6Huze9dZ8tdUH7wJLG3014msukzmETrcaMjtGFgPR
	zSUvUxNzZQrU17EjWgSjyBNExRWllh8/sDsqVOz9d8zqjrHbP4MVeZg==
X-Google-Smtp-Source: AGHT+IGMU/QynS43KZmRqiRcp6Rdt2dcy+pOoWGQO9FxD4vwZnEycYRVCvhRBFRb89gNqWcb39KFu3I/fU0F7KT7Oos=
X-Received: by 2002:a17:907:3f1a:b0:a80:a23e:fbf9 with SMTP id
 a640c23a62f3a-a897fa71a4fmr5913266b.6.1724866708638; Wed, 28 Aug 2024
 10:38:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com> <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Wed, 28 Aug 2024 12:38:16 -0500
Message-ID: <CADqNVTqZJ6oB6QsZcKgeP+dsCmFJug=pPQJbrhgbYSNo1+1Rcg@mail.gmail.com>
Subject: Re: [PATCH 5/9] introduce the log_issue_time option
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>, 
	Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 2:09=E2=80=AFAM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> When write_lat_log option is set, fio outputs the 'clat' completion
> latency log file. This clat log can be used to analyze IO latency. This
> file can also be considered as an IO trace file as each IO entry can
> fully describe an IO when the --log_offset and --log_prio options are
> also used.
>
> However, using the clat log file as an IO trace is inaccuate due to two
> reasons. Firstly, the time field of each entry uses millisecond units,
> which is too coarse for fast IOs (e.g. when using SSDs). Secondly, the
> time field value is recorded not at command completion, but at log
> sample recording. The time field value is slightly different from the IO
> completion time. It can be used only as an approximated completion time.
>
> To analyze IO issue time and IO completion time accurately using the
> clat log, introduce the new option 'log_issue_time'. When this option is
> set, add another field to the log file entries and put the IO issue time
> in nanosecond to the field. The IO completion time can be calculated by
> adding the completion latency to the IO issue time.
>
> The IO issue time field is added to 'slat' submit latency log file also.
> This helps to calculate IO start time by subtracting the submission
> latency from the IO issue time.
>
> The log_issue_time option can be used for IO trace when the
> write_lat_log option and the log_offset options are set together. When
> the log_issue_time option is set but the write_lat_log option or the
> log_offset option is not set, fio errors out. When the log_issue_time
> option and the write_lat_log option are set together with other
> write_X_log options, the IO issue time field is added to all log files.
> As for the other log files than clat and slat log, the IO issue time
> does not have meaning then '0' is set to the field. When log_avg_msec
> option is set, average of the log values of the specified duration is
> logged. The IO issue time does not have meaning in this case either and
> '0' is set to the field.
>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  cconv.c          |  2 ++
>  client.c         | 30 ++++++++++++++++++++----------
>  init.c           | 12 ++++++++++++
>  iolog.c          | 29 +++++++++++++++++++++--------
>  iolog.h          | 30 ++++++++++++++++++++++++------
>  options.c        | 10 ++++++++++
>  server.c         |  4 ++++
>  server.h         |  1 +
>  stat.c           | 24 +++++++++++++++---------
>  thread_options.h |  2 ++
>  10 files changed, 111 insertions(+), 33 deletions(-)
>
> diff --git a/cconv.c b/cconv.c
> index 1d494982..9571f1a8 100644
> --- a/cconv.c
> +++ b/cconv.c
> @@ -216,6 +216,7 @@ int convert_thread_options_to_cpu(struct thread_optio=
ns *o,
>         o->log_max =3D le32_to_cpu(top->log_max);
>         o->log_offset =3D le32_to_cpu(top->log_offset);
>         o->log_prio =3D le32_to_cpu(top->log_prio);
> +       o->log_issue_time =3D le32_to_cpu(top->log_issue_time);
>         o->log_gz =3D le32_to_cpu(top->log_gz);
>         o->log_gz_store =3D le32_to_cpu(top->log_gz_store);
>         o->log_alternate_epoch =3D le32_to_cpu(top->log_alternate_epoch);
> @@ -458,6 +459,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,
>         top->log_max =3D cpu_to_le32(o->log_max);
>         top->log_offset =3D cpu_to_le32(o->log_offset);
>         top->log_prio =3D cpu_to_le32(o->log_prio);
> +       top->log_issue_time =3D cpu_to_le32(o->log_issue_time);
>         top->log_gz =3D cpu_to_le32(o->log_gz);
>         top->log_gz_store =3D cpu_to_le32(o->log_gz_store);
>         top->log_alternate_epoch =3D cpu_to_le32(o->log_alternate_epoch);
> diff --git a/client.c b/client.c
> index 0b6044dd..5964faba 100644
> --- a/client.c
> +++ b/client.c
> @@ -1388,8 +1388,8 @@ static void handle_eta(struct fio_client *client, s=
truct fio_net_cmd *cmd)
>  static void client_flush_hist_samples(FILE *f, int hist_coarseness, void=
 *samples,
>                                       uint64_t sample_size)
>  {
> -       struct io_sample *s;
> -       int log_offset;
> +       struct io_sample *s, *s_tmp;
> +       bool log_offset, log_issue_time;
>         uint64_t i, j, nr_samples;
>         struct io_u_plat_entry *entry;
>         uint64_t *io_u_plat;
> @@ -1399,15 +1399,17 @@ static void client_flush_hist_samples(FILE *f, in=
t hist_coarseness, void *sample
>         if (!sample_size)
>                 return;
>
> -       s =3D __get_sample(samples, 0, 0);
> +       s =3D __get_sample(samples, 0, 0, 0);
>         log_offset =3D (s->__ddir & LOG_OFFSET_SAMPLE_BIT) !=3D 0;
> +       log_issue_time =3D (s->__ddir & LOG_ISSUE_TIME_SAMPLE_BIT) !=3D 0=
;
>
> -       nr_samples =3D sample_size / __log_entry_sz(log_offset);
> +       nr_samples =3D sample_size / __log_entry_sz(log_offset, log_issue=
_time);
>
>         for (i =3D 0; i < nr_samples; i++) {
>
> -               s =3D (struct io_sample *)((char *)__get_sample(samples, =
log_offset, i) +
> -                       i * sizeof(struct io_u_plat_entry));
> +               s_tmp =3D __get_sample(samples, log_offset, log_issue_tim=
e, i);
> +               s =3D (struct io_sample *)((char *)s_tmp +
> +                                        i * sizeof(struct io_u_plat_entr=
y));
>
>                 entry =3D s->data.plat_entry;
>                 io_u_plat =3D entry->io_u_plat;
> @@ -1595,6 +1597,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struc=
t fio_net_cmd *cmd,
>         uint64_t nr_samples;
>         size_t total;
>         char *p;
> +       size_t log_entry_size;
>
>         stream.zalloc =3D Z_NULL;
>         stream.zfree =3D Z_NULL;
> @@ -1610,11 +1613,13 @@ static struct cmd_iolog_pdu *convert_iolog_gz(str=
uct fio_net_cmd *cmd,
>          */
>         nr_samples =3D le64_to_cpu(pdu->nr_samples);
>
> +       log_entry_size =3D __log_entry_sz(le32_to_cpu(pdu->log_offset),
> +                                       le32_to_cpu(pdu->log_issue_time))=
;
>         if (pdu->log_type =3D=3D IO_LOG_TYPE_HIST)
> -               total =3D nr_samples * (__log_entry_sz(le32_to_cpu(pdu->l=
og_offset)) +
> -                                       sizeof(struct io_u_plat_entry));
> +               total =3D nr_samples * (log_entry_size +
> +                                     sizeof(struct io_u_plat_entry));
>         else
> -               total =3D nr_samples * __log_entry_sz(le32_to_cpu(pdu->lo=
g_offset));
> +               total =3D nr_samples * log_entry_size;
>         ret =3D malloc(total + sizeof(*pdu));
>         ret->nr_samples =3D nr_samples;
>
> @@ -1703,6 +1708,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct f=
io_net_cmd *cmd,
>         ret->compressed         =3D le32_to_cpu(ret->compressed);
>         ret->log_offset         =3D le32_to_cpu(ret->log_offset);
>         ret->log_prio           =3D le32_to_cpu(ret->log_prio);
> +       ret->log_issue_time     =3D le32_to_cpu(ret->log_issue_time);
>         ret->log_hist_coarseness =3D le32_to_cpu(ret->log_hist_coarseness=
);
>         ret->per_job_logs       =3D le32_to_cpu(ret->per_job_logs);
>
> @@ -1713,7 +1719,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct f=
io_net_cmd *cmd,
>         for (i =3D 0; i < ret->nr_samples; i++) {
>                 struct io_sample *s;
>
> -               s =3D __get_sample(samples, ret->log_offset, i);
> +               s =3D __get_sample(samples, ret->log_offset, ret->log_iss=
ue_time, i);
>                 if (ret->log_type =3D=3D IO_LOG_TYPE_HIST)
>                         s =3D (struct io_sample *)((char *)s + sizeof(str=
uct io_u_plat_entry) * i);
>
> @@ -1730,6 +1736,10 @@ static struct cmd_iolog_pdu *convert_iolog(struct =
fio_net_cmd *cmd,
>                         s->aux[IOS_AUX_OFFSET_INDEX] =3D
>                                 le64_to_cpu(s->aux[IOS_AUX_OFFSET_INDEX])=
;
>
> +               if (ret->log_issue_time)
> +                       s->aux[IOS_AUX_ISSUE_TIME_INDEX] =3D
> +                               le64_to_cpu(s->aux[IOS_AUX_ISSUE_TIME_IND=
EX]);
> +
>                 if (ret->log_type =3D=3D IO_LOG_TYPE_HIST) {
>                         s->data.plat_entry =3D (struct io_u_plat_entry *)=
(((char *)s) + sizeof(*s));
>                         s->data.plat_entry->list.next =3D NULL;
> diff --git a/init.c b/init.c
> index ff3e9a90..3b213c0e 100644
> --- a/init.c
> +++ b/init.c
> @@ -1621,12 +1621,18 @@ static int add_job(struct thread_data *td, const =
char *jobname, int job_add_num,
>                         .log_type =3D IO_LOG_TYPE_LAT,
>                         .log_offset =3D o->log_offset,
>                         .log_prio =3D o->log_prio,
> +                       .log_issue_time =3D o->log_issue_time,
>                         .log_gz =3D o->log_gz,
>                         .log_gz_store =3D o->log_gz_store,
>                 };
>                 const char *pre =3D make_log_name(o->lat_log_file, o->nam=
e);
>                 const char *suf;
>
> +               if (o->log_issue_time && !o->log_offset) {
> +                       log_err("fio: log_issue_time option requires log_=
write_lat_log and log_offset options\n");
> +                       goto err;
> +               }
> +
>                 if (p.log_gz_store)
>                         suf =3D "log.fz";
>                 else
> @@ -1650,6 +1656,9 @@ static int add_job(struct thread_data *td, const ch=
ar *jobname, int job_add_num,
>                         setup_log(&td->clat_log, &p, logname);
>                 }
>
> +       } else if (o->log_issue_time) {
> +               log_err("fio: log_issue_time option requires log_write_la=
t_log and log_offset options\n");
> +               goto err;
>         }
>
>         if (o->write_hist_log) {
> @@ -1661,6 +1670,7 @@ static int add_job(struct thread_data *td, const ch=
ar *jobname, int job_add_num,
>                         .log_type =3D IO_LOG_TYPE_HIST,
>                         .log_offset =3D o->log_offset,
>                         .log_prio =3D o->log_prio,
> +                       .log_issue_time =3D o->log_issue_time,
>                         .log_gz =3D o->log_gz,
>                         .log_gz_store =3D o->log_gz_store,
>                 };
> @@ -1693,6 +1703,7 @@ static int add_job(struct thread_data *td, const ch=
ar *jobname, int job_add_num,
>                         .log_type =3D IO_LOG_TYPE_BW,
>                         .log_offset =3D o->log_offset,
>                         .log_prio =3D o->log_prio,
> +                       .log_issue_time =3D o->log_issue_time,
>                         .log_gz =3D o->log_gz,
>                         .log_gz_store =3D o->log_gz_store,
>                 };
> @@ -1725,6 +1736,7 @@ static int add_job(struct thread_data *td, const ch=
ar *jobname, int job_add_num,
>                         .log_type =3D IO_LOG_TYPE_IOPS,
>                         .log_offset =3D o->log_offset,
>                         .log_prio =3D o->log_prio,
> +                       .log_issue_time =3D o->log_issue_time,
>                         .log_gz =3D o->log_gz,
>                         .log_gz_store =3D o->log_gz_store,
>                 };
> diff --git a/iolog.c b/iolog.c
> index bb1ade86..aadb0d05 100644
> --- a/iolog.c
> +++ b/iolog.c
> @@ -845,6 +845,7 @@ void setup_log(struct io_log **log, struct log_params=
 *p,
>         l->log_type =3D p->log_type;
>         l->log_offset =3D p->log_offset;
>         l->log_prio =3D p->log_prio;
> +       l->log_issue_time =3D p->log_issue_time;
>         l->log_gz =3D p->log_gz;
>         l->log_gz_store =3D p->log_gz_store;
>         l->avg_msec =3D p->avg_msec;
> @@ -887,6 +888,9 @@ void setup_log(struct io_log **log, struct log_params=
 *p,
>         if (l->td && l->td->o.log_max =3D=3D IO_LOG_SAMPLE_BOTH)
>                 l->log_ddir_mask |=3D LOG_AVG_MAX_SAMPLE_BIT;
>
> +       if (l->log_issue_time)
> +               l->log_ddir_mask |=3D LOG_ISSUE_TIME_SAMPLE_BIT;
> +
>         INIT_FLIST_HEAD(&l->chunk_list);
>
>         if (l->log_gz && !p->td)
> @@ -969,7 +973,7 @@ static void flush_hist_samples(FILE *f, int hist_coar=
seness, void *samples,
>                                uint64_t sample_size)
>  {
>         struct io_sample *s;
> -       int log_offset;
> +       bool log_offset, log_issue_time;
>         uint64_t i, j, nr_samples;
>         struct io_u_plat_entry *entry, *entry_before;
>         uint64_t *io_u_plat;
> @@ -980,13 +984,14 @@ static void flush_hist_samples(FILE *f, int hist_co=
arseness, void *samples,
>         if (!sample_size)
>                 return;
>
> -       s =3D __get_sample(samples, 0, 0);
> +       s =3D __get_sample(samples, 0, 0, 0);
>         log_offset =3D (s->__ddir & LOG_OFFSET_SAMPLE_BIT) !=3D 0;
> +       log_issue_time =3D (s->__ddir & LOG_ISSUE_TIME_SAMPLE_BIT) !=3D 0=
;
>
> -       nr_samples =3D sample_size / __log_entry_sz(log_offset);
> +       nr_samples =3D sample_size / __log_entry_sz(log_offset, log_issue=
_time);
>
>         for (i =3D 0; i < nr_samples; i++) {
> -               s =3D __get_sample(samples, log_offset, i);
> +               s =3D __get_sample(samples, log_offset, log_issue_time, i=
);
>
>                 entry =3D s->data.plat_entry;
>                 io_u_plat =3D entry->io_u_plat;
> @@ -1038,7 +1043,7 @@ static int print_sample_fields(char **p, size_t *le=
ft, const char *fmt, ...) {
>  void flush_samples(FILE *f, void *samples, uint64_t sample_size)
>  {
>         struct io_sample *s;
> -       bool log_offset, log_prio, log_avg_max;
> +       bool log_offset, log_prio, log_avg_max, log_issue_time;
>         uint64_t i, nr_samples;
>         char buf[256];
>         char *p;
> @@ -1048,15 +1053,16 @@ void flush_samples(FILE *f, void *samples, uint64=
_t sample_size)
>         if (!sample_size)
>                 return;
>
> -       s =3D __get_sample(samples, 0, 0);
> +       s =3D __get_sample(samples, 0, 0, 0);
>         log_offset =3D (s->__ddir & LOG_OFFSET_SAMPLE_BIT) !=3D 0;
>         log_prio =3D (s->__ddir & LOG_PRIO_SAMPLE_BIT) !=3D 0;
>         log_avg_max =3D (s->__ddir & LOG_AVG_MAX_SAMPLE_BIT) !=3D 0;
> +       log_issue_time =3D (s->__ddir & LOG_ISSUE_TIME_SAMPLE_BIT) !=3D 0=
;
>
> -       nr_samples =3D sample_size / __log_entry_sz(log_offset);
> +       nr_samples =3D sample_size / __log_entry_sz(log_offset, log_issue=
_time);
>
>         for (i =3D 0; i < nr_samples; i++) {
> -               s =3D __get_sample(samples, log_offset, i);
> +               s =3D __get_sample(samples, log_offset, log_issue_time, i=
);
>                 p =3D buf;
>                 left =3D sizeof(buf);
>
> @@ -1094,6 +1100,13 @@ void flush_samples(FILE *f, void *samples, uint64_=
t sample_size)
>                 if (ret)
>                         return;
>
> +               if (log_issue_time) {
> +                       ret =3D print_sample_fields(&p, &left, ", %llu",
> +                                                 (unsigned long long) s-=
>aux[IOS_AUX_ISSUE_TIME_INDEX]);
> +                       if (ret)
> +                               return;
> +               }
> +
>                 fprintf(f, "%s\n", buf);
>         }
>  }
> diff --git a/iolog.h b/iolog.h
> index d868921b..e864d169 100644
> --- a/iolog.h
> +++ b/iolog.h
> @@ -62,6 +62,7 @@ struct io_sample {
>   */
>  enum {
>         IOS_AUX_OFFSET_INDEX,
> +       IOS_AUX_ISSUE_TIME_INDEX,
>  };
>
>  enum {
> @@ -122,6 +123,11 @@ struct io_log {
>          */
>         unsigned int log_prio;
>
> +       /*
> +        * Log I/O issuing time
> +        */
> +       unsigned int log_issue_time;
> +
>         /*
>          * Max size of log entries before a chunk is compressed
>          */
> @@ -171,9 +177,14 @@ struct io_log {
>   * If the bit following prioity sample vit is set, we report both avg an=
d max
>   */
>  #define LOG_AVG_MAX_SAMPLE_BIT 0x20000000U
> +/*
> + * If the bit following AVG_MAX_SAMPLE_BIT is set, we report the issue t=
ime also
> + */
> +#define LOG_ISSUE_TIME_SAMPLE_BIT      0x10000000U
>
>  #define LOG_SAMPLE_BITS                (LOG_OFFSET_SAMPLE_BIT | LOG_PRIO=
_SAMPLE_BIT |\
> -                                       LOG_AVG_MAX_SAMPLE_BIT)
> +                                       LOG_AVG_MAX_SAMPLE_BIT |\
> +                                       LOG_ISSUE_TIME_SAMPLE_BIT)
>  #define io_sample_ddir(io)     ((io)->__ddir & ~LOG_SAMPLE_BITS)
>
>  static inline void io_sample_set_ddir(struct io_log *log,
> @@ -183,19 +194,22 @@ static inline void io_sample_set_ddir(struct io_log=
 *log,
>         io->__ddir =3D ddir | log->log_ddir_mask;
>  }
>
> -static inline size_t __log_entry_sz(bool log_offset)
> +static inline size_t __log_entry_sz(bool log_offset, bool log_issue_time=
)
>  {
>         size_t ret =3D sizeof(struct io_sample);
>
>         if (log_offset)
>                 ret +=3D sizeof(uint64_t);
>
> +       if (log_issue_time)
> +               ret +=3D sizeof(uint64_t);
> +
>         return ret;
>  }
>
>  static inline size_t log_entry_sz(struct io_log *log)
>  {
> -       return __log_entry_sz(log->log_offset);
> +       return __log_entry_sz(log->log_offset, log->log_issue_time);
>  }
>
>  static inline size_t log_sample_sz(struct io_log *log, struct io_logs *c=
ur_log)
> @@ -203,10 +217,12 @@ static inline size_t log_sample_sz(struct io_log *l=
og, struct io_logs *cur_log)
>         return cur_log->nr_samples * log_entry_sz(log);
>  }
>
> -static inline struct io_sample *__get_sample(void *samples, int log_offs=
et,
> +static inline struct io_sample *__get_sample(void *samples, bool log_off=
set,
> +                                            bool log_issue_time,
>                                              uint64_t sample)
>  {
> -       uint64_t sample_offset =3D sample * __log_entry_sz(log_offset);
> +       uint64_t sample_offset =3D sample *
> +               __log_entry_sz(log_offset, log_issue_time);
>         return (struct io_sample *) ((char *) samples + sample_offset);
>  }
>
> @@ -219,7 +235,8 @@ static inline struct io_sample *get_sample(struct io_=
log *iolog,
>                                            struct io_logs *cur_log,
>                                            uint64_t sample)
>  {
> -       return __get_sample(cur_log->log, iolog->log_offset, sample);
> +       return __get_sample(cur_log->log,
> +                           iolog->log_offset, iolog->log_issue_time, sam=
ple);
>  }
>
>  enum {
> @@ -295,6 +312,7 @@ struct log_params {
>         int log_type;
>         int log_offset;
>         int log_prio;
> +       int log_issue_time;
>         int log_gz;
>         int log_gz_store;
>         int log_compress;
> diff --git a/options.c b/options.c
> index ab650bb7..73fd4a7f 100644
> --- a/options.c
> +++ b/options.c
> @@ -4727,6 +4727,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
>                 .category =3D FIO_OPT_C_LOG,
>                 .group  =3D FIO_OPT_G_INVALID,
>         },
> +       {
> +               .name   =3D "log_issue_time",
> +               .lname  =3D "Log IO issue time",
> +               .type   =3D FIO_OPT_BOOL,
> +               .off1   =3D offsetof(struct thread_options, log_issue_tim=
e),
> +               .help   =3D "Include IO issue time for each log entry",
> +               .def    =3D "0",
> +               .category =3D FIO_OPT_C_LOG,
> +               .group  =3D FIO_OPT_G_INVALID,
> +       },
>  #ifdef CONFIG_ZLIB
>         {
>                 .name   =3D "log_compression",
> diff --git a/server.c b/server.c
> index dbb9eb5e..5967f421 100644
> --- a/server.c
> +++ b/server.c
> @@ -2298,6 +2298,10 @@ int fio_send_iolog(struct thread_data *td, struct =
io_log *log, const char *name)
>                         if (log->log_offset)
>                                 s->aux[IOS_AUX_OFFSET_INDEX] =3D
>                                         cpu_to_le64(s->aux[IOS_AUX_OFFSET=
_INDEX]);
> +
> +                       if (log->log_issue_time)
> +                               s->aux[IOS_AUX_ISSUE_TIME_INDEX] =3D
> +                                       cpu_to_le64(s->aux[IOS_AUX_ISSUE_=
TIME_INDEX]);
>                 }
>         }
>
> diff --git a/server.h b/server.h
> index a8e4dbf2..2157da97 100644
> --- a/server.h
> +++ b/server.h
> @@ -197,6 +197,7 @@ struct cmd_iolog_pdu {
>         uint32_t compressed;
>         uint32_t log_offset;
>         uint32_t log_prio;
> +       uint32_t log_issue_time;
>         uint32_t log_hist_coarseness;
>         uint32_t per_job_logs;
>         uint8_t name[FIO_NET_NAME_MAX];
> diff --git a/stat.c b/stat.c
> index 56d04e7a..2cfd6819 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -30,6 +30,7 @@ struct log_sample {
>         uint64_t bs;
>         uint64_t offset;
>         uint16_t priority;
> +       uint64_t issue_time;
>  };
>
>  struct fio_sem *stat_sem;
> @@ -3066,6 +3067,9 @@ static void __add_log_sample(struct io_log *iolog, =
unsigned long t,
>                 if (iolog->log_offset)
>                         s->aux[IOS_AUX_OFFSET_INDEX] =3D sample->offset;
>
> +               if (iolog->log_issue_time)
> +                       s->aux[IOS_AUX_ISSUE_TIME_INDEX] =3D sample->issu=
e_time;
> +
>                 cur_log->nr_samples++;
>                 return;
>         }
> @@ -3160,7 +3164,7 @@ static void __add_stat_to_log(struct io_log *iolog,=
 enum fio_ddir ddir,
>          * had actual samples done.
>          */
>         if (iolog->avg_window[ddir].samples) {
> -               struct log_sample sample =3D { {{ 0, 0 }}, ddir, 0, 0, 0 =
};
> +               struct log_sample sample =3D { {{ 0, 0 }}, ddir, 0, 0, 0,=
 0 };
>                 union io_sample_data *d =3D &sample.data;
>
>                 if (log_max =3D=3D IO_LOG_SAMPLE_AVG) {
> @@ -3258,7 +3262,7 @@ void add_agg_sample(union io_sample_data data, enum=
 fio_ddir ddir,
>                     unsigned long long bs)
>  {
>         struct io_log *iolog;
> -       struct log_sample sample =3D { data, ddir, bs, 0, 0 };
> +       struct log_sample sample =3D { data, ddir, bs, 0, 0, 0 };
>
>         if (!ddir_rw(ddir))
>                 return;
> @@ -3336,7 +3340,8 @@ void add_clat_sample(struct thread_data *td, enum f=
io_ddir ddir,
>
>         if (td->clat_log) {
>                 struct log_sample sample =3D { sample_val(nsec), ddir, bs=
,
> -                       offset, ioprio };
> +                       offset, ioprio,
> +                       ntime_since(&td->epoch, &io_u->issue_time) };
>
>                 add_log_sample(td, td->clat_log, &sample);
>         }
> @@ -3366,7 +3371,7 @@ void add_clat_sample(struct thread_data *td, enum f=
io_ddir ddir,
>                         uint64_t *io_u_plat;
>                         struct io_u_plat_entry *dst;
>                         struct log_sample sample =3D { {{ 0, 0 }}, ddir, =
bs,
> -                               offset, ioprio };
> +                               offset, ioprio, 0 };
>
>                         /*
>                          * Make a byte-for-byte copy of the latency histo=
gram
> @@ -3418,7 +3423,8 @@ void add_slat_sample(struct thread_data *td, struct=
 io_u *io_u)
>
>         if (td->slat_log) {
>                 struct log_sample sample =3D { sample_val(nsec), ddir,
> -                       io_u->xfer_buflen, io_u->offset, io_u->ioprio };
> +                       io_u->xfer_buflen, io_u->offset, io_u->ioprio,
> +                       ntime_since(&td->epoch, &io_u->issue_time) };
>
>                 add_log_sample(td, td->slat_log, &sample);
>         }
> @@ -3447,7 +3453,7 @@ void add_lat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
>
>         if (td->lat_log) {
>                 struct log_sample sample =3D { sample_val(nsec), ddir, bs=
,
> -                       io_u->offset, io_u->ioprio };
> +                       io_u->offset, io_u->ioprio, 0 };
>
>                 add_log_sample(td, td->lat_log, &sample);
>         }
> @@ -3492,7 +3498,7 @@ void add_bw_sample(struct thread_data *td, struct i=
o_u *io_u,
>
>         if (td->bw_log) {
>                 struct log_sample sample =3D { sample_val(rate), io_u->dd=
ir,
> -                       bytes, io_u->offset, io_u->ioprio };
> +                       bytes, io_u->offset, io_u->ioprio, 0 };
>
>                 add_log_sample(td, td->bw_log, &sample);
>         }
> @@ -3545,7 +3551,7 @@ static int __add_samples(struct thread_data *td, st=
ruct timespec *parent_tv,
>
>                 if (log) {
>                         struct log_sample sample =3D {
> -                               sample_val(rate), ddir, 0, 0, 0 };
> +                               sample_val(rate), ddir, 0, 0, 0, 0 };
>
>                         if (td->o.min_bs[ddir] =3D=3D td->o.max_bs[ddir])
>                                 sample.bs =3D td->o.min_bs[ddir];
> @@ -3589,7 +3595,7 @@ void add_iops_sample(struct thread_data *td, struct=
 io_u *io_u,
>
>         if (td->iops_log) {
>                 struct log_sample sample =3D { sample_val(1), io_u->ddir,=
 bytes,
> -                       io_u->offset, io_u->ioprio };
> +                       io_u->offset, io_u->ioprio, 0 };
>
>                 add_log_sample(td, td->iops_log, &sample);
>         }
> diff --git a/thread_options.h b/thread_options.h
> index 20fc18a3..ee1e5b31 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -400,6 +400,7 @@ struct thread_options {
>
>         unsigned int log_entries;
>         unsigned int log_prio;
> +       unsigned int log_issue_time;
>  };
>
>  #define FIO_TOP_STR_MAX                256
> @@ -708,6 +709,7 @@ struct thread_options_pack {
>
>         uint32_t log_entries;
>         uint32_t log_prio;
> +       uint32_t log_issue_time;
>
>         uint32_t fdp;
>         uint32_t dp_type;
> --
> 2.45.2
>
>

I am really excited to see this set of changes! I've been wanting (but
not had time) to have a single-file log output with all of the
information present, and this helps towards that while also achieving
its trace file goal.

Do you have any thoughts on eventually including the submit time or
submit latency in the clat file as well? Then one would have a single
file without any of the redundancies involved with multiple files.

I've also thought a bit about having a non-text but portable output
file option, like protobuf. The files are large, and gzip compresses
the per-I/O logs well, but I imagine protobuf would be a big win for
both outputting and ingesting the log files, and would be way smaller
than the non-compressed log files.

Thanks for the new feature and any input on my thoughts!
- Nick
