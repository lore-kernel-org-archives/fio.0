Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14D3206F22
	for <fio@vger.kernel.org>; Thu, 13 Feb 2025 05:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739425783; cv=none; b=bDY/I6gcSNU0t0Uc82z9Zf1PDNsh56OO9GkuBZYuG6YHZAH50wEAXoskwwTImWlN6hWDllYBoHkWXwr7PHp9TwrKrhGcdBLip4MFtnCgaa1pfd+qxcbesHCqopi7QwjOwHS/wkrCnzQlg9Ir6wUqqwr+6ntcxVkP5bHLtyDcQH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739425783; c=relaxed/simple;
	bh=ptaXJrNTlsxIVRWJtz4UlE9qifyDmghwqvZvw1Y6Wgw=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=FWLvLyzwAWfuSlcZ6StjAENxGzQJpayqn4Xtb01n6XUsvqMeORgeatvz7Xl+EbwSQXMivn5UxzZsvv/ZLarJwVm19mQAje19uzM9wcOiSvzEkNgzG4XUmQbrk/2+NSnnrnd4TpvJFhGFaRusVROYBpyzEDEKUB4EOaiCMFeza6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ByuD/yxd; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByuD/yxd"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2f44353649aso830473a91.0
        for <fio@vger.kernel.org>; Wed, 12 Feb 2025 21:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739425781; x=1740030581; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ptaXJrNTlsxIVRWJtz4UlE9qifyDmghwqvZvw1Y6Wgw=;
        b=ByuD/yxd6hWf8DHgV/592+R+4d48ix1kVDIRjv14JDlm110MPHuIaoS/a52XhjDAh4
         Wqn6/FwN0LSszDbcutDP5UJ3auN9HMbAN86o4ZCRYWaeSID0fQuAzoej7/Ve3xJ7RIvi
         dmmOuIiY0LHoHZImYpFoxgdVYIhRPAco1YJhYJOeC2/DAmTWyRgUMcazxkgbgZawRoid
         +yjS7jPCbbgf++abWwtlO7WKVBtL5aom5fltmNpqIcPpuCEV/Eb494QEUvcFuP5VwNjg
         CkFZcZgjyy7ZnYtADdU7jl2MDv8a24+Dkm6ClC7lvpWN4gyJPx37OhEZ60jHMkukNTXm
         JtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739425781; x=1740030581;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ptaXJrNTlsxIVRWJtz4UlE9qifyDmghwqvZvw1Y6Wgw=;
        b=w6lGQ67HxBOxFWxMLXHfXR9gjfXPzBDwKF2IxIACHP5TAqj5e8pH+w7eDyu+oM46X+
         bI9Krnl0VskLZAURQQ8ofzlhvT7dlnx9nVonITjVSViEstI8pTqd7nPuP67h9ifT9ARp
         3tI58x+7CJ0qRXsMQ7abVq0ZdYwYngYQmLcmTabCbzOkEX7tqn147I9YU6er/whxOp9F
         zGXcnQAYIC3cRvp+hIqICZ+S/xNJdYthkyT9Gzxh3ND7hqM0KlYji+GUWh9IEh9beXXh
         T5VyI7Br/qh6zCmo1LhtkW5RdSABB9YsssF3N19Z6IVJvtiH9KrV2DkBmSk2fdt9olWu
         wAdw==
X-Gm-Message-State: AOJu0Yw6XK9/kzY00FnjUwbImIvYjRyGb4tkzKZ1SYPzZnbEC5kKW/xe
	1wLL2PXuLJ84ankjy93xEfEA/FrHuqWVAWcDJtdd8w8YwPOcVhaPJt7f
X-Gm-Gg: ASbGncuVadaif0zPqPFT8COh7nTkGWU7ankgMhmP466ylbG0ACGaJIM0Mr3SgsgLoiK
	0gf9twIFB9F0BO9/8d6FSpWjVbfFXDSUGapMd+Zs/VM/X8mU78q7FirvGrBSoAQrr8Zk8BOkrUA
	Z7C8ysXEEytwiYAaoHS0LV07DWqH2x6s6thdwwpea33X9yxlM3cdW+lDW/mLxRfsJCfEhrmOngl
	sX4cYe3lBEi8eJlY8UsM6AJswiLCY99bgIygNA4WGX6gSMVLb9duHeE8/qYmYsCK1kwqssK1cpl
	tC/9QMW4vwaqDzoqJBrzF0Eiti//i94Y41Z633gOFAnmxOtogmnbcrEUrnVItgHkaRaCY8A1Ei1
	zT3NOzo3te8Y=
X-Google-Smtp-Source: AGHT+IH0e7FxZpf1dnuewNzm6xB1EPQdhych8psMqhSMLz58XhSc1saiCRNMqd5YP/yGw73rFzP95A==
X-Received: by 2002:a17:90b:258e:b0:2f8:34df:5652 with SMTP id 98e67ed59e1d1-2fbf9072b46mr7348276a91.21.1739425780589;
        Wed, 12 Feb 2025 21:49:40 -0800 (PST)
Received: from fv-az1915-977.xkjcjftakiyujkhqi2elkn4nmb.dx.internal.cloudapp.net ([52.160.165.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf9757365sm2415842a91.0.2025.02.12.21.49.40
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 21:49:40 -0800 (PST)
Date: Wed, 12 Feb 2025 21:49:40 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============4586733178281175449=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/3=5D_fix_verify_stop_for_verify_state_of_async_writes?=
In-Reply-To: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
References: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
Message-ID: <173942577971.2484.12473423249844880679@fv-az1915-977.xkjcjftakiyujkhqi2elkn4nmb.dx.internal.cloudapp.net>

--===============4586733178281175449==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/13301127698

--===============4586733178281175449==--
