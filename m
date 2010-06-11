Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41460 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab0FKHTP (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Jun 2010 03:19:15 -0400
Message-ID: <4C11E372.6070401@fusionio.com>
Date: Fri, 11 Jun 2010 09:19:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: weird error check for aio_cancel
References: <20100611043346.3B7A771AC5@kuma.localdomain>
In-Reply-To: <20100611043346.3B7A771AC5@kuma.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: fio@vger.kernel.org

On 2010-06-11 06:33, YAMAMOTO Takashi wrote:
> hi,
> 
> please look at the following patch.
> 
> YAMAMOTO Takashi
> 
> Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> 
> commit e7aa7a65700932fe68d96015c06e6e1b1ecea0da
> Author: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> Date:   Fri Jun 11 12:32:42 2010 +0900
> 
>     fix a weird check of the return value of aio_cancel.
>     
>     i don't know what this 1 means in the first place but at least
>     it isn't portable.  instead, check if the i/o has already
>     completed. (AIO_ALLDONE)

You are right, that looks like a genuine bug. The last case of
AIO_NOTCANCELLED should be ok, the caller should use normal completions
to reap the remainders.

I'll apply this.

-- 
Jens Axboe

