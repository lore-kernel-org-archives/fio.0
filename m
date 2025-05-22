Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38F261580
	for <fio@vger.kernel.org>; Thu, 22 May 2025 08:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747901254; cv=none; b=MCQOnin+qwaj6kgv50AgI0xPGmMvurUjTlpHxRmNPfQMaT/U2IOHygIgu44LWZvAMkAxR+5a06K8XLG5XHybbgveb30hCFwcYKRTmm2cUQ19hQZJLaw3YdT9UdTvmnEpoGIVwDGwBzh9JuEzti5dMKIXAPkm3RDezAs41tDRB8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747901254; c=relaxed/simple;
	bh=Xaal5lh5yZY8jns4nnrmNk5gzRycOk78lCMqYeKvNpQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IewqxWrP1posspfwqKKe8MEwXb/VidJ4LkFMqFa/s/0/AapyWDpPYN7nIEsx7c103LpiYpLhWndKJIHl2E8OjU6ARf6v0OMsNibSfTM9rooG4c6KfL6KMwGZYlB9D0LtV0aqEX1ZWXEJhHu1wtoou61i8XVWpcwQbgXLCRdf+nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NrJWYQJt; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NrJWYQJt"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-231fd67a9aeso44088075ad.1
        for <fio@vger.kernel.org>; Thu, 22 May 2025 01:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747901252; x=1748506052; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fT+ACsKkiNLmRLTQXumh7FNVfrGTw7vhSb1sS0Z0u+A=;
        b=NrJWYQJtxGc+PMcKmf+RatP+N1jqgSbE9IvYXgysx4xMNSMkWg216xPlMUNwtYv0p2
         xBu+V514d77Weip7QI89TuIMhMEAFSGUmbiIMDpVwfJ0QBGIK7zDC9SBzMokjkv4pGFO
         ovS1S0Ko9EprEtIjctRtKFMK2Idie8OtwOax47Iki25ahV/eX1bnmJi6odhNrO91jBDq
         zBRXwl3G5b/foszlcnz4RFfzWVipkkfWRrdsXfTClhMgfDfKJtjYs3jPWcOLRifPfFRa
         Kh5VEWMC4MwCYRMMVhdRifYSf1osp2ms/ensmkV3FG8AdL0akadZHwAk9J1Io9pyNrDT
         0sYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747901252; x=1748506052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fT+ACsKkiNLmRLTQXumh7FNVfrGTw7vhSb1sS0Z0u+A=;
        b=fD6DH2SC05zfjvvUay8Te5IigE19nnXSCkAZLEvzXnqtDxZkbIxBgm9P7K4Tp0mIbi
         69RegbuBPwW1hRAJOW+gqw7ZcpfSRCkyMrZWW8POt7iPTRBhP3C3PdY7OdgCYACt20AW
         yEbxU0OAimqIZSR3K5MpxWLFQKWtcHgR8bwORSCUl3XFWV1ynyNGAr4iSfJgGSxvBJms
         jmErmWZUfBmsKmy9aZzF4VjXFQ/CT6d/q06XxhI5vwvByA7ehkxTLZG9SyLCk6sijMmj
         54LgoIAVeueGkb4h6cGDZKnUsI/ItWd5GVJx3ZYJ4VBOBUly9Xrj6DNUraJ7dZ4qxoj1
         Cwyg==
X-Gm-Message-State: AOJu0YywZGHcm0pkYj62u7/n8kcVhhw1V6GP3y0VntWoJCWsOs+B4Znx
	joGwll1sS1l8kWrQbpiq5ke2LLG+CusepaH5Obz+AktVNkS/SMnlN4K8SBu0I2eC8FZfJITHy/A
	HMCWBFItzFtdDWE9UlhUZgwxBAK0GHjckie4c
X-Gm-Gg: ASbGncsGgpq7FQmRr8NcvAGVJOYzRXhrKTDwhs460dkmyN385rtKiTAeE9jAPsSXRO0
	LEXO4M6sgWNVv92eA5zHzwYd8ckYsOjpvuN3pFdgYPl7/kPKXhtwjYYLbb59ZKoVYaCiQgFSVu6
	t6r0f0yJXeDEHNynXYMV6ChM/JFaFXEnwsGfyVfLk9SVIxwMQgtpSjKWChVK0vOZ02uQ==
X-Google-Smtp-Source: AGHT+IEkamfpOm+PlDg2ZNI2cU7i75uWvLm59rx0SaaOY3R21/YBvmegbmtaOvARDCU/2LsPNLUit7XhpIbAHvQsjUE=
X-Received: by 2002:a17:903:3d10:b0:22e:23c1:d711 with SMTP id
 d9443c01a7336-231d4e5087cmr340886605ad.16.1747901252108; Thu, 22 May 2025
 01:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522043703.8458-1-RunaGuo-oc@zhaoxin.com>
In-Reply-To: <20250522043703.8458-1-RunaGuo-oc@zhaoxin.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 22 May 2025 09:07:05 +0100
X-Gm-Features: AX0GCFvBeAMqh2fgHAqO1u0proqVchCL3y_FVVvNR0LT5HN_6Da4iQE1JpncU_s
Message-ID: <CALjAwxh2iGf2FQYOTieMdT+3ZURkwhOwDOBrfYGO3tYLfXAwUQ@mail.gmail.com>
Subject: Re: [PATCH] Add Zhaoxin support to enable tsc_reliable and
 arch_random features
To: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, 
	cobechen@zhaoxin.com, tonywwang@zhaoxin.com, xanderchen@zhaoxin.com, 
	louisqi@zhaoxin.com, runaguo@zhaoxin.com, leoliu@zhaoxin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 22 May 2025 at 06:55, Runa Guo-oc <RunaGuo-oc@zhaoxin.com> wrote:
>
> Signed-off-by: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
> ---
>  arch/arch-x86-common.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
<snip>

On Thu, 22 May 2025 at 07:51, <fiotestbot@gmail.com> wrote:
>
>
> The result of fio's continuous integration tests was: failure
>
> For more details see https://github.com/fiotestbot/fio/actions/runs/15179=
641974

The bot has a point:

crc/../arch/arch-x86-common.h: In function =E2=80=98arch_init=E2=80=99:
135crc/../arch/arch-x86-common.h:71:43: error: expected expression
before =E2=80=98||=E2=80=99 token
136 71 | if (!strcmp(str, "GenuineIntel")) || (!strcmp(str, " Shanghai ") |=
|
137 | ^~
138crc/../arch/arch-x86-common.h:71:43: error: expected expression
before =E2=80=98||=E2=80=99 token
139 71 | if (!strcmp(str, "GenuineIntel")) || (!strcmp(str, " Shanghai ") |=
|
140 | ^~
141

Have you compiled and run this change to check it does what you expect?

--=20
Sitsofe
