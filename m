Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1090F24679C
	for <fio@vger.kernel.org>; Sun,  1 Mar 2026 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772362104; cv=pass; b=qZk4nKi7A7Hs7VlKueg9r4RBHwSTwuFZKYZPPEyvj3+HsNpdm0Bjc7CVezPuia9sZCLiiffeoIyISllEyI+n+n8XfOeq8KfGWnHgY1IIy/x0B+LoHWi4GtyVeQu9J7xChIKpczLJyhxXelyysrn3XSqr88HY2nErFDXvpeMMokc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772362104; c=relaxed/simple;
	bh=+O1bUBWOqfDeXoae3xg5JeDwOKiN4E1kFSuekNlzTQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H/axhCP0xS9vbC8YaJndXCKqR5k2dHawHMmOzFOf3Xq19bh5VF45e4meSjSrsSUwOrxN05JCmSIL9Bmj5EGrkZuuIY1xo0XuUEAl6VVBrNyJRGBwiT9iHhYOeLJEeJwLuJ15r5WagkBZmH0F3GGFJF/bZw7i3amA5qgpHQ/L4+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ed6l3mHZ; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ed6l3mHZ"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65a26c220b6so4685066a12.0
        for <fio@vger.kernel.org>; Sun, 01 Mar 2026 02:48:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772362101; cv=none;
        d=google.com; s=arc-20240605;
        b=KRg3HBhLiVc/koDJ77K41NCkoX7rheJFGYD4uWaPWo28lp/Br9i7DKySp+sM7cOkFh
         9yteAPvOjH16ORokd6NmNrwMfiP5p1FZ9zn3VOdEbnIAaeiQTn1Rj7wtQL9ZsN0T1fNF
         R4xF7Wv39UxSUEzv4oJlmOfFYbUaBcLzvLVQiRPhgexDsxej7k7Z9+YEr3Wz+pGDxrFl
         W3QsnSKevMCtxv+LpUBBpalC1oXH66YPZ9vyn0JsKUJTVWK8vo96BaOtGn8mzjEfkuXN
         w86skHUO7umO1gT9vkCo4ylLFjf3o7d+3Jl5yX9L3oaaoZ/ul1l1kdD31kKfbPnCNJ1G
         yrrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+O1bUBWOqfDeXoae3xg5JeDwOKiN4E1kFSuekNlzTQo=;
        fh=qmZ42qblRi9psaeLN8SNxfUaHzOE2UN5Ew56SIIgx/8=;
        b=L6tiz1YJdQIZZn8ZhIy9wD5uncfUR9mIOyJjS1xoQZxDm7f2tySbPPOZTgcpEoZOMn
         mE666bn9pE+Ma9T/+EO4TZpiamB70MPuwEhFgdIjC776Ff0LrK9ppYIF76K+uussIaPC
         O8+qUwq3JEwWY7SOA79536Q3dWXGK8GRSSq9qt/dY8X0I4R2lhqoYoKg6bp00ORQyx40
         z6l1HWuVrAICTL2HQkY79ijhGf83o44ZWTAe1Qub6mVdaCGGsQVDd7d94yMnd7gtMERO
         qTq3On1mzLK3+DD0xCNLh0YZKDAZVp3wp89PPx4IxU6Z7omCVp+k/qE3nQXzLFkKkdJC
         q9Ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772362101; x=1772966901; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+O1bUBWOqfDeXoae3xg5JeDwOKiN4E1kFSuekNlzTQo=;
        b=Ed6l3mHZInkJWz+jUvZpGJIK1FVhqKox/7hsYc3rr5dsvyWMQsWGJJr0txG3XoGkJC
         //w+PSM1oItO6c2zEberwSJ5e/G1ykbZP4o07ZybASWCxrwQNlz+yhirtJ/unvCOm+yq
         inyeh4OJ3JJH61OdTgrgihicF+htc11O0dcP8ICXCsUL6RrFsB6LJOUYUMBGkt3Am9g1
         hgICsboxd6dd3iPj9JKgJVCVMtR5A7K4bUUmWnpKtyrrY3UZSr5uSfyBMBfxlmNmKTCm
         n5xiDZ0nan6NLjDNeT2jmLn7G2FveQtgNUOEy9C/lQNyA/5g4JpvJnMmSUqWx7bUsWf7
         1gYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772362101; x=1772966901;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+O1bUBWOqfDeXoae3xg5JeDwOKiN4E1kFSuekNlzTQo=;
        b=uwjafxUOwRA6I3H5HQl2wKR9FzOQ2WAVFBS0wqZPsYwy1q7ykcghmQ+H5k/krPNldG
         dDYdAG6+WCWzrNHa6LSktHF3mezYwH3YZBrhoz8Q9sMfjRHLJkxm6p6PcezVwXBk35i6
         nKtk0eCCR9OVgYJnT0xg6SqiLfSTxMuk9j3M6njsT8i2NqXd9J2r6CDBankkV3Kgwr5l
         iQI3ANsJwRgZyhjEPn+t6Z0M7KX9x6HVk4BCphu8oWPdRd1s6t/Dilqo35qEhix91Lpg
         Dg97dN/ayFso969gabOsLSBLRAVHvS2IjjNc/n77UEhgJlFZh6gtl5MyoNXkLv2cAmMR
         bhdw==
X-Gm-Message-State: AOJu0YxgPZQ7l3tDYiMGvEXc7ST36yGHRVaPijoLAQol9k/2rC6OB/xp
	U8oHl3woDRkZ60EFIeQGWOJEjbfPT1LmxPaGpGv/FoxtKKN+G97579bDVuF5/NVpg3fwj31i/l8
	67P7nXOYQQTrYxnv/6UAJSINvsef7Fxs=
X-Gm-Gg: ATEYQzz6YN8FrR3VHJx5bgxi7UxBnlraYmYOqpKaIo4nyRxQ6ju4QKoI0H1BP72kz0x
	jEkjBxC4HchWNYR5MTcpqiZV1FRXf2hiRPL6AXpWR2kx4Gzn1xWiy3eEoTnzDG7Fow6LM6AjC9i
	fvSYu25G4JOt+UrkIXbQthWV7xMmpeScqp0OqkzxcdS6LXNeDkO3EooacAd+t7mA7OMOkXbhjfK
	G5OXjmWXfKt/D6KpIssSQJfODc4FauuG/2g4TwqeUFcF+7vX06AoLC2JqfM2FGe5vwbSHTA/hh3
	xH81jQ==
X-Received: by 2002:a17:907:1c02:b0:b8a:f3c0:c09 with SMTP id
 a640c23a62f3a-b93765c77d9mr636368866b.59.1772362101139; Sun, 01 Mar 2026
 02:48:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227080712.2422380-1-dlemoal@kernel.org>
In-Reply-To: <20260227080712.2422380-1-dlemoal@kernel.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 1 Mar 2026 10:47:54 +0000
X-Gm-Features: AaiRm530HDQg4reskX91fFjPzbyCi49v4fDuciQhG5s41Snx966Q5I4zvK0Zs1c
Message-ID: <CALjAwxj1zbewniV8SNUt9d-qkDGrNAaGPkzp0BtRAdoL71pmUg@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Introduce the end_syncfs option
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Feb 2026 at 08:13, Damien Le Moal <dlemoal@kernel.org> wrote:
>
> This patch series introduces the end_syncfs option and adds support for
> it to the main IO engines that can handle regular files.
> This new option improves the precision of file system benchmarks when a
> large number of files are being handled.

This looks excellent to me and I especially like that it now groups
the syncing by the filesystem each file uses. I went through the
ioengine flags and wondered whether absence of FIO_DISKLESSIO was
enough to know that an ioengine would support syncfs but there are
engines (like mmap and sg) that lack FIO_DISKLESSIO but would be
inappropriate so a new flag makes sense.

Out of idle curiosity, what happens if you use the syncfs option when
the file being operated on is a device? Regardless:

Reviewed-by: Sitsofe Wheeler <sitsofe@yahoo.com>

--
Sitsofe
