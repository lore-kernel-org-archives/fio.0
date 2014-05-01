Return-Path: <daniel.gollub@t-online.de>
Date: Thu, 1 May 2014 10:05:40 +0200
From: Daniel Gollub <daniel.gollub@t-online.de>
Subject: Re: [PATCH] crc/test.c: fix include of time.h
Message-ID: <20140501100540.6f9e18c0@marvin>
In-Reply-To: <53617267.8070909@bisect.de>
References: <1398883696-12041-1-git-send-email-danny.al-gaaf@bisect.de>
	<5361647E.6090904@kernel.dk>
	<53617267.8070909@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, 01 May 2014 00:00:07 +0200, Danny Al-Gaaf wrote:
> Am 30.04.2014 23:00, schrieb Jens Axboe:
> > On 04/30/2014 12:48 PM, Danny Al-Gaaf wrote:
> >> Replace include of time.h with renamed fio_time.h to fix build.
> > 
> > Thanks Danny, applied. Mine still builds fine, for some odd
> > reason... But it of course needs fixing.
> > 
> 
> It seems it was the same strange issue for Daniel.

In my case (Ubuntu) the multi-arch packaging of glibc caused this:

[...]
25441 open("crc/../gettime.h", O_RDONLY|O_NOCTTY) = 4
25441 open("crc/../time.h", O_RDONLY|O_NOCTTY) = -1 ENOENT (No such file or directory)
25441 open("/usr/lib/gcc/x86_64-linux-gnu/4.7/include/../time.h", O_RDONLY|O_NOCTTY) = -1 ENOENT (No such file or directory)
25441 open("/usr/local/include/../time.h", O_RDONLY|O_NOCTTY) = -1 ENOENT (No such file or directory)
25441 open("/usr/lib/gcc/x86_64-linux-gnu/4.7/include-fixed/../time.h", O_RDONLY|O_NOCTTY) = -1 ENOENT (No such file or directory)
25441 open("/usr/include/x86_64-linux-gnu/../time.h", O_RDONLY|O_NOCTTY) = 4 
[...]

I guess the same is true for all Debian-based distros doing multi-arch packaging like this.

Thanks Danny for finding this!

Best Regards
Daniel


