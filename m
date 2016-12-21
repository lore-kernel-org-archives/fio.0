Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:36422 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754151AbcLUGFR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2016 01:05:17 -0500
Received: by mail-ua0-f195.google.com with SMTP id 2so7744940uax.3
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 22:05:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161220235638.35477-2-elliott@hpe.com>
References: <20161220235638.35477-1-elliott@hpe.com> <20161220235638.35477-2-elliott@hpe.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Dec 2016 06:05:16 +0000
Message-ID: <CALjAwxjFu6o4Eb+Vn4MEzKiRMYyLvYmWh6NEXQziNTYgWRh5hw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pmemblk: Clarify fsize is in MiB not MB
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Robert Elliott <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 20 December 2016 at 23:56, Robert Elliott <elliott@hpe.com> wrote:
> From: Robert Elliott <elliott@hpe.com>
>
> Clarify that the FSIZE argument is in MiB (power of 2) rather
> than MB (power of 10) in comments and variable names.
> ---
>  engines/pmemblk.c | 39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
>
> diff --git a/engines/pmemblk.c b/engines/pmemblk.c
> index 977a02b..62f3746 100644
> --- a/engines/pmemblk.c
> +++ b/engines/pmemblk.c
[...]
> @@ -39,22 +39,31 @@
>   *   iodepth should be set to 1 as pmemblk is always synchronous.
>   *   Use numjobs to scale up.
>   *
> - *   direct=1 is implied as pmemblk is always direct.
> + *   direct=1 is implied as pmemblk is always direct. A warning message
> + *   is printed if this is not specified.
> + *
> + *   unlink=1 removes the block pool file after testing, and is optional.
> + *
> + *   The pmem device must have a DAX-capable filesystem and be mounted
> + *   with DAX enabled.  filename must point to a file on that filesystem.
>   *
> - *   Can set unlink to 1 to remove the block pool file after testing.
> + *   Example:
> + *     mkfs.xfs /dev/pmem0
> + *     mkdir /mnt/pmem0
> + *     mount -o dax /dev/pmem0 /mnt/pmem0
>   *
>   *   When specifying the filename, if the block pool file does not already
> - *   exist, then the pmemblk engine can create the pool file if you specify
> + *   exist, then the pmemblk engine creates the pool file if you specify
>   *   the block and file sizes.  BSIZE is the block size in bytes.
> - *   FSIZEMB is the pool file size in MB.
> + *   FSIZEMiB is the pool file size in MiB.

It might be safer to explicitly say "in megabytes" rather than "in
MiB" here because of fio's infamous reversal of the terms M(B)/MiB
(https://github.com/axboe/fio/issues/103 ). Can the user explicitly
specify units as is done elsewhere in fio?

-- 
Sitsofe | http://sucs.org/~sits/
