Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55CE3ED4.8020505@kernel.dk>
References: <CALjAwxh7sx3OHw9Gb=gBwet+YqpJNNDzZusNZK7X7bGK0Z06pQ@mail.gmail.com>
	<55CE0DA9.6050204@kernel.dk>
	<55CE1025.6080009@kernel.dk>
	<CALjAwxjk6TG+UO6d3L_7Fq=Ucm5WBtkMLLQwSqx+F_J9f=gReg@mail.gmail.com>
	<55CE3ED4.8020505@kernel.dk>
Date: Fri, 14 Aug 2015 20:21:33 +0100
Message-ID: <CALjAwxhbjE4xTZ5jA_m-0spFTtvwJb_bNZz7m7cPRcCXLY1wNA@mail.gmail.com>
Subject: Re: server mode and verify_dump
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 14 August 2015 at 20:17, Jens Axboe <axboe@kernel.dk> wrote:
> Right, I suspected that might have been the case. If the header isn't valid,
> then fio doesn't dump any contents. One could argue that it would be cleaner

What do you think it would take to dump a block's worth of data when
encountering a header error during a verify?

-- 
Sitsofe | http://sucs.org/~sits/

