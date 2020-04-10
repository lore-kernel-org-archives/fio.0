Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
 <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk> <61e87991-3fdb-bed3-95b9-b730d7bfb222@gmail.com>
 <BY5PR04MB6900AFAF3F60C1092BB842B0E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <43ac3364-5d63-0a89-9830-efff18b9b4b0@gmail.com> <BY5PR04MB690053CDA9D7D4C86A05D8F5E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <341b4035-f524-0d18-79d7-c9eb055dff0f@gmail.com>
In-Reply-To: <341b4035-f524-0d18-79d7-c9eb055dff0f@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 10 Apr 2020 16:05:49 +0100
Message-ID: <CALjAwxg31_Xgnxm3S7R+Op_aWHuaHHvCDbxitc-XqJwYf_5kmg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Generalize zonemode=zbd
Content-Type: text/plain; charset="UTF-8"
To: Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Wed, 8 Apr 2020 at 22:59, Vincent Fu <vincentfu@gmail.com> wrote:
>
> For what it's worth, I have integrated AppVeyor and travis-ci with my
> own github account, allowing the two services to run through the
> build/test cycle on Linux, Windows, and macOS any time I push changes to
> my fork of fio.
>
> It's been a while since I set up the integration but it looks like the
> right places to look are here:
>
> https://github.com/marketplace/appveyor
> https://github.com/marketplace/travis-ci
>
> The main drawback of the two services is that they do not provide access
> to the test artifacts. So I maintain a small cluster of servers that
> does automated builds/testing for fio, although this is all going away
> when our lab is dismantled at the end of May.

Appveyor can be made to selectively package up chosen artifacts that
can be downloaded. See
https://github.com/axboe/fio/blob/3f2dcb7f855d43244ec178aa2a34bb1475bf6901/.appveyor.yml#L30
for an example and see
https://www.appveyor.com/docs/packaging-artifacts/ for the docs.

-- 
Sitsofe | http://sucs.org/~sits/

