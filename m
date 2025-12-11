Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1291DE8BE
	for <fio@vger.kernel.org>; Thu, 11 Dec 2025 21:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765488877; cv=none; b=u21irI4GfPhG8DnApaijUty69d42xyh0GctNyvdW5fV4TSIJMew5s72aaD+Cy2+2TFhcDcz9JlgPzVqsI5crMOQp1rAlb1v4ZY73JL3AWLxoTU6wwVqW0F2+NVBTkO5nlVLYeXm9FmOG0GBAeLYCo7MNXzMSwic5DpbPDKQiubQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765488877; c=relaxed/simple;
	bh=RBQEIEMecJOlgcRAIFUKfVoXHXm/i0VvMXh0bQyAhiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DE7dqYwC+CQwh2MwnA34h3QgZCwQb6PQ5TXjGYyhxLXFlwn2Lm1x21SOFVcgW6Yl1zPKtK2OPI4bm1oVv6Txnu5SYIuEwjxRmSYu8vbStDuz14ffXIk/h/UE5VCidsPLLp8hY9BWwKXo/aIstQR8HRlbrU8oYZ0ssHzSeOu5PCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=inRrk4Qy; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="inRrk4Qy"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7ce5d6627dso118329566b.2
        for <fio@vger.kernel.org>; Thu, 11 Dec 2025 13:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765488874; x=1766093674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBQEIEMecJOlgcRAIFUKfVoXHXm/i0VvMXh0bQyAhiU=;
        b=inRrk4QyJsPw0QS2cbqLVMtlL1fa0aqB7DolSx5lxyp/aDTQOioV3avpDoA8tnNzJP
         AStex/RIdUO33GuJfuKRwCDu+Rga1fe2d6sHdA2a8Hsuyj2eYGk+FeLF36QdntQbg0u+
         /3DcqE4VAAdrf74eNJ1DqVvSKOXITcdTQLBNYeTjlGXbaWSRbN7Irim7nUGQ+keXNLWy
         6m2eeBvTzHtUMpevnMfhCf7rPnkvk+tnwfOkigYOeaIvWX7i7BgOiIGNIprPqEWJ/qwW
         KfZ2i5MDWSZTuAHeVQyjOXJ0Wa9vbGh394GJNbtllUblhZ1Q2jENwr5h8QVI3N/6rnSX
         g+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765488874; x=1766093674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RBQEIEMecJOlgcRAIFUKfVoXHXm/i0VvMXh0bQyAhiU=;
        b=SL7/1ttp+HPN9Nb5tOB890tdkqay1JkJi2WgfVdXebB5LvSY6w64PsS3sSB4FD4dfG
         gOhDXC3lqn6DxkYP0OdDL3DvHLomOU7Skk0ZSE+4meRZ+2UOAUtV2MceHMcCGFTzFZOl
         v/NJpywEWTkd+CyT9HZ8ymPWVQItOZGk12BnnvrAZXZ0UlnTvbHwn/jw/guUtwYCzboc
         +Tgn8AxJyN5VpEdy71b535EwFqjKYmFxbjxKzu2SxFdAWW0VHhl16M2+cqMjMk4WUczE
         N4d0MSYkXU3vL21BQEZ9v8r7FegTZfY5Kquml6xoL7yw0oe+0jjOFaHx01yImEOnJCP6
         8Lwg==
X-Gm-Message-State: AOJu0YxxjwLfG3I0sKfZXrGP9yiztfbmhe5n6WvJ3iRSyj4WaxkDn8W2
	3DSze3q7/UAV162AqoD9wrGNihvyLi9F3Cw1DcgXwGzO4kdUCFvO3xC8oRnXKhws7fWHjWnAbIn
	ubzisMlbpWDjn7ZURKBsIai2zojuDypGWDtFH
X-Gm-Gg: AY/fxX7rz8TPx9VxGhI1F2fT5ankukrIPvKV5bHGwFBKvIRWoF3Vhw3o22a9ouyEbsc
	A4wc9jfe26gZDl4E4blPN0L7IwBPaoXPQm/BL6aWQloUYtfz9pb9ZK4RWtXZojh0l0xRGT6gluM
	qETYPU+HRrAwTzbcPxNKByxjTkxJ0SRegQMLfeeG23a/5FgCxvPINLO8XoSQuEOUC3bV42CR081
	kfBNGKZorsydyF3t46aeXtKigVZRAiGmV1NPQMufwcHSP4XcSAS5LnV4Tc2YSGFOUg+VQ==
X-Google-Smtp-Source: AGHT+IHgNjbORgga8lVPnBeq8AXuYQJly36/pekDmh/OE6K01RX2kEcy96txexP+/KcNVZa1rZzd5gfMZD7sRfCaNSU=
X-Received: by 2002:a17:907:6e8f:b0:b53:e871:f0ea with SMTP id
 a640c23a62f3a-b7ce8509118mr847436266b.56.1765488874152; Thu, 11 Dec 2025
 13:34:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAJpEdjfZgqpyYDH4TWS3siCRca5rgy+Dj-a7dqCSaX0BObrjw@mail.gmail.com>
 <CALjAwxjyNHgvA65V_5njhXKK=QiRsgFE5XHzr2qOdoxZcfQ39A@mail.gmail.com> <CAAJpEdidxLSJJ2AQ8ExECLOGpxXWO_wOTOzN04q62TKsVnHKig@mail.gmail.com>
In-Reply-To: <CAAJpEdidxLSJJ2AQ8ExECLOGpxXWO_wOTOzN04q62TKsVnHKig@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 11 Dec 2025 21:34:07 +0000
X-Gm-Features: AQt7F2ouJF2IWkdbCXt9qdObxDEmwIVFsSojVfebUsFSQbl23ZMtf0LewmM5y70
Message-ID: <CALjAwxg-==Q7VQcVOHkqXBS-EnWLUkanuxVYfLYs1AD8pc_Kdg@mail.gmail.com>
Subject: Re: fdatasync behaviour in macOS
To: Anil Sharma <asharmaanil@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anil,

On Thu, 11 Dec 2025 at 03:28, Anil Sharma <asharmaanil@gmail.com> wrote:
>
> I think the confusing point for me was that I assumed for darwin fdatasyn=
c is mapped to the way fio handle fsync option and not OS's implementation =
(In documentation we mention when not supported it maps to fsync) and fsync=
 option internally is mapped to fcntl(..., F_FULLFSYNC). I think other user=
s might have similar understanding,

That's a fair point; doing a quick "git grep -C 5 DDIR_DATASYNC" shows
there are many ioengines that treat calls for fsync and fdatasync the
same way but do_io_u_sync() in io_u.c does not. There are at least two
ways to look at this: the documentation is wrong and needs updating
(i.e. lack of fdatasync() MAY fallback to fsync()) or the code is
wrong and needs updating :-)

> either we can disable the support of fdatasync option for darwin by eithe=
r printing the warning and map to OS's fsync implementation or fail early.
>
> In general, fsync implementation in Darwin is not POSIX standard; we can'=
t do much about it.

Technically the macOS's fsync() implementation *is* POSIX compliant (I
guess because macOS keeps achieving UNIX compliance this follows).
macOS defines _POSIX_SYNCHRONIZED_IO as -1 so strictly speaking it is
allowed to have an fsync() that doesn't flush the drive buffers (see
https://pubs.opengroup.org/onlinepubs/9799919799/ for POSIX's
wording). One can debate whether this is in the spirit of a POSIX
compliant fsync() but it matches the letter of it. There are other
OSes that "weak" fsync() behaviour (FreeBSD won't flush drive buffers
on fsync() unless ZFS is being used or you do some extra filesystem
specific configuration).

> But I would have assumed in any platform both fsync and fdatasync options=
 will provide similar durability guarantees. So, intuitively fsync and fdat=
async both can map Darwin's fsync implementation. There could be a separate=
 option f_fullfsync =3D int only supported for darwin. Which makes it clear=
 when running benchmarks for specific durability guarantee.

You can see Jens' introducing the fsync() -> fcntl(..., F_FULLFSYNC)
mapping in https://github.com/axboe/fio/commit/a04e0665cb5d3a545ab1dbe2d2b7=
c150b404735d
so my guess is if such an option were introduced it would have to
default to off. I pretty much agree that doing one of the following
would be an improvement:
- If CONFIG_FDATASYNC is defined map fdatasync to fcntl(..., F_FULLFSYNC)
- Change the #ifdef CONFIG_FDATASYNC before fdatasync to #if
defined(CONFIG_FDATASYNC) && !defined(CONFIG_FDATASYNC)
- Introduce a ffullfsync option (name to be bikeshedded) if
CONFIG_FDATASYNC is defined and if the ffullfsync option is disabled
use the "real" fsync()/fdatasync() otherwise use fcntl(...,
F_FULLFSYNC) for both fsync()/fdatasync()

Again, if someone (I'm not volunteering ;-) were to submit a non-ugly
patch/PR cleaning everything up then it could be reviewed.

--
Sitsofe
