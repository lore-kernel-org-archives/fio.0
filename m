Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4872242A96
	for <fio@vger.kernel.org>; Sat, 27 Sep 2025 01:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758937851; cv=none; b=T5BI5saSXGbqs8vw8mUBstdEvKDra2Tk7yJnwdh39C7e1yXfpko8V1pbGRthovzTg16K3KTRAV9xweAdyZI4iYk3ZsvnSBIa4vY4sHiRwxKpTKj85z3UFX3NAuB4UMJIQwTMOvD9OYCqvGNBjeKf1IeLdDYKJ5ejGlsgTwZxBAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758937851; c=relaxed/simple;
	bh=98aCQhuNiGnqNvXwCO7SOj8pEwpkmmYUi5WqKqec7CQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RcdBdCSSwEFjbk3iAuBNVRvGG4siBtoOS0Bbm8sU4jM/r090BEhhLBR+ae/bGGWXNk9KYOBM4zGKxx7YTMZTWirP2UNNwthCeTEKsf9KPHFkuL4ZPd8fnrkxaNjgSLBgBCXScuDxbcQkDeT0Fsdk1lJR0aNL3UbsV8DoGgBFOVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ktRAkNvO; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktRAkNvO"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb78ead12so478763466b.1
        for <fio@vger.kernel.org>; Fri, 26 Sep 2025 18:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758937848; x=1759542648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=98aCQhuNiGnqNvXwCO7SOj8pEwpkmmYUi5WqKqec7CQ=;
        b=ktRAkNvOF3Lyus/5sqA0Zg+UqNWdGItY00es4ZIH34qiY1Owzd+XeljoaigP5Z3Fql
         yBHNm5XnrrjAKKWcqcL4kqlpSxPh/xRcbksx6/QtCXKYRnRSa0FbfPXwB6kxxHxJ+V2z
         7B1PsgTBZkVai4I0fZU7zxz4BBwzlHZsI7ubUwFBIBPS8wFCE4gn9C/5a5KYMkGb2D6p
         rtUw4YSnmOw20qnyCjEykxKH5i6O0/oGMSbkNfQ0RyTEOL/7u/ia5FoMda+hjqPMq13S
         O6aQcSKmwh8xaSp+VxiH3j9yCiI/GtJWV7TEXzLzXd9wl84dktWICeb6bw+6gctzyp2K
         h1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758937848; x=1759542648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=98aCQhuNiGnqNvXwCO7SOj8pEwpkmmYUi5WqKqec7CQ=;
        b=RUdMmeqp2XWqbAxX4Y+ZhApOa6LdCSngZycDOo3anQcteeKWqGIXR3SaB4IBApzLbd
         rpv3CMSCpjYXQwVkrHnpX9v83qHfDXOcBQ/pZOvYq3qxiL1gbr81+Nmj3tmvNCxcvZ2E
         3qO3TVB0RcwcCdcHGOjRleg5xwFK2szfkQxYix/tFiDOzP1yUrELsW76n3xnPHd0lo5N
         QYQbbQXF6UzcRU36DOeC+WHE0ne+PocGX3yRltk2/YecI+KRWpp0wSbWVVOuxGHHxyI6
         VSP/aF3TqPwdKTlPTtWGfOTDdhJf5bEhE8fHpNNHsREqJSMiYSxEnr0S419REaaylFQj
         tB3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWn2qcNCOwxXxy86/OUK1aHT104rDKHgSF++O/Tuio0SCjfR906C09QxnHlrSDIHh00gnw=@vger.kernel.org
X-Gm-Message-State: AOJu0YweDUeM2Pi0xb/ymRmnHmvj2zwOWWIvO0/mAax0FRnsYWRl/Eu6
	9UmKflnS1w/3f7JxQFTUW0aTpAWVDDMnmhR4p09z6wNVdZbnd668ANAHaelhtc7fJ07fNXAAj3j
	jVF4UoDeXSzrF68tsu29cW9+od0+XykQ=
X-Gm-Gg: ASbGnctZVdnS3fVf9jdWJx+LP/Gu3LlXm9d1wLe3g2CtFuQjUVTUH2psiJDQHOaQl5p
	CVo+rD4DUuigR2Vtr/ni7sig8weNIGXSJjhb980dN+WCbTpRFensaSKjhGGC+u1UUWDrkSGlYBI
	Pr9I98rvJIAXPL21MVKRHHOXAmDgnykSb0vVtTtrl+AV8QC6yWDhj8rPPwkuZRnqLZQoWlXW+gr
	N8fzVnyHNMI25izULmbW6oiCvZIg4NQ7n+zzKd4ADKHqd/qD5HdqxJ7iWeI
X-Google-Smtp-Source: AGHT+IHRh9zmfnho71Pxbemrcc9WMHwGSGyE4uSz6k/wS5KUIj7tWmwd84LAaMylHZp06oWjlGAYdxmK7+171UWnwZ4=
X-Received: by 2002:a17:906:586:b0:b2e:4504:2cee with SMTP id
 a640c23a62f3a-b34d0381c5emr886280566b.41.1758937847388; Fri, 26 Sep 2025
 18:50:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAERsGfiZ9YVeXMGk=dL+orN3o2HXJ0Oy9EQhVwK43MMDUSA-WQ@mail.gmail.com>
 <CAERsGfgCA7iFwLQ2L+=QyEg0=KuwK4hq62QcYpnY5R4h9abZMg@mail.gmail.com>
 <CAERsGfg8tHjtYQvDY5=rufh+PMGBNGCFxiYsNwMGn94o0e0VDA@mail.gmail.com>
 <1394af5d-ca1c-453f-8a66-f0f3a53702cf@kernel.dk> <CAOp=CXk-nuKPqf9d94ikWJPC9OoTGPcfTtA_kDYNrjqAptvz0A@mail.gmail.com>
In-Reply-To: <CAOp=CXk-nuKPqf9d94ikWJPC9OoTGPcfTtA_kDYNrjqAptvz0A@mail.gmail.com>
From: Shivashekar Murali Shankar <ssdtshiva@gmail.com>
Date: Fri, 26 Sep 2025 18:50:35 -0700
X-Gm-Features: AS18NWBE-qSJDPHvt0i-4YGFIzg6BBwq6LrwSjcfQNhOVfLFjmVP668-MSDLZ18
Message-ID: <CAERsGfiJJsevgXpFX_TikAuk1RKzngVxAOxe_UogjS0XyJQVrg@mail.gmail.com>
Subject: Re: Fwd: fio: ruh info failed
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

thanks much vincent. any idea when this might get supported? any other
work around for this ?

On Fri, Sep 26, 2025 at 2:46=E2=80=AFPM Vincent Fu <vincentfu@gmail.com> wr=
ote:
>
> On Fri, Sep 26, 2025 at 5:43=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrot=
e:
> >
> > On 9/26/25 1:30 PM, Shivashekar Murali Shankar wrote:
> > > Hi,
> > >
> > > I am currently testing fio with io_uring on an FDP-capable drive, but
> > > I see failures such as =E2=80=9Cfio: ruh info failed=E2=80=9D when tr=
ying to run FDP
> > > job files. This is run on an XFS file system on a mounted drive. Do w=
e
> > > have support for this?
> > >
> > > Below is my fio job file:
> > >
> > > [global]
> > > ioengine=3Dio_uring
> > > direct=3D1
> > > bs=3D4k
> > > iodepth=3D32
> > > rw=3Dwrite
> > > numjobs=3D1
> > > group_reporting
> > > fdp=3D1
> > >
> > > [largedata]
> > > filename=3D/mnt/nvme/largedata
> > > size=3D30G
> > > fdp_pli=3D1
> >
>
> FDP support is currently only available for NVMe character devices.
> See the example here:
>
> https://github.com/axboe/fio/blob/master/examples/uring-cmd-fdp.fio
>
> > It's generally a good idea to CC the folks that worked on this, and
> > probably use the fio list rather than the io_uring list...
> >
> > Adding them.
> >
> > --
> > Jens Axboe
> >



--=20
Thanks and Regards,
Shivashekar Murali Shankar,
