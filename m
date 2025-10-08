Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE719230BD9
	for <fio@vger.kernel.org>; Wed,  8 Oct 2025 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759933139; cv=none; b=sC2SBhWW1fOX/b83mqRKqsUejuuYoBcFSMZiVJm13TIM6PD6BIK5OHaU/XTV9gmQtctoJbDxk8N4J+8dZ8/z8sOSMd+D554weyoLPZ2rqRY1JJ3NIcM71/JWX1x3Mt3eqRw+Xkciq1Axsv3yzfGYu0g5tmDKc1WewL6CKFkU44Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759933139; c=relaxed/simple;
	bh=4mveAhK0fANaHg20YdQpPmBbN6J2LeFOz52jK5sZXFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GP5FZBz9GhhsuvH+ttDHWdmqSkBGU3zMGAc7INS9IVybdsg/cnOz/0GajVj9VzNBUe07ahjxJsYI5sDXO6hM5wtwGVcmjjSNOixKcb5APEYsryElWIvXM5ulyksTGNIOZA+m4zpi8QhzIucWnbh0f8wZTJuiLov9iv6yzFDx9os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XndclLFa; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XndclLFa"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-93ba2eb817aso441097439f.2
        for <fio@vger.kernel.org>; Wed, 08 Oct 2025 07:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759933136; x=1760537936; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uaAvxivCqXD11Hk/u2l3CVt9LG+TBJYTBlwVmSfRrEk=;
        b=XndclLFa1tWhbdXYwINWG3Ou1EpUE5vR5fUN1edz1P2YCnHLq0GNLSfDlD0BdxTL8h
         NYDuqu6e0WFWlO1XNSGC3zSi4I+J18OIfSR+kGablzVLdA3i9sloXcg9tqHJuRx3yVRS
         TLLWO98k64JfglPs3VPOVRVwYN5G1WF00sQntwm2+jjPdBwD5Vw7v5C32G8WymnMaAVv
         8nMMZhnP5ApM2mJQoXq1SjqmbvUf9Dfm8XTYnmxoxpT2hBAWQH+o7xxBH2Gh9JmgGc+J
         T/0dhXEDXgH5lvvH76bC0WUZrFGbp5LsRSNpeN31mSEz/ywJrW/AOoaCg3UlvNfybpqk
         HywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759933136; x=1760537936;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uaAvxivCqXD11Hk/u2l3CVt9LG+TBJYTBlwVmSfRrEk=;
        b=HaVS/N/QiL1AUkhzZOmxx+lCU6etD9rmuAfRK+o8BbqB8sv6RnTB9SUZ0T5STzQA+z
         ig/Emsk+eSsoLp79lwodEYTMHISKeYbPgzGltsum9USeUV7tXWgFqcygO0CwLvx//RBs
         HBQN1Ftqtk/HOPDtbEYRuOegs5CVLggjLJrVRh81ADfYjM1BJ/g94ABxGv/mkvlUC8+2
         gkEhu46FDkLosle8YDRFlSVgTDFhVONriqes3GbMj3+2buMDTX4ttwi6Mho4x6ntKT88
         hfsj7hHgdG+wwLDTDSLJQ8cWYvwf+cr8GPHnHcax3BwS49DxqFXUYRWfxnIuXKiTZZDn
         Xi4g==
X-Forwarded-Encrypted: i=1; AJvYcCWcP88s18xqF75m7QEaWJOLNzTFCltE6/mFV1F1xnEzXLtVYD5Ypn0spUFsJolZUsyaRFU=@vger.kernel.org
X-Gm-Message-State: AOJu0YybJnkTFJIve0XIljdeYBhZjWb37ugs2hgHD4G/9Y+iVQLxNdmU
	t7hnmA8EFuecIXNhrBih7xBC9n7WvibEtJtwo/wKEFKeapfV+PUBHaTvVRpQHUCIp/uV2uX7WUq
	B7/oZ978=
X-Gm-Gg: ASbGncsOhZRFJHaB0nC3Mm/oMv9xKA3UO3HDfYuRwmkpy0Nf640xWdt0QYMy3NtUKxC
	QJqKhCAscKC8d52ioXnvi2bbDpeg1jhfr+TEMYY/5o0S72+MzIP2F+mVgoSRB9UNy7jUa5VU2+m
	ymVbWMezvGGVIRg2jneakSVY1/BkqonUHIt0sXwwV2NE8vjcheVt0BHWOzQK+yH4gZt2GiVo7V2
	Yw+iFH7ERY+UftKQCzItL4FRJhJM0ETep1jY+DWHkaspeiXaatogFesMkFAr+of2AMYFSCzZxnn
	6JcbowPtJH47kWNaIY5b46AF86uC78qS7K/vjJ4cV4KyrKuCoajmV7hSAH4lcCmIHAxyZNczI69
	YDH2C5oN+xw436TmDrtkMEgY7zSnHWfUvcYcUpOOI+vE=
X-Google-Smtp-Source: AGHT+IEB8SG1z9FLIRP0J4tgmX+eARJRyXiKf3jS2MPa9/y2qdw2QDQ6GM6+C0WLC9u5TbLRfcb6mw==
X-Received: by 2002:a05:6602:2d81:b0:8e3:2d3d:9a7d with SMTP id ca18e2360f4ac-93bd19a9a40mr387354639f.18.1759933135523;
        Wed, 08 Oct 2025 07:18:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93a7d81c743sm670713739f.6.2025.10.08.07.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 07:18:54 -0700 (PDT)
Message-ID: <12d613cc-d77b-4efb-99da-94c67a33a0ff@kernel.dk>
Date: Wed, 8 Oct 2025 08:18:53 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] stat: report zone reset count only when zonemode is
 set to zbd
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
 <20251008094847.1628954-2-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251008094847.1628954-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/8/25 3:48 AM, Shin'ichiro Kawasaki wrote:
> Currently, fio reports the zone reset count regardless of whether the
> zbd zonemode is specified. Reporting the zone reset count lacking the
> zbd zonemode is irrelevant and unnecessary.
> 
> Suppress the zone reset count report unless the zbd zonemode is
> specified. For that purpose, introduce the new flag "count_zone_resets"
> to the struct thread_stat. To maintain 32-bit alignment of the struct,
> repurpose the existing "pad3" field to allocate the flag. To group the
> related fields together, move the field "nr_zone_resets" and
> "latency_depth" within the struct. Make corresponding adjustments in the
> relevant functions fio_server_send_ts() and convert_ts(). Set the flag
> count_zone_resets only when the zbd zonemode is set, and the workload is
> write or trim. Refer to the flag in show_ddir_status() to determine if
> the zone reset count should be reported. Also refer to the flag in
> sum_thread_stats() to decide if the nr_zone_resets field should be
> summed up.

This one needs a FIO_SERVER_VER increment as it's modifying thread_stat.

-- 
Jens Axboe
