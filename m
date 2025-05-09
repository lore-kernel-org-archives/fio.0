Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A12291869
	for <fio@vger.kernel.org>; Fri,  9 May 2025 13:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746795733; cv=none; b=Zrocpq5VaqkHULAHq2eZfKYgERGoxpRXtGzrRPno3UuwcRKiwM8q0KNotRGYQa5hcdafL8QEzeoatOxpVOJ2MQAuuGUcFLSvtiWGq33LM6BOXzi5ZSBtpewJ+X7gAroQPa6S7X3Wzp1fna5VP69h27aYarJBSqZufuzfpFGb7HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746795733; c=relaxed/simple;
	bh=8r/8MbaV6enqbd72nfGcgOLmqCCt6hxrVHsaPprHHkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BD24KFuKAsEKqZxZOAtNCCwInZoCu3l/QQT7XRejEhmmHmhlNEMToTnLZRziK/U40joTnAlnnmG2amWZJ9BnQdcQMbI4HJOuWE2LG5vUFk4E76TxiDzIZ+ZmCXuJ8Po5w013bAk41fxzMZIycFT85RghfPW0pdz0LaY4hj4vjQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUpcVI+v; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUpcVI+v"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6f5499c21bbso40657496d6.3
        for <fio@vger.kernel.org>; Fri, 09 May 2025 06:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746795730; x=1747400530; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4m8tfrWkaZuUuFIQ4gKFJA6wuSfkp7R/u+4fA0+YNuE=;
        b=aUpcVI+viQVB0tzj7VEFPDrWgOEAv2hchAXXkjJJG0c5rQNpAptPXl2xM/IIsi9jlO
         9C8A26/QGpDLImBF5lXSVXpQG6VrMR0yrYY36hQUsgfJyCIMyAXiz9Ekgw711oQ8vmU7
         fHINBU9lMMfJfDAcZiqvqAiYGlDCfe0JwFK3D1YKmlO978eN6AlBGuF3LkHImO2SNgio
         DoOBD/b+PIDVIJPudA9wkeESaC7AGTolA6FFisgXbyvutmT84yAWLJtbzumVqoyC/T9d
         BxDHYOIh18/pRidvbnx7LfMU86Kka76S2yYpPhMp1B9FA26JH2Ft48m95CnAvX0r+/il
         C/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746795730; x=1747400530;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4m8tfrWkaZuUuFIQ4gKFJA6wuSfkp7R/u+4fA0+YNuE=;
        b=KHK+cN4/q9F7EHkM3Ume9HpDEnVuk3tHyhnwr1miksJshw1oHQzLrQ0wSvAgkMEEAM
         D1u504zhpVIyRpds6FHjcAM+2JEaMmNrxouCOZlP71cJuy0P/+w8A6Zugven3Myhoglr
         FkuaoBV5s+CsazKGofjwtDSPZfQj0/u8JI4qZ93sO04YpziTprdZHF3dMfiObSxeTgcc
         1ujlFBQRWCrqZTMUTSOHSs3wZ2ShxBSzrwhOM1YiXTEQhv03ep8e6klGxe4LWzDNcUT1
         pRILwjo+duhNW7g0jmz3wTH48W585PO1i4q55s8EqXxUtBPuG7SyFvjrBD6ZJdTQ9v3C
         mkHw==
X-Forwarded-Encrypted: i=1; AJvYcCUVdyFkZjRxNzSyn3hzpDLbY07RpBZIiGrDxDa8vpC8/dD839g8JmNeOxlW16CWh1VFoVE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsstT7KNkC7zzDYOoKwZK1tzMGGPTfHl4N/cDX+O27Lz5B62ys
	qVske7RESEIXYUYbGZtSHIuwj7Z3o9NoLZlZnLzDrNqMNnMv7jOIIolV3Hlk
X-Gm-Gg: ASbGncvE7aKu1ryD2Edqq8aZRlMZeuqXvEJjEsyraMtwWoQ5xDsimYGiuxf1lEZZ7lA
	i5oPJN5PWSO274ytobr1BeTMLKJs6izO0Z5PNTWJ7eF4ND4PybWC2EtL0r1uAXmBscYbTUqzOOb
	lxy8AsrybsgYsaIlIFdUUNJIHTizjkjvctd1JovgdpkkWFBJPre3YPYtJE+e+vIBlgF0DgLfBux
	a2KlGjWdnSyWQyMDIKMrQf/iSJmpaXZBwtP25p8+CE9br7gbpQE2foBEl9TV314Gj3j8qVPV3An
	5Ax0I7POgVdWehtrODQqCZFB0isgjBhvAAee9+jpKKo1LgWHPVORhcECgICVUp9eaGmlsQjM0TM
	k0P1if6KUo0SMY6lz
X-Google-Smtp-Source: AGHT+IHYfIEy3E7SS9+fz1KZKPhCOEStiExad2ususXHJeDYSmpBQYfousqC1M7Kxl6D1WZfpwjM1w==
X-Received: by 2002:ad4:5aa5:0:b0:6d8:9062:6616 with SMTP id 6a1803df08f44-6f6e47cb8cdmr51345596d6.7.1746795720887;
        Fri, 09 May 2025 06:02:00 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e3a472b3sm13230686d6.77.2025.05.09.06.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 06:02:00 -0700 (PDT)
Message-ID: <6c032491-06fd-4465-a051-6aaafb861540@gmail.com>
Date: Fri, 9 May 2025 09:01:59 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] configure: Fix libnfs cflags and libs
To: Damien Le Moal <dlemoal@kernel.org>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
References: <20250509095022.706951-1-dlemoal@kernel.org>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250509095022.706951-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/9/25 5:50 AM, Damien Le Moal wrote:
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
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   configure | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
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

The test builds fail because we do not install gnutls development 
libraries on the test platforms. Adding the diff below to the patch 
should resolve the failures.

Vincent

diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index ad352317..30b815f3 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -32,6 +32,7 @@ DPKGCFG
          libcunit1-dev
          libcurl4-openssl-dev
          libfl-dev
+       libgnutls28-dev
          libnuma-dev
         libnfs-dev
          valgrind
@@ -106,6 +107,7 @@ install_fedora() {
          bison-devel
          git
          flex-devel
+       gnutls-devel
          gperftools
          isa-l-devel
          kernel-devel
