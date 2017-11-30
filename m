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
 <B51AE08B-A0D4-457B-8DF5-E1CD3DC2A271@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <40a7b698-e78f-4b82-cdb5-4629d19dff3f@kernel.dk>
Date: Wed, 29 Nov 2017 21:04:13 -0700
MIME-Version: 1.0
In-Reply-To: <B51AE08B-A0D4-457B-8DF5-E1CD3DC2A271@bluestop.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Rebecca Cran <rebecca@bluestop.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 11/28/2017 09:44 PM, Rebecca Cran wrote:
> I’ve not followed the whole discussion, but I did some tests a couple
> of months ago replacing the calls to memcpy in the memmap engine with
> a new fio_memcpy function, rebuilding fio with the -ftree-vectorize
> flag along with -msse2, -mavx etc.  I saw an improvement of a few
> hundred MB/sec on my openSUSE system.

Care to send a patch for that? I think it'd be nice for fio to pack it's
own, especially when the performance varies so wildly and is platform
(and even version) dependent.

-- 
Jens Axboe


