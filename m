Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:43039 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZEMFuA (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 May 2009 01:50:00 -0400
Date: Wed, 13 May 2009 07:50:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] fio howto typo fixes
Message-ID: <20090513055001.GX4140@kernel.dk>
References: <4A09D7CF.2050707@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09D7CF.2050707@oracle.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: fio@vger.kernel.org

On Tue, May 12 2009, Randy Dunlap wrote:
> 
> Fix a few typos in the fio HOWTO file.

Thanks, applied!

> ---
> 
>  HOWTO |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -Naurp fio-20090511/HOWTO~fix512 fio-20090511/HOWTO
> --- fio-20090511/HOWTO~fix512	2009-05-11 01:37:33.000000000 -0700
> +++ fio-20090511/HOWTO	2009-05-12 11:25:57.000000000 -0700
> @@ -230,7 +230,7 @@ description=str	Text description of the 
>  		dump this text description when this job is run. It's
>  		not parsed.
>  
> -directory=str	Prefix filenames with this directory. Used to places files
> +directory=str	Prefix filenames with this directory. Used to place files
>  		in a different location than "./".
>  
>  filename=str	Fio normally makes up a filename based on the job name,
> @@ -250,7 +250,7 @@ filename=str	Fio normally makes up a fil
>  opendir=str	Tell fio to recursively add any file it can find in this
>  		directory and down the file system tree.
>  
> -lockfile=str	Fio defaults to not doing any locking files before it does
> +lockfile=str	Fio defaults to not locking any files before it does
>  		IO to them. If a file or file descriptor is shared, fio
>  		can serialize IO to that file to make the end result
>  		consistent. This is usual for emulating real workloads that
> @@ -303,7 +303,7 @@ fadvise_hint=bool By default, fio will u
>  size=int	The total size of file io for this job. Fio will run until
>  		this many bytes has been transferred, unless runtime is
>  		limited by other options (such as 'runtime', for instance).
> -		Unless specific nr_files and filesize options are given,
> +		Unless specific nrfiles and filesize options are given,
>  		fio will divide this size between the available files
>  		specified by the job.
>  
> 
> 
> 
> -- 
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe

