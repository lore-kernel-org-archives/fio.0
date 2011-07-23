Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:55033 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1GWS7k (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Jul 2011 14:59:40 -0400
Message-ID: <4E2B1A16.20509@fusionio.com>
Date: Sat, 23 Jul 2011 20:59:34 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: bsrange doesn't accept separate read,write values
References: <4E2B18C5.3090602@evernote.com>
In-Reply-To: <4E2B18C5.3090602@evernote.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dave Engberg <dengberg@evernote.com>
Cc: fio@vger.kernel.org

On 2011-07-23 20:53, Dave Engberg wrote:
> The 'bs' and 'bssplit' configuration variables accept separate numbers for read and write operations if you separate them with a comma. For example:
> bssplit=1k/39:8k/50:64k/11,1k/29:8k/50:64k/21
> 
> The documentation for 'bsrange' says it works the same way, but if I try to specify two ranges with a comma, I get an error when I run the app. E.g. if I put this line in the configuration file:
> bsrange=1k-16k,2k-32k
> 
> I get this error output:
> 
> fio: pid=26861, err=22/file:engines/sync.c:62, func=xfer, error=Invalid argument
> 
> Here's my attempt at a patch for this:
> 
> 
> *** fio-1.57-orig/parse.c    2011-07-14 11:20:25.000000000 -0700
> --- fio-1.57/parse.c    2011-07-23 11:38:12.000000000 -0700
> ***************
> *** 453,458 ****
> --- 453,464 ----
> 
>             strncpy(tmp, ptr, sizeof(tmp) - 1);
> 
> +         // Handle bsrange with separate read,write values:
> +         p1 = strchr(tmp, ',');
> +         if (p1) {
> +           *p1 = '\0';
> +         }
> +
>             p1 = strchr(tmp, '-');
>             if (!p1) {
>                 p1 = strchr(tmp, ':');
> 

Does this actually work, do you get the ranges set correctly? bssplit
has a separate parse handler for the range.

-- 
Jens Axboe

