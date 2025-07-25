Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059071C5D44
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753465493; cv=none; b=i6w5K4X4lEcg4OyiCwQvhIKXmjy0BprgjYAIiyJl91IlwMrzLyKRiNicqGuK16g3uagD/ME/QC4VvWsPTYJ/lMOv2Y7NUHTivBA97Yb2Y4HsmZZsZrwRkrBnxqLb3LtEMEmGCfEOTyVH4n/TijKheoPgdutxmQD3Qnd1+Fw48w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753465493; c=relaxed/simple;
	bh=h/oucMaBZlxAkxEZKYgsLTHAyB900RVABfyQ0b4U90c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lH/uUZhBnGfsFIVWWRFDf4ztH+AmetIOmPCd7wsp9WYzC9SP8IhyxXr1gcj1fcSuuip3zsbkqGXh37CFSLtddZSIy3/xmvAQmk6UnmFAJLQ1GJraTpARSoSOZqZ+t2lpNnK4y7I3LfdMRm166HNCOYFkZFYYMj/Bt9R6WfmdBQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cCLA4q7y; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cCLA4q7y"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e29616cc4fso207731885a.0
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753465491; x=1754070291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ek250HasfgzgTCFNS4UQ2OBKYpeH78aRXvlI91/Oajk=;
        b=cCLA4q7yyJEMxU6pFROKOpDWU/IXtzcXnuMfZ2MT7J1usI+eJJ1Sc4qv09HHVb064l
         xKb7GVJGSCgEoAsN5JW4Al9aZ+d8v6JBmqV6VnW1xx227OBf9w3mBDH8toZ2GpeOPsuu
         T7P2Iou+M4MAsWQHtcaGpaftk/coaXnSqCjwIiflIT5X0CT4Z9NwEStUAIaPw3p0PgU2
         f8ugWehgHh79R4wBsPRXSSPszeDbzopiY/uyDv0Q20el2J32/Mn77C4WQ3gzFTTgVySJ
         hFRFVm+3o+I8JdEEbDR4rOA8R2msxdfehjJ2a860V3SvTz7jZAkGKMHYw+e948ijKpnt
         nejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753465491; x=1754070291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ek250HasfgzgTCFNS4UQ2OBKYpeH78aRXvlI91/Oajk=;
        b=o410rFdxv2imUlTsf9vI5iTuL1Grmwh01Zfs2yHwoYYnzaIUHFt9ndnnmxUViuppXs
         OWXJ5BRauC/FKp9pkb/Gv1ev2GWSNxx1li6xSjvZ/IJOJEhn/lU2FZWvGlX41pNB7KDk
         ZwBUZGLY+VaXxXB8OlPHNEvJBma2V4M1IfjNFW51bQy+qhEmC1Txcli6Id880BGNqGG9
         SjgXFoIcGanTN/x2s9mgPPtFuAKoNOrDPpQjae7kOwhUEefUfQzhFiHsUdgHIfEQtYge
         uNgFxo8rLBC4i3Bg4k/bql0oeulrYnrxT9eQCj5cL1QoQWi38+rHPFy2+wNEI5yar8+c
         jk1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUXQW5Ss+Ml8NCQaDn3mm0b4n/BEjDyJEJE3Bn5SZyiVuRQEJSI3euJ+f2u52gMJ922GYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBIy4QhzjWuVyUoD3aYLSRBqJjibBNMCAhuF6sX9TI5biR2dVa
	05TCL2Gp0btW03ZKX8cXHjPLGfoWxCaTQJl2xAtFGZChDSF+UmeW+WKX
X-Gm-Gg: ASbGncs4NEHhjAEKbZJRpFszDRw/gWMH+AkGrMZy3c7zRgHD13ndROJrpp7x4lL/4cR
	xFSDn2CWZF1juYmfX9+LwOKGc5PG74rrIKzuDe6m94CDiaVqMGlSxaXKgcNgRiIVcL7Kq6ZVDTK
	0lxlu+5/wtNj20EApjCCy7+7LwmPjMMe7H99rMlJ7GllpdV9nG0S6FxwUQWrx1Zebigmht5otIA
	oSLt33FPX4ojL1dpVsAW9cLzCRv1FglBYMNV65hh2yebQRrJtC+V7rXIXqC+fjjTyNle1x22o/6
	+3mwaaGQXv6mQGVzZPaTjCdjUWZ9nMXL3BLs4kytvhhsXuFYG2dOJOHVjMl4FjbsliGhmlN6b1w
	yt7Vem75YRkiR9S7JC4WTOcA9MyD8M7xb59nH+TrTIM0nvhbb80jVTkHm5WNx5C0DU/mcmWM=
X-Google-Smtp-Source: AGHT+IGwgtcf8h+AyufUsRZliPchz41Xag8b+snhnV0ICyOxWZHgUqLXIM+hwP1M4F8Jsaf2G9PQYg==
X-Received: by 2002:a05:620a:8327:b0:7e6:2915:c127 with SMTP id af79cd13be357-7e63bfba1ffmr260885085a.50.1753465490608;
        Fri, 25 Jul 2025 10:44:50 -0700 (PDT)
Received: from [192.168.1.211] (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e6438799f9sm21492285a.54.2025.07.25.10.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 10:44:49 -0700 (PDT)
Message-ID: <db1480d0-eafc-48a1-bcbf-50a06c25a6ff@gmail.com>
Date: Fri, 25 Jul 2025 13:44:49 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] configure: libnfs + gnutls
To: Luis Chamberlain <mcgrof@kernel.org>, vincent.fu@samsung.com,
 fio@vger.kernel.org
References: <20250725061748.2180898-1-mcgrof@kernel.org>
 <20250725061748.2180898-2-mcgrof@kernel.org>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250725061748.2180898-2-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/25 2:17 AM, Luis Chamberlain wrote:
> The problem is that the configure script tries to get both libnfs and
> gnutls flags together, but gnutls is missing. Let me check the configure
> script's logic and fix it:
> 
> The configure script is trying to link both libnfs and gnutls together,
> but gnutls is not installed. Let me fix this by modifying the configure
> script to only require libnfs:
> 
> Generated-by: Claude AI
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   configure | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/configure b/configure
> index 9e69dc4b..1769ef38 100755
> --- a/configure
> +++ b/configure
> @@ -2359,8 +2359,8 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
>   if test "$libnfs" != "no" ; then
>     if $(pkg-config libnfs > /dev/null 2>&1); then
>       libnfs="yes"
> -    libnfs_cflags=$(pkg-config --cflags libnfs gnutls)
> -    libnfs_libs=$(pkg-config --libs libnfs gnutls)
> +    libnfs_cflags=$(pkg-config --cflags libnfs)
> +    libnfs_libs=$(pkg-config --libs libnfs)
>     else
>       if test "$libnfs" = "yes" ; then
>         feature_not_found "libnfs" "libnfs"

The gnutls requirement was added via

https://lore.kernel.org/fio/4369d6e2-48d4-43cb-965a-b376dc559dad@gmail.com/T/#t

I can think of two ways to resolve this:

- Make sure gnutls is installed when building fio
- Modify the configure script to detect whether or not gnutls really is 
needed by libnfs and set up the flags accordingly

Vincent
