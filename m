Return-Path: <axboe@kernel.dk>
Date: Tue, 28 Mar 2017 15:14:57 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 01/13] Fix return value of make_filename() when no
 filename_format
Message-ID: <20170328211457.GA29326@kernel.dk>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Mar 28 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> This is unlikely to happen in the first place since ->filename_format
> has a default value, and option parser can also detect an empty string,
> but it should return buf which is sprintf'd right before returning.
> 
> A caller expects this function to return filename string (which is
> buf arg itself in this case), and it also doesn't handle NULL return.

Applied 1, and 3-13. Thanks!

-- 
Jens Axboe


