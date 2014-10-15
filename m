Return-Path: <axboe@kernel.dk>
Message-ID: <543ED635.9040805@kernel.dk>
Date: Wed, 15 Oct 2014 14:16:53 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] BSD Yacc doesn't understand --no-lines, so use -l instead.
References: <543ED3A5.1010806@cran.org.uk>
In-Reply-To: <543ED3A5.1010806@cran.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/15/2014 02:05 PM, Bruce Cran wrote:
> I've attached a patch which fixes building on FreeBSD when bison isn't
> installed. Both BSD and GNU Yacc understand "-l".

Thanks Bruce, applied.

-- 
Jens Axboe


