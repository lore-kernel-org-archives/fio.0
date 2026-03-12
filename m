Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7648C1DF26E
	for <fio@vger.kernel.org>; Thu, 12 Mar 2026 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773322540; cv=pass; b=rYWxPyxev6rKCEVd1wRPscPg65QiV1zFFTvf15VNR9pn53xFGli67QVhwqPpRjrAt2BvZXPeFx8uX28nVDW9jsQvpRLNafWALuz4LZsOJwncdnxNZHNfArCBe2k3Q145I6MDFPIBlaopgOdJSD9VTnXchQyWvqSX8IVPd8pLaB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773322540; c=relaxed/simple;
	bh=pO62/2un1pIt8ShRdoDVyTIOwhP8ERfLMfEFT1RLWGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hl8RLsSeIttbcSkdCrgl9kqr2KA+gbfrQiUHOdXq6VEpP3aYwzm/hs2TKNwQs9Fj6j8sRgtOyyuN18rOyXlZaX+jZajOd30BAjxkSa6w2qICgMP1N8lbOsWSrIL+9JcgL4wlcQg1wBrBKk0bGvCRAyKKsdANLgxNrYHKTQBtwRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e9GTJII8; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e9GTJII8"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38a694a3cf9so9416161fa.3
        for <fio@vger.kernel.org>; Thu, 12 Mar 2026 06:35:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773322538; cv=none;
        d=google.com; s=arc-20240605;
        b=iVx70NGoZE4PJoUv3w7Xh6/WLIv/AMVWmCExl1G9i8xrbXW6xyMVEJ2NUyXsiWEA6+
         jE9DAW9tOQtIow3SY6yswlXFVtiW+EFEvterrPR6Bj/QS0q90wLjy7yy6wq/sG/2KOkd
         HL+kZHJ8+IMLD4QOiBSyd4CDsjCDRvQVm+17GRLqCFW6HSE3UqsULKeibCe/XmCOri6m
         HK3ep6udZ81wcM3d3YDVEtcQXhMxkmcDmNkmvxT4srI7/uy3RlF9prVarcC8XzvQWsso
         wwrtWdzNTpgQ5ND4Y4kRJglFAp9KjE23QoDZw/eDheLoj+bjfOYdj2D0zZwNmupw0RiL
         l31w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vWiEiixf/+VVQvN8nW03s/tkFhnte5EgBfVZrdhCh2w=;
        fh=dJVWyUrEQEsYbkJp8onQmdtdVq9KfC6sbwE/XF+NE4I=;
        b=VQQsWK6B7WP/Cgh6zj+y0Nb/LwiiDyEou24vuJ0ts0nvDflsF0lXUslHP6key9az2M
         9JPImQCsGCne7lZ/IVV5vN9kCTxoZOe/Vbb7nSgomquV71Gpr15rbpXz558aRwpThfTw
         Vnkzol1wZ1Qci5kcSXqh4jbfwZ6QRcj4xkhoENOqh/6lsY+1HsyTpQ5+TUPwCabA7yQC
         ph5Yzz1twZiLREIn7Xo8hnfsJTwQ3YQ3Pnevi8WBDA3CJlSPeU99hoZlbh7y9vOHfXQo
         QWwmK0UrH5G1+1U1gi7CMrkCkoBNc2x5v7h32N3wf8I4iaiya/tusZNvaqe518TRhZMx
         Y9eg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773322538; x=1773927338; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWiEiixf/+VVQvN8nW03s/tkFhnte5EgBfVZrdhCh2w=;
        b=e9GTJII8MGjEDRHaQOAp9eLdRV3IB1TJ/1NQ0TP9kfVPMgVFYgHHmADrYFjNOfm6iX
         xApPdzq2r0mEnET7Qm8FINc3kmShFnGeY0+htNbEVK4Tz/fLdHWP0SbxvzFV35SBfgQG
         w7VP3NzEAIuro7+P40JOvQqA2IwRPqqDSmHHfotbvCSl+RIEsmhDHRo2RWUbOcWUBCSG
         /NHsP83IkmsLxE1v+d7VVqj9nw5LwF7HxGYzQ7fgPzWBkOJi/+BLjiip/AvzlsHacly7
         YxgW0zdy8RUNOFiRDsc+UvLcPeoTgvq56Hfwwnt5BPVeLaYuwCTJ5iDEvPKyZqDDqdHR
         EciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773322538; x=1773927338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vWiEiixf/+VVQvN8nW03s/tkFhnte5EgBfVZrdhCh2w=;
        b=tJ1LvG+r+EIRUxv+6Tpa2DiEt4IDoYIPXe0Lu9zoAXFvHD19d73XdbRtDzwMw2Y8gQ
         2TKT12lviKHHM5SMdiNG4OsGVhEWAvonZ440Nmt5elYoeXLEcwIioKMD0GeYUc1yW3Ow
         7UQh8KCq1dMyxUSb/xmwW3uCASaGqG9iLUBYXMfuB+M1X429bhWqRISi+vlaujxKScVL
         B6YiBvX55q2n3xWEPs5Fk/mi9nBx6+xsI5MDfOx7SPXc3wnSXdY9GhUZPWaVZmDNYWh9
         eWl40mEUkBt5enuxo9aUlz8LLpXiPqWd934Goh6TdlGzWk+PhDG1aDjioVAH2Loe9tl1
         WAgA==
X-Forwarded-Encrypted: i=1; AJvYcCWJLgcGbvSbve4vS9gyTkRI3kTTOU0VNM1HmOApgj/bPbAhmYLHZH5WoaijkArKs2uR0Gw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx85SNAjf53EBoctE/pV0cTQDc5e8NCJkVH/Aq/ua2lLvjYxX/F
	l4lRTkcA0TeKjG1HFr2VcyUZ5ysFBYuJw5erKWOrjmQCvozE0dyDlf95CVlmd3RYVqSZhPt5RRW
	hv2pK6IE+lDkt2Z+rJqb6FRhThx8qUlU=
X-Gm-Gg: ATEYQzzOqEyt2zjLJv8lPznuwvlCmKlO4C7FP8CCboVgBGl0hCbU2fqvw3j8jXraZ9c
	Oo9G4tPhmLkkU8DnTwVHmCkeJpI/7c3Wj+Vos+IzsAd8F5hCbPReFM/cilnajkbxfGDGrRWDoWb
	sdZR6bxHuwniAVfh+tDTtFOrHVOMsJ57sCXA4/eSIaglQOlM/bJP0mkNOod/FlbfxPUHrqKDDth
	gdUcE3tPgjwJefZatA2qkcg0TKGEfUrNXW2uUrjrRMKJjx8mcWcWbshevntAA3+D00UGVRFDX/9
	Yy5+Bg==
X-Received: by 2002:a05:651c:1987:b0:38a:4bd7:617f with SMTP id
 38308e7fff4ca-38a67e5ddb7mr23769021fa.21.1773322537402; Thu, 12 Mar 2026
 06:35:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311155114.198006-1-npache@redhat.com> <20260311155114.198006-3-npache@redhat.com>
In-Reply-To: <20260311155114.198006-3-npache@redhat.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Thu, 12 Mar 2026 09:35:24 -0400
X-Gm-Features: AaiRm529wFn1JjojVkfEiGq6rLFo1EIGN5-sfBsibMVtSP6LQPw2F6XThBBCVdg
Message-ID: <CAOp=CXm0bB2MKjZoYuatyVMLwoiUrEUVR_yFpYU00Ouvyh3DhQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Documentation: update the HOWTO to include the
 page_fault engine
To: Nico Pache <npache@redhat.com>
Cc: axboe@kernel.dk, fio@vger.kernel.org, jvozar@redhat.com, jjurca@redhat.com, 
	jhladky@redhat.com, peterx@redhat.com, spetrovi@redhat.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 11:52=E2=80=AFAM Nico Pache <npache@redhat.com> wro=
te:
>
> Document the new page fault engine.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  HOWTO.rst | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/HOWTO.rst b/HOWTO.rst
> index e712ee2e..421e6408 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2376,6 +2376,11 @@ I/O engine
>                         several instances to access the same device or fi=
le
>                         simultaneously, but allow it for threads.
>
> +               **page_fault**
> +                       I/O engine that uses an mmap region to simulate d=
ata transfer by
> +                       allocating anonymous memory and copying data on r=
ead/write to
> +                       intentionally trigger page faults.
> +
>         File/directory operation engines define how the job operates file=
 or directory. The
>         following types are defined:
>
> --
> 2.53.0
>

Please also make the same change to fio.1

Vincent
