Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52816 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3GVU6d (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jul 2013 16:58:33 -0400
Message-ID: <51ED9CE8.8050203@kernel.dk>
Date: Mon, 22 Jul 2013 14:58:16 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [Pull Request] Fixing coherency in fio2gnuplot
References: <51ED6FFC.2070309@enovance.com> <20130722182915.GA32755@kernel.dk> <51ED9BA1.602@enovance.com>
In-Reply-To: <51ED9BA1.602@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: fio@vger.kernel.org

On 07/22/2013 02:52 PM, Erwan Velu wrote:
> On 22/07/2013 20:29, Jens Axboe wrote:
>> On Mon, Jul 22 2013, Erwan Velu wrote:
>>> Hello,
>>> Sorry to make many pull request in a row but I just discover a serious
>>> problem when plotting multiple traces at the same time. It was in fact
>>> shortening the plots & rendering to the smallest trace file.
>>>
>>> This bug is pretty boring and this patch series does fix it.
>>> The branch is on top the current master, shall be easy to merge ;o)
>> No worries, pulled both of them. Thanks!
>>
> Thanks !
> 
> Did you got the chance to had a look at it ?

The actual ouputs? No, not yet, will get around to playing with it
before the next release.

-- 
Jens Axboe

