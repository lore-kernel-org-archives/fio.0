Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200430124050.20146-1-adobriyan@gmail.com> <20200430124050.20146-6-adobriyan@gmail.com>
 <BY5PR04MB69006B1BE963DE08412F960FE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
In-Reply-To: <BY5PR04MB69006B1BE963DE08412F960FE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 1 May 2020 07:00:27 +0100
Message-ID: <CALjAwxgMJ6n43r2_6g3dQsGO7Zqvgfg23JP-NJjiOxDvXFN_mA@mail.gmail.com>
Subject: Re: [PATCH 6/7] fio: parse "io_size=1%"
Content-Type: text/plain; charset="UTF-8"
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, 1 May 2020 at 02:52, Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2020/04/30 21:41, Alexey Dobriyan wrote:
> > The following config:
> >
> >       zonemode=zbd
>
> I think you need to add the option field to struct thread_options_pack too,
> otherwise the client/server case will break/not handle the option as expected.

This may also necessitate an increase to FIO_SERVER_VER in server.h...

-- 
Sitsofe | http://sucs.org/~sits/

