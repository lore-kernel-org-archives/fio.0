Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36364 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1LSH4S (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 19 Dec 2011 02:56:18 -0500
Message-ID: <4EEEEE1F.6010204@kernel.dk>
Date: Mon, 19 Dec 2011 08:56:15 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fix net engine client read server write bug
References: <CAG5pYQeVKT=90W0U3GEcC58TXPHNvjp=GoyfmV7SiO6KWeeoDg@mail.gmail.com>
In-Reply-To: <CAG5pYQeVKT=90W0U3GEcC58TXPHNvjp=GoyfmV7SiO6KWeeoDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <renyufei83@gmail.com>
Cc: fio@vger.kernel.org, "Yufei Ren(Y!)" <renyufei83@yahoo.com.cn>

On 2011-12-16 21:40, Yufei Ren wrote:
> The net engine was updated with specific 'listen' parameter which used
> for identifying whether it is a tcp server, instead of previous
> 'rw=read' side must be the server. This let fio support bi-direction
> net io test. fio_netio_open_file() has to follow this
> principle. Otherwise, the following tcp client 'rw=read' and tcp
> server 'rw=write' case doesn't work.
> 
> [global]
> ioengine=net
> port=8888
> protocol=tcp
> bs=4k
> size=10g
> 
> [server]
> listen
> rw=write
> 
> [client]
> hostname=localhost
> startdelay=1
> rw=read
> 
> BTW, examples/netio needs 'listen' and 'hostname' adjusted.

Thanks, applied. There's also a bug wrt the unix socket handling, it'll
segfault without host/filename now. Will fix that up in a following
patch.

-- 
Jens Axboe

