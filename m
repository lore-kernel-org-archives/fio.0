Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/4] fio: option to make engines load dynamically
References: <cover.1593761533.git.ykorman@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <06091bf8-a6c0-345c-690b-e45289f59f86@kernel.dk>
Date: Fri, 3 Jul 2020 08:35:12 -0600
MIME-Version: 1.0
In-Reply-To: <cover.1593761533.git.ykorman@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Yigal Korman <ykorman@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 7/3/20 6:38 AM, Yigal Korman wrote:
> The following patchset provides a configuration option that converts a
> select set of engines into external engines that are loaded dynamically
> on demand.  The purpose of this option is to provide distribution
> packagers the ability to separate the core fio functionality from the
> additional optional engines.  Some of the optional engines have multiple
> dependencies that increase the footprint of fio considerably even when
> the user requires only the basic 'sync' engine.
> 
> For example, without the patchset, on a Fedora 31 system, installing fio
> brings a total of 38 package dependencies, the installed size is 57MB.
> With the patchset, installing fio brings a single dependency
> (numactl-libs) and the installed size is 2.1MB.
> 
> These numbers are relatively small but when one needs to bring fio to
> an offline server, collecting these dependencies is a hassle.
> Also, bundling fio into a container where the base image is small
> (Fedora 31 is ~200MB), the install size becomes more prominent.
> 
> I've tried to keep the changes as small and unobtrusive as possible.
> The only significant change is the way an engine is defined in the
> Makefile (variables are now prefixed with engine name).  If the option
> is provided, the Makefile will build the engines as external libraries
> and install them in /usr/lib/fio by default.  Fio will then search for
> the engines in that location if the engine is not compiled in.  The last
> patch should help with the migration to the new scheme by suggesting
> that an additional package is required if the engine is not found.
> 
> Future work to consider:
> * Move the engine help text from fio to the engines themselves.  Create
> * a whitelist of engines so that only engines that are part of the main
> * codebase are searched and loaded automatically.  Convert more engines
> * to this scheme. The current set of engines was selected based on
> * simplicity and external dependencies. Engines with multiple exported
> * flavors (i.e. glusterfs) are not converted yet.

Looks good to me, I've applied it. Thanks!

-- 
Jens Axboe


