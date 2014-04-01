Return-Path: <axboe@kernel.dk>
Message-ID: <533B0C97.8080007@kernel.dk>
Date: Tue, 01 Apr 2014 12:59:35 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Shared files with thread=1: func=xfer, err=Bad file descriptor
References: <CANvN+ekEmEeFeXZ_b7-51QpetdWx2nwJHwoEsbsiFTOcpYwizw@mail.gmail.com> <533ACDDC.6010002@kernel.dk> <CANvN+emPxK2FmEAsbdruCMR0jDdjE-s6N6wovHtAqowFprJH4g@mail.gmail.com> <533B045B.9070607@kernel.dk> <CANvN+eknc=9Ncooprk6AUqOTvkju_JpYivy7EL5xRXka2qv+6g@mail.gmail.com>
In-Reply-To: <CANvN+eknc=9Ncooprk6AUqOTvkju_JpYivy7EL5xRXka2qv+6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/01/2014 12:56 PM, Andrey Kuzmin wrote:
> Seems to have fixed it: EBADF does not show up anymore even in a 120s run.

Great, it has been committed. The issue was that fio would mistakenly 
not assign shadow_fd on that one alloc, hence it would think it was fd 0 
and close it. And when open(2) then (validly) started handing out 
untracked fd 0, then all hell broke lose.

-- 
Jens Axboe


