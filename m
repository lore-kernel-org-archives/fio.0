Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27BA22AE7C
	for <fio@vger.kernel.org>; Wed, 21 May 2025 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849777; cv=none; b=jKeH54xvsY4NQX+Jr0ipM+qfXoqUyTCL93P5DbfuyB+3OSFilEJJJSq7w5XdhHizpA4B1jRDswugvTzNCv6ttDj9uq7Z0Og++y1kc8ECh5XMk1wl4M8IXV5vhpR0C95RMADWOksZDMBZthUTc3fWOTwFkbUslORj1BrkPakX2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849777; c=relaxed/simple;
	bh=fVLBJ9g3oRsCGroHv/Swn3q8q705sJ40S1y7ZlIoJL8=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=r+/bdN6y659UD040cbCe2IP79Kf0fRRjQCb5a4Cay8FGHv5TBcYT+9LRgR2+P8ZRsDb74mwQA9Eunj1XUJQLCeIuWsNzcPBFW7OOAC1ZvAyk8oYOFP+5Tf73GgUlunORtgYB22R6Pn9DF7ezoOVEy2q3VIhzY4cVhmkSF6N878s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lft/CyBA; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lft/CyBA"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4769f3e19a9so48153941cf.0
        for <fio@vger.kernel.org>; Wed, 21 May 2025 10:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747849774; x=1748454574; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fVLBJ9g3oRsCGroHv/Swn3q8q705sJ40S1y7ZlIoJL8=;
        b=Lft/CyBAVIJuDrua3U3++t7ETERv529bGGPxyq2FDzIpNORC2S1s2mOWoewnaM/r+4
         DIJn//lO88cSkCkZA5fofbuIQDzWAoGj7ZJ3nxkVLoQWU+6geHid+ts6WbjkWTn19UHu
         /NAaxdvBN6a3hWPgGbU1t2t6SGex2HUNLZN5s5vCCAr626jQ9UUsWa0f2pr5yFIyzg5U
         K6YlbNAO8cKX3XNIy1V1bAyrhLXYzMxmBFTVbPGgM4HWWJLghebvERUKS7XloDFK/uZJ
         rPC7IbNBWc9omqNWHUFppqeQClfA4RBVj4RVC1Pw8opSc0C8zC6pnO711YgVODNn8VMA
         mxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747849774; x=1748454574;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fVLBJ9g3oRsCGroHv/Swn3q8q705sJ40S1y7ZlIoJL8=;
        b=djGuHZX/cpXTLCz/t3oj1DsR2zUuUneza1AE4yixR32IEqNmMTcnI3tagIyJF41QbQ
         ADNDARQ7X4fmVN4X0rT7JQCtgx5EC7fYT2+mDmU7ZyxrdViGdzgFX3FBlCSzt4Ejyt3P
         HDy50a08bZtngvSjBOGaCwIu4EYSo638Ivrv2JFcGVCTFeImcTI1rT5LzQIWwvBU8l/S
         WLmXednPKblxmNy6mWUeBlaaYJolCdO53sHipmEcqD540Uk5qKBiW2Iyu87RH7NLW/Jp
         O4uAZjR7chC+hmLmpuB4Y5Zk83X+C8gIyc3CikbWTmtVUWLerWXMaLb7XcZLQpsqUUBS
         qMmA==
X-Gm-Message-State: AOJu0YxGtZWV7+deQ4w6tHwNLoo4Mf23cBEfRdc/FCLAMj39Q3pYJWpe
	HRMMDAvS4Ne4NNnFTfdVZYzZPGlLbq2IFLZoYP2+/Zlddjc2zQoE1hypsEiR
X-Gm-Gg: ASbGnctTYI49VpyjsQPdF9GNDWq1yFnWGapk9hbic8An5JGhMnPLaYr4JXkAzluyEME
	4KjdQgvC8k56O93FpfERA5n2pkLB1BGC00aeO86OGcO0jU/YaA2CHmU9KNO7aP6lLKwXsdXpHtv
	/xzY1wtA0BUYCr7pxjIEBnDH9DFAtrOJb59o0gFEl0Tz/05lQeSdXJEPYnkiYs2wevq5XeJJBh6
	SkWRDk2aDykkkqyuOEiwAiQzIkeU3b/80YJ2ASpWVCvnOHrUK4f4VpxH5G5WyQLvKl1JgCkBElD
	0qjARS4w5unfZAr/sdvjpvZcIqYOhTAqNR2Zf1nA7z5mm4/bHpich8K4lJ5KDfzFcQ/VemdvW8K
	QVAxbOm1SkrdOvnykhS+eqQvjP3TMHU6lCwxuI+Dk2e26KfOS4XE=
X-Google-Smtp-Source: AGHT+IHB4uXnPOHCEUe80+W5WW3zHplsHcRhCfzG4eoXgFKdkhA82co9Dm9uvsEBQOxreW9Gh7FM3w==
X-Received: by 2002:a05:622a:440c:b0:494:b258:abbf with SMTP id d75a77b69052e-494b258ae5bmr290563171cf.52.1747849774530;
        Wed, 21 May 2025 10:49:34 -0700 (PDT)
Received: from pkrvmf6wy0o8zjz.ewmzc0bqkruufhf1y4x1ywmkfc.ex.internal.cloudapp.net ([172.214.243.139])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-494ae4fd7f0sm86552391cf.57.2025.05.21.10.49.33
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 10:49:34 -0700 (PDT)
Date: Wed, 21 May 2025 10:49:34 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============8562196438166442552=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_Add_Zhaoxin_support_to_enable_tsc=5Freliable_and_arch=5Frandom_features?=
In-Reply-To: <20250521020421.6862-1-RunaGuo-oc@zhaoxin.com>
References: <20250521020421.6862-1-RunaGuo-oc@zhaoxin.com>
Message-ID: <174784977305.2686.2705267545671388475@pkrvmf6wy0o8zjz.ewmzc0bqkruufhf1y4x1ywmkfc.ex.internal.cloudapp.net>

--===============8562196438166442552==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/15164633006

--===============8562196438166442552==--
