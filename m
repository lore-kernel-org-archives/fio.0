Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD65115D1
	for <fio@vger.kernel.org>; Fri,  9 May 2025 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746794500; cv=none; b=e4znm59PXpPwUsNjyv+AXHwDg/ISFTHs6oI1zq2thBgd3Nb/wL86Y+qv/dNIPjJnu0hkgtq4oCI/zceLCi/xKcUu8OXjRM24KEPZ2/7o3DsOULgqHbyfxLnBfr8rDn+2vRPeFSZZgpXjJi9/NNc1AJGtr4+5uX9FQ0PGoJyvnOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746794500; c=relaxed/simple;
	bh=3Wd6VkegV3RxujhWsJeIcsirwsDYUfpfZCyU9zR2w6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1MNXyNHi3oxkqvr8m9VQkJDPp2xo5IA20zUagzYqn4FA4VeGNibhX44/PI3R+pGjRidmYTDXe+5tAj9ZHuzo5aotSR6PibFfR06z9xwX71PaN1dKwPDgBlDPOR1xNF3BFOfA10MXHauLG9IQb0VRm+8s9Dzi4p72ta+FpHMxq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSELokxy; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSELokxy"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4769b16d4fbso12676771cf.2
        for <fio@vger.kernel.org>; Fri, 09 May 2025 05:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746794497; x=1747399297; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4t5Yjo1zffdRbJE34ld1hNm3Fn68c442cCmN6nRqaA0=;
        b=kSELokxy1pecAej/1wCtGaVsw2xZ6CDANIa8ZtEq9MRkMaBM6+S8tdVa8NwX1wcw5J
         lm1+IWvN1NskULvQNz24oT3T9lQOuWx/mtau9p4LfAF6NvBAMgP5iI/Th1zczP1I0++i
         uKY9sOQ7xzg9ywn3CQTpbQij5Tm5MeWhqoLDnwK8ZcsKPKiTsqtM0IYgvrpYOMQvXLVR
         QoBnyfd7wVUkmlONYz1OKYQwyoCdFwEl80+quq8jzJI8+jc/OFhdrpAZ9H4qHvMX57um
         un3gRh7QPyDK3yKxgLoiXeAyA+JdXwhn1oDrBhn+3PlK1fJCS+Ksd5F+yNfqtaoIviIK
         IO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746794497; x=1747399297;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4t5Yjo1zffdRbJE34ld1hNm3Fn68c442cCmN6nRqaA0=;
        b=fTjlq4L5Cr+ns4Syoxvh7lDg9P8S1Mjb4HeXjNZJb6rXjjT951u1XZ8j/UgeHOb/03
         OdV0na+x2mL66el2+GqfIAkm8qJ/Zifx6Lp9aqXI8oRI8kXGr9sRayNlgtXKpEsdFaDs
         wKdkW1ToL3BJYD9woEGjQtENsw9fyVQTNq8ePMGkl1l4ml3jhdMVnTxNPuuWRv8thNe0
         L1xNK9LEOR6g/Cz2Klxb1juD9ZL4fszMVgk0NUOO+rzsoed/0HRxj95Za+q/A5gvGMDH
         E4kd9ehEhYs8W2gY7/4M0GHhCt2lMCbn4+OM4xhoAsK+PxHmv6w/4kgX1uQahxghDSVe
         wS1A==
X-Gm-Message-State: AOJu0YzL1rIAWoPYRZX8a6mONiaO89oXJb1NAqY7Ww3Jb/H44NXK1b9V
	p1w8xkMApoeosS9xVV2uCtW/NRXQF14suPtiac5QeBktl2sSjCXO
X-Gm-Gg: ASbGnct4kae6ASpNjNr4LJTc7NQ0qQfts4Nzqyt60DA4lvc4FB0+JYoJZaQ5GMMT5wh
	w8cf3NSADcpuWIJIEF59F0a7uG9UBL9VvVld3EKNcEMQ0hG3Md1LvwumHUR/bqJCcH2+qo0lVCf
	RxgJVHeV15RD0DuWQNzbPbzt8qCXL+JMDjJKwWd5wQDbmjMJvqnEjoIgNf5PIbd4Ibw56ZCSIdf
	qKPsD69cwWxWjx047qrmHmVnDW37PNhcrpqqN0LVp2IaSz+9QDb/WgmVuXVe3g5qw2sfg8jVmGt
	kfLxXy6c24wVFuDoMMn1bxPK4X1lNh5Pb1IbC5ZNrA/k3mr/wsb/PQBDOSELYBYyAsm5dccZan3
	dxbRBUQhbT7qzUBwn
X-Google-Smtp-Source: AGHT+IGkpgZWeAp9PaqDWbalKlh+9TgHk9AKzIRTtDBmAElEikJr12YNlcgtk2rUX5yn0uZ1lepobA==
X-Received: by 2002:ac8:7e93:0:b0:489:7daf:c237 with SMTP id d75a77b69052e-494527ee3camr39704081cf.45.1746794497299;
        Fri, 09 May 2025 05:41:37 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945258789asm12219771cf.49.2025.05.09.05.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 05:41:36 -0700 (PDT)
Message-ID: <dddfb517-d3ab-4b34-bc25-39d84400b5ce@gmail.com>
Date: Fri, 9 May 2025 08:41:36 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] man: Fix recover_zbd_write_error option description
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <20250509020250.483865-1-dlemoal@kernel.org>
 <jrfpm3ssqtb5fdtgc6cxijybc7v3rd422d4hwi7dbxmjhtmfz3@a5spjgqyrkb2>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <jrfpm3ssqtb5fdtgc6cxijybc7v3rd422d4hwi7dbxmjhtmfz3@a5spjgqyrkb2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 10:17 PM, Shinichiro Kawasaki wrote:
> On May 09, 2025 / 11:02, Damien Le Moal wrote:
>> Add a missing ".TP" statement after the zone_reset_frequency option
>> description to get the correct description for the option
>> recover_zbd_write_error as a new paragraph.
>>
>> Fixes: 650c4ad385cf ("zbd: add the recover_zbd_write_error option")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Thank you for finding it out. LGTM.
> 
> Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Applied. Thanks.
