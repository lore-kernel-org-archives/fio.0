Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DE05914A
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707921604; cv=none; b=bdhwNv6yl2KeN+LfJw18n1qpJor1miiKcHIB3+QpIxPJaypV7+M6e/IbV1fylzfJCBon1MRQeTalusM8MXC/7L+QtKkdbC7Ax/9z1qqV5mtWgWz+4MYeWbOhjuol5UO+hrH7hpt2YyeS7efdZKztpv8guOpwbf0iEHUIQx/CIOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707921604; c=relaxed/simple;
	bh=dnnextaiXRFJsAo5ifbxIpJ5mwbsu2ea3/RYnGKKsPY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=J6wYUqR8z2g60UWplAF6Byc0xrVIUC9wRSVbuPOz34LFMt3fNhYOag9Yp28bBwzWOuO8hJ2OzfYZWCBDT0s4/rnXMSLDqzTFUZLqObY/0bof0gsONhOxThHhzfkQfnX4d8z3CT1UvY9wIyZgJoA8mL8MBb2UQLyzjjtw20qampA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LcTsMPuy; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LcTsMPuy"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so57361539f.0
        for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707921601; x=1708526401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75cYmWYP3EUsymOzFugbbVr3nKb3iEhx6x+hBXuica0=;
        b=LcTsMPuyKhg73LfB+iIwwyWRbioT010s5oR6s3IUOOwHw8g0z04gAMSEZBewRSbm7E
         Qaa91hb9EPH3JfRNALpElGDaAyqZo/J7Sc3VgNv6NZd5R10vHUtI9eToh6Ivq1FkfnIe
         OFr9k9FUJIDTCYu1hM2WKY5qVcwxTf0naAWbpn64+nyv5MrUEUQcD6uwMhWyuxYHo9r9
         E5udIVO9wK9/CrXS/z+WjvcJUokKinQ5nQKTbC62H7LF93Zk159mmxWsEbp3zuXdutOm
         Vpuch7o83eUzPiwIS/SjAKeKvjs078bL+4sjjeHdPAdDV7ascBd80fKC9OSjRQjqrRQs
         K2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707921601; x=1708526401;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75cYmWYP3EUsymOzFugbbVr3nKb3iEhx6x+hBXuica0=;
        b=jgMNHlGZSEa32Kh13MrcceR3ykfHBOxZGZQyMbdyy5W45n4e9a0xF4jCuxXU8O0nx6
         TpUvhDSaTxYLRj7vNRpEEKhKJ+H49K1f6Zrfw6O40E7wuf0BMLEbB6EuoT2VMFMERrPJ
         p8Jkxz3eaIsgAzthfkzwrvsZg3ebnRy5fmXVEhxAOg+ui8iSnZH6Xo9aP2orRTgxQ1Vy
         05J/RhJnYduqfw1Ivy5gJ/Wv7P6T03R8bzEdxvTJ8SzeSuNhkCmCk7kT6uATwdjBSIYX
         xuJ68R1TCMFxLQYMgSZjL1VGa6jmJ3AnOOnlK1Xp0Vl2j9Su/SI+oj6mDaFaiqck221K
         TQJw==
X-Gm-Message-State: AOJu0Yx76B3iQxjxKggO9WPRoXIt0ixaMNjYS+C6werRQ5PbSgHlMRkl
	J/Dxrig0Sp1jqkcCbNG/2lNvXI2JxijBAL6tK7BMhYlVYiVIn+3v3jF7Mgz6bBI=
X-Google-Smtp-Source: AGHT+IGT8IRh9mANxgq064kpyWbCtOoRjd5iosofZ5Fwou3RjmVbJAdkH+XbDaVGoqaqolXxNg9/vg==
X-Received: by 2002:a05:6602:52:b0:7c4:79cc:c4b3 with SMTP id z18-20020a056602005200b007c479ccc4b3mr3324926ioz.0.1707921600919;
        Wed, 14 Feb 2024 06:40:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUwyC7Bteen96kU4Gghkai7O/I+iTWogEXQNEZr7RI17y9aEA+/8wDtjSSlH3+KtgoQxNeygiTgPIab0WeVL9uTajCpwRbBTuURYEJAYFn2LnOOG3MjufKRYYwBGBvxjZOFr1IIN0UYaW9EXNF78O3I/sq8W+WJFk0A5MXYr2PaSz490aFZOi9sirdYur4VtlM=
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dl8-20020a056638278800b00473b54667acsm1661660jab.38.2024.02.14.06.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 06:40:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, 
 Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20240214122008.4123286-1-shinichiro.kawasaki@wdc.com>
References: <20240214122008.4123286-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] fix loops option behavior of read-very workloads
Message-Id: <170792159997.2612571.1719738018065409539.b4-ty@kernel.dk>
Date: Wed, 14 Feb 2024 07:39:59 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 14 Feb 2024 21:20:06 +0900, Shin'ichiro Kawasaki wrote:
> After the commit 191d6634e8a6 ("verify: fix bytes_done accounting of
> experimental verify") in fio version 3.33, loops option does not work
> good with verify-read workloads. The first patch in this series fixes
> it. The second patch adds a test case to confirm the fix.
> 
> Shin'ichiro Kawasaki (2):
>   verify: fix loops option behavior of read-verify workloads
>   test: add the test for loops option and read-verify workloads
> 
> [...]

Applied, thanks!

[1/2] verify: fix loops option behavior of read-verify workloads
      commit: 96a7e64c8967631ac565481672209ce96df02332
[2/2] test: add the test for loops option and read-verify workloads
      commit: 7aec5ac0bdd1adcaeba707f26d5bc583de6ab6c9

Best regards,
-- 
Jens Axboe



