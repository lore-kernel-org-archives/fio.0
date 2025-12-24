Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1AB23AB95
	for <fio@vger.kernel.org>; Wed, 24 Dec 2025 19:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766605469; cv=none; b=iX/LydrvdWVa2o614E1tq98pvMwunCAUeGK66l/AYwrA6100KsF4dJiPgJp91wuSGA02G7dO9PBhI6FM+1MVSHTGgD18v3f36TpQaSyC0WC6XWDhDtFlb/CcZsSTdEYJplx7y87EPSjKuvDzYPmO0NlDzTH6R4B1iKz3YAD5t+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766605469; c=relaxed/simple;
	bh=9m1RayFJkvNXASZwHOpzBtCUU0U7+v5/4I+SeNDUSgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cRvcisS6f2C2M/WS/9eaMrIWBFP4eoN8nSFL7imuimKQfxhdtrhFxceMW7IfoS2Y+YQ0akSPpUDfkBy+lg+6OeK7DyEtppr2EglXv7pbUjjoHJUKUKe2H6NLNDCtY6WURwwCeklAoH29Q3jZJa0PSA6wl765GhRx6RNf8wJWrmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CSnYAwjk; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSnYAwjk"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-597d712c0a7so6376964e87.0
        for <fio@vger.kernel.org>; Wed, 24 Dec 2025 11:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766605466; x=1767210266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wzdv0Dz7fDIsWscDqs9p/ZjSuEsl0aAxUwcckQlThsI=;
        b=CSnYAwjkzf4EaPmrv+Dl4S1f5sclZoBrwB8obagAYWBOY9EUbiRyhgn9z4OexNaEni
         3ZUv7Kr2j52UtbxJFjjwyf3Hex+wgghgnwjF8R6ak87qhMqRoY6uZ+67Xhybs8ZBlwpC
         XrQvTnBM8N1VcdBYCHQkJvYVv6+x2GXMz6C32fYgUZGoEbvol2WDNzU842ANEGFOd8nc
         uwTl+cumeyoJaYb9S1CoHElTBv9oGVwcBP/QOSpdKCT9ROzMpt0p9eBjfunWdNGCyo25
         fOMyOhzkO8cGqs/HPXEqMew9c3cnU3LazpMf+fvsX1TSutyBHvgdicaZbSc02BFiqu01
         chaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766605466; x=1767210266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wzdv0Dz7fDIsWscDqs9p/ZjSuEsl0aAxUwcckQlThsI=;
        b=m48ZQF6U0BuIlMLvNH2wJI+uMhvzqSXjv4FmGZkg1Hu/oeFMbpvg7YMXQfuzWdORRb
         APo1ubJRSwS0RrIbznZjs29sago5goDoYmC1NbFcdmvss7Gb/CgoRgv2sSJyXA3qcSb0
         MO5LNphTmdg//0+xmkv+WrivSE5GzkxlaSq9IL5q7M1Gboz9RJhe7QRr9tELLsItI0z9
         meplED+XUCI0Ojllf8viKbSNTfPVA9WuZ/rZwk9pQ+zcQDwx4vCbHeorgrkdQWtZkW9W
         qiVwyVM6lSmH0ozp5EyvFFlOxsCsi13t5FF4bvSW5/S5uu88nqtzZtNxFJtGfxaZeCoq
         dJ2g==
X-Forwarded-Encrypted: i=1; AJvYcCXyip50seLBqKwdnigAQTqz3yin2C5EHDIByhdQOj7ub6k9RkPy9wnzezey2YswX//M8t8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya6Str62KvW6x0RiA37r5SrDQSgpl7KdlJaIoT5zuiCJmTgAf6
	2D0DjgVZOMzRUR7IX/Yh80vm6gPyoLyuCeNDfYWSlCCjF6bre53HH4mrZ9biL10ERhmDkdsSlQD
	6bxSMYMD7cpitZANeg+uF0Rf6g4txxMk=
X-Gm-Gg: AY/fxX6Gw8p9qU8Hnk8D5yPMCBJXxbNRI6pq++mbRpBtqC6Ji1d2xZ8AGtUzYLpS8Xq
	NokxgbtojPdBaXtbciq5hfun1gNYhni98d+dmUBVr7InXt7BocCttT86v3RINSqfdG/08+gZzO0
	TioefhEJS7J+pL3OmTdyxrmxU2ldKe7S5XWxhoybU2L73WP/46JuznIa6/OwONKHdmsJtRI1Pm7
	T4Xa+zynNeyNytm3Rz3ly8cWXJf/6wZyUb9zCM+HtdRLpTZQEyRVI3s9UTsEr+PSiq/NA==
X-Google-Smtp-Source: AGHT+IFBdMkGUW7YL6U9O8cVLgNeDmB3CI1IsxeYj6gzNBm9wkF9C2fPFNoen3Rnbzt5yFh6yieV1LJsr4vQctXXIpc=
X-Received: by 2002:a05:6512:128c:b0:595:76d6:26f4 with SMTP id
 2adb3069b0e04-59a17d4939bmr7297950e87.5.1766605465722; Wed, 24 Dec 2025
 11:44:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219133853.8548-1-jack@suse.cz>
In-Reply-To: <20251219133853.8548-1-jack@suse.cz>
From: Vincent Fu <vincentfu@gmail.com>
Date: Wed, 24 Dec 2025 14:44:13 -0500
X-Gm-Features: AQt7F2qUywMiO-vb-Jij5IGt82vtFA6fy6Acb5WOsmGY8GhSs6H_zoF-hGi4n2Y
Message-ID: <CAOp=CX=fRTQnd=CEM9=7fprFF=gbK+Gs37AiHxh3-ivdiRLcqA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Add support for specifying ramp up period by
 amount of IO
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 8:43=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> Hello!
>
> In some cases the ramp up period is not easy to define by amount of time.=
 This
> is for example a case of buffered writes measurement where we want to sta=
rt
> measuring only once dirty throttling kicks in. The time until dirty throt=
tling
> kicks in depends on dirty limit (easy to figure out) and speed of writes =
to the
> page cache (difficult to know in advance). This patch series adds to fio =
an
> option to specify ramp up period in terms of amount to IO - i.e., the ram=
p up
> period finishes once given amount of IO is done.
>
> Changes since v1:
> * Improved documentation to explain behavior with group reporting, replac=
e wrong
>   note about default unit being megabytes
> * Add sanity checks for inconsistent ramp_size values within reporting gr=
oup
>   and usage of both ramp_size and ramp_time for a single job.
> * Fix fio server support for the new option
>
>                                                                 Honza
>
> Previous versions:
> Link: http://lore.kernel.org/r/20251217160217.15533-1-jack@suse.cz # v1

I see some evidence that this series lowers reported performance levels.

I measured 13.7-13.9M IOPS before applying this series but 13.5-13.6M
IOPS with these patches applied.

https://github.com/vincentkfu/fio has these patches applied.

vincent@meeki:~/fio-dev/fio-canonical$ ./perftest.sh
fio-3.41-65-gd028 **current tip
  read: IOPS=3D13.7M, BW=3D52.2GiB/s (56.0GB/s)(522GiB/10000msec)
     issued rwts: total=3D136806337,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.8M, BW=3D52.6GiB/s (56.5GB/s)(526GiB/10000msec)
     issued rwts: total=3D137832044,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.8M, BW=3D52.6GiB/s (56.5GB/s)(526GiB/10000msec)
     issued rwts: total=3D138017790,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.8M, BW=3D52.8GiB/s (56.7GB/s)(528GiB/10000msec)
     issued rwts: total=3D138339173,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.7M, BW=3D52.3GiB/s (56.2GB/s)(523GiB/10000msec)
     issued rwts: total=3D137141350,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.9M, BW=3D52.9GiB/s (56.8GB/s)(529GiB/10000msec)
     issued rwts: total=3D138603471,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.8M, BW=3D52.5GiB/s (56.4GB/s)(525GiB/10000msec)
     issued rwts: total=3D137722819,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.8M, BW=3D52.7GiB/s (56.6GB/s)(527GiB/10000msec)
     issued rwts: total=3D138275811,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.8M, BW=3D52.5GiB/s (56.4GB/s)(525GiB/10000msec)
     issued rwts: total=3D137584790,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.8M, BW=3D52.7GiB/s (56.6GB/s)(527GiB/10000msec)
     issued rwts: total=3D138181955,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0

fio-3.41-70-g19ea **with series applied
  read: IOPS=3D13.6M, BW=3D51.8GiB/s (55.6GB/s)(518GiB/10000msec)
     issued rwts: total=3D135851169,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.6M, BW=3D51.7GiB/s (55.6GB/s)(517GiB/10000msec)
     issued rwts: total=3D135621968,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.6M, BW=3D51.8GiB/s (55.7GB/s)(518GiB/10000msec)
     issued rwts: total=3D135896609,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.6M, BW=3D52.0GiB/s (55.8GB/s)(520GiB/10000msec)
     issued rwts: total=3D136300772,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.6M, BW=3D51.9GiB/s (55.8GB/s)(519GiB/10000msec)
     issued rwts: total=3D136113441,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.5M, BW=3D51.6GiB/s (55.4GB/s)(516GiB/10000msec)
     issued rwts: total=3D135364363,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.6M, BW=3D52.0GiB/s (55.9GB/s)(520GiB/10000msec)
     issued rwts: total=3D136375631,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.5M, BW=3D51.5GiB/s (55.3GB/s)(515GiB/10000msec)
     issued rwts: total=3D135055043,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.5M, BW=3D51.5GiB/s (55.3GB/s)(515GiB/10000msec)
     issued rwts: total=3D135058705,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
  read: IOPS=3D13.5M, BW=3D51.5GiB/s (55.3GB/s)(515GiB/10000msec)
     issued rwts: total=3D135092086,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0

This is the script I ran:

--------------------------------------------------
#!/usr/bin/env bash

ITERATIONS=3D10

echo $(./fio-old --version)
for (( i=3D0; i<$ITERATIONS; i++ ))
do
    ./fio-old --name=3Dtest --ioengine=3Dnull --filesize=3D1T --time_based
--ramp_time=3D5s --runtime=3D10s | grep "read:\|rwts"
done

echo
echo $(./fio-new --version)
for (( i=3D0; i<$ITERATIONS; i++ ))
do
    ./fio-new --name=3Dtest --ioengine=3Dnull --filesize=3D1T --time_based
--ramp_time=3D5s --runtime=3D10s | grep "read:\|rwts"
done
--------------------------------------------------

Vincent
