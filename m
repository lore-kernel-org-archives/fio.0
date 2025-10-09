Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDBB23BCE3
	for <fio@vger.kernel.org>; Thu,  9 Oct 2025 03:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759981143; cv=none; b=hTrRGK2Wurx7uPYkXgQpHuP5YEM05azJ7acEzvfN38YprW0qWfzvC+LkxdT3/N0O4HehyVsANCsz5EwMWmBPMpysEupKgpQvYhWLroLI5NoiFLQhs5LTkHJkPela9oDzfseHelTeEuFSfUxZvFwoLItTs8x3jJATGZ+MbpmjHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759981143; c=relaxed/simple;
	bh=NlotR8RLIl6FF12kvLmZnw+7S6+NFqIKDseKSldcweM=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=D/i2ZHRI4L3bpqxsUIVyjpjwsSnCztWN4trQ1OsaZPhZa5nDC2VEYcyNnGRpCMdGL/Eo3T0YYVFkfxTNyPNJF7v4+qzkgFtMI4JLBg6WI/4kZ+nf7v8BQLs+kBeTrFPyWYgqnIkmm3C+EgN8p3tHY/beLjglFcBwQ636Z6EiHNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRyCTo8k; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRyCTo8k"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-794e300e20dso428148b3a.1
        for <fio@vger.kernel.org>; Wed, 08 Oct 2025 20:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759981141; x=1760585941; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NlotR8RLIl6FF12kvLmZnw+7S6+NFqIKDseKSldcweM=;
        b=dRyCTo8kxH2KJnRut+tBvQMTaApnxvJpK6JAuN02yVw4sGjqoXSQ6u4E9O+1i5/Hjw
         qa7rxzkaUSqzL7sZhkUHeK57B3eeaecmdPlfpvwMihwO/OuUWy2P0f4XnzJ3U+QTGjkj
         0IobR59g0eHGpOzvMhgQ+nXPF7pBIjoNsFHUybc9PzYDry5tMPT2d0mCR8rzgualfWjF
         GF0bCkv1ReF9+fQvPSqY4m34ypz/4evyr1N2GuNQkSZwyDrCTuvRtNYC8oL0ECRZyFjt
         VscF/si+qsw4QLaEgzfGvsmcpQ1peqLj/7oESFUke/mim9+S5wLh68BNsPZ2xbfq6S3R
         vb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759981141; x=1760585941;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NlotR8RLIl6FF12kvLmZnw+7S6+NFqIKDseKSldcweM=;
        b=RAvLzC8HyR2UitpwQDbZ9hBI8BNNPsLVbIbCjWV0GxH/PJpT6XKssGSVDBv6E34ExH
         Yb5dzxln3EjFeomgW0A+rgKKL2o3j+SNB6Pc2JL4J2RSs3bEBVNv5qSzmkCdvxDIyxNn
         8PSYkaPr6FWZgK3KOk35EmoX1DMgGMomF0WN7VJz0syWdDTB4GPqQ3le3UE8UTfDCGju
         BGnQe+OrcHAn4iOAyyLyzEuv/GDQhNEshntnDKw1JSil8fLWNZPdTrHUKLFNf34dHqu2
         mpnzp2X2vos+nHUUglfgcZQndX7sTpxCjxVrZ2wZhwBBFzGj1MLXzXy0dMB6R43Aaj+7
         NnpQ==
X-Gm-Message-State: AOJu0Yx2x/YyQ5b4DK7CUWg2MwA65E3tY2pEUkBiLI7QNE6hvfvP/523
	/1hl9QHs8dH9+gvbRuGDV/eTJ0mg/iWbKDEvCmhdfq+Ls+3hagflW99n7dZT
X-Gm-Gg: ASbGncskKQQJ9aaZwXcSP+7PhlxQbvlpHgkgDRmMdW/iNRPcEImetOJdihwPGN+Cwql
	oUtJeTQmxD+30zNV11qai1RuLepxXvYRsC+wqNfBt3YuYWeVVyt3AidsAdzMt1fGfm3X6pM4edU
	MnCaWayNzuCOWSRsbqE1fpA9r1PsQvHWhNN4Ai4sBCLJLZF1PXIpjU7Q4NuxHnGB+5Z9cYT1ulU
	S5j/f6U/wLHzXgDEz+PsxzX1Rg+v0zo1g8rrgQ7L7L1m4/nrqi+4y2ckYUFjUAEXTl04jP9EXI6
	mrb9bCEH/L/hyOQ4pqisjx/sDR52Z1oMYANfew2bawrbKrPaBNol6JvNuBuJgZn50+5lx8tmyKU
	t1zenadTSR7iPIBBpZVxsNyE82ecl9+0xhC+kEY+IJH8sIw==
X-Google-Smtp-Source: AGHT+IF8Z7yZATKXJfaLN17TgFdBFU8En8+L9b+O395Hq0aEmnaUd728BfqLDYxDf3vkR0S1KgdgXA==
X-Received: by 2002:a05:6a20:a124:b0:243:78a:82cc with SMTP id adf61e73a8af0-32da8fcccbdmr6633009637.25.1759981141021;
        Wed, 08 Oct 2025 20:39:01 -0700 (PDT)
Received: from [10.1.0.86] ([128.24.161.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b51101e17sm5044470a91.10.2025.10.08.20.39.00
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 20:39:00 -0700 (PDT)
Date: Wed, 08 Oct 2025 20:39:00 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============0360697002442412500=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2_0/2=5D_stat=3A_improve_zone_reset_count_reporting?=
In-Reply-To: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
References: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
Message-ID: <175998114000.2754.4015645201934691969@runnervmwhb2z>

--===============0360697002442412500==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/18364283776

--===============0360697002442412500==--
