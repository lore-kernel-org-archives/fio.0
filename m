Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C430F13C676
	for <fio@vger.kernel.org>; Tue, 23 Apr 2024 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713886067; cv=none; b=XAVIN2h75v+VaGuSy261nWFQW0xPbvnjFEnWj9i996glyQKeMFEtasSywrIEXpmtXv4tqjjbz69KvRrfdgAG/TeLfpLtnzhf5Rd0aBNp1PubffNwghVpqs4VK26EwEYCRHticTY+bkvzJ5UqkBz89mgDR2Do0GfOlmnkluGXw2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713886067; c=relaxed/simple;
	bh=o9+ID1HxB/rCVdcy3kr73siUONP47ZUF+Nj36j0rsFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C9EwVsaQcaUlLAhSxpGDg2FbZcp0g5KR/hUE/do/DcO4J70vZ+XtF82b2/kLHUzwSjfR72jq7gtba2ex2xa8aGuaA57IenQq0i8CVvE/RrqqXpWamhZPl6LxrrMHPl3nGhwbIYYosCSiGaYTbTXOk6Gs2Fy8E30TwCihtz7KWh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ekJiPegg; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ekJiPegg"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-439656c1b3eso21305591cf.1
        for <fio@vger.kernel.org>; Tue, 23 Apr 2024 08:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713886064; x=1714490864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=azgxeZekA6SfB5tny0W35+ycRXg4+AcOFtxc8foD4IE=;
        b=ekJiPeggLqXZ6Js0jN53YkPdRv0SQOZgy6sV+n7w8lKXUSZNv18iGIStmmEC5wk7Fl
         aafJ7ysdzdbfspLG+JzHqa6gP0NUJxxuAnSTLVFsYVX4R/qruzG0TpGBpavqzUAIso0a
         d0REehj9uPaHFX1IbIoW6fpYx150TN+4sGPLL9kOhKAbm49gmO6gLDe9IP/99K4IT/fg
         o16knkJQcVKtwUGGXUQfWWYJE6oZ+Yt/6v/LEO8i2/GaN9VPV86WXNVyn4JxFEnLHl+T
         sjQ/EEWvu7k8ViGnrMCrpFItcjgJ8sAwyBHQlw9gO4qLUWnPwiq9vLEEdU2VpW9tyg16
         5kTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713886064; x=1714490864;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azgxeZekA6SfB5tny0W35+ycRXg4+AcOFtxc8foD4IE=;
        b=oCxvwvaTqmcF15N34zzg9HqArptHxhdLuC0NtO3gyVUJblQ+/TKDlxgVmOdoM/O7i8
         BwDUNh5Dv0mP2HI2afT2gW2W2lPffzrXiZyH4daxnakDOk9WsyOBN1FJktBG3SjptsSz
         xv2rfNn9U0lxJdWDIlrFkLEhXnruM/NUzVfYn/9nKWnN9VvQPAUrqBEJY3RTin8PGLKe
         aUmEHh9E0EjOQQCwRu5ovsdt+dcawkdtvQJxj8rbccvAdbZsm0chouMNHsCH0rs0A91s
         GzBDmw35peexOXNalzOw3gbbQFpfoi9i354LtQTCTgazLRROMc55tFS8FDb3sRv/HYct
         C+tw==
X-Forwarded-Encrypted: i=1; AJvYcCWTsWO56ofJqkYdLNPdsGJi9eIS2cYvX5ajRNcbUJ1wkCl4hD9chbbeBZ8JtKdjTcz1xQfMeSdGzNEUq4x+Nj/g/dEH
X-Gm-Message-State: AOJu0Yzbd0FRxcHXsyyCiyUGjD9B+8Fq0Og4tGsPIHNLgzp00NyO/RiB
	5kzgJgqRbRwlNyQBN0PsKP6nZB3SwjcRG+rqlA2hG87Ye96DACpv
X-Google-Smtp-Source: AGHT+IG3V1/un631hpp8ZqYxdV1SJfJGRilkLtog6EwdZE71Mqmfv06uRx1LhBpYkIoL16LeA9Yr4Q==
X-Received: by 2002:ac8:7d13:0:b0:437:bc88:e4cb with SMTP id g19-20020ac87d13000000b00437bc88e4cbmr17310766qtb.14.1713886064363;
        Tue, 23 Apr 2024 08:27:44 -0700 (PDT)
Received: from [192.168.1.206] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id t25-20020ac87619000000b00437a6e5b3fdsm4953209qtq.66.2024.04.23.08.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Apr 2024 08:27:43 -0700 (PDT)
Message-ID: <6922105c-4081-4f65-91b8-f578efc94953@gmail.com>
Date: Tue, 23 Apr 2024 11:27:43 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] fio: create over-arching data placement option
To: Ankit Kumar <ankit1455@gmail.com>
Cc: axboe@kernel.dk, ankit.kumar@samsung.com, kbusch@kernel.org,
 fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
 <20240422175522.4614-3-vincent.fu@samsung.com>
 <CAKi7+wcrvg4_ouCU2HUEWjA-TKwbTkc0xHjq5fGiufYw=hQWig@mail.gmail.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAKi7+wcrvg4_ouCU2HUEWjA-TKwbTkc0xHjq5fGiufYw=hQWig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Fio is not really consistent. From the first few options listed in the 
HOWTO we have:

numjobs
runtime
time_based
startdelay
ramp_time
clocksource
gtod_reduce
gtod_cpu

Supporting both dataplacement and data_placement would be easy to do.

Vincent

On 4/23/24 04:36, Ankit Kumar wrote:
> -               .lname  = "FDP Placement ID select",
> +               .name   = "dataplacement",
> 
> Wondering if instead of dataplacement we should use data_placement. I
> am ok either way.
> 

