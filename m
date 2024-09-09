Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6DF18C31
	for <fio@vger.kernel.org>; Mon,  9 Sep 2024 19:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725911588; cv=none; b=JMImv7A1kBUOgwQlG+nHcaeK0TGFEDPptDlwID4ZvCzKc2DnxUe36tunKOOvY88atDTKLBYs9dBIvLbtDnnw0lqmVcozUalJIwf4v/Iidn1SGae02tVj9oQl0gPrTngi/9aRNkL8mxln92ayc9Bv7FT18CA8YS9WaAcgfnOls1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725911588; c=relaxed/simple;
	bh=/KMLs6je+AC1heEd30U+6xgFA60GmiTyN9o0Gcilqv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=puSPTd9Oy9+h3EIUkzHG04pcEOekOnllJvR/4QsDUCgDk8sNETzVb2Ewhiwqy4nrBlJFk7gpGEyyNVXBGMzYliHy1qXWq7jcoros6NJpCnS6KTw/L/CN5Z60ir+RQAbDGdgVb9yKp+huZfRV7mTnnJFAvgfnTne4fSwII2P5M6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R46/IBN6; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R46/IBN6"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7c6b4222fe3so3191937a12.3
        for <fio@vger.kernel.org>; Mon, 09 Sep 2024 12:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725911585; x=1726516385; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nxEF9ZqI+HdsJVsqS+Y8kb2XjjV2GA+WsC3SsuWiu84=;
        b=R46/IBN67Gov0yzv7fQ7/LCmvc0HdSgjuEyBvlUeXUT+bcbEisQR+wc7XcIhheLOsO
         1Y9s91OArMtPeNxXpqXcmTd7qfz+0ptcQrClOWbCE2jeiJ9lDeod3BwnXRVY2itGMofs
         JztSuR8cP4HpZRileC0XEsyrq8btyOPqfscmjQdgYCP9T9SnJI9vxGKFtZDhZOoICrV6
         jI+XQJtKlhZe8CfUlY4GBcpEzaFF4w/xPN2rRJN8VtXyI/3rt7Z8soHyOEhsorPAGzGA
         TmtendVajYvf27j81q05i0moS9VHMSWS5RpD6+Oj2kNf06mII9u42kvy8Vb9xJAkqBHr
         SFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725911585; x=1726516385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nxEF9ZqI+HdsJVsqS+Y8kb2XjjV2GA+WsC3SsuWiu84=;
        b=mMQe411Jpka9meHDoxhjlrLevNN54u/k3J0sM+VE/vwMdhKvZrJ9ZSo7kJv7q2K6vO
         yF7mgkjdrSRvKKDSx9+8HF2wgwUVh4szcNbNM5kE5ugC9jIlXvft5VoqFgEyJhacMKg9
         deaRZV9bpa9feI0elsy64jnHehyt27rWRgs9SedEK8aC/i14KVGAHM5kbRawTbG/40F/
         y010qJ10P/lGxZE6+cYtGTLVVZzoeXOmKDoyrmgzP2W2mo5jVpa0LHp4y7BI+AYJjtUV
         x9BaDZWGhiG96rr0vQ2khlzRF207orIKGLeK1mfOHLOny8l+ASqHYBqu6oVv4Z/i0TPg
         Tk6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWIDk6rUAHyeEjnGvXNZapEkcHX5boFbSM2inMLqxM09/2jH5i4FE3lFMkSHVaQ+TLzwko=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDuu31s27hTw027jvdrhMFWkWeNgV93RVb7OxJN0lERT4RCGGb
	iF0CEJLiG1sG/YZl2NwIiQnztomgZsY5/PQtUHX7QwB/rs3pP9qzV/ObyJvKCYk=
X-Google-Smtp-Source: AGHT+IGCNJSRVyE5mZXjMhjiMJkg/lGnt6iDjTH57KgzQs9WfAUGR8c3O7xMV2X94gEW0F69S6eZ0A==
X-Received: by 2002:a05:6a20:c90d:b0:1c2:a722:92b2 with SMTP id adf61e73a8af0-1cf1d1e3754mr16250596637.45.1725911585017;
        Mon, 09 Sep 2024 12:53:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fc8253sm108060b3a.37.2024.09.09.12.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 12:53:04 -0700 (PDT)
Message-ID: <5b1ac00d-a67f-4a5a-8018-a183903ffdc0@kernel.dk>
Date: Mon, 9 Sep 2024 13:53:03 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: John Garry <john.g.garry@oracle.com>, fio@vger.kernel.org
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

John,

Maybe it wasn't clear, but I committed that change I mentioned in my
initial reply basically right after. If you could send a v2 on top of
the current tree, that'd be great.

-- 
Jens Axboe
