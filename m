Return-Path: <axboe@kernel.dk>
Message-ID: <5346B395.7000109@kernel.dk>
Date: Thu, 10 Apr 2014 09:07:01 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio on AIX - fallocate error
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net> <5346A3FE.10106@kernel.dk>
In-Reply-To: <5346A3FE.10106@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Carino, Mario" <Mario.Carino@AIG.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-04-10 08:00, Jens Axboe wrote:
> Fio should probably just ignore these flush-cache warnings and continue
> on, it's not really a fatal condition. I have attached a patch for you,
> can you apply that and give it a go?

I committed a variant of this, since I think it makes sense to do. As a 
user, there's nothing you can do to make it work, if your platform is 
missing the cache invalidation part. And it's not a fatal error 
condition, so fio will just warn and go on.

So you can git pull the update, or download the latest tar ball snapshot 
and give it another go.

-- 
Jens Axboe


