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
 <aa9efb3f-9fd5-5322-7614-aa8c773dfa29@kernel.dk>
 <TU4PR8401MB099144F611F2DA95262312F4EC380@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0e2efc36-3c1b-ac51-4baf-044276cc51e9@kernel.dk>
Date: Thu, 30 Nov 2017 14:23:50 -0700
MIME-Version: 1.0
In-Reply-To: <TU4PR8401MB099144F611F2DA95262312F4EC380@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
List-ID: <fio@vger.kernel.org>

On 11/30/2017 07:17 AM, Gavriliuk, Anton (HPS Ukraine) wrote:
> It's there any chance to fix it ?
> 
> dl560g10spmem01:/var/work # /usr/local/bin/fio --filename=/dev/dax0.0 --rw=randrw --refill_buffers --randrepeat=0 --ioengine=mmap --bssplit=4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwmixread=5 --iodepth=1 --numjobs=16 --runtime=1800 --group_reporting --name=4-rand-rw-3xx --size=290g
> 4-rand-rw-3xx: (g=0): rw=randrw, bs=(R) 4096B-256KiB, (W) 4096B-256KiB, (T) 4096B-256KiB, ioengine=mmap, iodepth=1
> ...
> fio-2.99
> Starting 16 processes
> 4-rand-rw-3xx: failed to get file size of /dev/dax0.0
> 
> 4-rand-rw-3xx: failed to get file size of /dev/dax0.0
> 
> 4-rand-rw-3xx: failed to get file size of /dev/dax0.0
> 
> 4-rand-rw-3xx: failed to get file size of /dev/dax0.0
> 
> 4-rand-rw-3xx: failed to get file size of /dev/dax0.0
> 
> 4-rand-rw-3xx: failed to get file size of /dev/dax0.0
> 
> 4-rand-rw-3xx: failed to get file size of /dev/dax0.0

Should already be fixed as of yesterday morning.

-- 
Jens Axboe


