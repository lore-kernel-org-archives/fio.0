Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:52199
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab1IPHF1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 16 Sep 2011 03:05:27 -0400
Message-ID: <4E72F536.1010005@kernel.dk>
Date: Fri, 16 Sep 2011 09:05:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO with direct, non-buffered IO on Mac OS X
References: <655B558C-ADC2-4D96-A31F-5F847B047AEC@schihei.de>
In-Reply-To: <655B558C-ADC2-4D96-A31F-5F847B047AEC@schihei.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Heiko Joerg Schick <info@schihei.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-09-16 08:55, Heiko Joerg Schick wrote:
> Hello Jens,
> 
> is there a way to execute FIO with direct, non-buffered IO on Mac OS
> X. It seems that the --direct and/or --buffered parameter only works
> in combination with the -ioengine=libaio parameter?

(CC'ing in the fio list)

direct=1 isn't tied to libaio in any way, and OSX should support it. Not
quite sure how unbuffered IO is done on OSX, perhaps others can chime in
here. On some operating systems, it's only supported on specific device
types or certain file systems.

-- 
Jens Axboe

