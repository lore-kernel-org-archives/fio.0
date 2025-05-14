Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3081920F079
	for <fio@vger.kernel.org>; Wed, 14 May 2025 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220257; cv=none; b=ka00sxC5olmOgr8mreRmZC4Nc/JXeaDavnrfpMyszqu5t+BYwmTObkY+FovK9njBvpl5jMxXe+Up5A6m4Cktt+duBVqZnY3pDvw0J2kPn5yHBpq7UviJyAvJP2Pgml3A6E8My7E9gRutOo+05nMMeRSEDnVvbnTWe3m8+JnSKyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220257; c=relaxed/simple;
	bh=sokVOXuLEUUQSIPZP6KzabL6VhCb4dlxHPEyn13SZ4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=exsSzmYekOpdaS55ygbAAtYGopK01gQnbCAWalbyFxe+/nVsi0Uc5qMgUaoFuZdmW3cxhrtQ0Oo6GeXGLsRqfnyi16TZcxa/9VPLLOJmGEAuZiD8SeTQsaPeGJ6RrCcHWg+FcG/WEuhQSPMKhiOMLq5wsKLVF/69xIIYpsRtE5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=muAcPLR5; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="muAcPLR5"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7c559b3eb0bso448892185a.1
        for <fio@vger.kernel.org>; Wed, 14 May 2025 03:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747220255; x=1747825055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dT4y5DVV+ifkT82D3qpDoq1iS8fVLcw6zlB5GjP+hZI=;
        b=muAcPLR53AZIwT0vFuW7S0k2qQKg2i+QIAKltUbiiS5Y58JaMM3jMphynBz+E/wo11
         4lJBH5e6/nZy5PPxwDJcI8egUcdRstn5BU4W4HbVEtzdvrDStrInrcjexG7iYY2/PhaF
         b4QHuB/HSyGKJEqaw45WLI2mKAjSP1PgelFAVxB3yxWR0dripeFDJkZzh2Xd5m1+HE9P
         xRzlSzyLp7Nsi/vcNIuuSYU9Y0rg+Eq9d1+C/fXtg7AGze5ZHQdXF3w60jIGBrVArClm
         kmVDiEAM5d9slP/SY05yt6FkmaOZj8P0Xa2qj42Qqty9zkedcvWnPKF11x5dkVnUptNd
         GRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747220255; x=1747825055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dT4y5DVV+ifkT82D3qpDoq1iS8fVLcw6zlB5GjP+hZI=;
        b=T+FiBFHgWRsB3EScAQJeTF34Fudyhk5W/5+Phj+rhtwLhwIVobx9DMErJ4MEgqPSy6
         GMLhYqUeS65REokNtY2lLu079Jabl71GA1tV4g3vlJ8P6qK3fYdUtpGTHP4dLrY7Kmnm
         Xbs5f5E2vsltO2mXztRIVlVbayqrCWW5hLKq4TGj/MaG8eqWxnMwvVlwbE66/3kU6RHP
         dsVLX67Xk7IqrlPnrZOj+p0bCWahZBjLeEJQoln6ezt4zIIBfZH6FKJg/FLzU2hIX/aS
         diGuPQno3dfXrDZO1E0tngvT95f4WDeWTuk8/2exTm3M4Mi0PTJbZ0yhiyBPiuVZ8src
         Kzdg==
X-Forwarded-Encrypted: i=1; AJvYcCWtYt+wtzNlWTQ1DxcFfxaFxenJIXsi7Q1gywuCyIXMXfmjtP9ME4Ek2jEGtvCV4o6KgWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwypFFwv1QL2Z/DV/zjbS/dxlKI9+ZQMntzqESsthlu9ChlQBTq
	GNQGi2yaKArbLNZQXL/Wzy4G0CyO+eop4Oe2pEVIRnVsNgTDlb6mQz5Wt9En
X-Gm-Gg: ASbGncsLgEnIv33SlhQf+a1gUUl7OWs/Te6MP/V+3lFsSUbwKQ4++4Uy+j7Rvbj2Jup
	T/Ebf2BKWMc9mQt4jcbjA6GsdZrfb2bNzdlfSRLHEhSvgOghl4urFpfWzdnyVx3CnE3wDnIpeMD
	hy6V7fLgXbnADG6tQ9RpZAM0v03sBn/Ec8aPV6k6KOLfDI0RflFe1ebHs/2xudMUtXdY0Idb1Df
	BsWY4LacyRHGnO5YlRbd5y2dMwwumtJBFa2jiMTwWkC77QBoGz/5yAHUX+9hclfwniFppcJmmXI
	R7GIX8KVnKUIguB/L4gGixgqsb72WlTmMxYdglq0ctTi6cLcsRKpSU221wHtpduxCLe1Y95nyvL
	hX8r+AZagF/eyw4LG6cdqlHMqBgY=
X-Google-Smtp-Source: AGHT+IEvQ7KE1x7etZ33TGhv8dTjx17iU72RIqCyKocGgqU62DCATmFOeuWUR1fuLjSZSBdsiSPqfA==
X-Received: by 2002:a05:620a:4693:b0:7c5:9b12:f53c with SMTP id af79cd13be357-7cd287f9126mr407008985a.5.1747220254631;
        Wed, 14 May 2025 03:57:34 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f4e15csm836531985a.10.2025.05.14.03.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 03:57:33 -0700 (PDT)
Message-ID: <4369d6e2-48d4-43cb-965a-b376dc559dad@gmail.com>
Date: Wed, 14 May 2025 06:57:33 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] configure: Fix libnfs cflags and libs
To: Damien Le Moal <dlemoal@kernel.org>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
References: <20250514070754.38281-1-dlemoal@kernel.org>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250514070754.38281-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 3:07 AM, Damien Le Moal wrote:
> libnfs version 16 requires the gnutls library. Without specifying at
> least -lgnutls, builds fail:
> 
>    LINK fio
> /usr/bin/ld: /usr/lib/gcc/x86_64-redhat-linux/15/../../../../lib64/libnfs.so: undefined reference to `gnutls_certificate_set_x509_trust_dir'
> /usr/bin/ld: /usr/lib/gcc/x86_64-redhat-linux/15/../../../../lib64/libnfs.so: undefined reference to `gnutls_transport_set_int2'
> ...
> 
> Modify the configure script to add cflags and library options for gnutls
> to correctly build libnfs engine.
> 
> Also make sure that the CI install the gnutls library header files.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
> Changes from v1:
>   * Modified CI install action as suggested by Vincent
> 
>   ci/actions-install.sh | 2 ++
>   configure             | 4 ++--
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/ci/actions-install.sh b/ci/actions-install.sh
> index ad352317..30b815f3 100755
> --- a/ci/actions-install.sh
> +++ b/ci/actions-install.sh
> @@ -32,6 +32,7 @@ DPKGCFG
>           libcunit1-dev
>           libcurl4-openssl-dev
>           libfl-dev
> +	libgnutls28-dev
>           libnuma-dev
>   	libnfs-dev
>           valgrind
> @@ -106,6 +107,7 @@ install_fedora() {
>           bison-devel
>           git
>           flex-devel
> +	gnutls-devel
>           gperftools
>           isa-l-devel
>           kernel-devel
> diff --git a/configure b/configure
> index 715f0602..986eb0a6 100755
> --- a/configure
> +++ b/configure
> @@ -2361,8 +2361,8 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
>   if test "$libnfs" != "no" ; then
>     if $(pkg-config libnfs > /dev/null 2>&1); then
>       libnfs="yes"
> -    libnfs_cflags=$(pkg-config --cflags libnfs)
> -    libnfs_libs=$(pkg-config --libs libnfs)
> +    libnfs_cflags=$(pkg-config --cflags libnfs gnutls)
> +    libnfs_libs=$(pkg-config --libs libnfs gnutls)
>     else
>       if test "$libnfs" = "yes" ; then
>         feature_not_found "libnfs" "libnfs"


Applied. Thanks.

Vincent
