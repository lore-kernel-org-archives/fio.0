Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2C2205E02
	for <fio@vger.kernel.org>; Wed, 10 Dec 2025 23:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765407909; cv=none; b=RL4mVlnXiw2IjlanrVzs6bMLn4lShw27L+u8rOcGGHvRv+doHug2luwv9O1K8kBj5cnsFexV3UpNC3nwwIz5tQngFEM53pLay2SdI0Hdvu/aMfMCf6eI/tBpwHrIrAK/eU+l3vK1iq7PElbFQOOxi8xvKBiXMW1gYPWL1f0K1H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765407909; c=relaxed/simple;
	bh=m/3DT+y5Z8NLWWM0/2uEFcaJPmIQNKYAoP7iYRmBfsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q9fR6CA8KJky+/UFT6kFFJ59deF608wp57IpE2OPOLyU3RVQaU5DG6A48aJCBODHLDv7dOpmo8Fe9mymTai+2jrR2WBjgD8alRPMXpHGEfwVYWpsnDcVv5Z4dtu6dZvawr4GUZZI5ROvqx5VrNBsZKKhSoY3OQ20F0EQp7Klmmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G08oEvXC; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G08oEvXC"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7bd8b170e0so39293666b.3
        for <fio@vger.kernel.org>; Wed, 10 Dec 2025 15:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765407906; x=1766012706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/3DT+y5Z8NLWWM0/2uEFcaJPmIQNKYAoP7iYRmBfsc=;
        b=G08oEvXCFkI5rEhuSxlwtZSSZgckxKgYG18DYVHcacga8QE0UcPrKxRU3xeV3je1CJ
         fTEa9GRQYOwbheTQW6rulotKqNetMpMYGtaEjZ5KbAUeWaIZtMtbKTIKxyCwUSsDJzGD
         Knh2tvkcz7UKEjyv1dw+iYKPHpm9+7gnc8lLpoTOLwmc2e0qh4mOe9rB68gxZzt6OQog
         cS2YGIGmBcMGJ89VmKglvt2qQ2kr36ssUWveJH6as1i+jGn+Viz8ZZ3FdPHFacdqQG5k
         YQLMhA+px8VVbYlbi1N0+n0m2mhUiidXiEx3NqWfCxjTI8yUYjiztMu03tWgZLw76Ba3
         OX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765407906; x=1766012706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m/3DT+y5Z8NLWWM0/2uEFcaJPmIQNKYAoP7iYRmBfsc=;
        b=Vu5A+4BfHjUIs38t50PAyL93sw+jX9Vz0JI3CCZe1lkurdqCnRBXx5qsTlD9ACf66q
         vveZ+PwPxSHdxtfow7+ZvIR2DntvgkENudy9vy61m+m/LhEIjDB23C9+HSCWKOy3xT+i
         ArvHQX4uxGNitnOV/U9ZrvvTTXGwddGSa2JskF3UtRqFqPkUlsZGKiQyNdLXvQkzWMdy
         0ajJzEsEdkGqibotJZnmN5vlg0XVcabie56FuwtbwOysehLXtlLUQJ/SpazmlKFo9/fJ
         lLq2/xZ+eJHuMnLx2zO7T2FDwNhMuWbOz07rUK8FuSQS91S162/Wu4aLo/RRFEf1BuPY
         ADDw==
X-Gm-Message-State: AOJu0YwANEwnh7AsN9hqeMiipfOfqvhNhoBTjGwUWHnjYX8qByt2D6Zw
	TlmkGF8oHNP1+m3rCwMaWuYgIwvfM9puY96J68pfEIBt/42+P9R1DXLTyNWB5jm2p8jZ7JiENKQ
	7FrleKVsk3jnK7tR8VqHUyQAY6SCrvZEn/8KI
X-Gm-Gg: AY/fxX7Z7t+UQN+EJSemYvVJS//K1PBWtZhT5ihTM0PHu4d2fbljYqqNuSyIgUGNczU
	tyPqys1DD5trO+IbF1CcgzcFZUg9wWh1Efij0CwCRIa0HTfs5i5f1er1P3btuCxIFV+wue/eM+D
	G2fbQ5Yg9ZbRrIpTbzOuYdP83kDO6TpsXd4jMhGDXK6O6f5rAx4WLDuWDIBjt+Yw5otGbpuX7Nw
	4qh318cvWqyCOlDhe6nXVcQql/jTPpM8/h7n/oJpb+2Vxu80wTC9ikc5g2mL/A+8THg2g==
X-Google-Smtp-Source: AGHT+IHTS/BSL4KxEUJjfSQ1xI794LvNN8lIxw99SBFhbo07fcv3MRAoVkjBJ+hB1bsl3J7fvPtSHVSdSthefP7XS34=
X-Received: by 2002:a17:907:808:b0:b72:6d3e:848f with SMTP id
 a640c23a62f3a-b7ce8247fcemr399471166b.19.1765407905671; Wed, 10 Dec 2025
 15:05:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAJpEdjfZgqpyYDH4TWS3siCRca5rgy+Dj-a7dqCSaX0BObrjw@mail.gmail.com>
In-Reply-To: <CAAJpEdjfZgqpyYDH4TWS3siCRca5rgy+Dj-a7dqCSaX0BObrjw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 10 Dec 2025 23:04:39 +0000
X-Gm-Features: AQt7F2prL3ZwxytdrJUnaFnzJXy2rIdYIgK7_i5a-BhGKDCEgOXJ3eUxAeiswLk
Message-ID: <CALjAwxjyNHgvA65V_5njhXKK=QiRsgFE5XHzr2qOdoxZcfQ39A@mail.gmail.com>
Subject: Re: fdatasync behaviour in macOS
To: Anil Sharma <asharmaanil@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 10 Dec 2025 at 06:07, Anil Sharma <asharmaanil@gmail.com> wrote:
>
> I am using fio to benchmark serial fsync in macOS. From what I could unde=
rstand, both fsync and fdatasync are linked to F_FULLSYNC in macOS. But the=
 output is very different. fsync=3D1 can only get 110 tps where fdatasync=
=3D1 option can get 5.5K tps. Which seems like we are only writing to OS Pa=
ge Cache.
>
> Question:
> Can we get a confirmation whether the fdatasync option is mapped to F_FUL=
LSYNC?

fio's fdatasync call is currently (as fio fio 3.41) *not* mapped to
fcntl(..., F_FULLFSYNC) on macOS and if we read fio's source we can
confirm this:

If you look at https://github.com/axboe/fio/blob/fio-3.41/io_u.c#L2463-L247=
4
you can see what fio uses to do fsync depends on whether
CONFIG_FCNTL_SYNC is defined. In that block you can see the call to
fdatasync *only* depends on whether CONFIG_FDATASYNC is defined and it
will never be mapped to fcntl(..., F_FULLFSYNC). Over in configure you
can see the probe for fcntl(..., F_FULLFSYNC) in
https://github.com/axboe/fio/blob/fio-3.41/configure#L706-L723 and the
probe for fdatasync(...) over in
https://github.com/axboe/fio/blob/fio-3.41/configure#L1252-L1268 . If
you check the config.log on macOS you can see that "Compiling test
case fcntl(F_FULLFSYNC)" and "Compiling test case fdatasync" both
succeed leading to CONFIG_FCNTL_SYNC and CONFIG_FDATASYNC both being
defined (see https://github.com/axboe/fio/blob/fio-3.41/configure#L3075-L30=
77
and https://github.com/axboe/fio/blob/fio-3.41/configure#L3380-L3382
for where these symbols are output).

> Please let me know if this needs to go in github issues.

Hmm it's not something I personally will work on (although I can 't
speak for others) so it's one of those things where a well formed
patch/PR would be more useful but there's some debate as to whether
it's worth it. It's well known that fsync() alone on macOS doesn't
trigger *drive* cache flushes (unlike Linux) so I don't think it's a
surprise that fdatasync() has the same behaviour as fsync()...
However, I can see how fio's remapping of just fsync and not fdatasync
is surprising. I guess the question is: does it make sense to even use
fdatasync=3D1 with fio on macOS if it's just going to do the same
heavyweight fcntl(..., F_FULLFSYNC) work as the current fsync() ->
fcntl(..., F_FULLFSYNC) mapping or should it just be disabled
entirely?

--=20
Sitsofe
