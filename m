Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 4/5] fix load_ioengine() not to support no "external:"
 prefix
References: <20170831201308.47933-1-tkusumi@tuxera.com>
 <20170831201308.47933-5-tkusumi@tuxera.com>
 <CALjAwxg4aQn=EbeB23Df2=srYOWhFEtKtuufy7qZZ9iirZWRHw@mail.gmail.com>
 <CAHndrBmTyx2sz5gwBefEU8FV5T0NfyKo-jhWm-b-xe+jRHFGeg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <937cb14c-7187-61d5-1fcb-fe1eb6086555@kernel.dk>
Date: Fri, 1 Sep 2017 08:43:53 -0600
MIME-Version: 1.0
In-Reply-To: <CAHndrBmTyx2sz5gwBefEU8FV5T0NfyKo-jhWm-b-xe+jRHFGeg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 08/31/2017 11:38 PM, Tomohiro Kusumi wrote:
> 2017-09-01 7:52 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>> On 31 August 2017 at 21:13,  <kusumi.tomohiro@gmail.com> wrote:
>>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>>
>>> To load ioengines, it should be done by either
>>>  1) find the ioengine from the existing (static linked) ioengines or
>>>  2) dlopen the path in case of external ioengine,
>>>
>>> but not to do 2 if 1 failed, as fio doesn't expect an ioengine to be
>>> dynamically loaded unless with "external:" prefix by design.
>>>
>>> The current implementation (i.e. do 2 if 1 failed) happened to have
>>> been able to load an external ioengine with below syntax without
>>> "external:" prefix, but this is a bug rather than a feature.
>>>
>>> (--)ioengine=./engines/skeleton_external.so
>>>
>>> The design of the external ioengine option since below commits in 2007
>>>  7b395ca5('Prefix external io engine loading with 'external'')
>>>  8a7bd877('Document loading external io engines')
>>> is to use "external:/path/to/so" syntax.
>>>
>>> This commit fixes above bug, which also potentially avoids the case
>>> where "/path/to/so" within the given "external:/path/to/so" happens
>>> to match the existing name, though this is normally unlikely to happen.
>>
>> People have already started depending on the "wrong" behaviour e.g.
>> ioengine=libfio_ceph_objectstore.so # must be found in your LD_LIBRARY_PATH
>> from https://github.com/ceph/ceph/blob/master/src/test/fio/ceph-bluestore.fio
>> . Because they're external it's hard to find out just how prevalent
>> this behaviour is.
> 
> Then they can add "external:".
> If it has ever been official (in docs/etc), then the program should
> maintain such behavior, like fio keeps kb_base=1024 by default.
> 
> This isn't the first time fio broke external ioengines to begin with,
> and fio doesn't guarantee external ioengines.
> e.g. this commit more than a year ago broke ABI.
> 565e784df05c2529479eed8a38701a33b01894bd
> 
> It's essentially the same as non mainline'd kernel modules are on
> their own to be uptodate with upstream.

No, those two are VERY different. Fio doesn't make any guarantees wrt
keeping the same ABI (or API, even) for external engines. If they break,
then you get to keep the pieces and glue them back together. We have
the engine version number as well to guard against those kinds of
changes.

But we don't break job files, at least not knowingly, and definitely
not just in the name of a cleanup.

-- 
Jens Axboe


