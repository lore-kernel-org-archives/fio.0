Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA24E23ABB4
	for <fio@vger.kernel.org>; Thu, 31 Jul 2025 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753978822; cv=none; b=sygoOdC7pxDKkH1jDZ+wyXKRArnJsUXgQDwvN2iYYdcJRJUCM/pIIb5aE9xdP2qfKunD/7IqSVQcGsGlIZPEzZT9wY9kxZ3aDKY9D1mx5mMoSSigP+P7i4vvLR6Fe76A9mZ3UKiDvESyIRuqgPBmdh8G48lgvyYlGHLPczUDaV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753978822; c=relaxed/simple;
	bh=HsxtOiWEEsVrjdjVD2qZD4S1oxGi2HYlOaS2XILInwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VyScGZiJlAbyeC5PFKQex0Oen3PDrn7dKqgA4DUF0plBxLgRfB1CxG0Bo7PfzTqHp2PZm5wXA8RcFwLtUjHDx+0SPLnQy5CKc4WbTUrEF7JUMUWVabHxwZlRy4K8lRjyQnEjYiiMpuQRZ/GTsxMGZJ1oDRn/+8EDGz5zVZeVeTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGPAPGpC; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGPAPGpC"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e1d89fcc31so107274185a.1
        for <fio@vger.kernel.org>; Thu, 31 Jul 2025 09:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753978820; x=1754583620; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q8YrBmTyN1rTDXsQGCmZgHuYr4/hbiuKjLRLao5aHdA=;
        b=bGPAPGpCH3vqH1U+SLf2aFlFvdQWfR3gW624lIAFa8TxPAPyXFUqUtgcZW7PfhrFqW
         tXHYRFppU5pQ5tWYPnyxpbDMCLnBCNn8h9eDaWhliX+YMhMG93eMQqRCilQNYFzKCazt
         RnEn4I5EQFmcuXDwiVJ8yMtzPE9T7itBLZKzNdpDgNBNf0zmJfQ/MzbqDhOWmRSgPGqs
         rwhcqCoktzsaTiEFJUM/VqX7mMKAfF6QDccaBST4f6pIM3c4BIWfz7Ggc7DvhH57//bO
         OWdi9zgh7ypkxH3OdjlByBQ6qSERAdqPkuv8JaaRFwT6FpQz7rKasnTenk1Hb7YIURE3
         AnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753978820; x=1754583620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8YrBmTyN1rTDXsQGCmZgHuYr4/hbiuKjLRLao5aHdA=;
        b=KElrWnPuVPrZd0NhoycPM3nKDGdpifa7u+ibnp/5Z6AA3KMr9PQ4dd34VNzxrLNv8p
         J+nD+S+gAIWCUfik5l4kQA+VWHv1/QpLLj9X/d/esRcBWPFAOT/dVpIe0rYdixzHgput
         Eaa66aI7myca+vhVQRAiuqAuaKwTH2B2IYRTt7TFDU2ZgYqS9MJ/xFDFQ2flNlL2L+y7
         fzBCNn8h2kGCjiogH2mN1UyOrgYyDlO1SRcuM8sX8B9uTA12dh0MfAlAke80RdBaUcms
         4JXhwqE84Y1Q1E0HJpstzneXHmzSxa6JYtWhcxYbeAkpa2JpODYmnSW5pA/9rKiD0RuH
         ZPdg==
X-Forwarded-Encrypted: i=1; AJvYcCXr4mU6G9oWS67X2bXnRYeKY3J3oKtfwE7JYf9M3V4eg0DFIFHe10muHFj3LYNpeSnkejo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTcNuUB0IJXSCX0PA2z3S54RtOxQYeWs68pIweDHcHVPmAyB8l
	gH3xkY6WYJV4+AFN9cw+XUNvojdylbQ1RXN3x2rGiTU8xWyUXX195fpx
X-Gm-Gg: ASbGncuUWKwj8NpwJqrtfLv0uwfTFPMtk4+H4sL1La5547py8A75FXcT1HohEOBNI0E
	dm0oytvmPDZspdc3weRj1/UNspn3fqqQv9m2tn1D/h64AEp6qT7uOTca4GyJpJSKrIe3WuvyjWt
	NRBEcnp2/u3y0ikBJpWWyyzUipernLGDnSM3twQEyFRjQeq21nnClUjmfWEIvc/j+cJquYSYPEa
	lGWb2iVtoJPiSiWx+CfUNogT6909ksjTIy9m6nwyhT3oKnDw4gbMVyq7QfDBQystUUSFwhCi1oK
	vboewhYfR+WwA7rsnzE/PZ/IPbZ+ArZvHZkKLHJKNQuMGsOe2IUhxErhtk/16AlUDJke+PbnzKk
	9/JEoElLDUoh4bd9ApOtJfPP9fh+Ida0GjQml53vv8rKqI1tips7oLjfqh2OlyzUUa5by+KM=
X-Google-Smtp-Source: AGHT+IFiBgP19gH1lGR9kkakTitkKABsmURzq89a3l/2rfTAywNmZxVoVhh2/2N9CMxr/FNdWg4lnQ==
X-Received: by 2002:a05:620a:ac1a:b0:7e6:252b:9b48 with SMTP id af79cd13be357-7e66ef7f4camr951773785a.11.1753978819380;
        Thu, 31 Jul 2025 09:20:19 -0700 (PDT)
Received: from [192.168.1.211] (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f706406sm100732985a.49.2025.07.31.09.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 09:20:18 -0700 (PDT)
Message-ID: <4b0299d7-e4a3-40ec-ad6c-5bd25330c50e@gmail.com>
Date: Thu, 31 Jul 2025 12:20:17 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] filesetup: make longest_existing_path() static and
 const-correct
To: Tomas Winkler <tomas.winkler@sandisk.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
References: <20250731122011.539660-1-tomas.winkler@sandisk.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250731122011.539660-1-tomas.winkler@sandisk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/25 8:20 AM, Tomas Winkler wrote:
> Mark longest_existing_path() as static since it is only used within
> filesetup.c. Also, declare the 'path' parameter as const char *
> because it is not modified within the function.
> 
> Signed-off-by: Tomas Winkler tomas.winkler@sandisk.com
> ---
>   filesetup.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/filesetup.c b/filesetup.c
> index a94d3b38..bcbd871e 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -1002,7 +1002,8 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
>   /*
>    * Find longest path component that exists and return its length
>    */
> -int longest_existing_path(char *path) {
> +static int longest_existing_path(const char *path)
> +{
>   	char buf[PATH_MAX];
>   	bool done;
>   	char *buf_pos;

Applied. Thanks. Next time when you post more than one patch please 
include a cover letter.

Vincent
