Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB0387D41B891BF12A39A81FD1AB390@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk> <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com>
 <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
 <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org> <TU4PR8401MB0991F4C4CAD9858A3BF2AE9DEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387489EC42684D7FACF3E1EAB3A0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991EBEF27D16271CD5361AAEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <aa9efb3f-9fd5-5322-7614-aa8c773dfa29@kernel.dk> <TU4PR8401MB099144F611F2DA95262312F4EC380@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <0e2efc36-3c1b-ac51-4baf-044276cc51e9@kernel.dk> <DF4PR8401MB0985A5C6D31650967F15CE1EEC390@DF4PR8401MB0985.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387D41B891BF12A39A81FD1AB390@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 3 Dec 2017 09:35:57 +0000
Message-ID: <CALjAwxh6Xhy63jwhrNoB470mBv_owguh66yC3J4XbBnW-tJDFA@mail.gmail.com>
Subject: Re: fio 3.2
Content-Type: text/plain; charset="UTF-8"
To: "Robert Elliott (Persistent Memory)" <elliott@hpe.com>
Cc: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, Jens Axboe <axboe@kernel.dk>, Rebecca Cran <rebecca@bluestop.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 1 December 2017 at 07:15, Robert Elliott (Persistent Memory)
<elliott@hpe.com> wrote:
> While discussing NUMA, I'll mention something else I saw in Windows
> while fixing the thread affinities there.
>
> At startup, fio spawns threads on all CPUs to measure the clocks
> (fio_monotonic_clocktest).  If you've constrained the CPU affinity
> outside fio, some of those will fail.  In Windows, something like
> START /AFFINITY 0x55555555 fio ...
> can cause half of the clock threads to fail.

This is very weird and doesn't make any sense (but I believe you): if
you have multiple threads crammed on to the same CPUs the TSC no
longer looks like it monotonically increases? Surely it should be MORE
likely to increase because a thread is likely to be on the same CPU as
another and can't actually be running at the same time as the other?

Something suspicious is going on - to this day I'm still unsure as to
why https://github.com/sitsofe/fio/commit/1a7a1fd98ad749768212f49f5ba3e9a1392c4263
would sometimes fail on Windows (but seemingly not on Linux)...

-- 
Sitsofe | http://sucs.org/~sits/

