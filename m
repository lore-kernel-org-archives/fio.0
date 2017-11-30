Return-Path: <axboe@kernel.dk>
Subject: Re: fio 3.2
From: Jens Axboe <axboe@kernel.dk>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk>
 <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com>
 <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
 <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org>
 <TU4PR8401MB0991F4C4CAD9858A3BF2AE9DEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387489EC42684D7FACF3E1EAB3A0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991EBEF27D16271CD5361AAEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <aa9efb3f-9fd5-5322-7614-aa8c773dfa29@kernel.dk>
 <1d608342-b34b-0443-c9fa-3f4dc8e48c99@kernel.dk>
Message-ID: <3e05e6d0-adb3-7038-aa01-bb94567ed615@kernel.dk>
Date: Thu, 30 Nov 2017 09:18:30 -0700
MIME-Version: 1.0
In-Reply-To: <1d608342-b34b-0443-c9fa-3f4dc8e48c99@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 11/30/2017 09:13 AM, Jens Axboe wrote:
> On 11/29/2017 09:21 PM, Jens Axboe wrote:
>> On 11/28/2017 09:13 PM, Elliott, Robert (Persistent Memory) wrote:
>>> small_content_scramble has hardly been touched since 2011, so it probably
>>> hasn't had much performance analysis.  
>>
>> That's fair, would be a good thing to look at, especially since it's on
>> by default.
> 
> Something like this might be an improvement. The main change here is
> that for each 512b chunk in the io_u buffer, we generate a "random"
> index between 0..7 and scramble the start and end of that with the
> offset and time. The difference here is that we do it all within a 64b
> range within each chunk, which should fall into the same cacheline since
> the io_u buffer is generally aligned. This cuts down on the number of
> cachelines we dirty for each io_u, from a max of 16 to 8.
> 
> We could further reduce this to 7, if we generate an overlapping
> cacheline between chunks. That would place the data in the same spot
> everytime, which isn't ideal though.
> 
> I ran a quick null benchmark with this, and on my laptop it brings us
> from 4061k/4068k to 4090k/4091k. Those are results from two runs, so not
> very conclusive or definitive... Suggestions and tests would be welcome.
> FWIW, this is what I ran:
> 
> ./fio --name=null --size=100g --rw=write --ioengine=null --gtod_reduce=1 --scramble_buffers=1 --iodepth=64 --direct=1 --cpus_allowed=2

Ran the same thing on a server box, which generated very reliable results.
It takes us from 3200K to 3340K. I'm going to commit this, but don't let
that stop anyone from testing it and making suggestions on how we can
further improve it.

-- 
Jens Axboe


