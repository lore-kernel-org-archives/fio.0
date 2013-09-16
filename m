Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60213 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3IPVN7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 16 Sep 2013 17:13:59 -0400
Message-ID: <52377489.9060605@kernel.dk>
Date: Mon, 16 Sep 2013 15:13:45 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: output mutating on me
References: <CAAAK+WVk9ch4PNrfUb8LHwp800T-qTXbH7tr_Tj9GvZh8a0J1A@mail.gmail.com> <5237593A.8050301@kernel.dk> <E8B80854-5126-4A4C-92D7-26222827F9E6@gmail.com>
In-Reply-To: <E8B80854-5126-4A4C-92D7-26222827F9E6@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 09/16/2013 02:19 PM, Brian L. wrote:
> it's running normal directly on the machine.
> 
>  i thought maybe clat and lat might be the same as slat and that is why there is only slat being output but i  not sure. 

(please don't top post)

I need the full invocations of what you are running. If you are not
running async IO, then you only get lat. If you are running async IO,
you get slat and clat as well. I can't completely tell, since you didn't
not push what each of them ran exactly and the full output.

-- 
Jens Axboe

