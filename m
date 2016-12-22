Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-co1nam03on0104.outbound.protection.outlook.com ([104.47.40.104]:57115
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761774AbcLVUJh (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 15:09:37 -0500
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 10/12] Clean up unit prefixes for binary multiples in
 comments and prints
Date: Thu, 22 Dec 2016 17:35:52 +0000
Message-ID: <DF4PR84MB0169BBF0A908AF0C05A5C948AB920@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20161222060853.64104-1-elliott@hpe.com>
 <20161222060853.64104-11-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-11-elliott@hpe.com>
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
> Subject: [PATCH 10/12] Clean up unit prefixes for binary multiples in
> comments and prints
> 
> diff --git a/goptions.c b/goptions.c
> index b3d3684..be49248 100644
> --- a/goptions.c
> +++ b/goptions.c
> @@ -826,7 +826,7 @@ static struct gopt *gopt_new_str_val(struct
> gopt_job_view *gjv,
>  				     unsigned long long *p, unsigned int
> idx)
>  {
>  	struct gopt_str_val *g;
> -	const gchar *postfix[] = { "B", "KB", "MB", "GB", "PB", "TB",
> "" };
> +	const gchar *postfix[] = { "B", "KiB", "MiB", "GiB", "PiB",
> "TiB", "" };

That has PB and TB backwards, and should fix it to:
+	const gchar *postfix[] = { "B", "KiB", "MiB", "GiB", "TiB", "PiB", "" };


---
Robert Elliott, HPE Persistent Memory


