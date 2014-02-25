Return-Path: <axboe@kernel.dk>
Message-ID: <530D1244.1020907@kernel.dk>
Date: Tue, 25 Feb 2014 13:59:32 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: iodepth_batch default 1 or iodepth
References: <94D0CD8314A33A4D9D801C0FE68B4029548AB248@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548AB248@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-02-25 12:45, Elliott, Robert (Server Storage) wrote:
> fio.1 says the default value for iodepth_batch is iodepth, but HOWTO says it
 > defaults to 1 and options.c defaults to 1.  Which is intended?
>
> The value is not displayed in the fio output anywhere, so it's unclear
 > what you're getting unless you specify a value.

The documentation is wrong (and illogical), it should default to 1 if 
not given. Which it does. So we should probably just fix up the 
documentation.

-- 
Jens Axboe


