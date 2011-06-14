Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45869 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1FNT64 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Jun 2011 15:58:56 -0400
Message-ID: <4DF7BD7D.3040708@kernel.dk>
Date: Tue, 14 Jun 2011 21:58:53 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add fallocate_keep_size option and functionality
References: <1308080427-31011-1-git-send-email-egouriou@google.com>
In-Reply-To: <1308080427-31011-1-git-send-email-egouriou@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Eric Gouriou <egouriou@google.com>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Daniel Ehrenberg <dehrenberg@google.com>

On 2011-06-14 21:40, Eric Gouriou wrote:
> Linux offers fallocate() and the FALLOC_FL_KEEP_SIZE option as
> an alternative to posix_fallocate(). When FALLOC_FL_KEEP_SIZE is
> specified for an falloc request going beyond the end of the file,
> the requested blocks get preallocated without changing the apparent
> size of the file. This is is a commonly recommended use of fallocate()
> for workloads performing append writes.
> 
> On systems where FALLOC_FL_KEEP_SIZE is available (i.e., Linux at this
> time), this patch add a fallocate_keep_size option, which is off by
> default. When *both* the options fallocate and fallocate_keep_size are
> set, then fallocate() will be used with FALLOC_FL_KEEP_SIZE set,
> instead of the default posix_fallocate().
> 
> Signed-off-by: Eric Gouriou <egouriou@google.com>
> ---
> I tried to follow the existing style and practices. I am wondering
> whether introducing 'fallocate_keep_size' is the best way, or whether
> I should have changed the existing 'fallocate' option from a boolean
> option to a string option. Let me know what you think.

Perhaps we could use just the one option, and have 0/1 retain they
meaning and add "keep" or something as the new variant. Other than that,
just one comment:

> diff --git a/helpers.c b/helpers.c
> index 377dd02..0da2fd7 100644
> --- a/helpers.c
> +++ b/helpers.c
> @@ -14,6 +14,11 @@ int __weak posix_fallocate(int fd, off_t offset, off_t len)
>  {
>  	return 0;
>  }
> +
> +int __weak fallocate(int fd, int mode, off_t offset, off_t len)
> +{
> +	return 0;
> +}
>  #endif

Say we have posix_fallocate() and not fallocate(), have it call
posix_fallocate()?

-- 
Jens Axboe

