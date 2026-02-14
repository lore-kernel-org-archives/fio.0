Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11F26CE2B
	for <fio@vger.kernel.org>; Sat, 14 Feb 2026 02:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771036789; cv=pass; b=BKLTMrLZcCKK6fGq3haOR6ltSSRR5kyjatY1ajfYwR5MA+gOcpu5zzg2l6ST25aWmrVgnFlCFVLGMn6IQQomiEBqIIYmzJrWSlt/vrhbGNnktYnAK+u/mIO3yluOnGmJnM93qbEmaVC1++ahoAQ3icC3uB52SSb8kLa/JuVQrAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771036789; c=relaxed/simple;
	bh=2RTt2WX5ZLWqtrW2JtNwRAFsbbie54ZaLKHSEiU1Dlc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aa6nHR9TsD+a0hZ7jGyN9XmGFvPHbVdjTS0OPIOPFhhyOH7IhZbPRefVx89eRtmsz/N7ak7PVJn82RPDP434EirZL27HTJnCvE0/D7UjV1v/1GufXnuZkceX9ICq7CDaDh/Oh2Zl1m0Rljb+bqOlYw03EAqIXNPuNJin2X0pQfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZWahNka; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZWahNka"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-38709888abbso12925791fa.1
        for <fio@vger.kernel.org>; Fri, 13 Feb 2026 18:39:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771036786; cv=none;
        d=google.com; s=arc-20240605;
        b=Ax9pAjXjm6Pwn3HQbmWorNQ3NbCmjN5tKzXUzu1Cz8S7ZwWosAoAJusRaY//795/4j
         2A5M2ctgAePw0LHxu+4GHz1ipwMRGbCYwYHMOCPtpwPm2+PCpd4Q7LD4mXMObsuMBCu9
         U69e8E6UMt3HJfHQLNjW8cYoH757J6wT81SBuWzDsitHJN/3Vr4Un+rjy5xHb6e1FWgo
         KICVu4XzH4J8/t++XPUT2FXBv0+D5gkTUerOFx1R3UCInHyeo2GqBBQhA/uRIRViCU2s
         2vhOFAU3X0S/lHLOuXmKjzW7oCkGK9KnVd/2LcOLRfmoKmrxAUFXMekTI86Urko27wOl
         BN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6fzzcE1b+oBkuQj6k5GZGn1kd1S+mdLx0PRJb5e1TFA=;
        fh=2pICpF+nLakmczZ8I5KjN/2E3/2n4E5Nv3ic29s8BXU=;
        b=X0ErQ5dpziVvrpxyMjmyv+vfTgRaNl7bLe1pi6UcZGsGPgs4eIPK9Fb3+3h2fuOW/C
         MX96n3pijTY74s0RrRP32mDDLk2toyHd+pOlvUhl7jg1Jyk4bmB9pKm1bK1nP/r3Nkpz
         agE64aVYtL5b/QetuU8SBc2B6zclqdQmvkXU3I8HGQdXbZupHuLU8gjdlsBWVaW8h4WW
         8Xu4uG35K3wKlxUHqCqF/pD5bDToYmqMthCBab8xeL80TZ/vbxaOxDXiGnhXUKeomvXx
         06L0RWZHovQ1mMNvwTNwF0dRxfgs8FzgGHtGTVkYd2lnvbCn4BimPT5lsjo4Ko7Z+qF/
         Q4zA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771036786; x=1771641586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fzzcE1b+oBkuQj6k5GZGn1kd1S+mdLx0PRJb5e1TFA=;
        b=JZWahNkayP6Kdpg2p5rlfuqK6fVxcwghX0MIQeXsTcIIIo9dfM2CQYKYI6qKgwv3y6
         UH2r4bSUMoJFFt0XSIpB4zoap80aMprpfKjE9jYsHssDTKW9g1jL08BRMFSsoHOs0eG8
         BJ6fsTM0B4A9tBogwnWiYoj2rvdyzkZDKQHbcOMkQyTDCEKKz6aJGr1yde0gD0zouwqU
         rMiImHOKHXi4xTtBu7RDgAqWblAvDbafWwWVt1y5JN65J6MwOZPxm5VIRU8W0YW05PKZ
         nKzB8ToR5yWpc3AK3MeplOnRIGMGaA8FEVYKmcMT3eDOBY5yRCS2VkF24u8GpX+WYrzD
         CLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771036786; x=1771641586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6fzzcE1b+oBkuQj6k5GZGn1kd1S+mdLx0PRJb5e1TFA=;
        b=h8xMSJS4EmqEsxmUfM5q6ZjS+ba09uX7pkTu7IHsGnb2HE6je+l8v8UT5VJVFvOMSI
         C9Zx/qTRjBf/LEyxhAjzAvrza7QdvTpqColXrkRFnIlNjb7mGzrPyTIrYyl3w766p2fi
         YJ1xBhrejMKXoSwF1n8hjYlfkjUTgDZpDnaTv2vsfuKBhpI7NHuiWdRYhBiOyXgE4p+5
         Q7Yyree6DNagFJ4nJXj382AutRaUrUe3dOpE9WTRTTdVdtuK5aOAJC94oX3PdYKD/6xV
         RpKBYrA0b3cvUGPcaazSEnE+mGQI+1tUFfeYFCCvbJx32u4NAJ+FlF53PJRy7or8Q/Oa
         vLhA==
X-Forwarded-Encrypted: i=1; AJvYcCUBwHK/h4YKSeNj+axtJ9h4gOJGvxIQuHM08I1S5REHdCy+31crDKB+ykkbXXVaTM6zPrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YypTsHAb4SGloq6XaFpl2Zdf2NXrlPJ3Cdi6NLUoZmdNnVu3aQs
	9EWaMmcFdwYmVYivP+9OSpXtptJFTuL3cBUnDazl1evSK7ro/hFAj25G23YP5QutpI4NHsg8UVX
	LABGlfM1R4hT2U5ZDQPpllk7yph20JQM=
X-Gm-Gg: AZuq6aLsQszCnGOeHi16xz+XsqhZ6apttK2w4Ny5lOzS01g7ayELYDmWZg7LVsRpsu7
	2PEriCKErIl/rPJHqFOa1GR8vooQpwvxPqoaUW5f+WLERk2D43HrT9xLU1JIoXDZF1j2RW3dPKq
	LXXQLEHtC3BpfqZKoOf4wp3+8NrteCsQZk/XP8YFDfaHlbDEvTYqbekx5eilkZdzWlv9Tp0hIp9
	sqbGPGM8kfwFPVsvwmSNlK4AY25Q9SaVm+YKpSwryCTngW9p/ODTKXcwl7nh/Cu8LTne0fVnYJC
	MK1BUQ==
X-Received: by 2002:a05:651c:1547:b0:387:176e:68df with SMTP id
 38308e7fff4ca-38810502f96mr11574851fa.11.1771036785422; Fri, 13 Feb 2026
 18:39:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206164058.3105327-1-cassel@kernel.org>
In-Reply-To: <20260206164058.3105327-1-cassel@kernel.org>
From: Vincent Fu <vincentfu@gmail.com>
Date: Fri, 13 Feb 2026 21:39:32 -0500
X-Gm-Features: AZwV_QjbTO1kH33BOcAdd0DqlZIYMhJSmdXTxmwBjgT8PQMKsDgqpNRzbvnnlFA
Message-ID: <CAOp=CXm86A_sG0SokEUsLJV8_7wJ8A15t0ugV16tGDp8Ef1FJA@mail.gmail.com>
Subject: Re: [PATCH 0/3] fio: Avoid errno and errno string mismatch
To: Niklas Cassel <cassel@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincent.fu@samsung.com>, fio@vger.kernel.org, 
	Damien Le Moal <dlemoal@kernel.org>, Jorgen S Hansen <jorgen.hansen@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 6, 2026 at 11:46=E2=80=AFAM Niklas Cassel <cassel@kernel.org> w=
rote:
>
> Hello all,
>
> This series fixes a problem where errno and error string representing tha=
t
> errno could be out of sync.
>
> Another possible solution is to remove td->verror everywhere and make sur=
e
> that the function wants the error string calls strerror() with the errno
> when they actually need it. However, that would be a larger change.
>
> Another optimization that could also be done is to look at the places whe=
re
> we call update_error_count() and td_clear_error(), if we don't set
> td->error for a non-fatal error, there is no reason to unconditionally ca=
ll
> td_clear_error() for a non-fatal error. (update_error_count() still has t=
o
> be called, as it sets td->first_error.) However, I do not really understa=
nd
> why update_error_count() + td_clear_error() is called by both:
> io_u.c:io_completed() and backend.c:break_on_this_error(), so I avoided t=
o
> do this optimization.
>
>
> Niklas Cassel (3):
>   fio: Fix error string not matching errno
>   io_u: Fix inconsistent handling of non-fatal errors with option
>     error_dump
>   stat: Remove duplicate space in __show_run_stats()
>
>  fio.h  |  7 +++----
>  io_u.c | 10 ++++++++--
>  stat.c |  2 +-
>  3 files changed, 12 insertions(+), 7 deletions(-)
>
> --
> 2.53.0

Applied. Thanks.

Vincent
