Return-Path: <axboe@kernel.dk>
Message-ID: <536108BB.7030502@kernel.dk>
Date: Wed, 30 Apr 2014 08:29:15 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio headers as build dependency for external-ioengines
References: <1398849904-6013-1-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1398849904-6013-1-git-send-email-d.gollub@telekom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Daniel Gollub <d.gollub@telekom.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/30/2014 03:25 AM, Daniel Gollub wrote:
> Hi,
> 
> I am working right now in preparing for the Ceph project an external
> fio ioengine, which depends on Ceph-internal libraries. So I thought
> about building this ioengine as an external ioengine. (Thats why I
> send couple of weeks/month ago this C++-compiler-issues-fixes for
> fio.h)
> 
> Since fio is not (yet) distributed with a -dev/-devel package in
> linux distribution and was very likely not yet consider doing so
> I wanted to start the discussion here if this in interested of the
> project "exporting"/"installing" the required fio headers to build
> external ioengines. So fio can be later a "packaged" build-dependency.
> 
> For time-being I thought about solving this like this:
> 
> One can introduce in the external project's build-env a parameter
> like: --with-fio=~/projects/fio/ and the resulting build-env will
> pass this path as include directory as compiler flags for the
> external ioengine build.
> 
> Unfortunately there are some issues with double-declaration and
> one ambiguous header file name (e.g. time.h - see provided patch)
> 
> Double-declaration issues of defines/macros/... I hit while building
> the Ceph filestore external ioengine:
> 
>  * ARRAY_SIZE
>  * CONFIG_CPU_COUNT
>  * le16_to_cpu
>  * le32_to_cpu
>  * le64_to_cpu
> 
> 
> If you want to reproduce the described issue with ceph,
> checkout following revision:
> https://github.com/gollub/ceph/commit/079c08c67f811c0173e70201dc91168b60d2e86b
> ( Working branch: https://github.com/gollub/ceph/tree/fio_filestore_v2 )
> 
> And run:
> ./configure --with-fio-dir=/path/to/fio/
> cd src
> make libfio_ceph_filestore.la
> 
> 
> This could be solved/workaround on the external ioengine side, as well
> as in the fio header. One possibility on the fio side could be to relax
> fio.h header a bit, so only mandatory declarations and further
> includes are part of it to successfully build an external-ioengine.
> I am happy to help on this if fio decides to go this route.
> 
> Thoughts?

It'd be a useful thing to be able to do. I applied your time patch,
looks fine to me. Are you going to be able to work through the other
issues? I think we just need to privatize some of the names a bit more.

-- 
Jens Axboe


