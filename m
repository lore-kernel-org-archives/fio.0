Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E501D79D2
	for <fio@vger.kernel.org>; Mon, 30 Jun 2025 19:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751312526; cv=none; b=A+XN2cifpDO58Q9Xn87JLpHZm5Ld9pJMwNeAZaU4aFuqHUFrkS45hD8h/ZCK/cM5FVZN8wA8D3VuQ53Nas3SNaTdHTFlsd9tdXdyhdix3MWPxXm3bb7EN8AZHUpiUgfBidVr2ZJK1bzlTsAFAA4IKACKUnS3ZecmLUdbzO2HCcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751312526; c=relaxed/simple;
	bh=neI6yxGVpbmNcGfrl3WJPJyCa4Lxrpd2xn6fww8GTZs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=gUkKnZoCppz5JMZdCw3aetwgXH1apCTsxx/2TMiE9prBqSG934O7qQACdXGpBpJIFloQm0LEznk+BEuRcuj8FIISUhCRQkiDGjadl7ZpWFwdXeq+S6HkYZa1zAddIqz0HWxhy7MZvh1lXkrYBdCpYj4O6mUvVMSSKCGSLf/GpOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PqfODsDd; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqfODsDd"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4a76ea97cefso25120501cf.2
        for <fio@vger.kernel.org>; Mon, 30 Jun 2025 12:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751312523; x=1751917323; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NBYn8kEV+tKNLDvpDIMeg+6vHfTmSa8W7uQvfZna4s=;
        b=PqfODsDdUSEDAU6yTSbpFM7uiGhQIM+x6xYAqD/gtmjX2Lso5YCHMBZeQtd7cxPUo8
         SiAIzjuTnJHcMUwF9MvOANE816sVxTqEdSSbnwesTWBmxh+7x5zHn8YZWBxOvF84elkK
         uoKAIJY6oM02SvTvNG1u8kkAZhn2gcwW83eznpxmWMxDwf1EaAMpyOw0WaMcdPIc2Y7f
         3gmf2mzXaGd5/kErcJ+Bxhbp/WDrHKCWqieNa8wo7mDWJBllxqoc5zD3/IIM4g+7e5iI
         NTs3lO1dt3Qwdt4Gwof8Gpko8Tjibl77wrOkgZBOe4+XBS0o0anf9178EIWwo6A4owxM
         GgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751312523; x=1751917323;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2NBYn8kEV+tKNLDvpDIMeg+6vHfTmSa8W7uQvfZna4s=;
        b=Lt3qhLmJPjWE1CFKIyclRDyvRpJvfAZyftJJrMTc5ZdQA0BK2gIpg6btRC6nSXtcAH
         cXCk1aVbRSr1q+p7b5MlfhhbZbEdbZTnn+lRuuMVHnuWETTOU2R5Bx9AbrIvrVUSulGf
         t4XexoOC+4DcO9nSZWbWQ4WW7u1KA56MU2ROl+xaTyCaw8IbLDWNGaPX1OFua1Oxjr12
         ONs3feTUhsBj5Nmt9rrlDPeTFHMjwINwCx0Vz7c2wzv6ZnODSJePohdLpzZAKh6BWU25
         ODhicobjaSaYA0yY1rHaok7aIOEfEa0cFw6viWrZLIO3b/2h29flXyEGo2vAsvGn7ubn
         8Wmg==
X-Gm-Message-State: AOJu0YyVxi5TZQKpamRdts6zlUQ6xT1Jsfv1dPZBuW7oLmRjWkHIiUYU
	ThOfm2Qc3s3qhGVX7qy+sFwDAxjI8VzC8DvQaXKvzhCZtEK7syzaNgpJTL66CQ==
X-Gm-Gg: ASbGnct4NJmtku35rn6okljhFk3z3FIJ0R31vACucelRSUlmYzL5q1tkhjWcWBws3Le
	11eJKbB9lzdsnmdb+TVBj+lUVx8Cu5rcMwnQQmFPfeWD2Va1lwz3Qaq8kT/tRmBKaZgy38Z2rcC
	aSuMe8K3ApJdJE8LDvGCS+8jpiX6ub01EkM+4kk73KoExkkQbVYYulBzgSGWsly2/+j40ZuHVg6
	U/Yq4vHeA4uB1+bKLhrjDiQ0EwPYcNIteT2tTnmOkbsYEo5J39lkYWhTsKyRMP0EGNDNNMwwQqs
	+TfYtuFs7HZHeSk8N0CXcuJTGJ+eb+etlPp7l7EAWbQ7K7lcPUer84hF4zH6CQOrCD/PbO0y/RA
	7OYWlJovxH6jc8Z2x3hIyhDjH0OQZQSNbEBrHCyPqaDSe7g==
X-Google-Smtp-Source: AGHT+IF696gIoq9ZztP+gVJqd1InZmvHl2rbcsccQO4RPkgltv5KXMaAVJ719lCXMAUI/1afcsya3A==
X-Received: by 2002:ac8:58d2:0:b0:494:9fc0:de3 with SMTP id d75a77b69052e-4a7fcad0725mr258055811cf.32.1751312523220;
        Mon, 30 Jun 2025 12:42:03 -0700 (PDT)
Received: from [192.168.1.211] (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7fc10620dsm63994181cf.7.2025.06.30.12.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 12:42:02 -0700 (PDT)
Message-ID: <e17fc881-c699-4d72-8824-0eceb69a7d3a@gmail.com>
Date: Mon, 30 Jun 2025 15:42:01 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Fu <vincentfu@gmail.com>
Subject: blog post on fio's verify feature
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: gost.dev@samsung.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I am pleased to share a blog post about fio's verify feature.

https://github.com/vincentkfu/fio-blog/wiki/Verify-overview

Ankit Kumar and I contributed some verify-related patches a few months 
ago, and this blog post shares some of what is going on behind the 
scenes in a verify workload.

Feedback is welcome.

Vincent
