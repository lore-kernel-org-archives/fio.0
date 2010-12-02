Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:45140 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab0LBTI4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Dec 2010 14:08:56 -0500
Message-ID: <4CF7EEC3.6090806@fusionio.com>
Date: Thu, 2 Dec 2010 20:08:51 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: iodepth and synchronous ioengines ("pitfall")
References: <20101201213831.GU28050@sebastiankayser.de> <4CF7ECA4.5050107@fusionio.com>
In-Reply-To: <4CF7ECA4.5050107@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On 2010-12-02 19:59, Jens Axboe wrote:
> On 2010-12-01 22:38, Sebastian Kayser wrote:
>> Hi,
>>
>> I just stumbled into a glaring pitfall when playing with iodepth=X for
>> the first time. Was using ioengine=sync (default), increased iodepth > 1
>> and wondered briefly why my results didn't change. Thinking about it,
>> this made perfect sense and the "IO depths" distribution in the result
>> summary even pointed me to it.
>>
>> Nevertheless, it might help others to avoid this alltogether if the man
>> page paragraph on iodepth would include a small heads up / reference to
>> ioengines. Example patch attached, not quite sure about the wording for
>> the verify_async aspect.
> 
> It's a good idea. Something else to keep in mind is that even with async
> engines, you can run into this issue. Say in Linux and not setting
> direct=1, the buffered IO will still be sync. So I think I'll add some
> wording as well to have the user keep an eye on the achieved IO depths
> and not just assume that it's running with a depth of X for iodepth=X.

http://git.kernel.dk/?p=fio.git;a=commitdiff;h=ee72ca09d4657f6a805c113d9bc43428f4b28a89

-- 
Jens Axboe

