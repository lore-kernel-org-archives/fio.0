Return-Path: <axboe@kernel.dk>
Message-ID: <52FB92B6.8070704@kernel.dk>
Date: Wed, 12 Feb 2014 08:26:46 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] Make fio.h a bit more C++ safe
References: <1392216715-9539-1-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392216715-9539-1-git-send-email-d.gollub@telekom.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Daniel Gollub <daniel.gollub@t-online.de>, fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>
List-ID: <fio@vger.kernel.org>



On 02/12/2014 07:51 AM, Daniel Gollub wrote:
> Following patches allow to include fio.h for a C++ based
> (external) ioengine to be compiled with g++.
>
> (Preparing two fio engines: one internal for CEPH RBD
> another external for CEPH FileStore)
>
> Daniel Gollub (2):
>    Make file.h C++ safe by casting fio_file_flags
>    Make parse.h C++ safe by avoiding "or" keyword

Thanks, applied both of them. You missed goptions.c for the ->or change, 
caught that and fixed it.

-- 
Jens Axboe

