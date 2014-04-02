Return-Path: <axboe@kernel.dk>
Message-ID: <533C1DB7.90206@kernel.dk>
Date: Wed, 02 Apr 2014 08:24:55 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Curious code in init()
References: <533BCB67.4050709@enovance.com>
In-Reply-To: <533BCB67.4050709@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-04-02 02:33, Erwan Velu wrote:
> Hey Jens,
>
> The following code is pretty confusing for me :
> http://git.kernel.dk/?p=fio.git;a=blob;f=init.c;h=c3996a76c12840e3ab3cf6514e5d5dce611a1077;hb=HEAD#l1962
>
>
> The "if (nr_clients && fio_clients_connect()) {" is using the do_exit
> concept while being after the code that manage it and does a return -1
> while exit code is set to 1.
>
> I don't get how it should be fixed.
> 1- we shall move the if nr_clients before the "if (do_exit", remove the
> return -1 and adjust the exit_code ?
> 2- we shall get rid of the do_exit & exit code semantic of the if
> nr_clients.
>
> What was the intent while reading the code ? ;o)

It should probably just be turned into an exit(1) or similar exit code. 
The current code will work to the extent that it will properly exit, 
however it wont signal the error correctly in the return value.

-- 
Jens Axboe


