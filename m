Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E22614A60C
	for <fio@vger.kernel.org>; Wed,  4 Mar 2026 00:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583279; cv=pass; b=jO7anMv0uCRRdcf5cGJ7jQb2Yq376VI0D4h84diMTxudImoohm+BIIdaqsZtw5JHIqj0N6iT7ea6n4mfVZKfJadG7i9haY/+CFa0/zMz1ZyghEmRZaooH9WgwdwYiKapOiKJj9TolBUjl+XsgRIcGYz+Qt6xCxeK6D/ARySXhwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583279; c=relaxed/simple;
	bh=AV/rUJLef8VUfgTZe8MizX7mL89i4s5zFQYjnRy9KCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gqksvjjVit2gC8Z369zA/N9b3VqktVmLEgB4DMsVNDSVP6BGa05Y+9QNTbtvbYXHdwx2xiug6TkQCB5s3IDdnsCAFfyDggXG7yVL7XSBmNrG82cNKGZL/5NTaBoAiXXCxMrN3eFUlYnXXfXWrlarPzdTAr91Lb3HGYple1dZHCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hM+16/+P; arc=pass smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM+16/+P"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38a283adc3aso7220031fa.3
        for <fio@vger.kernel.org>; Tue, 03 Mar 2026 16:14:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772583277; cv=none;
        d=google.com; s=arc-20240605;
        b=DgRhDV7hVmvBus3nYlHxV66XSRb5R2t3HEZl+m/SE56uQODbE75srsI/VGVfMTQUnA
         cLVBkDA0Ah2V3uBewXsWO5V1soQgKorU4IPaTE19LVIL+p8ErsjcxI8cUFD13F/TNWK3
         ylXukof0EQvqoMmBx8Hgj6CQTXXXh4A4msYZu13P/xeyag9Tw1ZyrXM/R8Av7SbSkzBe
         28gvrdzNmmqM/jddIuAEzUMt8AJxvwzMJK0F/wbSi+XD0YnjkR9zQ1wQyeu5cNz5eQIo
         R1jsA2cU/JWXNHXAzTvr8DKEGKL0hiex7nCm9lRVGSSeOdqdZzgnWUbugctbN6ABM8bQ
         pXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zpLaZRbvgRwg7UDXkFcHayZs7bd7Cq101v4vjVTHbus=;
        fh=k5DC5lFBnQoQAJUtOXIH+fI5BBFj5/t3YdQ1lYmC4iM=;
        b=OZrzxHycTBq6ouDgEE6MkkHjPz/tMCAw5XCfl52uH2Z0b6SOvuDvvSSAXmnSPFOTNl
         b5SduK34taqb0oL9fDoJTEbz9QMV7KNolBHrWzL2OF3/W+3jxefw1fdfYsukb+bh3V59
         FbAzzW10p4CyjkkXBqwHlWCRCdZ1yVI/Vf7Jmlu2Z3pcKyfOCvU0vpU0X4JXNpff8vQ6
         64KpibPc1hXw9ulbgBaWEQU0nQJJoDQXLC27Qtl/hr/YTGh7og3zbfZFt42jIvPS6A9k
         nAg+AzuOULm4pkb9qXhvIzssOYzFB0U4lKkoJHSbsdjyzdz/4ZsN6Tr8si+3XHFoTriv
         +S+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772583277; x=1773188077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpLaZRbvgRwg7UDXkFcHayZs7bd7Cq101v4vjVTHbus=;
        b=hM+16/+Pqdu22ziw1x58AHK5pvdf81PninGjT0AUdTqjSg00pdSGPdr+k01+ogjvWd
         3bYLYAnD6Sa5ZmYKGiSexjyU46HxC7LMTIvBdzfcy4TydCrvmggWb+OpYmeVl7hhABw2
         pEu9qdhS0dQD+hJkIRPxJNDn42q9Odsce8TsphTYVH9KmRfKqbhr5vKb+zcCxMrkG2nl
         iVhbkEaiSd4NkwhCHWyoer/9PyTdnuKzgSIoRHLW0qYbkjqMDXQClway0S2Qa59vwg0K
         I3wXO+x09ZrTvfI/LYG0Bxh1XDfqv2RiX6UM9YfUQWzRfsLu1JMMkR/+NCfPysGBbhHC
         3klA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772583277; x=1773188077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zpLaZRbvgRwg7UDXkFcHayZs7bd7Cq101v4vjVTHbus=;
        b=CWJ1pcv95cZsHFasZCc81hyv3+Ci72ALQhNzRMgUyxz2cVFdRAvK4aeu8s2TpZZpj/
         TtOHtT56Q3mxQ2X27mLc1nmIq7MM/qC4voDA9nVRykkWvlj395WL1Yyyxd9YVAGKqgoT
         RpPlqdNrTq2Y0DwTqv5sXUCRU+DYzR0Uxkw/jTI0LKVcS8AkpzgQLILd7OWvJWZpZnBF
         d1vqt0x0CXcc374Xeni4ki79FHsAqTEUdlxH+1MszjsWfEnxGC85pMtZNt/3BPTOESmA
         hLC5LIy6dpt2mIO35b4k7EUdZfI6vIubWE0hc8hkRf0URYT/RlDsxern2GEroP103V2V
         cqeg==
X-Gm-Message-State: AOJu0YyEHZUltlgQaCFnc3u6LekC4c1itG90fSGW0U55Xct0sjFhrht2
	YW9jMixEcWzNuLEeIRBRZuV9jocSQlnybkmfj+C5pQf88L09sWuJaB2GcYb6v0uANvA+qnojWX4
	liO2kw9LvJ/RxF7dFLJ9nkP+ifjan/BE=
X-Gm-Gg: ATEYQzyGaLBOX+RHxe0/jjMP9LK4XrkniL/+iGG902tTMeSNdIC353qRWfhMAN37Pf8
	vSWV2EqPVEeLuzyENGcrrT5nIvusqWHiRL8eiXupDeoEDnbg7YfxZ1gVd6sJQI2bHbV4Ksld5EQ
	6BXJNqw/w7ZsHv1Ix2WjDh/C0FVWyXzov1eL6p1lE8Esa34ppboeLWKabzf9IPuvLD8WUuimVN3
	BqU1SwEheqexUCdwWknJ17X9kTN7G0uKFbUQQoI6xSKPAU6W+Y+X+YpCga/dDG8RaR+G2TTR3ys
	EFrxXg==
X-Received: by 2002:a05:651c:160f:b0:38a:23dc:643f with SMTP id
 38308e7fff4ca-38a2c5a55ddmr1740231fa.15.1772583276476; Tue, 03 Mar 2026
 16:14:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Tue, 3 Mar 2026 19:14:24 -0500
X-Gm-Features: AaiRm501QYXIBpSTCDoPN5oxfy8IwjbyNrqhRFnLhuOIZcPZDh3BobPs722nbmk
Message-ID: <CAOp=CXmVLq=a0OHdUVSxXPbaM6eK4FSxEL8_JMWmh+Amw4upRA@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] zbd: fix problems of random write with unaligned
 block size
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied. Thanks.

Vincent

On Mon, Mar 2, 2026 at 8:32=E2=80=AFPM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> When random write workload runs with zonemode=3Dzbd and block size
> unaligned to the zone size or the initial write pointer position, three
> problems are observed. The first one is write target zone selection.
> When one zone is filled by the write workload, the same zone is selected
> as the next write target. This results in writes concentrating on
> certain zones despite the workload specifies random write.
>
> The second problem is wrong write target zone accounting. When a job
> selects a zone for next write, another job might have removed the zone
> from the write target zone under certain conditions.
>
> The third problem is write performance. The writes with unaligned block
> size leaves small remainder areas at the end of write target zones. To
> free up the zone resource, current fio does zone finish operations to
> the zones with the small remainder. Fio also calls io_u_quiesce() to
> prepare for the zone finish operation and the write target zone
> switching. These zone finish operation and io_u_quiesce() calls
> significantly degrade the random write performance.
>
> This series address these problems. The first two patches address the
> first two problems respectively. The third patch introduces a new option
> to address the performance problem. The last five patches adjust the
> documentation and the test set for the new option introduced by the
> third patch.
>
> Changes from v3:
> - 2nd patch: reflected review comments and added Reviewed-by tag
> - 3rd patch: fixed conflicts related to FIO_SERVER_VER and the 2nd patch =
change
> - Link to v3: https://lore.kernel.org/fio/20260302022609.3526823-1-shinic=
hiro.kawasaki@wdc.com/
>
> Changes from v2:
> - 2nd patch: improved the commit message to explain which workloads
>              remove zones from write target zones array
> - 4th patch: reflected review comments
> - Added Reviewed-by tags
> - Link to v2: https://lore.kernel.org/fio/20260216075936.3318729-1-shinic=
hiro.kawasaki@wdc.com/
>
> Changes from v1:
> - Per discussion with Vincent, keep the current zone finish operation as
>   default and introduced the new option "write_zone_remainder".
> - Dropped patches to remove codes for zone finish operation
> - Moved "fix write zone accounting" patch from 4th to 2nd in the series
> - Rebased to the latest master branch tip
> - Link to v1: https://lore.kernel.org/fio/20260109023603.2848421-1-shinic=
hiro.kawasaki@wdc.com/
>
>
> Shin'ichiro Kawasaki (8):
>   zbd: fix zone selection of random writes
>   zbd: fix write zone accounting
>   zbd: introduce write_zone_remainder option
>   doc: explain the option write_zone_remainder
>   t/zbd: add -m option to enable write_zone_remainder option
>   t/zbd: avoid test case 14 failure with write_zone_remainder option
>   t/zbd: avoid test case 33 failure with write_zone_remainder option
>   t/zbd: avoid test case 71 failure with write_zone_remainder option
>
>  HOWTO.rst                     | 26 ++++++++++-
>  cconv.c                       |  2 +
>  fio.1                         | 25 +++++++++--
>  init.c                        | 13 ++++++
>  options.c                     | 10 +++++
>  server.h                      |  2 +-
>  t/zbd/run-tests-against-nullb |  6 +++
>  t/zbd/test-zbd-support        | 45 ++++++++++++++++---
>  thread_options.h              |  2 +
>  zbd.c                         | 81 ++++++++++++++++++++++++++---------
>  10 files changed, 181 insertions(+), 31 deletions(-)
>
> --
> 2.49.0
>
