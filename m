Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF2E1A275
	for <fio@vger.kernel.org>; Mon, 14 Jul 2025 03:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752463943; cv=none; b=qB/68ID/QUDmCVH1HKae+rljCm+AaZChTU83o3PWuWeyNGuJROxbPXuAqsbS3Pgcxc+JW5njIqalDpusiD3vBW6zOxW+FnSem6lhOCXikW/fCyppdZOH3/sRRUaDgI59C7DJQqwpahK2EARePnQxhy7UGiXqsRqgMrCB1M3KfVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752463943; c=relaxed/simple;
	bh=LITA8YENtXG0bS9EJnDBjQ45iJEAHuSV+e2NZiwsUok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u3ebEhxOXvueu1aEYYiJoYqVn3+9aO7iqdcgA6lRMmI77nDbCPZYsK3eDqRRrdXW9+40TvbWZi46qUqa540BdYAVnFRg9UuW7pKUG/y4IhEmcWUqhf+m9CRb3wMKWW4688EOzDUTWKyChkwExJwM8xSWOjaneBKtNIDjnOIdSok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJ/chJOd; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJ/chJOd"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5315ebfd92cso3209860e0c.0
        for <fio@vger.kernel.org>; Sun, 13 Jul 2025 20:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752463941; x=1753068741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LITA8YENtXG0bS9EJnDBjQ45iJEAHuSV+e2NZiwsUok=;
        b=dJ/chJOdwX8H0mGgIiPRT/CU4EVeawmom8kCAX2Yfn0Zkdvj/dDTApqRBFe00phE1K
         a+uCTrqqBmvoAcDzOE8k+DbGLywRVxo100rZ9QOjExpul7cMo2X8urRN2Fj9wqMhS3Ec
         pbUBn34rHYyOeNB7nysPS4dkwgQBWPKuTe6p/Z7HTeAMsxYocFB/otETElPv/cwVvOJ8
         sOiQXnMQ0iT0x33NteP8gHnniOtRqvx0If093w+JV/kk1CJeh7cH87gZ9TVW1Ak/x6el
         DPitMThnG+4K0jrceQF8tj5wBrhAyNz/mq8g+1lh8ZLIlYT5ROREXdV5JHd12q+08U1v
         i//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752463941; x=1753068741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LITA8YENtXG0bS9EJnDBjQ45iJEAHuSV+e2NZiwsUok=;
        b=CShE8/hMCfLv0k1qpzl2AfcRC0lkvE4oHeVlB7VQYFy5dDOo0IWsCZruH0jWyOWRB0
         nZJ7mLVHT/0BRqAXR5xQ/K7alaAu7lAGGSDGDelxnAiTdJLJa1EIMdRUVYw6CeeGRvn2
         46xVxCKzQXMRZsyfPn4iXheX0yw4zjxk6LhV51ie5zJl3myayvxf0hZxmlcC8R/Fp2KP
         KzmoRGexNwLAcaFc9OFNz7y3PLadx63Bztc5rNdRZMSzo0v1OSPPGJfYUGboKqZmtkc3
         fYfCIHNt9oXBX/7KxHnUnqQ3GNaU9i3vDgGqZUU51gLKZ7ld3hKNiP9qFx3OBDxD3rEH
         aUPg==
X-Gm-Message-State: AOJu0YwxPdLpQxx4B/LbPAW99225wFSGvNsr4u4zLajAXxrm7EhdNh0V
	2RUqXWxtOyO5DofPyya8pbkRCL0Fw+CFqZJd6ayN39WABSVxY1nyOFpBUaHVwGlY0mM1JslRztl
	clnhwDMaakGjOdGgfw+pd1qUaCttqDRBLFyun
X-Gm-Gg: ASbGnctRqEtOm4Rp2yZP241ndf7EnTOos91yetjeR5YD7F9IwGu4tY6Zq2eutMFhcp5
	BeU6ZmgO4ceDjpi3yM4cfH01Tt/cVvtmIQtk6rZlPK1wh6Qy6ps0bC+mar4E9gtyY/mSoLJT7yc
	pWOiHh6/qnwosCav3oua+Uv2SNF7F/6wTnf9OY840RygDJZA3xzPEHUdjexJhmjtcvIEFoAsaEv
	y1jIDVdCqKnr59Dm1V/3uGNnvXarrQLOddDkmUmjQ==
X-Google-Smtp-Source: AGHT+IHSrRVFOqRxcEF6wEubmyoPpxUTgVlOJYCRsnGOERc/S/DtLVn3xM7N3EDfa/mMPjDM8mqDFifwT1R/Fh99nhE=
X-Received: by 2002:a05:6122:8c1e:b0:531:1314:618d with SMTP id
 71dfb90a1353d-535f34483b8mr8145194e0c.0.1752463941205; Sun, 13 Jul 2025
 20:32:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMjwZPGTg_xv6-YPA6PQGyJ1QgMup9k0atw_VT4qw1=hixYkKA@mail.gmail.com>
In-Reply-To: <CAMjwZPGTg_xv6-YPA6PQGyJ1QgMup9k0atw_VT4qw1=hixYkKA@mail.gmail.com>
From: CyberGym <cybergym.io@gmail.com>
Date: Sun, 13 Jul 2025 20:32:11 -0700
X-Gm-Features: Ac12FXxFsvazAI5Hfjv9NLGCScgn0xc9cdE983lIK4tRJrHWCOANOidqZsBkO-Y
Message-ID: <CAMjwZPEfMEVj0coOK2UdSuK94ecHZAk4L3aPguBZpdcfxWnpiA@mail.gmail.com>
Subject: Re: Null Pointer Dereference in __bloom_check via Uninitialized
 file_bloom in fio
To: fio@vger.kernel.org
Cc: zhun.wang@berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Just want to follow up and resurface the email. Please let me know if
you need any additional information from my end.

Best,
Zhun

On Sun, Jun 15, 2025 at 1:12=E2=80=AFAM CyberGym <cybergym.io@gmail.com> wr=
ote:
>
> Hi,
>
> We are a team of security researchers at UC Berkeley. We recently identif=
ied a bug in the latest version of the fio library. In fio/lib/bloom.c, a n=
ull pointer dereference exception is triggered on line 103 in the __bloom_c=
heck function. It seems that certain inputs cause the function file_bloom_e=
xists, in the file fio/filehash.c, to call the function bloom_string on lin=
e 103 when the variable file_bloom has yet to be initialized. file_bloom is=
 passed as the first argument to the bloom_string function, which itself is=
 located in the fio/lib/bloom.c file. bloom_string then calls __bloom_check=
 with the null pointer as the first argument, ultimately leading to the exc=
eption.
>
> You may find the original input that caused this error below (please unzi=
p first), with sha256 checksum 78ac354e97f09a8b5fef7332dc3653a328ae955feded=
239b95eebaff6db9e553.
>
> Though, the following input is more concise and preserves the same progra=
m behavior:
> [global]
> numjobs=3D2
> filename=3Dx
>
> Sincerely,
> UC Berkeley CyberGym Team
