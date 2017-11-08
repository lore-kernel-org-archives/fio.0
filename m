Return-Path: <logang@deltatee.com>
References: <1510096473-2397-1-git-send-email-sbates@raithlin.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <05d890f7-5f61-4e4a-3753-b904ce54efc8@deltatee.com>
Date: Tue, 7 Nov 2017 17:02:21 -0700
MIME-Version: 1.0
In-Reply-To: <1510096473-2397-1-git-send-email-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rmda: Add bind option
To: sbates@raithlin.com, axboe@kernel.dk, fio@vger.kernel.org, renyufei83@yahoo.com.cn
List-ID: <fio@vger.kernel.org>

Hey,

This looks good to me except for one nit below.


On 07/11/17 04:14 PM, sbates@raithlin.com wrote:
> Signed-off-by: Stephen Bates <sbates@raithlin.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>


> +static int ntoa(struct thread_data *td, const char *host,
> +		     struct sockaddr_in *addr)
> +{
> +	if (inet_aton(host, &addr->sin_addr) != 1) {
> +		struct hostent *hent;
> +
> +		hent = gethostbyname(host);
> +		if (!hent) {
> +			td_verror(td, errno, "gethostbyname");
> +			return 1;
> +		}
> +
> +		memcpy(&addr->sin_addr, hent->h_addr, 4);
> +	}
> +	return 0;
> +}

Why is this function called ntoa when it seems to be doing aton? Typo?

Logan

