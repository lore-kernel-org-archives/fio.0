Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354CA1A7047
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724951284; cv=none; b=JvXXUPM3qtYZlsRRgcvRUOvHpkRU4G4ZzCR6sNdCdCVVqAT+rX3DhGxsezjU9FaR0cbU96N0pl3cDuhoZQMKT1mL6kZ5I1lG4Yr/Uems8nKQocmywAvbiwHexZAHWOd114fUVtfhaLmE4hn2xh3amzQpUwYH3J9oISgePSqMekA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724951284; c=relaxed/simple;
	bh=VQrGRtlW9qwjMvL4AoVRxQqeGQLjBYd/Y0XpNVxP9Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hv4zADJmCRYg4HHHqkB9R+AGnspo43Rw8Z0JRkAqzc+YvtOrJGmTVMohqezhQH86c3OVtJbpObAwBgC+G1dJG9x5ZsGyS4Rf19bnyTNA5s/6aFRpkzjTF6QyTYoAn5kSZtUNGRrJqoIR/zXOvaPzqcUPTmTv+yL50Qn9xbqpM1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDsU4TZa; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDsU4TZa"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5df96759e37so650247eaf.2
        for <fio@vger.kernel.org>; Thu, 29 Aug 2024 10:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724951282; x=1725556082; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LuQ5iDfnCNDM9h6dMTQyhIigQD/lF6scgKELplW+ISs=;
        b=lDsU4TZa9UVZLqOn+kGXdn5VDAsQfidoUw5HO0+hoWnjRMSSw043w1PxCAMWYZUdhG
         qe9DIeie3fuCcGzGlWz8dGCmOhDJn2z4xaBWTmE9ms2b71tQ+yPOLL59nzFDiESngluL
         qpNmeaIDB8bXK/Ot7Q7VKZzi+BAQQ9pCz+XuJ1hiQH2WUt1pzijvOdgESuNcE2SjDx4T
         mRzGnOuj6WFfesn4V5U9F2vkokczP94bqUHLf+sU2/0SY7+RbLfXTvRsAZpmnnpRzuwF
         upwUfywiaycb8EY7YyfZbY20TDknVAmF5ayVASJJtl/vxWF6hlYDwCczz+h6/pWhlEtw
         PNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724951282; x=1725556082;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LuQ5iDfnCNDM9h6dMTQyhIigQD/lF6scgKELplW+ISs=;
        b=aKK6q7i+WSkbAS42Xyt7h/wQ1iTBQlffu5LA81EFGWRx0NAuqB7X7doXhSwHPmjEoN
         cPhbbZSq+uE18MGIUOkieLB0hwkZCkngQrWH5R6S/fg1X3IGTh7EiTRW/xnfV1/gna4U
         688xTADiwi3AILvhY+iR9BxIGQB7hUEX+YzN/1m3mcqZY8eRSvb2LQ35pXwvbgTElCaW
         JYouZekgoRTqzHuavUzoYMWMdF9dcAc0foUvCfNmPRBlEn/VCRy51moA073Gh15ahr+L
         5DLUm1ErTNrfKE+10OGszXtQC2o0kizZETsL5N8WL0V/1uP6pFKbDDfz8qn54hSB+SpN
         DsfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdPd/Kiv7DuJ61Bs1CbAlplSlaACP5cUmTNKnSXTGSwRqyrRACA94vFfPZAXxiqRy0Y3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNIWzfO9pmnNTUFtftaFpG600PSxp2X/C71uAXZAA8rBCJsBJ+
	PrJ9pm97XkWazQS6Oq1XrOEdHqE6yZ+EbsiiykXwXhV6z67UO7Pj
X-Google-Smtp-Source: AGHT+IEB/kOwgCxGLoxT+fsRYQvl9b9SMREgly/7uQsH6HYmc0Raf0rtCM1nfpkHf2BpZZdgPgwMyA==
X-Received: by 2002:a05:6358:7e14:b0:1b5:a157:27c9 with SMTP id e5c5f4694b2df-1b603c3af1dmr364873655d.15.1724951282077;
        Thu, 29 Aug 2024 10:08:02 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806d5dd0bsm67078785a.107.2024.08.29.10.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2024 10:08:01 -0700 (PDT)
Message-ID: <92796926-3f8b-4172-8443-4e4c1322c4b1@gmail.com>
Date: Thu, 29 Aug 2024 13:08:00 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] t/jobs/t0033: add test for the log file format
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Nick Neumann <nick@pcpartpicker.com>, Damien Le Moal <dlemoal@kernel.org>
References: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
 <20240829085826.999859-9-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240829085826.999859-9-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 04:58, Shin'ichiro Kawasaki wrote:
> Add a test to check the log file format which is described in the "Log
> File Format" section in HOWTO.rst. Generate log files using combination
> of options relevant to log files, and check that lines in log files have
> the format expected. This test helps to confirm that the changes in the
> log file related functions do not cause regressions.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

<snip>

Our automated tests now pass with the updated tests in this and the next 
patch:

https://github.com/fiotestbot/fio/actions/runs/10612135131

The only failure is unrelated to these changes.

Vincent

