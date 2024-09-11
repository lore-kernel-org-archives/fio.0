Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C6C18C3E
	for <fio@vger.kernel.org>; Wed, 11 Sep 2024 07:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726038358; cv=none; b=NeWYQ5FIUWdyik+41iSwp44YiL7fUvX04B0itq1BDEIiwqkBrBb3KIA3xmtPP7pFN/m2WeqcarwqcA22kq0h6DHW+d3vHBalNnpwA6C8kR5mlCMEcR8Drt0wRih67ZXyhfWMwA2KCD+Ex2a/IdIk0BzsBJiOVhGdNoFthxgi+mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726038358; c=relaxed/simple;
	bh=7JW5kbrhr8kxarVhvbUJe2BlDknKiknx8dh0MD1IMlA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDZgpStgpvxI7sJZdQTgxOrAi5kz0R0O1a2H5zmR+0cKGdRJTc9DWQaPqAqPnTywxKJgk6H2dgx8xnUg01QF/kCzrEeeMz0w7UUyoZCB3QCoZPT22VDIw28Tlw3XqmsU8Wec/psyeNVwgdEAwn7nLln7jx1K84TedY/qbGw3Wj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zxf3G1Ca; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zxf3G1Ca"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-502c0ffd07cso1079820e0c.0
        for <fio@vger.kernel.org>; Wed, 11 Sep 2024 00:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726038355; x=1726643155; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JW5kbrhr8kxarVhvbUJe2BlDknKiknx8dh0MD1IMlA=;
        b=Zxf3G1Ca5BHFGFlu74Y512MfQwgDoKCbzTVn5JVA4+7y3qi2lpck2qnFdtVZNZukXD
         M4pV5AI34z0MrEUZjzkE7wY8nGua4p4F+Rx2YDufVqdtXvwFU/Xww1ELkp12/3ixM+EQ
         9BdfKO4r8N/Vrdo9yyHJxhc9iIkxE+SLk15uvPQcnxht6v9XhEq7XCeRMAZH2z8UdcsQ
         Pp8Pn74+gNhYP5Acd/wF0RqOTBYoKL6ITYnh0HggoxoMsumOJqK+OOlAM1Z8n+GCenSp
         oonlDZ2tkL8U4MGAXaoABc1WUwacshTmtUqaed4QoSyPh7Fby2gnEU+qAGkMFICN9YyQ
         Yo7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726038355; x=1726643155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JW5kbrhr8kxarVhvbUJe2BlDknKiknx8dh0MD1IMlA=;
        b=Ez+x2CdPwmKyRxF4n1hBRkjovMr+L4zTTR3Wqhah6eiepZZv/C7JbedkVJe7cPooAd
         oXmudoVUa0ajr97558p3BxIXdSq9cS+yqjju28OL7DRgxX3kf/40+cNx1xKcYocnzbwo
         W3Qaq6o9SRQTLuWVHUJoxpLWVhDScNfRD1niyYzC/Q1IKeUQjW4pv1j6rZyLCS4Wmv0k
         DQo+frpasej3z6PpOW7bvK0WLuNVhRmv/L9VHUO23RLIdwozYxQjzJqHRtFyhpOqEl2E
         x1MkF7Gw8CCgW9H/kDALgCAx3vEM9EIcQfon7Ucp85+lEvh0FwGnsEzcRy7vSwiSWwe6
         HA2g==
X-Gm-Message-State: AOJu0YzSv4Ah7k7LBN/ozNwj7jkf9f8/2imEzk0TX0qwwKKiX3Ywbi/h
	4SszIAt7M7cLxH41+f13xLO48ydtpqK7fGnfJqcHiQwaedWbExXoU6gaDFGxUIW+Atm9jraN9ft
	xzzv0CqNr15T7oIMKZ7aucnkOCQhk0A==
X-Google-Smtp-Source: AGHT+IENu9KsvD5vej8TremTqQhSOo6ZGbz9ZX54ZGpowPL5DngSQuKLJtk871cQ2q6OSaLPVdOBjDk+hjaQDtC9cvc=
X-Received: by 2002:a05:6122:3123:b0:501:2556:1cd9 with SMTP id
 71dfb90a1353d-5022142350fmr17647218e0c.10.1726038355400; Wed, 11 Sep 2024
 00:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALeYq=AP_h293ZrkixjFLxXzYpB3nm1YgAyZxYCMHW=ByvxBWg@mail.gmail.com>
 <44241ecf-7130-469f-8a10-873be7e464d8@kernel.org>
In-Reply-To: <44241ecf-7130-469f-8a10-873be7e464d8@kernel.org>
From: Anatoly Belanovsky <abelanovsky@gmail.com>
Date: Wed, 11 Sep 2024 10:05:45 +0300
Message-ID: <CALeYq=B+drGz9Gafwf80FooHyXsYDbb70N965zFx8jS98VNAdg@mail.gmail.com>
Subject: Re: how to fully load RAM while stressing SSD using fio
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your reply.

Let me explain my final goal. I would like to evaluate my server
thermal restriction, so I want all my components to consume as much
power as possible.
When I run intel ptat I see that RAM consumes 370 Watts of power
however when I start to stress my 12 nvme with fio RAM consumes only
215 Watt of power.

I failed to run both ptat and fio, since ptat takes all CPU time.

On Wed, Sep 11, 2024 at 2:49=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 9/11/24 03:01, Anatoly Belanovsky wrote:
> > Hello,
> >
> > I would like to stress my SSD and RAM with fio and I use command
> >
> > fio --direct=3D1 --rw=3Drandrw --rwmixread=3D90 --rwmixwrite=3D10 --bs=
=3D4k
> > --ioengine=3Dlibaio --iodepth=3D256 --numjobs=3D2 --time_based
> > --group_reporting --eta-newline=3D1 --runtime 12h --name=3Djob1
> > --new_group --filename=3D/dev/nvme0n1
> >
> > I noticed that while I am stressing it with fio the power consumption
> > of RAM is much less than if I use other stress utilities like intel
> > ptat or y-cruncher.
> >
> > How I can run fio to use full power capacity of RAM? I tried to
> > increase numjobs but it didn't help.
>
> Remove direct=3D1. That will add lots of memory copies. But then you may =
not see
> the real speed of your drive due to this added overhead.
>
> --
> Damien Le Moal
> Western Digital Research
>


--=20
Best Regards, Anatoly
