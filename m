Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-sn1nam02on0093.outbound.protection.outlook.com ([104.47.36.93]:7824
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755200AbcLVUuk (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 15:50:40 -0500
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 11/12] Improve IEC binary and SI decimal prefix handling
Date: Thu, 22 Dec 2016 20:50:38 +0000
Message-ID: <DF4PR84MB0169B1B22E420D242971ECCEAB920@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20161222060853.64104-1-elliott@hpe.com>
 <20161222060853.64104-12-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-12-elliott@hpe.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

> -----Original Message-----
> From: Elliott, Robert (Persistent Memory)
> Sent: Thursday, December 22, 2016 12:09 AM
> Subject: [PATCH 11/12] Improve IEC binary and SI decimal prefix
> handling
> 
...
> diff --git a/parse.c b/parse.c
> @@ -207,32 +207,50 @@ static unsigned long long
> __get_mult_bytes(const char *p, void *data,
>  		}
>  	}
> 
> +	/* If kb_base is 1000, use true units.
> +	 * If kb_base is 1024, use opposite units.
> +	 */
>  	if (!strncmp("pib", c, 3)) {
>  		pow = 5;
> -		mult = 1000;
> +		if (kb_base == 1000)
> +			mult = 1024;
>  	} else if (!strncmp("tib", c, 3)) {
>  		pow = 4;
> -		mult = 1000;
> +		if (kb_base == 1000)
> +			mult = 1024;
>  	} else if (!strncmp("gib", c, 3)) {
>  		pow = 3;
> -		mult = 1000;
> +		if (kb_base == 1000)
> +			mult = 1024;
>  	} else if (!strncmp("mib", c, 3)) {
>  		pow = 2;
> -		mult = 1000;
> +		if (kb_base == 1000)
> +			mult = 1024;
>  	} else if (!strncmp("kib", c, 3)) {
>  		pow = 1;
> -		mult = 1000;

The following added if statements are in the wrong place and really 
belong above.  Corrected in v2.

> -	} else if (!strncmp("p", c, 1) || !strncmp("pb", c, 2))
> +		if (kb_base == 1000)
> +			mult = 1024;
> +	} else if (!strncmp("p", c, 1) || !strncmp("pb", c, 2)) {
>  		pow = 5;
> -	else if (!strncmp("t", c, 1) || !strncmp("tb", c, 2))
> +		if (kb_base == 1024)
> +			mult = 1000;
> +	} else if (!strncmp("t", c, 1) || !strncmp("tb", c, 2)) {
>  		pow = 4;
> -	else if (!strncmp("g", c, 1) || !strncmp("gb", c, 2))
> +		if (kb_base == 1024)
> +			mult = 1000;
> +	} else if (!strncmp("g", c, 1) || !strncmp("gb", c, 2)) {
>  		pow = 3;
> -	else if (!strncmp("m", c, 1) || !strncmp("mb", c, 2))
> +		if (kb_base == 1024)
> +			mult = 1000;
> +	} else if (!strncmp("m", c, 1) || !strncmp("mb", c, 2)) {
>  		pow = 2;
> -	else if (!strncmp("k", c, 1) || !strncmp("kb", c, 2))
> +		if (kb_base == 1024)
> +			mult = 1000;
> +	} else if (!strncmp("k", c, 1) || !strncmp("kb", c, 2)) {
>  		pow = 1;
> -	else if (!strncmp("%", c, 1)) {
> +		if (kb_base == 1024)
> +			mult = 1000;
> +	} else if (!strncmp("%", c, 1)) {
>  		*percent = 1;
>  		free(c);
>  		return ret;


