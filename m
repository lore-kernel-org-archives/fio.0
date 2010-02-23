Return-Path: <Ricardo.M.Correia@Sun.COM>
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Date: Tue, 23 Feb 2010 13:48:09 +0000
From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: Verification failures with mixed read/write case
In-reply-to: <20100223093610.GQ1025@kernel.dk>
Sender: Ricardo.M.Correia@Sun.COM
Message-id: <1266932889.3379.19.camel@cfslap.wizy.org>
References: <1266456009.19149.72.camel@cfslap.wizy.org>
 <20100223092849.GP1025@kernel.dk> <20100223093610.GQ1025@kernel.dk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yup, that seems to have worked.

Thanks :)

On Ter, 2010-02-23 at 10:36 +0100, Jens Axboe wrote:
> OK, so this seems to be just a bug in sha256, it's working as expected
> here. Can you try the below patch?
> 
> diff --git a/verify.c b/verify.c
> index 59f1ddf..c894b60 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -212,7 +212,7 @@ static int verify_io_u_sha256(struct verify_header *hdr, struct io_u *io_u,
>  {
>  	void *p = io_u_verify_off(hdr, io_u, header_num);
>  	struct vhdr_sha256 *vh = hdr_priv(hdr);
> -	uint8_t sha256[128];
> +	uint8_t sha256[64];
>  	struct sha256_ctx sha256_ctx = {
>  		.buf = sha256,
>  	};
> diff --git a/verify.h b/verify.h
> index c12bc7d..be98c54 100644
> --- a/verify.h
> +++ b/verify.h
> @@ -37,7 +37,7 @@ struct vhdr_sha512 {
>  	uint8_t sha512[128];
>  };
>  struct vhdr_sha256 {
> -	uint8_t sha256[128];
> +	uint8_t sha256[64];
>  };
>  struct vhdr_sha1 {
>  	uint32_t sha1[5];
> 



