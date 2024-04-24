Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA401BF31
	for <fio@vger.kernel.org>; Wed, 24 Apr 2024 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713984538; cv=none; b=kqntk5wxsgF0YogPufuuz+byLU7dRqIfDUL2F4qRIWvEW573SxmLQPhHuLDL/gWWglovAdsdbkFbg7tv0oSnKPawOUaMPperF8nfQVqXbsgS50xQkCs+nNx7CNX3HI/SBZPeKD+/vt6hjIK7py3ZfihkHRHF+B1L8Fv1B2dPI14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713984538; c=relaxed/simple;
	bh=Q1uLGt7kWGO1Gu5DfTQn+noKBrA7rxwspi4Jz+8QxxQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=EcgsI2Hr5ULIrg9fQD40kR7wKRr6ed4w70NDGRKyHyH0yApMgL3KpAjOo3pnnBWwR1MKR+e0BKUwxaNm+mEO0AcfT7Ey7aaeu92JCJz1B8mlH86mnvWuEJxhOPUjkTItNvG7mkyLfDvG5dHUi1wnJ8ZgemeeNscv7nbgo94LliE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lcg6XwHY; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lcg6XwHY"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dc236729a2bso240751276.0
        for <fio@vger.kernel.org>; Wed, 24 Apr 2024 11:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713984536; x=1714589336; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XpPu9avzyqjR/ZHrSBR5kJPTKVm4wPU08YjIlaaIn94=;
        b=Lcg6XwHYzgh65E0OqTc83ePNJUS7zi0u7cmx1kpgnby4D9YB1R6vsjpqbugTzMQS+t
         +Wd/mPdvLxpBbBc4ZAEOsCgXBNy1XAI3ceuIedqvH2Dh0re8uRvmF0ALr+gqFY8Gyxm5
         tyS03dY51e7iqvR9VB3TnO+f8VsuaZ69liraFkFCHDy+QdlEAppkWy6SLYzsCk2oKzYj
         IcYbrY2mAmUgfPGMtTGN/D5LK1j+87BFyt1Rvg7wUcpB8brIzINircD+OoTnkegGymzW
         q7wiZxnHQMeE4fDYURuNyREdhUuuGLeeKMohWT/jDvn5glIQdahwseFhlntZBiG3qEhz
         YnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713984536; x=1714589336;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XpPu9avzyqjR/ZHrSBR5kJPTKVm4wPU08YjIlaaIn94=;
        b=Blegth7dkgvnHyMY6FF5B5z16UbxGW1MXiybZxlvshe5Z4aDS+TMorgo9UFQTDTrar
         XBefxsUbBC7ldoCPMhNlssbuZlBQewmOFbtx4f8KG+QHNxMWSC4xZbiDINWKWJX21MSW
         okvfdMioC3jjUoWuuNUuE59eMWSfBOjq4HgOSmhV+qw81GzE+4LZcwhnPLtOS4zFfSn7
         9wlX7FdFV7Dd+kgwyX15elYayIuJFnih17yDU/PkvozOGWSNvSLp9PWD+ykE6aVYqKyd
         NvPi2mRdlVp2W7oKwl89LsvpJvfM6ZNM1qv/IAYf1qbCyPlY/E/XOqpQP9xfyQTUp0h9
         bpuA==
X-Forwarded-Encrypted: i=1; AJvYcCVQZ6gJA5yYNbifkRN9fJlQ4KOmNGB4a2waN7G4Lg+JiiUYSEFEy0J5qtAoL6EVS3XS/VxpxFjRkOmPV3ybNwmspJWO
X-Gm-Message-State: AOJu0Yzy4sCZaBXE5Wt3hBRmW3Vu780MVl8cgR59Gck9gCdHfU8gRYXQ
	R3u7U8Fb77btYuTo3JYlKUfA5XkNE/vpRZjTx6wd8BTVE1vtOmLc
X-Google-Smtp-Source: AGHT+IG3dGj8g3w7amZDzu8Dtv4Oln0Q2qvAdgkG8BYjs/8+b1qG0w9CZYWJHbDqI0+P/nD4ovgx2w==
X-Received: by 2002:a25:a2c3:0:b0:de5:52be:8375 with SMTP id c3-20020a25a2c3000000b00de552be8375mr3771186ybn.43.1713984536352;
        Wed, 24 Apr 2024 11:48:56 -0700 (PDT)
Received: from [192.168.1.206] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id a7-20020a0cca87000000b006969f5d3159sm6318591qvk.50.2024.04.24.11.48.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 11:48:55 -0700 (PDT)
Message-ID: <389390f1-04ea-4eef-b6e5-21bdc31f76e3@gmail.com>
Date: Wed, 24 Apr 2024 14:48:55 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] FDP tweaks, NVMe streams support
From: Vincent Fu <vincentfu@gmail.com>
To: Ankit Kumar <ankit1455@gmail.com>
Cc: axboe@kernel.dk, ankit.kumar@samsung.com, kbusch@kernel.org,
 fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
 <CAKi7+wco_sbPbWp3_V0p4UOzBXnaQ7KhvTnGcSbFy+VWZr899A@mail.gmail.com>
 <81569cbc-5849-4199-a0bd-d7cf255241b3@gmail.com>
Content-Language: en-US
In-Reply-To: <81569cbc-5849-4199-a0bd-d7cf255241b3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 11:16, Vincent Fu wrote:
> On 4/23/24 04:49, Ankit Kumar wrote:
>> Overall changes look good to me. I was thinking maybe in future we
>> should add a new group for all the data placement options, debug logs.
> 
> As far as I can tell the option groups are only used by gfio which has 
> not received any attention for a long time.
> 
> For debug logging it might be reasonable to have a separate group for 
> these messages.
> 
> Vincent

Applied with support for both options dataplacement and data_placement.

Vincent
