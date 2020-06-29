Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v1 2/3] configure: new --dynamic-libengines build option
References: <cover.1592981060.git.ykorman@gmail.com>
 <9b74bba79ea8e70991754ac55dc4f65d44c6c347.1592981060.git.ykorman@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f79de251-712d-d26d-f2f2-112d2d55ea78@kernel.dk>
Date: Mon, 29 Jun 2020 15:07:56 -0600
MIME-Version: 1.0
In-Reply-To: <9b74bba79ea8e70991754ac55dc4f65d44c6c347.1592981060.git.ykorman@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Yigal Korman <ykorman@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 6/28/20 1:27 PM, Yigal Korman wrote:
> When enabled, some of the more dependency-heavy internal engines are
> converted to "plugin" engines, i.e. they are built into separate object
> files and are loaded by fio on demand.
> This helps downstream distros package these engines separately and not
> force a long list of package dependencies from the base fio package.

How does this impact the performance of the engine? It'd be interesting
to run a test with something ala:

fio --name=test --ioengine=null --size=100g --rw=randread --norandommap --gtod_reduce=1

with the current build, then apply these patches (and turn the null engine
into an externally loadable engine, of course), and re-run the test case.

For what it's worth, I like the change in general, as dependencies do
pile on. But I'd like to ensure that we're not taking a performance hit
for something like this.


-- 
Jens Axboe


