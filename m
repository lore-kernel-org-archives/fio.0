Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD17A15B10E
	for <fio@vger.kernel.org>; Fri, 27 Sep 2024 10:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727432344; cv=none; b=csRuYwdWHTs30INaG06uPU6qEHcoh06gB5fltDNJQKxlbspAW4ghQF0d/uCNgP5+brf1dPQvVtpZz8YGPvVyYrkp7XhenoGN7Cbs+oFy/oN3etXnIAdlomFzsfX/d+I+bv/hbnzgzCvquY/iXtD6d/9ukPu3NbmBpjDgD0AHj8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727432344; c=relaxed/simple;
	bh=GtheCC2yFpVkcsajr9RdI7ku8Z6ZCiasUhSJkhQb+oA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PA7+3qwMwXOXnw+0CRE0jya0XzvyfQoXHCWwe2J4vAXrwzCCEjxF3pHK3Owyp150CPwqqEnxVFqgEsDk7k9OPnqg9IZ6L0LBxKP+dtja4u6ec8Y5dWFEoc+yHRxsB1cT3geEvGXbCYMhYJmfEQ+mfHdUIxp/LYR1Yrd9axVt0+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nuIAcMe9; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nuIAcMe9"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2054e22ce3fso22808045ad.2
        for <fio@vger.kernel.org>; Fri, 27 Sep 2024 03:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727432341; x=1728037141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/yOtC0q+c9KmwU3cto8PeFIs/l5Sz775JLGmcNThWU=;
        b=nuIAcMe9XqcQuWApA+tFdsU1UA5nVrfXNB2Ehpu78MRyDBtzYqx2t+9//VUbVXppD2
         Wdqf5eJVWinG15ewaPu6e2386BZNQ/0HjG5r0cDe42UBkAHjBDf25byk8oDsbWhzercj
         KAPE8denBMxR5xeR+FKn4w2dIQm+ABrAOTojroUgmfE2ObEeb9nfU/7YKKN0f25QhE5t
         rN0TTpNe5sulaKxm/a0OY6by0dLPXxpCuY1V8tso+cqcgqVDp7oXLzZ7vbjgWrnCrmRb
         j8izDC2YZN7rvHkcR4mcRBnGu+BKH1XefTBvcPaHa/7r31uaUZNCd2VL6+UlW12tOW1I
         040Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727432341; x=1728037141;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/yOtC0q+c9KmwU3cto8PeFIs/l5Sz775JLGmcNThWU=;
        b=EqkHyxRhCHbqJxcFCTfdKf2U9dksyvOhHdEN9/E2FXcu5jA8Y9RLHNrC3KSlrTyX7n
         98NVIdvZDYKYt6G7CDxYYQildREfvz9SI3LWG9VEg9nNuofv/U3AxhpdXWS7vg1Q8G/v
         2/Oq8WFz2D6k60dSdIfwD6VMc80altQ3JiD5R5PPslvFLgt1/uqny4uv3+PmcLYkAlxH
         2xbWk1XP3QqFhzMmHN0qS7oDqeMPeyleHx19SZagsTcyBBnc010ZF2X82AAG2qkJEwM8
         pckb58C5O15yIP3zWaaXzfvfgmF20D8DlgFD8RSA8jCf1fnjkPcAJheRDQdtTHD9g9fI
         awAQ==
X-Gm-Message-State: AOJu0Yx9He1lpNi8e5jxgbzmZgfXm4jtGsm+dHcqpsApkiTb6dCiECFI
	dF8uqpzwbxYukrVRg4V0Zav/trDieI9CE5bHBURKuDlanRjZ6/LBnajqst0xb1A=
X-Google-Smtp-Source: AGHT+IFqKqyEOx+NrtlMapQg/9xrAyZltmbKDEbm/qEP8QfxzSIL/92GSwgq5cMdVaJ7GQ0sK1XfBg==
X-Received: by 2002:a17:90a:67c6:b0:2d8:840b:9654 with SMTP id 98e67ed59e1d1-2e0b8ed1658mr3049865a91.34.1727432340657;
        Fri, 27 Sep 2024 03:19:00 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e0b6c7729fsm1666729a91.22.2024.09.27.03.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 03:18:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
In-Reply-To: <20240927030857.17001-1-minwoo.im.dev@gmail.com>
References: <20240927030857.17001-1-minwoo.im.dev@gmail.com>
Subject: Re: [PATCH] engines/io_uring: Fix negative errno in io_u->error
Message-Id: <172743233882.34160.722966549342748593.b4-ty@kernel.dk>
Date: Fri, 27 Sep 2024 04:18:58 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Fri, 27 Sep 2024 12:08:57 +0900, Minwoo Im wrote:
> io_u->error can have either negative errno value or device-specific
> error status as a positive value.  fio always tries to parse the errno
> with strerrno() and it expects the value to be a positive one.
> 
> Commit ebe67b667f25 ("io_uring: Add IO_U_F_DEVICE_ERRROR to identify
> error types") tried to abs(io_u->error) to convert it first.  And it
> caused the following build warning:
> 
> [...]

Applied, thanks!

[1/1] engines/io_uring: Fix negative errno in io_u->error
      commit: e4e8520b374e7e021d289d400ade70c41681d635

Best regards,
-- 
Jens Axboe



