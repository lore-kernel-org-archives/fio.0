Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B78979946
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709580589; cv=none; b=ioFy5gHSJ+YN+Lc8PDLddFmYRKFiTmLYxWfuxFWq3z1vTAZSAvNfWxHVefR+HDgbGSnbEeDUt4My1L5qW504xvw54GCS6XRXgwKUaxYjAjuCYloHa8qzRfQb/GoQhmUpgj2O75HUsJFKn6ChN0RSdVI25hzFyY60Z5xgEa8Lz+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709580589; c=relaxed/simple;
	bh=+cE7R/8Td3F20WU1xZNSULtwd/N4fQJYQ8BKNHkm8Fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rm32p4XsDSYqjwkOlHcLGEodzvnAzdmybo+3NsXEaflwO4ExwWJWy/HNC26BN5zRcEsnFAbPrzxwC9Vcx5Y8bo4xZW/juWofXyffbGob79Q5uRmGg+nbO4tc8jzL1+NrSNp1Awihs4AzvVMBgNik7HQuCE2Kg5mGLyFiNXusZA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UlsuYHID; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlsuYHID"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-68f9e399c91so42074946d6.2
        for <fio@vger.kernel.org>; Mon, 04 Mar 2024 11:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709580587; x=1710185387; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UkJzx6xC2H6Wv8+CHY1OHhylK5fY2sGb+cgnEuRVVRo=;
        b=UlsuYHIDbhUTBAag+nFWdDduqJhSZlrER8eRjjOYrT4an0omq66jBLrQIJcAIl7qDb
         OXYXy6ycocXKCBXKbKYTMqV/kcLyv0hkDBYbYYmMyEMGZcv7Gvg3pfsaoiX2zoHDqQeb
         4LwBWvmDvfduyvt2kFvWkd3X8YeOF/QviJTEGxTEbViuxpOMVqIs8JdK1xxP2zFPmxsx
         WZVSDryIdEWNNoGrFSa0iKprUGh9BxW9ScJ6dwN5PtZAW2PdBvctaYZED02+WNPe20rT
         G8vR5Q55G24YdYwWm8GSN19Nu6D68LX/AmWz3CvxVnP+UL3PhyAppF8vpJJ8I0hg5F1e
         MckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709580587; x=1710185387;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkJzx6xC2H6Wv8+CHY1OHhylK5fY2sGb+cgnEuRVVRo=;
        b=Szw2vM5BuRRIUHJtTFnQzaY05KBND3VoqGzMXT2QO2L5yb0/yeBq9kOTe+4hW0FOwC
         1CWhfxazJjlXGt/dDKkb+/O9bx9UwXZeIsuEWcab/+mElOCFOKIWyfhY9wnAlKEGoppt
         uz/UhxCHeX/pwF+szb3p/PcBFmWIKiMvlRMGiCzt4oUiWG06sWpCLcP0rJj/jJEMZzpo
         mB5Wwf42z1GJE3lgs1lB8xkFQ0QIvXL1/jc3s4xFLUu49Vr0C2UWgwTQS6AWr06mP3M8
         v3ddL8fKNZ8sc60TAEl5AqylKYXmVK2GUn7O/B1p5HlkFKc6rmrvbntkc14Yzb8trae+
         Dn3w==
X-Gm-Message-State: AOJu0Yz2qwi3jNFqEt9qqaPDHITGvx+5p6XxHUoEhGvmYNdup8yXGzoZ
	9T1NvBDtkQkGzCm7I0wD22gwWX1//mlo+PM7uSieKKTvt1kHgQlw
X-Google-Smtp-Source: AGHT+IFQlkk8TUBBd4KyIRfZHEIy2NzxVbCPEGjP2ts5mC4tas5MDA0dYHgNaVSkkiHBGGYq6Mdscw==
X-Received: by 2002:a0c:cd8d:0:b0:68f:6e0a:d47d with SMTP id v13-20020a0ccd8d000000b0068f6e0ad47dmr10039322qvm.49.1709580579353;
        Mon, 04 Mar 2024 11:29:39 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id l14-20020a056214028e00b0068fecdef142sm5376720qvv.130.2024.03.04.11.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 11:29:38 -0800 (PST)
Message-ID: <307ea21d-464e-49d1-a03c-34c04dbe0c4f@gmail.com>
Date: Mon, 4 Mar 2024 14:29:38 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] Doc: Make note of using bsrange with ':'
Content-Language: en-US
To: Avri Altman <avri.altman@wdc.com>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org
References: <20240304071851.982-1-avri.altman@wdc.com>
 <20240304071851.982-7-avri.altman@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240304071851.982-7-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 02:18, Avri Altman wrote:
> Which is also a supported form of delimiter.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   HOWTO.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index c404d724..2386d806 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1631,7 +1631,7 @@ Block size
>   	Comma-separated ranges may be specified for reads, writes, and trims as
>   	described in :option:`blocksize`.
>   
> -	Example: ``bsrange=1k-4k,2k-8k``.
> +	Example: ``bsrange=1k-4k,2k-8k`` also the ':' delimiter ``bsrange=1k:4k,2k:8k``.
>   
>   .. option:: bssplit=str[,str][,str]
>   

Please make the same change in fio.1
