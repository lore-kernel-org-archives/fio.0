Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:37508 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754548Ab3JCUGA (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 3 Oct 2013 16:06:00 -0400
Message-ID: <524DCE29.3050808@nellans.org>
Date: Thu, 03 Oct 2013 15:06:01 -0500
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: precondition ssd drives w/ fio
References: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
In-Reply-To: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>



On 10/03/2013 02:31 PM, Brian L. wrote:
> For benchmarking SSD drives, I was told that we should precondition
> our drives to get more accurate real world reading.
>
> I was wondering if anyone is using fio itself to precondition ssd
> drives or use a different script to populate random data on the
> drives?
>
> Thanks in advance.
>
> Brian L.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


fio is flexible enough that it can precondition with just about any 
shape of traffic you're willing to craft a job for.  but what traffic
you believe is representative of your real world use case
is entirely up to you and can have dramatic affect on the garbage 
collection efficiency of the drive.

google "ssd preconditioning" and many of the flash manufacturers have
whitepapers on how/why you might choose to precondition your drives
before doing any benchmarking.
