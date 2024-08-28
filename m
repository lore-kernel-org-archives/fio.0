Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699CE158DB9
	for <fio@vger.kernel.org>; Wed, 28 Aug 2024 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864554; cv=none; b=uqgZJil2XsHoXnlCML5O426gNaFX1HcSMd8hBDXx08at9sQ1cD67oiqPVcIKlrMtQhp2sMRrAuu49ck2w2CJcSdDX5e84nTmMGAoCS6/8/FaDEexw0CNBNLvpB2KXRte8AqJvO7fgMMq93cuOqhlGMveyDWYOqTRHjbTLH05xGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864554; c=relaxed/simple;
	bh=vqmbdr017WtHHXcsKB5PHZJLqkBVw7v4wfQ4zGvd0K0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJ3xP8f2O1OZ6+i43YKQ4TO/CKnUTS1pZxCHPymri4ICJr+cTQJNRrS3vDGTam5N0xjSsSZLs8taTTmfKA3Suvt/ezsGxfhvecRE1UxoS1FD3ExpeAA/IoA192K6tVj6YVhgqg3XX4VPRG7GWt1M+LztehUYbsYktoKJ6T1BZ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jU1QEMKJ; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jU1QEMKJ"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-39d22965434so2495805ab.0
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 10:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724864550; x=1725469350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SM7Vzlay15tZJzKGFA/XifQP/q1ZNXLhhQwuDFn1vg8=;
        b=jU1QEMKJAJY2vUhNtiScATvjAqnKlIcytgOV7Eo9wKNUQQGEcTUI8gxNrbV4G9EWJq
         WV08gUk7861BcGlEZIIpkEC0/64hDZmOJa+bFc5Te4TicbKLuA8DP+GiT2MhEAhSWDCe
         sxfSiUtVjXq2pC6EBlBW5K6xYVKeq+37/PtEsxz5Eh8jrdEn9do0+p38YDEPES8t2FrX
         QUEkYmv9+P9AESA2omB+kr1Wy7kzow/HD4plX9NLbjIrINmSrdmAL4f8ZO1DAsdRcY9N
         Is7+tI9PwA3p7ln8cgMn2+31DlZAJ2B7RaEGSXjjzMH0rpXoCHa9iA2hIFylOqsLOj5q
         l2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724864550; x=1725469350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SM7Vzlay15tZJzKGFA/XifQP/q1ZNXLhhQwuDFn1vg8=;
        b=H/wP8iGfVBpKp+a4Po0dpfbUhFhcJRFfk12oy7WI0M5HaRL85R8H7l6JlHFFgvAj9d
         tle1yS29gsCLZ+lxEzSD96fucQmd71oxZTn2Jy2oLWlFmmfw9wiZi3gOPg2xpXM7xWGR
         cX05zPUC3VQ+PqnG9O4LZrHHloHuWQx50WlnPkmd6nno4VIk6GJsnLdjNfTQO9zZvrIl
         aMhSKT0LphVNyTozmJ8iLrwK9gM7993IpOmeVI43IIV2xBdbT63rCtflY8YRvvscnjNr
         BbHVjYlsuCVx3kHe9KJdVGECQ7LIjuTfvSJ7IDLakYosp35ZzHKSQ7Z7T+6sGGhZhyJW
         LBdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmpQaNH3qo2kB6rL/NGW96jjBqlmeyaEAz6c89ZzUpLIAgz7FqFYbqVKJCAKbEukGx7h0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMAqc/c8Uj2vJZ8OWo8Fqb09BCi339D1hK9FzKmToOrB93a3iy
	+WnQJVcKT1qFkagzONTJs18/0a45Au1QCxTQ1vdo3EgpyOaWD98hFAjSwWIAIp4=
X-Google-Smtp-Source: AGHT+IEgBGxxLEcEnvCfiTduUS9fJtTJHKXWCerGI1raYtOQ+olrM/seidX+Prtc2EDTO89sQVJDvg==
X-Received: by 2002:a05:6e02:1d88:b0:39d:24af:b004 with SMTP id e9e14a558f8ab-39f37b1f72dmr1580285ab.8.1724864550416;
        Wed, 28 Aug 2024 10:02:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39f376eb88csm688035ab.7.2024.08.28.10.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 10:02:30 -0700 (PDT)
Message-ID: <b6c35fb6-5306-4b4c-8fdd-1357af057315@kernel.dk>
Date: Wed, 28 Aug 2024 11:02:29 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] introduce the log_issue_time option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This one needs a FIO_SERVER_VER increment.

-- 
Jens Axboe

