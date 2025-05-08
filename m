Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692B4258A
	for <fio@vger.kernel.org>; Thu,  8 May 2025 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746725511; cv=none; b=h7qMIcra31eduM07zE8vPQUot+50/3+Vi5Yv7XoFJV2CTr/F7wwSwRheVxLW7gcCQmwMAo+tuFhS2Xrua0gvzZzNb8QdOO9M772yIjAFwyY/NfRxMMM0UnUDY8eYH8riG35+HaO6U+txA8RP2O1a8FzYkvw4U8vuRuFdwdKXJ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746725511; c=relaxed/simple;
	bh=1AqOzGUxlSH5hc238g/mTuL1Sq41yWY2lgNWd8pAne0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WjCYLU/2bycjdg4fLCSbnbEZ9Uq6nNXxEPQ/ihbUZAp5EqV6EJ4pXA19OYOBbj3UHFFTY0h3skhEBc9UEEXS+cpejfgqiEf8VDM2vntVUaygGfEH2c10rLWwSP9Pk5Fn1QrNS6vAVCYcwCxgv4esS/8LBvCF0hzRazEybybIYUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ISSeK+gu; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ISSeK+gu"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3106217268dso11155201fa.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 10:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746725507; x=1747330307; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csLcxCyNm43J6XJsMgFooiyeXnfzBjZb6jzWS7p9rOI=;
        b=ISSeK+guXRqVHV6QNtdMmFlb6snUK5ee2EVIlWi0AKY61ENM/9xUqSNLqeOKbO2h7I
         Sin/ASDfsz0nH+WKMkCnynKNQzoKKAUIkeRcFi+fZc0Q+NI5tEjT75rgPA4jVq3orP53
         +KphjZbvX5Z2zlla/ypNRf77rDuhmrVUJgjWtKnOGwx4Vi4UbsFRGmtQczlQcL0qAZhu
         anfw1ym2OhxABvsXPL6Q6LjMMMDJT4uCfeg3+9StDNxvRJLD22LxMQ42V48r5Rp7WXBx
         aGgsG5C4dgOKk32TePT/TpTCKOdhTgfw1jS882G58fVXjYsh8AVtCiNmEYN+IalV7jsU
         ZelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746725507; x=1747330307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csLcxCyNm43J6XJsMgFooiyeXnfzBjZb6jzWS7p9rOI=;
        b=LyZid7tFPY8bmoE+4Bm0x/CcR81xE2jLWxU8IUs/7mxzTFvk1GU8VHlwPwBpw+LH59
         5CHoCTikdBKRBkPI5x8afVgKRNZC0AK3WegMLSnJBNOobcGPcxv4ozTMeDLg5Dpc6i1h
         eQf5snGwfcUaLeKjmdLHhiCg1ZoIBjh2WFNprulT4g8P2M66Me23kD33jMp1ojE4Bsrp
         VgORNsSepDkMX0TjibrkPBfUrZVw1mfIBO7wy/d75pjFv+POHSD5DU58gT1TdRZbC0Cp
         1igWnE0M3aGSUX65h3SKtckxoAa7+XKNDFMG7PWW6stmsUyFwzNSV1pRImaJ+bdlbkBN
         HilQ==
X-Gm-Message-State: AOJu0YzikBwv7WPxLyoCxESHYIR34FDv5FkrI3wIuFblHW3ZOd28sCmE
	ZYdgcIcOp+dVpodFpbcJN6N4SlGccHOGUBMlrZR7ElwwXdoUL+xmZVqcpsJMUGjWrUmX0MXtXhj
	n9pHRybvhGpkeqjSvBfatXmckUPY=
X-Gm-Gg: ASbGncsL3zD1ZGvwEvUdnMCpmHH9L85IbkqdwpGcQL6oVWgOgTlEcdhJCnZN61gBAmf
	HFVuJNQJxdRC4B1euvBgNughco9wNi0RcjNzwsOkqlxw6lHsrLOyZ+9cdS1HiOXzzNHDyZA5iSr
	WKzzzxyPpDxK6d/cMQ9HHw9cm+QMTttHtS
X-Google-Smtp-Source: AGHT+IH8Nj6PScH9DMHK3a5GIePE/GZ3muw/ChM6PJ8HZJsQ+IR1FQ5vd/lnNYK+MPCy8L1RZm+TchdGdrtM5yXq5Ss=
X-Received: by 2002:a2e:be91:0:b0:308:eb58:6591 with SMTP id
 38308e7fff4ca-326c4626190mr1684921fa.25.1746725507009; Thu, 08 May 2025
 10:31:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508171444.2113-1-vincent.fu@samsung.com> <16cf9fd1-968b-4349-903b-9a58eb0c9945@kernel.dk>
In-Reply-To: <16cf9fd1-968b-4349-903b-9a58eb0c9945@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
Date: Thu, 8 May 2025 13:31:35 -0400
X-Gm-Features: ATxdqUG0nVvSD73C9n1oqlI8ltIaz6lRYxRUa6b5jiNh-dBqJjhAfQbSlzItLK0
Message-ID: <CAOp=CX=dgfwZqbjSqxHgRSRZDLkifJFEWemeVvpBMcdR7WkADw@mail.gmail.com>
Subject: Re: [PATCH] windows: fix pread/pwrite
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 1:18=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/8/25 11:14 AM, Vincent Fu wrote:
> > The pread and pwrite functions for Windows posix emulation never actual=
ly seek
> > to the requested offset. Fix this so that the psync ioengine works corr=
ectly on
> > Windows.
> >
> > Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
> > ---
> >  os/windows/posix.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/os/windows/posix.c b/os/windows/posix.c
> > index e3abf383..3e48c3ff 100644
> > --- a/os/windows/posix.c
> > +++ b/os/windows/posix.c
> > @@ -830,18 +830,24 @@ ssize_t pwrite(int fildes, const void *buf, size_=
t nbyte,
> >               off_t offset)
> >  {
> >       int64_t pos =3D _telli64(fildes);
> > -     ssize_t len =3D _write(fildes, buf, nbyte);
> > +     ssize_t len;
> >
> > +     _lseeki64(fildes, offset, SEEK_SET);
> > +     len =3D _write(fildes, buf, nbyte);
> >       _lseeki64(fildes, pos, SEEK_SET);
> > +
> >       return len;
> >  }
> >
> >  ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset)
> >  {
> >       int64_t pos =3D _telli64(fildes);
> > -     ssize_t len =3D read(fildes, buf, nbyte);
> > +     ssize_t len;
> >
> > +     _lseeki64(fildes, offset, SEEK_SET);
> > +     len =3D read(fildes, buf, nbyte);
> >       _lseeki64(fildes, pos, SEEK_SET);
> > +
> >       return len;
> >  }
>
> lol, how broken is that... Does windows have any offset read/write
> variants, or is lseek required?
>
> --
> Jens Axboe
>

I could not find a better way to do this but I am hoping someone who
knows more about Windows than I do can weigh in. Sitsofe?

Vincent
