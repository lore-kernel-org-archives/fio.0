Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E64256C83
	for <fio@vger.kernel.org>; Mon, 12 May 2025 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747039658; cv=none; b=EmswIuKmAAumljPe0was5zXbIsqdMSsFX55YW0287MaGXPZgLbZQHchNYdjfSNlPVPULT6Z0CzdWTKz3wOvhJFH+yoDosNEKyxaCsbrF5weKW41A5/k1ADJWuNvRQIRyCATO2DtceWMqqnZqA2heNQYG6iaGaOUyrWz6Cdq9xWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747039658; c=relaxed/simple;
	bh=g2+cGDOdex8SKvrCS59C+Y5ykG8tJSqY7EDBRAkeb0c=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=beNshioAdvuIBHlPvEtfPi4tUkPU0seh2S5wi96dprAhGrH7enIoVuoCy4LJ14hQHnlKt6qQK8b/x6dmMR4kDCxbGOieTDyDCNaj5aRcL9xrVVXKjHHmJ2Lqfw+UtewtxYdeYJpNV22CE7lKMwQuXek9pIXfVkIrvrb60jD+TAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhXji2YJ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhXji2YJ"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-309f3bf23b8so5140515a91.3
        for <fio@vger.kernel.org>; Mon, 12 May 2025 01:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747039654; x=1747644454; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g2+cGDOdex8SKvrCS59C+Y5ykG8tJSqY7EDBRAkeb0c=;
        b=mhXji2YJeJjjXkbPXgUhBEHcjZObZYOE18mTCg5fAKDi4WWin5XVzoZ5zW2h52UuPV
         hFyqxyvVKdiBLccIZlSiqmFnBjGnod7l7emQwJaqESUSq2czCrMQbvijMdRnh7xhqOdP
         qQ7/lyrig+/JjasN32yfBcbw0h6MSnrPTBPBLHIohejXaVT/Pgnm/6bR/07dRs56LbrA
         O+/ScWTRhl27fpkw4kEuxDD1UaS1LA9jerTAydnNwaUdYTEk2KCtB3m70nMV6s69U+8d
         /uDQrnwCbqxW3kWkZxlMSrIEtQLOZkM5ppO8uolisOtuTJ6SOXhZYq0MgqM78BLi+MpM
         IDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747039654; x=1747644454;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2+cGDOdex8SKvrCS59C+Y5ykG8tJSqY7EDBRAkeb0c=;
        b=owUYQ4ZEAeTnXgcUsAiMp3ot6kLPH5Iko62R/+8ffstJOCrha3Cb8EjNXZcWsdmU43
         Kbe7tZFHh3TZi1Yppg1Zb3ok8Mmd3+FoLmwLEGHKELqNXrqKRykLpoTBXqHwlMoN9ibH
         lIpb5Sqmn5AxSv++mDrQu6go9OXBibbPHNcPewvpcTnIQnCP08Evd5NvFSdh6oTGmY2J
         S/v8gjScBwIsVvlvSX7gaL5BujuxRbLlvG9WW54gaY31vdt3LBi/cYsj2kp4um5bBClD
         MtkkJqkDzMwpzHsdbC6m8X9fXvcjJz3MMTWC7HmkRBCyhzQUJ6fOo5FB4SJmlOzXxhKF
         cxTw==
X-Gm-Message-State: AOJu0Yyn2IwGw67HimKiVDAJssOroHUUCBaFu+csXPYUE3te241nkob6
	FrjtEMYWrECYzauh4Iu5qIn7xeh/7t/NhDLxRpfZ39fgc7F4Kk09FM6x
X-Gm-Gg: ASbGncu0BA0wuzahXSSS4FpHPEVFCpDopddfQd7QiLmc4MtA0lOue7+BlOn3KHx86qN
	Uc+CddUprikDzAJKX4aVlAcrrBDO/hgcgQp+viqMAKSydAX+B5F6ZULSmf9KvmwrU6s+ifpnoOb
	A53BUCDuvVzrgr0I40DuC/GjgLNOTLrjk/7ovFa0SfBRSkkBnIj1dOTfLuN4WFXUJOBENQdnJiS
	OxpKxqdcVz08aU4PN79h6fOrhApSuCUQ6KLkWDkU3K4egjb/kU06WINodu4eBW9ftHJo11MsRld
	Mr0w7SVK+QBl4FCdErMsQDxX+eKSbVz1YUpByQhVs+/wFhGYVZLdsmztXJj3q9lUrLKyXdTzLB0
	dj3PS4/dOxuZg5kFRIbX/NwMTOkq6Vf4+hJgJQ4Vkt0Qrhw==
X-Google-Smtp-Source: AGHT+IFaBb5W+AbAUfRwQ1Lop5Uix9jviTwQXo5j2OSgmTCpFugAQKpuNOvJaU8tZnzqvNrDHcsXbw==
X-Received: by 2002:a17:90b:278d:b0:2ee:9e06:7db0 with SMTP id 98e67ed59e1d1-30c3cff5ca2mr21469229a91.11.1747039654494;
        Mon, 12 May 2025 01:47:34 -0700 (PDT)
Received: from fv-az1693-421.ta2el201fmauvbt1524me5x4xb.dx.internal.cloudapp.net ([52.234.46.120])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad4d2f1e8sm8457136a91.11.2025.05.12.01.47.34
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 01:47:34 -0700 (PDT)
Date: Mon, 12 May 2025 01:47:34 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============5141835954446916252=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_fio=5Fsem=2C_diskutil=3A_introduce_fio=5Fshared=5Fsem_and_use_it_for_diskutil_lock?=
In-Reply-To: <20250512013022.64633-1-shinichiro.kawasaki@wdc.com>
References: <20250512013022.64633-1-shinichiro.kawasaki@wdc.com>
Message-ID: <174703965379.2555.752018432508173249@fv-az1693-421.ta2el201fmauvbt1524me5x4xb.dx.internal.cloudapp.net>

--===============5141835954446916252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: cancelled

For more details see https://github.com/fiotestbot/fio/actions/runs/14962653715

--===============5141835954446916252==--
