Return-Path: <bruce@cran.org.uk>
Message-ID: <52F927AC.6020007@cran.org.uk>
Date: Mon, 10 Feb 2014 12:25:32 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Mutex destruction, invalid memory accesses, leaks
References: <20140206192135.GB3950@kernel.dk> <20140207034439.GA17588@sucs.org> <52F505A8.30004@kernel.dk> <20140209195042.GA17058@sucs.org>
In-Reply-To: <20140209195042.GA17058@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@yahoo.com>, Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2/9/2014 12:50 PM, Sitsofe Wheeler wrote:
>
> Yes it's still happening with -git from a moment ago. What is stopping a
> sleeping thread from holding a mutex that is destroyed and then waking
> up on it after the memory has been unmapped?

In case it *is* a bug in winpthreads-1.dll, are you using version 
3.1.0-1? It was released on the 15th January and there appeared to be 
some mutex-related fixes when I looked at the svn log a few weeks ago.

-- 
Bruce

