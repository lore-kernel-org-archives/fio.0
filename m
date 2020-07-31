Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
 <20200729210415.4166-2-dmitry.fomichev@wdc.com> <CY4PR04MB3751CCE0FB675C4906F9C414E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <MN2PR04MB59519F3A6FCC32DFCEC891B3E1710@MN2PR04MB5951.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB59519F3A6FCC32DFCEC891B3E1710@MN2PR04MB5951.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Jul 2020 06:54:21 +0100
Message-ID: <CALjAwxgRCsoKwhJhg8M1TO8Ga3Os+gQxSWAQQX=suvLvabsZCA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] configure: improve libzbc version check
Content-Type: text/plain; charset="UTF-8"
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On Fri, 31 Jul 2020 at 00:09, Dmitry Fomichev <Dmitry.Fomichev@wdc.com> wrote:
>
> Right now, there is no default for libzbc ioengine support. If libzbc is found by
> configure, then libzbc ioengine will always be added. The new flag, --disable-libzbc,
> prevents adding support for libzbc ioengine in this case. If libzbc is not present,
> fio configure is not failed with "feature not found".
>
> Currently, no other feature in fio configure has the default option of "yes" and all
> features that can be explicitly set to yes are set so by script command line options.
> If a feature is set to yes and is not available, configure fails with "feature not found"
> error. Do we really want configure to fail on any system that doesn't have libzbc
> unless --disable-libzbc is added to the command line?
>
> There is one feature option, "disable_lex",  with the default value, "". I guess we
> could define libzbc option the same way to improve code clarity.

That's right:
- "yes": hard fail if probe fails
- "": probe but don't hard fail
- "no": don't probe and disable feature

So your suggestion of a default of "" is right because I can't believe
we want to hard fail when libzbc is unavailable.

I learned of this pattern while reading
https://github.com/qemu/qemu/blob/1448629751871c4924c234c2faaa968fc26890e1/configure#L348
which I think was the basis of fio's configure script. The desire to
show this pattern led to some of the refactoring in
https://github.com/axboe/fio/commit/d490af7f8c0ee7a992f332bb6bcffb30313d6488
even though it added some unncessary lines for those options...

-- 
Sitsofe | http://sucs.org/~sits/

