Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC4F27CCCD
	for <fio@vger.kernel.org>; Sat,  9 Aug 2025 14:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754749718; cv=none; b=kppyigKkn1RfeIMEGbIuEkxjPUqOgyg4C8vZAZfRw9Pkh8+uAigvqk6vq5/g777Qc8cItDLl/E8gDyHATL8+hM6ermipLLGEC2e8k0WxjBa/DyNThE/+WqvX3ZB7bthaUePbk5nR60cMBWEZQD2WpsDabF9S5KgBcitYkwy/ils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754749718; c=relaxed/simple;
	bh=P4GAi2ePyIkvpM+dhVk1fQyhQJjN9UIT/jxHjyIlNIo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MKiuX3lva2yP2r+Seb8SZM/bRYpWiqL+opuctAcODMMxLo8IeGjfa89J0n8AZJoDvBRXShY8VPq3FFwHkFW0mypHlXvahvP/3CLr6WYY302+RgwyKT/HG3ww9ABL6A/zsNzYSpaNlOxxinTYKe89x1V9wdbfFQW7aioAoH2oEIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cfab0jr0; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cfab0jr0"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76bc5e68e26so2975373b3a.0
        for <fio@vger.kernel.org>; Sat, 09 Aug 2025 07:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754749713; x=1755354513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hffU8oY4OQEfxzNI0qePacJ7+zKFTT15YqUIAtV3CRM=;
        b=cfab0jr09UW3w0a5Z/KsFw3AWvq/ojfgYLXAv8fBBgD8DbN2e34xgFPwCwCzkxtZBq
         0qi+VLLk7dq+4j9uREMS6pa2AmMYOOHuh+/wPdyG/EYqrDDTloXCu2AO0UKFowA7lTFV
         9toq7Otuj71XpUbPxZIjRBMdr60IRjIzRyHzG0F5+Zw1BYndC6y6d6A0YVbSsshAcVMl
         9Hy/Vy8z+oqAGytnJO+9B+ACgWluo0tAaV6eOXf4cDA3ymiAhTS4SZ6vxkZjdJQ1t2hq
         t97oT4o1fKEtF9sGn2aO45UzKQUZBTK6kEX+JtgyhfwLsozUrcVCE3MaEu6yZ/k4/oGu
         JA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754749713; x=1755354513;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hffU8oY4OQEfxzNI0qePacJ7+zKFTT15YqUIAtV3CRM=;
        b=Zs0DqkD+AsL5lUIZb8qEZ9iqb5Cywi9hxyhADWxCyAZYneN+uLQ9wQBocfKpSGqXNP
         sdn4gampwquePOz8a6FgwMEzQ0rT1Gj0fm6eaZuQUgZRkDmtfSAOatyJwXsh3lSq51qg
         bzqL0kOXZSsnk5M+4NPfXs50wZo+fze0OO+QB0npSz8RZREaAKaiKwhwd6soseUunKYq
         hgDgwjQ33dqUivyYYjFZ9aieVuI+lH5s7Im33CkrogAIES33pj+n9B6xtmjTl0jDR6VW
         D2pJxB68fD/+1IhhoNv8Ruyl52uODtJB1hseF0d405VChfStgmuNJ6Qo+6U96I6osup5
         zb3g==
X-Gm-Message-State: AOJu0YwqKs6umJetUFgQnfA5AUKPy5pDlf+xl8MUn/M+3qIx1AZv3yUP
	1zCZxkMeD4w46etQRKaTP8iE/S4FWAPkp5eS253k5VHo3XCDWl/jiL5pbWjrDEiv1AnmIHWEiVn
	3JK22
X-Gm-Gg: ASbGncuWjld/xKJxKcl58UySbvJaO3lzcGICNXXT+g/UaqklN2qg6lJHZdrFHBVIP9J
	1XGRvt6eJiLjuua2YIWj7BoUJY4PE5Jelz/QEWJjqTb/POdJ7A/0riIpk6o0STh/k4zeIDKYjSE
	kZr25cSxCZDPlz+vEPkcMGyFWtDyuLr34W8y800+qwk40OZ8ThFMVm+77sdxCIQ6AR9rk8gF6Nm
	gItgvdC/9211J8p0FShmsfKE4GndF3xg0Y5r/swjFhxemuvD8vKnyth4YsrbGUUV5We8e1/6rnV
	Qe09+er8tL3Qe5e9smd0CcA4Oiy57xfzeHeVJufrA85HTSOP1q/LTGdyL8f7dGvx5Tf8tACU5mL
	QTIy9JNgY0beMDvk=
X-Google-Smtp-Source: AGHT+IEAXKtyaIq2fGsh1oPGwaXnKAQBhOMaz32yBJvUoV1OAceqlM+0jt/Y0SS087ZLLHnW59uaww==
X-Received: by 2002:a05:6a00:990:b0:76c:35c0:c81a with SMTP id d2e1a72fcca58-76c461938ccmr10093608b3a.18.1754749712684;
        Sat, 09 Aug 2025 07:28:32 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfbd22csm22774301b3a.65.2025.08.09.07.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 07:28:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Riley Thomasson <riley.thomasson@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
In-Reply-To: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
References: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] verify: fix issues of verify state handling
 improvement
Message-Id: <175474971142.643727.4390148010932341386.b4-ty@kernel.dk>
Date: Sat, 09 Aug 2025 08:28:31 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sat, 09 Aug 2025 10:15:53 +0900, Shin'ichiro Kawasaki wrote:
> Recently, verify state handling was improved through GitHub PR 1951 [1].
> My thank goes to Riley Thomasson. The work provided the fundamental fix
> for the out-of-order write completion issue :)
> 
> However, I observed the work introduced two issues. The first issue is
> unbalanced calls of log_inflight() and invalidate_inflight() during
> write failures, which leads to fio run stops by aborts. The second issue
> is verify state file data structure change without file version
> increment. This patch series addresses these two issues by two patches
> respectively.
> 
> [...]

Applied, thanks!

[1/2] verify: fix write tracking in error cases
      commit: 1e6ca399f8b5062fcb4be3b043b7355a0617afb6
[2/2] verify: bump up verify state file version
      commit: a52833b3295f0fae160eb3d4937a371756d6d929

Best regards,
-- 
Jens Axboe



