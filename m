Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0C058129
	for <fio@vger.kernel.org>; Thu, 21 Mar 2024 11:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711022299; cv=none; b=PWE5S7VOw1nVVqpKjF7cedCw504EJwRqY0p3N0b+C60di29mrxqRrqcuaQOZAPHQk0N9YR3e+HNKVA7QYZlOCVwlsNSv0nWN7uWye3SBK1FXdf3enJhR2D2LxHuqyvKwcA6PgXMXlRkqX7Sh6hUhyeV6sd46LRSpYVg5RaGkgRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711022299; c=relaxed/simple;
	bh=YoQZ206aTkFS7o9Z0zUd6gmEw8tOVDl9x7xBhF3H6W0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AA2QrsB//0UKIF3afQh3KdxrZcQzDxRNk0kAaBKbDUSACYSM+vhJEaRZUE8l3ar3JRhbquVWaXQw7UW9tKjDV4Nw0t2pPhi8XqCxjEKUYIzhMYeKjsRQL7l8TgRVOzFLiYWqMxV7gY/oHaKGI3ECdd5haF9yTbLWVbNtBTtBavA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P1X4VQ9W; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P1X4VQ9W"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso166414a12.1
        for <fio@vger.kernel.org>; Thu, 21 Mar 2024 04:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711022296; x=1711627096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRDegfoxjvoOs1q/D0gjO/up6ytDzYWZ4Hi4xJ3SVqA=;
        b=P1X4VQ9WBkCvGbKAQxMFx8DseCGVuRmZGpY+BCawEiNHx188ilX5Vj8YeTy1YUPj9T
         7h6WiCQWTjykdCXTjH+g+3z1+Daog4D4D3Ewk7oQ4PBndoaG5Ljt7+PegDgKTM2DYdBX
         GkPJm55FnlVE/fMdBqDkyJvA1TeGFzESTdo2ix3Gh9nlwBa86F0Kn9sbkJov/6zSGZR6
         jcOKFAda4Hmjk/mdaTxcTtU29pZUmWEw81Ho/Y1o8x9sjYWmiYljXe12y62irF6YBSXe
         TLE9crHItoyRozb0PMH4Q7sV4BKcvpynN/kHp+qkfP3eoTIsXYYmqiTtakstemEI/u27
         xSjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711022296; x=1711627096;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CRDegfoxjvoOs1q/D0gjO/up6ytDzYWZ4Hi4xJ3SVqA=;
        b=XXtPGESw5lPPhIdMILUQRtKQYpPcDf+4cID+CTbP9xwbJXC+wUkJH+vITJhznXSZPQ
         exXVhzCNRLVBi4vvMsfbQa/LcvRTRZVR8d9PfCCvzfw1UXDU8jLU5UPBJkYH0eU6D0gN
         QJjYFI8vcNKaqw8Uxn+k1e7X1ixU7s+HaEtc+sehxzn82vB3FGctErsasnJI+i7As+Fv
         RxbyddglCRq5Zo9zuShnTm2PgYIE2r2pLOBeqTPBksdR6W0ry652tUOMtkOsyEe91jq6
         6qRdnvlajhFQU7aopike9pmf3eYeqyvs1chqL1l8ltjOm6WbVTaacuqri/Q6+LXk+i20
         LcOA==
X-Gm-Message-State: AOJu0YzTyw/4AqeqZNBgq8d1GvyjwJHs5UN4fj0WSenb9hIYDOSUJuFD
	MIN+EfuJIYAOneAw1qDxdkyCPAZJw8OhSR5uIxU4e72zIRSHY7XCgQ1HAAq7r6dG3zYH1Mjpq3M
	9
X-Google-Smtp-Source: AGHT+IFFM6cBpBgNnsIz6qGRHfaoYsWvWgHp4/2oeW8Imo0rIG4h90AF9Fh4SMpihVPd90lhMz25KA==
X-Received: by 2002:a17:90a:bb96:b0:29b:c578:adfc with SMTP id v22-20020a17090abb9600b0029bc578adfcmr4210593pjr.2.1711022296143;
        Thu, 21 Mar 2024 04:58:16 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x20-20020a17090abc9400b0029dd7b52d1bsm3355928pjr.56.2024.03.21.04.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 04:58:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Kookoo Gu <Zhimin.Gu@solidigm.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
In-Reply-To: <20240321031011.4140040-1-shinichiro.kawasaki@wdc.com>
References: <20240321031011.4140040-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] fix assertion failure with asynchronous I/O replay
Message-Id: <171102229496.7206.8236287895881846054.b4-ty@kernel.dk>
Date: Thu, 21 Mar 2024 05:58:14 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 21 Mar 2024 12:10:09 +0900, Shin'ichiro Kawasaki wrote:
> After the commit b85c01f7e9df ("iolog.c: fix inaccurate clat when replay
> trace") in fio version 3.36, asynchronous I/O replay with log recording
> options trigger an assertion failure. The first patch in this series fixes
> it. The second patch adds a test case to confirm the fix.
> 
> Shin'ichiro Kawasaki (2):
>   iolog: regrow logs in iolog_delay()
>   test: add the test for regrow logs with asynchronous I/O replay
> 
> [...]

Applied, thanks!

[1/2] iolog: regrow logs in iolog_delay()
      commit: c3c398e0701187716b6fba847fdae192e469b80b
[2/2] test: add the test for regrow logs with asynchronous I/O replay
      commit: 140c58beeee44a10358a817c7699b66c5c7290f9

Best regards,
-- 
Jens Axboe



