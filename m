Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46824 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3A0Pjb (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 27 Jan 2013 10:39:31 -0500
Date: Sun, 27 Jan 2013 08:39:25 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: asking for an example job file
Message-ID: <20130127153925.GO15635@kernel.dk>
References: <CAJdxx76y1m6NG9_D86XXY4xz2mJc4guP1Qa_DCqNQNamNPxK7w@mail.gmail.com>
 <50F3CB5F.8070507@kernel.dk>
 <CAJdxx75-H7LOQ3Kf13U6h7TskpvCKuwL4pbkG16PzHinYwHRsw@mail.gmail.com>
 <CAJdxx77Yq=Df4eS-iQVfFNXzjBusF3zG+ZLhLnGQVuVHhdkA=g@mail.gmail.com>
 <CAJdxx74Tu3LHhJ9LUOTg=K3NfiwY6iD9mrDS=_3EXcqEKNaENg@mail.gmail.com>
 <CAN2qFaotYBVvJyvac0L8EUJAiJAbnYjFtmXgPNCe2ey6P_ZHFA@mail.gmail.com>
 <CAJdxx77U9ULtqV3sSGzwX0Pi7pZeyP1avuVzxkLm-pLhS1vncQ@mail.gmail.com>
 <CAHaS=QwrKy7ZmmzZ2UCEx1qUT8GNJ9u+TwTw2Pe4nU030gyOAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHaS=QwrKy7ZmmzZ2UCEx1qUT8GNJ9u+TwTw2Pe4nU030gyOAw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio <fio@vger.kernel.org>

On Thu, Jan 24 2013, Greg Sullivan wrote:
> (resending in plain text - sigh)
> 
> I tried to use the "rate" functionality on Windows some time ago, and
> it was extremely erratic. As I recall, the Windows maintainer couldn't
> reproduce the behaviour I was observing, and since the work I was
> doing was not critical, I gave up. (yes - I know - boo hiss! :) :)

It might have something to do with some of the timing functions on
Windows, which are way too coarse to be used for rate limiting. If you
have the job file that you used handy, I can try and take a look at it.

-- 
Jens Axboe

