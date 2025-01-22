Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A064C14D6F6
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737562575; cv=none; b=Z9XIQBdVF6unYrWKOrlfvSVhNyaBVH3hoFcCxJnS0MOO1LyWk2f2B4esZf4SOoJbHzFPsGZ1dYWtN+Ai5EH1+aM90GJsdvRRg5CTztseF2Nt0VsDZ8Bw1Lh9yvBy/hBRo6+hve1T1ga44HpW/qknxKwJ5pfPeyyMrbw8E1L4aTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737562575; c=relaxed/simple;
	bh=iRW3MqqMQd2vVpQz9TuGHlrTqwiHjWtOZI7gUXaLLBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1lqEcgrproKMFlxb34z69Q4+95k0BxHmnw1wXU8WdobFa6atl1pBof6DKyawfe1Vej8YQfSZgx3LMIRIeRWHfrJV0tQD55hNIsFZiO5mFk7TkEU/SOq+YK5ifUlTSt1IS/PqgkvLFpN7t2QrlSYOVnKlQUqOC0LAQ7yT4PBPGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3Xrqm6T; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3Xrqm6T"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7be6fdeee35so413035385a.1
        for <fio@vger.kernel.org>; Wed, 22 Jan 2025 08:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737562572; x=1738167372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zXd3fB282I1atwSzvwHgqxGBT6mKHKBqaF6p6OT/R5I=;
        b=Q3Xrqm6TJUrQVinoBk7tZRTFtHyNxZpNsk2+HChgDdf3Cp+h5+XkiX5eOQXrZGW2P6
         2ZYcLe1+lDP94yZdSM7UYq8SezK3qckdLWfOgTJgYlR2iYCbXEzDCkguqnAU+mpcHtU8
         n6Sx/YzZFO/W1f7SmpmmzT73mJtj7wNjLNFNfrwK27TvzpSlckGZfSPyLJYCpYTiWEFB
         UGsSjP+dYPKbrtXDkw5jtyVM98lyCjw+H82r/7bXAgR7EJoR67TxN03ToCEvT27ciRWC
         5qDZ0O+H4RblayjqNbA/MbR0ksm4sHk1dLEkbacH8Wou6y9Cw/vJV1ahnqU+khrW4bE4
         RevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737562572; x=1738167372;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zXd3fB282I1atwSzvwHgqxGBT6mKHKBqaF6p6OT/R5I=;
        b=w1I+x6JusZjgrRdfawrJ156P8YizlbYaSH7Mpep6GPTvoduSN3f8AI73Tcp5ibiczA
         0zTGtU5w6OZ6hK8PthGYpUQNLpVIVld/6DQqZCCCUA6zVB7uU0jQnif9Cx2+L9IqRRUY
         FlYvt/lrmdFWbhdfQWChH6STI2jE6UoTXIb2XSWBohqnexdwS4mongynFnbCeXKRT8iE
         ovn+dlOHqqN8unZlycA0EB+Tfqt8vjg2WivomOYEsz2nBqkMZHqTnp5SLqg6Y/1ZYP8D
         dnJRrsnDbwO45cEfZj5XKSlBzBbAMFw5Sil4QZDKRhFs8jboGE7iWL9F7Y6hmtGb2V+F
         MDxw==
X-Forwarded-Encrypted: i=1; AJvYcCVd0ex/HxjaqJgVqBsc95GhEtGAyo85yYx49wqnecIRBZpEN8Ax/DosudZj/i14HFWOc0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGvw6MBLGNBHcHh6/KEtDdoW07Pakq+XQs3Di3txCal2siUJs0
	ewWOYavniMSeyS9Jz2mz1bviTRZF5DyWstneOVuLGq9vYo2o0SYa
X-Gm-Gg: ASbGnctY+FBwJwL1YqH5P2XE8Y1+uH/MefxOJwZ+DcyEU9wTKaAn8wYb8gFFzDjpYhj
	PzZU9vT3rrQ9kOzeglOE86FExHaG27LygwjJmNJWTq5rYwAI0Xcx4eMavBqeTTC3OQkI9rDFU1P
	oqKsB667YW1JGq7sVIjno+bWazMEHWbE+N6/MzWPVALyFBQ0Qm6QDoAjHlQG80i5Kkjj/yeJek6
	TW26z1Lp46VT+woVM8hU/QuZ3nHwgmS0lG8x+MReeqSJO1k9lMOo+I2gmSOzZ9rZPQ7OGIpgMND
	qWFB6+s/dtQbPkL/xS6WoKXT4bgaaFp3lk/mEKIs/R1l0V7fIfwl2/5S
X-Google-Smtp-Source: AGHT+IHvbGZLM8+TIB3CD6mqjFnOq4BWgLhyKcSj1/PP7ojOHzyu70yOu9TZWaJkjecRbz+HIz3Z+g==
X-Received: by 2002:a05:620a:2a0e:b0:7b6:d079:748f with SMTP id af79cd13be357-7be6325df6emr4703981185a.54.1737562572402;
        Wed, 22 Jan 2025 08:16:12 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614ef2bbsm674632485a.107.2025.01.22.08.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 08:16:11 -0800 (PST)
Message-ID: <e6b1b453-d185-4ca8-91f2-302333875999@gmail.com>
Date: Wed, 22 Jan 2025 11:16:10 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] zbd: fix open zone status check for non-write jobs
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <niklas.cassel@wdc.com>
References: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 8:38 PM, Shin'ichiro Kawasaki wrote:
> Currently, fio checks if each zone within the IO range is in an open
> condition or not. This check is done even if the job does not perform
> any write operations, and causes confusion among users.
> 
> This series addresses the problem. The first patch fixes it, and the
> second patch adds a test case to confirm the fix.
> 
> Changes from v1:
> * 1st patch: added Fixes tags
> 
> Shin'ichiro Kawasaki (2):
>    zbd: do not check open zones status and limits when jobs do not write
>    t/zbd: add test case to confirm no max_open_zones limit check
> 
>   t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
>   zbd.c                  | 10 ++++++++++
>   2 files changed, 39 insertions(+)
> 


Applied. Thanks.

Vincent
