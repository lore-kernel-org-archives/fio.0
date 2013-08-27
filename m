Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3H0RDL (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Aug 2013 13:03:11 -0400
Message-ID: <521CDBC2.8050705@kernel.dk>
Date: Tue, 27 Aug 2013 11:02:58 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Adds check for numberio during verify phase.
References: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
In-Reply-To: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>, fio@vger.kernel.org

On 08/26/2013 03:22 PM, Juan Casse wrote:
> We check numberio to detect stale blocks.
> 
> Signed-off-by: Juan Casse <jcasse@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> ---
>  HOWTO            |  7 +++++++
>  init.c           | 33 +++++++++++++++++++++++++++++++++
>  ioengine.h       |  1 +
>  iolog.c          |  1 +
>  iolog.h          |  1 +
>  libfio.c         |  3 ++-
>  options.c        |  9 +++++++++
>  thread_options.h |  2 ++
>  verify.c         | 10 ++++++++--
>  9 files changed, 64 insertions(+), 3 deletions(-)
> 
> diff --git a/HOWTO b/HOWTO
> index 005dac2..14ff8b5 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -657,6 +657,13 @@ ioengine=str	Defines how the job issues io to the file. The following
>  				filename, eg ioengine=external:/tmp/foo.o
>  				to load ioengine foo.o in /tmp.
>  
> +data_integrity_check
> +		If this option is given, fio will check the i/o number of
> +		each block read back during the verification phase. Fio
> +		checks numberio to detect stale blocks. Currently, this
> +		option requires synchronous i/o, and equal-sized read and
> +		write blocks. This option requires workloads that write data.

I think this use case is just too narrow. Why does it require sync IO
and equal read/write sizes? Can't you just replay and re-generate and
compare?

-- 
Jens Axboe

