Return-Path: <axboe@kernel.dk>
Message-ID: <531F3657.9030003@kernel.dk>
Date: Tue, 11 Mar 2014 10:14:15 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: number_ios is checked on completion, not submission
References: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net> <531F2D56.8080801@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B4029548C7B40@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548C7B40@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/11/2014 10:08 AM, Elliott, Robert (Server Storage) wrote:
> That patch still exits after 5127 ios.
>
> io_bytes_exceeded is called 5128 times, but it sees td->io_u_queued=0 each time.

Can you check if ->cur_depth or ->io_u_in_flight catches it?

> keep_running makes it to the if (td->o.number_ios) branch one time, and sees number_ios set to 5127  and td->o.number_ios set to 5000 (causing it to return 0 and trigger the end, after 5127 ios).

That's expected. That just controls the outer loop, we want to catch it 
in both places.

-- 
Jens Axboe


