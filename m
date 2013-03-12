Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44745
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362Ab3CLMPj (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Mar 2013 08:15:39 -0400
Date: Tue, 12 Mar 2013 13:15:09 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Android: add ioprio support
Message-ID: <20130312121508.GN25165@kernel.dk>
References: <513EB3E5.7020209@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513EB3E5.7020209@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

On Tue, Mar 12 2013, Aaron Carroll wrote:
> Also fix a build warning due to unused variable in some configs.

I applied the ioprio part, is the other bit against an older series?

> diff --git a/engines/net.c b/engines/net.c
> index 624ff15..abb8412 100644
> --- a/engines/net.c
> +++ b/engines/net.c
> @@ -490,6 +490,9 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
>  			return 1;
>  		}
>  	}
> +#else
> +	/* avoid warnings */
> +	(void)optval;
>  #endif
>  
>  	if (o->proto == FIO_TYPE_UDP)
> @@ -553,6 +556,9 @@ static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
>  			return 1;
>  		}
>  	}
> +#else
> +	/* avoid warnings */
> +	(void)optval;
>  #endif
>  
>  	reset_all_stats(td);

optval is only inside the scope of the ifdef. This was changed with
commit 6264c7a8 as of Feb 28th.

-- 
Jens Axboe

