Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98EE3A1A8
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 01:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724895871; cv=none; b=rcV6k8HI0QUrZA6y/LiGbGLwaziYK3/MKJ3mvklDzVPRPR/yIhrzfM+Caa8+vVydUCMC5IdYIqssaMWOP+3mj0KD1FE01jmzMlCf9Wcl5le+3NuWJKjd05bqEcpH4UrSEj/aUNCf0nN9xb5HbAWw/j0DF/qZDXzZQR8dPgebzwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724895871; c=relaxed/simple;
	bh=Mrgea6xEQ3EyGyFiJ1sMQ+gmw+KhGsdOd7+QsGPuL0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gD5EUJh4e//2zWy9ghQjuf8igEL+OsAcVx+6NRmzO1fGK0waoNEIAiwfJNYBOMCzURNO/vDjpi8ryFVNptlhWMo7Bez9KWAo17lZqwSKrIGb4NssGO9o4coxE9B8RSTsYx/1BES6FoIj7GVK7FmMn4lpcDxjytX1loIAOWgS+78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=JKJlrXTG; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="JKJlrXTG"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42b964d7526so161405e9.1
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 18:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1724895868; x=1725500668; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mrgea6xEQ3EyGyFiJ1sMQ+gmw+KhGsdOd7+QsGPuL0I=;
        b=JKJlrXTGzdCtYbZF38Hf6uiQ/dJfrGcvlSIEFrJ7NmgsJLfRm587M9JGJIV/F2a1tx
         +DQNMDTr+19FQBf8pLENogApGKjGc1aXyJ1BfCiK1PFn4Pf+awmiueSMiPxTJtkwKajC
         9yYh05K7R4N3iq9oFgoSZf7unzPqjoLxgFE73rZEt2dxt6WGuufRR0sNDkq8y5dQxUfq
         EN5V07IAtwT68x77JgrO6QU3ShqkSvH7Pdgonawh5wmSytlNEWhzry0aYg/WlkguE0/l
         pTp0klu1aLagoG69ungi9GWUQn/YFsxDgZ1q/SMxUZI3qSD+By2KPRA/CkQ2mcgaRFY+
         jH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724895868; x=1725500668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mrgea6xEQ3EyGyFiJ1sMQ+gmw+KhGsdOd7+QsGPuL0I=;
        b=nXOYELCezL2sFQxrJtPFqjsrapODloubLC/SdMfT+xiUUBWpFrCw+HxZcvTiPL2jKd
         Okdy3RUrcvJ0GDTwPCfmjwKlpY0ypaNEP6oKuMJC2B8kY2NkhwKjhwHH36xkzBt9CAwD
         MasTE4yefvpsrTJ5roFtWdWzM5Al3idzHhImtDDRQgwKiJ//l5pnXtC2+VWGNNitsH8d
         O8LURj27Mctgw0aD7q53aKxafMF8HjfpDgER7dC5llIgzRzPl2DjqDhCZlON4nUd1BtE
         wHHshAoLOqrim/lk8E7pJdPf50X0nU3hyHWd0a0wmzrGc1tiX6GdY1Zfo2zIGyqGFb65
         sInQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8jAZohOzhrqAm8lixC0y7bD3XTPKvhqJDPb4vqGmbwfWNV7Dvn/KVUrbzK8BHPi5/pOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM2SPECaFS8K/fmKu+VXiUpNhyKeBX4J6/6GlAnhrsxWdNQea/
	AQcN/wNXpJhfvGfdLkByRtovoFP1SA36jEUKrRIvVvM0IsDYT9C9UBhkqlWI5/Shx2WSqutdhnT
	uzu63pekwCTMAKTBx6suRp2FedLqx5Tq0a1wz9A==
X-Google-Smtp-Source: AGHT+IEQ+YJ21+jkuZlmt31GisIhtUlqQFJYv20gBzIwkgD89AmjwTsX4yrmrKaD1qZGQmudfmTiIJRCSuUksNwaIxU=
X-Received: by 2002:a05:6000:184a:b0:36b:3394:f06f with SMTP id
 ffacd0b85a97d-3749b581615mr450063f8f.5.1724895868195; Wed, 28 Aug 2024
 18:44:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-6-shinichiro.kawasaki@wdc.com> <CADqNVTqZJ6oB6QsZcKgeP+dsCmFJug=pPQJbrhgbYSNo1+1Rcg@mail.gmail.com>
 <51c896f9-7180-4465-8f32-434f237d157b@kernel.org>
In-Reply-To: <51c896f9-7180-4465-8f32-434f237d157b@kernel.org>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Wed, 28 Aug 2024 20:44:15 -0500
Message-ID: <CADqNVTpFmDpNW8APJGjuiN_OpbgDQp1HNrdNG8uw6G9YnhpW8A@mail.gmail.com>
Subject: Re: [PATCH 5/9] introduce the log_issue_time option
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 8:05=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
> The submit time is what Shin'ichiro patches are adding :)
> issue time =3D=3D submit time. Maybe we should change the name to log_sub=
mit_time ?
>
> With the code refactoring/cleanup that Shin'ichiro did, the submit latenc=
y can
> easily be added too. Though one could argue that the "clat" name for the =
log
> then becomes a little inappropriate.

Oops, sorry - yes, I should have said submit latency, or start time.
Either one makes the slat and lat logs redundant, and puts all of the
info in one single nice file, which happens to be clat. :-)

> Adding an option to change the clat file format can be done on top of thi=
s series.

Definitely. With everything that may end up in "clat", I could see the
option morphing to *only* output the single clat file. Right now one
ends up with the lat and slat files too, which take up lots of
(arguably unnecessary) space in memory.
