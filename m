Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF36322A
	for <fio@vger.kernel.org>; Mon, 22 Jun 2026 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782146107; cv=pass; b=MVxtoXs+u26wUQ9zf2GddJKBMBMiLdYH6jGi51C04v0uZqtwb8mlHfU5y5FBZtcK2JeECO5yWASiUrSuLW4RRDWmd7dQ9G78ao9BtYiUYoasXJrW/OeXGgxIxiKzxCjeGhQRhmdMj5uXwLmvffPcH7wSUH5U3ClGEpGW42bUtJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782146107; c=relaxed/simple;
	bh=PNMO4OdRNQ4PVzozZJ5MOfzGqqe4dE+1Xo/jU5U5pzQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=gqkVjCFL5D0GDvBA1Cdn4m83rQeowcsjJ1g6d79mKGrwBhRnKMidTHld4ISlc4azqUE77nu9gRU7YBU77agonAnCQAl/9kRIqv3Z7Unz+k7FUyiv9kgfZj/qqaN1iexod1GUKVWmnMSFf77kEnx3y0XOyjI3sZNHMEt6coEZgtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HJ9NXmYw; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HJ9NXmYw"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39677c80386so52170451fa.3
        for <fio@vger.kernel.org>; Mon, 22 Jun 2026 09:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782146104; cv=none;
        d=google.com; s=arc-20240605;
        b=gv/yhlIXQcCMPdifuy1orxxuT4Umqu6eIRir5zYWRSo74WVKczbsET6eS2GTtSmgqV
         s7TlCHb6EN4U5pygNp1rNzCmhsCF08R4XMwvCRMDt+7nyih/2EZvHJ+Hef/J31M6Zqn+
         Sg2P1HEy7Vue7KTa0dkHW+DMSwpRF4SYOZWlCT9KzBsIqNnwhvF4rRriONhGqKIFbhYa
         IvLpcg0XsfYWm5q9UDhIvZYKoJFG2pDW0ES//vk2iw9/W4z7PVZ7tRaw/A4NybKQ6UBh
         7Vblf1VWE6vcnjXil8j420odL2WwI/Zp0p3qZLrSHCb/TdjqjjIakWIiCWdR9uU5PUhH
         toQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=PNMO4OdRNQ4PVzozZJ5MOfzGqqe4dE+1Xo/jU5U5pzQ=;
        fh=5n2ewnrib42ihxdcSJGD0St/U/4La8aDJl3qCg7T/5I=;
        b=LB9OIMye2/T8wNkSeeDnp9Xba5MNMzwpmU0jLGqEOQLPeCJrvrCoexG2vrnmJyatjc
         6naqhq+6njdIHv7DxOBWq/RAb1lEPMGO8UMPmPvAHD6ECG1JvvJ0qoVcBm3rKrpG1Vu1
         lnN2w37nk186wXVhgBlb0CixfDohwtnh6RF1MXA3QVGQmXQCt+NCSxV3aMn/RrZTYuPT
         w25U6mJkLQVTdEL0z3MV9wJ/gegm+N4jdwHT2AvQD74KRrKQXGD0wwiymJa62tolK8T1
         Be3ENEg8HAW93QJWATLWE7zk+TkNtx/FgSz/lG3Tgm9e26kAU/GkO9UF9k+En8XOKfLU
         p4Dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782146104; x=1782750904; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PNMO4OdRNQ4PVzozZJ5MOfzGqqe4dE+1Xo/jU5U5pzQ=;
        b=HJ9NXmYwbXshMwmsvUq1u9Ctx6zaz5N8aOGguAuyAXDbGx/hVvkKZwg/rMM+jiAq8T
         MdDOq6pLu0IpGDfJTkj3z5eyO3NoNcR1jWUpVYrF+PZ/vdBurOOEeIZeYwpa5aBwWDlm
         E2BTKJuINQgX9MlUGjviSs7wl0tVUzlVlXW+58Zlagz+dPfIrOMJKFGSRl7YdA78T8gv
         t5xnxnhEpV/3YomKbxDNaKl4oGlCk9SyFl5SDUSwbWcXSDurAUEvmSlOu6t/SkEwtGLT
         P6vpX7z5oyIikF0mGiDm7+I0vRW1WgFis/e1S63LMwDArjgvityNx+H8EVns6elZpMB/
         Sopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782146104; x=1782750904;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNMO4OdRNQ4PVzozZJ5MOfzGqqe4dE+1Xo/jU5U5pzQ=;
        b=cfEGYV6y0afgC7b5jl82M4Jnv4d20xWVo7C9xTyokZ/iOG57t0F4jatTkGqJuE8tbd
         ldwtUik+mH26E8JIBVLvE5n/Zkhrn9wrcHjFYhIcZJYgRhp8xKEZn89FCjH99egc0f3E
         spREeWnUtqkglrZjN4jwEJfjweZDi8vzdlXFaSNSirzS1Od+/i/etj3mXpQl2Bpm4Uqs
         X8yfyriCBJCS8DuQyXnv3K5+glBWVuteGf+ku9oVr5MZ58PlBwFmBr3XNS0uM+rCG1VO
         p5xmH7XY0lqEYKry8YyY32KUj4Gts2LVppZx/CnS5HvHd2cd7M8pyjnugtKCftBWkL9G
         gEGg==
X-Gm-Message-State: AOJu0YwNAxQDwZV+bDBL5/++O77SlAdYrv3Wamdgosx50nriO0A+8y97
	oSXftDSIPz90vrXtZg6DTG8kIyzuf6dfgJ4XpwW90A7oskvfVwDkUsl7N34Kt//G/mPeNmZK2A2
	lRFHuSVrD8kprD8w4d6S6s97FidrSWdu8IfbU
X-Gm-Gg: AfdE7ckggtLsfKPfypFsJkx3XPX0F4oZTelpIz9iuRkKteMGa03D28rfE1/XUVNTYXb
	9Mai0CLII1b2nWHb8u/qRVtSYsRGFkx/HvpTX0THHTq2S9qwpAskoYP8mPc79JSfTcc0gK9azAj
	iQwlNi2IOD9C3xzNo+j7F+lSxxP0bp6MK0AzMJKwuGP7jiNFpS8Ibhn5WrsPKqg5tsWrgQGC76O
	yoiSuCm+AIvrA5zVrDc0DXJ0LaEMBcQJWCqGmkIriJqpWNxNdveXKzjkw2P3qj/v9TpsyEn3aFL
	sM4tVDbcDghXVEJCCUDDPVOsk3Nfjxd4U+Mu2g==
X-Received: by 2002:a05:651c:b2c:b0:396:7c9c:208b with SMTP id
 38308e7fff4ca-3998e406d9cmr33259561fa.7.1782146103908; Mon, 22 Jun 2026
 09:35:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 22 Jun 2026 12:34:43 -0400
X-Gm-Features: AVVi8CfTw1DkFviiBAEJhXwaW0WKTk_P_RurM6P-s-l7yR-cZUluJB_m6alAWWk
Message-ID: <CAOp=CXm4SJEudn_-JnE6A03a5qOrR=cixhWAhVa2nz2JrKqwxQ@mail.gmail.com>
Subject: Blog post on how Fio uses an RB tree for verify
To: fio <fio@vger.kernel.org>, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"

I am pleased to share a blog post about how Fio uses an RB tree for verify:

https://github.com/vincentkfu/fio-blog/wiki/How-does-Fio-use-an-RB-tree-for-verify

Feedback is welcome.

Vincent
