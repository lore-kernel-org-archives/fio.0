Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3JPOg6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Oct 2013 10:36:58 -0400
Message-ID: <525EA43A.6010004@kernel.dk>
Date: Wed, 16 Oct 2013 08:35:38 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] client.c: fix free of wrong pointer
References: <1381916247-9947-1-git-send-email-zhiguohong@tencent.com>
In-Reply-To: <1381916247-9947-1-git-send-email-zhiguohong@tencent.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hong Zhiguo <honkiko@gmail.com>, fio@vger.kernel.org
Cc: Hong Zhiguo <zhiguohong@tencent.com>

On 10/16/2013 03:37 AM, Hong Zhiguo wrote:
> Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
> ---
>  client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/client.c b/client.c
> index b20d6dc..1fefda8 100644
> --- a/client.c
> +++ b/client.c
> @@ -625,7 +625,7 @@ static int __fio_client_send_ini(struct fio_client *client, const char *filename
>  	if (len) {
>  		log_err("fio: failed reading job file %s\n", filename);
>  		close(fd);
> -		free(buf);
> +		free(pdu);
>  		return 1;
>  	}

Thanks, applied!

-- 
Jens Axboe

