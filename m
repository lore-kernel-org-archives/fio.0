Return-Path: <axboe@kernel.dk>
Subject: Re: Is the libiscsi engine patch applied correctly?
References: <20190425155203.GA11294@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <035ceaed-70a7-da29-8677-f1669f7f09db@kernel.dk>
Date: Thu, 25 Apr 2019 10:10:40 -0600
MIME-Version: 1.0
In-Reply-To: <20190425155203.GA11294@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/25/19 9:52 AM, Richard W.M. Jones wrote:
> It seems like these two lines might be in the wrong order? (and the
> same thing later in the file too)
> 
> https://github.com/axboe/fio/blob/afc22c98609ee80a99fbed24231181bdab2bc659/optgroup.h#L65-L66

They are, that's a bug. Thanks for letting me know, I've fixed it up.

-- 
Jens Axboe


