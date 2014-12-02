Return-Path: <axboe@kernel.dk>
Message-ID: <547E276D.70700@kernel.dk>
Date: Tue, 02 Dec 2014 13:56:13 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: remove deprecated --latency-log from manpage
References: <94D0CD8314A33A4D9D801C0FE68B4029593EF992@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593EF992@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/02/2014 01:20 PM, Elliott, Robert (Server Storage) wrote:
> The --latency-log argument is no longer accepted; fio returns
> an error message saying it is deprecated.  So, remove it from
> the manpage.

Thanks, applied.

-- 
Jens Axboe


