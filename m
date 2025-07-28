Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124001A23B1
	for <fio@vger.kernel.org>; Mon, 28 Jul 2025 21:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753738074; cv=none; b=G08BaZrFVJr+Uy0JXmL/RsBQT3VEVTZVUJ/UdK5AnEknX8rqKukXJ7SAH7M8nfclv2enHV2oqg2HNjJCJWtRohdUJN2qEoK3+oQrPE+FQVflyHnbod36tTCj6zMvEGhR7J43fKx3uryYGyC1oaMuVGDuc8G6soBeFi9Io3/iS/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753738074; c=relaxed/simple;
	bh=IBCypX3PVSAgwxUr5p4P4X4CoGioWFcYHsKhap35JQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hz1pddj9LtPs4+n+SETTDU1iVadUp613IAGRQzq+Vfy8J0av/kySHAcc6vn9wyDj+pzYTQJAtiw+1o90fwkowjKAIX6CcrRt6mGHBICdk2QbfBw1Uk+qdqrM4niraEuijjkpi0CSidPb03C7OjFnVGzMS4nrl6UpSfeygzxdQOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZP3rw2oB; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZP3rw2oB"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b34ab678931so3860432a12.0
        for <fio@vger.kernel.org>; Mon, 28 Jul 2025 14:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753738072; x=1754342872; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2l6w2hRKLWNHJDDuhsa7KTub3t/mEZk/1MVxj9AIMs8=;
        b=ZP3rw2oBXxWZSYJwWOWVsAmwM7S8E6lj+5AGJ5xHVybjDkRBpN8xA3YGl4zzZ7xa0n
         GSiPzGxy4xilEEI5lfiGZbREC0kiOe/BGSjCfHq33mla8ylyyaswgH3bB/iKVnjwqh1+
         0bc0fd/9ogo6rN+zO4aej41kMm62ekpXxz35ro6H1nZJ/d6D549plyIPrODtV68YLZCa
         xjMKrs4xW7d6OrKmoi45EcG2Caj99B8t9KXKiq+F6Id7pJyRQSiA+HleHwbfc7Rn5BKs
         eqGO2P4bZ2uw68q8IFQllTAt4mUBePVeuFS8KcyV84QUD5Si4Cn4MfTeiFNC7jM8WOqc
         5Aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753738072; x=1754342872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2l6w2hRKLWNHJDDuhsa7KTub3t/mEZk/1MVxj9AIMs8=;
        b=bN6polJ2hZ38CvNLJpA/dYgbe876M//Y0/hes1w1sVOZJMAb34pNV4X6EGecO4duCT
         S1LiWyl5czJg3RdeY6EYWThKaU5zaPHXfHAGNGVKtL1vpb4MQSJpmdC/H7K/ORvOobRd
         SdGh219eYNysrY0fxKFxSpRppfYdZOTHnvBnQ676Bv2TGCFq3HMCp5xxnuZA5dDU9wxf
         Qk+5dXRXt/+Hdbdz8TzSFtlHnYarc56/+IhY+cTAViClugcq0S7xJF9N9iV0PURt9INN
         sEKFyIc/Jm8zDfVYS4VQQ1RsdrWxi0QaXnv2Qi9wsGEG59AvAUZ1YN/F8WVgnmf41Yxa
         yuoA==
X-Forwarded-Encrypted: i=1; AJvYcCWvnPSZ/Wa0gs6x+JT7L66hoiSiVEb19DDQ3WglS77N5x43X/SpGYN7y2s5mfV3Z9KOL1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhwgDh0U+B8YuJC0Yx8hxTOObrfacoZ0j1eLi5564ZKMWhwc2c
	yeCDJJAyEBN4B4VWcsM/uYv5+GarI5zq0dHeyFf4W6KU//IM7ocXTUBl1azEeP1r26SqB9I2IfM
	oVcLYKgANJzBr0qmTiFKPv8slZW1G/q/Xnq93
X-Gm-Gg: ASbGnctFn2+87Y/KpsxCYGB1xfeCfaPDltmAYYMxCa/SGTBjWckmaEGQzLbSOavBmtD
	HsW7wCHFw+jEvotSMIqZPYqOJILQjFpyoJBKpXf6ilaOXim8z2y2EWrjNSx+a6S2LmJF6SlBBwx
	QAPnWFSW8XVOYNIM+6UiQJkvOP2dzjGS1nmRBWEB6tXK9L67J1GxxOjgl7YdLn1qg09oewHpJE2
	9nTmhL9KWh0CdR5Ta09W6T15jcG2RwehXTgx8iD
X-Google-Smtp-Source: AGHT+IEX/AiYGp9hFPpxIvpyMh868QHrN0MZf84sXyFC2S7PLoEXYCUIdfiqYKYlghXY+lSFAo7sotAbxV2VTKTiiwo=
X-Received: by 2002:a17:90b:35c8:b0:312:1dc9:9f67 with SMTP id
 98e67ed59e1d1-31e77841b4amr17577588a91.2.1753738072233; Mon, 28 Jul 2025
 14:27:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250725061748.2180898-1-mcgrof@kernel.org> <20250725061748.2180898-3-mcgrof@kernel.org>
In-Reply-To: <20250725061748.2180898-3-mcgrof@kernel.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 28 Jul 2025 22:27:25 +0100
X-Gm-Features: Ac12FXyFcQB4tpBhWEnZ4xp8EX5RV7Cl_cpR6GWQyWpJKvO6AQ2fI0lcTnq1C8w
Message-ID: <CALjAwxgo2O1sRw-DELeDbB5_RqPtO5Zt9rUR0OXpnkxmwW+5-A@mail.gmail.com>
Subject: Re: [PATCH 2/2] fio: add latency steady state detection
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: vincent.fu@samsung.com, fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Jul 2025 at 07:20, Luis Chamberlain <mcgrof@kernel.org> wrote:

<snip>

> diff --git a/HOWTO.rst b/HOWTO.rst
> index 55ebc388..c5e6a0ad 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -4154,6 +4154,18 @@ Steady state
>                         Collect bandwidth data and calculate the least squares regression
>                         slope. Stop the job if the slope falls below the specified limit.
>
> +               **lat**
> +                       Collect completion latency data and calculate the maximum mean
> +                       deviation. Stop the job if the deviation falls below the specified
> +                       limit. The latency values are weighted by the number of I/O samples
> +                       in each measurement interval.
> +
> +               **lat_slope**
> +                       Collect completion latency data and calculate the least squares
> +                       regression slope. Stop the job if the slope falls below the
> +                       specified limit. The latency values are weighted by the number
> +                       of I/O samples in each measurement interval.
> +

You'll need to update the man page (fio.1) too.

-- 
Sitsofe
