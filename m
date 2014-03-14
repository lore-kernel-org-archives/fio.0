Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53236D0B.5040507@kernel.dk>
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>
	<532349BF.4010307@kernel.dk>
	<CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>
	<532361FE.10901@kernel.dk>
	<53236538.2040903@kernel.dk>
	<CAF+0mv=q-nEGkeQdJgwH78_3n6novRHAWfRwp=QHa8dFinYd3Q@mail.gmail.com>
	<53236D0B.5040507@kernel.dk>
Date: Fri, 14 Mar 2014 14:06:47 -0700
Message-ID: <CAF+0mvmV4DYyGvG_ccENE5NqhB-wuQsqUVQD8LY0mvM-hTeXoA@mail.gmail.com>
Subject: Re: Possible bug when setting compression
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> zero_buffers and buffer_compres_percentage=100 are essentially the same
> thing, for both cases it writes buffers just fill of zeroes. So I'm not sure
> what you were expecting here since you don't think it works as it should?
>
> If you have both zero_buffers and scramble set, then the result will be a
> bit less compressible. The goal of scramble_buffers is to defeat basic
> dedupe attempts. So even if you don't fully refill your buffers every time,
> the blocks will be a bit different.
>
> --
> Jens Axboe
>
>

Hmm, I was assuming that scramble_buffers shouldn't have any effect
since it's scrambling all zeros.  Is scramble_buffers inserting random
data even with zero_buffers set?

