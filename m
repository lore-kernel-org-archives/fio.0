Return-Path: <castor@egocast.org>
MIME-Version: 1.0
In-Reply-To: <532C5A4C.7020501@kernel.dk>
References: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
	<1395338370-89038-1-git-send-email-castor.fu@egocast.org>
	<1395338370-89038-3-git-send-email-castor.fu@egocast.org>
	<532C5A4C.7020501@kernel.dk>
Date: Fri, 21 Mar 2014 10:03:35 -0700
Message-ID: <CALKLVuLb_gJA5t8HupHPjggDVzuQVjJ5f3ppb4dKeRzc73tqaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add unlink hook to ioengine API
From: Castor Fu <castor@egocast.org>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> This patch seems a bit pointless, without wiring some IO engine up for an
> unlink hook that isn't unlink(2).

That's true, though for the engines which currently don't touch the
local filesystem fio is doing
unlink's on the jobfile names.  So I guess on some of those engines
the unlink operator should be a no-op.

