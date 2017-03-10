Return-Path: <axboe@kernel.dk>
Date: Fri, 10 Mar 2017 14:44:04 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/17]
Message-ID: <20170310214404.GA30759@kernel.dk>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Mar 07 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> The first 3 patches are resend of what I've sent after 2.18,
> except that I've modified commit messages a bit.
> 
>   Add runtime handlers for 97900ebf for FreeBSD/DragonFlyBSD
>   HOWTO: Add platforms without fdatasync(2)
>   configure: Align help messages
> 
> Tomohiro Kusumi (17):
>   Add runtime handlers for 97900ebf for FreeBSD/DragonFlyBSD
>   HOWTO: Add platforms without fdatasync(2)
>   configure: Align help messages
>   Avoid irrelevant "offset extend ends" error message for chrdev
>   Fix debug print format of file ->file_name
>   Fixup for a minor 0 byte file size case
>   Explicitly check td_trim(td) to detect open(2) flag
>   Drop redundant td_rw(td) tests
>   Remove unassigned fio_unused variable
>   Drop fio_unused attribute from used variable
>   Fix a function name typo in debug print
>   Don't set FIO_FILE_extend when create_on_open= option is set
>   Minor fixup for "Layint out IO file..." message
>   HOWTO: Add some details for invalidate=
>   Define struct file_name as a file local structure
>   Use union for per file engine private data storage
>   configure: Make Cygwin take regular configure path

Applied, thanks.

-- 
Jens Axboe


