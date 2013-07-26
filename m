Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3GZPIH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Jul 2013 11:08:07 -0400
Message-ID: <51F290C0.6020404@kernel.dk>
Date: Fri, 26 Jul 2013 09:07:44 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Definition of IO depth distribution in the terse output
References: <CAOtMX2jEtNYwUct2VN6E2TBoDXXm7oJSXwzJiqKfXGzNvG3QLQ@mail.gmail.com> <20130726031034.GO29296@kernel.dk> <CAOtMX2g9=nmyify=YL+WjiB9rhLPqB5-5q4ARqY=-D_vK6Q9Kg@mail.gmail.com>
In-Reply-To: <CAOtMX2g9=nmyify=YL+WjiB9rhLPqB5-5q4ARqY=-D_vK6Q9Kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: asomers@gmail.com
Cc: fio@vger.kernel.org

On 07/26/2013 08:51 AM, asomers@gmail.com wrote:
> I still don't understand how there isn't a gap.  Are you saying that
> the buckets go like this:
> <=1, >=2, >=4, >=8, >=16, >=32, >=64 ?
> 
> Is the lowest bucket misnamed, or is there a gap between 1 and 2?

Bucket0		1
Bucket1		2..3
Bucket2		4..7
Bucket3		8..15
Bucket4		16..31
Bucket5		32..63
Bucket6		64..

-- 
Jens Axboe

