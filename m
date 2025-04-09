Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF67277809
	for <fio@vger.kernel.org>; Wed,  9 Apr 2025 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224101; cv=none; b=DlkmTbbDD3NTojo5aJTKE+u9p1ljDXp4q8RGoC7qVtlhEAAy+hV0UtJh+L/ibhH0smLkPMbfhpQ6LEb7PnBsaByXe45fY8FBd5g92QPlte7b4RVB6JJOVjz/e4+cVDRLD9KX77aCn1dqvPhtQhhmEKT6gZNxmCv8zCnunIZbrlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224101; c=relaxed/simple;
	bh=oboJz04dH2b9ReEllDfrctcAoJg2OoZk9NPh6pAfeH8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=tMRGG/RV37Wih0VmCBgqWXzzTYKDc1tsYgmq2dTAum8IL7Xfniya/wL3FbE+m71xwdSaEq/nUBInYmGF6Aj8WJt4kcx7ZDG6pQE2BoTxc4jD07uAHWUKR0RKKkRNSVTVeT5Q8QyFvIYNqLg2jCxHRrwe2RQP3OPw8fdZ1OZ8GuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=NGE0dmYL; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="NGE0dmYL"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5f121612dabso2253a12.1
        for <fio@vger.kernel.org>; Wed, 09 Apr 2025 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1744224097; x=1744828897; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oboJz04dH2b9ReEllDfrctcAoJg2OoZk9NPh6pAfeH8=;
        b=NGE0dmYL2QAiLFFHyHspMBgN8n2jRDA3ePHFZSjHLQH5C7s8GtgvXpXuz8rjWIXqz0
         JccFl8pdtT8mTgKc3nlAtXtvqzQvrLaSSoIp+1FVunHPbkCIUr5HFtx63Rub8t0Jvfwn
         SaLCUg5PUbtrhgE43Cm8kDfHxNxTIipz1OhgCdrauBa9Ehb4gvzA9uMCAQgE2bIdnPbg
         /CoJzN4FVvP1HXqNgtlbzvDRt6q9xo9RUkvhsBYX/c+EWsO7oDEe4r3jtIuP+gN6RE92
         snP3gRzC3IVL+2FgOLsZDeg2m0GO7aOXOSOY045nv8XoKEQH2OepW4dp0FQx+1qncvlF
         d77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224097; x=1744828897;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oboJz04dH2b9ReEllDfrctcAoJg2OoZk9NPh6pAfeH8=;
        b=m3+BnYVgXZMs1jUWlsp2K2woNXiTcj6dxxsczZ+yuMAIzZY2pAKIAvckYWoGR+wKn/
         mOnrrW+3OPqSRdHJgXRaozijGdeh224lAgwVub15e4Le3Rf5bphBdQqkfdH64yd/UmwW
         itJ/B6bVrmbyjwb107gsT9PEpkEj13ZQPNsr+GGhyqc0SnJGtIZemRHXMTT4wI3UtJ+v
         ozS0xHhdCTFv3CcgEKc9xYCO35Dn2qHm4ytNm6PzUTcMDShDguOq3jv5Fik/Xocn2eNp
         QZmkGkengyGxfuOIVhQz8QY8EbQVcjBoBk7+JmPHs4zEUVBY6rd87x3bpl+L6Noghr8D
         fJAQ==
X-Gm-Message-State: AOJu0YzFtgYKQJaWj0GtGdKTCpSRs22wHRInjLXFLcdPw+MtgHFoRQ2N
	BWdLycD0pPGbBLn14nY8itcOB+tSyiC9uZKqrV1c0YYcA4278vZhkxJNYkkBanh8JLMT8zYTPMc
	WVGQOi522AxyDV9e3JzO+edPCf52pnZAM2GwlLIm/CjHiWJPy/jk=
X-Gm-Gg: ASbGncvSZxVa1xrt+Oahfp3p6DER0difrW6bWvE0IFldMM2lOFpnsNhWciY1zphc9SF
	o9FQBtJllgBHymbdmHLCcmiZc3DzlC0vIJDR1Q9dxNkTouFBhZc7g9yPMq6Nmf9gGA+kj5OKerC
	ExfJKD9IIqKN4NrlYsmBzp9w==
X-Google-Smtp-Source: AGHT+IG2AP5jAvIXiAFIG1xSOtm51ij74x9xAndZ+AN6L/U6PzktguYowqVx+aIcdTiy3pBRoKxkcOjiNEyFUGxG5OM=
X-Received: by 2002:a17:907:f212:b0:abf:689a:ed2c with SMTP id
 a640c23a62f3a-aca9b6bf52amr144419466b.6.1744224097441; Wed, 09 Apr 2025
 11:41:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nick Neumann <nick@pcpartpicker.com>
Date: Wed, 9 Apr 2025 13:41:25 -0500
X-Gm-Features: ATxdqUEcrX6GZfQCoITIu2ZkpT7txe9QocQj96N3PWYO4yhIWM2F2GVGwgqGPrw
Message-ID: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
Subject: Performance variation in traditional HDDs?
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We recently benchmarked some identical HDDs (same part number,
purchase date, and firmware) with fio and were surprised by speed
differences between them. Intrigued, we bought a few more sets of
identical drives and benchmarked them. It makes sense that there would
be some variation - after all, these are rotating platters and
physical rotation speed may vary a bit.

All sets of identical drives showed some variation, with some showing
significantly more than others. Note that when the exact same drive is
rebenched, it generally shows the same results. So different instances
of the same drive really do perform differently.

For example, we benched 6 of the same 2TB 7200 RPM drive and did a
full drive write with fio. The slowest drive averaged 158MB/s over the
run. The fastest averaged 174MB/s. And the average of all drives was
169MB/s.

I was wondering if anyone had pointers/thoughts on what kind of
variation should be expected in performance with HDDs, or
articles/research about this behavior?

Thanks,
Nick
