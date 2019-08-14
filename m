Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Subject: Re: [PATCH v3 7/7] Makefile: Add 'fulltest' target
References: <20190814201012.253060-1-bvanassche@acm.org>
 <20190814201012.253060-8-bvanassche@acm.org>
 <CALjAwxjQ_dukjjVH6qnrZTJL-jbcsx6FgbfENJxvdsCJk5fUag@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <01203a78-591d-6727-1bec-1fd6c8fb5208@acm.org>
Date: Wed, 14 Aug 2019 14:14:11 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxjQ_dukjjVH6qnrZTJL-jbcsx6FgbfENJxvdsCJk5fUag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/14/19 2:11 PM, Sitsofe Wheeler wrote:
> Looks good. We just need to switch
> https://github.com/axboe/fio/blob/master/.travis.yml over to run
> both...

Hi Sitsofe,

I'm not sure whether Travis supports kernel module loading. See also
https://github.com/travis-ci/travis-ci/issues/2291.

Bart.




