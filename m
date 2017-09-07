Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <8CE90EB9-3BA6-4CA5-BFC4-08810821FD38@bluestop.org>
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org>
 <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk> <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
 <8ed561b4-4adb-b864-6f97-78f77388395d@bluestop.org> <CALjAwxih3rd1-FEFQxBgnVt-p4Lg1PZE_HxDBgyJ9ogyJ93wxg@mail.gmail.com>
 <971E6EBD-123F-425D-AE44-94099576C643@bluestop.org> <CALjAwxgUOKjQKZawkiAfXBLNdEnDzwBuZyRvGXHoOZ3ZVEQnig@mail.gmail.com>
 <AA68DD56-9BED-46CD-93EE-8FC43B42F526@bluestop.org> <CALjAwxjS5ER7LP4NOBbMz0RG6ot=T0jyMCUzBaUvyKhuE_183Q@mail.gmail.com>
 <8CE90EB9-3BA6-4CA5-BFC4-08810821FD38@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 7 Sep 2017 21:24:17 +0100
Message-ID: <CALjAwxh2ppFM5QEAjSDiEdEM5D5SoOVBYJ4e0nqM3s-rLzScdQ@mail.gmail.com>
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7 September 2017 at 07:52, Rebecca Cran <rebecca@bluestop.org> wrote:
>
>> On Sep 7, 2017, at 12:28 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>>> On 7 September 2017 at 07:06, Rebecca Cran <rebecca@bluestop.org> wrote:
>>> That does make sense: to see the difference you just need to copy data between areas of memory.
>>
>> I can't help but be reminded of Linus comment over on
>> https://bugzilla.redhat.com/show_bug.cgi?id=638477#c46 .
>
> Hmm, are you suggesting by that it's not something we should try and optimize within fio?

No the opposite - that a non libc memcpy may out perform the libc one
(even if it looks simpler in some cases)!

> I can totally understand that, and I'd be willing to put off any further work on this until/if we run into issues testing the performance of future NVDIMM-P (i.e. Storage Class Memory) devices.

It's not my intent to put you off - all your ideas sound good!

-- 
Sitsofe | http://sucs.org/~sits/

