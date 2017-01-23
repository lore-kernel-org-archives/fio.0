Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 4/8] Remove unused io_u's priv union field
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
 <1485184391-11036-4-git-send-email-tkusumi@tuxera.com>
 <CANvN+e=SsCxGCcMNktU88+uSS5_TrZ+jNG1K+gLcgS5vH1ZDDA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <eee7c54a-2357-d437-1bbc-df0c467fe7e5@kernel.dk>
Date: Mon, 23 Jan 2017 11:01:40 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+e=SsCxGCcMNktU88+uSS5_TrZ+jNG1K+gLcgS5vH1ZDDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, kusumi.tomohiro@gmail.com
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/23/2017 09:06 AM, Andrey Kuzmin wrote:
> This may break some I/O engines.

Are you using it? I'm happy to revert that change, it's not like
it's gaining us back some memory. It is annoying to have no in-tree
users of a "feature", though.

-- 
Jens Axboe


