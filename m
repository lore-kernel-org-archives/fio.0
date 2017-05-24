Return-Path: <axboe@kernel.dk>
Date: Tue, 23 May 2017 20:03:09 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5]
Message-ID: <20170524020308.GB26621@kernel.dk>
References: <20170523184449.48134-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523184449.48134-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, May 23 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> These are another cleanup patches to make it less OS dependent
> (less Linux dependent).
> 
> Tomohiro Kusumi (5):
>   Move {is,load}_blktrace() to a new header blktrace.h
>   Drop struct thread_data dependency from os headers
>   Drop circular dependency in log.c and lib/output_buffer.c
>   Move Linux/ppc64 specific cpu_online() to os/os-linux.h
>   Include sg headers in os/os-linux.h

Looks good, applied, thanks.

-- 
Jens Axboe


