Return-Path: <axboe@kernel.dk>
Date: Sat, 8 Apr 2017 11:05:00 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/8] Don't silently terminate td when no I/O performed
 due to error
Message-ID: <20170408170459.GB13541@kernel.dk>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Apr 04 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Some runtime configurations can cause threads/processes to terminate
> without any I/O performed, yet with no explicit error message, which
> is quite confusing. In the example below, fio finishes with neither
> error nor regular statistics due to file offset + bs being larger
> than the file size while in get_io_u().
> 
> This commit calls log_err() when this happens. Since it's difficult
> to tell the exact reason after thread has left the main I/O loop[*],
> it gives advice to use a command line option --debug=io, similar to
> the way td_io_init() gives advice.
> 
> [*] It can't just replace dprint(FD_IO, ...) calls with td_verror()
> for e.g. while in get_io_u(), since those are also used by non error
> paths too.

Thanks, applied 1-2, and 4-7.

-- 
Jens Axboe


