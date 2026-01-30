Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48C329AB11
	for <fio@vger.kernel.org>; Fri, 30 Jan 2026 20:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769803730; cv=pass; b=cx3+xlLbm8prMAzPINUlH/ReZqcND5hsygY0zeWGEWQxlmwf2ja49dOUbqsiYZC1bse5Yr1EpaTK1SaJ766OhIX534Mv2z/xmc90kEGAVD+Xh6Jls39PshpaWFamZqulXrlz/ROlwF6QewBW45MOdomo+h7ZGsLvXkiLAo8vgrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769803730; c=relaxed/simple;
	bh=bRFFQSy59Ri6U6SnWTb31Zas9n/ZoHlawEHWL+4jO/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oHd4lvPYkr0vaRqqDOSUPvqY00w1zaHLBjxUn2Nd1zMvJUve+08xe4Z/qTndFFz6a17FpoRZ6BAF3NU5OmS2VhMSjQt3kIs/IuyRDTHyh1W9O5eTMVtUh5kEq+jY6/XVTCUN4k2iGs8d9BWm8rWmCD32KRyEs0Gt5tV2pzSjCEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QIZ1R6C7; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIZ1R6C7"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59de38466c2so2881042e87.0
        for <fio@vger.kernel.org>; Fri, 30 Jan 2026 12:08:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769803727; cv=none;
        d=google.com; s=arc-20240605;
        b=OvqsIYWGFN7HFciPbGxnT9ttIU2/fTq8AqMy2Ip4vOwnWi5lFyeKPIaDEFnRoyz+HB
         rpNtYJUYH398EZOh7rYtwfwiS+lSKa1Iz6P0tTdz2mdjOaaYRVVElHo4rTa/2KoelOvQ
         qrJseg15R/bkZAXi7fDM77geEHYbm5RTC84CggoVjzt1KUZLWVwKfTmnhc69DO2LzQPf
         0L46KTeoUcQ6W9JHtn3Ty6NOrWd1q+pukTFKrZq8stYe59XdfYarK7LcZhLlma1E9Atg
         gWBOiwomyWPRYR1KTWzIPfDO2x1CddC4fodA/K7wUYnUujkgHrxDDjWIa/ZKLWxHvbpe
         gKFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bRFFQSy59Ri6U6SnWTb31Zas9n/ZoHlawEHWL+4jO/E=;
        fh=AYxSU3ImT44jUTxO9WNvGVROAe/iZE5b+BQl5IEiO0M=;
        b=bqdYsjc9zB4TpJpeauNm+3htdRCE7l8vLKyt4JD7nARAqZK91/eS/EjI1Mim70C5uM
         2cvXyZriEHZ9n6Nm5nUbkY1HutJ9JfGGG1hr9pUsV84NrtUhOLuhHzONyizHsiF5JSjD
         scotajvOFSxBq7CY50+pT0OCMrjBVVr9ZlyUwEn2rIjzEFZYeL2smhrJfpol8kHJfwI2
         K8MutdaLkDxbBjfDVILA5+RBDXE5uXLXwQI5Ze4c9Wmj6EC6Dqeym7CkqFo6iINP1mKS
         I0qQKcpBWZq5CQS/bPRJJu+51BuSSu4oC98NfKP60udBmjaUfM6TqIkHGJfMd4tiAIVz
         OM9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769803727; x=1770408527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRFFQSy59Ri6U6SnWTb31Zas9n/ZoHlawEHWL+4jO/E=;
        b=QIZ1R6C7anB++0T0eJO0lzWdb+2guOrOvRApuc9k309UQeS6kqB/GGCMpQNdaQea3+
         XZh6ZAT4h0NGcJXkHzrwScCNi/fI6lHOjBaT09vBf6DcNYDygvYASWUvNtbBwYq+ltRt
         HwkNH8cXpBSSBc4ZaN4ioPwzF8yYNMks8E/5pQwNtrKTaiMt2Z1qIwHzVCYoeed9gcYD
         SB+WrtvEWvHVtqZq48Xg8NA8L9qOF6uSS2O8kg5VDGT0/s/QSU5LdBVrXr4BJ/5hs9K+
         BQPfgKXrPrGFoNxnWFiBUvXrds1hiHWGSJap7SKMV047WlUOnF1HwchqZXmcpgZtUSil
         sLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769803727; x=1770408527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bRFFQSy59Ri6U6SnWTb31Zas9n/ZoHlawEHWL+4jO/E=;
        b=sLS0As18+F1StkaOJsRQr7T8AQCY72Zf9ZwHF4gj9wuDpAm8C/8RY5t/mrhs1fhBTZ
         t6eKEZ5v+U/HdtIkRhBT9VvOBdG4IpE1mvtAg0sPHuz2RsMXJ06rY3H2TGOg75C/pKxk
         crPb+TztQZftGI0D/UzVF5OOOiJuLQTGoexkleTsNlROupbYWbQjoO+zkaj3wRe89Fu5
         NntzXYzA1mNdsWNf8gxCGnfidsv4yi3EkOtjpRgvumVMMvVAmnMWacR2yOx6jGbfLlni
         UvyazxNAqI8zkDX6PTIB0ysJmoMcVu8WAd+1R4VITlFLjqlzLGskEzeZPuS7BAsaI7+V
         58/g==
X-Gm-Message-State: AOJu0Ywnw5R4LeYU5J5WHYemaj/VyX4F6m78lWGg9YE4S/Axh2hxMGU/
	jCKP6SBY38seJYG4Xi0IbpSz+3uOCLpBshimDxABG0xOk04DLV8TAIfExmR+sjsZkOcTDAM30v2
	4UfzgDW61FzbwEy/KAIuuv5inluSHwTw=
X-Gm-Gg: AZuq6aIZJyRsu5vgEuwBzoBU24UFAz+KzQKchDdDlG4iZxpMrWmX9L1qYJn/vSV/jaL
	dfxqXYR2BhyhrTYfSrDznoWZPuHSevqz8YNhQki3INteoEFFCuuCjEnDJ25Tg+vQRDyY6ITqL1e
	2noZi0lHmK0vNwY0iH/KYT4OP4bpZM6+6kOT2XcVmGiLvTi5/ibwrRfBB7BAhSvDg0QGXV7GKsb
	jSKzVXlZLK6v/mZ+rVf2kW2N9ga8voIwJ1PysfzanHcjmzZVbrHVVXoyopSK2p0eDKoIw==
X-Received: by 2002:a05:6512:1350:b0:59e:1b0a:b9e5 with SMTP id
 2adb3069b0e04-59e1b0abb82mr896724e87.11.1769803726867; Fri, 30 Jan 2026
 12:08:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129184302.34887-1-npache@redhat.com> <20260129184302.34887-3-npache@redhat.com>
In-Reply-To: <20260129184302.34887-3-npache@redhat.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Fri, 30 Jan 2026 15:08:35 -0500
X-Gm-Features: AZwV_QgeGbrKJ47XQLwQBaBBPt0OyOhUODSUUoHXR4m57Y5bpDtxU7Mdh5mf3iU
Message-ID: <CAOp=CXkRbfsuzHYrB0qVnZPNx3OQgVUE48iZTzjDFtBB0x-Uyg@mail.gmail.com>
Subject: Re: [RFC 2/2] page_fault: add hugepage_delay option for delayed MADV_HUGEPAGE
To: Nico Pache <npache@redhat.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, david@kernel.org, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 1:43=E2=80=AFPM Nico Pache <npache@redhat.com> wrot=
e:
>
> Introduce hugepage_delay to map with MADV_NOHUGEPAGE first, then
> madvise MADV_HUGEPAGE after a configurable delay via a helper thread.
> This makes khugepaged candidates reproducible for page_fault tests.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

I would add this option as an *ioengine* option instead of a general
FIo option. There are examples in sync.c, io_uring.c, etc.

This option also needs to be added to the documentation.

Vincent
