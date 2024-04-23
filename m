Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E35713B7A3
	for <fio@vger.kernel.org>; Tue, 23 Apr 2024 15:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713885412; cv=none; b=gMfviigurU37Cg1FV100EQco3MuW8umZ55D/IXgmBKeG1RT55ZCTWBrlAJOPy3cLgOFxGqlMF4C1/HZNI5VTjzDuDYtaikPUizU1b3gBfxU6h1AJY7cbLsbmTbwDGTg25gpUqNYT3ELJY8AmHPu/jooFf7GfNuvUMtSU2RxcaTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713885412; c=relaxed/simple;
	bh=QdLloN0kAmE1VZZCKXHl0QEFoVRcUw4yezLNQX0GnJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pr1FFMqgoTKW4KBjk3ToIsea3a02mKr/Emn9Wgduo9Iykvvr2rypIaXf6ydSTgf9Nt+21VjgPrAfeizd7QgpXhFa7sgoRh/gZAC5SC4MddfqxESOjAxhggVHLngmD7yIea72UeRVfn5U/AtKeyRJyHuJynZtHuEJ2rj/L/hDa3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKFCmSdY; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKFCmSdY"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-78f0628da1eso355099485a.3
        for <fio@vger.kernel.org>; Tue, 23 Apr 2024 08:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713885410; x=1714490210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VSHj4CM4ZVEPC+rohIckUkn2ZAChi9+VIlZS0vtnqIQ=;
        b=SKFCmSdYAuSWFgUhG056WyTOjHDF7jc6tQVih1ud8ntIx/ni+2N0t1CauPwVimiGfV
         2d0I3lCPLishpHM0Gn0QVMmINzq+ERgobystSBpHtF/f95KamOnF5WSriURuc5zRlGN7
         N4vqypBa8YixP1MmWgQz79Ssx6yTay7fUVcWazTiYzXfltIr5wVF9qgCj7SLmhpqLJi4
         Ox4E999dbcjk1MUw9qSn6cY7ofSYbacKX0aSW9BnPVjWrPum0uepwOL1mVYEr0KW5kTC
         nHRj65ZDBuprXJO9jE3k6MwDJ6cz04bWLEXqvSpmU/TUBnWZ+FNnMMo3ijAGxTbl0yMj
         SeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713885410; x=1714490210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VSHj4CM4ZVEPC+rohIckUkn2ZAChi9+VIlZS0vtnqIQ=;
        b=bbXivPRvb5AmBc+E3B5dBKxTjVassRuVqUpzzpm/dLbTdimppmej1rGfGMmGer6aX+
         jgQb0miV3w57a4yui/9qSB7BvFYvKAlVM2JBhkPVulhjsjaGSdD73UmmVhEDWzhKB+hc
         yhNhGoOUF4+7G3Oa0MvdPYG30QZI/jB9TYTe27LakjpT2yzD58RlA0hJcyStqFpNw49b
         RQQaS9Lkllw6h904t11AF6fCAiPx8LxRbtLE+BZ3Dh1zTW+Y7U6Z3dSKAX2JRpmh9Mox
         Soi5AHXZMgphuTrnIRFUv43ezL9WcOhPXWrhdwcKA6chjYpkR2weBFqltr3zpoDzpd9I
         h7vA==
X-Forwarded-Encrypted: i=1; AJvYcCWt7sDsxOraVYB79klorTj/pHQdrrYOEP0A/2bUp4WL4Wt1phtlulgw6sL9r0bRLIfEo1E5U0imPQyBtf2Tfx8UZQjG
X-Gm-Message-State: AOJu0Yw+GKjJSw7ct7Og/XFJWo6/GZQS+RI8GeiK1Lvu/aerlJpg2FDD
	Awb5SejVmTp5QVO2NumXrSF0AEhq9O0xm2n7Obo6a3bWYSB44+ACDJagtA==
X-Google-Smtp-Source: AGHT+IGDujqocadRjLeACkyi1Y/1zdAYtraPWymyd9pdRCLeaal0lCX4/1c+vNWUOSIyMnF1EDGzmQ==
X-Received: by 2002:a05:6214:19e5:b0:6a0:8511:98e0 with SMTP id q5-20020a05621419e500b006a0851198e0mr6442873qvc.22.1713885410292;
        Tue, 23 Apr 2024 08:16:50 -0700 (PDT)
Received: from [192.168.1.206] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id c10-20020a0cf2ca000000b0069f54baabe1sm5208434qvm.127.2024.04.23.08.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Apr 2024 08:16:49 -0700 (PDT)
Message-ID: <81569cbc-5849-4199-a0bd-d7cf255241b3@gmail.com>
Date: Tue, 23 Apr 2024 11:16:49 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] FDP tweaks, NVMe streams support
To: Ankit Kumar <ankit1455@gmail.com>
Cc: axboe@kernel.dk, ankit.kumar@samsung.com, kbusch@kernel.org,
 fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
 <CAKi7+wco_sbPbWp3_V0p4UOzBXnaQ7KhvTnGcSbFy+VWZr899A@mail.gmail.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAKi7+wco_sbPbWp3_V0p4UOzBXnaQ7KhvTnGcSbFy+VWZr899A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 04:49, Ankit Kumar wrote:
> Overall changes look good to me. I was thinking maybe in future we
> should add a new group for all the data placement options, debug logs.

As far as I can tell the option groups are only used by gfio which has 
not received any attention for a long time.

For debug logging it might be reasonable to have a separate group for 
these messages.

Vincent
