Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C926AE6
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727372930; cv=none; b=fpSiuAbMcpmsryokrNXefwGy4cfX2WH2OMNbWGVpNUZogXhH5Ru+dSw7hqWLsr4yTc5tVzU2KJSJ6Yc3rCVNYDhINI2FegzedU+O8DEdfU5yJPdd3cBgCcfjcDips0MDfbun8RtquTDDtR61BEj/gb4CZAKOwGSzmMg8K7EhZdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727372930; c=relaxed/simple;
	bh=0wH7wo/BubJwdCX3t4oFaUyolcgZQk0b0htte5FRmmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ioxzmui51LQueasAPbRopl+bKzW1pECD/3zMKYQrDnZFw3NrmR2d+mX/ppopNTXtsjrUKF+Cb7iEDnvRL5hkaIyXuw1UBs43suA9YEiFu6iiRo27K/5dgf8ZfgWUCEtYDdVKZHfSITrZzLD8kTFfFDaUsdCHcBKLjsr7zCinEsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nVXKrQHb; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nVXKrQHb"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-831e62bfa98so62099939f.1
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 10:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727372926; x=1727977726; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kPaaEUMSJN8uDvx4fwkFdk9EaOglqcLnRkmhfxQTgCM=;
        b=nVXKrQHbX++bWEGadh1XxQuj3lbHnmpz/PADPk2ELFkYNjKNbqL4ps0C05bUjGxVVW
         lu9Ibh85JY2SnaPnafpzJGhrnynRp+cHJ9v9NrkYB3rSyZtOG+z1ap1aWQnYvo8lu1O9
         twahHd59CCmuk8SK9IXXOD9FNoHQ+a3jPF4e+fJdeR3zxeU+DDbMN8oYgWoLvA9QI4A8
         8n6htqfnzE4HxMPA7FAo33NlSAkj+hFwcqw9O5WokXCIlX6JVBZsJY3un4pJVJrSAKP/
         Fzi/8bvLA5+wdP2/0oGc/aUW3qPAUCd+35xBIsnTqQxj/J7sNl4I0cbOLJh6fWIk8H6G
         McLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727372926; x=1727977726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kPaaEUMSJN8uDvx4fwkFdk9EaOglqcLnRkmhfxQTgCM=;
        b=XUcI3lS2beoun9glR6e2a/2R64cyiH+BlvDgvXrEWMl7PydVei2RxR0OsPArPSEx7R
         cBWFrsfocL7WnRBSRZJKKIZXt/txIvPoYfSekR74Se26AYq0kS5lFlFRH3RpSN7IsRLT
         x1ACvPWvF6Kt5SA2TMFrwvOFVdwNh4HkqImi8ZzewXuBPIduW6oahrkG+SaXib1Bu3GH
         WJ6zyD7cOu3lgjihZGPTsWbre/R8yqhaigkycHkVovlB+L+VurU8S+Hd03cktVW85aUU
         Ig/fiowv542GdRwERNQVC4Crsj0iD4pv9zBFNVzF2wsa+HE98HIVLVrhBcifJ35UJbMI
         ysxg==
X-Forwarded-Encrypted: i=1; AJvYcCUbNFi9WfjIEIMp+3eHmFCuaiM16ju84L7TXKSCX/axKV9i4QJiZsxLkglQhtooxCazr38=@vger.kernel.org
X-Gm-Message-State: AOJu0YwII+5fSuU6taon9VH7jSZwerNMcwKyq2YyDUCxS38iXQWuzCT7
	d7bdRRar9Hr+UMbMNVNxHXE8n2zRjJWu8vhzYDv1Rdw1AxA/sb3BzDnyNeMRa4A=
X-Google-Smtp-Source: AGHT+IHyHKU4q2Zf2Oq6oOXug1LELIugH7G1H0mafYgif8SBa6Zv1vMt5SfW45AjtekxB0gveVjRhw==
X-Received: by 2002:a05:6602:6427:b0:82a:545b:113f with SMTP id ca18e2360f4ac-83493257f13mr65323139f.12.1727372925886;
        Thu, 26 Sep 2024 10:48:45 -0700 (PDT)
Received: from [172.19.0.169] ([99.196.128.115])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d8888d9661sm56712173.135.2024.09.26.10.48.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 10:48:45 -0700 (PDT)
Message-ID: <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
Date: Thu, 26 Sep 2024 11:48:22 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
To: Minwoo Im <minwoo.im.dev@gmail.com>, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/25/24 6:41 PM, Minwoo Im wrote:
> diff --git a/io_u.h b/io_u.h
> index ab93d50f967e..20afad667ee1 100644
> --- a/io_u.h
> +++ b/io_u.h
> @@ -22,6 +22,7 @@ enum {
>  	IO_U_F_BARRIER		= 1 << 6,
>  	IO_U_F_VER_LIST		= 1 << 7,
>  	IO_U_F_PATTERN_DONE	= 1 << 8,
> +	IO_U_F_DEVICE_ERROR	= 1 << 9,
>  };
>  
>  /*

The patches you sent should've been a series, how are they supposed to
both apply when you add an item here for each of them as if the other
one doesn't exist?

I'll fix it up, but for the future, if patches depend on each other, it
should be a series. Please check if everything works when it's pushed
out, which should be shortly.

And since I'm on a plane and this doesn't appear to want to send, when
you do see it, please also add HOWTO additions similar to the fio.1
additions you made.

-- 
Jens Axboe
