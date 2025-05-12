Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D20255227
	for <fio@vger.kernel.org>; Mon, 12 May 2025 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747055801; cv=none; b=I6V+6HLMSu6qp3ImWZhS7NWF0utIDhttZgY9vyrSNS5O3C3XWzU+ZMpIaMYD2WsTWmq0U8r3VhgQ34PRcr8ezhpOornSIJT1E2PGNnmpNlhsqLnHiLghQVdekGI4utvDQWssoKRRqTF/MPV8B1yJ3QJNwwLfhK5nwLnFXZTchnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747055801; c=relaxed/simple;
	bh=hAFS2yQYx0EsHYA0so1l25sm2VRJXdijGqtZRSN13ng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RXRWP3eRazN4a9uCp0qEAOYfeKgwaUsAs2gMVUKnxrPmPqvWYqQSRMDAkV3lq/t/9pmIXh5HqKJdF2etqj5v09P2uwK7ErZbLwJyIwjJdGBQrGv0i+E9ro2DVqpr4W233rlFN7f/+lRfn9zA+k2lTkfqIeBD+Z7s5Z/3Rrq0wy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=baX4/Jrl; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="baX4/Jrl"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-476ac73c76fso50369961cf.0
        for <fio@vger.kernel.org>; Mon, 12 May 2025 06:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747055798; x=1747660598; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LDMer/3dmRkQjfsXUMzK9qecwqQNp6Wc1zrJWO1WNRw=;
        b=baX4/Jrl/jIKnzCAnXVR8f4vMVCbmi2FObPCWxGlLZNhEdyFPbJVIUvccmAnaeANuX
         CaVLcFYeaFyv4kDOwxxbtmWrjkyqC9RjtLzC41Ydj3ruKcyat/OSveBdn7FXKVA2jhmN
         pxc5TS9RMI1d5WvQ60v+Md8mbwg7i6qtqr9MEBoLxwaz4QkuNWyk4xdKZCcP94yQvH2r
         p0yt0V7sY9mHhN1QoxGaRFIoUMq9p5m0ax4SLr2XaH8Dcn7jAS18dFD3Y7aIHEt3wMyN
         NZDRtRQTQeF30Ierdi+NGiTslJ3eEImAme1TgVMKEAjgo/dbfm3L13tffCMDkKyDDZle
         RCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747055798; x=1747660598;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LDMer/3dmRkQjfsXUMzK9qecwqQNp6Wc1zrJWO1WNRw=;
        b=nqW2N8y9l7zjpTXVIrSkcBrLQ9z7N/hZWl5WnNi1iBDY6ujx6Kms+TWC/1wUytzLFD
         /uAvrbx22jnGNUnu9rQnHyQlvQ7XKe0pygfM4zinCFDsnjLC6gy6WkaFtz6H/LyPTp7p
         zx/bt/czQSqbYMWuBCOrBqW2bsFL6ie+FNM+wqs6+k0lQX0HrGjNJcBx8yfZrjxTJ0Zw
         RvMOMs9AqWVPPxf5aVvyWwscmjxYuXpRe14hIZelEbD4ei5gvz5Ye76Et9Vts7MPm2LP
         JK4e73+Fd+vkeKmw4qRqTCj2PJqwjynsd7Uwj7wTjF008YIhcjmlkXSDGsz90W1PW6tS
         6O6A==
X-Forwarded-Encrypted: i=1; AJvYcCXlKryYI+uU30fCVRfbBWl0yuZUHsRpTdYUDKLKq85Dlyw+4FigNysnoJxBSANxBMmFW3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyppMqF9OLzaAj66lMP06nh2wPXZVSvkTV1b/mwk7++K4PYB/sa
	xpb704DbGzUt+c2pgL8dq4AJxTEdtx+QTlmddu9qQ8HTUdu5l3Ki1sQn4xRoJZK4KEhF67a5W8M
	B
X-Gm-Gg: ASbGncsM5SoeakSXEMCkwqJYOTayYAPi9hZd8CDIR8hyL2jo7N+/8OtciB8HvpOpSJw
	3Is38zWTBtIYQpbonipCukuaijb37AYWoxyimmjxRc1iZh1IUDjuxsPHquhCn3TqS9HcvZsXzAu
	VU/HqU67MakBZPvgXZjGwfEFgu0OG69t5QUOWQ5WvTUnQ93e396QunJIMoW+xEs62Ob9A2C9cbx
	6CeoLVBcW3lx4wVNGR2hlJmnmLxB9RAsU19abmn8nmsPi0vOUUgQ3ekoKDKjJaByW+Cpl+B4GIB
	FMGct+Q+x4PYZ0RjPgd3I7eUfXiZjI9IHovxWrbohU2eCJ4=
X-Google-Smtp-Source: AGHT+IG9Vc+yPJ7JPN9PRrCvhn+TRIdTlhAXxyp2NaBfK4Zs1jrCHkzbOVytVSSQjh0bRv8qxcjGDw==
X-Received: by 2002:a05:6808:14ca:b0:3fa:7909:2717 with SMTP id 5614622812f47-4037fe76823mr7233762b6e.34.1747055787618;
        Mon, 12 May 2025 06:16:27 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa226825c2sm1635966173.132.2025.05.12.06.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 06:16:27 -0700 (PDT)
Message-ID: <70f490f8-4590-4446-a72f-b75213868134@kernel.dk>
Date: Mon, 12 May 2025 07:16:26 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fio_sem, diskutil: introduce fio_shared_sem and use it
 for diskutil lock
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20250512013022.64633-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250512013022.64633-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/11/25 7:30 PM, Shin'ichiro Kawasaki wrote:
> diff --git a/fio_shared_sem.c b/fio_shared_sem.c
> new file mode 100644
> index 00000000..95e07400
> --- /dev/null
> +++ b/fio_shared_sem.c
> @@ -0,0 +1,44 @@
> +/*
> + * Separate out the two helper functions for fio_sem from "fio_sem.c".
> + * These two functions depend on fio shared memory. Other fio_sem
> + * functions in "fio_sem.c" are used for fio shared memory. This file
> + * separation is required to avoid build failures caused by circular
> + * dependency.
> + */
> +
> +#include <stdio.h>
> +
> +#include "fio_sem.h"
> +#include "smalloc.h"
> +
> +/*
> + * Allocate and initialize fio_sem lock object in the same manner as
> + * fio_sem_init(), except the lock object is allocated from the fio
> + * shared memory. This allows the parent process to free the lock
> + * allocated by child processes.
> + */
> +struct fio_sem *fio_shared_sem_init(int value)
> +{
> +	struct fio_sem *sem = NULL;

Pointless initialization, you overwrite it right after.

> +	sem = smalloc(sizeof(struct fio_sem));
> +	if (!sem) {
> +		perror("fio: smalloc for semaphore failed");
> +		return NULL;
> +	}

smalloc() doesn't set errno, and logs an error separately.

-- 
Jens Axboe
