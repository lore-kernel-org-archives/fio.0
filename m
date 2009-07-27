Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:34679 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbZG0K2l (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Jul 2009 06:28:41 -0400
Date: Mon, 27 Jul 2009 12:28:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Verify pattern & header meta data
Message-ID: <20090727102841.GB4148@kernel.dk>
References: <66dfd3fe0907231233u53c30fe7l20c4b1103459292c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0907231233u53c30fe7l20c4b1103459292c@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Thu, Jul 23 2009, Radha Ramachandran wrote:
> Hi,
> Is there any reason why during the verify phase, when the pattern
> verification is on, there is no meta verification done. I see why
> doing pattern verify followed by a crc/md5/sha verification can be
> redundant, but I think it is useful to have meta verify check even if
> there is pattern verification just to confirm that the data was read
> from the correct location as expected.
> If this is reasonable I have a change to check meta data after pattern
> verification where applicable:
> 
> 
> >git diff
> diff --git a/verify.c b/verify.c
> index 84fc015..3c8997a 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -482,6 +482,12 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
>                                 log_err("fio: verify failed at %llu/%u\n",
>                                         io_u->offset + hdr_num * hdr->len,
>                                         hdr->len);
> +                       /*
> +                        * Also verify the meta data if applicable.
> +                        */
> +                       if (hdr->verify_type == VERIFY_META) {
> +                               ret = ret | verify_io_u_meta(hdr, td,
> io_u, hdr_num);
> +                       }
>                         continue;
>                 }

It looks like an oversight, I've added your patch. Thanks!

-- 
Jens Axboe

