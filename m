Return-Path: <axboe@kernel.dk>
Message-ID: <537A2545.80104@kernel.dk>
Date: Mon, 19 May 2014 09:37:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: A possible patch for a dangling pointer issue of librbd engine
References: <CA+8ZFnjK+68M1aSp4pFx=orD4fhM0D+Qi1QOjpQsDBwQvOhVSA@mail.gmail.com>
In-Reply-To: <CA+8ZFnjK+68M1aSp4pFx=orD4fhM0D+Qi1QOjpQsDBwQvOhVSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "xan.peng" <xanpeng@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, daniel.gollub@gmail.com
List-ID: <fio@vger.kernel.org>

On 05/18/2014 07:58 PM, xan.peng wrote:
> I'm interested in the librbd engine, and I possibly found a bug which
> you can see from the following patch.
> 
> And you can see more information at https://github.com/axboe/fio/pull/10.
> (BTW, are github pull requests the correct way to submit patches to fio?)

Sure, you can do that, but email me+list about them separately as I
might not see them on github. So I'm not going to pull your branch,
since you have two patches on top of the interesting one, where the 2nd
just reverts the other one. I'm apply this one separately.


-- 
Jens Axboe


