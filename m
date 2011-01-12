Message-ID: <4D2D5D76.10008@fusionio.com>
Date: Wed, 12 Jan 2011 08:51:18 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio make
References: <20110112050003.3FF6837A2F5@kernel.dk> <CB423058-1F05-4521-8488-DB9C8A84FAE3@cscs.ch>
In-Reply-To: <CB423058-1F05-4521-8488-DB9C8A84FAE3@cscs.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "N. Harake" <hussein@cscs.ch>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2011-01-12 08:45, N. Harake wrote:
> 
> I am getting this error while running the make, any ideas would be appreciated 
> 
> user@server:~/fio-1.41> make
>     CC gettime.o
>     CC fio.o
>     CC ioengines.o
>     CC init.o
>     CC stat.o
>     CC log.o
>     CC time.o
>     CC filesetup.o
>     CC eta.o
>     CC verify.o
>     CC memory.o
>     CC io_u.o
>     CC parse.o
>     CC mutex.o
>     CC options.o
> options.c:1143: error: 'SYNC_FILE_RANGE_WAIT_BEFORE' undeclared here (not in a function)
> options.c:1148: error: 'SYNC_FILE_RANGE_WRITE' undeclared here (not in a function)
> options.c:1154: error: 'SYNC_FILE_RANGE_WAIT_AFTER' undeclared here (not in a function)
> make: *** [options.o] Error 1

Please update to the latest released version, 1.44.3. If it happens
there as well, I need to know more about your build environment (distro,
version, etc).

-- 
Jens Axboe


