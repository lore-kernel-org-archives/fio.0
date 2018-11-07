Return-Path: <axboe@kernel.dk>
Subject: Re: Mention of fio by Apple
References: <CALjAwxjW8=DniS12hBvPXmd1Cp0NjEm9RewHAO8rHerDQg=eDQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cef30e0a-e855-f54c-8b94-3b387605dd42@kernel.dk>
Date: Wed, 7 Nov 2018 13:55:31 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxjW8=DniS12hBvPXmd1Cp0NjEm9RewHAO8rHerDQg=eDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/4/18 3:44 AM, Sitsofe Wheeler wrote:
> Looks like someone is referencing an fio benchmark result on Apple's
> Mac Mini page and whoever did it took care to respect the Moral
> License (https://fio.readthedocs.io/en/latest/fio_doc.html#moral-license
> ). From https://www.apple.com/mac-mini/ :
> 
> "4. Testing conducted by Apple in October 2018 using preproduction
> 3.2GHz 6-core Intel Core i7-based Mac mini systems with 64GB of RAM
> and 1TB SSD, and shipping 3.0GHz dual-core Intel Core i7-based Mac
> mini systems with 16GB of RAM and 1TB SSD. Tested with FIO 3.8, 1024KB
> request size, 150GB test file and IO depth=8. Performance tests are
> conducted using specific computer systems and reflect the approximate
> performance of Mac mini."

Nice, good find :-). I'm impressed they honored the moral license.

> My only question is: as the depth was 8 were they using the posixaio engine?

They most probably were, either that or 8 threads/processes.

-- 
Jens Axboe


