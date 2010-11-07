Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:47559 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0KGLni (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 7 Nov 2010 06:43:38 -0500
Message-ID: <4CD690DF.6090807@fusionio.com>
Date: Sun, 7 Nov 2010 12:43:27 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: RFC: Data pattern buffer filling race condition fix
References: <201011061035.18709.bvanassche@acm.org>
In-Reply-To: <201011061035.18709.bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Radha Ramachandran <radha@google.com>

On 2010-11-06 10:35, Bart Van Assche wrote:
> On multicore non-x86 CPUs fio has been observed to frequently reports false
> data verification failures with I/O engine libaio and I/O depths above one.
> This is because of a race condition in the function fill_pattern(). The code
> in that function only works correct if all CPUs of a multicore system
> observe store instructions in the order they were issued. That is the case for
> multicore x86 systems but not for all other CPU families, such as e.g. the
> POWER CPU family.
> 
> As far as I can see this bug was introduced via commit
> cbe8d7561cf6d81d741d87eb7940db2a111d2144 (July 14, 2010).
> 
> I'm posting this patch as an RFC since the fix is GCC-specific.

ppc is notorious for its weaker memory ordering. I do have a ppc test
box, but haven't used it in a while. But it used to find bugs
immediately for race conditions, that x86 would never trigger. So since
you are pin pointing that particular commit, you are convinced that this
bug manifests itself due to bad ordering between the filled buffer and
the fill length?

> diff --git a/verify.c b/verify.c
> index ea1a911..3826198 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -31,18 +31,27 @@ void fill_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u
>  		fill_random_buf(p, len);
>  		break;
>  	case 1:
> +#ifdef __GNUC__
> +		__sync_synchronize();
> +#endif

You should be able to use the fio included write_barrier() and
read_barrier(), which are hooked to the architectures. Then you don't
need to use GNUC additions.

-- 
Jens Axboe

