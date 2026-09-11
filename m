Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF2F379C38
	for <fio@vger.kernel.org>; Fri, 11 Sep 2026 21:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789160960; cv=none; b=EZG3M6NhnujK83Lz0FTD0MWtbCtHFzsau2i5PTEWiHSN3+lEy897SqJSq26UOB4PR4QUC4iYM/vpwC1F0IpNkLnJG14E8hmO/csGnIjAzKsvJzA+hQeVdhoxTSeabC0hFgATho7uEM7tWy7C7GTQYeomDnUEQakrvbsCO7gqN9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789160960; c=relaxed/simple;
	bh=tHOgS05cHufnUEzGJ8VcX0xiHGeRCiDjdj6+Y9Gaud0=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=UrSNT0wgUZ811n99SRzLAlKUuw1JHTbWPT4gQ2NKtryQGXpY4sG2p9UztrCVhl3anI1MfWgkyq7HIdTnajqAHGlGtYhXIXJSfx2YNaaSNMocXczp1JUnMnfa9R7FFyT86Bk4B91gTBozmppzVcAu1q0kPlZQvY70HnrWVumsrbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORojkg2y; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORojkg2y"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6be1f18687bso952878eaf.2
        for <fio@vger.kernel.org>; Fri, 11 Sep 2026 14:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789160955; x=1789765755; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tHOgS05cHufnUEzGJ8VcX0xiHGeRCiDjdj6+Y9Gaud0=;
        b=ORojkg2ylybvaYB3Xrm4Ecc9H5LuaZypqqaCf8qHmzYWsRkumb9vj0dMj2NQT2W6t4
         2kA8cdvvOUWdt+8OMOjXJB5bKiLIjKik3ZtnEXiI1rBRWvXtTVOakgXfTAwSveZaMH6i
         QiRiZQV1bgchVjzjqL3bY7c419PM6Hi+AgueoA2MVyfxu+z4KwcePpLlk1a0+u29vg9+
         siJgczofQw3+Ac0bewGqWSYaDIQKYlvpzuNGpi36z+0FOPJ3h3K6n7Y529cfTHtal/hl
         5NsE3o6P53F9zgr0YfNkLHGq84c5kY4Gm9+fWnuWibb/T+FRmA85KCyXPg2bVXDziF0m
         Ax8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789160955; x=1789765755;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tHOgS05cHufnUEzGJ8VcX0xiHGeRCiDjdj6+Y9Gaud0=;
        b=kyzhGSn0PpnfHPl8hTILrS69Pky8D1xTqEeyVBRI5dPVvtnIQXlhTLX4UdOY0oG4Rv
         vOUhwJPkSZqw0BNC8lIRl+lEo8LdYarlgCVK0Iih4iOsaH+jDq4a/fyOj1SmBKtgXAVX
         na5sZcE2OmG8oCi3jIeY8jABjQs/d1xCV1t/BGIFiGA1uXs+j+FIIzl1rcTcu25BSyfV
         Lg9dORHvvHGrl6eyk9coSadc7UN5qqOS3KvETRYR/nTgDk2g/f9pnbpcO6vSvifZXvif
         pb+af0Pz9WYR9qoFmtL81nUgwepTKZgb1WuvEIsnE1RnYRVI+AfLpl3M3j0eBPXtjA6f
         LBXg==
X-Gm-Message-State: AFuF++knJjuGDB4erNiibIzYrDWWPWF0TNDGWPuLJXgV+UYyySaDCBko
	Ka49vy7W0xYMBoJD0JzwyTu6e0EcLj4tYZHKo0K65fvSH8Y6dLO310SAeGaI
X-Gm-Gg: AYBFou33k1xGf86UI1v0HL9Gp4CPlF/IydnEh5zAJQpTk5KXeSzRoT2+UwyQjBgelpV
	QfBQ4LsCYNvvlH8tlOPrFYJL/bOldGCfB2ZKpQAcUOUXNkbX+wglLpMARni1qbbzRx+awwVUEHe
	zQenI4xyX0DhzeCcu2RcyX9NUrOKn+5aF83X8brvzvaF0aEoCpIpdIBrYyFPdCyWflCBgPSppUJ
	DZ9RYD+b5nQp5PUmBX6sInfx/iAnwUlW16T/QivOS4j7J9gO2cG/ZnFhbra7cU9pwC8sSVPONlp
	d+WeSd13S9FKc/IUGEiZVe4LT36pqCoCwquvQAAjaqUd9PSaHmTQtb6ArwqO8YvfTUVAjwJBmbD
	eYT/byFq8AAj/88OQDuU6dv8uxCz9k3JaoZpXqq0J9FS59bHd3B1+lnOa+Te+cfolCznnhh9G79
	GRHQoSLjqxydVTiLcIC6b2Q+39ZkrtaG9uRuxBxPoTu0ya+gvwq44kwZgTi++Xf5hMk6QX7/+zx
	+cJJw0R6yByKajoT/GzR0MYcVo7050j9SaLVb0eoEQwZFRlDlokUNf/GIb4TunrmwHnaw==
X-Received: by 2002:a05:6820:184a:b0:6b7:83d6:2926 with SMTP id 006d021491bc7-6c0bc1d82dcmr4512348eaf.41.1789160955469;
        Fri, 11 Sep 2026 14:09:15 -0700 (PDT)
Received: from runnervmlun5p.4oje2qbujxxehcp531edvjx4bf.gx.internal.cloudapp.net ([20.106.22.181])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f5adf677sm4091284a34.4.2026.09.11.14.09.15
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 14:09:15 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:09:15 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============5659777137254503794=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCHv2_0/4=5D_fio=3A_fix_eta?=
In-Reply-To: <20260910161310.1478081-1-kbusch@meta.com>
References: <20260910161310.1478081-1-kbusch@meta.com>
Message-ID: <178916095477.2971.12409468673227679585@runnervmlun5p.4oje2qbujxxehcp531edvjx4bf.gx.internal.cloudapp.net>

--===============5659777137254503794==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: failure

For more details see https://github.com/fiotestbot/fio/actions/runs/34637696308

--===============5659777137254503794==--
