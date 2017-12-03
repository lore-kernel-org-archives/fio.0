Return-Path: <axboe@kernel.dk>
Subject: Re: fio 3.2
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
 <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org>
 <TU4PR8401MB0991F4C4CAD9858A3BF2AE9DEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387489EC42684D7FACF3E1EAB3A0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991EBEF27D16271CD5361AAEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <aa9efb3f-9fd5-5322-7614-aa8c773dfa29@kernel.dk>
 <TU4PR8401MB099144F611F2DA95262312F4EC380@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <0e2efc36-3c1b-ac51-4baf-044276cc51e9@kernel.dk>
 <DF4PR8401MB0985A5C6D31650967F15CE1EEC390@DF4PR8401MB0985.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387D41B891BF12A39A81FD1AB390@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh6Xhy63jwhrNoB470mBv_owguh66yC3J4XbBnW-tJDFA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5b1cd1e7-8a7a-033d-e962-e0df334a02d6@kernel.dk>
Date: Sun, 3 Dec 2017 10:10:36 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxh6Xhy63jwhrNoB470mBv_owguh66yC3J4XbBnW-tJDFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, "Robert Elliott (Persistent Memory)" <elliott@hpe.com>
Cc: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, Rebecca Cran <rebecca@bluestop.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 12/03/2017 02:35 AM, Sitsofe Wheeler wrote:
> On 1 December 2017 at 07:15, Robert Elliott (Persistent Memory)
> <elliott@hpe.com> wrote:
>> While discussing NUMA, I'll mention something else I saw in Windows
>> while fixing the thread affinities there.
>>
>> At startup, fio spawns threads on all CPUs to measure the clocks
>> (fio_monotonic_clocktest).  If you've constrained the CPU affinity
>> outside fio, some of those will fail.  In Windows, something like
>> START /AFFINITY 0x55555555 fio ...
>> can cause half of the clock threads to fail.
> 
> This is very weird and doesn't make any sense (but I believe you): if
> you have multiple threads crammed on to the same CPUs the TSC no
> longer looks like it monotonically increases? Surely it should be MORE
> likely to increase because a thread is likely to be on the same CPU as
> another and can't actually be running at the same time as the other?

The threads fail to start, it's not a TSC failure. I'm guessing it's
because fio gets limited to a subset of the available CPUs, and that
causes fio to fail doing the clock check when fio_setaffinity() in
clock_thread_fn() fails.

-- 
Jens Axboe


