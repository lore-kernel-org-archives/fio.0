Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A17F1CDFD5
	for <fio@vger.kernel.org>; Sat, 27 Dec 2025 09:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766826774; cv=none; b=PJ6ApwO4DcDLHOx4/+ZupPLVMaQXbTjCPc75z2b6I6EOIgpUemdHnBPfqgIOJLQHOijXSmCAZDh0kYY/PptZPRe5iZ+L+O5bijlwwGcxLLbrlLKVVwvp7w7Y6cgPep7D3P9U9SGwmLNzAcqZlKa9yTHaRSTbwoTL0jCcoCfTNjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766826774; c=relaxed/simple;
	bh=KoWWAsZUADUauoh3bG38g6U3LXrvE8qDEX8qsstJaMI=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=c+CsFkvVwKoGRWZfEyHRhb3iGF0Fm3rEOZlSwxRmcOrK7KeEYznkuA7HzIBvbjbG3/LOAy2df9I/mnR9RiPqxPepa/U5OVTS60grSCZlys48BKcO9aYYTuF08bgyRQeuD+zdGJt0WvNR0VTGM8OVIQhkn9bQL1GDxnDkFSWT6wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lhmzefuJ; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lhmzefuJ"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-121b251438eso95324c88.0
        for <fio@vger.kernel.org>; Sat, 27 Dec 2025 01:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766826772; x=1767431572; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KoWWAsZUADUauoh3bG38g6U3LXrvE8qDEX8qsstJaMI=;
        b=lhmzefuJToeC+cOrm0ELrZGEoS6i4pDeBoEUtqstvBukN34VFaFVxmJ4LrHGMt1bML
         Snb5f70bpQC164cuGOxN0fvQMakUONcGQ4gxKSqIdR/ERn+fSZLy8G9qxVACtHQ/eU2H
         fTa4/CgoE0w4I7vYpqPkinM4pUytQlmEB6aiIFKwA4xTUGzp5UK8PR9KWGYkwzD3jKd3
         VyyXmxTGSdak4GucrnvqF0rAxrYYrVWKCrdhUNFvIBJjrDSa4MaazlhRgzAb7GeUydT7
         sMM6T8GryKXExhqQo7PyxIxu3Jh1VmdC+KliC2WFQl03Q8gM66fdG/ow+rokju25qZqB
         enyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766826772; x=1767431572;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KoWWAsZUADUauoh3bG38g6U3LXrvE8qDEX8qsstJaMI=;
        b=j4ZXcdOj9fgkU1kFPdtbBAvX4xra4HaJCGi2FcQPvMjF4w4TcRJE3BxLDYDq3r17QJ
         qzTe8QwUQ3T8J5IxcmfHBX4NI1B3UdHRSpGlLiH3eNKTZNFV8qfeVkp+6zVwpAoHnLbu
         ZLS9J0LEq/FiB7asTcKzdkVfFBefcD9srp4xpzRzTHauS388/h1sqoTp5HxtZGNzq8H+
         9i961bg8qG11U9fXGOfNcajntEOQAXCW0GLL8ketug9sl11ImgS4H4oN1V2PGXG/Q8Y1
         D9SsFmHzWIGhmwT7+xmo69mMG7RuLSGDR8s2hqLQdeQU7mHzS0V3/+kNtyFKsgJWOVrG
         6bxA==
X-Gm-Message-State: AOJu0Yw66xmZgAtQ5Z1zmTvYM/oXdMS7wLlk6s559OurYFRSLo9uUL91
	IkRIkQ8eiYNpIMjfvM5IuIwul/462FlcqTIg7G3bUdNniXKcS8NmN2Qd6kIo
X-Gm-Gg: AY/fxX50Z2G4Wa8qYOGPg3qaNCIcU2bPHoUNxruQrlVdnsmrJ1xvxbuAZOOxKOb/kSA
	d6xw/18nh4xz4BCewU6Awog1hPKhB0Se6HaRvfphW0auwA3VU/ojS41RfbWmy5wUSvPaHkMZNvf
	fn82Iv7/v+LUU7LzLy+gFnRk6H/YmVhRY+IwS8WUqbFHqQ+jfc/zKKbUjrxKjqaNEMFah4zDfuf
	uzxz8bOAcDe2UnVvrgaobdDW0uKuPNwIHxattJ5b85T2D9EPuCpNHppoMybWJMhhh/Dbie1pzdV
	8LRqYQaqxkLedXgnfZStLkEiGUJFFXe0kt703IOgaH2Xh6yJhV4+O3a7OEx4Ur2IOEqCgPxpCVu
	uvxqs55BZ7QNDtOc7ytVfR/M4lGNuo4x8fX5TnYbkYWl2ni5LkoRBsKg/Z3WpnGRl9L3KjFPgSk
	4MnvCniDzx1I8z9I8rD/o4aLIG+XAx8AlYp55bIBc0zbDYCzwrk2dpcxXm2E4Rv1NFtFHQhlhIe
	iJvX446wGs=
X-Google-Smtp-Source: AGHT+IHvjkOzIlwxAqxbKEJSEJ9OpNxIFrMQyPTtggBWjYQdWKmtXIJMVWuUpEFZYqrURKzSUqQosQ==
X-Received: by 2002:a05:7022:f406:b0:11b:c86b:3870 with SMTP id a92af1059eb24-12171a687a0mr21725070c88.4.1766826771733;
        Sat, 27 Dec 2025 01:12:51 -0800 (PST)
Received: from runnervmh13bl.da3kbe4elcuundlem0cemmerod.dx.internal.cloudapp.net ([172.184.210.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254cd77sm97302657c88.14.2025.12.27.01.12.51
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Dec 2025 01:12:51 -0800 (PST)
Date: Sat, 27 Dec 2025 01:12:51 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============0276170053682091291=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_Introduce_the_end=5Fsyncfs_option?=
In-Reply-To: <20251227082511.863845-1-dlemoal@kernel.org>
References: <20251227082511.863845-1-dlemoal@kernel.org>
Message-ID: <176682677076.2874.4260507702427882288@runnervmh13bl.da3kbe4elcuundlem0cemmerod.dx.internal.cloudapp.net>

--===============0276170053682091291==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/20536821129

--===============0276170053682091291==--
