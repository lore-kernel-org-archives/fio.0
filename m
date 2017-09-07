Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <AA68DD56-9BED-46CD-93EE-8FC43B42F526@bluestop.org>
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org>
 <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk> <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
 <8ed561b4-4adb-b864-6f97-78f77388395d@bluestop.org> <CALjAwxih3rd1-FEFQxBgnVt-p4Lg1PZE_HxDBgyJ9ogyJ93wxg@mail.gmail.com>
 <971E6EBD-123F-425D-AE44-94099576C643@bluestop.org> <CALjAwxgUOKjQKZawkiAfXBLNdEnDzwBuZyRvGXHoOZ3ZVEQnig@mail.gmail.com>
 <AA68DD56-9BED-46CD-93EE-8FC43B42F526@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 7 Sep 2017 07:28:01 +0100
Message-ID: <CALjAwxjS5ER7LP4NOBbMz0RG6ot=T0jyMCUzBaUvyKhuE_183Q@mail.gmail.com>
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7 September 2017 at 07:06, Rebecca Cran <rebecca@bluestop.org> wrote:
>
>> On Sep 7, 2017, at 12:00 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> When this gets added will it be possible for fio to have a "memcpy
>> benchmark" mode where you're able to compare implementations when
>> using a fixed block size (in a similar way to --crctest) or does this
>> not make sense because you actually have to be copying to a device to
>> see the difference?
>
> That does make sense: to see the difference you just need to copy data between areas of memory.

I can't help but be reminded of Linus comment over on
https://bugzilla.redhat.com/show_bug.cgi?id=638477#c46 . At any rate I
notice that Agner Fog has an optimised memcpy too over on
http://agner.org/optimize/#asmlib (and older version apperars to be
here https://github.com/lukego/asmlib/blob/master/memcpy64.asm ).

-- 
Sitsofe | http://sucs.org/~sits/

