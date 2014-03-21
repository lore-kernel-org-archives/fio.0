Return-Path: <axboe@kernel.dk>
Message-ID: <532C5A4C.7020501@kernel.dk>
Date: Fri, 21 Mar 2014 09:27:08 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Add unlink hook to ioengine API
References: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com> <1395338370-89038-1-git-send-email-castor.fu@egocast.org> <1395338370-89038-3-git-send-email-castor.fu@egocast.org>
In-Reply-To: <1395338370-89038-3-git-send-email-castor.fu@egocast.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: castor.fu@egocast.org, fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>
List-ID: <fio@vger.kernel.org>

On 03/20/2014 11:59 AM, castor.fu@egocast.org wrote:
> From: Castor Fu <castor@alumni.caltech.edu>
>
> ---
>   filesetup.c | 6 +++---
>   ioengine.h  | 4 +++-
>   ioengines.c | 8 ++++++++
>   iolog.c     | 2 +-
>   4 files changed, 15 insertions(+), 5 deletions(-)

This patch seems a bit pointless, without wiring some IO engine up for 
an unlink hook that isn't unlink(2).

-- 
Jens Axboe


