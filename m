Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E661AAD7
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 12:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706100610; cv=none; b=IRdVx+iwarX7Kd1RMeUBNcbcQPd+/i5qFrv0bEO5I/UgRPJWmzLkKEk2eZtbsnZizDkVWhz2+w7AIL2DYCfhJEfEeKKYUXztKvR5qTG+PV9myTyw9pU8objA9ZsyAWG7jMlsKsRXtNspSR1IC00kK43oC1ALvruwYtDGhDss39A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706100610; c=relaxed/simple;
	bh=9MqoOT4Kh2Ro9gfuJZNG77O0Sh/mMMxhMFZoXsVe6s0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pbLdp0lvOUOt4KSsCYqnkPPVTTHuZHUhrDhpyP+pCeQ5R4PABTYi8hyTljcYYG+gC3lnuAlW3mfu/QWUDjXiNFl25iH6qRRViwa5pSBIXuoaVimWOCe+c7qHJqewZgeK7jn1MeTcAnJMxIUBqrelhHK6P5ClDOTh/U5+ttRSv6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=apJ07OsH; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="apJ07OsH"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d722740622so6693365ad.0
        for <fio@vger.kernel.org>; Wed, 24 Jan 2024 04:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706100605; x=1706705405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=41Wx93VON2db7LfiB4ge0wyW9IxVccJ/oY7v4dLwcZs=;
        b=apJ07OsHaYYBr9SNqTTYGqpJRYJI4UkzbDBbHHS+x1LBcICChi4/pXiPB2zaFe28R8
         QX/6a9inu3AlQLiJdzMvYVkNOtup0bBTfSK4YQPd+Z171Zx6TIkuCP7RmLBboDR4vpki
         PAfSFI+VmreWpHaZqgqLc2xiLGE5WWX2g0hM/W7zEzef8JtN3Rf9rqE5e74/m7ilEx8n
         x+Z7R/ehzW9N0Uaxx5obcY6Asw9lDfqYM+nMAjvrcnEDq4yscCIi3IJNGH2i8AdxDRYZ
         SrhCnM6qciXTk3voXux0SMFEVDr6qIeRls55VYNe4IsMhGBgzuLDGEPdsX4RPgXPkRG0
         4q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706100605; x=1706705405;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41Wx93VON2db7LfiB4ge0wyW9IxVccJ/oY7v4dLwcZs=;
        b=v5wnuWn86i33B9E9uRrtttG2opEAvFlpADsgXlN2segzgMQjbFtG6AoSlfjW5KruWg
         vVSxCpLDRSPUxA4Ss6A2W7LJfRe5c/AxYc6QP/fdvwUJciUR7d6BunmDfXCgzCQsaXeR
         a8S3v24UeA3+vj4tclyDOOnpa0gdimhQ9o4TAYvtW2BRN4fB4tPp3FuQp/GZlnKqd+Wv
         zkvbpJNP9AGJZCHXxNUCkotI+7tONeyT6M+vr8OmwIbWQfoY+nItqIVuZvE1CpMZQyWK
         jEsc2/kk99iuU5POX4qulP4OtHoxi0QLueph4qUlptY/9o3rpOLyvg1XyPSlb/438pUi
         b58A==
X-Gm-Message-State: AOJu0Yzy+dGqGcFP9fGpoiXDqwqdi1xtrVJnuN2glQSWgUa1lQNMKaqb
	DxBrUXcvpgRrCpKFk+h1DXA7/EuovYutZ2Kt0GAp6SmA4NPtNux9oFRAZyJYuFClEexjOzgGr1n
	3jdk=
X-Google-Smtp-Source: AGHT+IHAbbGDHt7YHVg9OqHYCWUNi7WNTnTmRZCF6mbcAISQBIZv57iKeKv1NVU+CVndLGmZr36fEA==
X-Received: by 2002:a17:902:9f97:b0:1d7:3ea0:e6e5 with SMTP id g23-20020a1709029f9700b001d73ea0e6e5mr2243192plq.6.1706100605363;
        Wed, 24 Jan 2024 04:50:05 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id o1-20020a170902bcc100b001d75cd8e3c0sm4167359pls.130.2024.01.24.04.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 04:50:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: fio@vger.kernel.org
In-Reply-To: <20240123202636.179467-1-chris.packham@alliedtelesis.co.nz>
References: <20240123202636.179467-1-chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH] configure: Don't use cross_prefix when invoking
 pkg-config
Message-Id: <170610060445.2105877.9714457576369625906.b4-ty@kernel.dk>
Date: Wed, 24 Jan 2024 05:50:04 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 24 Jan 2024 09:26:36 +1300, Chris Packham wrote:
> pkg-config doesn't need to have a cross prefixed version. It can be
> pointed at alternate sysroots with environment variables like
> PKG_CONFIG_SYSROOT_DIR. The configure script was already inconsistent
> with using `pkg-config` in some places and `${cross_prefix}pkg-config`
> in others. Make check_min_lib_version() and the gtk checks consistent
> with the rest by dropping the `${cross_prefix}` usage with pkg-config.
> 
> [...]

Applied, thanks!

[1/1] configure: Don't use cross_prefix when invoking pkg-config
      commit: 1ee0469f6d180a98d31196bea787f37269ff9cdd

Best regards,
-- 
Jens Axboe



