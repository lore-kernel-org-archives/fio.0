Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA813342F
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708011642; cv=none; b=S3WIkTnBUjKa/MjjThlekaovPBL6DK5+csXa9vWXsKevTQ+YbA7ja+br3SFXaKaJbNPPCX8utu33EDpexNkOUggtWGylZgeeg3/p219J2snqUu+m6ZRHxobyvEt6IJQbmVO+xbdyIeXJL/Mz2Phc1yAiHF/tiTbxTynzGLia7yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708011642; c=relaxed/simple;
	bh=SSa6jYi0MkCamZ8XbpZbVihmPgrguxM6ett4WON1UO8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HPe2YQAvZcibhDsdkgkNhU8ceLDY0ySQyGm6yYkzYRZMNXrWxcijG1ta7pbF0Fq7Zv1N0K4io0/Je7ljlGEgimvN1Yxk2crwZmB3narFSTr/hRUhQxOzT4khgxkEmuRUzydCEuVKyMwN3/AUq2b6DcxrbVZidT5kqRBGMdpSeVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I9dLAwWJ; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I9dLAwWJ"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-363acc3bbd8so476805ab.1
        for <fio@vger.kernel.org>; Thu, 15 Feb 2024 07:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708011637; x=1708616437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5j3axKNPgjddyG2D2vqVWTuYHhVCT5D1yPJA6xE3uY=;
        b=I9dLAwWJa5Z6D8Lhy8G6YUAH5amD6X2NiLhtuNYxtTwhDbRD5v/onuo7upo5hmEfHM
         eysDkV5HLnULyrlfr8LVe+EROwjIMTMcgVecVKu5FFf405JP+riAI5VT3VmiAOpXPCxG
         QMdbV2iEIWaW3Z65PRnaodwK3cQBNHl3bTDGX0lPeduG+13suIzPUFfNlUlCXni5J616
         qtf1bNKgx4Ebx259uScY8h7t98+wQDA2my/DuMJ01vVYX/2jNRiu/JOwqWuixb8ZjMgp
         e1nkIrLfI6wpl9LB0UI5HiJGz0qyL4HVPb/Tq8LDrVhY12KtqDXplwliH2myHiDmSqG3
         H4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708011637; x=1708616437;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i5j3axKNPgjddyG2D2vqVWTuYHhVCT5D1yPJA6xE3uY=;
        b=VwXtpeuMP3rYCjypGVszY1TZZMd7+Ewx3w2Nji7AVVaZXeMyuWDJsqiadmTUglsXF4
         y/aAY2U0McwHRDD43TrlcyEJAnm0TZvRgWjlVYyssBXwHCgzvXtrpbEx213l4tB7rQbA
         uzpdvta8HH7o33X+IiYhSU+aY4uVXhkNEcjfXxqupLaAi/K2FibTRa/ZEr3SukREouF1
         eDegcQghQd6KcVE5mk9VLWLjaZrMDv8YBNbGOtArskvfPYBgt2BJCatwl04oDMXZTXow
         CW2qewFmDwaUlmaAM98VI0Jek0WQ/R0FlGKfcYkf54XGjhV8qX1U7ZWDwufBZL/3gu1x
         FZcw==
X-Gm-Message-State: AOJu0Yz7UkqFcZA7RPWb414Art0119lSO/KMyvbWvd/ZoQ8gsf0ZMNV0
	QSVbIFHHNNQCHV34rrWkuWwJI6Fb/9g/FWe8b4PkyNHgDvb7TcUjC86PiFx0IZ+NMzNzCm5L4mS
	8
X-Google-Smtp-Source: AGHT+IGIGZO+u5vPemjf9OccdFL3HAK/7g8KQcjJpxwsW+MfTl0U/tjH+ylHammzKPVdnGGU6mY/kQ==
X-Received: by 2002:a05:6e02:1c05:b0:35f:bc09:c56b with SMTP id l5-20020a056e021c0500b0035fbc09c56bmr1718093ilh.2.1708011637596;
        Thu, 15 Feb 2024 07:40:37 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 9-20020a056e0211a900b00363980d75d3sm433488ilj.2.2024.02.15.07.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 07:40:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: vincentfu@gmail.com, Ankit Kumar <ankit.kumar@samsung.com>
Cc: fio@vger.kernel.org, joshi.k@samsung.com
In-Reply-To: <20240215151812.138370-1-ankit.kumar@samsung.com>
References: <CGME20240215100103epcas5p3271477465b0155deb7483f26858087ec@epcas5p3.samsung.com>
 <20240215151812.138370-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH v2 0/3] Support trim with multiple ranges
Message-Id: <170801163679.3036043.13144027146541040787.b4-ty@kernel.dk>
Date: Thu, 15 Feb 2024 08:40:36 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 15 Feb 2024 20:48:09 +0530, Ankit Kumar wrote:
> NVMe specification allow multiple ranges for the dataset management
> command. The block ioctl only accepts a single entry for trim, but
> with nvme character device we can send multiple ranges.
> 
> The first patch in this series adds an option num_range to send multiple
> range per trim request. This will only work if the data direction is
> solely trim i.e. trim or randtrim.
> 
> [...]

Applied, thanks!

[1/3] trim: add support for multiple ranges
      commit: b3251e31bae2c2ec7c8db0e7e7511eb03b8b0190
[2/3] engines/nvme: pass offset and len instead of io_u
      commit: 0d610785a8072eba146dd05f2928a1a89da49bd5
[3/3] engines/io_uring: add multi range dsm support
      commit: 5d4ee0de9d6afaa74c7c15c3d4f210a06d4e2139

Best regards,
-- 
Jens Axboe



