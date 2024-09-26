Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2144C79
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727372020; cv=none; b=dyc7U1DREjni07ew2u+iI7RO5NIAV59Peq4yU0q5BqErBTHJq6Syovn8IvD2mFzVZs7GGASHKGJaggKsLkmMu4vyZhm4zLrRt+yJrGuZ+3OUI+5r6pynZ3NqJcredxXnji+RBbGLI/9ZRGxRYfWDkq0NMCABoAsk9jdp90aWLFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727372020; c=relaxed/simple;
	bh=yzMt1UyySL0uRA9Tu0hlLewHzwZ4UVeXT/IwSlGFezI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Mqq/oRuDv63vj8POXAx2LqGfliVD+mMPR3b5Po5rqqBSKwACaGySMsmvSwtoMqMM78BkUZLg8OT/aBqz0sqv7JYZ7wKRlf8Z/SRTDwAAv5BTcy/+7EoHp6T9oTLI6qTe/anFnanKKOJPVN4cfWOT+ZHvsa48DawcUxAOI8TNbWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qFTE0HZq; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qFTE0HZq"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-82ab349320fso53728939f.1
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 10:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727372016; x=1727976816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObQLB36Rt4vAF94vEv/YmDFpBkL+s1CAzfyEhBEmVZ8=;
        b=qFTE0HZqrrUftKgFvegRdfcTpKN4uaVAHB/BhmKeorNgNAXIkz7imHHWdmrXzWDbah
         axIubGD8GW7JTNVoXTcZbezBz60GEn8rC59/g/gJaBgfdaI/0slkGD23ANNnMsrlO7kU
         whOKX3IzsAAGHY0oANet0uNV/ku5q9hF5DisUvrbW+hh9ctXWFi0J1WSuCxqYJ8Qao7F
         ackdNsQMry1r9R40BcHwla7mi73JWUvwQkwUahVJeraqaFy+8iZOgFUHfZ4pWMsvaG/k
         cBDSljmHqwT+ViLm63EKfyXDDNCUbegBxxcOzqNljD+jZjd3gb1nYHY0KGpYWadRb4DN
         6BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727372016; x=1727976816;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ObQLB36Rt4vAF94vEv/YmDFpBkL+s1CAzfyEhBEmVZ8=;
        b=Wi/3OlGYVLTjJDfgFsUgblr5UuFiYP0RTqJWWaW9vJtnNOEL1uySOKAIUioarpKmV/
         HGqOOdDUxzu1XvZxcYo0nYbbu/rdaElRMyJI6iiootFLLlbCKeh88KPNdawx/qXey64R
         uTHFF1X6cat6Kw0pxEjlUGNq/U4aPKbHQDcYCar2H/Zf1Md/655KsT/RvGPdavYAnvkz
         RheiZGxkdog+utqJqYBkOp+wfTmdEG9G0wEUW+hNOSiemhmd2Uqv65ulz+goAWkI9EIQ
         wr/9WEcGzH0hEvxAoQEZq0ewd47oAH8xHWQZybbzV9+AlxhrDaoFJ6AE2yUnubbAfZ9B
         UpaA==
X-Gm-Message-State: AOJu0YxupQ6y0nnv7KplcWwGXBxmAbD9FvuPX7XjHlTO3CB2MP3ikJ6i
	VbSct8OlymGXOA+AeL0kjruF1CvtUUpITa+dO1jW/3seTvZ9L9w5zQswGxsW/TicPkn6/sXrOoL
	9Ez2iFg==
X-Google-Smtp-Source: AGHT+IHN+DwylRca2yK8LR6UBwI7eD+OWgyijXLwQtrkHIuBunlqhwSewVXHUgJLEaX4A6hYk141dQ==
X-Received: by 2002:a05:6e02:1d92:b0:3a0:49da:8f6d with SMTP id e9e14a558f8ab-3a3452ba629mr1650955ab.22.1727372016596;
        Thu, 26 Sep 2024 10:33:36 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.128.115])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344df41fcsm404545ab.86.2024.09.26.10.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 10:33:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
In-Reply-To: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error
 types
Message-Id: <172737201034.348564.13850142856663579318.b4-ty@kernel.dk>
Date: Thu, 26 Sep 2024 11:33:30 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Thu, 26 Sep 2024 09:41:34 +0900, Minwoo Im wrote:
> __io_u_log_error expects a positive value of io_u->error parsing it with
> strerror() expecting it to be an errno.  io_uring_cmd (cmd_type=nvme),
> for example, has returned errno value as a positive value and
> device-specific CQE status type and code as well.
> 
> Commit 78831c6b35c5 ("io_uring: Fix the flip to negative of CQE status")
> has put the abs() to the cqe->res, and it caused confusions between the
> actual CQE stauts and the system error value (errno).  Now we have
> Commit 2a13699a89dc ("io_uring: Add .errdetails to parse CQ status"),
> meaning that io_uring_cmd ioengines will parse the actual value of
> io_u->error value as CQE status value, so we should know if the value is
> for CQE status or errno.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
      commit: ebe67b667f25694ead4caa0198598318f891b345

Best regards,
-- 
Jens Axboe



