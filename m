Received: from mail-wr2-f37.google.com (mail-wr2-f37.google.com [74.125.225.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFEF4BEE37
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789675325; cv=none; b=slKZaFXr7gLBOUNrXna+By58YFlSSUJ8mcArZTIh2dd+zEFTupVJsObkaU/PqTegVhNkHUDkEBrJMOreqtOwiuYcv9BhlIRgWlgWTZGcKKebJZ5E6+I0lEb/a0lgwNGO2Z8Ts0RO9IBHmk3tSy4VhWxOTRm0sTjownP9k/gmx7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789675325; c=relaxed/simple;
	bh=rYc2WND9O+cx19sQ4YN4o++Jfc5v1TWpop589JoMFyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vb33oTZSqBP5SvoWZQyOrEMLA6jXb/DgvzLXO/pkTavCx38crxeSN+Kt7icHMjpp2AbglYkbqp/BhFnKt7Y2NIFkOXEcd/bvGvyaI16OjLX0W4wRK7L3TDvE7ZyQfmKKaz4OpTWmEzXjCI4Xk+UltmdNdO9ype/hH9vLh2P9prU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ESGUVlHJ; arc=none smtp.client-ip=74.125.225.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ESGUVlHJ"
Received: by mail-wr2-f37.google.com with SMTP id ffacd0b85a97d-482f6356f6bso1064448f8f.2
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789675321; x=1790280121; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BxgXTgJI9gr973taTy6I/sMlvO1fIOYMmSo3+ojL4Zk=;
        b=ESGUVlHJAFo9amAmQ98M5YpkJwNJQBnK5jlP3KHmgi2l7m8mKnz/gdfuaQTXEb/n20
         fbW5hvlcZZScTMLUjwHiHsz9xIcHmumiFDtMAgze4lGL5qPiwPN5K41+NOTN8VpGrTKa
         j0+7pmGN4HY02PWYIXPJmDUk2iVsy9LMPGrOPkOPnF3pcSzD1/VSrztz++j6h4hxBtBr
         cLqa032AXpF5fI11MHK6YQujeHFa9Zj9zrtfA7jNDpbRcaYc1A8ev1WH7+yMUPUdz13m
         HIOnLPnhEs7NqfPHGcC020BZzvc61aFTxcgSvcvJ5tMpuCj9Ear+JqYFD6LoXD8y6udH
         BCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789675321; x=1790280121;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BxgXTgJI9gr973taTy6I/sMlvO1fIOYMmSo3+ojL4Zk=;
        b=NTq+6azBaytTz/GGhETu5YMuYV8UXG0DKu5Rz4JhztOKPrY2eb9DNIBj+hYHzO55sL
         tah1sSGYfESzHg+VQbdvIXIVQynoZ83eOUAerIBa8FN/dJv0VZ/RcRYPe3Vg8Kj1yBji
         G5guUKJPslpaNEI+4mjOJhzqir1lLQnihvT37NwFXZ73+56p3a01fkzW5j3aXidaHV7y
         D+BYERZ/6hPvT7zY9cyL+wC/UHSFJx9CcLu9cogVGSENHays7uUqgC5ANlHKQJeF2u8U
         uapT3U+3J0YRUkugiOJInUpWfgEKdPs96gfuu/4lmRRwctJWwRlXyORbeKE2GNohqR/u
         s5bQ==
X-Forwarded-Encrypted: i=1; AKwUvBxa1eNd9xJgZgW1wJl/Z3OinwpopRfqdeuh2j1q6aBxDnJ85a4ZLiOp9N2i6nGP1w4ewUw=@vger.kernel.org
X-Gm-Message-State: AFuF++lV/gklCeyjpgkylW0nZSOT0FvhlEuYgHzUN2SoDvskEmrL/X7c
	XpQYKclqHZCbH1Rw3TgQfWvg5x1pDRF3KJRE3ApGkCQerpOuBgdVHusaX7js8zmTdF9B6eImNxP
	LYOvmIBt2fg==
X-Gm-Gg: AYBFou1ngmvUPmNIxLgq1Wx6qNVboPWfacoRB3irfHVbV3ErxgYVLXLquM1KVd2rZAk
	nFKxDxGJJdLg4e7F7vKmKskPMPB25iT+GogYkIct/xt1UF3akD6XMCBrPOnNiHTX4UJeWRp5eaR
	GQ8QpK6p75iI6kx7QcVg5nbzMRkuV4vxhK4yOJzdDIuUjGVelE38dwgryYH0/I0gYYzeaK99eni
	NKVjqR3WZ8Z2HsVeAEMfRSIJJJRZGaonLbD728/oOOWbbBOU6FINp6qj9MM3dfpCr2R+l44GzYc
	xsQoNibK6rCuOtecwBqio+LptyN3pfroCR4RdUq6HXcWHbTYhiegeHRpImguCawiS56PTqAkrNf
	o4YwTCMHeymDQAYQA0LDdT0moEBJJztEcKWPl+x+kS65nubExP1vnuZKOdC8ba/iZ9DlhNxjGti
	31U3Em9uaEIZRoe4PpT+9mjoHd5udRB30k+6+x9+S5ogM9OyZEYcrUVMCQDqNkdIH22S+WW1caT
	mFBDtMi+4wAfwhDeCyLNuAaEHawbCbi3qsxBmvaioMKw4pz5Vy28zLi4vUzBYH6u1MH
X-Received: by 2002:a5d:5f86:0:b0:487:a9f:4fa5 with SMTP id ffacd0b85a97d-4871e20f7camr68447f8f.4.1789675321265;
        Thu, 17 Sep 2026 13:02:01 -0700 (PDT)
Received: from [192.168.1.112] ([217.65.139.42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf344bfsm17741362f8f.27.2026.09.17.13.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:01:58 -0700 (PDT)
Message-ID: <ca12a7ee-7a5c-469f-89ea-5d3a3cc43489@kernel.dk>
Date: Thu, 17 Sep 2026 14:01:57 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] fio: server: Warn when listening on network
To: Eric Sandeen <sandeen@redhat.com>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-4-sandeen@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260917194706.2264798-4-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 1:41 PM, Eric Sandeen wrote:
> Make it crystal clear to users at run time that the client/server
> protocol should only be used in trusted environments.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  server.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/server.c b/server.c
> index 34f3f5c0..887ed7ed 100644
> --- a/server.c
> +++ b/server.c
> @@ -2596,6 +2596,13 @@ static int fio_init_server_connection(void)
>  	} else
>  		snprintf(bind_str, sizeof(bind_str), "%s", bind_sock);
>  
> +	if (!bind_sock) {
> +		log_info("fio: WARNING: The fio network protocol is neither "
> +			 "authenticated nor encrypted.\n");
> +		log_info("fio: WARNING: Use this mode only in trusted "
> +			 "environments.\n");
> +	}
> +
>  	log_info("fio: server listening on %s\n", bind_str);
>  
>  	if (listen(sk, 4) < 0) {

Let's not pollute the log with that - just document it in the...
documentation!

Like I said in a private email, anyone that runs a fio backend
outside of a trusted local/test environment needs to get their
head examined. By definition, since it's generally used to open
block devices and read/write to them it's run as root. And since
the environment should be trusted, so should the clients. Anyone
thinking otherwise needs to get their head examined.

-- 
Jens Axboe

