Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWrLtBXR"
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824D5F2
	for <fio@vger.kernel.org>; Tue, 12 Dec 2023 06:40:53 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-77f642b9a22so224429085a.0
        for <fio@vger.kernel.org>; Tue, 12 Dec 2023 06:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702392052; x=1702996852; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Y2N0Rgtb/4yuE07ixlFJjg/nR50sh1ARCgHswBEB3g=;
        b=BWrLtBXRVdcqYKgd6cioJRby1YS8CvGkG5/NiFFrjqu7uf72cF5BIeUernBQhQl4BK
         Fxan6zhQDx7tAGk8RP2nzMH/1hTyoC2uowc/kuZqO3mdqChAtHdM7eFRZryR3sKHRhIM
         y31bEDO6ZSHqKJ4ZbRtecheZCm+KV0EJpLOFlJ/FdrKdgO1Ko24H05mQP6vQOdyFBh23
         qM+IHEBq9MBy/GxuIN00Pg/zJshj4i2fkFnev/HFUVgEM8D+FJJPMC+/C+FeUq58+75O
         IjjRRtBPVWExulJc3VtLoLIJjDLES8hQ/E1Y5HEH+qLOfGHFaHwTNsg0TO6LB8AzkUS3
         Cfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702392052; x=1702996852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Y2N0Rgtb/4yuE07ixlFJjg/nR50sh1ARCgHswBEB3g=;
        b=BE5CHeAH2m6wDwyw0hWcgMzzSyEwED0zwVi8KlM+kkqJ+uiISXqQHHdKSzTHE5LSIS
         wOQO1k6f8hMkKCtM2XGNJ+rO7SnbJzRJrxWLXsuhnoz3VmUnutjA4uVzrf9WfNuf/1b4
         TddfOopTqr+DVV6jo15joiFEcyNgCFmzkD9PHjFEUGPYYXjJlz80FY74F5fjjor7PPFX
         Lm6Zsph0s7vpW6JKYpqiduakZhLI0G8HQfh/UodD0rkl15i9MmnmsfcdnppALe4ruqIJ
         h9gcsh4oM+QfXXJkpZ6SCU6vqhESf9/94Fqj+KamaBxAGqMusJuRCMzl1JcXpGI0ghEJ
         H0mQ==
X-Gm-Message-State: AOJu0YyEOxZMz5jdb6076MhY/tjd6MVz1GS+VKuOtvmkR304D1pxTvbz
	H5U08VCax+kMxKAsL+8B30Y=
X-Google-Smtp-Source: AGHT+IE+isg7xMRACKHanBcwOdfjmmwstyIfqPbbSSVwBodGFcFJ3IhIM9k1gZ8ZKtVNSgEZIKoARA==
X-Received: by 2002:a05:620a:4628:b0:774:e4e:34d with SMTP id br40-20020a05620a462800b007740e4e034dmr10276372qkb.33.1702392052445;
        Tue, 12 Dec 2023 06:40:52 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id t16-20020a05620a035000b0076cc4610d0asm3747733qkm.85.2023.12.12.06.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 06:40:51 -0800 (PST)
Message-ID: <1dd0e64e-029e-4689-a6c3-b2e0e5228dae@gmail.com>
Date: Tue, 12 Dec 2023 09:40:51 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] engines/io_uring_cmd: skip pi verify checks for error
 cases
To: Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc: fio@vger.kernel.org
References: <CGME20231212092942epcas5p28e0b580bf48a7d932f1d801a7d4226dd@epcas5p2.samsung.com>
 <20231212144718.568406-1-ankit.kumar@samsung.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20231212144718.568406-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/23 09:47, Ankit Kumar wrote:
> If any error is observed for read requests, skip all end to end data
> protection checks.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   engines/io_uring.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 5ae3135b..c0cb5a78 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -468,10 +468,12 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
>   	cqe = &ld->cq_ring.cqes[index];
>   	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
>   
> -	if (cqe->res != 0)
> +	if (cqe->res != 0) {
>   		io_u->error = -cqe->res;
> -	else
> +		return io_u;
> +	} else {
>   		io_u->error = 0;
> +	}
>   
>   	if (o->cmd_type == FIO_URING_CMD_NVME) {
>   		data = FILE_ENG_DATA(io_u->file);

Applied. Thanks.
