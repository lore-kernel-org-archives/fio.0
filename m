Message-ID: <4D30367B.8090504@fusionio.com>
Date: Fri, 14 Jan 2011 12:41:47 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20110114050004.0ECBF37A2F4@kernel.dk> <20110114113809.00005e5f@unknown>
In-Reply-To: <20110114113809.00005e5f@unknown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2011-01-14 12:38, Bruce Cran wrote:
> On Fri, 14 Jan 2011 06:00:03 +0100 (CET)
> Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>> +	strcpy(fname, basename(ptr));
> 
> libgen.h needs to be included to pick up basename(3).

Indeed, apparently mine picks it up elsewhere. I added the header.

-- 
Jens Axboe


