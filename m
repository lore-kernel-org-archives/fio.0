Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3AD770FE
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725991312; cv=none; b=kA8GZAYmrdwPV8UrwulW6fsPbwYtka7XsuNnyzPOy/pAbVsnusOdP8DR4jTmrCsDYb0irFA/gZrjvIXniNBGq0fBWG0kEMTR5+NDzISBQTJ3uPbUOAcSj2skTduSRWoxkO5PJa9mAt7p6HnZa8JTj5RSVfDjuLlM4+P3T8tb6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725991312; c=relaxed/simple;
	bh=YMMurFwFbeHYqi1IRSWb9STJpawvN5VSmYb7Kz/m0ik=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=gNEKhAMFjU/X8NM7d3m+Et2A0EckczQ8L5zdVFN9lm/j3FHPKzO89f3mNj2CR/IKJGh1PJCceLs15JBxi86rZcap89MH83dgRfPaJT08sIB1QnPwYqQrYta3CjAjk5OH0PAbYjqNtq1UkJtQW3xZYNboafIhAYStFVCwzQNikkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J8MvwhJt; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J8MvwhJt"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3dd16257b7bso2317050b6e.1
        for <fio@vger.kernel.org>; Tue, 10 Sep 2024 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725991310; x=1726596110; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YMMurFwFbeHYqi1IRSWb9STJpawvN5VSmYb7Kz/m0ik=;
        b=J8MvwhJtW2KB5Yf7+U97KPUlbjr6V03Pcl4wc0eNwxfHQc7+HxXlCywcK0k8DjzTLp
         LprvZo3MzlSb4YaXdnxQhX0h2b9Fr6RB9+KHyVNGoRENA6Vlz39G+05IIMfY8sAl1Vho
         Y3/8Y1DPnDTkdQ9lKR9n058j0PEGOFoFuUK2tQU18HJtg4tVfDZQW/LiEe0obFWXP+fw
         Z53mmi0V+lIfFf1tg6kIDvp3pmhnIbplOO9uAQ1CdBgTYrijPmaMW4rorep5J06Qdjps
         zcVkFfFexbISC7Led2yKc9rZLtC+hpC3SCCulhTOttp9QA9JqTfoNRLKx73OUQ1RnepJ
         dRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725991310; x=1726596110;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YMMurFwFbeHYqi1IRSWb9STJpawvN5VSmYb7Kz/m0ik=;
        b=jSA+przkxVCyxaC5IvxHDsEFx2Ffkoq2iyjMaF1MdxABWAR3bLiABMrsdGsAmOAhqU
         f9XaAk5Q4qN6vU/SHVxRNOwxR/C8MwUylxC76gOfnhqJ+APJ2SZ5j9DhNbX9A1eO6db9
         STdfZMMR1XCJB1C7v1fGhELl3VN5vyiz+2aQQFWfFtK3LYZfwQxYH6QGx+hhgqmMAGMt
         ENn1HgMG0yNiQY63nrnS4IG5dwBa56JeWn/IC8xq0RncR4J5w+Gd1h7LYJFDxw8JUlkc
         Sa1NwU4H+OY7FLiV6tvkYg/ha/ZWT1rhSgjHExRhSz92Fa7bcwTC0Iwfo4Q0P5y1QxQw
         +FHQ==
X-Gm-Message-State: AOJu0YyfJnqrYbWDSMqzW3ZtZ9ymyC1bEM1MAlTUKQKGiV2juTL7+qaS
	slWF2DZx2W2UhvWh8aVqGbxyGA5HPqtm4bfKYlTdCE+IRYTSJyqcBs+aMt8U+sPPN6ccuhy9Uck
	CbwxczSoa8gCXP8QInKQz+7BBCIDHif6I
X-Google-Smtp-Source: AGHT+IH4fL2Y50+pJr7wCwqjzod5eVciknMWiWQltL8Tu7Y3bd/VQgmnc63fobFp08e8fquGTW94hpOFy/HqklHqFfo=
X-Received: by 2002:a05:6808:1407:b0:3e0:4dbc:34f7 with SMTP id
 5614622812f47-3e04dbc373amr3606562b6e.21.1725991309761; Tue, 10 Sep 2024
 11:01:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anatoly Belanovsky <abelanovsky@gmail.com>
Date: Tue, 10 Sep 2024 21:01:39 +0300
Message-ID: <CALeYq=AP_h293ZrkixjFLxXzYpB3nm1YgAyZxYCMHW=ByvxBWg@mail.gmail.com>
Subject: how to fully load RAM while stressing SSD using fio
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to stress my SSD and RAM with fio and I use command

fio --direct=1 --rw=randrw --rwmixread=90 --rwmixwrite=10 --bs=4k
--ioengine=libaio --iodepth=256 --numjobs=2 --time_based
--group_reporting --eta-newline=1 --runtime 12h --name=job1
--new_group --filename=/dev/nvme0n1

I noticed that while I am stressing it with fio the power consumption
of RAM is much less than if I use other stress utilities like intel
ptat or y-cruncher.

How I can run fio to use full power capacity of RAM? I tried to
increase numjobs but it didn't help.

Best Regards, Anatoly
