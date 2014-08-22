Return-Path: <fio-owner@vger.kernel.org>
Received: from mailuogwdur.emc.com ([128.221.224.79]:11490 "EHLO
	mailuogwdur.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687AbaHVSW6 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 22 Aug 2014 14:22:58 -0400
Received: from maildlpprd55.lss.emc.com (maildlpprd55.lss.emc.com [10.106.48.159])
	by mailuogwprd54.lss.emc.com (Sentrion-MTA-4.3.0/Sentrion-MTA-4.3.0) with ESMTP id s7MHxNE9003684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Fri, 22 Aug 2014 13:59:23 -0400
Received: from mailusrhubprd54.lss.emc.com (mailusrhubprd54.lss.emc.com [10.106.48.19]) by maildlpprd55.lss.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Fri, 22 Aug 2014 13:59:05 -0400
Received: from mxhub22.corp.emc.com (mxhub22.corp.emc.com [128.222.70.134])
	by mailusrhubprd54.lss.emc.com (Sentrion-MTA-4.3.0/Sentrion-MTA-4.3.0) with ESMTP id s7MHx8C6032626
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Fri, 22 Aug 2014 13:59:08 -0400
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Fri, 22 Aug 2014 13:59:06 -0400
Subject: RE: buffer_pattern usage question
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C83252F803A1@MX44A.corp.emc.com>
References: <3DB5F5EE-7D4F-487B-B757-BAD37D041DEB@datrium.com>
 <53F760AB.9060908@kernel.dk>
In-Reply-To: <53F760AB.9060908@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Why the parameter buffer_pattern is absent in git HowTo?

KR

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Jens Axboe
Sent: Friday, August 22, 2014 6:24 PM
To: Surendar Chandra; fio@vger.kernel.org
Subject: Re: buffer_pattern usage question

On 2014-08-21 20:01, Surendar Chandra wrote:
> Could you please help me with this setup
>
>     filename=fio-data
>     size=4k
>     rw=write
>     buffer_pattern="HELLO"
>
> The output still continues to be pseudo random. I even tried buffer_pattern=0xDEADBEEF and other params.

It's not going to take a string, it needs to be a decimal of hexidecimal number. I added some code to error out if it fails parsing this now.

buffer_pattern=0xDEADBEEF should work, and does for me:

axboe@lenny:/home/axboe/git/fio $ hexdump fio-data
0000000 beef dead beef dead beef dead beef dead
*
0001000


--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
