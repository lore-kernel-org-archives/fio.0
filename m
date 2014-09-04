Return-Path: <axboe@kernel.dk>
Message-ID: <5408C3E7.2050105@kernel.dk>
Date: Thu, 04 Sep 2014 13:56:23 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: cpus_allowed_policy for async IO verification threads
References: <94D0CD8314A33A4D9D801C0FE68B402958C4F41B@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C4F41B@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/04/2014 01:40 PM, Elliott, Robert (Server Storage) wrote:
> To accompany cpus_allowed_policy=split, should fio offer
> a verify_async_cpus_allowed_policy=split to bind its
> async IO verification threads to particular CPUs?
> 
>       verify_async_cpus=str
>       Tell fio to set the given CPU affinity on 
> 	the async IO verification threads.  See cpus_allowed for 
> 	the format used.

That would probably not be a bad idea.

-- 
Jens Axboe


