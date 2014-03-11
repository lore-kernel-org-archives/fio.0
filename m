Return-Path: <axboe@kernel.dk>
Message-ID: <531F3850.3010105@kernel.dk>
Date: Tue, 11 Mar 2014 10:22:40 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: number_ios is checked on completion, not submission
References: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net> <531F2D56.8080801@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B4029548C7B40@G4W3202.americas.hpqcorp.net> <531F3657.9030003@kernel.dk> <531F36C2.6060103@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B4029548C7BAC@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548C7BAC@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/11/2014 10:19 AM, Elliott, Robert (Server Storage) wrote:
> That works.
>
>    IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.6%, >=64=98.7%
>       issued    : total=r=5000/w=0/d=0, short=r=0/w=0/d=0

Goodie, committed.

-- 
Jens Axboe


