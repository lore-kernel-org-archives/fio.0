Return-Path: <axboe@kernel.dk>
Message-ID: <52F95D7B.1000002@kernel.dk>
Date: Mon, 10 Feb 2014 16:15:07 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio 2.1.5 release upcoming
References: <20140206192135.GB3950@kernel.dk>	<CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>	<20140209205744.GB2750@kernel.dk>	<CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>	<20140210221420.GD4096@kernel.dk> <CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>
In-Reply-To: <CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> To be honest I'm not sure how to apply a patch.  Thus far I have only
> used release versions of fio.  Do I need to get fio from git, apply
> the patch, and then compile?

The easiest would be:

$ git clone git://git.kernel.dk/fio

Then save the patch from mail in a file, eg /tmp/patch. Then do:

$ cd fio
$ patch -p1 --dry-run < /tmp/patch

If the patch command spews any errors, the most likely explanation is 
that your mailer mangled it somehow. You can try and add -l and see if 
that makes patch happier, it'll ignore white space then.

Assuming that worked, just do:

$ ./configure
$ make

and re-run with ./fio and your job file.

-- 
Jens Axboe

