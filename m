Received: from mail-lr2-f25.google.com (mail-lr2-f25.google.com [74.125.230.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A354CF6B
	for <fio@vger.kernel.org>; Tue, 22 Sep 2026 15:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091608; cv=pass; b=Z8dZAGKeMkGCWMxg2IzHYETsAzlw5IfZvltsNiH8HLHnIjybMoeJpbdoA+2rViVmlR4NqnvFHnrpigwVOVLbzfnMdlZStSPIMc2w+Sd53hP46kxgm53XseKqOsAUOYwZz+Z1AbN6eIllpW8wl86bCdCeKp30hijcY+5+GraotOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091608; c=relaxed/simple;
	bh=DvZViCKD77/5ULpUDr+kFNvxJ/k327/1hwcJZMaQpOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uesb0AWDbtCNpb5DO1OQmcqS1D+GUadN2SbuSpNc7rM6CilaxGem7UzSy6lxwISTkfSLleM86RAw4Xb8OuzOXK7GjYI8XvLgUTzwteZh8By3jK81ZHcvcWA8XHCSZRgAzH/zrkPhATYBGAOaDdNqWwTpQHNM3w3jZ24qqvPypOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y245Q1sX; arc=pass smtp.client-ip=74.125.230.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y245Q1sX"
Received: by mail-lr2-f25.google.com with SMTP id 38308e7fff4ca-3a2ff17443dso45880361fa.1
        for <fio@vger.kernel.org>; Tue, 22 Sep 2026 08:40:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790091605; cv=none;
        d=google.com; s=arc-20260327;
        b=HAfkO3HUdlyfIpXM7b3Jd+4f3Cc2xgpv97mkBcgw21ogLkz3iUK+UAoH3a3IUi7xMl
         7ugpSVb0bYdwaqaQCZZAxtKm1Ha0TVUXkmVRBafi+bupkl3KQ4ZDjAPXn+tepbJ9m7GF
         QGPzCwxh/4dkF3nw50VEoBX7GBFFdTuNobc/9q8zws+/vvnzvD3NOuAtagpTy5zLJwJN
         8oEHKnOVL+T8xoq6yL5uVvxfeIO9NTTANZ7/QxV+3kfa7VR+kQYN5PR1rM5oQB2UodnO
         3BAVo5ZWfBpud8vf7FMd9l9aKmUOwGcPQr6lpkD2bso7wMm69ngdZSxXiydj4oLWv+09
         BoSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DvZViCKD77/5ULpUDr+kFNvxJ/k327/1hwcJZMaQpOU=;
        fh=Kl6F7yvf4czyo/eedW04ixGw46+/QQw4GW5u9O7r+QI=;
        b=W/BSj9bBsqWmXTnjJB1R4U2izaw/IBmkqO/w8qDTdb/n6LmmoVzprYoA5se5avESBm
         AQM6DOrMWl5mWU3M0ZRloFa1sHKdVoJfQRpZknU4TuObNAnXw76GUtm8GkoKHuICQooi
         UVyGPdFHuvo/9hP9LQDdkiV1eaqNmIJdcPGKyVUUAIziEW4TDtSAuqT16ALsFereElSL
         2b+CnpJzOKKANSGRjo1/QGpiPdIqJI0x7CreegzILP72JVGwVJ63tN4/UPykT17lqFRx
         sxfUMA50tF55U5xXxc2sjht5CCIsjd8KtihaSbe+zdkm1bIHo3BCpGyGNElTOepI5EFP
         SzNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790091605; x=1790696405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DvZViCKD77/5ULpUDr+kFNvxJ/k327/1hwcJZMaQpOU=;
        b=Y245Q1sXSWWcQje3+CwydJvEa/aDr5tgCv/jFZbVqfiJ9fyQ+bUgf1KI1tFUniHjwe
         EBwjmO4dFOiOzZQSm6Sec5cGrQSm6TKGW7vckiq+2ew2betUWfLrhN7z3Fq1OnNpcL5z
         vEoP3iYTvoWq8mATeFOQVVb4GtVlhfL4jNnbEs/dqv27HzsxSaZiL8ajSRnAYNywl/Uo
         XQBJndPNEJQHIbDWI9wp0Ee0rXKyhcx6EMLdoF9o7mk7R8vttiUJr/oL3E1FR1+jrV77
         O2UHojau6rGP6I3KO7pgte5EQ+L3rUR3or+rWJmetIEU/uRWeK9tipUdE7dJWgCSgnL7
         uIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091605; x=1790696405;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DvZViCKD77/5ULpUDr+kFNvxJ/k327/1hwcJZMaQpOU=;
        b=lvl2EsmuEh9e60VmZgVnhowzA0Om1XiRYnrITRMbKQ2woI5PgdRlMjLJKZHFwkEhi4
         K47FcKyReJxUHpQYKb4qw1TLznpQlG91dvA+k31G2/pd0+AreH6OtTV+hH/13Ws95QUG
         hEf406C7RixK4Jqs91qy1H8T8W0gfhBxzt2N6QKasCr77GDjb5FD4a3okGKl3pbt1UYf
         VQP5eO46760gBBaxju/uYD39R41QExvn2znQOtQy4piXIKacKkcT19v+NyVXU+QY2GQo
         RyhLAb61Ck/XB7yGonDpBO5ZTBjHI5Y28wkXZtPOuz9GxigAcw8PA3LdIPyzWLPUbk8b
         lFOA==
X-Gm-Message-State: AFuF++nUgPH2qn5LQ+UP0jcFBFKCpW2cxnptrLz0xZHkYrZo/rTitz6e
	gbh2h51BOvWWw4+YhXvsWiHvO9bBnMOLPYwp+8u2ayGGpms7HG85gOkfcJdSsSlzUN7XWSbKjFI
	uq13TLaut6WRlIC4iUYk9fqntDTgOExM=
X-Gm-Gg: AYBFou1I1rgxMiVzZzvO5RndXG2JlBxrEPgj+RMSz5Sr8EgEzioN4VCB2T6WEzWT1/Y
	0C7ht4i2F5duMHnuZHm6wNB29viRbLXRJmkdalWt/mh5GskaXt0EiXd8q5mo1bPT7F2o+tDEwWh
	21u2aAmibkobQ0w8lE8zTHGTAwOmho/Qnbmh2sNggPFEONcjBxRTe9qn7v4e7gsgSCczDnfQXZc
	nsoGhCsQTJGINb6qsB1iSrwRPYZ6xsl83NGTexld24o6CShEw2q1NcDJ3YtoT9DKGvoUgL8T5LK
	NASMfNHI3qkeH1ndzD5YrO3D2k8TN82IHP+FMW76GXD5z3KbS/Jk5NSNV3qShdYdjiIP/7Mbtp+
	IJ06CZ1SJtp8=
X-Received: by 2002:a2e:bc02:0:b0:3a6:16a2:ca87 with SMTP id
 38308e7fff4ca-3a616a2cd8dmr15398401fa.18.1790091604364; Tue, 22 Sep 2026
 08:40:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>
 <CAOp=CXmANYTw3at495z+G3S9injh2nLpgOP=_vQ3LBtbaF-G_Q@mail.gmail.com>
 <20260921232021epcms2p5c738e175300ab42e01655efe7535dcaf@epcms2p5>
 <CGME20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p4>
 <CAOp=CX=timCvNWUNpkR-sRpwVJ114mzew4-CuQbMTvj4v_tDSQ@mail.gmail.com> <20260922021238epcms2p4439e830aebe8bad4c39f52a1bd03501b@epcms2p4>
In-Reply-To: <20260922021238epcms2p4439e830aebe8bad4c39f52a1bd03501b@epcms2p4>
From: Vincent Fu <vincentfu@gmail.com>
Date: Tue, 22 Sep 2026 11:39:52 -0400
X-Gm-Features: AcwNN1U2jqSBWq5OpKQITnCPpUuSnYc1dz59hocKGdjt-tig8H0ZvKmVP7k-zws
Message-ID: <CAOp=CXk7EKjb1EKypuNt90V0sNEporQmGhpG2MO9vZj-GySrKg@mail.gmail.com>
Subject: Re: [PATCH] examples: add seq-rand-read-write.fio
To: jieon.seol@samsung.com
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "jieon.seol@gmail.com" <jieon.seol@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:12=E2=80=AFPM Jieon Seol <jieon.seol@samsung.com=
> wrote:
>
> Thanks. I took another look at ssd-test.fio before reworking the patch, a=
nd I realized that I had described the scope of my original patch too broad=
ly.
>
> The workload I intended to add is specifically based on basic mobile-stor=
age performance testing rather than a replacement for a generic SSD test. I=
n particular, it uses 512 KiB sequential I/O with a single job and 4 KiB ra=
ndom I/O with eight jobs sharing a 1 GiB address range.
>
> Similar workload characteristics are also used in published UFS/mobile-st=
orage performance measurements, including 512 KiB sequential and 4 KiB rand=
om I/O.
>
> Changing ssd-test.fio would therefore require making choices about generi=
c SSD workloads, such as the appropriate queue depth and I/O engine, which =
are somewhat different from the purpose of my original patch.
>
> Would you be open to a v2 that makes this scope explicit, for example as =
examples/mobile-storage.fio, rather than changing ssd-test.fio?

Yes, please send v2 describing it as an example test for mobile storage. Th=
anks.

Vincent
