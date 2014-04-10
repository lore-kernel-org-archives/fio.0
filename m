Return-Path: <axboe@kernel.dk>
Message-ID: <5346CD5C.8090008@kernel.dk>
Date: Thu, 10 Apr 2014 10:57:00 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio on AIX - fallocate error
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net> <5346A3FE.10106@kernel.dk> <E2B4022DB0264A4B90C5F1B01B8E677D73322971@LIVP3MMBX13.mail.aig.net> <5346C84D.1010704@kernel.dk> <E2B4022DB0264A4B90C5F1B01B8E677D733229A5@LIVP3MMBX13.mail.aig.net>
In-Reply-To: <E2B4022DB0264A4B90C5F1B01B8E677D733229A5@LIVP3MMBX13.mail.aig.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Carino, Mario" <Mario.Carino@AIG.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/10/2014 10:44 AM, Carino, Mario wrote:
> Debug output attached

Are you running with the previous patch for the fadvise error? It looks 
like you are not, which is why it exits.

-- 
Jens Axboe


