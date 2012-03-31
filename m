Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55551 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2CaX3z (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Mar 2012 19:29:55 -0400
Message-ID: <4F779366.5000008@kernel.dk>
Date: Sat, 31 Mar 2012 16:29:42 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Verify with mixed read/write
References: <CAKa9NmtSnSj=mOx7E7rwBpHW1xPThd+K0RnsGXcDA8QX2qgkJw@mail.gmail.com>
In-Reply-To: <CAKa9NmtSnSj=mOx7E7rwBpHW1xPThd+K0RnsGXcDA8QX2qgkJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: fio@vger.kernel.org

On 2012-03-30 17:06, Vikram Seth wrote:
> Hi,
> 
> Does the verify option work with mixed read/write case, like rw or randrw  ?
> 
> It's not clear from the help text (pasted below).
> 
>                 This option can be used for repeated burn-in tests of a
>                 system to make sure that the written data is also
>                 correctly read back. If the data direction given is
>                 a read or random read, fio will assume that it should
>                 verify a previously written file. If the data direction
>                 includes any form of write, the verify will be of the
>                 newly written data.

It does, yes.

-- 
Jens Axboe

