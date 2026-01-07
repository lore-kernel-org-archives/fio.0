Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D963A0B36
	for <fio@vger.kernel.org>; Wed,  7 Jan 2026 21:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767821181; cv=none; b=SHnrtqXIjyJzsIFEWE0pK2qoyuH5vCT/he6Omh+43NQnmGFVORj3hJZyQTKRHnMwVN/y0vD3eL4b5pux8/Yk0eLLLQgwwo5081pra8ZSke3JHiWDVyx5ZR2XVTi1wrreRJz5s9Kx3KskVBrC/pEPVKPaNJOy7xXVWTSj5wb/g6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767821181; c=relaxed/simple;
	bh=6UH/Sd2aR0mX1NJTrcpNp27ez2beaIKi0OPSp6oL8Cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ex6/8ppx0QMddcddBSPnNmFMtEkLQDXDZ4G99G2gpWUIe5YSzTKLzxjhg0UIvePpCIqDIw+zo0d656VhsJ2jnLu5seZFJIqjsRjaU2TePNeTWCwr4S0gZ70B74pdGoVe5InQc1m7ffok+x/eIzUXDobKf49bJjSOFAXQpKbVUtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ewh9WM7A; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ewh9WM7A"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37cef3ccb82so21250561fa.2
        for <fio@vger.kernel.org>; Wed, 07 Jan 2026 13:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767821178; x=1768425978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oK9oxCOgiiclEy3NCIc2HqU9wqqiIrsKaO9h/OkfK0=;
        b=Ewh9WM7AHjCIb57FZJFup+Oem/ZoqLBa6x1ILWlJy4oWRExBWsfkZr/Azj+BS8a+u5
         4s3+td9NuFbyR4iMBSaPV0Vw1gVDZZpDOO+V/NhGurGNURDGH3CBQJGm1Vd4ISJoG3BW
         3yjqCvEgsF1U7wnhPaqu0RFniWHUtlTOSpcqhHoqw7zihSy5vkf06z5dAHCrEPyJ4hOD
         nbvAWGjSlQ/PluaZPL4xpdBKRqbPGslqwpqBZ+Yt604bhnddnvf6OXjBYrxGk3KvBUxX
         1UJLNtzKM8fXmqqya5/cvNgCdhS9ceXpY3V+vGPve5mzmN2wFHvjqnktJTvq66GNXcaY
         fCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767821178; x=1768425978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0oK9oxCOgiiclEy3NCIc2HqU9wqqiIrsKaO9h/OkfK0=;
        b=iM42pMvhSnxBPBQeLO2+6WMd+jeiiPgD6o426tr2j8l7rDPAVppdNMP2GTznlyFcRY
         W/MMyIVdVgN2YVyhX5NZ1Yob8EAtUmv3A6NguVdMiY1OJ6aXSl/EmAd39iEUfVBpoIF2
         IAQygUSyrk1p72mPtwS4IePfWwuxW15r9Rd2QLQfyy93Hw8DPeIAhX9RgJMWs0wdW6zD
         Pfyn/FTu0gJvS9NgJaL9gsAjp+UpcgVQakczS9t6l/K8nuebCTVyhfj7Yp3LUUC68N9T
         LL9PV5ieRFgfSinO57V1z7m0xOMwbJQ/a1xgA/h55+OAr/AF56N7WmKfHEzcqsqiS+te
         btpA==
X-Forwarded-Encrypted: i=1; AJvYcCWJ72dys19gA1eMKCodTEj39Jfu2XKsmJYUVoWKt+8q7tcgla4QtkgcBBfJ+FS4ugtRuQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdlmTfAKq2xCU4BE5Dmj+SxIzArJz8tJha+oZtMKtESJp5dA7v
	4wF9hHn2Q3dvKAgx4k2dNHtnjECTk22L9O2xHQx95ENp4Rygz4OYJ0JKyMDvLl5ciDN7vfUyqd7
	osj45rGBlxeS2LH4qttBl4BEBgaI8ikg=
X-Gm-Gg: AY/fxX5KvG3ctrNGvFL670OgqJOpwYm70xmXVui2jqhOgtUVrhqPtyAB8aSJwl3lQa8
	y0dk3unBkAd34kVwJNBcPyM5v2rgKwojBAZsV+auyveYlfjuz14gUexNu9pbUb14yDkaneW42ok
	rNSc3/0Hzx2r1NbNmc1L73GbhI4GJewHOUP53/PrNboI2R6iSNbq1/hzCbPfBy6sY/Y6a/YrnL0
	xqWYWz83fc0+rUIhjp9Dl8XNtkgft+vxt8unkN/H3yHzoWBCRmChAG9dkOoXCWzs9bdyA==
X-Google-Smtp-Source: AGHT+IHci67wEyif0Uod+hyxOlRAdoP8T4hMOUa9S36z/BgfSKlwyWVEs9Bb90Hdr8xpKMbb09GRjLiG7S1CIW9FUek=
X-Received: by 2002:a2e:a58a:0:b0:381:7f8:4b31 with SMTP id
 38308e7fff4ca-382ff8419dfmr8901721fa.31.1767821178175; Wed, 07 Jan 2026
 13:26:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219133853.8548-1-jack@suse.cz> <CAOp=CX=fRTQnd=CEM9=7fprFF=gbK+Gs37AiHxh3-ivdiRLcqA@mail.gmail.com>
 <6c4o2uapq7t4tj52lvxrq4vxfiprvbp2lbdzcdbew6b6qmh7ur@kttcfiv2wrg2>
In-Reply-To: <6c4o2uapq7t4tj52lvxrq4vxfiprvbp2lbdzcdbew6b6qmh7ur@kttcfiv2wrg2>
From: Vincent Fu <vincentfu@gmail.com>
Date: Wed, 7 Jan 2026 16:26:05 -0500
X-Gm-Features: AQt7F2plyOB_I4JQUGvdZXfT5hR4jJdHnBmWy-53-dXXIVLLh2h1bSB4EwBaKxU
Message-ID: <CAOp=CX=rVNLmxde-L34D=e7gL2a8f1EhbhcwY0UOgJsZr-in7w@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Add support for specifying ramp up period by
 amount of IO
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 12:03=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> <snip>
>
> Thanks for reporting. I had a look and on my machine it actually improves
> reported performance levels:
>
>             AVG      STDDEV
> old  50818766.4  845445.763
> new  54965054.6 1113699.088
>
> But IMHO this is mostly just a benchmarking noise due to changes in code
> alignment wrt caches and possibly data structure alignment as well. Just =
if
> I do two compilations of the same sources I get easily a difference in
> averages ~2 million ops (i.e., ~4%). So at this point I don't think it's
> really worth it to worry about...
>
>                                                                 Honza

Thanks. I tried on a second system and found no difference. Applied.

Vincent
