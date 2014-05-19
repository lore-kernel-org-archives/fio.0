Return-Path: <xanpeng@gmail.com>
MIME-Version: 1.0
In-Reply-To: <537A2545.80104@kernel.dk>
References: <CA+8ZFnjK+68M1aSp4pFx=orD4fhM0D+Qi1QOjpQsDBwQvOhVSA@mail.gmail.com>
	<537A2545.80104@kernel.dk>
Date: Tue, 20 May 2014 00:38:08 +0800
Message-ID: <CA+8ZFnjhqs7Y8Ho6XjqrWXLebYKrn5jJeVdMnr+x4dc6xL1ReQ@mail.gmail.com>
Subject: Re: A possible patch for a dangling pointer issue of librbd engine
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, daniel.gollub@gmail.com
List-ID: <fio@vger.kernel.org>

On Mon, May 19, 2014 at 11:37 PM, Jens Axboe <axboe@kernel.dk> wrote:
> Sure, you can do that, but email me+list about them separately as I
> might not see them on github. So I'm not going to pull your branch,
> since you have two patches on top of the interesting one, where the 2nd
> just reverts the other one. I'm apply this one separately.

Got it.
p.s. I reverted the 2nd commit as it's of a different topic, and it
was automatically merged into the 1st by GitHub before I noticed.

