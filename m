Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE3A1DC98C
	for <fio@vger.kernel.org>; Wed, 20 Aug 2025 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701547; cv=none; b=rLssCsAL/5brmj6MM7xh5ylH2C81otj63UKftsDlSkboLQvCQ0JC+s7gXHM5RRkQtJRoLsxPd7HurzdAEtGYoSXRAECazQDS9Ht8CibxLTMFhP+NtuGa8wMnd7Z8QDo5GU0xtgtJKqpdtBZYK2BpLnL8EN+nodRY+0NbOFHVy1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701547; c=relaxed/simple;
	bh=flkIP12rv3rjywgWdH0t5o9yLbMqzcgx7AYG8VTC2co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ns+xkqNmmm4UV3Keu+7iu1hlJ0XF43oQRoFMS7wPIXipKmcO3StC1RrI7sysTpHCmwp8/pWvf3oz7V4V7ERing0ptB8x08DGM2Xm4Hc1AHqwZfP3dyugzQyKNO6X7GQ0bvOnXul35J1m21UnEixm4Zpb01Dt1CaBr3/vpJYUa3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DXRgeJ/o; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXRgeJ/o"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-333f90376a3so46054501fa.2
        for <fio@vger.kernel.org>; Wed, 20 Aug 2025 07:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755701544; x=1756306344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsxv1LS4VyNK0SVB6HCiwoyAwZ4tBcApqaChfi7sBe4=;
        b=DXRgeJ/oFL3RdxJjSm4w/pfgGqo9dQH12lwS4BHZVdVQjASCV8xNbq4mpx3cDx3iyP
         WlP56IHSdWH1nFREVSnj7Aj2l0jS2ESjXi/mr+RwWCB3x5IEL18OBwVwDeLsxtJjC30B
         wVm58lC+qXcriKkGlMpkbBOKyf5IqhQSQdNPONxmC6MTa0BhfrInXr2Zk0e6/RZiVza4
         BE2lzNNAa5MIiyYNmi0dbplX/nH/O4uydVFnFhoHiR3I/SYsNKgMvYYiBMMYx2RlvkoE
         1POL6pr/0M8amzXOkioTJteaHAVgB6FUUijmJwBDLogqOLzcSdv2nyvJurJsfqcxtpic
         trGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755701544; x=1756306344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zsxv1LS4VyNK0SVB6HCiwoyAwZ4tBcApqaChfi7sBe4=;
        b=kp5f2ox+qS96+zoYrO/+auyToyGKfThwyVqSxiSo4MKyMfeq/NGqQkBInelk7WZzyA
         VWPHW/Agr/15v247wIQa5xHSVeRTwEKSbSpN0c3Qp7P9lzgQYu7L3lOREBSrEuoVX+cj
         M6uiCWpsdCFKxAcfqQkbHY53/okn1QiJ8/oG5leMmtU5AXX0cte1cuZOvJnMZ5aiC0B2
         XrRnIroSAO+ZwBkp4yGuiYPFewTHgSehBQ63L1F4gW4MZtUoFERs8BHtkkXJ8DCwaAZC
         k2rhm4jcfHJP4I3S4G5XeQresDw+1BDtFmQBnb3FcOB9+tamaJ2gTvnxhK9CWUQgJ4Pp
         WTFw==
X-Forwarded-Encrypted: i=1; AJvYcCXdLa2UornlbxPsqA8awOQqLvWUCPLKFC+k5vgEs/d/nyMK36pxFdm7PNHmDxGZ1nMQ4PE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfno0lcWZMDQ0m64Kz1giqjYiGE8jsBN51PS5qKLzOVIdLHLIF
	ptsmU+a7IfzjhkvYPOqgacAs3GcHG3PF7Pt0SrsxXSmKbqvwxGwr5lGMhXOyF+UEqItl/zAoWBU
	+g7oxvRWaBJieCGmt1NHpkjcH9I+iMXM=
X-Gm-Gg: ASbGncsOnZk36govnbR39TIfR3O2aDazG/W6KnKNMCr2uqmsEJ2KeVD9NOJBeXMfLxA
	ZCymJWPXnCB5xiM9oHOi7Syx/TiTP7P8cMvCQ2KedkaXHUPDY7mPf+P43qQJs4iRAaThahl/+Gu
	x5oQDpnlbPpOuBZn6n3d3S1cykYze5+1J2y5j9LS/aYO8CCWRXd9tAT0MBJKPUr+nDIokCM4BHO
	IQ4cw==
X-Google-Smtp-Source: AGHT+IHzF/KiKeJWxAC1d+6wQKZZ0sx+28e59m61KU21GiIYw8YhfpPfekQ701wMIKoHsQfchyVtz03h4U74Ec7cPO4=
X-Received: by 2002:a05:651c:40d2:b0:32a:6aa0:217b with SMTP id
 38308e7fff4ca-3353be1e265mr7085571fa.25.1755701544169; Wed, 20 Aug 2025
 07:52:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820130321.73376-1-tomas.winkler@sandisk.com>
In-Reply-To: <20250820130321.73376-1-tomas.winkler@sandisk.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Wed, 20 Aug 2025 10:52:12 -0400
X-Gm-Features: Ac12FXyPH_kqLNPT5ZtsWDtMw_OkTOGgvb9fRgN_j_FeRxFH165BiWjzPeWx2Ng
Message-ID: <CAOp=CXntJu-MNL_VkfjrfO9EEbu+=+h8hhuuz-CjsvKEEcwCYw@mail.gmail.com>
Subject: Re: [PATCH 0/3] fio: fix static and const correctness
To: Tomas Winkler <tomas.winkler@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied. Thanks.

Vincent

On Wed, Aug 20, 2025 at 9:03=E2=80=AFAM Tomas Winkler <tomas.winkler@sandis=
k.com> wrote:
>
> Fix static and const correctness issues across fio.
> Mark functions as static when they are not used outside their compilation=
 unit,
> and add const qualifiers to input-only parameters. This reduces symbol ex=
posure,
> clarifies function contracts.
>
> Tomas Winkler (3):
>   stat: make stat.c static and const-correct
>   engines/http: make fio_http_getevents static
>   engines: make engines static-correct
>
>  engines/cpu.c  |   4 +-
>  engines/exec.c |   6 +--
>  engines/http.c |   2 +-
>  engines/nvme.c |   4 +-
>  engines/sg.c   |   2 +-
>  stat.c         | 100 ++++++++++++++++++++++++-------------------------
>  stat.h         |  24 ++++++------
>  steadystate.c  |   4 +-
>  steadystate.h  |   4 +-
>  9 files changed, 75 insertions(+), 75 deletions(-)
>
> --
> 2.43.0
>
