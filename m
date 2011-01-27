Message-ID: <4D4135F7.2080600@fusionio.com>
Date: Thu, 27 Jan 2011 10:08:07 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20110127050004.1AE9737A304@kernel.dk> <20110127085159.0000478f@unknown>
In-Reply-To: <20110127085159.0000478f@unknown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2011-01-27 09:51, Bruce Cran wrote:
> On Thu, 27 Jan 2011 06:00:04 +0100 (CET)
> Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>> +#define POSIX_MADV_DONTNEED	MADV_DONTNEED
>> +#define POSIX_MADV_SEQUENTIAL	MADV_SEQUENTIAL
>> +#define POSIX_MADV_RANDOM	MADV_RANDOM
> 
> These are already defined on OpenSolaris 2009.06 and cause redefinition
> warnings.

I wonder why that was broken on Solaris, I'll add an ifdef check.

-- 
Jens Axboe


