Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173D340DB5E
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789678682; cv=none; b=p2sBvpsIv9dpLCiou7ukfXuQzW0qZvzLG+d+u5c6X6h4g3MJNSdAUPy75DQugVbuhndmgwVXmuqJQI7Wkx0RBF3GwwJJ3JWs1DV05rrynBMqwSeVPYwdG/44y/LsxwNc/yPXxjeiXWLZcRYY0bAe0vG00cFcVqMACzBBhvdd7xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789678682; c=relaxed/simple;
	bh=+/OpYF4jW8fjk7gJ0lA+dbCykv52sBWZi1uQLcDCZY4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VPaXioq4CWfigF94wyGJwfYGHnetmTEnI5t//OH0VxzRqjRUGaM0pdHJSe2+pIpDDXR1U4r7CBud4XKncB0JCwqSUQt447KIh4qbJ0ZLUFpywtqgbDde8uiOz0rVKcR3zHgi6nkgAsRf92tHIDNl95oHulzNNGG2gS/NrkkUmIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mYm3oAUi; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="mYm3oAUi"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d4eb63f16so273837b3.0
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789678678; x=1790283478; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DvhaQeC2A1bDHGIwReyugHy7NKHi/5/8IIkPNol+28I=;
        b=mYm3oAUi3CM1CVx9GyLjfxqlKHMIsZvSozPPgWD72CKH9kWG9gqJGrkQWqhl4/Ipvm
         MzWE1NbYQnrFpvfn2GV6iJZIOqGdzyjYUEeOxzGZnR7qAKhgzHEtLHsOJcrJpBS/2XGq
         /owof25jGma8N63ETJhqijuOtOKb6ON1F2xgR/RaMit+p81yOnm7nsc/7I4Pw5aKH32G
         VNt7B+kTWv0g62kYeVoUHkDByq2Y3uPlBCb8ZqjDpL7lKx9vFkbd1WH2rXHXrlMFB9tL
         8qoFpkZpmrKy74FMM/XUNXM75T+kczY07PTwy8tDFJCWasUVkxA7sXqr1a4Og6MYfFLR
         OhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789678678; x=1790283478;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DvhaQeC2A1bDHGIwReyugHy7NKHi/5/8IIkPNol+28I=;
        b=Wbh0wtlVujAo32OVBabVE3n3GHG4Mv5GaDJn1mrVu1e7YcHFDytq69QXNJO6iezLL+
         /VeN7uEt9qKnKFgKDH3Zz3xmJMEVz+S9NPOHUHogLnmBuS+/Fl5QMCEgkDx8xmu16z1U
         wZEokgNeQaoysDGMvkKiWJdAaP3NbQJqhaElAgNuEBpD6SDVIOdWEC8149pZVLg530dB
         suQVXVPaAx8jHerJfuZVbfYs/zbJ/a8O7GD+uVhsL4EIN0m6HGm/qtbA2uuDU0IQpoIL
         C2CV18DSqVI3MlivONHT+zPnL3YWOLd5hGogJ/0FQ85quAiW0Fbk9ya7Z0rqTfEUt6tP
         8Odg==
X-Gm-Message-State: AFuF++ksvqZisA1HkdX7pl23xnJkMmV2Qghibord3AuNaAIVSGojxegS
	TzWsDZURvkxWszzH/CsvvOO/AUwrYCNxiD5fWECpQGlg4X8E7daHuVPCwKCXKAI6ziW8OZmLBF4
	L4iA8FJ+EPw==
X-Gm-Gg: AYBFou1fsTZ0qHRSIOByUME5coodhhElrgV724s4AeL5xfBBmK6EO3SgVXN7BRWVFZh
	OvgZZ3j7gruiy/FhGniNio+3SbvZNPVoPCpRISuTWJ5lRrWHQ09rd38wZAQ80S4bwDtyMrC23WI
	/LuIpOfh4EhrxdCsnEb9QUbZc5Urz4nEsp4HQVkrad2SQ/dY/GGti+jMC7BAVoW9oqFTnMJ/ehU
	WOHS7PEOB0BvUu02VQAp0ChYa+1cmA2G6dR/fr/oIFQecoAwNQ/EpecbTiXwdhPuO2v4hpMHSeo
	YSgLe7C9DUWhJjxwaUFUhR3BGLUkQ+ni7ZpMb5ZSvwlUoytJZHT32/+FhQUE2mnqyChnOxlJl4H
	COpTbpazvjT6GhCnRfLi8A9t9slnyKhMslkQwEGhvhlxMLfQwIp178Fgh1wqqWRyz7tlGZuOUUR
	0SSWZoFYVjXPygAcTGJd4v8i92jFoGwzV+8nA5CE25MIrP0ewBwWaALuKfz08MPi5VhGzF5xt7a
	v312LiXNNA8RWDC9/Lk80W9g3O27cOVSAZ56oH1aXClnMRmEiIutjnsKIKN/J0=
X-Received: by 2002:a05:690c:660c:b0:80e:dc2:873b with SMTP id 00721157ae682-897331419e0mr1227657b3.16.1789678678004;
        Thu, 17 Sep 2026 13:57:58 -0700 (PDT)
Received: from [127.0.0.1] ([217.65.139.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-896ca22d543sm3481767b3.22.2026.09.17.13.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 13:57:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20260917205554.2281093-1-sandeen@redhat.com>
References: <20260917205554.2281093-1-sandeen@redhat.com>
Subject: Re: [PATCH V2] client: don't send uninitialized data in
 fio_send_file error replies
Message-Id: <178967867670.1755301.8723095281128051810.b4-ty@b4>
Date: Thu, 17 Sep 2026 14:57:56 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Thu, 17 Sep 2026 15:55:53 -0500, Eric Sandeen wrote:
> Various error cases in fio_send_file() might send an uninitialized
> buffer over the wire. The server should ignore this when errno is set,
> but it's best practice to not ship heap data over the wire, so fix that
> by:
> 
> - using calloc vs malloc in the initial allocation so that early error
>   paths send initialized data.
> 
> [...]

Applied, thanks!

[1/1] client: don't send uninitialized data in fio_send_file error replies
      commit: 162e8fb3d059c090caa56255e4a6a92bfa6e47b3

Best regards,
-- 
Jens Axboe



