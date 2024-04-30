Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7179A537E4
	for <fio@vger.kernel.org>; Tue, 30 Apr 2024 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714498515; cv=none; b=BQS1E+OtcR+yUzREl+RiE0aA+0nXFOvpanuZhKCN/W0HeRZRccrw2GxOru9u7u8LBn1cO8tT8VDBRK51x2/AkDYuHb30AySTrMVaQ4v9di/RuAb+pnsw3m3+WnXZWFvYemLGd5Tl4XgjkMhOL45b7GAqfKPUfpE6lrAmwelPTTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714498515; c=relaxed/simple;
	bh=gUeOJHcYUZIeQD22FuPA7UaY3ot9AXKexYh2MoCcTLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rd5mE0Cr7b3CvjyXdvk47yPrJr9xBrwGby4cNDRMnsNqSn+bA04dLqvpruaLE+dczn5cVp4AxRILhOd60OHa4y7kwEDzGeps23aawWbJqWkNYXiZX+dCmijL8VO1b6/1ewrrq0T2X9iyaAeAk2Dix+x3mw0vilDNlxnezonhntU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dr+u2Xpd; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dr+u2Xpd"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-78ef9ce897bso419769985a.0
        for <fio@vger.kernel.org>; Tue, 30 Apr 2024 10:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714498513; x=1715103313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fwWI0wI7NCMBXRg6gzAwcceDZ0QsAFzzD0BxScCbVpE=;
        b=Dr+u2XpdD8qSn+2dVcG8Mq9olc8ZkGQwuIuYJVHTtcavDaClDaxZ+YdOiqycc5OzTD
         Gj5nhukES9Kh27YDfYEPxSJ3kf+m0pjLi7HBNY5/34hcUdmAwAAkis34vo6JFRWOBJfM
         dOw+kzL5HW99k+akeQ2eUrYy8rb9uXLU01YQIFEqSKMy5nW2wmrLwP6yE9DArK3wmpaC
         iEpJfMgQrkBd/virmu/zldwlAfx+/lCAu9H0Bb7wzGw7Gj0Tc5tpt+2Ydt0GaqqeYo4S
         9RwkBRtrNawIWqb0FhtrCk32gw7YAOOHN1JzueLzMAw8uEM4x5zGSHvLwJk9agEFy4K2
         TJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714498513; x=1715103313;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fwWI0wI7NCMBXRg6gzAwcceDZ0QsAFzzD0BxScCbVpE=;
        b=uHLCXR1hyqIqdNnJDQLXYastti5NKJdiUzbH9+RIoDgq+bDMhi6AAwKuY8wv7ut7xe
         q+L+48IzZFkLJzYpPUjfkfEr9E5BGEzWHawJ4vuOVSdQVfQH72z/eMJnL4x01KcL3NzF
         /vDtU7yyKi9PIgZspX6c65n9CUFl/aD1znosOGkS0yu1c09X51AlU6LR8/wuoD6AxbEp
         9EiBZ/st5NqfjBmrxN9v0NPiyRb62F7KdyhxBOrEP8nztpM+tBQDDtihqTqa3s8QuMLk
         KfUwQu8CfzQXzZifjFlh3/Nh3xaOmUY8LHwLlwJMWIwyWE+w/aKOG+2QhHL0JUT2m/qK
         oFMg==
X-Forwarded-Encrypted: i=1; AJvYcCXFFxbgoUHj7saB9rpfUuoqhLVuow3ydJySjUhwqk3DWLGuwYjKavBlQM3swoRYlTwK0ZjdNKyyyqTIuwF4+J7o1d6F
X-Gm-Message-State: AOJu0YyB5/xWVfzhFk4VY5etP8pAP/5IS7EECxcHUjvnlGkx4X6o90XW
	4NF606CcX82Abgl4OBUWMKJmyFwlkQ183kR1LN6XNcPnqvn/IJL1
X-Google-Smtp-Source: AGHT+IEFIugTkh5g3bJAdbzEXNxNZpjvlgU5Ui5LsMkeA/8X88+a4n3RoAX4BpO6yWJTC+ZlP5Rqrw==
X-Received: by 2002:a05:6214:250f:b0:6a0:cd1b:9f9f with SMTP id gf15-20020a056214250f00b006a0cd1b9f9fmr38318qvb.38.1714498513106;
        Tue, 30 Apr 2024 10:35:13 -0700 (PDT)
Received: from [192.168.1.206] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id n11-20020a056214008b00b006a0d0c6ed22sm781321qvr.98.2024.04.30.10.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 10:35:12 -0700 (PDT)
Message-ID: <114ae848-2cbc-40ba-8034-6a481604e38b@gmail.com>
Date: Tue, 30 Apr 2024 13:35:12 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] zbd: fix two zonemode zbd problems
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
 Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
References: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 06:30, Shin'ichiro Kawasaki wrote:
> Recently, two problems were found regarding fio zonemode=zbd option. The first
> problem is the unexpected zone resets and the verify failures when
> verify_backlog option is specified. The second is the unexpected failure of test
> case 31 in t/zbd/test-zbd-support.
> 
> The first two patches address the first problem, and the last patch addresses
> the second, respectively.
> 
> Shin'ichiro Kawasaki (3):
>    zbd: remove unnecessary verify_backlog check in zbd_file_reset()
>    t/zbd: add test case to confirm verify_backlog=1 options
>    t/zbd: avoid test case 31 failure with small devices
> 
>   t/zbd/test-zbd-support | 19 +++++++++++++++++--
>   zbd.c                  |  3 ---
>   2 files changed, 17 insertions(+), 5 deletions(-)
> 

Applied. Thanks.
