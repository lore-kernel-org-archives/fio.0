Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FA213698F
	for <fio@vger.kernel.org>; Mon, 20 May 2024 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716212058; cv=none; b=ean2BzKHJQ4Po2CL8apBoq4+9A/IhBvw4vXwfOrGvJWg1Avm8FuILuv6sU8otJ6RDdTW6ggmIH7H8pMv+X1pQeyZrQAN4m5DQzeNCuO74T6iimo5vCF+o8bWdV5w362UkOal13DP4zj/YW6dqQl33FB9kjfdkTzLrw6GAtqoXTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716212058; c=relaxed/simple;
	bh=DHjEjqoZsKFXCPreIodiEGRBsX81+/W0C42hQxn5i2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S17Ee1IgaKzftNwp/jxfWFd8kinmwilxqTDbr4+e9XF117t0Xf0hglqwhcAVPoQ3XuRhT4bcWHBl+Y0pzYvx6pUAH9o2K3HB3yXH6fVpEuIOCdgyDiB28y3b/JUcY7AZNtVGWU7q5qUP3a1NQwQQ0/HPFXvKkGsnN4g2qZgGqfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9gOeqp8; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9gOeqp8"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2450441dd16so1488674fac.2
        for <fio@vger.kernel.org>; Mon, 20 May 2024 06:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716212056; x=1716816856; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mZ1iR2FoUIU+pnyIXZK7yX32/LavskKFl+E4s/gI5Q0=;
        b=O9gOeqp8rx3/NqhNqFthHA0F5NCUFnH3QSJJL7/7bpj26U9/1VsgyXh0V9LoS0NC2f
         38zEhJldTq11MYYJCJH0/HT96j8icHV5mtkW2rTm5xNp4re5xVnshD0Vs2ckoEEzQjsc
         UfxEWRiQapiMyj4dlFutC8g59pmKtG4p0k/tSNwQlGCIrzECxOdpNaWM8Trh1IaGpHq+
         Han2xtWDnsfU1tl8Pjq0WIgbzGhgh8yW/hzgWmZc1KbUFuNsq0ZjYfJU5iII3zeXnkBO
         w1DdEYhwGimQSKWx9fqp4Lizs0R6jmS+VjS88uqNyDf9LIcT7KkfYc3HL5aVHuEJ90AQ
         1HCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716212056; x=1716816856;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZ1iR2FoUIU+pnyIXZK7yX32/LavskKFl+E4s/gI5Q0=;
        b=Dn8DMGGkwsTQCtIJtiNyJ0FIOUGPdrdNlK1Ogj5ZJBuWt0DGsolLhJBcjt4abMAjfV
         k3yMB/j3qfTzZijzu6Qj8NCHXrlMZE18eLFb503foOTYgpdD4dn7pUDlRs/Py9iT7nn3
         W6++MDLF5oK+absIy07XqTJX6vGVJ8vO9oJtHvUwPQA45AsfFnPW0ji1IOp8XXmCNfCs
         nWbhqwo/bUFqlpjg4/rcPxmb0qhd+kHBBuhvVOgDwdziE6yZ5g7fgHjf3QE7B2LVW38N
         dOXqY50kwysP78HL/tZI+epmKluuqbGNWc+/dD3sPmlermWHTRh91O7j4M5/xI7dezAI
         Nt3A==
X-Forwarded-Encrypted: i=1; AJvYcCUulYe69FpMk2alX649hRObx2aPJQvjzA9eO4VVetqxZVLyddlMfJTclozXwAvq9w13CwLWLa7hnUsrdEUZTQx6GrK1
X-Gm-Message-State: AOJu0YyAlRK/cfcdnzFB31Zbd9ID/ChgMDLdsSv96IeRRcwPmRKFoSY6
	0+iMRSlq3FYQ+vYaNOEEADs3Sw4yhNM2s93WMYAdKbqFTEcD3EeWYdULzg==
X-Google-Smtp-Source: AGHT+IEm1pfJt2F1A/fogIaZcsw3NsNquNd8K7OWm3QWTEniqaqyi6LI4THkijTgqTWUiiWdTSYzfQ==
X-Received: by 2002:a05:6870:b6a7:b0:23e:6d9a:8f45 with SMTP id 586e51a60fabf-24172f79503mr33033740fac.48.1716212056378;
        Mon, 20 May 2024 06:34:16 -0700 (PDT)
Received: from [192.168.1.206] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf27fa04sm1181847985a.41.2024.05.20.06.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 May 2024 06:34:15 -0700 (PDT)
Message-ID: <4e703542-b839-4e69-af59-847e26dc1722@gmail.com>
Date: Mon, 20 May 2024 09:34:15 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re:
To: Minwoo Im <minwoo.im@samsung.com>, fio@vger.kernel.org
References: <CGME20240520102002epcas2p3d0944968114a664556cbd74d53beddee@epcas2p3.samsung.com>
 <ZkshRcr4c0GN8xLi@localhost>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <ZkshRcr4c0GN8xLi@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/24 06:09, Minwoo Im wrote:
> subscribe fio
> 
> 

Minwoo, here are instructions for subscribing to this list:

http://vger.kernel.org/vger-lists.html#fio

Vincent
