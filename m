Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC86C128387
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709654147; cv=none; b=gKT7fCaCvvoch8SZdDzssALugWxuZpBGqHZuWcFce3dAxZcoczvHf8HZ9eVcSkVPttrOByp9JAJq6jXhA+43cSP03WRsqYTGH5Ql4nsO2a/bXK6gVkfoTqUgtmVV+eD8h+ggxMfUh/WMcv9N/3SuZroCLyhtpdl1KUb8xZ/ueNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709654147; c=relaxed/simple;
	bh=dKx1troUZe7XzjwOIzRq0IIYbwz3rWsMCPjdG9lehpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DMGupbNvbEpmFwRhOsb09hMKKm9AffWEUouOk7Rp1v6ZTWejmVaivz/X00qwzfYN3k+Xj+Whf6BRdhnInFippvA6xNNmhXY3GlD5fM61QJgdTY2QEdiRYRCWDcIPQENyk4e0GUsdWtvGxbVqLZpaMJhXG08HOCVYQVL0ZNbVIkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Si7hbjxz; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Si7hbjxz"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-42a029c8e76so45293051cf.2
        for <fio@vger.kernel.org>; Tue, 05 Mar 2024 07:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709654144; x=1710258944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qS6qh+K4VReUVv+dnPxKApTZGxEOGjMdz4dYTgpUDx8=;
        b=Si7hbjxzYq+OdIpdjJJ1Y+CeiKFeim/YsDtjR1wcXSo1/AGopKHo4MzrtVivywBFcD
         HvgAEod3E/gK5B0Y4sac3s1BJRq4tGPimV9W61lU1bENHhq61j/SHk2DhpoQ7B+z062E
         2kCIS5Ko/zLaChZExb9LhnUG3Sb1ENZcZF2k0WD+LEJiLV6yKEbkM5/DSAWeH87Pldp/
         PK01zuNE3Owrkr3ovl84po+5wHEYrwolP8KH7AtX72FvOIe8slgdV012/Wk8BO1A5tKt
         REGB8PE+cQZ5oUiJq7bb/p09pBwLUqeLU/5SpygulaWQ9FljFcuZXUBHofw7lzpeziPB
         fs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709654144; x=1710258944;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qS6qh+K4VReUVv+dnPxKApTZGxEOGjMdz4dYTgpUDx8=;
        b=qCmS6NRZycPzFAftwn/GTpcovyXQvt9s6Yb7uic7rTBDnIGEkkfyEx3jzTF3YuxvOL
         C01yw1Pw3gDi5hsRf/O3bCtBqwHG/denLE3Mk00dzJWTUBLgp7hZTLEnoSe7YJvXIKP6
         hsTnDF4HnYonXgxCNC7fjCWSiYSePpqoUQ7bjikO3rly6q9JQWsfwjbOoqVrvmphezex
         N7S78IRQxS9pMwUlMhyoEukBXsnzmUL3tc6ruOYjaRk/C7ERzeTkchPBnywxj/FJ+1ay
         lUplp5spuscVjbyqCxJBoIQBUUMxooge2LiZv8iHiCLjn6VLTchEIkvyXn2SouE6ydQh
         yN8Q==
X-Gm-Message-State: AOJu0Yzk1Q/ohuKwJN62NCZ53JGdXYjfViop7XAYNbJ8hv1nFm6dejOc
	tUsqq/t+pj5EvDsRG3hyEXes+cRsM3dRaoLdhZ4sC4D5o1DJwqX+
X-Google-Smtp-Source: AGHT+IEvcG9yxipGueRvYzaNFWLlV7GHabHyuijcSa/ZaS9r+zokC+l5jfBY/I3W/3y7RadyfdK33w==
X-Received: by 2002:ac8:7fcc:0:b0:42e:ea2e:905b with SMTP id b12-20020ac87fcc000000b0042eea2e905bmr2746790qtk.14.1709654144428;
        Tue, 05 Mar 2024 07:55:44 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id m20-20020a05622a119400b0042ef530b49fsm1743962qtk.88.2024.03.05.07.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 07:55:43 -0800 (PST)
Message-ID: <a1002eb7-ef78-4a37-8cd1-aabd619d82ae@gmail.com>
Date: Tue, 5 Mar 2024 10:55:43 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] Some minor cleanups
Content-Language: en-US
To: Avri Altman <avri.altman@wdc.com>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org
References: <20240305090008.1216-1-avri.altman@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240305090008.1216-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/24 04:00, Avri Altman wrote:
> v2->v3:
> Attend Vincent's comments:
>   - patch 3/6 - remove
>   - patch 2/6 - fix typo
>   - patch 6/6 - elaborate example in man page as well
> 
> v1->v2:
>   - patch 5/6 - fix typo (Vincent)
> 
> 
> Mainly fixing typos, style issues, etc.
> 
> Avri Altman (5):
>    fio: Some minor code cleanups
>    t/jobs: Further clarify regression test 7
>    t/jobs: Rename test job 15
>    t/jobs: Fix a typo in jobs 23 & 24
>    Doc: Make note of using bsrange with ':'
> 
>   HOWTO.rst                                         | 4 ++--
>   backend.c                                         | 4 ++--
>   eta.c                                             | 8 +++++---
>   fio.1                                             | 2 +-
>   io_u.c                                            | 3 ++-
>   parse.h                                           | 2 +-
>   stat.h                                            | 1 -
>   t/jobs/t0007-37cf9e3c.fio                         | 5 ++++-
>   t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} | 0
>   t/jobs/t0023.fio                                  | 4 ++--
>   t/jobs/t0024.fio                                  | 2 +-
>   t/run-fio-tests.py                                | 2 +-
>   12 files changed, 21 insertions(+), 16 deletions(-)
>   rename t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} (100%)
> 

Applied. Thanks.
