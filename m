Return-Path: <axboe@kernel.dk>
Subject: Re: fio 3.2
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com>
 <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com>
 <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org>
 <TU4PR8401MB0991F4C4CAD9858A3BF2AE9DEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB0387489EC42684D7FACF3E1EAB3A0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB0991EBEF27D16271CD5361AAEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <aa9efb3f-9fd5-5322-7614-aa8c773dfa29@kernel.dk>
 <TU4PR8401MB099144F611F2DA95262312F4EC380@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <0e2efc36-3c1b-ac51-4baf-044276cc51e9@kernel.dk>
 <TU4PR8401MB0991226E41D378F0373CBE42EC3C0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0bffe3f5-c8af-3f9a-4c15-be432a8ba5bb@kernel.dk>
Date: Mon, 4 Dec 2017 11:41:00 -0700
MIME-Version: 1.0
In-Reply-To: <TU4PR8401MB0991226E41D378F0373CBE42EC3C0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, "Robert Elliott (Persistent Memory)" <elliott@hpe.com>, Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 12/04/2017 10:12 AM, Gavriliuk, Anton (HPS Ukraine) wrote:
> I have run next command several times,
> 
> perf record /usr/local/bin/fio --filename=/dev/dax0.0 --rw=randrw --refill_buffers --norandommap --randrepeat=0 --ioengine=mmap --bssplit=4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwmixread=5 --iodepth=1 --numjobs=16 --runtime=1800 --group_reporting --name=4-rand-rw-3xx --size=290g --numa_cpu_nodes=0
> 
> each perf report shows me toppest clock_thread_fn(),

It's the cpu clock calibration that fio does. Just ignore it, it's run
before any of the actual work starts.

Additionally, please stop top posting. Proper net etiquette is replying
below the context you are responding to.

-- 
Jens Axboe


