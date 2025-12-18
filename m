Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1F350A16
	for <fio@vger.kernel.org>; Thu, 18 Dec 2025 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766071167; cv=none; b=OZQmVHDbJabA+k0wf9O/sMCfsbSqlIA+yQ4rxne1LpeDHtIbny3qZCDd5qvCBZeQHVo9uQOV6P9kRcXEkOE9gNHCjJYE8Q4dOK9sLuylpuGJInLATJsjvSUyDcHgjsENR4yR/hEj7j1FVyT0YC2UF5Xj8XDFJsP4q9mwQLDiCWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766071167; c=relaxed/simple;
	bh=gJg0XkoEiHT/0JrKdl37sabNDgE1CQzd62dY1WsLhnI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=irWYLexxi4tH/j4IU4GLA7cEPzUFoLBIQO6TYIOWxjjZs21fodeersuv8rBve+VpJSZR4d7gJqN0kCVrdpbanCT+mp0ofyXkkUStkW+2NBB2K8swAu9WK30YuRr8b61Jh1ZWNFGVXLQrQmzvYR7vKGLr1mn2LNHvy15WVdXbwcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YyywYZY8; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YyywYZY8"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-37fd6e91990so5595031fa.3
        for <fio@vger.kernel.org>; Thu, 18 Dec 2025 07:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766071164; x=1766675964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h16GKQkNYQHakyP1wLoQjWTERDqLv9U54RjYgX13Ffg=;
        b=YyywYZY8Sens8/TzZQ2tX0Dx26qvcWIfVFx1ZqubBLiFNzBiU96DK074o9RBcB/5tP
         na0RJjuDVH0NN3ALohbw1eSZult8CTkUhkA60zAe8ecVTzdAK7JSDOx7OQ2Ef0LE4md5
         C86J2Ou3Xun4XttkQ0QWgjeVjeeHiFEvo/3Xz0rkTD0bm+kCETYtWMPhZDND1TI+Uwm9
         zl201jpcDbDr/+0g/gJngs0Ymnt4X83pShwfdSAuo+uZ0atuQyl0V99kl/30OvcKWShU
         faux5/QwcRcLQr57d4h9YHxZKQY8+qd1T+qd3zN5dsvsv5l31Nsf5rbCfr0RgiYET8pB
         sKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766071164; x=1766675964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h16GKQkNYQHakyP1wLoQjWTERDqLv9U54RjYgX13Ffg=;
        b=d0MVcU2mEUG0zykBUuMM8QbJPU2xu2Xunjgig7bLiFdMW2jaUTL2yyKVlXOq9o6yvr
         UM+Y6hLXw+vbtoo18MdUY7saRpQijwPT6L6sTdVGuyK4yXdt3ChXeXjX5VwOay/aLmhj
         YgFUWXMYA1mQvKGdxuGiXv8wTM48vVRFE0JFQEYDe+gahLlSQZGwE2qcwPGHFY+UJFrK
         daJOjXQnpxDKi09/iPbOSR6XFE6fWPDftNZfxalGwwVrpp9q3IkzQUjProsVT6DyRHI8
         SwaUYJPuaIw7rNtc90pwPbye9lgtao7ttCahWfy+hkG9C2fNxt42Rk8g+GKHgN7RlFAD
         TvoQ==
X-Gm-Message-State: AOJu0Ywx2DoHkoknbKNshYzbtTin/cURNDijYmrQTPLZZmeZnT7Ng4qS
	HFUrHZgWoRYgzprSG/+mt8iAh5TmwAly2d/7oOAYfVWDkDpmZB+Gnd+OiIoy6uResyOQyO3Fpv/
	QIXQOA6IkFYYBBVq9xVIU2J6Q8YENSvQ=
X-Gm-Gg: AY/fxX72O81svMnUgQ5wQ6KU8Hle3hX033HjQqyDaTCadOLJo0Rk9yAUsHzG4rVa/zb
	IiLTtpAYkayDG6WPC46G3o0kmyehcOZrSupF/yUx23t+q4DlIdbVEvaHyzWpn4OpxGu/vr4HizX
	15TTP6Vpq9gthA7hnqS2cmsM2C/jWWHznISEHeohvXGx6sSpGZ1oilKD58q4IBuOahrxemGNXZK
	dGh4a19ZWYcB6GgQWrLEi46TD3BTNUFqgNPLCOJTchyKK3rBS50OMoI4o4Cc3qX3bRGiw==
X-Google-Smtp-Source: AGHT+IGG0RlrFcw1O8ciKaK7Ft3LShZdiA4in49ogLEkypNDiEk7chNqkWb31zw7YFT7nME2geRZvxTi4PAStFlXuLg=
X-Received: by 2002:a2e:ad93:0:b0:37f:c796:7867 with SMTP id
 38308e7fff4ca-37fd0792949mr63610331fa.13.1766071163987; Thu, 18 Dec 2025
 07:19:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217160217.15533-1-jack@suse.cz> <20251217161722.6357-5-jack@suse.cz>
In-Reply-To: <20251217161722.6357-5-jack@suse.cz>
From: Vincent Fu <vincentfu@gmail.com>
Date: Thu, 18 Dec 2025 10:19:12 -0500
X-Gm-Features: AQt7F2pWpEw83zoksN-eqWD00Iqi_TUxB7F7ilkoEMGqHb4VsmUVu9GlfOgbhC8
Message-ID: <CAOp=CXkbuuue6N=VVkqOX_vnsR+urtJWcizTTOG9LOWeCeihFA@mail.gmail.com>
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
To: Jan Kara <jack@suse.cz>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 11:17=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> In some cases the ramp up period is not easy to define by amount of
> time. This is for example a case of buffered writes measurement where we
> want to start measuring only once dirty throttling kicks in. The time
> until dirty throttling kicks in depends on dirty limit (easy to figure
> out) and speed of writes to the page cache (difficult to know in
> advance). Add option ramp_size which determines the ramp up period by
> the amount of IO written (either by each job or by each group when group
> reporting is enabled).
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  HOWTO.rst        |  7 +++++++
>  fio.1            |  6 ++++++
>  options.c        | 11 +++++++++++
>  thread_options.h |  2 ++
>  time.c           | 50 ++++++++++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 74 insertions(+), 2 deletions(-)
>
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 9f55a73bde05..49ebae6275a6 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -715,6 +715,13 @@ Time related parameters
>         :option:`runtime` is specified.  When the unit is omitted, the va=
lue is
>         given in seconds.
>
> +.. option:: ramp_size=3Dsize
> +
> +       If set, fio will wait until the workload does given amount of IO =
before
> +       logging any performance numbers. Similar considerations apply as =
for
> +       ``ramp_time`` option. When the unit is omitted, the value is give=
n in
> +       megabytes.
> +

At the very least the documentation should explain how this options works w=
ith
reporting groups.

Currently this patch compares the running total of the group's bytes to one
job's value for ramp_size and then declares ramp time over for all jobs in
the group if the threshold is exceeded. A little more thought should be put
into potential use cases here. Should fio allow ramp_size to differ among j=
obs
in a reporting group? Consider adding an option to enable/disable connectio=
ns
between jobs in the same reporting group.

Vincent
