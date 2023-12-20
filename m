Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5773156DD
	for <fio@vger.kernel.org>; Wed, 20 Dec 2023 02:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N7b07R5j"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d3d3f0afc4so4668975ad.1
        for <fio@vger.kernel.org>; Tue, 19 Dec 2023 18:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703040770; x=1703645570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3IoA7d/R/Tv+FEwT+NwAeY+lJ/Wi6CvreVp1R5xggfw=;
        b=N7b07R5jCp6fazTINqh3ZfZNtZvNPQ6z03FegcurF62voDKiGPfqJJ1zpqgOXJ9V4W
         H2jTEzW6dG8OzbV/gcRhqLaeV9NYMXuoQBSSS/dhhP7JR5qjshXBtgT1ZpApTvkuUxW6
         Ol4nsa0PReYkB53MFIwcbEMkuWKa3F7bp9/vXT+bBSmErKEIc+IZdExHuQXVrpPKbWhR
         doD2UlXKVNk22tcUyWNUMkGzfaZ5gtbnOHnXEOU7g/vkUAP6f2JfWgNbb60yKMqlGrHe
         1ZgrsklmfblSObe1sSPzbBoNgTsy0TD9LVDNok+y1Lr92IZjXDNM8mymlHHo8iNI+fQB
         RSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703040770; x=1703645570;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3IoA7d/R/Tv+FEwT+NwAeY+lJ/Wi6CvreVp1R5xggfw=;
        b=DhQTY5dRkC2Kd3o9MtwjbImjKgUkgpwCAKGN2hAIIMyClpqQShXF3sBBLQz2JLIbC4
         ABl1i4EJPsi6DiXl17YGjguZQOMISQ0UF61hJ501dFO/QGX+tyyIni06fsIhb2RAb0Pr
         JxzWeIrnYrryADtdkALda7yMuzCyEHex5n17YKL4HqT7EoCEdBrYuZZRhfAhG+4xImJv
         vmXXfA4rPBjl1fESMCCAx8rs9k7TkQND1z7w911KOKE7Hm+Mtl7jJCC+kYUl2KUtDEbE
         Z7FZfG9JVZ+zAPLz4MYpczHFrs2H+9rR0oIFdPRtrYXgGJH7Eip6PfZSYp+XIiPSl6q+
         qtdg==
X-Gm-Message-State: AOJu0YyMtmbLmgWmCmo7iRgEHfpZTUKMab9wuB7d5tqcfYqRLO1IbSez
	yEIpf1EAvC+ZXv0eQ6VbL3I1sA==
X-Google-Smtp-Source: AGHT+IHJcgaonoswikdSfbUVDCXXcKw4lEpSkizpr4hy/xHkmFHa+CktYMhsyH6dKEW6Y9IIX26vzw==
X-Received: by 2002:a17:902:d486:b0:1d3:ce3e:466d with SMTP id c6-20020a170902d48600b001d3ce3e466dmr6623853plg.1.1703040770071;
        Tue, 19 Dec 2023 18:52:50 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id jj19-20020a170903049300b001d3ec25614bsm448879plb.24.2023.12.19.18.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 18:52:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, 
 Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
References: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] zbd: fix unexpected write with rwmixwrite=0 option
Message-Id: <170304076902.675634.6484738554713184824.b4-ty@kernel.dk>
Date: Tue, 19 Dec 2023 19:52:49 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Wed, 20 Dec 2023 09:58:44 +0900, Shin'ichiro Kawasaki wrote:
> Recently it was reported that rw=randrw issues write even when rwmixwrite=0 is
> specified under zonemode=zbd condition. This series addresses it and adds a test
> case to confirm the fix.
> 
> Shin'ichiro Kawasaki (2):
>   zbd: avoid write with rwmixwrite=0 option
>   t/zbd: add test case to confirm no write with rwmixwrite=0 option
> 
> [...]

Applied, thanks!

[1/2] zbd: avoid write with rwmixwrite=0 option
      commit: cbbfe5a9c91895b382aff061bff658c211acd495
[2/2] t/zbd: add test case to confirm no write with rwmixwrite=0 option
      commit: be943a3ef5d94d8a9fefa11dc004789f66beb8e6

Best regards,
-- 
Jens Axboe



