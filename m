Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8444312C7FB
	for <fio@vger.kernel.org>; Tue, 16 Apr 2024 15:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713281107; cv=none; b=VvZmPLdEcxaq9whPrSckG0S5LYs9rAGMT2fDNDAz52O9xRRrn6lTCrifssrJF4atR4wPBbu9ULDUx5R6v66qYF26evUUU3DnqzN4ykq2EwxGcO6DThBS2Xn7Bpc2xK3BksFaOt+mso0FEhTAbe0nBJ66ixAbO0WT5jKGSDXhCXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713281107; c=relaxed/simple;
	bh=ns7isBsgdUv5w31hoKBHKEwsT1vwS8+9vMZdO/eyalE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XVBMrrClYPUubbyab79m3Ec7hDIeCw+AExrA0OkD21oVVmXyQhOPq/TwIy28Rqeq+MiCySQWQmMWf1kR4gOAtzoUtd0XG3VdXld/gSZTMy73q/G7agaqRt/UFkvRjerLQZFCR7Tpb5CsY8r3J+D4+e1xXajPd3DpYYVB0rhschU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y39EbG8m; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y39EbG8m"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-43716ff5494so16062061cf.0
        for <fio@vger.kernel.org>; Tue, 16 Apr 2024 08:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713281104; x=1713885904; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aSwLQsNm7MyfzRVpbwPEDG9pMqN6Gmke7Oei5Itf2Dc=;
        b=Y39EbG8mYENqfoNq4LmhbwekNBJYYciCl/dlAzmtFxyYOykz9aJEK8oIbY65AZxPcA
         RIElbYNg255gogcHswlKdOdGSACouiBvi+58wJQYx2judBcYosY3kGGRkEopcqpwi1Gc
         t2Jp0F0F7sZfUD6Xhj/mwARQyGSuNSGm2DPldceP2sGPPHjor06vYOwfxfP6vpsGDYyJ
         FIalSMGlYLlbuvxqMf40I9sRksEy3GFb1J3a0SDuKtPsqVVHroEajkyXoKDCbyLuNBF4
         LNjl3dW1QlK5YHZF70oT4zULN7e2KU7DTxVXTUlK3ap801HFSZNhnkbl9J7/n+sAb+Zl
         mszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713281104; x=1713885904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSwLQsNm7MyfzRVpbwPEDG9pMqN6Gmke7Oei5Itf2Dc=;
        b=iAvuo3aCZPBamti+avAORBxni1upucx7/qEn6V3faDtQYujXKf3kQGiry1VuG9gAL6
         Gu15pHfqO/u+6BHt1mkRrgY8HF63UiV6z3Oni7/mbAfMnjIGfaR91qGNbre7zfOmHF/h
         Hjxbsxifr/ra67Gd75HyATJs480qZ+IGcp5laKjNDrukAPXYBzutu9v3JKl9hTDnzca8
         PHXW+2fh9X6ai4n1CUhpm2Wmh51/PAxFj0h7X8/x/lFCIrjTAPT7nEsoiHajttYm23L8
         4Mr5P/b/FdrY5r1dlosaC7xUyF2Xf6gqG4oBN04QVIqjprHsP9X0Xk8ScXM+qQWFDM1b
         4sQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD1YNRsvc5+hjxBeE58gEGvl1yrs5x9359cKDIZG2UVmtNcx1cSAbwx1XPHMULqpO4cflkYh2XStyRSeztGKpPWx0X
X-Gm-Message-State: AOJu0Yw0zgeBc1fYXhkRc1Mnrx5Cd2kUmBk09X5JEh3DZ42xAP4vxr+u
	BtAPepl/3t5EImOKQu1Gkkv+Mm2Cf7TMv3xpcNdVYpAKDpt6T4AwArBQdQ==
X-Google-Smtp-Source: AGHT+IFIeSSps+U1z2ccKJi0AqFaHq58RBK3TbtwqsvHIi2lC2CJbvfG2QL4x0lNrnc6W608PtHtPA==
X-Received: by 2002:ac8:5fc3:0:b0:434:6c3e:3074 with SMTP id k3-20020ac85fc3000000b004346c3e3074mr3382621qta.22.1713281104285;
        Tue, 16 Apr 2024 08:25:04 -0700 (PDT)
Received: from [192.168.1.206] ([172.58.188.23])
        by smtp.gmail.com with ESMTPSA id dq20-20020a05622a521400b00434e990098bsm7271792qtb.77.2024.04.16.08.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 08:25:03 -0700 (PDT)
Message-ID: <551f4e4a-8aba-43f6-ae20-439041b87310@gmail.com>
Date: Tue, 16 Apr 2024 11:25:03 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fio output percentile latency seems upper bounded
To: ylhsieh@mxic.com.tw, fio@vger.kernel.org
References: <OFA9096527.7152DEBE-ON48258B01.0030FF36-48258B01.003110F5@mxic.com.tw>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <OFA9096527.7152DEBE-ON48258B01.0030FF36-48258B01.003110F5@mxic.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/24 04:55, ylhsieh@mxic.com.tw wrote:
> Hi, there
> 
> In fio output, sometimes I see tail percentile latency to be 17112760320,
> and it remains this value to 99.99%, why? Also, the mean latency is larger
> than this value? (intuitively, tail latency should be larger than mean
> latency...?) What's the reason and how to make it reasonable?
> 
> "clat_ns" : {
>    ...
>    "mean" : 41081227631.728256,
>    ...
>    "percentile" : {
>      "1.000000" : 1669332992,
>      "5.000000" : 10536091648,
>      "10.000000" : 17112760320,
>      "20.000000" : 17112760320,
>      ...
>      "99.950000" : 17112760320,
>      "99.990000" : 17112760320
>    }
> },
> "lat_ns" : {
>    ...
>    "mean" : 41087031313.177292,
>    ...
> }
> 
> Thank you
> YL
> 
> 
> CONFIDENTIALITY NOTE:
> 
> This e-mail and any attachments may contain confidential information
> and/or personal data, which is protected by applicable laws. Please be
> reminded that duplication, disclosure, distribution, or use of this e-mail
> (and/or its attachments) or any part thereof is prohibited. If you receive
> this e-mail in error, please notify us immediately and delete this mail as
> well as its attachment(s) from your system. In addition, please be
> informed that collection, processing, and/or use of personal data is
> prohibited unless expressly permitted by personal data protection laws.
> Thank you for your attention and cooperation.
> 
> Macronix International Co., Ltd.
> 
> =====================================================================
> 

Yes, there is an upper bound. See the discussion in stat.h:

https://github.com/axboe/fio/blob/master/stat.h

The intention is to calculate the min, max, and mean without loss of 
precision. But for the latency percentiles, each latency measurement is 
assigned to a bucket that includes a range of values. The midpoint of 
the bucket for the highest set of values is 17112760320 ns. Values 
exceeding this are not tracked accurately.

You could increase FIO_IO_U_PLAT_GROUP_NR if you wanted to track long 
latencies more accurately.

Vincent

