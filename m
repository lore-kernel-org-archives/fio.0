Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4DE27A907
	for <fio@vger.kernel.org>; Fri, 26 Sep 2025 19:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758914970; cv=none; b=pd8ISLYYja+FrldXk04w2+uZRZz+oi7wiGlxRarhJ9tW2RBkG9anICbNIO84kywrAiNJHx9JrpKeTtBHFWcdSQ8NQjGRP0Q6yqv9YFj1WLIIqdAeKkMMBOOtsMd+zlNXlJ5bWrgyH8RI92LoFEGllUi45JSW/lUbtoewP2/swkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758914970; c=relaxed/simple;
	bh=EFAWc70KvrS5pkL/1SHAz119oAcbyfwSeQkRPWi1mtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=jI8UP4iTbKBN1uESZc0Xsjun2uYluNrDDArHEwmBsOntICbv4JPMVZGOScJilRre2t4dH2zBxDa1RinABG5FC1v69F2sD0EO+pRjd/Rn4OUlYoQwBqrzhwj8PMZHOFTj6ce7Hg9VV3F535zP7P1+EJjKhBijJ22xrSc7ptWAquA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nF2B2UeR; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nF2B2UeR"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b2e168f0a75so434414466b.0
        for <fio@vger.kernel.org>; Fri, 26 Sep 2025 12:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758914967; x=1759519767; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFAWc70KvrS5pkL/1SHAz119oAcbyfwSeQkRPWi1mtA=;
        b=nF2B2UeRg4rZv+3XHHggtJJqzJxSlY/S80s2fAWT7VfKtNe0sjS645KQ1VGSP6O+3E
         7AUWcy9Nj8/F618e+ClQqmai4Adkn/+cZUHSmt6jxxB505Ytv12jwJR1pSUZQrn6Z6ji
         rB64EVH7G2Wl3WnaA0/KS8TNtKxKJnnb6Q7sWVCf3owTyu0dMCCSnqnHjdifw9fK43IL
         JuaS0iJsoN+LNOPiHZEyMQf1aCCTDgRKztPiYtWt5EBfYaX+CTheebKEpyfTnzkv+SWy
         uclwG9D7NskdiyUzOi2xuXQdxyiZNPHVHZrshjXAQQxBXXHEZNp28RRzo+oDXQL6khVw
         C7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758914967; x=1759519767;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFAWc70KvrS5pkL/1SHAz119oAcbyfwSeQkRPWi1mtA=;
        b=InZZX/yFvNCdCI8Hi5b5ZnEzrWnFSQqXQcEb/XLeDJPHAlS7fRIBxHbmmKwQtwOVqs
         es73eATx5fgakdmnDSEHf9bJIO0qJaBG415Am6nK9+y4hhXNPSaZahOsEWIqt6GnINw+
         /4kbdKY3GXOI6hBr+5ZOE9t4yAjChP63HIdfw4X6xmd6OAHk1Ml9bnvc6XO+jzHUrVD0
         HssLDkLPLbwd/tIg8KguqYsoOgh+cqqZOIjoTVtF/11wru3n0EeMiO2yKSi93Yw49Pkw
         DSegSYpA5p8//jGhWBjfr8qRMJGDLliYtsom4qXbFwYZRAMx23r3P/tkdEyl39aUPD98
         8L/A==
X-Gm-Message-State: AOJu0YwhjpCHTMdWm5p+MkLz4ToTq4GcvXBSHztXJ/PCKw6LG8L3ktVn
	pEezaAynZuFZT88cCT+dRql7uHjI0klS2NxsX1ILGr6VWbFQ4/XEQcK4kyMhId957YH6pm8MLDK
	UMSHJzhGteOBCxzpG7bW5UmEoDEZkPfndnQ==
X-Gm-Gg: ASbGnctng3uNRnFgtV5/T77ge06WjvpdFpXnGtDGD46pZ1gs+tPShweqOUQhuy7gHj2
	5NVtfVUx8fmKGW8GZ/JOYjG1jhQUS8tiIS3xrjRJNzENzrFFuVFwypcxlYdLDUFiaRYevR4wrqx
	Vbrei9RmCKlwi8FsMt0FKlQB3fPUqLdCECHmCtDOJklDIpmckjxVaMgWDa1cxs6HNjeYsdhJmgI
	ir/U8zeqFDY8VsD2lxb85QV/gxGYfYyRcb5HQ8=
X-Google-Smtp-Source: AGHT+IFpCzucZKgiJJ26K65HoCqQNafNyPWforKiyXMRbN6uhTGEnBff9ax8oOGHQInwXbkCk2WS/k6ABiHrLHetgGA=
X-Received: by 2002:a17:907:7f0f:b0:b04:25e6:2ddc with SMTP id
 a640c23a62f3a-b34b635567bmr854785166b.8.1758914967020; Fri, 26 Sep 2025
 12:29:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAERsGfiZ9YVeXMGk=dL+orN3o2HXJ0Oy9EQhVwK43MMDUSA-WQ@mail.gmail.com>
In-Reply-To: <CAERsGfiZ9YVeXMGk=dL+orN3o2HXJ0Oy9EQhVwK43MMDUSA-WQ@mail.gmail.com>
From: Shivashekar Murali Shankar <ssdtshiva@gmail.com>
Date: Fri, 26 Sep 2025 12:29:14 -0700
X-Gm-Features: AS18NWBrRKANzbzil6ZEspMCl_PzOkwL_w4a1yc4PmbJSaEUhAfNXsJrq-CwpBw
Message-ID: <CAERsGfgCA7iFwLQ2L+=QyEg0=KuwK4hq62QcYpnY5R4h9abZMg@mail.gmail.com>
Subject: Fwd: fio: ruh info failed
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I am currently testing fio with io_uring on an FDP-capable drive, but
I see failures such as =E2=80=9Cfio: ruh info failed=E2=80=9D when trying t=
o run FDP
job files. This is run on an XFS file system on a mounted drive. Do we
have support for this?

Below is my fio job file:

[global]
ioengine=3Dio_uring
direct=3D1
bs=3D4k
iodepth=3D32
rw=3Dwrite
numjobs=3D1
group_reporting
fdp=3D1

[largedata]
filename=3D/mnt/nvme/largedata
size=3D30G
fdp_pli=3D1

--=20
Thanks and Regards,
Shivashekar Murali Shankar,
