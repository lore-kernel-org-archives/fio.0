Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965E513FED
	for <fio@vger.kernel.org>; Thu,  2 Nov 2023 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3D+NZu+X"
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C881A6
	for <fio@vger.kernel.org>; Thu,  2 Nov 2023 05:09:57 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc41afd376so1427665ad.1
        for <fio@vger.kernel.org>; Thu, 02 Nov 2023 05:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698926997; x=1699531797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCPu6x3o6V9OTEa/uvsvy/4tpMXQnSjy+/yD32S3Kyo=;
        b=3D+NZu+XpxTEc0dueeBhm/RM1VKXyMsLcTmBQoepfY4ShHaDV/sXPQdDUNsBARCQRq
         E4Xdu6kj0WAitFAFY5/9oLLSh9YPpKGOUIcrT6BsaAgr1e1ElU+Z8kY+FAdUTeyGEf1P
         Crm8FAJboFmOuFTnbQ3YTvIVIg0fPvO13E5NIv6ixxPOWIQSnq6eG4BhWrpEvMnKc31q
         9LgeEwK/VT4x/t3QRqn0wIgUt9rTtvg78Hcsx29PPH8E3r4SYRdd++Dp+YY8r6784GW9
         DXi1eCBJXxL7wiApjjmSE3DxJU27QSNOresHAeCkSMaBgkKXmK32Tron1++noEn+iqkG
         8B5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698926997; x=1699531797;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kCPu6x3o6V9OTEa/uvsvy/4tpMXQnSjy+/yD32S3Kyo=;
        b=aSBKURd21UeJqkJikLgWHDEvNhk4Jg+4tf3poKe9Uxfg2NRB0jVQOtyx+4pSWCaDUX
         pAxNLzbHrlPsvFCWj+awZEbXkKGlU7tULMQWZqNca6j2E5sy9c0DDLTzl9brrJKDzFHS
         Xk/V8pjyGV12bdtL2u10qx7L+fpEpiSjxy+2DV+F9a7BRJeVVSsV920kkdBAmGzaKBti
         B/LWyYtUaae6ALAndxcmhHcewV3b/oS/cFAKcplH5VtR3aXY3OBQGZG/E+LngXa5Ai2t
         01vtcOTtibsw+gJSofxvEFboqG3zlKKSFv+8OkwNRcJb1enThD4x5CHAuAWz3vPEiqTG
         tXKw==
X-Gm-Message-State: AOJu0Yyr1t/rrnV1cVEypzX4l7c+4RdlgN44nVzzhWFnOoi8phmhy09r
	vgXmLFME0OONW31voy8tU5hNig==
X-Google-Smtp-Source: AGHT+IGclOVeLgavboZXAPEYuZvBFjv/ZXCrmBZ8WXolplgXBb8599QMarPI0hZKNDrU4ViICYIgtQ==
X-Received: by 2002:a17:903:1383:b0:1cc:394e:102a with SMTP id jx3-20020a170903138300b001cc394e102amr13856515plb.0.1698926997311;
        Thu, 02 Nov 2023 05:09:57 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l8-20020a170902f68800b001bd28b9c3ddsm2987979plg.299.2023.11.02.05.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 05:09:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ankit Kumar <ankit.kumar@samsung.com>
Cc: fio@vger.kernel.org, vincentfu@gmail.com
In-Reply-To: <20231102135928.195372-1-ankit.kumar@samsung.com>
References: <CGME20231102084106epcas5p21fea8b9fb34faef6c9783d020e57a2f5@epcas5p2.samsung.com>
 <20231102135928.195372-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH] engines/xnvme: fix fdp support for userspace drivers
Message-Id: <169892699637.469010.15819801641541826948.b4-ty@kernel.dk>
Date: Thu, 02 Nov 2023 06:09:56 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615


On Thu, 02 Nov 2023 19:29:28 +0530, Ankit Kumar wrote:
> The xNVMe backend supports FDP commands for userspace drivers
> such as SPDK. Enable support in the xnvme ioengine.
> Update the xnvme fdp example file accordingly.
> 
> 

Applied, thanks!

[1/1] engines/xnvme: fix fdp support for userspace drivers
      commit: 48cf0c63e5b867c8953f25deaa02466bf94a2eed

Best regards,
-- 
Jens Axboe



