Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55024 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0D0Gy4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Apr 2010 02:54:56 -0400
Date: Tue, 27 Apr 2010 08:54:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Using offsets in fio
Message-ID: <20100427065454.GY27497@kernel.dk>
References: <4BD62D8A.5050109@auckland.ac.nz> <20100427064224.GX27497@kernel.dk> <k2v8baae1371004262349sb41985e9i73f4d3a2e42aca7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k2v8baae1371004262349sb41985e9i73f4d3a2e42aca7c@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: DongJin Lee <dongjin.lee@auckland.ac.nz>
Cc: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>, fio@vger.kernel.org

On Tue, Apr 27 2010, DongJin Lee wrote:
> So for example, you'd expect, for example,
> at the end of 1TB position (1073741824 bytes) the offset is to be 1073741824
> ?

1073741824 byte offset would be 1GB.

> and similarly for end of 2TB position, the offset would be the twice?

Yeah, there's no magic there, it's simply a byte offset where the IO
will take place.

-- 
Jens Axboe

