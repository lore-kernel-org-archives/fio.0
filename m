Return-Path: <axboe@kernel.dk>
Message-ID: <5346B9FE.10409@kernel.dk>
Date: Thu, 10 Apr 2014 09:34:22 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio on AIX - fallocate error
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net> <5346A3FE.10106@kernel.dk> <E2B4022DB0264A4B90C5F1B01B8E677D733228A3@LIVP3MMBX13.mail.aig.net>
In-Reply-To: <E2B4022DB0264A4B90C5F1B01B8E677D733228A3@LIVP3MMBX13.mail.aig.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Carino, Mario" <Mario.Carino@AIG.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/10/2014 09:30 AM, Carino, Mario wrote:
> Hi Jens,
>
> Well, that's the thing. We can't get rid of the fallocate error
> regardless of how we set fallocate= in the job file. We've tried
 > 0,1,none,posix and keep (which seems to be invalid now) and we ALWAYS
 > get the fallocate error. Sometimes the job continues to run, but the
 > output file is only created at zero byte length.

Can you send me the job file you are using?

-- 
Jens Axboe


