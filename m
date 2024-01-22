Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E67F38DF1
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 19:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705953360; cv=none; b=YS7eeCkkmnk8tWiWW1AUysmR4M7w6WWVkS7n2zaFbVjDWo9/AWoMgAiiblNNZiWZnE5PL9JDqhH8ZCLjUbvcdmwtW0QVmVs+wIv+q1iZOKARga9NBXzgyzWzdpeEBGO7dpnnEba8FaIgCPlKrL1OmmGGHOBCe7EZmW9M2g/HQxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705953360; c=relaxed/simple;
	bh=qC8Ya03B42Ohc7Bk8McjVZWWItTEGyU+zCdIN2vPvPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfkMN1HFn0ufnQ2ft+8ORAV0UOv8z/ABOXKNaichkrKwrgD+oNYwlk2QxSsl6YRm6tC3uM+PP72t+PSqI73fbQzk4sRZIkv/Kx7DVoEb7ZYV2+a1ICZ1wUV0MsUgmw5im3iOI4XmE60lBYDhYTRHoBvdwYGVowMvCA2Uimr8spY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFWRkYy/; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFWRkYy/"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-683cabd96ceso21440556d6.3
        for <fio@vger.kernel.org>; Mon, 22 Jan 2024 11:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705953358; x=1706558158; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PIp1+XC60OEtvfRF5MgxvWosCiusB/H2CQaeig7zIro=;
        b=gFWRkYy/WEjFM5LnUQ/aWEYhqmDwKu2xJA8SP1dbYEOmKnr6uo7PM+wWznlkMYn5a4
         RPHUWuxKBao6qWjiZ4uR7wy8yoq6Nw/CFYLMzaDSgkuswUePpXd0JLIJ6cd1RdPcMPM7
         rYGwTeyHrhfBEA/2aB7tm88/nlU47hTpWD3aRehEdhTnXKhDq3MWyMtSYNgA+o6fLGFv
         wEXPfVIGOwx/NPvJ0ErPSgKq3hu2QB7h4ouNuRPCMpNdALGPZ9mM8qSbgAih9zgWDk5b
         ntBiT53xlSvniG+mtBJh6zK2Z46xn6TwD/ty+JjIxUirFi31+fVJusYu30eI3AutyZCJ
         fIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705953358; x=1706558158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PIp1+XC60OEtvfRF5MgxvWosCiusB/H2CQaeig7zIro=;
        b=drZIjO5585FulGrXQNyoKKKwK9Ma40Zf084F1EQSB0mHBMj5zhvnnSYw5Kir70/Hif
         mOA4+Bl/AvRbtjYg1xQ9fI/q+eVbKXnamOrwkynHru/m4MvVs3gnu71pzhk8nVJkryI4
         C8StYvAU9C5spwqkPpV+8f+77hCG4G/d2jMg8zkA2xCNC7GMdpYEgz5QOtPZcqsA1CCh
         75InLen9JtLFzRhGYVkOzjnfIDmbNEF7QLDPom+GJe3zCsYn8sGeLYlHfa7jcVrmt50X
         JiOHe91L3vtUbBAmzArV6BzOyiaiexMGf6XOSTuLT+s5GFTk/DmItjndpU/VdWi/1dAH
         rfUQ==
X-Gm-Message-State: AOJu0YwDHB+tcxvxWIK3KiN+6ZcPXIMd+y0L3LNYT6kLn0iXaziE6wbj
	/wY8ixQYIJ9Hj+1htu8FT736Ih57sp6b5jpYLIP3MibMkcH7a2t2Cdq/mwYe
X-Google-Smtp-Source: AGHT+IFv767ECHtlbzb+frl1zuoXKOrBR50QdkM9/b1heEg8Zbf+xO5rfX3ClJyW3xFzhDHupzU5rA==
X-Received: by 2002:ad4:4ee3:0:b0:686:9499:bacf with SMTP id dv3-20020ad44ee3000000b006869499bacfmr1276898qvb.118.1705953357936;
        Mon, 22 Jan 2024 11:55:57 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id v14-20020a0ced4e000000b006819adbc9f1sm2685901qvq.43.2024.01.22.11.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 11:55:57 -0800 (PST)
Message-ID: <daae86e3-5b80-4990-a30d-4924d52f1e39@gmail.com>
Date: Mon, 22 Jan 2024 14:55:57 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] stat: log out both average and max over the window
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Ankit Kumar <ankit.kumar@samsung.com>
Cc: fio@vger.kernel.org
References: <20240122112300.47805-1-ankit.kumar@samsung.com>
 <CGME20240122060525epcas5p17d417303b27a454e1db288a61e0642fc@epcas5p1.samsung.com>
 <20240122112300.47805-2-ankit.kumar@samsung.com>
 <6f3a1f7e-29cd-4e58-af00-9d1be93261b3@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <6f3a1f7e-29cd-4e58-af00-9d1be93261b3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/24 13:17, Jens Axboe wrote:
> On 1/22/24 4:22 AM, Ankit Kumar wrote:
>> Modify option log_max_value to report average, max or both the values, by
>> setting it to 0, 1 or 2 respectively. There is no change to existing log
>> formats while reporting only average or max values.
> 
> That would be much cleaner as a posval instead, where it takes a textual
> description rather than magic 0/1/2 values.
> 

You could do what was done for continue_on_error, which it seems was 
also originally a boolean that was later expanded to have other possible 
values.

Maybe even change the name of this option to something like 
"log_lat_value" and retain the original name as an alias.

Vincent
