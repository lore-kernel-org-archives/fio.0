Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20170831201308.47933-5-tkusumi@tuxera.com>
References: <20170831201308.47933-1-tkusumi@tuxera.com> <20170831201308.47933-5-tkusumi@tuxera.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 1 Sep 2017 05:52:11 +0100
Message-ID: <CALjAwxg4aQn=EbeB23Df2=srYOWhFEtKtuufy7qZZ9iirZWRHw@mail.gmail.com>
Subject: Re: [PATCH 4/5] fix load_ioengine() not to support no "external:" prefix
Content-Type: text/plain; charset="UTF-8"
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 31 August 2017 at 21:13,  <kusumi.tomohiro@gmail.com> wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>
> To load ioengines, it should be done by either
>  1) find the ioengine from the existing (static linked) ioengines or
>  2) dlopen the path in case of external ioengine,
>
> but not to do 2 if 1 failed, as fio doesn't expect an ioengine to be
> dynamically loaded unless with "external:" prefix by design.
>
> The current implementation (i.e. do 2 if 1 failed) happened to have
> been able to load an external ioengine with below syntax without
> "external:" prefix, but this is a bug rather than a feature.
>
> (--)ioengine=./engines/skeleton_external.so
>
> The design of the external ioengine option since below commits in 2007
>  7b395ca5('Prefix external io engine loading with 'external'')
>  8a7bd877('Document loading external io engines')
> is to use "external:/path/to/so" syntax.
>
> This commit fixes above bug, which also potentially avoids the case
> where "/path/to/so" within the given "external:/path/to/so" happens
> to match the existing name, though this is normally unlikely to happen.

People have already started depending on the "wrong" behaviour e.g.
ioengine=libfio_ceph_objectstore.so # must be found in your LD_LIBRARY_PATH
from https://github.com/ceph/ceph/blob/master/src/test/fio/ceph-bluestore.fio
. Because they're external it's hard to find out just how prevalent
this behaviour is.

-- 
Sitsofe | http://sucs.org/~sits/

