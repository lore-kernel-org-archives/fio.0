Return-Path: <axboe@kernel.dk>
Date: Thu, 13 Feb 2014 09:06:58 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] Fix IPv6 check on FreeBSD by including netinet/in.h
Message-ID: <20140213160658.GC10926@kernel.dk>
References: <52FC50FF.6060008@cran.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FC50FF.6060008@cran.org.uk>
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Feb 12 2014, Bruce Cran wrote:
> I noticed IPv6 support was being disabled on FreeBSD; it seems the
> configure script needs netinet/in.h so in6_addr is known.

Thanks Bruce, applied.

-- 
Jens Axboe


