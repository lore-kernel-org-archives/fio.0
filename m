Return-Path: <axboe@kernel.dk>
Message-ID: <52FC465A.4060009@kernel.dk>
Date: Wed, 12 Feb 2014 21:13:14 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] engines/null: allow build as external C++ ioengine
References: <1392232426-16152-1-git-send-email-d.gollub@telekom.de> <1392232426-16152-2-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392232426-16152-2-git-send-email-d.gollub@telekom.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Daniel Gollub <daniel.gollub@t-online.de>, fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>
List-ID: <fio@vger.kernel.org>

On 2014-02-12 12:13, Daniel Gollub wrote:
> In first place to have a simple test candidate for external
> ioengines using get_ioengine() method for retriving the
> io_engine struct.
>
> Can be compiled with:
>
> g++ -O2 -g -shared -rdynamic -fPIC -o null.so null.c -DFIO_EXTERNAL_ENGINE

I'm assuming this is just an example of how you'd build your external 
engine? Look OK to me with that in mind.

-- 
Jens Axboe


