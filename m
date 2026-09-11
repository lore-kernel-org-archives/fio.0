Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627E4568FA6
	for <fio@vger.kernel.org>; Fri, 11 Sep 2026 19:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789156231; cv=pass; b=LwrBPEJFzfwDpXXvW9gmt1A2wM1BQueqXq8WI8aAnDaoooQq8RAzrQHZgqnpOv29iunHOEwPIEO5Qc6JaBi1wmAthMHY/TzO6pH+q9FSMeYrPJooAe47jQww1yIZM6CVt64cf/Bs5XcIqPAblX6jNwOa/v8lg6znnpNCFJqPDL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789156231; c=relaxed/simple;
	bh=QkgMlQaViWwWdMyqpgBtOsJU41E4gqUA/ZKXObs42Kk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XX6dXavTz8lwag0SJaToAKAmC337/74nVoHRGk3U8v9uzAxCnAd8BvNuJN5sdNmfmcclv1RUeEZucd1jxWwoo8uH4y4OgW+WOo39mOLmrvSa/wqrXCmL4FBsvfvlArzO+3RihMpGAMnOZPS8o3utHEClwMyRP2gsC0xsh1wnESo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7JRGyy1; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7JRGyy1"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3a4835ab78cso12574991fa.2
        for <fio@vger.kernel.org>; Fri, 11 Sep 2026 12:50:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789156208; cv=none;
        d=google.com; s=arc-20260327;
        b=m5FPW8xlY9pjMoVXpsyZjoRxiKevAxyZDV1fH2h6B+mAeaKDE3pO6NOTUQdYp5cfRY
         39hIqVMcs8+gjIiQ5g3cU2rYZiWZ9KheVwEN03RtihBrTqgilBIHvGIHdUEC+IKJfHJH
         ALbJGoi5kl3N2/OKRyQX09a6UMdPxLobKMIKCuPFYIrbYMqiWxuot0y32bB0vfnpXGH2
         7fzn5AjCJVPRGKecgxE14pCg/KFgJxP/6wJqBy7u5RiAQq+FNQZX9b5ITlqNwDkj2wNw
         FQGCfoFb0SYMaTBbXZhqHshbdB6H1nd11VE99vO3RDS4IB0s78G8PrU94QrwPfS+5Ats
         E1fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QkgMlQaViWwWdMyqpgBtOsJU41E4gqUA/ZKXObs42Kk=;
        fh=4U1Hn5Lg8YZkznXeQefaaGN8uE77LIcuj7VRWbLiznE=;
        b=ija4TGM/oERGZRZvwZaFuC8BvkgHgCyaB3Thav/Jw+61//FkHrLTbWSXPAj34t4xOv
         D9vnblX4FxJSX/3TizYRdDESBQyPkiPp83SOvFIo1RtrcBlX61/EUQsowXN3l1XG5IJT
         GNcPMydlbTgAIOTJHdqAFlcsjWxY3PEBLnk84apHt2VAgMFR/xSnjBMmjcPB5XuKAO0Q
         jmgl0PXFLLHgU0kOWs7AiVSqevsQfdwH06pHkXavqY3gziru6IsQXGjKDZzdQGEetmqs
         pkqSNO1WMtthZ3VBcdqpTuyxQw/E6h3FOpukO9h4XIQoeWcLXHCQyJKzisPKWlKQQk3t
         O/Nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789156208; x=1789761008; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QkgMlQaViWwWdMyqpgBtOsJU41E4gqUA/ZKXObs42Kk=;
        b=A7JRGyy1ApA6Hamt6T9UYchyw+WUrAh6ZcCsTsSR6dMFnH+EmE4T0lyO0hFTnzXKHF
         gAUikIOZzihOe1j9wD6aaug/G/kKidRKGDFHS4kLNUxRFoZmYs7MKFqyhS33SIuF0prO
         5CJ4BvxvTGbmqf/JItBmUNdYrTGMGRKk0O15aH5MvX1PzI8wx7swSZoBmeivRopX/Bv7
         dNuK142Pu5Ez+LnvW+JRuFqmV46yw89MplRMEUFpNqF4kzjJKcPbpsJLrJ9/sCM60N6h
         BxH5EhNo3KoW/gHUo36Dm6Fpv39oLpv5z+t0XYAnrvgsnWV1kSbUwWNde0P4Ij11Vj8/
         1QbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789156208; x=1789761008;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QkgMlQaViWwWdMyqpgBtOsJU41E4gqUA/ZKXObs42Kk=;
        b=cVXuOkSdymeIiuuaQKkGOP9x3659q9prielWCpSQnHvuzQzjarysb6hMLOzX6Uy7/o
         ASjEsASlW3dT1kVkdpgb9+8ihtzlHAyrJeZQLJDGtDupLjryRT8V2DWZFQ01cVa0wx9z
         MxQryXhKQQKQJ8F4CaYS0w/ug7NC3b2cYV3/fmBuvG5OFuTYoA/3VxVAvx72a2lWGN2R
         Qepl35KELolJxy6Z0pRCWFfIViYI/bqKNlzBDG5X5RdFzMG4hQpeeG1tqitHEmnDSyKD
         Bq8912izkR6+lm0WoQgjRAwFqVB30DNN3ezyW0tU7szorWPgTB3rHiB1yXlveCXo3wG4
         XuMw==
X-Gm-Message-State: AFuF++ngySnG4vbWSsapMiKyX2M3vAwHY7iSTRUOxJ+kHod64PfQczDv
	LeQ8JGR7tdhzgYj9A4IsbM7LaNWtqwf83ehQR//VdVYbVHJGz2MMbhEVRHA/uU6XAWM0zmvAsJR
	3d3j7a0WRRZh9DuLfmXret0PD+NdiYLiwcYo4
X-Gm-Gg: AYBFou1sZHC8tpoaLEYM3uA/EoiXiWLxcqkwMmkwojTYNaa0AG8aiTmeQB/m7KeYdDz
	FQ0DhercTsNPNNyIP8JxvPhSP549w6Snn5+KDbAMmXV/C08+Icu2NbnEn8qqclPX8jR7Jgbrv05
	62uXz7KEP3xXQXG819+v0XXqKt7rJ8E/+Umj1ZqKY0okaImRQe6qnPdnJ4vZGIWzYPm3fTvxbsc
	aG91N6xR4hQ4zlxH8/Yh2ugmOrq6B86htb7bkifuk66o0H6YB0EUbnV1kCRErLP/yri8PlVX4cK
	VKOF4XL32anOK7nhoXMdrvy9kxvJIkbJTlb5ltji1k+tg9GMAeZ+FSJ+hlt+1e0OhD/hJw0VJgh
	VoCOprxpapoc=
X-Received: by 2002:a05:651c:43c1:10b0:3a4:952b:b061 with SMTP id
 38308e7fff4ca-3a5a50741e9mr4778201fa.26.1789156207741; Fri, 11 Sep 2026
 12:50:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910161310.1478081-1-kbusch@meta.com> <20260910161310.1478081-3-kbusch@meta.com>
In-Reply-To: <20260910161310.1478081-3-kbusch@meta.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Fri, 11 Sep 2026 15:49:55 -0400
X-Gm-Features: AcwNN1UadWcHpCv7izTnp3L_PGKA6Amn4wM8moZnQX6JnbLuSNL23pcID11fTrU
Message-ID: <CAOp=CXmEGm0xoVsCEaLcnv7tOJVu2YKj7pX+JhaSOUPOBQpa+A@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] backend: don't mark a job as running before it has
 set up
To: Keith Busch <kbusch@meta.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 12:13=E2=80=AFPM Keith Busch <kbusch@meta.com> wrot=
e:
>
<snip>
> Widen the TERMINATE_STONEWALL check to match. It tests for runstate >=3D
> TD_RUNNING to find jobs worth terminating, and a job in the setup window
> used to satisfy that. Without this, exit_what=3Dstonewall stops reaching =
a
> job that is still setting up, and a test where the short job is reaped
> while a longer one sits in exec_prerun goes from 5.5s to 20.5s. Note
> TD_RAMP sorts below TD_SETTING_UP, so ramping jobs remain excluded from
> that check exactly as before.
>

I wonder if we should actually swap the order of TD_RAMP and TD_SETTING up =
in
the state machine. A job that is in its ramp time is part of the currently
running stonewall group, so it should be terminated when exitall=3Dstonewal=
l.

Vincent
