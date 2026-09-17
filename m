Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578E54E4C27
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789675215; cv=none; b=RtUN2L6livkps5tmlftezJJ58U2L7RW3IwKCz2Picn+77kn5hPpJjFV1nARKkQ4QqVIV+gccZuK/XGJYfgxYET+dbtKmUBkBB1piLZD+lKRqsWoTMG968B58en4eBbTuixy6FKKM8sjlL5ujvuMBh911moGXZZCSFo2XWe78G4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789675215; c=relaxed/simple;
	bh=8garfyVOoK3ynAVqPydxT8IOve+AisrImbMVrLKrg3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XOfdDI8gopNzmErj5+astbbEABWzfIai2bQgUY819bL4+AcrnquqWbcjx8ENHwAn80kxa0lG+ukB3+g10JofX4FCdwSFXrX/RGfKB7HmUTPwaMZHZh7u8ngj1T+VTFj6OAqzPzf4U8h1XS3qngonJo60q1CCw4Ch0DZYlUOm7Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=wmg+4G73; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="wmg+4G73"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e64ccso332695e9.0
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789675209; x=1790280009; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BpxkCkYc3vMQuLY9bsNpGDZHUHTayb6feoky1vHUSTw=;
        b=wmg+4G73QXHEiHqRammji+N51vH6gGiWr8tIIBp7AWl59OvO7DPTkZstCwYx/pXfEk
         Qb9FWmAifLBtSjh5UTD1hgFV/EvZEoSu3fcwz0Nr6AYWIqX1Yy+uksFZ3CdGEfDe5tIb
         xjJCbEEpvCp+T/y48cAE0eYRy+GE2zalKQXNQfuu0Bugdn/i9BoCORfW+/yUMnWnxEk6
         6buCslU7Eoc5Bo3tT/+rvdsDd/L0IUkgA2yx1qxpYrW9TIJIECLaUkh9lDhCWyqE9RGT
         phdluI45doXIr0GLHZ/JTuLqKc5Hw8VhYOFh9g8pjwgMRYpKOEvJJVD27Df4BPqour6x
         eyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789675209; x=1790280009;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BpxkCkYc3vMQuLY9bsNpGDZHUHTayb6feoky1vHUSTw=;
        b=r8+FQtasayMVHhWGmMnzMpmBe35UTYJKPhIjMXHaYjMuZr4ip6WYPPxMHpfVbyzlHj
         Nt0MRowSXLgy7aKGrLzHtw2/sFASXjzmRil0ZRELy/1BKUgZwiOOakcCt5Jh4dGtm3r+
         1j+UJhcZ7DK78o6vac0tZHl5kbrIYrBXLSWjyVGgHn5oxvbv7BrX4ZRgdt2B3blN7Lc+
         aEhz5BRYL1djA8nW5J+0RzEKqK0MrKAN9gK0ddMU2twm7nN6FXq1D0Kvz+aMSz1oIQMb
         xbbFOBGVesQYKoSWOoY5jwPE9nSTpVseLvkg73OiAx6imNCb5Cxt71M0hULgpMd/r4z6
         8tcg==
X-Forwarded-Encrypted: i=1; AKwUvBzjADJvqZwPPVYpkrfI+v1yjfXyyYzE2jiwzVZYVeGK/BgTa/5z3mptbUSpLq6q/lAIX5M=@vger.kernel.org
X-Gm-Message-State: AFuF++mkQHyBqXeGFW8b44VYNmlGnf1lugWW6m+A8UdvDdMitlpdlUW2
	lqCEi6CWFHsGx6B97MVAvQPBDVHQnqRt4ZJ+tbFB0Cb+7cAPU0l/mMfHbtzT6oFqqEQlKeW61t9
	tPBJFNTpaGA==
X-Gm-Gg: AYBFou0VTsgBmzxCZPo9vUb7cbd0EVYdkYD1mx0bwlxY94SihHAvwbrM64yg4md1P1P
	jTWNKvs7Gj0mhnA3HjKYrRPv0doImuQuBUcEZbvoJuKPHLIwAtZvbdlZEAbEdWwFMWdO1vZHTLE
	x6lghaCoqbZky/u5z9da4vV3EikhLvdstBZ9WiJrlUNzVbAiSfwvkrTOex3dECE3nJrfem+RNX2
	TS+KLcxJG0iFrykqAFpjJEsa8WmyiGTaJk5tYvAiVWnQHNLViiXiQe4lA/b/jAOVXHKMWeRxdXk
	H0xt7On87/2cRbs4y5DhaotDZ4g45IHQG38u+x7WcNZBEx3rXYDxNUstsEkp9Zbfi2vdwCJ4chy
	eSSDt9DFSbi9Wt1mHNs6YrRKimja1F8CC3Rlpx9A4qFiTPADZlXdS7fqpTqVsGWcc4r0Hrf1WJ5
	D9tz69HmcuR53P3OTd/ri54Kjs/kwi/RraKRIuJJgk1q2sh7HJHrQqrnnNKF7go7hGRVHcucwc0
	tFyKcosxPC2Eno6CGVU9WwdixxOYU+sg63s16aycDv4y8qH/q29J8CVM1Q=
X-Received: by 2002:a05:600c:3493:b0:49f:bd3c:bc21 with SMTP id 5b1f17b1804b1-49fc573b55emr26415e9.28.1789675209212;
        Thu, 17 Sep 2026 13:00:09 -0700 (PDT)
Received: from [192.168.1.112] ([217.65.139.42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871af1cf5dsm2064298f8f.36.2026.09.17.13.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:00:08 -0700 (PDT)
Message-ID: <fe69c3bc-95e3-442b-ac61-9d84c85f2e93@kernel.dk>
Date: Thu, 17 Sep 2026 14:00:07 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] client: sanitize FIO_NET_CMD_SENDFILE requests
To: Eric Sandeen <sandeen@redhat.com>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-2-sandeen@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260917194706.2264798-2-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 1:41 PM, Eric Sandeen wrote:
> A legitimate fio server should only be requesting files from the
> client's cwd; reject absolute paths or any paths above the cwd.
> 
> Since this adds yet another failure mode, move fail: to the end of
> the function as is a bit more typical for a goto fail;
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  client.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/client.c b/client.c
> index 374a744a..b32c2852 100644
> --- a/client.c
> +++ b/client.c
> @@ -1809,12 +1809,18 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
>  	size = sizeof(*rep);
>  	rep = malloc(size);
>  
> +	/* Sanitize requested path to reject files not under cwd */
> +	if (pdu->path[0] == '/' ||
> +	    strstr((const char *)pdu->path, "..") != NULL) {
> +		log_err("fio: rejecting sendfile request for unsafe path: %s\n",
> +			(const char *)pdu->path);
> +		rep->error = EPERM;
> +		goto fail;
> +	}

Won't this potentially break existing use cases?

-- 
Jens Axboe
