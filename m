Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F39617B505
	for <fio@vger.kernel.org>; Sat,  2 Aug 2025 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754149252; cv=none; b=uMbpEbq+W5VVVOxYuVqnunm9P1SAaTUuQXww+s+M8ps8eD1wFz8Wg3znWOHdc69IQicXtvLHW6oJX9hwHQVLrAd8lAuwXjP1wncrudVONEO8Q9pKKdut5TqZHI5cECig3u4894d6Ykrv0xZOxXv+ncgvVvvgEd4jcRQKrlmBsH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754149252; c=relaxed/simple;
	bh=ZvQCTwKcs/0Mq8JoZHOJa11YcQ8vSVgaV9Rf73swzGY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tDGXRm+mcIX6tn68yjeq/T/3WznkUGvU0EuvOUTeVmJlRmTrEPJvaYui7SqqeSbiVaNFHzFq4ptii8GlQZ+S2UGWCjA0jxBjMt32iBnNQpEenpv1Qttovx/UVsZ6FdAGHW5Mj48ey1NI6NfCu3F8y2CfxHJrXYlIzr+b8I0a53E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RmMv1EoD; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RmMv1EoD"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-30174a93186so2480635fac.3
        for <fio@vger.kernel.org>; Sat, 02 Aug 2025 08:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754149250; x=1754754050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+kI4DrASrWKD+fNwlIjeCkF599nwASLLhJV7LPmRcI=;
        b=RmMv1EoDxZUGo8mLJk0W/SzjWk2yLbhr49og+aZpgbntAzmFfAl8JP5Sqcp5d4W2mK
         j4nMxjwIbUQ8xDdJ3POivvv3ZClMfFw7T/8zRPM+0MW90G3lA36m4PYaT+S5oyeeVsbl
         06bvUOZgzm+eCS1M7honmN9GRhYGcrwodEfhHw0PRE68j6aA0bJITYGk3s7VWZu1HKm0
         SVmneUhKr8fC65FNSZ4E/VFUs+njtti/+4t1yv5emVEZt6oXli68fdlyYjkpQqVHqyeq
         ua8Yz16QH46Sq23dAZYW7eHbeKmSzEkBrH/qGSLYwedPRwHXGU09GKCufW7sRFzefRoQ
         BAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754149250; x=1754754050;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D+kI4DrASrWKD+fNwlIjeCkF599nwASLLhJV7LPmRcI=;
        b=SfFdnh+lObZytTVnTVID3HaHBc19on14nL+HFo73yKVMdXQk1Je8eU/CNLFqFlOSyv
         mBuoeJ5DlpUIREaG5KJpb80DFBY7jAAETxNNbv1V4zPI6+MTarOeY84ID3SvdO4Y8W10
         2PSihmXhwepeRqHGXsiZUYnLBtFZ65f7yC+eO7R76EN6J3djBsIOllkaWpnxANxZeJlP
         Au2su76pN1AK2ehdsqwDfsV97MLVCRHopL3ArEc0rTNcWqF9THxCaYN+VtAd0uowtaRL
         gVfbs00CIZxRtylkSgKLbGOO5tqaH1AZNi87FjfYBs8yTtkzUAXkTP9MU8qpUBaxhZbM
         8v7A==
X-Forwarded-Encrypted: i=1; AJvYcCVgOka0Ce7pqTMfT1mF/4fNIrNN3pTRs4qYMoznTNNNdBlaN+XsGZ4bW/V9UHYcyc5BDro=@vger.kernel.org
X-Gm-Message-State: AOJu0YyATEZyQ1f+C12PFtGwbANgsGCHeG+fmK7AE4aja9lJQv45PPbX
	lkf5/dP44LkA2ZBsHmdTzQNwF9FFaE1cw7D+FC7PCiLGrvLvKCpbMoGjVKS7rSkj9r5UMjKadVB
	rA3Fh
X-Gm-Gg: ASbGncu5oGqhJm9fz8zvGvCI2bqAPyIbReCWz/BYibf/s8wEUxVxENUlItz0L2DOoql
	kNPaITwwCFH56vh8r0+IWb/QAhxnCF1PoYdT14EZMiUvt+Y+LOQheFhPd6BymNDEpYi5+vrZitG
	CyFhG6K1/DzOPbTnAytlqRYq6eV+mylRXKbNZgkmEI9ChtPV3frK5jlhfJWTj2ZepFJaVDapL1d
	1TDrS9kkmuJBXC7ZxqC5MSgih6FZMHyvb7dn3QY24nhfdf16agzwLTjglwBQ5iP1Rz41HAV38I1
	cTLVvlR6j2mlMw8acjm0yima3G3i3QE4bLxFa2e2fuQ37hqP5f9xhDIyEwyP6pBQu/qF4HwH/Mi
	KynwvIY8icckkbw==
X-Google-Smtp-Source: AGHT+IFDWnsKNKRWXv5QVkDLeSGwD034xFizIF0OVJjB/URMi7qPK8bk35tJvwndSTHjUkUaFtSzwA==
X-Received: by 2002:a05:6e02:158b:b0:3e3:fac6:ee58 with SMTP id e9e14a558f8ab-3e41618db56mr73528145ab.12.1754149239234;
        Sat, 02 Aug 2025 08:40:39 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55da4e77sm1922447173.91.2025.08.02.08.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 08:40:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: anuj1072538@gmail.com, hch@infradead.org, joshi.k@samsung.com, 
 anuj20.g@samsung.com, fio@vger.kernel.org, gost.dev@samsung.com, 
 ankit.kumar@samsung.com, martin.petersen@oracle.com, 
 Vincent Fu <vincentfu@gmail.com>
Cc: Vincent Fu <vincent.fu@samsung.com>
In-Reply-To: <20250725175808.2632-1-vincent.fu@samsung.com>
References: <20250725175808.2632-1-vincent.fu@samsung.com>
Subject: Re: [PATCH v2 0/7] io_uring r/w with metadata
Message-Id: <175414923813.810748.8854050289816732502.b4-ty@kernel.dk>
Date: Sat, 02 Aug 2025 09:40:38 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 25 Jul 2025 13:57:56 -0400, Vincent Fu wrote:
> This patch series adds support for io_uring read and write operations for
> block devices with metadata.
> 
> Patches 1-5 are refactors and cleanups to prepare for the new feature.
> Patch 6 adds the actual support for read and write operations with metadata.
> Patch 7 adds a test script for this feature using NVMe devices.
> 
> [...]

Applied, thanks!

[1/7] engines/io_uring: store ioengine id in ioengine data
      commit: 9897c064e8b1fda0e69a0bdf944f1c84654b8630
[2/7] engines/nvme: move inline functions from .c to .h file
      commit: 49842d0736b127656c8106e2c7d69b1043b784c1
[3/7] engines/nvme: refactor filling protection information
      commit: 2fb6a2782ab1a21751fade28e11c0ed4fb528e19
[4/7] engines/io_uring: simplify io_u_free
      commit: f928d3ea49019f6afd26bb86ff3910afaaca1c31
[5/7] engines/io_uring: fill in guard generation options at init time
      commit: be06e55f7e3299ad68df6a4dff56b8c69c5e660c
[6/7] engines/io_uring: support r/w with metadata
      commit: f97d9f38b27b2373fee63489975c3ef44ea58f78
[7/7] t/io_uring_pi: test script for io_uring PI
      commit: ef740f7cbe47d5552677fb018b15b4ab1f1de4f4

Best regards,
-- 
Jens Axboe



