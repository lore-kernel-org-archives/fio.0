Return-Path: <axboe@kernel.dk>
Subject: Re: fio 3.2
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
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <aa9efb3f-9fd5-5322-7614-aa8c773dfa29@kernel.dk>
Date: Wed, 29 Nov 2017 21:21:30 -0700
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 11/28/2017 09:13 PM, Elliott, Robert (Persistent Memory) wrote:
> small_content_scramble has hardly been touched since 2011, so it probably
> hasn't had much performance analysis.  

That's fair, would be a good thing to look at, especially since it's on
by default.

> One of the few changes made was to add an integer divide by 1000, which 
> is always slow (painfully slow on some CPUs):
> 
> 	offset = ((io_u->start_time.tv_nsec/1000) ^ boffset) & 511;
> 
> perf top doesn't show that taking time - I think the compiler realized
> it could pull that calculation out of the loop and just do it once.  Different
> compilers and compiler options might not realize that.

Yeah, int divides suck. This didn't used to be like this, it got added
with the nsec conversion. I have fixed this up now.

-- 
Jens Axboe


