Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535832327A7
	for <fio@vger.kernel.org>; Wed,  7 May 2025 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746617368; cv=none; b=fly639wWMLhDwwwz7xiP0eLTDNx9dNuuAiBCfBaeNkfMqm0O4chNacJmA4IE+dfNnv5Dt4mcbiid1oJQibd7Ae0eo731CTxU2COceq7cbTDd0nyUfjNOhGkD8vQ79cTcC2wjfw4cn+vJTAoWvtcD5zzppow36sWwkCiUwg6WAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746617368; c=relaxed/simple;
	bh=TwzegJbbke4l3Ux+ItbuwKTJXKrsjJYYzVRsXNXq5SQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=my9h+lg8WD0yAzjPyOW5y2CkBeOjtQrPc1Ttqi3KI6wcp8keTLlDfWBID3rf1hKtusJJ//nV2SyYv19JHUxVROHcGk8Fj9PmgtZjXVTP0htP6Jwe025wE43uWTjwWs8E3Viri5bgMh1UvVPZSFNLb6SgyZWqDdR/emWPtPTt2ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ik1ZGeZA; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ik1ZGeZA"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-867347b8de9so28819639f.0
        for <fio@vger.kernel.org>; Wed, 07 May 2025 04:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746617363; x=1747222163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gF9mjSJKvH7vy/pDpLbbyMggp28iXPCG702LjEj7OlM=;
        b=Ik1ZGeZAAA4t6PqgQCU4WSWYu+G2glvNfwHOcrIILMbq4bF14G2Nq8A+GgBuNyMXSF
         TODgH0MK6g90aSu/Vi9qz+xU/o38auzoWjwXeDHmUpPbQthf5DFeiAAx3tB4eV/Z8VH5
         5wwzKIDLJ+wMSZAuku761XB/p7ljdHzvFlKtT0Sj7w05WLEpgHKz+31HNEp4fe+VuDRa
         bxZHegwx08BEIRlgbhX/EozdeU2wzBAnbbb65mMatHLvDnbxNoWaK2R2GYvL9l/R7+g3
         FuBkU7vbJSENsAOOUtQo+8HCMVOXcicpHn0sZST18r4dNAvMXeEO52KjaQNc1bPz2jkM
         DY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746617363; x=1747222163;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gF9mjSJKvH7vy/pDpLbbyMggp28iXPCG702LjEj7OlM=;
        b=nOudXmw99BbqUHKA4POhjpmlHqC1gYT182p+BKMgk5e2HA19T+u7RIpb2MpfqrlfbA
         W1Du+QhIbvFjzFlTL6dwrP4GrtlodIOcQLF3E25COnoMH1qgJeN9BbfDZs3tywQi/xXL
         yQmsijk81s3iJb0W+Z+bSyRRueyyd+iEOCUaluZgVqGfke5aKy770K2qOsUMhjz05SjX
         EBdrIGVPM8T7plnzR3m0r9z0OinQjmrftNkcZ3raY6QcWwi0ZgRhbppCNgZsVAnWd+WL
         46igHFHUtobK3HO0AH0HafT2GwVA7uiuf6FZW8djjTKzuo5S7XSB5HrT3S+PfegjXZBD
         P1XA==
X-Gm-Message-State: AOJu0YzOnxCoC/ZmrEN5bLW2A6BU9RhGsdnpF7oB5yVdpjKV/cltaLfU
	c4gYRFcxJu3MyrcfRg3oY9eQ+h6pPNQVfdhsytkiNd6rSzPY3LE7QSJzBPwhdDc=
X-Gm-Gg: ASbGncvb8YhABpUGYMeyo+0u31uT24iNLCbE89n1TpWNnraAENLWWNbc1PvI3dSr9Ya
	2mhzZ9oU2Rx7nmkmbVNgetj2Qyhbh6weW7UHFeocIPKZ03Fb+qbfbZCOaihVIwIj1pp4NqfDAuF
	FgsaCk9Cz+vFAm3dJmYTW8M1XCOepxBq8k8CFdLNrg1Y02qtPC52hjOW6E39fjdYM7KoArsL7am
	+rJVvwwtR7aWS+UA8OTIqtE4QtpshiKkVjeuy4O6ksa9tIf3/QNTRLesZoEScfzEw9c/OEy7X0x
	oV/LCZCogMMvN2Fdnb5vTkN8PXh6dXLp9VtHwbLaIJM=
X-Google-Smtp-Source: AGHT+IH9/YAqyIO4l3Y98MH8IEYw0e4WSR1GrG+g0H1eBmAVMxw3QXoSO4+MAohG7x4liRu9BH0oaQ==
X-Received: by 2002:a05:6e02:1d88:b0:3d4:2ea4:6b87 with SMTP id e9e14a558f8ab-3da73916d5cmr24256795ab.11.1746617363035;
        Wed, 07 May 2025 04:29:23 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da71c4e704sm5326835ab.64.2025.05.07.04.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 04:29:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 0/8] zbd: support continue_on_error for zonemode=zbd
Message-Id: <174661736206.1785376.17260834205270367848.b4-ty@kernel.dk>
Date: Wed, 07 May 2025 05:29:22 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 25 Apr 2025 14:21:40 +0900, Shin'ichiro Kawasaki wrote:
> When the continue_on_error options is specified, it is expected that the
> workload continues to run when non-critical errors happen. However,
> write workloads with zonemode=zbd option can not continue after errors,
> if the failed writes cause partial data write on the target device. This
> partial write creates write pointer gap between the device and fio, then
> the next write requests by fio will fail due to unaligned write command
> errors. This restriction results in undesirable test stops during long
> runs for SMR drives which can recover defect sectors.
> 
> [...]

Applied, thanks!

[1/8] oslib: blkzoned: add blkzoned_move_zone_wp() helper function
      commit: 4175f4dbec5d1d9e5e0490026e98b1806188e098
[2/8] ioengine: add move_zone_wp() callback
      commit: 6f635d6f72ad3d4ae76fff63671a208c27bdaf2d
[3/8] engines/libzbc: implement move_zone_wp callback
      commit: d4f6fa5e35d6bd20dd648b3aaaad84a0a9a4fa6e
[4/8] zbd: introduce zbd_move_zone_wp()
      commit: 143aaff963694ee3745c204f414e1e27a759a7df
[5/8] zbd: add the recover_zbd_write_error option
      commit: 650c4ad385cf7ff320cb34f76784ca63d2daa32e
[6/8] t/zbd: set badblocks related parameters in run-tests-against-nullb
      commit: 5cbd1644e0dcfeb55e6cb4717259778ed11cc70e
[7/8] t/zbd: add the test cases to confirm continue_on_error option
      commit: b6002e78926bce20bc168d02c83b7c8f5dd37470
[8/8] t/zbd: add run-tests-against-scsi_debug
      commit: 4dc6c8da6ed938f12a42f167839100ab551ae8d1

Best regards,
-- 
Jens Axboe



