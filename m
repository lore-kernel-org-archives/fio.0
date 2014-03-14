Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53236538.2040903@kernel.dk>
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>
	<532349BF.4010307@kernel.dk>
	<CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>
	<532361FE.10901@kernel.dk>
	<53236538.2040903@kernel.dk>
Date: Fri, 14 Mar 2014 13:53:17 -0700
Message-ID: <CAF+0mv=q-nEGkeQdJgwH78_3n6novRHAWfRwp=QHa8dFinYd3Q@mail.gmail.com>
Subject: Re: Possible bug when setting compression
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> So that wont work as-is, since the parser will bypass the store when the
> callback is specified. It needs a one-liner, please try this updated one
> instead.
>
> --
> Jens Axboe
>

Ok, so it looks like everything works now except for zero_buffers.

fio-2.1.6.1-11-g0574 + patch

buffer_compress_percentage=100
iops=83457

buffer_compress_percentage=50
iops=78836

buffer_compress_percentage=1
iops=52785

buffer_compress_percentage=0
iops=51013

zero_buffers
iops=69465

scramble_buffers=0
zero_buffers
iops=83451

