Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174B6139561
	for <fio@vger.kernel.org>; Wed,  6 Mar 2024 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709743914; cv=none; b=JyQD4ub7wd0sFE7xGJA0OeT3BmMjkrGd3qUgZWuZ603bc2pu6SFpNRwDtmVRuxAZmyyqW/xFifV0SJr8N5C4sUZIs/nXAUcASAsFo1LWV0EBNg+sz92AKwplNQOuRjTa+Ulwo1L4v9iStIqP7BYCWRp94hg3MZXAIzpO0aZitOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709743914; c=relaxed/simple;
	bh=XhiaKMaKXHWIH2rYvipqJgjBQVp2JfzNx/aMVcFiEbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TTrc8qthVk3lAtca/aRzIOZpzCUOk5chrDRkDZZkgbywVc5bhe51+KTqefwojYWyAuuGxAt8yQb3MhvDl7oIioWbHClpA4TfAQZj3mf7RR6E1lOwfK0CwfwZXJQV1DPIo9MeXeGTwKgDEQSvy8XoI8KGjiZbODfyHTjHN9mu2us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e35pEJFM; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e35pEJFM"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7882b1e87c4so1399485a.1
        for <fio@vger.kernel.org>; Wed, 06 Mar 2024 08:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709743912; x=1710348712; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rv7W6FcBil2pP/opMj9x5D9I0oMK0msqNPFNf36ImFs=;
        b=e35pEJFMuhWBdF7VFbW/DSIZ44pJ69oqeZatIv/dKRkAKyYWvV54lLwORs9ssufstO
         M4qx4uKef0fiBuoO2IS3AHOMTDaL6qdLZpNR9eGPY2tnVUjMryQFNTaiPC5mVulzaenr
         B5mETcuJEHh9tnB6LvCuKhO0UIUFhhp35TT5XYi19OhAL/f5lcWQAgJY6MP+J+f3Yr20
         WxcNtc0xcW7Z+Br3PLs1tsva3ywfYbw1b8qZK3h7nw3WoNYwjXkk6Zbk4scGH8Rw1gly
         ysqIkYHiq7rQRPuLOg3JZlVTIjnN4PzZf7Ozn83gedNYC1UpJyoswTwFHN54Q0FFbeZ6
         04kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709743912; x=1710348712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rv7W6FcBil2pP/opMj9x5D9I0oMK0msqNPFNf36ImFs=;
        b=Xc3KedBI+BsFTai632LIsdrfsu9WD38pZSNTmOYmTWD531lIDSB06zvS3kqsgAt8x1
         jjcZGC8+9QPoLOBGY/UcnztyyAJ1CE/BGxxmEdtcgfvm2GUnzeq8O/GAfg2bFnoUNqSW
         mNgPcWFkZTTdLsJucZyBE993KFEapHFSey3f484yXSU+zVvStViV1YPH3Jv9y0Km3nlT
         LSPB+83aDB577SvWmqpz6H3PG3y/0hFAL60hS6DgLjJigjrG2mcb7hqzA/pCkCPLAFkb
         GQSmL5D3JlLIpHF6PPdd9hVC3u2Z5j9qZS28xj08IoFK19uwgEDzgecVbohlFsUroNbU
         l2cw==
X-Forwarded-Encrypted: i=1; AJvYcCXsEHmAB/KDzO6SKCilHVH5GKaprMxBHj4kPz25k+zAXhWzm2SAD5CmQji2q7PbnpMFYy9ASms66d5YVY7Qrc/2n/Dw
X-Gm-Message-State: AOJu0Yx0kS/7QQIt4bdFhzfoWdrlX6IgDnecBytK0xtb5Sb5Q/W1X/78
	UgbfZ6rSFoFoR10C4MQJBckoLJAepVA80Gye90FetulPR0Zpr6ZQ
X-Google-Smtp-Source: AGHT+IF0OFWwEZ7hPqzZRLta+bCbdM3cEJ9tOYtH+aP9iP+I4aBxe0kNd1RByx+AwYP/uM7uUPiQzw==
X-Received: by 2002:a0c:f883:0:b0:690:986b:dc93 with SMTP id u3-20020a0cf883000000b00690986bdc93mr1865710qvn.41.1709743911674;
        Wed, 06 Mar 2024 08:51:51 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ow1-20020a0562143f8100b0068c8be959a0sm7687874qvb.111.2024.03.06.08.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:51:51 -0800 (PST)
Message-ID: <bf389657-7c37-4fe0-8ca7-17aecebfef3d@gmail.com>
Date: Wed, 6 Mar 2024 11:51:50 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fio version change gives different throughput results
To: Thomas Weber <thomas.weber@de.ibm.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <3309778342f6bfdefe0b7a1de1fcddab10902c37.camel@de.ibm.com>
 <706651ae-3f53-4cc6-aa06-43a49f8e2078@gmail.com>
 <064bbd4dc5db416092090ce568ef8759744f46f0.camel@de.ibm.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <064bbd4dc5db416092090ce568ef8759744f46f0.camel@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/24 04:44, Thomas Weber wrote:

<snip>

> 
> Thank you. I noticed that fix as well in the fio changelog.
>  From the description it seems to affect only non-sequential IO.
> However I saw huge throughput degradations for both rw=rw and
> rw=randrw.
> 
> Do you think this is related to that bug fix too?
> 
> [smallstuff-seq-slow]
> rw=rw
> nrfiles=1000
> openfiles=25
> filesize=1k-1m
> bssplit=4k/20:128k/80
> rwmixread=60
> 
> [smallstuff-rand-slow]
> rw=randrw
> nrfiles=1000
> openfiles=25
> filesize=1k-1m
> bssplit=4k/50:8k/25:64k/25
> rwmixread=75
> 

The patch description mentions file_service_type != sequential but makes 
no comment about whether offsets are chosen randomly or sequentially. In 
fact the example job in the patch description chooses offsets randomly.

I tried your smallstuff-seq-slow job and found the following:

fio-3.25+ [1]:----- 424 MiB/s read, 384 MiB/s write
fio-3.36:---------- 384 MiB/s read, 347 MiB/s write
fio-3.36-97-g9b699: 517 MiB/s read, 467 MiB/s write

[1] fio-3.25 needs 382975557e632efb506836bc1709789e615c9094 to build 
with recent kernels

If you are able to reliably reproduce the problem I suggest that you run 
git bisect to identify the commit responsible for the difference you 
have observed.

Vincent
