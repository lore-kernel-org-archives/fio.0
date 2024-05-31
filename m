Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E91946F
	for <fio@vger.kernel.org>; Fri, 31 May 2024 20:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186047; cv=none; b=X/5TZYHZud2TyUeLHbrkZ1AEgTh3BMa+Ye597o+AAOU9borR0DM6+gVp14PTQrr5EaenzanEtgwSuEqLk/56tQhldRZXy+EssyNyec55BTvS0DZRjNhRP8G0mTYzNWTZNKcm3GWnqiIWWmSEbluXjD68PJs5azuwHTh7xOqHYdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186047; c=relaxed/simple;
	bh=iEsxK/s5YrFr2w712ZEg6xaavZSyPUbf7esQ7wP0Q34=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=TDaKUouuMstuo7VJ42dN09ty0Kh/jQf51syKy3UUZ3cSTwhw3H3di0YfOTDQVzgjIAfY6zxMx1oORNH5S/kYf1d/qzBgamIVFBQ4LAYqJ5r0mizvWJrxfC4E2PisLUJ6q92skCDvHt2gM7MEqtojQbE404bOhKp6nzg2IVm4vbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CYdCmkgu; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CYdCmkgu"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-43feec1a475so10333351cf.2
        for <fio@vger.kernel.org>; Fri, 31 May 2024 13:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717186044; x=1717790844; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJJsEs+F8GqK7/QU6RIbmBYToYyT9X0VMyxDaguZLKU=;
        b=CYdCmkgu95bB8t0206AMNag0JFE9IqAlohE2Qkea3UGhMDJHvv04cwn3/qcdi+mgL6
         2n21vqQ2nUBDpFlb6eebWnqf2j36zXa5A1emAfbUF7/30DXho+ryguoFgNbhqwbmDHx8
         6aN2IDyP0MJ6KjKD0sit99QwSK+kqe/FOqaJYx4kW7l33vPBLUopiKuXj2u7CmNn4qDo
         DNha9Ywt74e2CGQzrA25IPpWTj57JHzm5+KXkYYoXi9hZEOFYCfCKNNU5z9/7/7KxOnv
         kog4HsBfP973PdAVYtKbije+y9A7SXFt7qVHsqzGaZhOhFB+ZQPIySXqcYnfCrnOO94L
         /Y0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717186044; x=1717790844;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DJJsEs+F8GqK7/QU6RIbmBYToYyT9X0VMyxDaguZLKU=;
        b=xSXcFWrnHlcuL0ndHyzQkHplx34C2q6dQ3fWezquCCX/7uRMbmj/rtV9SuBE1gT8hG
         JeWFhfjT1KqV6M64UCE1vcRBBMQ2a849GiAhwTeyDQ6PXBcPv0C/e0UabR4C+AFjZAKw
         1nxLo9ygVMwyEMt8ffs+/mMj2HJSWEhMnJmLfqWjPMfonSoJ15+RKty8kAxmZcYTZRhJ
         NmLYsr4oRYZuTWz7+OWvziDzhieMiKgyu3sVWrg44rNFMvC82FHurKiU4t+RmjQDu+Sp
         gcJ76xrR4mIpKhUK3eYQ37GrWAEMw/2SKqSB+iQDujEaVHsLFTWw9k1cnhC2UQLH5lzP
         z3IA==
X-Gm-Message-State: AOJu0YxNeZUa3Wuk+ucc7KCETY0oSKfDda19fs85hcwBu7AADWJi8yTA
	h1B0esUgS4inow+FGMV2zgMmR/Zg0uD8jx8XvCLmX70vMG8eOmB+s9C4ow==
X-Google-Smtp-Source: AGHT+IHQcrJ+RTwcRUozNg5XytgGPQu1jMhfaJwTg/WCaAoLpqrHCBZmVsITJ7ksvwUYmVblfQls7w==
X-Received: by 2002:ac8:5883:0:b0:43a:c483:9fc3 with SMTP id d75a77b69052e-43ff524c0fdmr32394991cf.26.1717186044298;
        Fri, 31 May 2024 13:07:24 -0700 (PDT)
Received: from [192.168.1.206] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43ff23c2240sm11309291cf.31.2024.05.31.13.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 13:07:23 -0700 (PDT)
Message-ID: <d7707a8d-fb44-404b-a2d9-3b196f147bf2@gmail.com>
Date: Fri, 31 May 2024 16:07:22 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: gost.dev@samsung.com
From: Vincent Fu <vincentfu@gmail.com>
Subject: FDP blog post
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I am pleased to share a blog post on FDP co-authored by Arun George, 
Ankit Kumar, and me:

https://github.com/vincentkfu/fio-blog/wiki/FDP

We provide a brief introduction to FDP and then walk through an example 
exercising fio's FDP support.

Take a look! Feedback is welcome.

Vincent
